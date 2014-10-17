import_toronto_cts <- function() {
  data <- read.csv("data-raw/Toronto_CTs.csv")
#   toronto_cts <- as.character(sprintf("%.2f", as.numeric(data$CTUID)))
  toronto_cts <- data.frame(Geo_Code = as.character(data$CTUID), ward = data$ward, region = data$region, stringsAsFactors=FALSE)
  save(toronto_cts, file = "data/torontoCTs.RData")
}
