---
title: "Before The Workshop"
author: Marc Weber
layout: post_page
---

Prior to the start of the workshop everyone will need to have the software 
installed and tested.  You will need to have  R and RStudio.  Get the latest versions of each and install using the defaults.  

1. **R:** 
    - [General Info](http://cran.r-project.org/)
    - [Windows](http://cran.r-project.org/bin/windows/base/R-3.4.4-win.exe)
    - [Mac](http://cran.r-project.org/bin/macosx/R-3.4.4.pkg)
        - *Note:* Mac users will need to make sure they have XQuartz installed. You can check to see if you have it by looking in the directory `Applications/Utilities`.  If you need to install it, [follow this link](http://xquartz.macosforge.org/landing/).
    - [Linux](https://cran.r-project.org/bin/linux/)
        - Follow instructions and use file for your flavor of Linux

2. **RStudio:** 
    - [General Info](http://www.rstudio.com/products/rstudio/download/)
    - [Windows](https://download1.rstudio.org/RStudio-1.1.442.exe)
    - [Mac](https://download1.rstudio.org/RStudio-1.1.442.dmg)
    - [Ubuntu (64 bit)](https://download1.rstudio.org/rstudio-1.1.442-amd64.deb)

3. **ArcGIS and R-ArcGIS bridge:  (optional)** 
    - If don’t already have ArcGIS, you can get a free 21 day trial [here](http://www.arcgis.com/features/free-trial.html)
    - [Instructional videos on installing the R-ArcGIS bridge](https://community.esri.com/groups/rstats/content?filterID=contentstatus%5Bpublished%5D~objecttype~objecttype%5Bvideo%5D) 

  
Once everything is installed, follow the instructions below to test your installation.

## Open RStudio
Once installed, RStudio should be accessible from the start menu.  Start up RStudio.  Once running it should look something like:

![RStudio Window](/AWRA_GIS_R_Workshop/figure/rstudio.png)

## Find "Console" window
By default the console window will be on the left side of RStudio.  Find that window.  It will looking something like:  

![RStudio Console](/AWRA_GIS_R_Workshop/figure/rstudio_console.png)

## Copy and paste the code
Click in the window and paste in the code from below:


```r
version$version.string
```

## It should say (or slightly older version OK)...

```r
## [1] "R version 3.4.4 (2018-03-15)"
```




