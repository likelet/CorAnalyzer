library(ggplot2)
correlationScatterPlot <- function(tb, xcol, ycol, cormethod,isFitted = TRUE){
  #get sample names
  #xcol, ycol should be character variants as colnames of columns to be plotted
  #prepare data
  logtb <- data.frame(matrix(NA, ncol = 2, nrow = length(tb[,1])))
  for(i in 1:length(tb[,1])){
    logtb[i,1] <- log10(tb[i, xcol] + 1)
    logtb[i,2] <- log10(tb[i, ycol] + 1)
  }
  colnames(logtb) <- c(xcol, ycol)
  #prepare cord. of Spearman Correlation notes

  #calculation: spearman correlation & correlation test
  spearmanCor <- cor(logtb[,xcol], logtb[,ycol], method=cormethod)
  pvalue=cor.test(logtb[,xcol], logtb[,ycol], method=cormethod)$p.value
  #plotting: scatter plot + regression line
  p <- ggplot(logtb, aes_string(x = xcol, y = ycol)) + 
    geom_point(color = "black", size = 1) + 
    annotate("text", x =max(logtb[,xcol]) , y=max(logtb[,ycol]), label = paste("R = ",as.character(round(spearmanCor, digits = 4)),sep=""))+
    annotate("text", x =max(logtb[,xcol]) , y=max(logtb[,ycol])-1, label = paste("P-value = ",as.character(round(pvalue, digits = 4)),sep=""))+
    scale_x_continuous(paste("Expression level of ", xcol)) + 
    scale_y_continuous(paste("Expression level of ", ycol))
  
  #insertion: regression line
  if(isFitted == TRUE){
    p <- p + 
      geom_smooth(method = "lm", se = FALSE, color = "#990000", size = 0.75)
  }
  
  #theme
  p <- p + 
    theme(
      panel.background = element_rect(fill = "white", color = "black"),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.title = element_text(family="Times", face = "bold.italic", color = "black", size = 15),
      legend.title = element_text(face = "bold", color = "black", size = 15),
      legend.text = element_text(color = "black", size = 15),
      #custom theme
      axis.text.x = element_text(family="Times", face = "bold.italic", angle = 00, color = "black", size = 15),
      axis.text.y = element_text(family="Times", face = "bold.italic", angle = 00, color = "black", size = 15)
    )
  
  
  return(p)
  
}
