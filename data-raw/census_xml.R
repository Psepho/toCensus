doc <- XML::xmlParse("data-raw/census.xml")
ns <- XML::xmlNamespaceDefinitions(doc)
to_nodes <- "//*[@concept = 'GEO' and @value = '35535']/../.."
#to_doc <- XML::xpathSApply(doc, path = to_nodes)

years <- as.integer(XML::xpathSApply(doc, path = stringr::str_c(to_nodes, "/g:Obs/g:Time"), namespaces = c(g = ns$generic$uri), XML::xmlValue))
values <- as.integer(XML::xpathSApply(doc, path = stringr::str_c(to_nodes, "/g:Obs//*[@value]"), namespaces = c(g = ns$generic$uri), XML::xmlGetAttr, "value"))
labels <- as.integer(XML::xpathSApply(doc, path = stringr::str_c(to_nodes, "/g:SeriesKey/g:Value"), namespaces = c(g = ns$generic$uri), XML::xmlGetAttr, "value"))
data <- data.frame(matrix(labels, ncol = 3, byrow = TRUE))
names(data) <- c("geo", "MTNDr", "Sex")
data$years <- years
data$values <- values


doc2 <- xml2::read_xml("data-raw/census.xml")
years <- as.integer(xml2::xml_text(xml2::xml_find_all(doc2, stringr::str_c(to_nodes, "/generic:Obs/generic:Time"), xml2::xml_ns(doc2))))
values <- as.integer(xml2::xml_attr(xml2::xml_find_all(doc2, stringr::str_c(to_nodes, "/generic:Obs//*[@value]"), xml2::xml_ns(doc2)), "value"))
labels <- as.integer(xml2::xml_attr(xml2::xml_find_all(doc2, stringr::str_c(to_nodes, "/generic:SeriesKey/generic:Value"), xml2::xml_ns(doc2)), "value"))
data <- data.frame(matrix(labels, ncol = 3, byrow = TRUE))
names(data) <- c("geo", "MTNDr", "Sex")
data$years <- years
data$values <- values
