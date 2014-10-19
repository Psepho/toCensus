library(toCensus)
library(dplyr)
library(reshape2)
polling <- import_polling()
agents <- to_voters(voters, 10)

candidates <- names(agents)[8:10]
cast_vote <- function(agent, candidates, n = 1) {
  support <- sample(candidates, n, replace = TRUE, prob = agent[8:10])
  vote <- ifelse(runif(n) > agent[, 11], 0, 1)
  data.frame(support = support, vote = vote)
  vote
}
agent[8:10]
lapply(agents, cast_vote, n = 1)
do(agents, cast_vote(., candidates))

mutate(agents, vote = cast_vote())
regions <- ct_geo %>%
  group_by(Geo_Code, region) %>%
  select() %>%
  distinct()

agents <- dplyr::left_join(agents, regions)
agents <- dplyr::left_join(agents, polling)
agents <- agents %>%
  select(Geo_Code, Tory:Engagement)
melted <- melt(agents)

summary_agents <- melted %>%
  group_by(Geo_Code, variable) %>%
  summarise(value = mean(value))
geo_agents <- dplyr::left_join(ct_geo, summary_agents)

engagement <- geo_agents %>%
  filter(variable == "Engagement")
support <- geo_agents %>%
  filter(variable != "Engagement")

library(ggmap)
library(mapproj)
toronto_map <- qmap("queens park,toronto", zoom = 11, color = "bw", maptype = 'terrain', extent = 'device', legend = "bottomright", source = "google")

toronto_map +
  geom_polygon(aes(x=long, y=lat, group=group, fill=cut_interval(value, n=3)), alpha = 4/6, data=engagement) +
  scale_fill_brewer("Engagement", labels=c("Low", "Medium", "High"), palette = "OrRd")

toronto_map +
  geom_polygon(aes(x=long, y=lat, group=group, fill=cut_interval(value, n=5)), alpha = 4/6, data=support) +
  scale_fill_brewer("Support", labels=c("Low", "", "", "", "High"), palette = "OrRd") +
  facet_wrap(~variable)
