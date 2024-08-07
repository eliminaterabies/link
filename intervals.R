library(dplyr)
library(shellpipes)

calcs <- rdsRead()


intervals <- (calcs
	|> select(ID,dateSerial, dateGen, bestInc, Biter.ID, bestInc.biter)
)

summary(intervals)
