library(plyr)
library(dplyr)
library(lubridate)
# URL to download the data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# Downloads the zip file and names it data.zip
download.file(url, "./data.zip")
# Extracts the data.zip file in the current directory
unzip("data.zip", list = FALSE, exdir = "./")

# Reads the data file and assigns it to rawData
rawData <- read.table("./household_power_consumption.txt", sep = ";", header = TRUE, na.strings = c("?","NA"))
# use the parse_date_time function from lubridate function to parse Date and Time Vectors
rawData$Date <- parse_date_time(rawData$Date, orders = "dmy")
rawData$Time <- parse_date_time(rawData$Time, orders = "hms")

#subset data to include only the required dates 
filteredData <- filter(rawData, Date == ymd("2007-02-01") | Date == ymd("2007-02-02"))
# remove rawData to free some space
rm(rawData)
#combine Date and Time columns into single column for plotting
dateComp <- strftime(filteredData$Date, format = "%Y-%m-%d", tz="UTC")
timeComp <- strftime(filteredData$Time, format = "%H:%M:%S", tz="UTC")
filteredData$dateTime <- as.POSIXct(paste(dateComp,timeComp, sep = " "), tz="UTC")

# opens a png graphic device 
png(filename = "./plot2.png", width = 480, height = 480, units = "px")

# plots the data
with(filteredData, 
     plot(dateTime, Global_active_power, 
          type="l", 
          xlab = "",
          ylab = "Global Active Power(Kilowatts)")
     )
#close the device
dev.off()
