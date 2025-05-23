# Importing data from OTN to ACTEL
getwd() #check working directory 

# Load libraries ---------------------------------------------------------------
remotes::install_github("hugomflavio/actel", build_opts = c("--no-resave-data", "--no-manual"), build_vignettes = TRUE)
#install.packages("actel")
library(tidyverse) # Tidyverse (data cleaning and arrangement)
library(actel)
library(lubridate)# Lubridate - same group as Tidyverse, improves the process of creating date objects
library(readr) # #read_csv() is from tidyverse's readr package --> you can also use read.csv() from base R but it created a dataframe (not tibble) so loads slower
library(ggmap)# GGmap - complimentary to ggplot2, which is in the Tidyverse
library(sp) #SP and Raster packages for mapping.
library(raster)
#devtools::install_github("afsc-gap-products/akgfmaps", build_vignettes = TRUE)

# Importing data- import files into R ------------------------------------------
# (minimum requirement are biomentric, spatial,deployment, and detentions to use the preload() function. Optionalfiles include Distance matrix and Spatial.txt)

## Time format: ----------------------------------------------------------------
# All dates will be supplied to Actel in this format:

actel_datefmt = '%Y-%m-%d %H:%M:%S'

## Biometric file: -------------------------------------------------------------

##This table contains two columns:
##Release.date: Corresponds to the date and time when the animal was released, and must be typed in yyyy-mm-dd hh:mm:ss format. Note that the timestamps must be in the local time zone of the study area, which you will later supply in the tz argument.
##Signal: Corresponds to the code emitted by your tags. If you are unsure as to what signals are, you should ask the tag manufacturer more about the differences between code spaces and signals.

biometric <- read_csv("data/biometric.csv")
biometric$Signal <- as.integer(biometric$Signal)

head(biometric)
str(biometric)
# Importing data from OTN to ACTEL
getwd() #check working directory 

# Load libraries ---------------------------------------------------------------
remotes::install_github("hugomflavio/actel", build_opts = c("--no-resave-data", "--no-manual"), build_vignettes = TRUE)
library(tidyverse) # Tidyverse (data cleaning and arrangement)
library(actel)
library(lubridate)# Lubridate - same group as Tidyverse, improves the process of creating date objects
library(readr) # #read_csv() is from tidyverse's readr package --> you can also use read.csv() from base R but it created a dataframe (not tibble) so loads slower
library(ggmap)# GGmap - complimentary to ggplot2, which is in the Tidyverse
library(sp) #SP and Raster packages for mapping.
library(raster)
library(gWidgets2tcltk)
#devtools::install_github("afsc-gap-products/akgfmaps", build_vignettes = TRUE)

# Importing data- import files into R ------------------------------------------
# (minimum requirement are biomentric, spatial,deployment, and detentions to use the preload() function. Optionalfiles include Distance matrix and Spatial.txt)

## Time format: ----------------------------------------------------------------
# All dates will be supplied to Actel in this format:

actel_datefmt = '%Y-%m-%d %H:%M:%S'

## Biometric file: -------------------------------------------------------------

##This table contains two columns:
##Release.date: Corresponds to the date and time when the animal was released, and must be typed in yyyy-mm-dd hh:mm:ss format. Note that the timestamps must be in the local time zone of the study area, which you will later supply in the tz argument.
##Signal: Corresponds to the code emitted by your tags. If you are unsure as to what signals are, you should ask the tag manufacturer more about the differences between code spaces and signals.

biometric <- read_csv("data/biometric.csv")
biometric$Signal <- as.integer(biometric$Signal)

head(biometric)
str(biometric)

## Spatial file: --------------------------------------------------------------

##This file should include both station deployment sites and release sites. It is essential that this table has the following columns:
##Station.name: The name of the station will be used to match the receiver deployments.

##Array:
#- If you are listing a station: The array to which the station belongs.
#- If you are listing a release site: The first array(s) that the animal is expected to cross after being released.
#Note: The release sites must have exactly the same names in the biometrics table and in the spatial table. If there is a mismatch, actel will stop.

#Section: The study area section to which the hydrophone station belongs. Leave empty for the release sites.

#Type: The nature of the item you are listing. You must choose between "Hydrophone" or "Release".

spatial <- read_csv("data/spatial.csv")
head(spatial)
str(spatial)

