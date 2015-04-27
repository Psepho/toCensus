doc <- XML::xmlParse("data-raw/census.xml")
to_nodes <- "//*[@concept = 'GEO' and @value = '35535']/.."
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
