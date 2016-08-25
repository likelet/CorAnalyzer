library(shiny)
library(ggplot2)
library(Hmisc)
library(corrgram)
library(pheatmap)
library(RColorBrewer)

source("PlotCorrelation.R")

options(shiny.maxRequestSize=100*1024^2) # max file size is 100Mb


shinyServer(function(input,output,session){

datasetInput <- reactive({ 
                            
  
example<-read.table("test.txt",header=T,sep="\t",row.names=1,stringsAsFactors=F)
 	inFile <- input$file1
  if (!is.null(inFile)){			
   data<-read.table(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote,stringsAsFactors=F,row.names=1) 
  }
 switch(input$dataset,
          "example" = example,
          "upload" = data
          )	
	})
 # reactive the samplename input by user



 # output upload dataset or example dataset  
output$summary <- renderDataTable({
  
  data<-datasetInput()
  if(input$iscolumn == FALSE){
    data<-t(data)  
  }
  
  data
  })

#rChart output
#output$chartTable <- renderChart2({
#dTable(datasetInput(), sPaginationType = input$pagination)
#})

 
 #calculating correlation of matrix
 getcorMatrix<-function(){
   data<-datasetInput()
   if(input$iscolumn == FALSE){
     data<-t(data)  
   }
   cormatrix<-cor(data, use=input$use, method=input$method) 
   return(cormatrix)
 }


#do significant test of cor
getcorTest<-function(){
  data<-datasetInput()
  
  if(input$iscolumn == FALSE){
    data<-t(data)  
  }
  
  matrix<-as.matrix(data)
  
  result<-rcorr(matrix,type=input$method)
  return(result)
}

#cormatrix output
output$corMatrix <- renderDataTable({
  result<-getcorMatrix()
  result<-cbind(row.names(result),result)
  result
})

output$corPvalue <- renderDataTable({
  result<-getcorTest()
  a<-result[[3]]
  a<-cbind(row.names(a),a)
  a
})



output$downloadmatrix <- downloadHandler(
    filename = function() {
      paste("output", Sys.time(), '.txt', sep='')
    },
     
    content = function(file) {
      write.table(getcorMatrix(),file)
    }
  )
 
#cor matrix plot 
output$plot <- renderPlot({
  data<-datasetInput()
  
  if(input$iscolumn == FALSE){
    data<-t(data)  
  }
  
  p<-corrgram(data, order=NULL, lower.panel=input$lowerpanel,
           upper.panel=input$upperpanel, diag.panel=input$diagpanel,
           main="correlation Plot (unsorted)")
  print(p)
}) 

#scater plot 
scatterplotfunction=reactive({
  data<-datasetInput()
  name1=input$select1
  name2=input$select2
  p=correlationScatterPlot(data,name1,name2,input$method)
  return(p)
})
output$scatterplot <- renderPlot({
  
  print(scatterplotfunction())
},height=800,width=800)

 
#dynamic UI for scatter plot 
output$analysisUI <- renderUI({
  df=datasetInput()
  tagList(
  selectInput("select1","Column 1",choices = names(df),selected = names(df)[1]),
  selectInput("select2","Column 2",choices = names(df),selected = names(df)[2])
  )
})

## download function for scatter plot 

output$downloadDataPNG <- downloadHandler(
  filename = function() {
    paste("output", Sys.time(), '.png', sep='')
  },
  
  content = function(file) {
    #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
    png(file=file)
    print(scatterplotfunction())
    dev.off()
  },
  contentType = 'image/png'
)


output$downloadDataPDF <- downloadHandler(
  filename = function() {
    paste("output", Sys.time(), '.pdf', sep='')
  },
  
  content = function(file) {
    pdf(file)
    print(scatterplotfunction())
    dev.off()
  },
  contentType = 'image/pdf'
)

output$downloadDataEPS <- downloadHandler(
  filename = function() {
    paste("output", Sys.time(), '.eps', sep='')
  },
  
  content = function(file) {
    postscript(file,fonts=c("serif", "Palatino","Times"))
    print(scatterplotfunction())
    dev.off()
  },
  contentType = 'image/eps'
)


##########################
####heat Map function
##########################

colorInput<-reactive({
  
  if(input$HeatmapColor=="SelfDefine"){
    
    color = colorRampPalette(c(input$mincolor, input$midcolor, input$maxcolor))(100)
    
  }else if(input$HeatmapColor=="BuYlRd"){
    color=colorRampPalette(rev(brewer.pal(n = 9, name = "RdYlBu")))(100)
  }else{
    color=colorRampPalette(brewer.pal(9, input$HeatmapColor))(100)
  }
  color
})

#heatmap function
Corheatmap<-function(){
  data<-getcorMatrix()
  test<-data.matrix(data)
  if(input$cluster=="All"){
    crows = TRUE
    c_cols = TRUE
  }else if(input$cluster=="A"){
    crows = TRUE
    c_cols = FALSE
  }else if(input$cluster=="B"){
    crows = FALSE
    c_cols = TRUE
  }else{
    crows = FALSE
    c_cols = FALSE
  }
  
    pheatmap(test,
             color=colorInput(),
             cellwidth = input$cellwidth, 
             cellheight = input$cellheight, 
             border_color=input$border,
             scale=input$scaleoption,
             cluster_rows = crows, cluster_cols = c_cols,
             main = input$plottittle,
             fontsize=input$mainsize,
             fontsize_row=input$fontsizerow,
             fontsize_col=input$fontsizecol,
             legend=input$displaycolorkey,
             display_numbers=input$displaynumbers,
             fontsize_number=input$fontsizenumber
    ) 
  
  
  
}

output$heatmapplot<-renderPlot({
  Corheatmap()
  
},height=800,width=800)



#download function
output$downloadDataHeatPNG <- downloadHandler(
  filename = function() {
    paste("output", Sys.time(), '.png', sep='')
  },
  
  content = function(file) {
    #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
    png(file=file)
    print(Corheatmap())
    dev.off()
  },
  contentType = 'image/png'
)


output$downloadDataheatPDF <- downloadHandler(
  filename = function() {
    paste("output", Sys.time(), '.pdf', sep='')
  },
  
  content = function(file) {
    pdf(file)
    print(Corheatmap())
    dev.off()
  },
  contentType = 'image/pdf'
)

output$downloadDataheatEPS <- downloadHandler(
  filename = function() {
    paste("output", Sys.time(), '.eps', sep='')
  },
  
  content = function(file) {
    postscript(file,fonts=c("serif", "Palatino","Times"))
    print(Corheatmap())
    dev.off()
  },
  contentType = 'image/eps'
)

 #inout alert
 observe({
   showshinyalert(session, "shinyalert1", "By default, a tab-delmited file with header information is recommanded. alternatively, you can use follow option to parse you data")
 })
 #size option
 observe({
   showshinyalert(session, "shinyalert2", "Setting line size parameter here!", "info")
 })
 #set text
 observe({
   showshinyalert(session, "shinyalert3", "Setting sample names, title and axis style of this plot", "info")
 })
 #legend option 
 observe({
   showshinyalert(session, "shinyalert5", "Setting the postion,font and size of legend", "info")
 })
 observe({
   showshinyalert(session, "shinyalert6", "I am Kidding too :)", "info")
 })

 observe({
   showshinyalert(session, "shinyalert7", "This panel produced significance level for pearson and spearman correlations. To perform this kind of analysis, only pairwise deletion is used", "info")
 })

#alert text 
 observe({
   showshinyalert(session, "shinyalert4", paste(input$select2Input1, collapse = ","), "info")
 })
})



