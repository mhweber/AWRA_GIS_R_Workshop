---
title: "05 - Spatial Data in R - simple features"
author: Marc Weber
layout: post_page
---

The `sf` Simple Features for R package by Edzer Pebesma is a new, very nice package that represents a changes of gears from the `sp` S4 or new style class representation of spatial data in R, and instead provides [simple features access](https://en.wikipedia.org/wiki/Simple_Features) for R. This will be familiar to folks who use [PostGIS](https://en.wikipedia.org/wiki/PostGIS), [MySQL Spatial Extensions](https://en.wikipedia.org/wiki/MySQL), [Oracle Spatial](https://en.wikipedia.org/wiki/Oracle_Spatial_and_Graph), the [OGR component of the GDAL library](https://en.wikipedia.org/wiki/GDAL), [GeoJSON](https://datatracker.ietf.org/doc/rfc7946/) and [GeoPandas](http://geopandas.org/) in Python.  Simple features are represented with Well-Known text - [WKT](https://en.wikipedia.org/wiki/Well-known_text) - and well-know binary formats.

The big difference is the use of S3 classes in R rather than the S4, or new style classes of `sp` with the use of slots.  Simple features are simply `data.frame` objects that have a geometry list-column.  `sf` interfaces with [GEOS](https://trac.osgeo.org/geos) for topolgoical operations, uses [GDAL](https://en.wikipedia.org/wiki/GDAL) for data creation as well as very speedy I/O along with [GEOS](https://trac.osgeo.org/geos), and also which is quite nice can directly read and write to spatial databases such as [PostGIS](https://en.wikipedia.org/wiki/PostGIS).  

Edzar Pebesma has extensive documentation, blog posts and vignettes available for `sf` here:
[Simple Features for R](https://github.com/edzer/sfr)

## Lesson Goals
  - Learn about new simple features package using some administrative boundaries, EPA data (Wadeable Streams Assessment sites) and some water quality data

First, if not already installed, install `sf`

```r
library(devtools)
# install_github("edzer/sfr")
library(sf)
```

```
## Linking to GEOS 3.5.0, GDAL 2.1.1, proj.4 4.9.3
```

The `sf` package has numerous topological methods for performing spatial operations.

```r
methods(class = "sf")
```

```
##  [1] [                 aggregate         cbind            
##  [4] coerce            initialize        plot             
##  [7] print             rbind             show             
## [10] slotsFromS3       st_agr            st_agr<-         
## [13] st_as_sf          st_bbox           st_boundary      
## [16] st_buffer         st_cast           st_centroid      
## [19] st_convex_hull    st_crs            st_crs<-         
## [22] st_difference     st_drop_zm        st_geometry      
## [25] st_geometry<-     st_intersection   st_is            
## [28] st_linemerge      st_polygonize     st_precision     
## [31] st_segmentize     st_simplify       st_sym_difference
## [34] st_transform      st_triangulate    st_union         
## see '?methods' for accessing help and source code
```

To begin exploring, let's read in some spatial data. We'll grab EPA Wadeable Streams Assessment sites to begin looking at.

```r
library(RCurl)
library(sf)
library(ggplot2)
download <- getURL("https://www.epa.gov/sites/production/files/2014-10/wsa_siteinfo_ts_final.csv")

wsa <- read.csv(text = download)
class(wsa)
```

Just a data frame that includes location and other identifying information about river and stream sampled sites from 2000 to 2004.

```
## [1] "data.frame"
```

Before we go any further, let's subset our data to just the US plains ecoregions using the 'ECOWSA9' variable in the wsa dataset.

```r
levels(wsa$ECOWSA9)
wsa_plains <- wsa[wsa$ECOWSA9 %in% c("TPL","NPL","SPL"),]
```

Because this data frame has coordinate information, we can then promotote it to an sf spatial object.

```r
wsa_plains = st_as_sf(wsa_plains, coords = c("LON_DD", "LAT_DD"), crs = 4269,agr = "constant")
str(wsa_plains)
```

Note that this is now still a dataframe but with an additional geometry column.

We can do simple plotting just as with `sp` spatial objects...note how it's easy to use graticules as a parameter for `plot` in `sf`.

```r
plot(wsa_plains[,46], main='EPA WSA Sites in the Plains Ecoregions', graticule = st_crs(wsa_plains), axes=TRUE)
```

![WSASites](/AWRA_GIS_R_Workshop/figure/WSASites.png)


Now let's grab some administrative boundary data, for instance US states.  After bringing in, let's examine coordinate system and compare with coordinate system of the WSA data we already have loaded.  Remember, in sf, as with sp, we need to have data in the same CRS in order to do any kind of spatial operations involving both datasets.

```r
states  <- us_states()
st_crs(states)
st_crs(wsa_plains)
# They're not equal, which we verify with:
st_crs(states) == st_crs(wsa_plains)
# We'll tranfsorm the WSA sites to same CRS as states
wsa_plains <- st_transform(wsa_plains, st_crs(states))
```


```r
states  <- us_states()
st_crs(states)
st_crs(wsa_plains)
# They're not equal, which we verify with:
st_crs(states) == st_crs(wsa_plains)
# We'll tranfsorm the WSA sites to same CRS as states
wsa_plains <- st_transform(wsa_plains, st_crs(states))
```

And plotting with `plot` just like counties - notice use of pch to alter the plot symbols, I personally don't like the default circles for plotting points in `sf`.

```r
plot(cities[1], main='Oregon Cities', axes=TRUE, pch=3)
```

![GIS Explorer OR Cities](/AWRA_GIS_R_Workshop/figure/GIS Explorer OR Cities.png)

Take a few minutes and try using some simple features functions like st_buffer on the cities or st_centrioid or st_union on the counties and plot to see if it works.

Let's construct an `sf`  spatial object in R from a data frame with coordinate information - we'll use the built-in dataset 'quakes' with information on earthquakes off the coast of Fiji.  Construct spatial points sp, spatial points data frame, and then promote it to a simple features object.

```r
data(quakes)
head(quakes)
```

```
##      lat   long depth mag stations
## 1 -20.42 181.62   562 4.8       41
## 2 -20.62 181.03   650 4.2       15
## 3 -26.00 184.10    42 5.4       43
## 4 -17.97 181.66   626 4.1       19
## 5 -20.42 181.96   649 4.0       11
## 6 -19.68 184.31   195 4.0       12
```

```r
class(quakes)
```

```
## [1] "data.frame"
```
 
Create a simple features object from quakes

```r
quakes_sf = st_as_sf(quakes, coords = c("long", "lat"), crs = 4326,agr = "constant")
```


```r
## Classes ‘sf’ and 'data.frame':	1000 obs. of  4 variables:
##  $ depth   : int  562 650 42 626 649 195 82 194 211 622 ...
##  $ mag     : num  4.8 4.2 5.4 4.1 4 4 4.8 4.4 4.7 4.3 ...
##  $ stations: int  41 15 43 19 11 12 43 15 35 19 ...
##  $ geometry:sfc_POINT of length 1000; first list element: Classes 'XY',
## 'POINT', 'sfg'  num [1:2] 181.6 -20.4
## - attr(*, "sf_column")= chr "geometry"
##  ..- attr(*, "names")= chr  "depth" "mag" "stations"
```

We can use `sf` methods on quakes now such as `st_bbox`, `st_coordinates`, etc.

```r
st_bbox(quakes_sf)
```

```r
##         min    max
## long 165.67 188.13
## lat  -38.59 -10.72
```

```r
head(st_coordinates(quakes_sf))
```

```r
##       X      Y
## 1 181.62 -20.42
## 2 181.03 -20.62
## 3 184.10 -26.00
## 4 181.66 -17.97
## 5 181.96 -20.42
## 6 184.31 -19.68
```

And plot...

```r
plot(quakes_sf[,3],cex=log(quakes_sf$depth/100), pch=21, bg=24, lwd=.4, axes=T) 
```

![Quakes](/AWRA_GIS_R_Workshop/figure/Quakes.png)

- R `sf` Resources:

    - [GitHub Simple Features Repo](https://github.com/edzer/sfr)
    
    - [First Impressions From SF](https://geographicdatascience.com/2017/01/06/first-impressions-from-sf-the-simple-features-r-package/)
    


