library(dplyr)
library(shellpipes)

bitten <- rdsRead("bitten")
biters <- rdsRead("biteCount")

## Potential biters (animals not tagged convincing as non-rabid)
print(biters
	|> select(ID)
	|> distinct()
	|> nrow()
)

## Dogs observed biting
print(numBiters <- bitten
	|> select(Biter.ID)
	|> distinct()
	|> nrow()
)

links <- (bitten
	|> inner_join(biters
		, by=c("Biter.ID"="ID")
		, suffix=c("", ".biter")
	)
)

print(linkedBiters <- links
	|> select(Biter.ID)
	|> distinct()
	|> nrow()
)

print(c(missingBiters=numBiters-linkedBiters))

## This code was missing

biterCount <- (bitten
	%>% filter(!is.na(Biter.ID))
	%>% group_by(Biter.ID)
	%>% summarize(secondaryInf=n())
	%>% arrange(desc(secondaryInf))
	%>% select(ID=Biter.ID, secondaryInf)
)

mean_biting_freq <- mean(biterCount$secondaryInf)

## 


summary(links)
saveVars(links, mean_biting_freq)
