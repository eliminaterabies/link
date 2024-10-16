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
	|> mutate(Date.bitten = ifelse(flags>1, NA, Date.bitten))
	|> select(-flags)
	|> distinct()
)

## There should be no repeats now
## If there are, we need to look more closely at info for multiply bitten dogs
repBiters <- (biters
	|> group_by(ID)
	|> summarize(count=n()) 
	|> filter(count>1)
	|> nrow()
) 

stopifnot(repBiters==0)
summary(biters)
rdsSave(biters)
