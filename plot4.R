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

## create empty list and add plot fields
fields <- vector()
for (i in 1:3) fields[i] <- paste0("Sub_metering_",as.character(i))

## vector of plot colours
colours <- c("black","red","blue")

## work out maximum plotting extent over the 3 fields for Sub_metering
df      <- data.frame(hpc$Sub_metering_1, hpc$Sub_metering_2, hpc$Sub_metering_3)
hpc$max <- apply(df,1,max)


## Create .png file plot in default 480x480 size
png(file = "plot4.png")

## Prepare multi-plot canvas
plot.new()
par(mfrow = c(2, 2), mar = c(4, 4, 3, 3))

## Plot 4.1 - Global_active_power

plot(hpc$D.T, hpc$Global_active_power, type="n", ylab="Global Active Power", xlab="")
lines(hpc$D.T, hpc$Global_active_power)


## Plot 4.2 - Voltage

plot(hpc$D.T, hpc$Voltage, type="n", ylab="Voltage", xlab="datetime")
lines(hpc$D.T, hpc$Voltage)


## Plot 4.3 - Sub_metering

plot(hpc$D.T, hpc$max, type="n", ylab="Energy sub metering", xlab="")
for (i in 1:3) 
    lines(hpc$D.T, hpc[[ fields[i] ]], col=colours[[i]])
legend("topright", fields, col=colours, bty="n", lwd=1,  cex=0.95, y.intersp=.9,  
       text.width=80000)

## Plot 4.4 - Global_reactive_power

plot(hpc$D.T, hpc$Global_reactive_power, type="n", ylab="Global_reactive_power",
     xlab="datetime")
lines(hpc$D.T, hpc$Global_reactive_power)


## Done
dev.off()