## Deployments file: -----------------------------------------------------------

#Receiver: The serial number of the receiver. If a receiver was retrieved and re-deployed, you should add extra rows for each deployment.
#Station.name: The name of the station where the receiver was deployed. It must match one of the station names in the spatial file.
#Start and Stop: The times when the receiver was deployed and when the receiver was retrieved, respectively. Must be in a yyyy-mm-dd hh:mm:ss format. Note that these timestamps must be in the local time zone of the study area, which you will later supply in the tz argument

deployments <- read_csv("data/deployments.csv")
head(deployments)
str(deployments)

## Detentions: -----------------------------------------------------------------
raw_detections <- readr::read_csv("data/alb_matched_detections_2021.csv", guess_max=60000) 

detections_otn<-dplyr::select(raw_detections, "receiver","codespace","tagname", "sensorraw", "sensorunit","datecollected", "sensorname") |> 
  mutate(Receiver = as.character(receiver),
         CodeSpace = as.character(codespace),
         tagname = as.character(tagname),
         Sensor.Value = as.character(sensorraw),
         Sensor.Unit = as.character(sensorunit), 
         Timestamp = raw_detections$datecollected,
         Signal = as.integer(stringr::str_extract(sensorname, "(?<=-)[^-]*$")) #Use this instead of actel's function to extract the signals: as.numeric(stringr::str_extract(COLUMN, "(?<=-)[^-]*"))
         
  ) |>
  filter(!is.na(Signal)) #So trying to convert Signal from Char to Intiger and then remove the NA's 

str(detections_otn)
head(detections_otn)


## Distances matrix: ----------------------------------------------------------
#Needs to be developed

#A distances matrix is a table that contains information on the distance (in metres) between every pair of spatial elements the study area 
#Matrix is symmetric (i.e. the entries of the matrix are symmetric with respect to the main diagonal).
#The diagonal line is composed of 0's as it represents the distance between an element and itself.
#Must have at least one release site, and the names of the release sites must be identical to those in your 'spatial.csv' and your 'biometrics.csv'.

#To avoid doing this manually, you can get R to do it for you. Here's what you need:
# A shapefile with a land polygon of your study area.The coordinates of your receivers and release sites in the same coordinate system as the shapefile.

## Distances matrix: ----------------------------------------------------------
dot_string <- 
  "A -- C -- D -- E -- F
A -- B -- C
D -- F"
dot <- readDot(string = dot_string)
plotDot(dot)

## Preload data ----------------------------------------------------------------

# Now that we have the R objects created, we can run preload:
x <- preload(biometrics = biometric, deployments = deployments, spatial = spatial, detections = detections_otn, dot = dot_string, tz = "UTC") #OlsonNames(tzdir = NULL) # Use following to get list: OlsonNames(tzdir = NULL), so local is: US/Alaska

results <- explore(datapack = x)

#which(is.na(detections_otn$Timestamp))
#detections_otn[which(is.na(detections_otn$Timestamp)), ]




# Map --------------------------------------------------------------------------

PKG <- c(
  
  "devtools",
  
  "ggplot2", # Create Elegant Data Visualizations Using the Grammar of Graphics
  "scales", # nicer labels in ggplot2
  "ggthemes",
  "sf",
  "ggspatial",
  "maps",
  "tidyr",
  "plyr",
  "dplyr",
  "magrittr",
  "readxl",
  "stringr",
  "stringi",
  # "akgfmaps", # RACE-GAP Specific # devtools::install_github("afsc-gap-products/akgfmaps", build_vignettes = TRUE)
  "pingr", # check website links
  "httr", # check website links
  "flextable" # making pretty tables
)

PKG <- unique(PKG)
for (p in PKG) {
  if(!require(p,character.only = TRUE)) {
    if (p == "akgfmaps") {
      devtools::install_github("afsc-gap-products/akgfmaps", build_vignettes = TRUE)
    } else {
      install.packages(p)
    }
    require(p,character.only = TRUE)}
}

devtools::install_github("afsc-gap-products/akgfmaps", build_vignettes = TRUE)

## Define CRS ------------------------------------------------------------------

crs_out <- "EPSG:3338"
crs_in <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"

## Get world map ---------------------------------------------------------------

