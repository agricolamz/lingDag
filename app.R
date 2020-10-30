library(shiny)
library(shinyWidgets)
library(colourpicker)
library(tidyverse)
library(leaflet)
library(lingtypology)

villages <- readRDS("villages.rds")

villages$lang <- factor(villages$lang, levels =c(
    "Dargwa", "Lak", "Tsova-Tush", "Ingush", "Chechen", "Khinalug", "Archi", "Tsakhur", "Rutul", "Kryz", "Budukh", "Udi", "Lezgian", "Agul", "Tabasaran", "Avar", "Andi", "Botlikh", "Godoberi", "Chamalal", "Bagvalal", "Tindi", "Karata", "Akhvakh", "Tsez", "Hinuq", "Bezhta", "Hunzib", "Khwarshi", "Nogai", "Kumyk", "Azerbaijani", "Armenian", "Tat", "Georgian"))
villages$aff <- factor(villages$aff, levels =c("Dargwa", "Lak", "Nakh", "Khinalug", "Lezgic", "Avar", "Andic", "Tsezic", "Kipchak", "Oghuz", "Armenic", "Iranian", "Georgic"))

ui <- fluidPage(
    titlePanel("Draw an East Caucasian map with lingtypology [Moroz 2017]"),
    navbarPage("",
    tabPanel("main window",
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
),
tabPanel("choose language color",
         colourInput("col_Dargwa", "Select colour for Dargwa", "#ff9900"),
         colourInput("col_Lak", "Select colour for Lak", "#cc9900"),
         colourInput("col_Tsova_Tush", "Select colour for Tsova-Tush", "#996633"),
         colourInput("col_Ingush", "Select colour for Ingush", "#663300"),
         colourInput("col_Chechen", "Select colour for Chechen", "#996600"),
         colourInput("col_Khinalug", "Select colour for Khinalug", "#cccc00"),
         colourInput("col_Archi", "Select colour for Archi", "#99cc00"),
         colourInput("col_Tsakhur", "Select colour for Tsakhur", "#669900"),
         colourInput("col_Rutul", "Select colour for Rutul", "#009900"),
         colourInput("col_Kryz", "Select colour for Kryz", "#009933"),
         colourInput("col_Budukh", "Select colour for Budukh", "#006600"),
         colourInput("col_Udi", "Select colour for Udi", "#004d00"),
         colourInput("col_Lezgian", "Select colour for Lezgian", "#00cc00"),
         colourInput("col_Agul", "Select colour for Agul", "#00cc66"),
         colourInput("col_Tabasaran", "Select colour for Tabasaran", "#339966"),
         colourInput("col_Avar", "Select colour for Avar", "#009999"),
         colourInput("col_Andi", "Select colour for Andi", "#003366"),
         colourInput("col_Botlikh", "Select colour for Botlikh", "#336699"),
         colourInput("col_Godoberi", "Select colour for Godoberi", "#003399"),
         colourInput("col_Chamalal", "Select colour for Chamalal", "#000099"),
         colourInput("col_Bagvalal", "Select colour for Bagvalal", "#000066"),
         colourInput("col_Tindi", "Select colour for Tindi", "#333399"),
         colourInput("col_Karata", "Select colour for Karata", "#666699"),
         colourInput("col_Akhvakh", "Select colour for Akhvakh", "#9900ff"),
         colourInput("col_Tsez", "Select colour for Tsez", "#990033"),
         colourInput("col_Hinuq", "Select colour for Hinuq", "#cc0000"),
         colourInput("col_Bezhta", "Select colour for Bezhta", "#ff5050"),
         colourInput("col_Hunzib", "Select colour for Hunzib", "#ff0066"),
         colourInput("col_Khwarshi", "Select colour for Khwarshi", "#993333"),
         colourInput("col_Nogai", "Select colour for Nogai", "#666666"),
         colourInput("col_Kumyk", "Select colour for Kumyk", "#a6a6a6"),
         colourInput("col_Azerbaijani", "Select colour for Azerbaijani", "#cccccc"),
         colourInput("col_Armenian", "Select colour for Armenian", "#dbcfeb"),
         colourInput("col_Tat", "Select colour for Tat", "#d5daff"),
         colourInput("col_Georgian", "Select colour for Georgian", "#fff5ee")),
tabPanel("choose branch color",
         colourInput("col_Dargwa2", "Select colour for Dargwa", "#ff9900"),
         colourInput("col_Lak2", "Select colour for Lak", "#cc9900"),
         colourInput("col_Nakh", "Select colour for Nakh", "#996633"),
         colourInput("col_Khinalug2", "Select colour for Khinalug", "#cccc00"),
         colourInput("col_Lezgic", "Select colour for Lezgic", "#00cc66"),
         colourInput("col_Avar2", "Select colour for Avar", "#009999"),
         colourInput("col_Andic", "Select colour for Andic", "#9900ff"),
         colourInput("col_Tsezic", "Select colour for Tsezic", "#ff5050"),
         colourInput("col_Kipchak", "Select colour for Kipchak", "#666666"),
         colourInput("col_Oghuz", "Select colour for Oghuz", "#cccccc"),
         colourInput("col_Armenic", "Select colour for Armenic", "#fff5ee"),
         colourInput("col_Iranian", "Select colour for Iranian", "#fffded"),
         colourInput("col_Georgic", "Select colour for Georgic", "black"))))

