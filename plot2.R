## Household Power Consumption data file. 
##
## Format:
##
## Date;Time;Global_active_power;Global_reactive_power;Voltage;Global_intensity;Sub_metering_1;Sub_metering_2;Sub_metering_3
## 16/12/2006;17:24:00;4.216;0.418;234.840;18.400;0.000;1.000;17.000
## 1/1/2007;00:00:00;2.580;0.136;241.970;10.600;0.000;0.000;0.000
##
## Target data: 
## 
## {01/02/2007 00:00:00} to {03/02/07 00:00:00}
##

data_start  <- 66637
data_length <- 2881

hpc=read.table("household_power_consumption.txt", sep=";", skip=data_start, nrow = data_length,
     col.names = colnames(read.table("household_power_consumption.txt", nrow = 1, header = TRUE, sep=";")))

if ((hpc$Date[1] != "1/2/2007") | (hpc$Time[1] != "00:00:00")) 
     stop("Data file has changed (Start).")

if ((hpc$Date[data_length] != "3/2/2007") | (hpc$Time[data_length] != "00:00:00")) 
     stop("Data file has changed (End).")

## Date and Time -> DateTime
hpc$D.T <- strptime(with(hpc,paste(Date,Time)), "%d/%m/%Y %H:%M:%S")

## Create .png file plot in default 480x480 size
png(file = "plot2.png")
plot(hpc$D.T, hpc$Global_active_power, type="l", 
                                       ylab="Global Active Power (kilowatts)",
                                       xlab="")
## Done
dev.off()


