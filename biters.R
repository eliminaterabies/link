## Goes with biters.md
library(dplyr)
library(shellpipes)

bitten <- rdsRead()
## table(bitten$rabiesFlags)

summary(bitten)

# Only suspected dogs are treated as potential biters
biters <- (bitten 
	|> select(-Biter.ID)
	|> filter(!is.na(ID))
	|> filter(rabiesFlags>0)
	## Not decided yet, JD wants to move this next line back up to bitten.md
	|> mutate(Date.bitten = ifelse(rabiesFlags>1, NA, Date.bitten))
	|> distinct()
)

## There should be no repeats now
## We used distinct() to combine information for dogs 
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
