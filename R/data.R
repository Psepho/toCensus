#' Data from the 2011 Census for Toronto.
#'
#' Cleaned and filtered Census data for the Toronto CMA.
#'
#' \itemize{
#'   \item age. Age categories
#'   \item gender. Male or female
#'   \item Geo_Code. The census tract ID
#'   \item family_income. The median family income for the CT
#'   ...
#' }
#'
#' @format A data frame with 4367115 rows and 4 variables
#' @source Statistics Canada
#' @name voters
NULL
#' Geocode data for 2011 census tracts.
#'
#' Geocoded census tract data filtered to the Toronto CMA.
#'
#' \itemize{
#'   \item long
#'   \item lat
#'   \item order
#'   \item hole
#'   \item piece
#'   \item group
#'   \item Geo_Code. The census tract ID
#'   ...
#' }
#'
#' @format A data frame with 171578 rows and 7 variables
#' @source Statistics Canada
#' @name ct_geo
NULL
