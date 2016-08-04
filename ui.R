library(shiny)
library(shinysky)

shinyUI(pageWithSidebar(
    headerPanel("Correlation analysis Online"),
    sidebarPanel(
     #gsub("label class=\"radio\"", "label class=\"radio inline\"",)
      wellPanel(radioButtons("dataset", strong("Dataset"), c(Example = "example", Upload = "upload"),selected = 'example'),

       conditionalPanel(
         condition = "input.dataset == 'upload'",
         fileInput('file1', 'Choose CSV/text ',
                 accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
         shinyalert("shinyalert1"),
         wellPanel(
                   checkboxInput('header', 'Header', TRUE),
                   radioButtons('sep', 'Separator',
                                       c(Comma=',',
                                       Semicolon=';',
                                       Tab='\t'),
                 '                     \t'),
                  radioButtons('quote', 'Quote',
                                         c(None='',
                                          'Double Quote'='"',
                                          'Single Quote'="'"),
                                          '')
                   )
       )
       ),
       checkboxInput('advance', span('Advanced Option', style = "color:blue"), FALSE),
       
       conditionalPanel(
       condition = "input.advance == true",
      #Size option 
         wellPanel(
           selectInput("iscolumn", "Calculating cor by rows or columns",
                    c("By Col" = TRUE,
                      "By Row" = FALSE),selected= TRUE),
           selectInput("use", "Specifies the handling of missing data",
                    c("All.obs" = "all.obs",
                      "Complete.obs" = "complete.obs",
                      "Pairwise.complete.obs" = "pairwise.complete.obs"),selected="all.obs"),
           selectInput("method", "Specifies the type of correlation",
                    c("Pearson" = "pearson",
                      "Spearman " = "spearman",
                      "Kendall" = "kendall"),selected="spearman"),
           checkboxInput('plotoption', span('Plot Option', style = "color:red"), FALSE),
           
           conditionalPanel(
             condition = "input.plotoption == true",
             #Plot option 
             wellPanel(
               selectInput("lowerpanel", "Lower Panel",
                           c("pie" = "panel.pie",
                             "Shade " = "panel.shade",
                             "Ellipse" = "panel.ellipse",
                             "Scatterplot" = "panel.pts",
                             "none" = NULL),selected="panel.shade"),
               selectInput("upperpanel", "Upper Panel",
                           c("pie" = "panel.pie",
                             "Shade " = "panel.shade",
                             "Ellipse" = "panel.ellipse",
                             "Scatterplot" = "panel.pts",
                             "none" = NULL),selected="panel.pie"),
               selectInput("textpanel", "Text Panel",
                           c("Min-Max" = "panel.minmax",
                             "Txt " = "panel.txt",
                             "none" = NULL),selected="panel.txt"),
               selectInput("diagpanel", "Diag Panel",
                           c("Min-Max" = "panel.minmax",
                             "Txt " = "panel.txt",
                             "none" = NULL),selected=NULL)
             )
           )
       )
      ),
       p("This application was created by ",strong("Qi Zhao")," from Ren's lab in SYSU.")
     ),
     mainPanel(
     #verbatimTextOutput("test"),  
       tabsetPanel( 
                    tabPanel("Input Data",dataTableOutput("summary")),                     
                    tabPanel("Correlation Matrix",
                       wellPanel(   
                                  downloadButton('downloadmatrix', 'Download corMatrix')
                       ),dataTableOutput("corMatrix")           
                    ),
                    tabPanel("Correlation Test",shinyalert("shinyalert7"),dataTableOutput("corPvalue")),
                    tabPanel("Plot",shinyalert("shinyalert6"),plotOutput("plot",height=800,width="auto"))
        )
      )
    ))
