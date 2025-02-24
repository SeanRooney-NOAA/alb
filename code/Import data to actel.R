#Importing data from OTN to ACTEL

getwd() #check working directory

#Load libraries
library(tidyverse) # Tidyverse (data cleaning and arrangement)
library(actel)
library(lubridate)# Lubridate - same group as Tidyverse, improves the process of creating date objects
library(readr) # #read_csv() is from tidyverse's readr package --> you can also use read.csv() from base R but it created a dataframe (not tibble) so loads slower
library(ggmap)# GGmap - complimentary to ggplot2, which is in the Tidyverse
library(sp) #SP and Raster packages for mapping.
library(raster)

#Importing data- import files into R (minimum requirement are biomentric, spatial,deployment, and detentions to use the preload() function. Optionalfiles include Distance matrix and Spatial.txt)

##Time format:____________________________________________________
# All dates will be supplied to Actel in this format:

actel_datefmt = '%Y-%m-%d %H:%M:%S'

##Biometric file:____________________________________________________

##This table contains two columns:
##Release.date: Corresponds to the date and time when the animal was released, and must be typed in yyyy-mm-dd hh:mm:ss format. Note that the timestamps must be in the local time zone of the study area, which you will later supply in the tz argument.
##Signal: Corresponds to the code emitted by your tags. If you are unsure as to what signals are, you should ask the tag manufacturer more about the differences between code spaces and signals.

biometric <- read_csv("data/biometric.csv")

head(biometric)
str(biometric)

##Spatial file:____________________________________________________

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

##Deployments file:____________________________________________________

  #Receiver: The serial number of the receiver. If a receiver was retrieved and re-deployed, you should add extra rows for each deployment.
  #Station.name: The name of the station where the receiver was deployed. It must match one of the station names in the spatial file.
  #Start and Stop: The times when the receiver was deployed and when the receiver was retrieved, respectively. Must be in a yyyy-mm-dd hh:mm:ss format. Note that these timestamps must be in the local time zone of the study area, which you will later supply in the tz argument

deployments <- read_csv("data/deployments.csv")
head(deployments)
str(deployments)

##Detentions:____________________________________________________
raw_detections <- readr::read_csv("data/alb_matched_detections_2021.csv", guess_max=60000) 

detections_otn<-dplyr::select(raw_detections, "receiver","codespace","tagname", "sensorraw", "sensorunit","datecollected", "sensorname") |> 
mutate(receiver = as.character(receiver),
         codespace = as.character(codespace),
           tagname = as.character(tagname),
         sensorraw = as.character(sensorraw),
         sensorunit = as.character(sensorunit), 
         datecollected = ymd_hms(raw_detections$datecollected),
         Signal = stringr::str_extract(sensorname, "(?<=-)[^-]*$") #Use this instead of actel's function to extract the signals: as.numeric(stringr::str_extract(COLUMN, "(?<=-)[^-]*"))
        
)
        
str(detections_otn)
head(detections_otn)

##Distances matrix______________________


##Preload data___________________________________________________________________

# Now that we have the R objects created, we can run preload:
#x <- preload(biometrics = bio, deployments = deployments, spatial = spatial,
#'  detections = detections, dot = dot, tz = "Europe/Copenhagen")
#'  
#'  
#'  
#'  
#'  
#'  
#'  
#'  
#'  
#'  
#'  