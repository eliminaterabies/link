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
bitten <- (left_join(bitten, flagCount)
	|> select(-flag)
	|> mutate(bestInc = if_else(flags>1, NA, bestInc))
)

summary(bitten)

## Don't allow distinct symptom dates for a dog
symptomCount <- (bitten
	|> select(ID, Symptoms.started)
	|> filter(!is.na(Symptoms.started))
	|> distinct()
	|> group_by(ID)
	|> summarise(symptomDates = count())
	|> filter(symptomDates>1)
)

## Which dogs have inconsistent information across multiple bites?
print(multcheck <- bitten
	|> select(ID, Suspect, Symptoms.started)
	|> distinct()
	|> select(ID)
	|> filter(duplicated(ID))
	|> left_join(bitten)
, n=100)

## Are the Biters really identifiable?

print(multcheck
	|> filter(Biter.ID %in% bitten$ID)
)

## Ok, so this simply gets rid of the NAs. 


## Total bites recorded (not necessarily all from dogs)
biteCount <- (bitten
   %>% group_by(ID)
   %>% summarize(timesBitten=n())
   %>% ungroup()
)

bitten <- full_join(bitten, biteCount)
rdsSave(bitten)