server <- function(input, output, session) {
    output$MYMAP <- renderLeaflet({
        
        villages[villages$lang == "Dargwa", "lang_color"] <- input$col_Dargwa
        villages[villages$lang == "Lak", "lang_color"] <- input$col_Lak
        villages[villages$lang == "Tsova-Tush", "lang_color"] <- input$col_Tsova_Tush
        villages[villages$lang == "Ingush", "lang_color"] <- input$col_Ingush
        villages[villages$lang == "Chechen", "lang_color"] <- input$col_Chechen
        villages[villages$lang == "Khinalug", "lang_color"] <- input$col_Khinalug
        villages[villages$lang == "Archi", "lang_color"] <- input$col_Archi
        villages[villages$lang == "Tsakhur", "lang_color"] <- input$col_Tsakhur
        villages[villages$lang == "Rutul", "lang_color"] <- input$col_Rutul
        villages[villages$lang == "Kryz", "lang_color"] <- input$col_Kryz
        villages[villages$lang == "Budukh", "lang_color"] <- input$col_Budukh
        villages[villages$lang == "Udi", "lang_color"] <- input$col_Udi
        villages[villages$lang == "Lezgian", "lang_color"] <- input$col_Lezgian
        villages[villages$lang == "Agul", "lang_color"] <- input$col_Agul
        villages[villages$lang == "Tabasaran", "lang_color"] <- input$col_Tabasaran
        villages[villages$lang == "Avar", "lang_color"] <- input$col_Avar
        villages[villages$lang == "Andi", "lang_color"] <- input$col_Andi
        villages[villages$lang == "Botlikh", "lang_color"] <- input$col_Botlikh
        villages[villages$lang == "Godoberi", "lang_color"] <- input$col_Godoberi
        villages[villages$lang == "Chamalal", "lang_color"] <- input$col_Chamalal
        villages[villages$lang == "Bagvalal", "lang_color"] <- input$col_Bagvalal
        villages[villages$lang == "Tindi", "lang_color"] <- input$col_Tindi
        villages[villages$lang == "Karata", "lang_color"] <- input$col_Karata
        villages[villages$lang == "Akhvakh", "lang_color"] <- input$col_Akhvakh
        villages[villages$lang == "Tsez", "lang_color"] <- input$col_Tsez
        villages[villages$lang == "Hinuq", "lang_color"] <- input$col_Hinuq
        villages[villages$lang == "Bezhta", "lang_color"] <- input$col_Bezhta
        villages[villages$lang == "Hunzib", "lang_color"] <- input$col_Hunzib
        villages[villages$lang == "Khwarshi", "lang_color"] <- input$col_Khwarshi
        villages[villages$lang == "Nogai", "lang_color"] <- input$col_Nogai
        villages[villages$lang == "Kumyk", "lang_color"] <- input$col_Kumyk
        villages[villages$lang == "Azerbaijani", "lang_color"] <- input$col_Azerbaijani
        villages[villages$lang == "Armenian", "lang_color"] <- input$col_Armenian
        villages[villages$lang == "Tat", "lang_color"] <- input$col_Tat
        villages[villages$lang == "Georgian", "lang_color"] <- input$col_Georgian
        
        villages[villages$aff == "Dargwa", "aff_color"] <- input$col_Dargwa2
        villages[villages$aff == "Lak", "aff_color"] <- input$col_Lak2
        villages[villages$aff == "Nakh", "aff_color"] <- input$col_Nakh
        villages[villages$aff == "Khinalug", "aff_color"] <- input$col_Khinalug2
        villages[villages$aff == "Lezgic", "aff_color"] <- input$col_Lezgic
        villages[villages$aff == "Avar", "aff_color"] <- input$col_Avar2
        villages[villages$aff == "Andic", "aff_color"] <- input$col_Andic
        villages[villages$aff == "Tsezic", "aff_color"] <- input$col_Tsezic
        villages[villages$aff == "Kipchak", "aff_color"] <- input$col_Kipchak
        villages[villages$aff == "Oghuz", "aff_color"] <- input$col_Oghuz
        villages[villages$aff == "Armenic", "aff_color"] <- input$col_Armenic
        villages[villages$aff == "Iranian", "aff_color"] <- input$col_Iranian
        villages[villages$aff == "Georgic", "aff_color"] <- input$col_Georgic
        
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
