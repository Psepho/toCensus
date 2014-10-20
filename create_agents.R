library(toCensus)
library(dplyr)
library(reshape2)
polling <- import_polling()
agents <- to_voters(voters, 1000000)

regions <- ct_geo %>%
  group_by(Geo_Code, region) %>%
  select() %>%
  distinct()

agents <- dplyr::left_join(agents, regions)
agents <- dplyr::left_join(agents, polling)
agents <- agents[!is.na(agents$Engagement),]

candidates <- names(agents)[8:10]
agents$support <- NA
agents$vote <- NA
for (i in 1:dim(agents)[1]) {
  agents$support[i] <- sample(candidates, 1, replace = TRUE, prob = agents[i, 8:10])
  agents$vote[i] <- ifelse(runif(1) > agents[i, 11], 0, 1)
}

ct_summary <- agents %>%
  group_by(Geo_Code, support) %>%
  transmute(votes = sum(vote))

geo_summary <- dplyr::left_join(ct_geo, ct_summary)

library(ggmap)
library(mapproj)
toronto_map <- qmap("queens park,toronto", zoom = 11, color = "bw", maptype = 'terrain', extent = 'device', legend = "bottomright", source = "google")

toronto_map +
  geom_polygon(aes(x=long, y=lat, group=group, fill=cut_interval(votes, n=5)), alpha = 4/6, data=geo_summary) +
  scale_fill_brewer("Votes", labels=c("Low", "", "", "", "High"), palette = "OrRd") +
  facet_wrap(~support)
