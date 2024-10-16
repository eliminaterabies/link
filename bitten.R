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

## See which records have flags
bitten <- (bitten
	|> mutate(flag = 
		Suspect %in% c("Yes","To Do", "Unknown")
		| !is.na(Symptoms.started) | !is.na(bestInc)
	)
)
flagCount <- (bitten
	|> group_by(ID)
	|> summarize(flags=sum(flag))
	|> ungroup()
)

## More than one flag for a dog means no incubation period
## Do we need to keep the flag count? 
## Come back and check after we write biters.R
bitten <- (left_join(bitten, flagCount)
	|> mutate(
		bestInc = if_else(flags>1, NA, bestInc)
		, Symptoms.started = if_else(flags>1, NA, Symptoms.started)
	)
	|> select(-flag)
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
