## Goes with biters.md
library(dplyr)
library(shellpipes)

bitten <- rdsRead()
## table(bitten$rabiesFlags)

summary(bitten)

## FIXME: we could try to save Date.bitten if all Date.bitten values are the same (and no NAs)
biters <- (bitten 
	|> select(-Biter.ID)
	|> filter(!is.na(ID))
	|> filter(rabiesPossible>0)
	|> select(-rabiesPossible)
	|> mutate(Date.bitten = if_else(rabiesFlags>1, NA, Date.bitten))
	|> distinct()
)

## We used distinct() to combine information for dogs 
## Repeats that remain should be reported to Glasgow and dropped for now
repBiters <- (biters
	|> group_by(ID)
	|> summarize(count=n()) 
) 

biters <- biters |> full_join(repBiters)
summary(biters)

## FIXME: Can some dogs here be saved if Glasgow does not respond?
tsvSave(biters |> filter(count>1) |> select(-count))
rdsSave(biters |> filter(count==1) |> select(-count))
