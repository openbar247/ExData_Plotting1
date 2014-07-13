epowname <- "household_power_consumption";
epownametxt <- paste(epowname, ".txt", sep="")
epownamezip <- paste(epowname, ".zip", sep="")
dateformat <- "%d/%m/%Y"
# download and/or unzip file necessary
if (!file.exists(epownametxt))
{
    if (!file.exists(epownamezip))
    { 
        download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", epownamezip)
    }
    unzip(epownamezip)
}
# read raw data
epowdata <- read.table(epownametxt, header=F, stringsAsFactors=F, na.strings=c("",NA,"?"), sep=";")
# use second line descriptive names as column names instead of V1-V9
colnames(epowdata) <- epowdata[1,]
# exclude the first line as the descriptive names are NOW the column names
epowdata <- epowdata[-1,]
# include only rows within specified date range
epowdata <- epowdata[as.Date(epowdata$Date, format=dateformat) >= as.Date('2007-02-01') & as.Date(epowdata$Date, format=dateformat) <= as.Date('2007-02-02'),]
# create a new column that merges Date and Time columns and converts into POSIXlt class instance
datetime <- strptime(paste(epowdata$Date, epowdata$Time), format=paste(dateformat, "%H:%M:%S"), tz="PST")
epowdata <- cbind(datetime, epowdata)
# create appropriate plot directly to file to avoid legend truncation
# and turn off associated devices
png(filename="plot3.png", width=480, height=480)
plot(epowdata$datetime, epowdata$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering", col="black")
lines(epowdata$datetime, epowdata$Sub_metering_2,type = "l", col = "red")
lines(epowdata$datetime, epowdata$Sub_metering_3,type = "l", col = "blue")
legend("topright", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), box.col="black", lty=1, xjust=0.5, cex=0.95)
dev.off()