world_coordinates <- maps::map("world", plot = FALSE, fill = TRUE) %>% 
  sf::st_as_sf() %>%
  # sf::st_union() %>% 
  sf::st_transform(crs = crs_out) %>% 
  dplyr::filter(ID %in% c("USA", "Russia", "Canada")) %>% 
  dplyr::mutate(ID = ifelse(ID == "USA", "Alaska", ID))

## Get place labels for map ----------------------------------------------------

place_labels <- data.frame(
  type = c("islands", "islands", "islands", "islands", 
           "mainland", "mainland", "mainland", 
           "convention line", "peninsula", 
           "survey", "survey", "survey", "survey", "survey"), 
  lab = c("Pribilof Isl.", "Nunivak", "St. Matthew", "St. Lawrence", 
          "Alaska", "Russia", "Canada", 
          "U.S.-Russia Maritime Boundary", "Alaska Peninsula", 
          "Aleutian Islands", "Gulf of Alaska", 
          "Bering\nSea\nSlope", "Eastern\nBering Sea", "Northern\nBering Sea"), 
  angle = c(0, 0, 0, 0, 0, 0, 0, 30, 45, 0, 0, 0, 0, 0), 
  lat = c(57.033348, 60.7, 61, 64.2, 
          62.296686, 62.798276, 63.722890, 
          62.319419, 56.352495, 
          53.25, 54.720787, 
          57, 57.456912, 63.905936), 
  lon = c(-167.767168, -168, -174, -170.123016, 
          -157.377210, 173.205231, -136.664024, 
          -177.049063, -159.029430, 
          -173, -154.794131, 
          -176, -162, -165)) %>%
  dplyr::filter(type != "peninsula") %>% 
  dplyr::filter(type != "survey") %>% 
  # dplyr::mutate(
  #   color = dplyr::case_when(
  #     type == "mainland" ~ "grey80", 
  #     TRUE ~ "grey30"), 
  #   fontface = dplyr::case_when(
  #     type == "mainland" ~ "bold", 
  #     TRUE ~ "regular"),
  #   size = dplyr::case_when(
  #     type == "mainland" ~ 3, 
  #     TRUE ~ 2) ) %>% 
  sf::st_as_sf(coords = c("lon", "lat"),
               crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0") %>%
  sf::st_transform(crs = crs_out) 

## Determine map boundaries ----------------------------------------------------

boundaries <- data.frame(lon = c(-153, -152), # c(-180, -140)
                         lat = c(57.5, 58) )  %>% # c(46, 66)
  sf::st_as_sf(coords = c("lon", "lat"),
               crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0") %>%
  sf::st_transform(crs = crs_out) %>% 
  sf::st_coordinates() %>% 
  data.frame()

## Inport Groundfish Bottom Trawl Survey shapefiles (akgfmaps) -----------------

# shp_ebs <- akgfmaps::get_base_layers(select.region = "bs.south", set.crs = "auto")
# shp_nbs <- akgfmaps::get_base_layers(select.region = "bs.north", set.crs = "auto")
# shp_ai <- akgfmaps::get_base_layers(select.region = "ai", set.crs = "auto")
# shp_ai$survey.strata$Stratum <- shp_ai$survey.strata$STRATUM
# shp_goa <- akgfmaps::get_base_layers(select.region = "goa", set.crs = "auto")
# shp_goa$survey.strata$Stratum <- shp_goa$survey.strata$STRATUM
# shp_bss <- akgfmaps::get_base_layers(select.region = "ebs.slope", set.crs = "auto")
# 
# shp_all <- dplyr::bind_rows(list(
#   shp_ebs$survey.area %>%
#                     sf::st_transform(crs = crs_out) %>%
#     dplyr::mutate(SURVEY = "EBS"),
#   shp_nbs$survey.area %>%
#     sf::st_transform(crs = crs_out) %>%
#     dplyr::mutate(SURVEY = "NBS"),
#   shp_ai$survey.area %>%
#     sf::st_transform(crs = crs_out) %>%
#     dplyr::mutate(SURVEY = "AI"),
#   shp_goa$survey.area %>%
#     sf::st_transform(crs = crs_out) %>%
#     dplyr::mutate(SURVEY = "GOA"),
#   shp_bss$survey.area %>%
#                     sf::st_transform(crs = crs_out) %>%
#     dplyr::mutate(SURVEY = "BSS"))) %>%
#   dplyr::select(Survey = SURVEY, geometry)


## wrangle data for plot funsies -----------------------------------------------

dat <- spatial  %>% 
  sf::st_as_sf(coords = c("Longitude", "Latitude"), 
               remove = FALSE,
               crs = crs_in) %>%
  sf::st_transform(crs = crs_out)


# Being mapping -----------------------

p21 <- ggplot2::ggplot() +
  
  ### Map shapefile aesthetics ----------------------------------
# Manage Axis extents (limits) and breaks
ggplot2::geom_sf(data = world_coordinates,
                 fill = "grey10",
                 color = "grey20")  + 
  ggplot2::scale_x_continuous(name = "Longitude °W",
                              breaks = seq(-180, -150, 1)) +
  ggplot2::scale_y_continuous(name = "Latitude °N",
                              breaks = seq(50, 65, 1)) + # seq(52, 62, 2)
  
  ggplot2::geom_sf_text(
    data = place_labels %>% dplyr::filter(type == "mainland"),
    mapping = aes(label = lab, angle = angle), 
    color = "grey60", 
    size = 3, 
    show.legend = FALSE) + 
  ggplot2::geom_sf_text(
    data = place_labels %>% dplyr::filter(type == "survey"),
    mapping = aes(label = lab, angle = angle), 
    color = "black",
    fontface = "bold",
    size = 2, 
    show.legend = FALSE) + 
  ggplot2::geom_sf_text(
    data = place_labels %>% dplyr::filter(!(type %in% c("mainland", "survey"))),
    mapping = aes(label = lab, angle = angle), 
    color = "grey10", 
    fontface = "italic", 
    size = 2, 
    show.legend = FALSE) +
  
  ### Plot data ----------------------------------------------------------------

# ggplot2::geom_sf(
#   data = roms_dat_lines, 
#   mapping = aes(
#     color = depth_m,
#     # linetype = depth_m, 
#     geometry = geometry), 
#   alpha = 0.7,
#   linewidth = 2) + 
ggplot2::geom_sf(
  data = dat,
  mapping = aes(
    shape = Section,
    color = Type,
    geometry = geometry),
  alpha = 0.7,
  size = 3) +
  #   ggplot2::facet_wrap(~date) +
  ggplot2::scale_color_viridis_d(name = "Type", option = "D", begin = .2, end = .8) +
  #   ggplot2::ggtitle(label = "Juvenile Grenider Modeled ROMS Dispersal", 
  #                    subtitle = "At different depths, years, and environmental conditions") + 
  ggplot2::scale_shape_discrete(name = "Section",
                                na.value = NA,
                                na.translate = FALSE) +
  
  ### Plot aesthetics ----------------------------------
ggplot2::coord_sf(xlim = boundaries$X,
                  ylim = boundaries$Y) +
  ggplot2::theme_bw() +
  ggplot2::theme(
    plot.margin=unit(c(0,0,0,0), "cm"), 
    strip.background = element_rect(fill = "transparent", colour = "white"), 
    strip.text = element_text(face = "bold"), # , family = font0
    panel.border = element_rect(colour = "grey20", linewidth = .25, fill = NA),
    panel.background = element_rect(fill = "white"), 
    panel.grid = element_line(colour="grey80", linewidth = 0.5), 
    plot.title = element_text(face = "bold"), # , size = 12, family = font0
    axis.text = element_text(face = "bold"), # , size = 12 , family = font0
    legend.key = element_blank(), 
    legend.key.width = unit(0.6, "cm"),
    legend.key.size = unit(0.6, "cm"),
    legend.title = element_text(face = "bold"), # size = 10, , family = font0
    legend.title.position = "top", 
    legend.background = element_blank(),
    # legend.text = element_text(size = 10, angle = 90),
    legend.key.spacing = unit(0.0010, 'cm'), 
    legend.position = "right", # "bottom",
    legend.text.position = "right"# "bottom"
  )




## Spatial file: --------------------------------------------------------------

##This file should include both station deployment sites and release sites. It is essential that this table has the following columns:
##Station.name: The name of the station will be used to match the receiver deployments.

##Array:
#- If you are listing a station: The array to which the station belongs.
#- If you are listing a release site: The first array(s) that the animal is expected to cross after being released.
#Note: The release sites must have exactly the same names in the biometrics table and in the spatial table. If there is a mismatch, actel will stop.

#Section: The study area section to which the hydrophone station belongs. Leave empty for the release sites.

#Type: The nature of the item you are listing. You must choose between "Hydrophone" or "Release".

spatial <- read_csv("data/spatial.csv")
head(spatial)
str(spatial)

## Deployments file: -----------------------------------------------------------

#Receiver: The serial number of the receiver. If a receiver was retrieved and re-deployed, you should add extra rows for each deployment.
#Station.name: The name of the station where the receiver was deployed. It must match one of the station names in the spatial file.
#Start and Stop: The times when the receiver was deployed and when the receiver was retrieved, respectively. Must be in a yyyy-mm-dd hh:mm:ss format. Note that these timestamps must be in the local time zone of the study area, which you will later supply in the tz argument

deployments <- read_csv("data/deployments.csv")
head(deployments)
str(deployments)

## Detentions: -----------------------------------------------------------------
raw_detections <- readr::read_csv("data/alb_matched_detections_2021.csv", guess_max=60000) 

detections_otn<-dplyr::select(raw_detections, "receiver","codespace","tagname", "sensorraw", "sensorunit","datecollected", "sensorname") |> 
  mutate(Receiver = as.character(receiver),
         CodeSpace = as.character(codespace),
         tagname = as.character(tagname),
         sensorraw = as.character(sensorraw),
         sensorunit = as.character(sensorunit), 
         datecollected = ymd_hms(raw_detections$datecollected),
         Signal = as.integer(stringr::str_extract(sensorname, "(?<=-)[^-]*$")) #Use this instead of actel's function to extract the signals: as.numeric(stringr::str_extract(COLUMN, "(?<=-)[^-]*"))
         
  ) |>
  filter(!is.na(Signal)) #So trying to convert Signal from Char to Intiger and then remove the NA's 

str(detections_otn)
head(detections_otn)


## Distances matrix: ----------------------------------------------------------
#Needs to be developed

#A distances matrix is a table that contains information on the distance (in metres) between every pair of spatial elements the study area 
#Matrix is symmetric (i.e. the entries of the matrix are symmetric with respect to the main diagonal).
#The diagonal line is composed of 0's as it represents the distance between an element and itself.
#Must have at least one release site, and the names of the release sites must be identical to those in your 'spatial.csv' and your 'biometrics.csv'.

#To avoid doing this manually, you can get R to do it for you. Here's what you need:
# A shapefile with a land polygon of your study area.The coordinates of your receivers and release sites in the same coordinate system as the shapefile.

## Distances matrix: ----------------------------------------------------------
dot_string <- 
  "A -- C -- D -- E -- F
A -- B -- C
D -- F"
dot <- readDot(string = dot_string)
plotDot(dot)

## Preload data ----------------------------------------------------------------

# Now that we have the R objects created, we can run preload:
x <- preload(biometrics = biometric, deployments = deployments, spatial = spatial, detections = detections_otn, dot = dot, tz = "UTC") #OlsonNames(tzdir = NULL) # Use following to get list: OlsonNames(tzdir = NULL), so local is: US/Alaska


recoverLog(file="actel_job_log.txt", overwrite = FALSE)
#read.table("actel_job_log.txt", stringsAsFactors = F, header = T)


head(biometric)
str(biometric)








# Map --------------------------------------------------------------------------

PKG <- c(
  
  "devtools",
  
  "ggplot2", # Create Elegant Data Visualizations Using the Grammar of Graphics
  "scales", # nicer labels in ggplot2
  "ggthemes",
  "sf",
  "ggspatial",
  "maps",
  "tidyr",
  "plyr",
  "dplyr",
  "magrittr",
  "readxl",
  "stringr",
  "stringi",
  # "akgfmaps", # RACE-GAP Specific # devtools::install_github("afsc-gap-products/akgfmaps", build_vignettes = TRUE)
  "pingr", # check website links
  "httr", # check website links
  "flextable" # making pretty tables
)

PKG <- unique(PKG)
for (p in PKG) {
  if(!require(p,character.only = TRUE)) {
    if (p == "akgfmaps") {
      devtools::install_github("afsc-gap-products/akgfmaps", build_vignettes = TRUE)
    } else {
      install.packages(p)
    }
    require(p,character.only = TRUE)}
}

devtools::install_github("afsc-gap-products/akgfmaps", build_vignettes = TRUE)

## Define CRS ------------------------------------------------------------------

crs_out <- "EPSG:3338"
crs_in <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"

## Get world map ---------------------------------------------------------------

world_coordinates <- maps::map("world", plot = FALSE, fill = TRUE) %>% 
  sf::st_as_sf() %>%
  # sf::st_union() %>% 
  sf::st_transform(crs = crs_out) %>% 
  dplyr::filter(ID %in% c("USA", "Russia", "Canada")) %>% 
  dplyr::mutate(ID = ifelse(ID == "USA", "Alaska", ID))

## Get place labels for map ----------------------------------------------------

place_labels <- data.frame(
  type = c("islands", "islands", "islands", "islands", 
           "mainland", "mainland", "mainland", 
           "convention line", "peninsula", 
           "survey", "survey", "survey", "survey", "survey"), 
  lab = c("Pribilof Isl.", "Nunivak", "St. Matthew", "St. Lawrence", 
          "Alaska", "Russia", "Canada", 
          "U.S.-Russia Maritime Boundary", "Alaska Peninsula", 
          "Aleutian Islands", "Gulf of Alaska", 
          "Bering\nSea\nSlope", "Eastern\nBering Sea", "Northern\nBering Sea"), 
  angle = c(0, 0, 0, 0, 0, 0, 0, 30, 45, 0, 0, 0, 0, 0), 
  lat = c(57.033348, 60.7, 61, 64.2, 
          62.296686, 62.798276, 63.722890, 
          62.319419, 56.352495, 
          53.25, 54.720787, 
          57, 57.456912, 63.905936), 
  lon = c(-167.767168, -168, -174, -170.123016, 
          -157.377210, 173.205231, -136.664024, 
          -177.049063, -159.029430, 
          -173, -154.794131, 
          -176, -162, -165)) %>%
  dplyr::filter(type != "peninsula") %>% 
  dplyr::filter(type != "survey") %>% 
  # dplyr::mutate(
  #   color = dplyr::case_when(
  #     type == "mainland" ~ "grey80", 
  #     TRUE ~ "grey30"), 
  #   fontface = dplyr::case_when(
  #     type == "mainland" ~ "bold", 
  #     TRUE ~ "regular"),
  #   size = dplyr::case_when(
  #     type == "mainland" ~ 3, 
  #     TRUE ~ 2) ) %>% 
  sf::st_as_sf(coords = c("lon", "lat"),
               crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0") %>%
  sf::st_transform(crs = crs_out) 

## Determine map boundaries ----------------------------------------------------

boundaries <- data.frame(lon = c(-153, -152), # c(-180, -140)
                         lat = c(57.5, 58) )  %>% # c(46, 66)
  sf::st_as_sf(coords = c("lon", "lat"),
               crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0") %>%
  sf::st_transform(crs = crs_out) %>% 
  sf::st_coordinates() %>% 
  data.frame()

## Inport Groundfish Bottom Trawl Survey shapefiles (akgfmaps) -----------------

# shp_ebs <- akgfmaps::get_base_layers(select.region = "bs.south", set.crs = "auto")
# shp_nbs <- akgfmaps::get_base_layers(select.region = "bs.north", set.crs = "auto")
# shp_ai <- akgfmaps::get_base_layers(select.region = "ai", set.crs = "auto")
# shp_ai$survey.strata$Stratum <- shp_ai$survey.strata$STRATUM
# shp_goa <- akgfmaps::get_base_layers(select.region = "goa", set.crs = "auto")
# shp_goa$survey.strata$Stratum <- shp_goa$survey.strata$STRATUM
# shp_bss <- akgfmaps::get_base_layers(select.region = "ebs.slope", set.crs = "auto")
# 
# shp_all <- dplyr::bind_rows(list(
#   shp_ebs$survey.area %>%
#                     sf::st_transform(crs = crs_out) %>%
#     dplyr::mutate(SURVEY = "EBS"),
#   shp_nbs$survey.area %>%
#     sf::st_transform(crs = crs_out) %>%
#     dplyr::mutate(SURVEY = "NBS"),
#   shp_ai$survey.area %>%
#     sf::st_transform(crs = crs_out) %>%
#     dplyr::mutate(SURVEY = "AI"),
#   shp_goa$survey.area %>%
#     sf::st_transform(crs = crs_out) %>%
#     dplyr::mutate(SURVEY = "GOA"),
#   shp_bss$survey.area %>%
#                     sf::st_transform(crs = crs_out) %>%
#     dplyr::mutate(SURVEY = "BSS"))) %>%
#   dplyr::select(Survey = SURVEY, geometry)


## wrangle data for plot funsies -----------------------------------------------

dat <- spatial  %>% 
  sf::st_as_sf(coords = c("Longitude", "Latitude"), 
               remove = FALSE,
               crs = crs_in) %>%
  sf::st_transform(crs = crs_out)


# Being mapping -----------------------

p21 <- ggplot2::ggplot() +
  
  ### Map shapefile aesthetics ----------------------------------
# Manage Axis extents (limits) and breaks
ggplot2::geom_sf(data = world_coordinates,
                 fill = "grey10",
                 color = "grey20")  + 
  ggplot2::scale_x_continuous(name = "Longitude °W",
                              breaks = seq(-180, -150, 1)) +
  ggplot2::scale_y_continuous(name = "Latitude °N",
                              breaks = seq(50, 65, 1)) + # seq(52, 62, 2)
  
  ggplot2::geom_sf_text(
    data = place_labels %>% dplyr::filter(type == "mainland"),
    mapping = aes(label = lab, angle = angle), 
    color = "grey60", 
    size = 3, 
    show.legend = FALSE) + 
  ggplot2::geom_sf_text(
    data = place_labels %>% dplyr::filter(type == "survey"),
    mapping = aes(label = lab, angle = angle), 
    color = "black",
    fontface = "bold",
    size = 2, 
    show.legend = FALSE) + 
  ggplot2::geom_sf_text(
    data = place_labels %>% dplyr::filter(!(type %in% c("mainland", "survey"))),
    mapping = aes(label = lab, angle = angle), 
    color = "grey10", 
    fontface = "italic", 
    size = 2, 
    show.legend = FALSE) +
  
  ### Plot data ----------------------------------------------------------------

# ggplot2::geom_sf(
#   data = roms_dat_lines, 
#   mapping = aes(
#     color = depth_m,
#     # linetype = depth_m, 
#     geometry = geometry), 
#   alpha = 0.7,
#   linewidth = 2) + 
ggplot2::geom_sf(
  data = dat,
  mapping = aes(
    shape = Section,
    color = Type,
    geometry = geometry),
  alpha = 0.7,
  size = 3) +
  #   ggplot2::facet_wrap(~date) +
  ggplot2::scale_color_viridis_d(name = "Type", option = "D", begin = .2, end = .8) +
  #   ggplot2::ggtitle(label = "Juvenile Grenider Modeled ROMS Dispersal", 
  #                    subtitle = "At different depths, years, and environmental conditions") + 
  ggplot2::scale_shape_discrete(name = "Section",
                                na.value = NA,
                                na.translate = FALSE) +
  
  ### Plot aesthetics ----------------------------------
ggplot2::coord_sf(xlim = boundaries$X,
                  ylim = boundaries$Y) +
  ggplot2::theme_bw() +
  ggplot2::theme(
    plot.margin=unit(c(0,0,0,0), "cm"), 
    strip.background = element_rect(fill = "transparent", colour = "white"), 
    strip.text = element_text(face = "bold"), # , family = font0
    panel.border = element_rect(colour = "grey20", linewidth = .25, fill = NA),
    panel.background = element_rect(fill = "white"), 
    panel.grid = element_line(colour="grey80", linewidth = 0.5), 
    plot.title = element_text(face = "bold"), # , size = 12, family = font0
    axis.text = element_text(face = "bold"), # , size = 12 , family = font0
    legend.key = element_blank(), 
    legend.key.width = unit(0.6, "cm"),
    legend.key.size = unit(0.6, "cm"),
    legend.title = element_text(face = "bold"), # size = 10, , family = font0
    legend.title.position = "top", 
    legend.background = element_blank(),
    # legend.text = element_text(size = 10, angle = 90),
    legend.key.spacing = unit(0.0010, 'cm'), 
    legend.position = "right", # "bottom",
    legend.text.position = "right"# "bottom"
  )



