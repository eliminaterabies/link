library(dplyr)
library(shellpipes)

bitten <- rdsRead()
table(bitten$flags)

summary(bitten)

# Only suspected dogs are treated as potential biters
biters <- (bitten 
	|> select(-Biter.ID)
	|> filter(Suspect %in% c("Yes","To Do", "Unknown"))
	|> filter(flags<2)
)

repBiters <- (biters
	|> group_by(ID)
	|> summarize(count=n()) 
	|> filter(count>1)
	|> nrow
) 

stopifnot(repBiters==0)

rdsSave(biters)
