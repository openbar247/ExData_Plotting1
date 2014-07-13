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
# create appropriate plot copy to associated file and turn off associated devices
png(filename="plot2.png", width=480, height=480)
plot(epowdata$datetime, as.numeric(epowdata$Global_active_power), type="s", xlab="", ylab="Global Active Power (kilowatts)", cex=0.75)
dev.off()
