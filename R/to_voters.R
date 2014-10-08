#' Sample a specific number of Toronto voters.
#'
#' Uses the toVoters dataset to sample a specific number of voters
#'
#' @param df The voters dataframe
#' @param n. The number of voters, defaults to 100
#' @param export. Should the voters be exported to csv
#' @return A dataframe containing the voters.
to_voters <- function(df, n = 100, export = FALSE){
  these_voters <-df[sample(nrow(df),n),]
  if (export) {
    write.csv(these_voters, file = "to_voters.csv")
  }
  else {

  }
  these_voters
}
