library(toCensus)
polling <- import_polling()
agents <- to_voters(voters, 100000)
agents <- dplyr::left_join(agents, polling)

library(dplyr)
summary_agents <- agents %>%
  group_by(Geo_Code) %>%
  summarize(Engagement=mean(Engagement))
geo_agents <- dplyr::inner_join(ct_geo, summary_agents)

library(ggmap)
library(mapproj)
toronto_map <- qmap("queens park,toronto", zoom = 10, maptype = 'terrain')
toronto_map +
  geom_polygon(aes(x=long, y=lat, group=group, fill=(1-Engagement)), alpha = 4/6, data=geo_agents) +
  scale_colour_brewer("Engagement")

# library(sp)
# library(rgdal)
# map <- readOGR(dsn = "data-raw", "gct_000b11a_e")
# map@proj4string
# map.2 <- spTransform(map, CRS("+proj=longlat
# +datum=WGS84"))
# map.2@proj4string
# mapdata <- ct_geo@data
# mapdata <- filter(mapdata, CMANAME == "Toronto")
