## See bitten.md

library(shellpipes)
manageConflicts()

library(dplyr)

animal <- rdsRead()

## Make the variables we want
bitten <- (animal
	|> mutate(
		Suspect = factor(Suspect)
		, ID = factor(if_else(ID==0, NA, ID))
		, Biter.ID = factor(if_else(Biter.ID==0, NA, Biter.ID))
	)
)

## Are there any repeats of biter/bitee pairs?
repeatPairs <- (bitten
	|> filter(!is.na(ID) & !is.na(Biter.ID))
	|> filter(duplicated(data.frame(ID, Biter.ID)))
)
stopifnot(nrow(repeatPairs)==0)

## Is rabies possible
bitten <- (bitten
	|> mutate(rabiesPossible = 
		Suspect %in% c("Yes","To Do", "Unknown")
		| is.na(Suspect) | !is.na(Symptoms.started) | !is.na(bestInc)
	)
)

## Group across incidents for a given bitee
flagCount <- (bitten
	|> group_by(ID)
	|> summarize(rabiesFlags=sum(rabiesPossible))
	|> ungroup()
)

## More than one rabiesPossible flag for a dog means 
## we throw out previously calculated bestInc
## because we're not confident about the relevant bitten date
bitten <- (left_join(bitten, flagCount)
	|> mutate( bestInc = if_else(rabiesFlags>1, NA, bestInc))
	|> select(-rabiesPossible)
)

summary(bitten)

## Don't allow distinct symptom dates for a dog
symptomCount <- (bitten
	|> group_by(ID)
	|> summarize(sdCount = sum(!is.na(Symptoms.started)))
)

bitten <- (left_join(bitten, symptomCount)
	|> mutate(Symptoms.started = if_else(sdCount>1, NA, Symptoms.started))
	|> select(-sdCount)
)

summary(bitten)

rdsSave(bitten)
