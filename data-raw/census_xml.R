doc2 <- xml2::read_xml("data-raw/census.xml")
ns <- xml2::xml_ns(doc2)
to_nodes <- "//*[@concept = 'GEO' and @value = '35535']/../.."
years <- as.integer(xml2::xml_text(xml2::xml_find_all(doc2, stringr::str_c(to_nodes, "/generic:Obs/generic:Time"), ns)))
values <- as.integer(xml2::xml_attr(xml2::xml_find_all(doc2, stringr::str_c(to_nodes, "/generic:Obs//*[@value]"), ns), "value"))
labels <- as.integer(xml2::xml_attr(xml2::xml_find_all(doc2, stringr::str_c(to_nodes, "/generic:SeriesKey/generic:Value"), ns), "value"))
data <- data.frame(matrix(labels, ncol = 3, byrow = TRUE))
names(data) <- c("geo", "MTNDr", "Sex")
data$years <- years
data$values <- values

struct <- xml2::read_xml("data-raw/structure.xml")
mtndr_num <- xml2::xml_attr(xml2::xml_find_all(struct, "//*/structure:CodeList [@id='CL_MTNDR']/structure:Code", xml2::xml_ns(struct)), "value")
mtndr_desc <- xml2::xml_text(
  xml2::xml_find_all(struct, "//*/structure:CodeList [@id='CL_MTNDR']/structure:Code/structure:Description [@xml:lang='en']", xml2::xml_ns(struct))
  )
structure <- data.frame(code = mtndr_num, description = mtndr_desc)
