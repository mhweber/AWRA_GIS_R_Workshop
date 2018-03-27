#####################################################
# Source code for AWRA GIS Conference April 2018
# R and Spatial Data
# Marc Weber, Mike McMannus, Steve Kopp
#####################################################

#######################
# SpatialData in R - sp
#######################

# Download data
download.file("https://github.com/mhweber/AWRA_GIS_R_Workshop/blob/gh-pages/files/SourceCode.R?raw=true",
              "SourceCode.R",
              method="auto",
              mode="wb")
download.file("https://github.com/mhweber/AWRA_GIS_R_Workshop/blob/gh-pages/files/WorkshopData.zip?raw=true",
              "WorkshopData.zip",
              method="auto",
              mode="wb")
download.file("https://github.com/mhweber/AWRA_GIS_R_Workshop/blob/gh-pages/files/HUCs.RData?raw=true",
              "HUCs.RData",
              method="auto",
              mode="wb")
download.file("https://github.com/mhweber/gis_in_action_r_spatial/blob/gh-pages/files/NLCD2011.Rdata?raw=true",
              "NLCD2011.Rdata",
              method="auto",
              mode="wb")
unzip("WorkshopData.zip", exdir = "/home/marc")

getwd()
dir()
setwd("/home/marc/GitProjects")
class(iris)
str(iris)

# Exercise 1

library(sp)
getClass("Spatial")
getClass("SpatialPolygons")

library(rgdal)
data(nor2k)
plot(nor2k,axes=TRUE)

# Exercise 2

cities <- c('Ashland','Corvallis','Bend','Portland','Newport')
longitude <- c(-122.699, -123.275, -121.313, -122.670, -124.054)
latitude <- c(42.189, 44.57, 44.061, 45.523, 44.652)
population <- c(20062,50297,61362,537557,9603)
locs <- cbind(longitude, latitude) 
plot(locs, cex=sqrt(population*.0002), pch=20, col='red', 
     main='Population', xlim = c(-124,-120.5), ylim = c(42, 46))
text(locs, cities, pos=4)

breaks <- c(20000, 50000, 60000, 100000)
options(scipen=3)
legend("topright", legend=breaks, pch=20, pt.cex=1+breaks/20000, 
       col='red', bg='gray')

lon <- c(-123.5, -123.5, -122.5, -122.670, -123)
lat <- c(43, 45.5, 44, 43, 43)
x <- cbind(lon, lat)
polygon(x, border='blue')
lines(x, lwd=3, col='red')
points(x, cex=2, pch=20)

library(maps)
map()

map.text('county','oregon')
map.axes()
title(main="Oregon State")

p <- map('county','oregon')
str(p)
p$names[1:10]
p$x[1:50]

L1 <-Line(cbind(p$x[1:8],p$y[1:8]))
Ls1 <- Lines(list(L1), ID="Baker")
SL1 <- SpatialLines(list(Ls1))
str(SL1)
plot(SL1) 

