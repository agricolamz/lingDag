library(shiny)
library(shinyWidgets)
library(leaflet)
library(lingtypology)

villages <- readRDS("villages.rds")

villages$lang <- factor(villages$lang, levels =c(
    "Dargwa", "Lak", "Tsova-Tush", "Ingush", "Chechen", "Khinalug", "Archi", "Tsakhur", "Rutul", "Kryz", "Budukh", "Udi", "Lezgian", "Agul", "Tabasaran", "Avar", "Andi", "Botlikh", "Godoberi", "Chamalal", "Bagvalal", "Tindi", "Karata", "Akhvakh", "Tsez", "Hinuq", "Bezhta", "Hunzib", "Khwarshi", "Nogai", "Kumyk", "Azerbaijani", "Armenian", "Tat", "Georgian"))
villages$aff <- factor(villages$aff, levels =c("Dargwa", "Lak", "Nakh", "Khinalug", "Lezgic", "Avar", "Andic", "Tsezic", "Kipchak", "Oghuz", "Armenic", "Iranian", "Georgic"))

ui <- fluidPage(
    titlePanel("Draw an East Caucasian map with lingtypology [Moroz 2017]"),
    column(3, wellPanel(
        submitButton("redraw"),
        pickerInput(
            inputId = "LANGS",
            label = "select languages", 
            choices = levels(villages$lang),
            selected = levels(villages$lang),
            options = list(
                `actions-box` = TRUE), 
            multiple = TRUE
        ),
        pickerInput(
            inputId = "REGIONS",
            label = "select regions", 
            choices = unique(villages$republic),
            selected = unique(villages$republic),
            options = list(
                `actions-box` = TRUE), 
            multiple = TRUE
        ),
        pickerInput(
            inputId = "BRANCH",
            label = "select branch", 
            choices = levels(villages$aff),
            selected = levels(villages$aff),
            options = list(
                `actions-box` = TRUE), 
            multiple = TRUE
        ),
        sliderInput("DOT_SIZE", "size of the dot", min=1, max=10, value=3),
        prettySwitch("KUTANS", "kutans", FALSE),
        prettySwitch("COLOR", "color by language", TRUE), 
        selectInput("TILE", 
                    label = "choose a tile:", 
                    choices = c("OpenStreetMap.Mapnik", "Stamen.Terrain", "Stamen.TonerLite"),
                    selected = "OpenStreetMap.Mapnik"),
        prettySwitch("MINIMAP", "minimap", FALSE), 
        sliderInput("MINIMAP_H", "minimap height", min=100, max=400, value=150),
        sliderInput("MINIMAP_W", "minimap width", min=100, max=400, value=150))),
    column(6, leafletOutput("MYMAP", height = 600, width = 800))
)

server <- function(input, output, session) {
    output$MYMAP <- renderLeaflet({
        if(!input$KUTANS){
            villages %>% 
                filter(!kutans) ->
                villages    
        }
        
        villages %>% 
            filter(lang %in% input$LANGS,
                   republic %in% input$REGIONS,
                   aff %in% input$BRANCH) ->
            villages
        
        if(input$COLOR){
            villages$features <- villages$lang
            villages$colors <- villages$lang_color
        } else{
            villages$features <- villages$aff
            villages$colors <- villages$aff_color
        }

        map.feature(language = villages$lang2, 
                    features = villages$features, 
                    latitude = villages$lat,
                    longitude = villages$lon,
                    label = villages$village,
                    color = villages$colors,
                    width = input$DOT_SIZE,
                    tile = input$TILE,
                    minimap = input$MINIMAP, 
                    minimap.position = "bottomleft",
                    minimap.width = input$MINIMAP_W,
                    minimap.height = input$MINIMAP_H)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)