library(readxl)
library(lubridate)
library(dplyr)
library(ggplot2)
library(reshape2)

## Download this file from navient.com
loans <- read_excel(path = 'ByTransaction.xlsx', sheet=1)

loans$month <- floor_date(loans$Date, 'month')

grouped <- 
  loans %>%
  group_by(month) %>%
  arrange(month) %>%
  summarise(principal=sum(Principal), interest = sum(Interest), total = sum(Total))


## dplyr and reshape2 not playing nicely, coerce to data.frame
grouped <- data.frame(grouped)
m <- melt(grouped, measure.vars = c("principal", "interest", "total"))
m$value <- m$value * -1

sum(subset(m, variable=='interest')[,3])
sum(subset(m, variable=='principal')[,3])
sum(subset(m, variable=='total')[,3])

m <- subset(m, value > 0)
ggplot(m, aes(x=month, y=value, colour=variable)) + geom_smooth()
