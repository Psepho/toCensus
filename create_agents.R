polling <- import_polling()
agents <- to_voters(voters, 10000)
agents <- dplyr::left_join(agents, polling)
geo_agents <- dplyr::inner_join(ct_geo, agents)

library(ggmap)
library(mapproj)
toronto_map <- qmap("queens park,toronto", zoom = 11, maptype = 'terrain')
toronto_map +
  geom_polygon(aes(x=long, y=lat, group=group, fill=Engagement), alpha = 5/6, data=geo_agents) +
  scale_colour_brewer("Engagement")



library(sp)
library(rgdal)
map <- readOGR(dsn = "data-raw", "gct_000a11a_e")
map@proj4string

map.2 <- spTransform(map, CRS("+proj=longlat
+datum=WGS84"))
map.2@proj4string

