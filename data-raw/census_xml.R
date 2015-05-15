#http://www12.statcan.gc.ca/census-recensement/2011/dp-pd/tbt-tt/OpenDataDownload.cfm?PID=102006
census_xml <- xml2::read_xml("data-raw/98-311-XCB2011019/Generic_98-311-XCB2011019.xml")
ns <- xml2::xml_ns(census_xml)
to_nodes <- "//d1:GenericData/d1:DataSet/generic:Series/generic:SeriesKey/*[@concept = 'GEO' and starts-with(@value, '535')]/../.."
years <- as.integer(xml2::xml_text(xml2::xml_find_all(census_xml, stringr::str_c(to_nodes, "/generic:Obs/generic:Time"), ns)))
values <- as.integer(xml2::xml_attr(xml2::xml_find_all(census_xml, stringr::str_c(to_nodes, "/generic:Obs//*[@value]"), ns), "value"))
labels <- as.integer(xml2::xml_attr(xml2::xml_find_all(census_xml, stringr::str_c(to_nodes, "/generic:SeriesKey/generic:Value"), ns), "value"))
toCensus <- dplyr::data_frame(matrix(labels, ncol = 3, byrow = TRUE))
names(toCensus) <- c("geo", "CL_AGE", "CL_SEX")
toCensus$years <- years
toCensus$values <- values
rm(census_xml, labels, values, years)

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
structure_file <- "data-raw/98-311-XCB2011019/Structure_98-311-XCB2011019.xml"
age_structure <- extract_structure("CL_AGE", structure_file)
sex_structure <- extract_structure("CL_SEX", structure_file)

toCensus <- dplyr::left_join(toCensus, age_structure)
toCensus <- dplyr::left_join(toCensus, sex_structure)
toCensus <- dplyr::select(toCensus, geo, years, values, age, sex)
rm(age_structure, sex_structure)

devtools::use_data(toCensus, overwrite = TRUE)
