---
title: "Lesson 4 - Spatial Data in R - Interactive Mapping"
author: Marc Weber
layout: post_page
---

There are a number of packages available now in R for mapping and in particular interactive mapping and visualization of spatial data - we'll take a quick look at a few here. Note that for this section, images on web page here are not interactive (long story....has to do with limitations to the way this GitHub blog site is rendered) - your results, except for using initial ggplot figure, will be interactive.



## Lesson Goals
- Explore a sampling of interactive mapping libraries in R

## Quick Links to Exercises
- [Exercise 1](#exercise-1): ggplot and plotly
- [Exercise 2](#exercise-2): mapview
- [Exercise 3](#exercise-3): leaflet
- [Exercise 4](#exercise-4): tmap
- [R Mapping Resources](#R-Mapping-Resources)

## Exercise 1
### ggplot and plotly

This first set of examples include gplot and ggmap, which aren't interactive, but shows using plotly with ggplot map for interactive map
```r
library(ggplot2)
library(plotly)
library(mapview)
library(tmap)
library(leaflet)
library(tidyverse)
library(sf)
library(USAboundaries)
library(rbokeh)
states <- us_states()
states <-states %>%
  filter(!name %in% c('Alaska','Hawaii', 'Puerto Rico')) %>%
  mutate(perc_water = log10((awater)/(awater + aland) *100))

states <- st_transform(states, 5070)
# plot, ggplot
g = ggplot(states) +
  geom_sf(aes(fill = perc_water)) +
  scale_fill_distiller("perc_water",palette = "Spectral", direction = 1) +
  ggtitle("Percent Water by State")
g
```

![states_ggplot](/AWRA_GIS_R_Workshop/figure/states_ggplot.png)


Use plotly to make interactive
```r
ggplotly(g)
```
![plotly](/AWRA_GIS_R_Workshop/figure/plotly.png)



## Exercise 2
### mapview
`mapview` is a nice package that makes use of `leaflet` package but simplifies mapping functions.  Here again we'll use the states data pulled in with the USAboundaries package. 

```r
mapview(states, zcol = 'perc_water', alpha.regions = 0.2, burst = 'name')
```

Spend some time playing with parameters in mapview - examine the interactive plot - try different backgrounds, see how you can toggle individual features on and off.  `mapview` can plot rasters as well - try generating a simple map like the one above using one of the raster layers from the raster section.  After you plot a raster, see if you can plot multiple layers - `mapview` makes it easy to plot multiple layers together as described [here](https://github.com/r-spatial/mapview/blob/develop/vignettes/articles/mapview_02-advanced.Rmd)


## Exercise 3
### leaflet
`Leaflet` is an extremely popular open-source javascript library for interactive web mapping, and the `leaflet` R package allows R users to create `Leaflet` maps from R.

The simplest of leaflet maps
```r
m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=-123.290698, lat=44.565578, popup="Here's where I work")
m  # Print the map
```

You can add vector (point, line, and polygon) and raster data to leaflet maps.  Add our states polygons.
```r
leaflet(states) %>%
  addTiles() %>%
  addPolygons()
```

Your turn - try adding our srtm raster data to a leaflet map and explore other provider tiles and try setting some diffrent tiles to make a simple interactive map. Note that some of the providers do require an API key.

## Exercise 4
### tmap





## R Mapping Resources<a name="#R-Mapping-Resources"></a>:

- [Leaflet for R](https://rstudio.github.io/leaflet/)



