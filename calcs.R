# Calculating different intervals

library(dplyr)
library(tidyr)
library(ggplot2)
library(shellpipes)

maxWait <- 10
maxGen <- 150
maxInc <- 150

calcs <- (rdsRead()
	|> mutate(
		, waitingTime=as.numeric(Date.bitten - Symptoms.started.biter)
		, dateSerial=as.numeric(Symptoms.started - Symptoms.started.biter)
		, dateGen=as.numeric(Date.bitten - Date.bitten.biter)
		## , sameDay = as.numeric(waitingTime==0)
	)
)

rangeTrim <- function(x, high, low=0){
	return(if_else(
		x>=low & x<=high, x, NA
	))
}

calcs <- (calcs
	|> mutate(
		waitingTime = rangeTrim(waitingTime, maxWait)
		, dateSerial = rangeTrim(dateSerial, maxGen)
		, dateGen = rangeTrim(dateGen, maxGen)
		, bestInc = rangeTrim(bestInc, maxInc)
		, bestInc.biter = rangeTrim(bestInc.biter, maxInc)
		, combSerial = waitingTime + bestInc
		, combGen = bestInc.biter + waitingTime
	)
)

print(summary(calcs))

rdsSave(calcs)
