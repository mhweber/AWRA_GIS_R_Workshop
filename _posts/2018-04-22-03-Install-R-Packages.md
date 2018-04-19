---
title: "Installing necessary R packages"
author: "Marc Weber"
layout: post_page
---
  
First we need to install several R packages.  Note the use of the terms `package` and `library` in R - you encounter both, and if you want to delve into semantics of which to use see [this post on R-bloggers](https://www.r-bloggers.com/packages-v-libraries-in-r/).  R operates on user-contributed packages, and we'll be jumping into use of several of these spatial packages in this workshop.  Several packages we'll be making use of are `sp`, `rgdal`, `rgeos`, `raster`, and the new `sf` simple features package by Edzer Pebesma.  You should be able to use the packages tab in RStudio (see below) to install packages in a straightforward way.  Mac and Linux users may have certain pre-requisites to fill, we'll assume you can navigate these on your own or can assist as needed.

![RStudio Console](/AWRA_GIS_R_Workshop/figure/packages.png)

Install all of the following packages in R:
Install all of the following packages in R - note that for both `sf` and `tidyverse` - and specificallly `ggplot2` in `tidyverse`, I've indicated the alternative install from GitHub rather than CRAN.  This is optional, as is installing devtools, and you will be fine with the CRAN version of packages, except that you will not be able to reproduce one of the example plots in the `sf` section that uses `sf_geom` funtion from the development version of `ggplot2`. Note that `tidyverse` is a 'meta-package' that includes several specific packages such as `ggplot2`, `dplyr`, and `tidyr`.
```r
install.packages("devtools") # optional but needed for using install_github
install.packages("rgdal")
install.packages("rgeos")
install.packages("raster")
# From CRAN:
# install.packages("sf")
# From GitHub:
library(devtools)
install_github("edzer/sfr")
install.packages("gstat")
install.packages("spdep")
install.packages("maptools")
install.packages("stringr")
install.packages("reshape")
# From CRAN:
# install.packages("tidyverse")
# From GitHub:
devtools::install_github("hadley/tidyverse")
install.packages("micromap")
install.packages("tmap")
install.packages("RCurl")
install.packages("dataRetrieval")
install.packages("maps")
install.packages("USAboundaries")
install.packages("rasterVis")
install.packages("landsat")
install.packages("plotly")
install.packages("leaflet")
```

Installing `rgdal` will install the foundation spatial package, `sp`, as a dependency, and installing `tidyverse` will install both `ggplot2` and `dplyr`.

For Linux users, to install simple features for R (`sf`), you need GDAL >= 2.0.0, GEOS >= 3.3.0, and Proj.4 >=  4.8.0.  Edzer Pebesma's Simple Features for R GitHub repo has a good explanation:

[Simple Features for R](https://github.com/edzer/sfr)

You basically want to add [ubuntugis-unstable](http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu/) to the package repositories and then get those three dependencies:

```r
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get install libgdal-dev libgeos-dev libproj-dev
```

The Simple features for R package , `sf`, also needs udunits and udunits2 which may need coercing in linux:

[Units Issues in sf GitHub repo](https://github.com/edzer/units/issues/1)

The following should resolve:

```r
sudo apt-get install libudunits2-dev
```


