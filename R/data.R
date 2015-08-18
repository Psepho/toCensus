#' Data from the 2011 Census for Toronto.
#'
#' Cleaned and filtered Census data for the Toronto CMA.
#'
#' \itemize{
#'   \item Geo_Code. The census tract ID
#'   \item ward. The city ward for the tract
#'   \item region. The region of the tract
#'   \item age. Age categories
#'   \item gender. Male or female
#'   \item family_income. The median family income for the CT
#'   \item income_range. An ordered factor for income
#'   \item age_range. An ordered factor for age
#'   ...
#' }
#'
#' @format A data frame with 2116555 rows and 8 variables
#' @source Statistics Canada
#' @name toCensus
NULL
#' Geocode data for 2011 census tracts.
#'
#' Geocoded census tract data filtered to the City of Toronto.
#'
#' \itemize{
#'   \item long
#'   \item lat
#'   \item order
#'   \item hole
#'   \item piece
#'   \item group
#'   \item Geo_Code. The census tract ID
#'   \item ward. The city ward for the tract
#'   \item region. The region of the tract
#'   ...
#' }
#'
#' @format A data frame with 65906 rows and 9 variables
#' @source Statistics Canada
#' @name ct_geo_to
NULL
