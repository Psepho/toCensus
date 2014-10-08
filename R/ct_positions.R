#' Estimate left-right score for each census tract.
#'
#' Uses the candidate positions data to estimate left-right scores
#'
#' @return A dataframe containing the results from each worksheet.
ct_positions <- function(){
  library(toVotes)
  ctuid <- transform(ctuid, year = as.factor(ctuid$year))
  ctuid <- dplyr::select(ctuid, CTUID:area)
  ct_votes <- dplyr::left_join(toVotes, ctuid)
  load("/Users/routlema/Documents/GitHub/toronto_elections/data/candidate_positions.RData")
  candidate_positions <- dplyr::select(candidate_positions, candidate, year, left_right_score)
  ct_votes <- dplyr::left_join(candidate_positions,ct_votes)
  ct_votes <- dplyr::filter(ct_votes, year != "2014")
  ct_votes <- ct_votes %>% dplyr::group_by(ward, area, CTUID) %>%
    dplyr::summarize(weighted_score = weighted.mean(left_right_score, votes))
  rm(ctuid, candidate_positions)
  ct_votes
}
