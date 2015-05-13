#http://www12.statcan.gc.ca/census-recensement/2011/dp-pd/tbt-tt/OpenDataDownload.cfm?PID=102006
census_xml <- xml2::read_xml("data-raw/98-311-XCB2011019/Generic_98-311-XCB2011019.xml")
ns <- xml2::xml_ns(census_xml)
to_nodes <- "//d1:GenericData/d1:DataSet/generic:Series/generic:SeriesKey/*[@concept = 'GEO' and starts-with(@value, '535')]/../.."
years <- as.integer(xml2::xml_text(xml2::xml_find_all(census_xml, stringr::str_c(to_nodes, "/generic:Obs/generic:Time"), ns)))
values <- as.integer(xml2::xml_attr(xml2::xml_find_all(census_xml, stringr::str_c(to_nodes, "/generic:Obs//*[@value]"), ns), "value"))
labels <- as.integer(xml2::xml_attr(xml2::xml_find_all(census_xml, stringr::str_c(to_nodes, "/generic:SeriesKey/generic:Value"), ns), "value"))
toCensus <- data.frame(matrix(labels, ncol = 3, byrow = TRUE))
names(toCensus) <- c("geo", "MTNDr", "Sex")
toCensus$years <- years
toCensus$values <- values
rm(census_xml, labels, values, years)

struct <- xml2::read_xml("data-raw/98-311-XCB2011019/Structure_98-311-XCB2011019.xml")
mtndr_num <- xml2::xml_attr(xml2::xml_find_all(struct, "//*/structure:CodeList [@id='CL_MTNDR']/structure:Code", xml2::xml_ns(struct)), "value")
mtndr_desc <- xml2::xml_text(
  xml2::xml_find_all(struct, "//*/structure:CodeList [@id='CL_MTNDR']/structure:Code/structure:Description [@xml:lang='en']", xml2::xml_ns(struct))
  )
structure <- data.frame(code = mtndr_num, description = mtndr_desc)
