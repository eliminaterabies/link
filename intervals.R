library(dplyr)
library(shellpipes)

linked <- rdsRead()

summary(linked)

intervals <- (linked
	%>% mutate(
		dateInc=as.numeric(Symptoms.started - Date.bitten) 
		, dateIncBiter = as.numeric(Symptoms.started.biter - Date.bitten.biter)
		, dateSerial=as.numeric(Symptoms.started - Symptoms.started.biter)
		, dateGen=as.numeric(Date.bitten - Date.bitten.biter)
		, estSerial = dateSerial + bestInc - dateInc
		, estGen = dateGen + bestInc - dateInc
	)
)

summary(intervals)
