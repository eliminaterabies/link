library(shellpipes)
manageConflicts()

library(tidyr)
library(dplyr)

transmission <- (rdsRead()
	|> select(serial=bestSerial, gen=bestGen)
	|> pivot_longer(everything()
		, names_to="type"
		, values_to="days"
	)
	|> filter (!is.na(days))
)

summary(transmission |> mutate_if(is.character, as.factor))
