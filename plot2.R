##This function loads the assignment data, subsets it and then plots it according to specs
##Originally used sqldf() for subsetting but loading the library for the user became overcumbersome
##I also could have made this a multi-function pprocess but used one function to do it all...
##Because I am lazy
plot2<- function() {
  ##This Section checks for data file and downloads/unzips it if is not present##
  file<-"household_power_consumption.txt"
  link<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  dfile<-"exdata-data-household_power_consumption.zip"
  if(!file.exists(file)){
    download.file("link", unzip(dfile,exdir=".",unzip="internal"))
  }
  data <- read.table(file, sep=";", header=TRUE, na.strings="?")
  
  #Creates a timestamp column from Date:Time
  data$timestamp <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")
  
  ##Subsets on dates we are interested in
  date <- c(as.Date("2007-02-01"), as.Date("2007-02-02"))
  data<-data[as.Date(data$timestamp) %in% date,]
  ##Create the png file our graph will go in
  png(file="plot2.png",width = 480, height = 480)
  ##Let's plot this plot()!
  with(data, {
    plot(timestamp, Global_active_power, type="l", xlab="",
         ylab="Global Active Power (kilowatts)")
  })
  dev.off()
}

