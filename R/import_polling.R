#' Import polling data from an Excel file
#'
#' Imports the polling data, broken down by agent characteristics
#'
#' @return A dataframe containing the polling breakdown.
import_polling <- function() {
  filename <- "data-raw/Polling data for agents.xlsx"
  sheetname <- "Groupings"
  workbook <- XLConnect::loadWorkbook(filename)
  polling <- data.frame(XLConnect::readWorksheet(object=workbook, sheetname, startRow = 2, useCachedValues = TRUE))
  names(polling) <- c("gender", "age_range", "region", "income_range", "Tory", "Ford", "Chow", "Engagement")
  polling <- transform(polling, gender = as.factor(gender), income_range = as.factor(income_range), age_range = as.factor(age_range))
  polling <- dplyr::group_by(polling, gender, age_range, income_range)
  polling <- dplyr::summarise(polling, Tory = mean(Tory), Ford = mean(Ford), Chow = mean(Chow), Engagement = mean(Engagement))
  polling
}
