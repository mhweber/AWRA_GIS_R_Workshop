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
- [Exercise 3](#exercise-3): add web services layer


## Exercise 1
### ggplot and plotly

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
```

![states_ggplot](/AWRA_GIS_R_Workshop/figure/states_ggplot.png)


Use plotly to make interactive
```r
ggplotly(g)
```
![plotly](/AWRA_GIS_R_Workshop/figure/plotly.png)

## Exercise 1
### ggplot and plotly







