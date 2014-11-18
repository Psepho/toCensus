#' Extract geocode data from the Census Tract shapefile
#'
#' Filters the geocoded data to CTs beginning with 53
#'
#' @return A dataframe containing geocode data.
geocodeCTs <- function() {
  # Census tracts -----------------------------------------------------------
  if(file.exists("data-raw/gct_000b11a_e.shp")) {
    # Nothing to do
  }  else {
    download.file("http://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/gct_000b11a_e.zip", destfile = "data-raw/gct_000a11a_e.zip")
    unzip("data-raw/gct_000b11a_e.zip", exdir="data-raw")
  }
  proj4string=sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=GRS80 +towgs84=0,0,0")
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
  ct_geo_to <- ggplot2::fortify(ct_geo_to,region="CTUID")
  ct_geo_to <- transform(ct_geo_to, id = as.numeric(id))
  names(ct_geo_to)[7] <- "Geo_Code"
  ct_geo_to$Geo_Code <- as.character(ct_geo_to$Geo_Code)
  ct_geo_to <- dplyr::left_join(ct_geo_to, toronto_cts)
  save(ct_geo_to, file = "data/cttoGEO.RData")
}
