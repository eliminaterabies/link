# Calculating different intervals

library(dplyr)
library(tidyr)
library(ggplot2)
library(shellpipes)

commandEnvironments()

calcs <- (rdsRead()
	%>% rowwise()
	%>% mutate(
		, dateSerial=as.numeric(Symptoms.started - Symptoms.started.biter)
		, dateGen=as.numeric(Date.bitten - Date.bitten.biter)
	)
)

print(summary(calcs))

rdsSave(calcs)
