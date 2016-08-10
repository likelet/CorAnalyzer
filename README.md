CorAnalyzer
=============
<p> CorAnalyzer is a shiny app, which were developed for interactive generating correlation scatter plot from matrix data set.</p>

### Install dependencies
To check the dependencies installed correctly, this command can help users to check the status of each installation<br/>
```R
library("Packages for check")
```
Code for install dependencies R packages 
```R
cDep <- c("ggplot2","shiny","grid","Hmisc","corrgram","shinyBS")

###INSTALLED PACKAGES
#get installed list
inst <- packageStatus()$inst

#check and install DEPENDENCIES from CRAN
for(i in 1:length(cDep)){
  tag = which(inst$Package == cDep[i])
  if(length(tag)){
    remove.packages(cDep[i])
  }
  install.packages(cDep[i])
}

###Install shinysky for pretty shiny UI
if (!require("devtools"))
  install.packages("devtools")
devtools::install_github("AnalytixWare/ShinySky")
```

### Designers:
Qi Zhao, zhaoqi3@mail2.sysu.edu.cn<br/>

### Developers:
Qi Zhao, zhaoqi3@mail2.sysu.edu.cn <br/>

### Maintainer:
Qi Zhao
Please feel free contact us. <br/>

### Copyright
To be addressed

### Citation 
During developing