library(maptools)
counties <- map('county','oregon', plot=F, col='transparent',fill=TRUE)
counties$names
#strip out just the county names from items in the names vector of counties
IDs <- sapply(strsplit(counties$names, ","), function(x) x[2])
counties_sp <- map2SpatialPolygons(counties, IDs=IDs,
                                   proj4string=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
summary(counties_sp)
plot(counties_sp, col="grey", axes=TRUE)

# Exercise 3

StreamGages <- read.csv('StreamGages.csv')
class(StreamGages)
head(StreamGages)

coordinates(StreamGages) <- ~LON_SITE + LAT_SITE
llCRS <- CRS("+proj=longlat +datum=NAD83")
proj4string(StreamGages) <- llCRS
summary(StreamGages)

bbox(StreamGages)
proj4string(StreamGages)

projInfo(type='datum')
projInfo(type='ellps')
projInfo(type='proj')

proj4string(StreamGages)

plot(StreamGages, axes=TRUE, col='blue')

map('state',regions=c('oregon','washington','idaho'),fill=FALSE, add=T)

plot(StreamGages[StreamGages$STATE=='OR',],add=TRUE,col="Yellow") #plot just the Oregon sites in yellow on top of other sites
plot(StreamGages[StreamGages$STATE=='WA',],add=TRUE,col="Red")
plot(StreamGages[StreamGages$STATE=='ID',],add=TRUE,col="Green")

load("/home/marc/GitProjects/gis_in_action_r_spatial/files/HUCs.RData")
class(HUCs)
getClass("SpatialPolygonsDataFrame")
summary(HUCs)
slotNames(HUCs) #get slots using method
str(HUCs, 2)
head(HUCs@data) #the data frame slot 
HUCs@bbox #call on slot to get bbox

HUCs@polygons[[1]]
slotNames(HUCs@polygons[[1]])
HUCs@polygons[[1]]@labpt
HUCs@polygons[[1]]@Polygons[[1]]@area

# How would we code a way to extract the HUCs polygon with the smallest area? 
# Look at the min_area function that is included in the HUCs.RData file
min_area
min_area(HUCs)
# We use sapply from the apply family of functions on the area slot of the Polygons slot

StreamGages <- spTransform(StreamGages, CRS(proj4string(HUCs)))
gage_HUC <- over(StreamGages,HUCs, df=TRUE)
StreamGages$HUC <- gage_HUC$HUC_8[match(row.names(StreamGages),row.names(gage_HUC))]
head(StreamGages@data)

library(rgeos)
HUCs <- spTransform(HUCs,CRS("+init=epsg:2991"))
gArea(HUCs)

# Reading in Spatial Data
ogrDrivers()
download.file("ftp://ftp.gis.oregon.gov/adminbound/citylim_2017.zip","citylim_2017.zip")
unzip("citylim_2017.zip", exdir = ".") 
citylims <- readOGR(".", "citylim_2017") # our first parameter is directory, in this case '.' for working directory, and no extension on file!
plot(citylims, axes=T, main='Oregon City Limits') # plot it!

download.file("https://www.blm.gov/or/gis/files/web_corp/state_county_boundary.zip","/home/marc/state_county_boundary.zip")
unzip("state_county_boundary.zip", exdir = "/home/marc")
fgdb = "state_county_boundary.gdb"

# List all feature classes in a file geodatabase
fc_list = ogrListLayers(fgdb)
print(fc_list)

# Read the feature class
state_poly = readOGR(dsn=fgdb,layer="state_poly")
plot(state_poly, axes=TRUE)
cob_poly = readOGR(dsn=fgdb,layer="cob_poly")
plot(cob_poly, add=TRUE, border='red')

#######################
# SpatialData in R - sf
#######################

# From CRAN:
install.packages("sf")
# From GitHub:
library(devtools)
# install_github("edzer/sfr")
library(sf)

methods(class = "sf")

# Exercise 1
library(RCurl)
library(sf)
library(ggplot2)
download <- getURL("https://www.epa.gov/sites/production/files/2014-10/wsa_siteinfo_ts_final.csv")

wsa <- read.csv(text = download)
class(wsa)

levels(wsa$ECOWSA9)
wsa_plains <- wsa[wsa$ECOWSA9 %in% c("TPL","NPL","SPL"),]

wsa_plains = st_as_sf(wsa_plains, coords = c("LON_DD", "LAT_DD"), crs = 4269,agr = "constant")
str(wsa_plains)

head(wsa_plains[,c(1,60)])

plot(wsa_plains[c(46,56)], graticule = st_crs(wsa_plains), axes=TRUE)

plot(wsa_plains[c(38,46)],graticule = st_crs(wsa_plains), axes=TRUE)
plot(wsa_plains['geometry'], main='Keeping things simple',graticule = st_crs(wsa_plains), axes=TRUE)

ggplot(wsa_plains) +
  geom_sf() +
  ggtitle("EPA WSA Sites in the Plains Ecoregions") +
  theme_bw()

# Exercise 2
library(USAboundaries)
states  <- us_states()
levels(as.factor(states$state_abbr))
states <- states[!states$state_abbr %in% c('AK','PR','HI'),]

st_crs(states)
st_crs(wsa_plains)
# They're not equal, which we verify with:
st_crs(states) == st_crs(wsa_plains)
# We'll tranfsorm the WSA sites to same CRS as states
wsa_plains <- st_transform(wsa_plains, st_crs(states))

plot(states$geometry, axes=TRUE)
plot(wsa_plains$geometry, col='blue',add=TRUE)

plains_states <- states[wsa_plains,]

plains_states <- states[wsa_plains,op = st_intersects]

iowa = states[states$state_abbr=='IA',]
iowa_sites <- st_intersection(wsa_plains, iowa)

sel_list <- st_intersects(wsa_plains, iowa)

sel_mat <- st_intersects(wsa_plains, iowa, sparse = FALSE)
iowa_sites <- wsa_plains[sel_mat,]
plot(plains_states$geometry, axes=T)
plot(iowa_sites, add=T, col='blue')

sel_mat <- st_disjoint(wsa_plains, iowa, sparse = FALSE)
not_iowa_sites <- wsa_plains[sel_mat,]
plot(plains_states$geometry, axes=T)
plot(not_iowa_sites, add=T, col='red')

# Exercise 3
wsa_plains <- wsa_plains[c(1:4,60)]
wsa_plains <- st_join(wsa_plains, plains_states)
# verify your results
head(wsa_plains)

library(dataRetrieval)
IowaNitrogen<- readWQPdata(statecode='IA', characteristicName="Nitrogen")
head(IowaNitrogen)
names(IowaNitrogen)

siteInfo <- attr(IowaNitrogen, "siteInfo") 
unique(IowaNitrogen$ResultMeasure.MeasureUnitCode)

IowaSummary <- IowaNitrogen %>%
  dplyr::filter(ResultMeasure.MeasureUnitCode %in% c("mg/l","mg/l      ")) %>%
  dplyr::group_by(MonitoringLocationIdentifier) %>%
  dplyr::summarise(count=n(),
                   start=min(ActivityStartDateTime),
                   end=max(ActivityStartDateTime),
                   mean = mean(ResultMeasureValue, na.rm = TRUE)) %>%
  dplyr::arrange(-count) %>%
  dplyr::left_join(siteInfo, by = "MonitoringLocationIdentifier")

iowa_wq = st_as_sf(IowaSummary, coords = c("dec_lon_va", "dec_lat_va"), crs = 4269,agr = "constant")

plot(st_geometry(subset(states, state_abbr == 'IA')), axes=T)
plot(st_geometry(subset(wsa_plains, STATE =='IA')), add=T, col='blue')
plot(iowa_wq, add=T, col='red')

wsa_iowa <- subset(wsa_plains, state_abbr=='IA')
wsa_iowa <- st_transform(wsa_iowa, crs=26915)
iowa_wq <- st_transform(iowa_wq, crs=26915)

wsa_wq = st_join(wsa_iowa, iowa_wq, st_is_within_distance, dist = 50000)

# Exercise 4
download <- getURL("https://www.epa.gov/sites/production/files/2014-10/waterchemistry.csv")

wsa_chem <- read.csv(text = download)
wsa$COND <- wsa_chem$COND[match(wsa$SITE_ID, wsa_chem$SITE_ID)]

wsa = st_as_sf(wsa, coords = c("LON_DD", "LAT_DD"), crs = 4269,agr = "constant")
states <- st_transform(states, st_crs(wsa))
plot(states$geometry, axes=TRUE)
plot(wsa$geometry, add=TRUE)

avg_cond_state <- st_join(states, wsa) %>%
  dplyr::group_by(name) %>%
  dplyr::summarize(MeanCond = mean(COND, na.rm = TRUE))

ggplot(avg_cond_state) +
  geom_sf(aes(fill = MeanCond)) +
  scale_fill_distiller("Conductivity", palette = "Greens") +
  ggtitle("Averge Conductivity (uS/cm @ 25 C) per State") +
  theme_bw()

st_drivers()

download.file("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip", "ne_110m_admin_0_countries.zip")
unzip("ne_110m_admin_0_countries.zip", exdir = ".") 
countries <- st_read("ne_110m_admin_0_countries.shp") 
plot(countries$geometry) # plot it!

# Geodatabase Example - if you haven't already downloaded:
download.file("https://www.blm.gov/or/gis/files/web_corp/state_county_boundary.zip","/home/marc/state_county_boundary.zip")
unzip("state_county_boundary.zip", exdir = "/home/marc")
fgdb = "state_county_boundary.gdb"

# List all feature classes in a file geodatabase
st_layers(fgdb)

# Read the feature class
state_poly = st_read(dsn=fgdb,layer="state_poly")
state_poly$SHAPE

###########################
# SpatialData in R - Raster
###########################

library(raster)
r <- raster(ncol=10, nrow = 10, xmx=-116,xmn=-126,ymn=42,ymx=46)
str(r)
r
r[] <- runif(n=ncell(r))
r
plot(r)


r[5]
r[1,5]

r2 <- r * 50
r3 <- sqrt(r * 5)
s <- stack(r, r2, r3)
s
plot(s)

b <- brick(x=c(r, r * 50, sqrt(r * 5)))
b
plot(b)


# Exercise 1

US <- getData("GADM",country="USA",level=2)
states    <- c('California', 'Nevada', 'Utah','Montana', 'Idaho', 'Oregon', 'Washington')
PNW <- US[US$NAME_1 %in% states,]
plot(PNW, axes=TRUE)

library(ggplot2)
ggplot(PNW) + geom_polygon(data=PNW, aes(x=long,y=lat,group=group),
                           fill="cadetblue", color="grey") + coord_equal()

srtm <- getData('SRTM', lon=-116, lat=42)
plot(srtm)
plot(PNW, add=TRUE)

OR <- PNW[PNW$NAME_1 == 'Oregon',]
srtm2 <- getData('SRTM', lon=-121, lat=42)
srtm3 <- getData('SRTM', lon=-116, lat=47)
srtm4 <- getData('SRTM', lon=-121, lat=47)

srtm_all <- mosaic(srtm, srtm2, srtm3, srtm4,fun=mean)

plot(srtm_all)
plot(OR, add=TRUE)

srtm_crop_OR <- crop(srtm_all, OR)
plot(srtm_crop_OR, main="Elevation (m) in Oregon")
plot(OR, add=TRUE)

srtm_mask_OR <- crop(srtm_crop_OR, OR)

Benton <- OR[OR$NAME_2=='Benton',]
srtm_crop_Benton <- crop(srtm_crop_OR, Benton)
srtm_mask_Benton <- mask(srtm_crop_Benton, Benton)
plot(srtm_mask_Benton, main="Elevation (m) in Benton County")
plot(Benton, add=TRUE)

typeof(values(srtm_crop_OR))
values(srtm_crop_OR) <- as.numeric(values(srtm_crop_OR))
typeof(values(srtm_crop_OR))

cellStats(srtm_crop_OR, stat=mean)
cellStats(srtm_crop_OR, stat=min)
cellStats(srtm_crop_OR, stat=max)
cellStats(srtm_crop_OR, stat=median)
cellStats(srtm_crop_OR, stat=range)

values(srtm_crop_OR) <- values(srtm_crop_OR) * 3.28084

library(rasterVis)
histogram(srtm_crop_OR, main="Elevation In Oregon")
densityplot(srtm_crop_OR, main="Elevation In Oregon")

p <- levelplot(srtm_crop_OR, layers=1, margin = list(FUN = median))
p + layer(sp.lines(OR, lwd=0.8, col='darkgray'))

Benton_terrain <- terrain(srtm_mask_Benton, opt = c("slope","aspect","tpi","roughness","flowdir"))
plot(Benton_terrain)

Benton_hillshade <- hillShade(Benton_terrain[['slope']],Benton_terrain[['aspect']])
plot(Benton_hillshade, main="Hillshade Map for Benton County")

# Exercise 2

library(landsat)
data(july1,july2,july3,july4,july5,july61,july62,july7)
july1 <- raster(july1)
july2 <- raster(july2)
july3 <- raster(july3)
july4 <- raster(july4)
july5 <- raster(july5)
july61 <- raster(july61)
july62 <- raster(july62)
july7 <- raster(july7)
july <- stack(july1,july2,july3,july4,july5,july61,july62,july7)
july
plot(july)

ndvi <- (july[[4]] - july[[3]]) / (july[[4]] + july[[3]])
# OR
ndviCalc <- function(x) {
  ndvi <- (x[[4]] - x[[3]]) / (x[[4]] + x[[3]])
  return(ndvi)
}
ndvi <- raster::calc(x=july, fun=ndviCalc)
plot(ndvi)

savi <- ((july[[4]] - july[[3]]) / (july[[4]] + july[[3]]) + 0.5)*1.5
# OR 
saviCalc <- function(x) {
  savi <- ((x[[4]] - x[[3]]) / (x[[4]] + x[[3]]) + 0.5)*1.5
  return(savi)
}
ndvi <- calc(x=july, fun=saviCalc)
plot(savi)

ndmi <- (july[[4]] - july[[5]]) / (july[[4]] + july[[5]])
# OR 
ndmiCalc <- function(x) {
  ndmi <- (x[[4]] - x[[5]]) / (x[[4]] + x[[5]])
  return(ndmi)
}
ndmi <- calc(x=july, fun=ndmiCalc)
plot(ndmi)

# Exercise 3

download.file("https://github.com/mhweber/gis_in_action_r_spatial/blob/gh-pages/files/NLCD2011.Rdata?raw=true",
              "NLCD2011.Rdata",
              method="auto",
              mode="wb")
load('NLCD2011.Rdata')



ThreeCounties <- OR[OR$NAME_2 %in% c('Washington','Multnomah','Hood River'),]
NLCD2011 <- crop(OR_NLCD, ThreeCounties)
srtm_mask_Benton <- mask(srtm_crop_Benton, Benton)
plot(srtm_mask_Benton, main="Elevation (m) in Benton County")
plot(Benton, add=TRUE)

srtm_crop_3counties <- crop(srtm_crop_OR, ThreeCounties)
plot(srtm_crop_3counties, main = "Elevation (m) for Washington, \n Multnomah and Hood River Counties")
plot(ThreeCounties, add=T)
county_av_el <- extract(srtm_crop_3counties , ThreeCounties, fun=mean, na.rm = T, small = T, df = T)

download.file("https://github.com/mhweber/gis_in_action_r_spatial/blob/gh-pages/files/NLCD2011.Rdata?raw=true",
              "NLCD2011.Rdata",
              method="auto",
              mode="wb")
load("/home/marc/NLCD2011.Rdata")

# Here we pull out the raster attribute table to a data frame to use later - when we manipule the raster in the raster package,
# we lose the extra categories we'll want later
rat <- as.data.frame(levels(NLCD2011[[1]]))

projection(NLCD2011)
proj4string(ThreeCounties)
ThreeCounties <- spTransform(ThreeCounties, CRS(projection(NLCD2011)))

# Aggregate so extract doesn't take quite so long - but this will take a few minutes as well...
NLCD2011 <- aggregate(NLCD2011, 3, fun=modal, na.rm = T)
plot(NLCD2011)
e <- extract(NLCD2011, ThreeCounties, method = 'simple')
class(e)
length(e) 
# This next section gets into fairly advance approaches in R using apply family of functions as well as melting (turning data to long form)
# and casting (putting back into wide form)
et = lapply(e,table)
library(reshape)
t <- melt(et)
t.cast <- cast(t, L1 ~ Var.1, sum)
head(t.cast)

names(t.cast)[1] <- 'ID'
nlcd <- data.frame(t.cast)
head(nlcd)
nlcd$Total <- rowSums(nlcd[,2:ncol(nlcd)])
head(nlcd)
# There are simpler cleaner ways to do but this loop applys a percent value to each category
for (i in 2:17)
{
  nlcd[,i] = 100.0 * nlcd[,i]/nlcd[,18] 
}
rat
# We'll use the raster attrubite table we pulled out earlier to reapply the full land cover category names
newNames <- as.character(rat$LAND_COVER) # LAND_COVER is a factor, we need to convert to character - understanding factors very important in R...
names(nlcd)[2:17] <- newNames[2:17]
nlcd <- nlcd[c(1:17)] # We don't need the total column anymore
nlcd

# Last, let's pull the county names back in
CountyNames <- ThreeCounties$NAME_2
nlcd$County <- CountyNames
nlcd
# Reorder the data frame
nlcd <- nlcd[c(18,2:17)]
nlcd

# Whew, that's it - is it a fair bit of code?  Sure.  But is it easily, quickly repeatable and reproducible now?  You bet.

###########################
# SpatialData in R - Interactive Mapping
###########################

# Exercise 1
library(ggplot2)
library(plotly)
library(mapview)
library(tmap)
library(leaflet)
library(tidyverse)
library(sf)
library(USAboundaries)
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

# Exercise 2
mapview(states, zcol = 'perc_water', alpha.regions = 0.2, burst = 'name')

# An example that may be similar to what you try:
mapview(srtm)
mapview(states[states$name=='Oregon',]) + mapview(srtm) # can you figure out how to set the zoom when combining layers?

###########################
# SpatialData in R - Exploratory Spatial Data Analysis (ESDA)
###########################

library(rgdal)
library(gstat)
library(spdep)

# The shapefile needs to be in the working directory to use '.' or you need to specify the full path in first parameter to readOGR
wsa_plains <- readOGR(".","nplspltpl_bug")

class(wsa_plains)
dim(wsa_plains@data)
names(wsa_plains)
str(wsa_plains, max.level = 2)

bubble(wsa_plains['COND'])

coordinates(wsa_plains)

hscat(COND~1,wsa_plains, c(0, 10000, 50000, 250000, 750000, 1500000, 3000000))

hscat(log(COND) ~ 1,wsa_plains, c(0, 10000, 50000, 250000, 750000, 1500000, 3000000))
hscat(log(COND) ~ 1,wsa_plains, c(0, 10000, 50000, 100000, 150000, 200000, 250000))
hscat(log(COND) ~ 1,wsa_plains, c(0, 10000, 25000, 50000, 75000, 100000))
hscat(log(PTL) ~ 1,wsa_plains, c(0, 10000, 50000, 250000, 750000, 1500000, 3000000))
hscat(log(PTL) ~ 1,wsa_plains, c(0, 10000, 50000, 100000, 150000, 200000, 250000))
hscat(log(PTL) ~ 1,wsa_plains, c(0, 10000, 25000, 50000, 75000, 100000))

tpl <- subset(wsa_plains, ECOWSA9 == "TPL")
coords_tpl <- coordinates(tpl)
tpl_nb <- knn2nb(knearneigh(coords_tpl, k = 1), row.names=tpl$SITE_ID)
tpl_nb1 <- knearneigh(coords_tpl, k = 1)
#using the k=1 object to find the minimum distance at which all sites have a distance-based neighbor
tpl_dist <- unlist(nbdists(tpl_nb,coords_tpl))

summary(tpl_dist)#use max distance from summary to assign distance to create neighbors
tplnb_270km <- dnearneigh(coords_tpl, d1=0, d2=271000, row.names=tpl$SITE_ID)
summary(tplnb_270km)

plot(tpl)
plot(knn2nb(tpl_nb1), coords_tpl, add = TRUE)
title(main = "TPL K nearest neighbours, k = 1")

library(maptools)
library(rgdal)
library(spdep)
library(stringr)
library(sp)
library(reshape) # for rename function
library(tidyverse)

# N.B. Assigning short name to long path to reduce typing
shp.loc <- "//AA.AD.EPA.GOV/ORD/CIN/USERS/MAIN/L-P/mmcmanus/Net MyDocuments/AWRA GIS 2018/R and Spatial Data Workshop"

shp <- readOGR(shp.loc, "ef_lmr_huc12")

plot(shp)
dim(shp@data)

names(shp@data)

head(shp@data) # check on row name being used
# Code from Bivand book identifies classes within data frame @ data
# Shows FEATUREID variable as interger
sapply(slot(shp, "data"), class)

# Assign row names based on FEATUREID
row.names(shp@data) <- (as.character(shp@data$FEATUREID))
head(shp@data)
tail(shp@data)

# Read in StreamCat data for Ohio River Hydroregion. Check getwd()
scnlcd2011 <- read.csv("NLCD2011_Region05.csv")
names(scnlcd2011)
dim(scnlcd2011)

class(scnlcd2011)

str(scnlcd2011, max.level = 2)
head(scnlcd2011)
scnlcd2011 <- reshape::rename(scnlcd2011, c(COMID = "FEATUREID"))
names(scnlcd2011)

row.names(scnlcd2011) <- scnlcd2011$FEATUREID

head(scnlcd2011)

# gages$AVE <- gage_flow$AVE[match(gages$SOURCE_FEA,gage_flow$SOURCE_FEA)]
# this matches the FEATUREID from the 815 polygons in shp to the FEATUREID from the df scnlcd2011
efnlcd2011 <- scnlcd2011[match(shp$FEATUREID, scnlcd2011$FEATUREID),]
dim(efnlcd2011)

head(efnlcd2011) # FEATUREID is now row name
row.names(efnlcd2011) <- efnlcd2011$FEATUREID
head(efnlcd2011)
str(efnlcd2011, max.level = 2)
summary(efnlcd2011$PctCrop2011Cat)

summary(efnlcd2011$PctDecid2011Cat)

efnlcd2011 <- efnlcd2011 %>%
  mutate(logCrop = log(PctCrop2011Cat + 0.50),
         logDecid = log(PctDecid2011Cat + 0.50))

names(efnlcd2011)

sp@data = data.frame(sp@data, df[match(sp@data[,by], df[,by]),])
shp@data = data.frame(shp@data, efnlcd2011[match(shp@data[,"FEATUREID"], efnlcd2011[,"FEATUREID"]),])

head(shp@data)
class(shp)

names(shp@data)
dim(shp@data)
class(shp@data)
class(shp)
summary(shp)
head(shp@data)
summary(shp@data)

ctchcoords <- coordinates(shp)
class(ctchcoords)

ef.nb1 <- poly2nb(shp, queen = FALSE)
summary(ef.nb1)

class(ef.nb1)

plot(shp, border = "black")
plot(ef.nb1, ctchcoords, add = TRUE, col = "blue")

ef.nbwts.list <- nb2listw(ef.nb1, style = "W")
names(ef.nbwts.list)

moran.plot(shp$PctDecid2011Cat, listw = ef.nbwts.list, labels = shp$FEATUREID)

moran.plot(shp$PctDecid2011Cat, listw = ef.nbwts.list, labels = shp$FEATUREID)

unique(shp@data$huc12name)

huc12_ds1 <- shp@data
names(huc12_ds1)
str(huc12_ds1) # check huc12names is a factor

library(tidyverse)
# from Jeff Hollister EPA NHEERL-AED
# the indices [#] pull out the corresponding statistic from fivenum function
# library(dplyr)
huc12_ds2 <- huc12_ds1 %>%
  group_by(huc12name) %>%
  summarize(decidmin = fivenum(PctDecid2011Cat)[1],
            decidq1 = fivenum(PctDecid2011Cat)[2],
            decidmed = fivenum(PctDecid2011Cat)[3],
            decidq3 = fivenum(PctDecid2011Cat)[4],
            decidmax = fivenum(PctDecid2011Cat)[5],
            cropmin = fivenum(PctCrop2011Cat)[1],
            cropq1 = fivenum(PctCrop2011Cat)[2],
            cropmed = fivenum(PctCrop2011Cat)[3],
            cropq3 = fivenum(PctCrop2011Cat)[4],
            cropmax = fivenum(PctCrop2011Cat)[5])

# N.B. using tidyverse function defaults to creating an object that is:
# "tbl_df"     "tbl"        "data.frame"
class(huc12_ds2)

# from Marcus Beck in 2016-05-16 email
# devtools::install_github('USEPA/R-micromap-package-development', ref = 'development')
devtools::install_github('USEPA/micromap')
library(micromap)

huc12 <- readOGR(shp.loc, "ef_lmr_WBD_Sub")
plot(huc12)
names(huc12@data)

huc12.map.table<-create_map_table(huc12,'huc12name')#ID variable is huc12name
head(huc12.map.table)

mmplot(stat.data = as.data.frame(huc12_ds2),
       map.data = huc12.map.table,
       panel.types = c('dot_legend', 'labels', 'box_summary', 'box_summary', 'map'),
       panel.data=list(NA,
                       'huc12name',
                       list('cropmin', 'cropq1', 'cropmed', 'cropq3', 'cropmax'),
                       list('decidmin', 'decidq1', 'decidmed', 'decidq3', 'decidmax'),
                       NA),
       ord.by = 'cropmed',
       rev.ord = TRUE,
       grouping = 6,
       median.row = FALSE,
       map.link = c('huc12name', 'ID'))

mmplot_lc <- mmplot(stat.data = as.data.frame(huc12_ds2),
                    map.data = huc12.map.table,
                    panel.types = c('dot_legend', 'labels', 'box_summary', 'box_summary', 'map'),
                    panel.data=list(NA,
                                    'huc12name',
                                    list('cropmin', 'cropq1', 'cropmed', 'cropq3', 'cropmax'),
                                    list('decidmin', 'decidq1', 'decidmed', 'decidq3', 'decidmax'),
                                    NA),
                    ord.by = 'cropmed',
                    rev.ord = TRUE,
                    grouping = 6,
                    median.row = FALSE,
                    map.link = c('huc12name', 'ID'),
                    plot.height=6, plot.width=9,
                    colors=brewer.pal(6, "Spectral"),
                    
                    panel.att=list(list(1, panel.width=.8, point.type=20, point.size=2,point.border=FALSE, xaxis.title.size=1),
                                   list(2, header='WBD HUC12', panel.width=1.25, align='center', text.size=1.1),
                                   list(3, header='2011 NLCD\nCropland',
                                        graph.bgcolor='white',
                                        xaxis.ticks=c( 0, 25, 50, 75, 100),
                                        xaxis.labels=c(0, 25, 50, 75, 100),
                                        xaxis.labels.size=1,
                                        #xaxis.labels.angle=90,
                                        xaxis.title='Percent',
                                        xaxis.title.size=1,
                                        graph.bar.size = .6),
                                   list(4, header='2011 NLCD\nDeciduous Forest',
                                        graph.bgcolor='white',
                                        xaxis.ticks=c( 0, 25, 50, 75, 100),
                                        xaxis.labels=c(0, 25, 50, 75, 100),
                                        xaxis.labels.size=1,
                                        #xaxis.labels.angle=90,
                                        xaxis.title='Percent',
                                        xaxis.title.size=1,
                                        graph.bar.size = .6),
                                   list(5, header='Micromaps',
                                        inactive.border.color=gray(.7),
                                        inactive.border.size=2)))


print(mmplot_lc, name='mmplot_lc_v1_20180205.tiff',res=600)

library(tmap)
qtm(shp = shp, fill = c("PctDecid2011Cat", "PctCrop2011Cat"), fill.palette = c("Blues"), ncol =2)
