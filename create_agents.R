library(toCensus)
polling <- import_polling()
agents <- to_voters(voters, 10000)
agents <- dplyr::left_join(agents, polling)

library(dplyr)
summary_agents <- agents %>%
  group_by(Geo_Code) %>%
  summarize(Engagement=mean(Engagement))
geo_agents <- dplyr::left_join(ct_geo, agents)

library(ggmap)
library(mapproj)
toronto_map <- qmap("queens park,toronto", zoom = 11, maptype = 'terrain')
#toronto_map <- qmap("dupont and avenue, toronto", zoom = 11, maptype = 'terrain')

toronto_map +
  geom_polygon(aes(x=long, y=lat, group=group, fill=cut_interval(Engagement, n=3)), alpha = 4/6, data=geo_agents) +
  scale_fill_brewer("Engagement", labels=c("Low", "Medium", "High"), palette = "OrRd")
