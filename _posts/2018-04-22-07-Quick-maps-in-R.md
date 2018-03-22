---
title: "Lesson 4 - Spatial Data in R - Interactive Mapping"
author: Marc Weber
layout: post_page
---

There are a number of packages available now in R for mapping and in particular interactive mapping and visualization of spatial data - we'll take a quick look at a few here. 



## Lesson Goals
- Explore a sampling of interactive mapping libraries in R

## Quick Links to Exercises
- [Exercise 1](#exercise-1): ggplot, plotly and ggmap
- [Exercise 2](#exercise-2): mapview
- [Exercise 3](#exercise-3): leaflet
- [Exercise 4](#exercise-4): tmap
- [Exercise 3](#exercise-3): add web services layer


## Exercise 1
### ggplot, plotly and ggmap

This first set of examples include gplot and ggmap, which aren't interactive, but shows using plotly with ggplot map for interactive map
```r
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

ggplotly(g)
```




- R `raster` Resources:

    - [Wageningen University IntrotoRaster](http://geoscripting-wur.github.io/IntroToRaster/)
    
    - [Wageningen University AdvancedRasterAnalysis](https://geoscripting-wur.github.io/AdvancedRasterAnalysis/)

    - [The Visual Raster Cheat Sheet](https://cran.r-project.org/web/packages/raster/)
    
    OR you can install this as a package and run examples yourself in R:
    
    - [The Visual Raster Cheat Sheet GitHub Repo](https://github.com/etiennebr/visualraster)
    
    - [Rastervis](https://oscarperpinan.github.io/rastervis/)
