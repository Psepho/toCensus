#' Extract specified structure from a census XML file.
#'
#' @param attr The attribute to extract
#' @param file The XML file containing the structure
#' @return A dataframe containing the attributes.
#'
extract_structure <- function(attr, file) {
  struct <- xml2::read_xml(file)
  ns <- xml2::xml_ns(struct)
  num <- xml2::xml_attr(
    xml2::xml_find_all(struct, stringr::str_c("//*/structure:CodeList [@id='", attr, "']/structure:Code"), ns),
    "value")
  desc <- stringr::str_trim(xml2::xml_text(
    xml2::xml_find_all(struct, stringr::str_c("//*/structure:CodeList [@id='", attr, "']/structure:Code/structure:Description [@xml:lang='en']"), ns)
  ))
  df <- dplyr::data_frame(as.integer(num), desc)
  colnames(df) <- c(make.names(attr), stringr::str_to_lower(stringr::str_replace(make.names(attr), "CL_", "")))
  df
}

#' Create list of files for XML parsing
#'
#' @param data_table A reference number for the Statistics Canada datatable
#' @return list A list containg two file paths: one for the values and one for the structure
#'
file_list <- function(data_table) {
  xml_file <- stringr::str_c("data-raw/98-311-XCB2011019/Generic_", data_table, ".xml")
  structure_file <- stringr::str_c("data-raw/98-311-XCB2011019/Structure_", data_table, ".xml")
  list(xml_file = xml_file, structure_file = structure_file)
}

# All Toronto census tracts start with 535
to_nodes <- "//d1:GenericData/d1:DataSet/generic:Series/generic:SeriesKey/*[@concept = 'GEO' and starts-with(@value, '535')]/../.."

# Age and sex data --------------------------------------------------------

data_table <- "98-311-XCB2011019"
files <- file_list(data_table)
census_xml <- xml2::read_xml(files$xml_file)
ns <- xml2::xml_ns(census_xml)
years <- as.integer(xml2::xml_text(xml2::xml_find_all(census_xml, stringr::str_c(to_nodes, "/generic:Obs/generic:Time"), ns)))
values <- as.integer(xml2::xml_attr(xml2::xml_find_all(census_xml, stringr::str_c(to_nodes, "/generic:Obs//*[@value]"), ns), "value"))
labels <- as.integer(xml2::xml_attr(xml2::xml_find_all(census_xml, stringr::str_c(to_nodes, "/generic:SeriesKey/generic:Value"), ns), "value"))
toCensus <- dplyr::data_frame(matrix(labels, ncol = 3, byrow = TRUE))
names(toCensus) <- c("geo", "CL_AGE", "CL_SEX")
toCensus$years <- years
toCensus$values <- values
rm(census_xml, labels, values, years)

# Extract age and sex structure
age_structure <- extract_structure("CL_AGE", files$structure_file)
sex_structure <- extract_structure("CL_SEX", files$structure_file)
# Join values with structure
toCensus <- dplyr::left_join(toCensus, age_structure)
toCensus <- dplyr::left_join(toCensus, sex_structure)
toCensus <- dplyr::select(toCensus, geo, years, values, age, sex)
rm(age_structure, sex_structure)

# devtools::use_data(toCensus, overwrite = TRUE)
