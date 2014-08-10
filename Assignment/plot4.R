##This function loads the assignment data, subsets it and then plots it according to specs
##Originally used sqldf() for subsetting but loading the library for the user became overcumbersome
##I also could have made this a multi-function pprocess but used one function to do it all...
##Because I am lazy

plot4<- function() {
  
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
  png(file="plot4.png",width = 480, height = 480)
  
  ##Let's plot this plot()!
  ##First we need to set up the grid
  par(mfrow=c(2, 2))
  with(data, {
    ##Copy/paste #1: Why did the "in kilowatts" dissapear?!?
    plot(timestamp, Global_active_power, type="l", xlab="",
         ylab="Global Active Power")
    
    ## Top RIght
    plot(timestamp, Voltage, type="l", xlab="datetime", ylab="Voltage")
    
    ## Bottom Left, Similar to #3
    plot(timestamp, Sub_metering_1, type="n", xlab="",
         ylab="Energy sub metering")
    
    colors <- c("black", "red", "blue")

    variables <- paste("Sub_metering_", 1:3, sep="")
 
    for (i in seq_along(variables)) {
      var <- variables[i] 
      data_plot <- data[[var]]
      lines(timestamp, data_plot, col=colors[i])
    }
    
    legend("topright",
           bty="n", 
           legend=variables,
           col=colors, 
           lty="solid" 
    )
    
    ### Subplot 4 (bottom right)
    plot(timestamp, Global_reactive_power, type="l")
    
  })
  ##Easy peasy
  dev.off()}
