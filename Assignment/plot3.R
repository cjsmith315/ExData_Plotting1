##This function loads the assignment data, subsets it and then plots it according to specs
##Originally used sqldf() for subsetting but loading the library for the user became overcumbersome
##I also could have made this a multi-function pprocess but used one function to do it all...
##Because I am lazy

plot3<- function() {
 
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
  png(file="plot3.png",width = 480, height = 480)
  
  ##Let's plot this plot()!
  with(data, {
    plot(timestamp, Sub_metering_1, type="n", col="black", xlab="",
         ylab="Energy sub metering")
    colors <- c("black", "red", "blue")
    ##Set up variables, concatenate numerals to string
    variables <- paste0("Sub_metering_", 1:3)
    ##Looping through variable list to paint lines on canvas
    for (i in seq_along(variables)) {
      var <- variables[i]
      data_plot <- data[[var]]
      lines(timestamp, data_plot, col=colors[i])
    }
    
    ##Finish up with legend
    legend("topright",
           legend=variables,
           col=colors,
           lty="solid"
           )
  })
dev.off()}
