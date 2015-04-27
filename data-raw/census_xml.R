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


library(XML)
res <- lapply(xpathSApply(doc, path = to_nodes),
             function(x){
               years = xpathSApply(x, "//g:Obs/g:Time", namespaces = c(g = ns$generic$uri), xmlValue)
               values = xpathSApply(x, "/g:Obs//*[@value]", namespaces = c(g = ns$generic$uri), xmlGetAttr, "value")
               list(years=years,
                    values =values)
             })

xpathSApply(doc, "//*[@concept = 'GEO' and @value = '35535']/../../g:Series/g:Obs", namespaces = c(g = ns$generic$uri), function(x) xmlValue(xmlChildren(x)$value))


values <- as.integer(XML::xpathSApply(doc, path = "//g:Series/g:Obs//*[@value]", namespaces = c(g = ns$generic$uri), XML::xmlGetAttr, "value"))
years <- as.integer(XML::xpathSApply(doc, path = "//g:Series/g:Obs/g:Time", namespaces = c(g = ns$generic$uri), XML::xmlValue))
labels <- as.integer(XML::xpathSApply(doc, path = "//g:Series/g:SeriesKey/g:Value", namespaces = c(g = ns$generic$uri), XML::xmlGetAttr, "value"))



XML::xpathSApply(doc, path = "//*[local-name() = 'ID']", XML::xmlValue)
XML::xpathSApply(doc, path = "/x:GenericData/x:Header/x:ID", namespaces = c(x = ns[[1]]$uri), XML::xmlValue)
XML::xpathSApply(doc, path = "//g:KeyFamilyRef", namespaces = c(g = ns$generic$uri), XML::xmlValue)
XML::xpathSApply(doc, path = "//g:Series/g:Obs/g:Time", namespaces = c(g = ns$generic$uri), XML::xmlValue)
XML::xpathSApply(doc, path = "//g:Series/g:SeriesKey/g:Value", namespaces = c(g = ns$generic$uri), XML::xmlAttrs)
XML::xpathSApply(doc, path = "//g:Series", namespaces = c(g = ns$generic$uri), XML::xmlChildren)
XML::xpathSApply(doc, path = "//g:Series", namespaces = c(g = ns$generic$uri))[1]
XML::xpathSApply(doc, path = "//g:Series/g:Obs", namespaces = c(g = ns$generic$uri))
XML::xpathSApply(values[[3]], path = "//g:Time", namespaces = c(g = ns$generic$uri), XML::xmlValue)
XML::xpathSApply(values[[3]], path = "//g:ObsValue", namespaces = c(g = ns$generic$uri), XML::xmlGetAttr, "value")

values[2]

XML::xmlValue(values[[2]]["//g:Time"])

XML::getNodeSet(values[[2]], path = "//g:Time", namespaces = c(g = ns$generic$uri))

both_sex_nodes <- "//*[@concept = 'Sex' and @value = 1]/.."
to_doc <- doc[to_nodes]
both_sex_to <- to_doc[both_sex_nodes]
to_data <- doc["//*[@concept = 'GEO' and @value = '35535']/../*[@concept = 'Sex' and @value = 1]/../*[@concept = 'MTNDr' and @value = 1]/../../generic:Obs/generic:ObsValue/@value"]


XML::xpathSApply(doc,"//*[@concept = 'GEO' and @value = '35535']/ancestor::Series/SeriesKey")


32 median age
43 Total number of census families in private households



doc <- xml2::read_xml("census.xml")
xml2::xml_structure(xml2::xml_find_all(doc, "//*[@concept = 'GEO' and @value = '35535']/.."))


library(xml2)
to_doc <- xml_find_all(doc, "//*[@concept = 'GEO' and @value = '35535']/../*[@concept = 'Sex' and @value = 1]/../*[@concept = 'MTNDr' and @value = 1]/../../Obs/ObsValue")

xml_attrs(doc, "Concept")

xml_path(to_doc)
xml_structure(to_doc)
