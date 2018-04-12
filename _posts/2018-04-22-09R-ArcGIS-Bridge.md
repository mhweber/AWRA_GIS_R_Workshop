---
title: "Lesson 6 - R ArcGIS Bridge Demo"
author: Marc Weber
layout: post_page
---

If don’t already have ArcGIS, you can get a free 21 day trial [here](http://www.arcgis.com/features/free-trial.html).

[Instructional videos](https://community.esri.com/groups/rstats/content?filterID=contentstatus%5Bpublished%5D~objecttype~objecttype%5Bvideo%5D) on installing the R-ArcGIS bridge.

**Using R and ArcGIS together**:
The most effective way to leverage the combined value of ArcGIS and R is to use the R-ArcGIS bridge, an open source project providing a seamless two-way data bridge between R and ArcGIS. The bridge also allows R scripts to be run from ArcGIS as geoprocessing tools.
The R-ArcGIS bridge works with versions beginning at R 3.2.2 , ArcMap 10.3.1, ArcGIS Pro 1.1, or later.
The bridge supports feature, raster, and tabular data from ArcGIS. This can be data on your local disk as well as URLs to feature services and image services. The bridge support data objects of the most common spatial packages: sp, sf, and raster, along with R data frame objects. The usage is very similar to standard R syntax. 

**Open ArcGIS data**:
```r
gis_data <- arc.open(path = ‘c:/data/seagrass.shp’)
```

**Load dataset to R data frame**:
```r
R_data <- arc.select(gis_data, fields, SQL, spatial ref)
```

**Working with spatial data and you need the shape (geometry) information**:
```r
ozone.sp.df <- arc.data2sp(ozone.dataframe)
ozone.dataframe <- arc.sp2data(ozone.sp.df)
```

**Results of analysis can be written with ArcGIS capabilities as well**:
```r
arc.write(path = tempfile("ca_new", fileext=".shp"), data = ozone.dataframe)
```

**Installation instructions**
	- [ArcMap Installation Video](https://community.esri.com/videos/4134-installing-the-r-arcgis-bridge-for-arcmap-1031)
	- [ArcGIS Pro Version 1.1-1.4 Installation Video](https://community.esri.com/videos/4135-installing-the-r-arcgis-bridge-for-arcgis-pro-11-141)
	- [ArcGIS Pro Version 2.0+ Installation Video](https://community.esri.com/videos/4136-installing-the-r-arcgis-bridge-for-arcgis-pro-20)

**Free Online Training & Tutorials**
  - [Analyze Crime Using Statistics and the R-ArcGIS Bridge](https://learn.arcgis.com/en/projects/analyze-crime-using-statistics-and-the-r-arcgis-bridge/): A guided learn lesson that covers all the basic functionality of the bridge along with how to perform an analysis integrating R and ArcGIS. 
  - [Using the R-ArcGIS Bridge](https://www.esri.com/training/catalog/58b5e417b89b7e000d8bfe45/using-the-r-arcgis-bridge/): A guided web course that covers all the basic functionality of the bridge.
  - [Integrating R Scripts into ArcGIS Geoprocessing Tools](https://www.esri.com/training/catalog/58b5e578b89b7e000d8bfffd/integrating-r-scripts-into-arcgis-geoprocessing-tools/): A guided web course on creating an ArcGIS Geoprocessing tool which calls an R script.
  - New online tutorial in early May on use of raster data

**Resources**
  - [arcgisbinding package vignette](https://r-arcgis.github.io/assets/arcgisbinding-vignette.html): The package vignette provides a detailed description of each function in the arcgisbinding R package. It also includes a template for creating script tools. 
  - [Sample script tools](https://github.com/R-ArcGIS/r-sample-tools): Sample script tools to be used as working examples to create new script tools from. 

**Help**
  - [R-ArcGIS GeoNet](https://community.esri.com/groups/rstats): The main place to go for everything about the R-ArcGIS project and community, including discussion forum, training materials, videos, blogs, etc. Users can ask questions in the forum to other users and to the R-ArcGIS project team.
  - [R-ArcGIS GitHub](https://github.com/R-ArcGIS/r-bridge/issues): For suspected bugs and install issues, use the ‘Issues’ section of the r-bridge-install page. We also have a [section](https://github.com/R-ArcGIS/CHANS-tools) where R-ArcGIS bridge community members can share script tools they have created to help other users. Contact us if you would like to add or link in your project here.

