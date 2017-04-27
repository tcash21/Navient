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
  arrange(month) %>%
  mutate(Principal = Principal *-1) %>%
  mutate(principal=cumsum(Principal), interest = cumsum(Interest), total = cumsum(Total))

ggplot(grouped, aes(x=month, y=total)) + geom_line()

## dplyr and reshape2 not playing nicely, coerce to data.frame
grouped <- data.frame(grouped)
m <- melt(grouped, measure.vars = c("principal", "interest", "total"))
m$value <- m$value * -1

sum(subset(m, variable=='interest')[,3])
sum(subset(m, variable=='total')[,3])
sum(subset(m, variable=='principal')[,3])