library(toCensus)
library(dplyr)
library(reshape2)
polling <- import_polling()
n <- 100000
sim <- 10
agents <- to_voters(voters, n)
agents$sim <- 1
for (i in 2:sim) {
  new_agents <- to_voters(voters, n)
  new_agents$sim <- i
  agents <- rbind(agents, new_agents)
}

regions <- ct_geo %>%
  group_by(Geo_Code, region) %>%
  select() %>%
  distinct()

agents <- dplyr::left_join(agents, regions)
agents <- dplyr::left_join(agents, polling)
agents <- agents[!is.na(agents$Engagement),]

agents <- agents %>%
  select(Geo_Code, sim, Tory, Ford, Chow, Engagement)

candidates <- names(agents)[3:5]
agents$support <- NA
agents$vote <- NA
for (i in 1:dim(agents)[1]) {
  agents$support[i] <- sample(candidates, 1, replace = TRUE, prob = agents[i, 3:5])
  agents$vote[i] <- ifelse(runif(1) > agents[i, 6], 0, 1)
}

ct_summary <- agents %>%
  group_by(sim, Geo_Code, support, add = FALSE) %>%
  summarise(votes = sum(vote))
ct_summary <- ct_summary %>%
  group_by(Geo_Code, support) %>%
  summarise(votes = mean(votes),
            error = sd(votes, na.rm = TRUE))
total_votes <- ct_summary %>%
  group_by(support) %>%
  summarize(votes = sum(votes))
prop.table(tapply(total_votes$votes, total_votes[1], sum))

geo_summary <- dplyr::left_join(ct_geo, ct_summary)

library(ggmap)
library(mapproj)
toronto_map <- qmap("queens park,toronto", zoom = 11, color = "bw", maptype = 'terrain', extent = 'device', legend = "bottomright", source = "google")

toronto_map +
  geom_polygon(aes(x=long, y=lat, group=group, fill=cut_interval(votes, n=5)), alpha = 4/6, data=filter(geo_summary, support != "NA")) +
  scale_fill_brewer("Votes", labels=c("Low", "", "", "", "High"), palette = "OrRd") +
  facet_wrap(~support)
