library(shellpipes)
manageConflicts()

library(dplyr)

animal <- rdsRead()

## Number of transmission events
## JD: In what sense is the number of transmission events? Don't we have more cleaning to do?
dogsTransmissionNum <- nrow(animal)

## What's the logic that Unknown dogs must have biters?
SuspectDogs <- animal %>% filter(Suspect %in% c("Yes","To Do", "Unknown"))
dogsSuspectedNum <- SuspectDogs |> select(ID) |> distinct() |> nrow()
unknownBiters <- SuspectDogs %>% filter(Biter.ID == 0)

bitten <- (animal
	|> mutate(
		Suspect = factor(Suspect)
		, ID = factor(ifelse(ID==0, NA, ID))
		, Biter.ID = factor(ifelse(Biter.ID==0, NA, Biter.ID))
	)
)

## Total bites recorded (not necessarily all from dogs)
biteCount <- (bitten
   %>% group_by(ID)
   %>% summarize(timesBitten=n())
   %>% ungroup()
)
## JD: Some analysis dropped here because we can't really add these numbers:
## an animal bitten 3 times will appear 3 times each with a 3.

## Number of distinct biters
## JD: Not currently being used
print(bitten
	|> filter(Biter.ID != 0) |> select(Biter.ID) |> distinct() |> nrow()
)

bitten <- full_join(bitten, biteCount)
saveVars(dogsTransmissionNum, dogsSuspectedNum, unknownBiters)
rdsSave(bitten)
