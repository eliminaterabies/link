library(shellpipes)
manageConflicts()

library(dplyr)

inc <- (rdsRead()
	|> select(bestInc)
	|> filter(!is.na(bestInc) & bestInc <= 155)
	|> pull(bestInc)
)

saveVars(inc)
