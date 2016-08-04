library(shiny)
library(ggplot2)
library(grid)
library(Hmisc)
library(corrgram)



options(shiny.maxRequestSize=100*1024^2) # max file size is 100Mb


shinyServer(function(input,output,session){

datasetInput <- reactive({ 
                            
  example<-mtcars
#example<-read.table("E:\\Program Files\\R\\R-3.1.0\\library\\shiny\\examples\\ROCplot\\data\\test.txt",header=F,sep="\t",stringsAsFactors=F)
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



