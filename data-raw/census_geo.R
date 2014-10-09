#' Extract geocode data from the Census Tract shapefile
#'
#' Filters the geocoded data to CTs beginning with 53
#'
#' @return A dataframe containing geocode data.
geocodeCTs <- function() {
#   download.file("http://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/gct_000a11a_e.zip", destfile = "data-raw/gct_000a11a_e.zip")
  unzip("data-raw/gct_000a11a_e.zip", exdir="data-raw")
  ct_geo <- maptools::readShapeSpatial("data-raw/gct_000a11a_e", proj4string=sp::CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"))
  ct_geo <- ggplot2::fortify(ct_geo,region="CTUID")
  ct_geo <- transform(ct_geo, id = as.numeric(id))
  names(ct_geo)[7] <- "Geo_Code"
  ct_geo <- dplyr::filter(ct_geo, grepl('^535', Geo_Code))
  save(ct_geo, file = "data/ctGEO.RData")
}
