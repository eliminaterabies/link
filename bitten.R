library(shellpipes)
manageConflicts()

library(dplyr)

animal <- rdsRead()

## Make the factor variables we want
bitten <- (animal
	|> mutate(
		Suspect = factor(Suspect)
		, ID = factor(ifelse(ID==0, NA, ID))
		, Biter.ID = factor(ifelse(Biter.ID==0, NA, Biter.ID))
	)
)

summary(bitten)

## Are there any repeats of biter/bitee pairs?
repeatPairs <- (bitten
	|> filter(!is.na(ID) & !is.na(Biter.ID))
	|> filter(duplicated(data.frame(ID, Biter.ID)))
)
stopifnot(nrow(repeatPairs)==0)

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
