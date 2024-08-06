library(dplyr)
library(shellpipes)

bitten <- rdsRead()
table(bitten$flags)

summary(bitten)

# Only suspected dogs are treated as potential biters
biters <- (bitten 
	|> select(-Biter.ID)
	|> filter(!is.na(ID))
	|> filter(Suspect %in% c("Yes","To Do", "Unknown"))
	|> filter(flags<2)
)

## There should be no repeats now
repBiters <- (biters
	|> group_by(ID)
	|> summarize(count=n()) 
	|> filter(count>1)
	|> nrow()
) 

stopifnot(repBiters==0)
stopifnot(biters |> filter(flags!=1) |> nrow() == 0)

biters <- biters |> select(-flags)

## These are _potential biters_, dogs with a unique suspected event
summary(biters)
rdsSave(biters)
