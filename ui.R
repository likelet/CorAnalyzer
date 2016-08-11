library(shiny)
library(shinysky)

shinyUI(pageWithSidebar(
  headerPanel("CorAnalyzer"),
  
  sidebarPanel(
    #gsub("label class=\"radio\"", "label class=\"radio inline\"",)
    conditionalPanel(condition = "input.conditionedPanels == 'InputData'",
                     wellPanel(
                       radioButtons(
                         "dataset",
                         strong("Dataset"),
                         c(Example = "example", Upload = "upload"),
                         selected = 'example'
                       ),
                       conditionalPanel(
                         condition = "input.dataset == 'upload'",
                         fileInput(
                           'file1',
                           'Choose CSV/text ',
                           accept = c('text/csv', 'text/comma-separated-values,text/plain', '.csv')
                         ),
                         shinyalert("shinyalert1"),
                         wellPanel(
                           checkboxInput('header', 'Header', TRUE),
                           radioButtons('sep', 'Separator',
                                        c(
                                          Comma = ',',
                                          Semicolon = ';',
                                          Tab = '\t'
                                        ),
                                        '                     \t'),
                           radioButtons(
                             'quote',
                             'Quote',
                             c(
                               None = '',
                               'Double Quote' = '"',
                               'Single Quote' = "'"
                             ),
                             ''
                           )
                         )
                       )
                     )),
    conditionalPanel(condition = "input.conditionedPanels == 'Scatter plot'",
                     #gsub("label class=\"radio\"", "label class=\"radio inline\"",radioButtons("overlapnumber", h6("Get over lap of your data list"), c(twoList = 2, threeList = 3,fourList=4,fiveList = 5),selected = 5)),
                     uiOutput("analysisUI")),
    conditionalPanel(
      condition = "input.conditionedPanels == 'CorrelationHeatmap'",
      selectInput(
        "HeatmapColor",
        strong("Select Heatmap Color"),
        c(
          "BuYlRd",
          "RdYlBu",
          "Blues",
          "BuGn",
          "BuPu",
          "GnBu",
          "Greens",
          "Greys",
          "Oranges",
          "OrRd",
          "PuBu",
          "PuBuGn",
          "PuRd",
          "Purples",
          "RdPu",
          "Reds",
          "YlGn",
          "YlGnBu",
          "YlOrBr",
          "YlOrRd",
          "SelfDefine"
        )
      ),
      conditionalPanel(
        condition = "input.HeatmapColor == 'SelfDefine'",
        #jscolorInput("mincolor"),
        wellPanel(
          selectInput(
            "mincolor",
            "Min Color",
            choices = c(
              "black",
              "red",
              "green",
              "blue",
              "yellow",
              "orange",
              "purple",
              "brown",
              "grey",
              "cyan",
              "tomato",
              "white"
            ),
            selected = "green"
          ),
          #jscolorInput("midcolor"),
          selectInput(
            "midcolor",
            "Middle Color",
            choices = c(
              "black",
              "red",
              "green",
              "blue",
              "yellow",
              "orange",
              "purple",
              "brown",
              "grey",
              "cyan",
              "tomato",
              "white"
            ),
            selected = "white"
          ),
          #jscolorInput("maxcolor")
          selectInput(
            "maxcolor",
            "Max Color",
            choices = c(
              "black",
              "red",
              "green",
              "blue",
              "yellow",
              "orange",
              "purple",
              "brown",
              "grey",
              "cyan",
              "tomato",
              "white"
            ),
            selected = "red"
          )
        )
      ),
      selectInput(
        "cluster",
        strong("Cluster option"),
        choice = c("All", Row = "A", Column = "B", "none")
      ),
      selectInput(
        "border",
        strong("Border option"),
        choice = c(
          default = "grey60",
          white = "white",
          NoBorder = NA
        ),
        selected = "grey60"
      ),
      textInput("plottittle", strong("Plot tittle"), value = "Heatmap for correlation matrix"),
      selectInput(
        "scaleoption",
        strong("Scale"),
        choice = c("row", "column", "none"),
        selected = "row"
      ),
      wellPanel(
        h4("Cell Size"),
        sliderInput(
          "cellheight",
          "Cell Height",
          value = 20,
          min = 1,
          max = 100,
          step = 1
        ),
        sliderInput(
          "cellwidth",
          "Cell Width",
          value = 20,
          min = 1,
          max = 100,
          step = 1
        )
      ),
      wellPanel(
        h4("Font Size"),
        sliderInput(
          "mainsize",
          "Title  size",
          value = 15,
          min = 1,
          max = 100,
          step = 1
        ),
        sliderInput(
          "fontsizerow",
          "Rownames  size",
          value = 20,
          min = 1,
          max = 100,
          step = 1
        ),
        sliderInput(
          "fontsizecol",
          "Colnames  size",
          value = 20,
          min = 1,
          max = 100,
          step = 1
        )
      ),
      checkboxInput("displaycolorkey", strong("Display Colorkey"), TRUE),
      checkboxInput("displaynumbers", strong("Display numbers"), FALSE)
    ),
    #Size option
    wellPanel(selectInput(
        "iscolumn",
        "Calculating cor by rows or columns",
        c("By Col" = TRUE,
          "By Row" = FALSE),
        selected = TRUE
      ),
      selectInput(
        "use",
        "Specifies the handling of missing data",
        c(
          "All.obs" = "all.obs",
          "Complete.obs" = "complete.obs",
          "Pairwise.complete.obs" = "pairwise.complete.obs"
        ),
        selected = "all.obs"
      ),
      selectInput(
        "method",
        "Specifies the type of correlation",
        c(
          "Pearson" = "pearson",
          "Spearman " = "spearman",
          "Kendall" = "kendall"
        ),
        selected = "spearman"
      ),
      
      p(
        "This application was created by ",
        strong("Qi Zhao"),
        " from Ren's lab in SYSU."
      ),
      checkboxInput(
        'plotoption',
        span('Plot Option for matrix plot', style = "color:red"),
        FALSE
      ),
      
      conditionalPanel(
        condition = "input.plotoption == true",
        #Plot option
        wellPanel(
          selectInput(
            "lowerpanel",
            "Lower Panel",
            c(
              "pie" = "panel.pie",
              "Shade " = "panel.shade",
              "Ellipse" = "panel.ellipse",
              "Scatterplot" = "panel.pts",
              "none" = NULL
            ),
            selected = "panel.shade"
          ),
          selectInput(
            "upperpanel",
            "Upper Panel",
            c(
              "pie" = "panel.pie",
              "Shade " = "panel.shade",
              "Ellipse" = "panel.ellipse",
              "Scatterplot" = "panel.pts",
              "none" = NULL
            ),
            selected = "panel.pie"
          ),
          selectInput(
            "textpanel",
            "Text Panel",
            c(
              "Min-Max" = "panel.minmax",
              "Txt " = "panel.txt",
              "none" = NULL
            ),
            selected = "panel.txt"
          ),
          selectInput(
            "diagpanel",
            "Diag Panel",
            c(
              "Min-Max" = "panel.minmax",
              "Txt " = "panel.txt",
              "none" = NULL
            ),
            selected = NULL
          )
        )
      )
    )
  ),
  mainPanel(
    #verbatimTextOutput("test"),
    tabsetPanel(
      tabPanel("InputData", dataTableOutput("summary")),
      tabPanel(
        "Correlation Matrix",
        wellPanel(downloadButton('downloadmatrix', 'Download corMatrix')),
        dataTableOutput("corMatrix")
      ),
      tabPanel(
        "Correlation Test",
        shinyalert("shinyalert7"),
        dataTableOutput("corPvalue")
      ),
      tabPanel(
        "Scatter plot",
        h4("Fecth plot"),
        wellPanel(
          downloadButton('downloadDataPNG', 'Download PNG-file'),
          downloadButton('downloadDataPDF', 'Download PDF-file'),
          downloadButton('downloadDataEPS', 'Download EPS-file')
        ),
        plotOutput("scatterplot")
      ),
      tabPanel(
        "CorrelationHeatmap",
        h4("Fecth plot"),
        wellPanel(
          downloadButton('downloadDataHeatPNG', 'Download PNG-file'),
          downloadButton('downloadDataheatPDF', 'Download PDF-file'),
          downloadButton('downloadDataheatEPS', 'Download EPS-file')
        ),
        plotOutput("heatmapplot")
      ),
      tabPanel(
        "Matrix plot",
        shinyalert("shinyalert6"),
        plotOutput("plot", height = 800, width = "auto")
      )
      ,
      id = "conditionedPanels"
    )
  )
))
