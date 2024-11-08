


library(pacman)
p_load(sf, tidyr, ggplot2)

getwd()

rivers <- read_sf("data/vd_l_2016_3_RivEX.shp")

fpm_data <- read.csv("data/Margaritifera_alla.csv")

p_load(ggspatial)

fpm_data$longitude
fpm_data$latitude

ggosm(type = "cartolight", echo = T)
  


fpm_sf <- st_as_sf(fpm_data, coords = c("longitude", "latitude"), crs = 4326)

plot(fpm_sf)

plot(rivers)



ggplot(fpm_sf) + geom_sf()

p_load(rnaturalearth)

world_map <- ne_countries(returnclass = "sf",scale = 50)

ggplot(world_map) + geom_sf()

sweden_map <- world_map %>%
  dplyr::filter(admin == "Sweden") %>%        # Limit to Sweden
  st_transform(crs = 3006)             # Transform to Swedish CRS (SWEREF99TM)

fpm_3006 <- st_transform(fpm_sf, crs = 3006)

rivers_3006 <- st_transform(rivers, crs=3006)

ggplot() + 
  geom_sf(data = sweden_map, fill = "white") + 
  geom_sf(data = rivers_3006 %>% dplyr::filter(LINJEKOD != 26, COUNTRY == "SE"), color = "lightgrey") +
  geom_sf(data = fpm_3006, color = "chocolate") + 
  theme_minimal()

### Let's connect the point layer to the river line layer

nearest_features <- st_nearest_feature(fpm_3006, rivers_3006)

rivers_3006$FPM <- 0
rivers_3006$FPM[nearest_features] <- 1


ggplot() + 
  geom_sf(data = sweden_map, fill = "white") + 
  #geom_sf(data = rivers_3006 %>% dplyr::filter(LINJEKOD != 26, COUNTRY == "SE", FPM == 0), color = "lightgrey") +
  geom_sf(data = rivers_3006 %>% dplyr::filter(LINJEKOD != 26, COUNTRY == "SE", FPM == 1), color = "chocolate") +
  #geom_sf(data = fpm_3006, color = "chocolate") + 
  theme_minimal()
