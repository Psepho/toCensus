library(toCensus)
library(dplyr)
library(reshape2)
regions <- ct_geo %>% # To join agents to regions for polling data
  group_by(Geo_Code, region) %>%
  select() %>%
  distinct()
polling <- import_polling()
n <- 1000000 # Number of voters to sample
sim <- 100 # Number of iterations to run
# Create the agents for each sim
sims <- rep(1:sim, each = n)
agents <- to_voters(voters, n)
for (i in 2:sim) {
  agents <- rbind_list(agents, to_voters(voters, n))
}
agents <- data.frame(sim = sims, agents)
agents <- dplyr::left_join(agents, regions)
agents <- dplyr::left_join(agents, polling)
agents <- agents[!is.na(agents$Engagement),]
agents <- agents %>% # Drop the demographics, now that we've joined with polls
  select(Geo_Code, sim, Tory, Ford, Chow, Engagement)
candidates <- names(agents)[3:5] # List to choose from
agents$vote <- ifelse(runif(dim(agents)[1]) > agents$Engagement, 0, 1) # Vector indicating if they vote
cast_vote <- function(agents) {
  sample(candidates, 1, replace = TRUE, prob=agents[3:5])
}
agents$support <- apply(agents, 1, cast_vote) # Each agent casts a vote

ct_summary <- agents %>%
  group_by(sim, Geo_Code, support, add = FALSE) %>%
  summarise(votes = sum(vote),
            intent = n())
ct_summary <- ct_summary %>%
  group_by(Geo_Code, support) %>%
  summarise(votes = mean(votes),
            intent = mean(intent))
total_votes <- ct_summary %>%
  group_by(support) %>%
  summarize(votes = sum(votes),
            intent = sum(intent))
prop.table(tapply(total_votes$votes, total_votes[1], sum))
total_votes$votes/total_votes$intent

geo_summary <- dplyr::left_join(ct_geo, ct_summary)

library(ggmap)
library(mapproj)
toronto_map <- qmap("queens park,toronto", zoom = 11, color = "bw", maptype = 'terrain', extent = 'device', legend = "bottomright", source = "google")

toronto_map +
  geom_polygon(aes(x=long, y=lat, group=group, fill=cut_interval(votes, n=5)), alpha = 4/6, data=filter(geo_summary, support != "NA")) +
  scale_fill_brewer("Votes", labels=c("Low", "", "", "", "High"), palette = "OrRd") +
  facet_wrap(~support)

toronto_map +
  geom_polygon(aes(x=long, y=lat, group=group, fill=cut_interval(intent, n=5)), alpha = 4/6, data=filter(geo_summary, support != "NA")) +
  scale_fill_brewer("Intent", labels=c("Low", "", "", "", "High"), palette = "OrRd") +
  facet_wrap(~support)
