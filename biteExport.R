library(shellpipes)
manageConflicts()

library(tidyr)
library(dplyr)

biters <- (rdsRead()
	|> filter (!is.na(bestInc))
)

summary(biters |> mutate_if(is.character, as.factor))
