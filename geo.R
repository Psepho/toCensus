library(rgdal)
library(sp)
# library(sp)
library(rgeos)

# Census tracts -----------------------------------------------------------

if(file.exists("data-raw/gct_000b11a_e.shp")) {
  # Nothing to do
}  else {
  download.file("http://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/gct_000b11a_e.zip", destfile = "data-raw/gct_000a11a_e.zip")
  unzip("data-raw/gct_000b11a_e.zip", exdir="data-raw")
}
#ct_geo <- maptools::readShapeSpatial("data-raw/gct_000b11a_e", proj4string=sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=GRS80 +towgs84=0,0,0"))
ct_geo <- rgdal::readOGR(dsn = "data-raw", layer = "gct_000b11a_e")


# Toronto wards -----------------------------------------------------------

if(file.exists("data-raw/VOTING_SUBDIVISION_2010_WGS84.shp")) {
  # Nothing to do
}  else {
  download.file("http://opendata.toronto.ca/gcc/voting_subdivision_2010_wgs84.zip",
                destfile = "data-raw/subdivisions_2010.zip")
  unzip("data-raw/subdivisions_2010.zip", exdir="data-raw")
}
to_geo <- rgdal::readOGR(dsn = "data-raw", layer = "VOTING_SUBDIVISION_2010_WGS84")


# Harmonize the projections
ct_geo <- spTransform(ct_geo, CRSobj = CRS(proj4string(to_geo)))
# Subset the CTs to just those in Toronto
ct_geo_to <- ct_geo[to_geo,]

length(over(ct_geo, to_geo))
length(over(to_geo, ct_geo))

# Find ct_geo ID in each to_geo polygon
cts_in_to <- ct_geo@data[over(to_geo, ct_geo),]
was_in_ct <- to_geo@data[over(ct_geo, to_geo),]

head(over(to_geo, ct_geo))
ct_geo[to_geo,]

plot(to_geo)
plot(ct_geo_to)
