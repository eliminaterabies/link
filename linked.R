library(dplyr)
library(shellpipes)

bitten <- rdsRead("bitten")
biters <- rdsRead("biteCount")

summary(biters)

print(biters
	|> select(ID)
	|> distinct()
	|> nrow()
)

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

summary(links)
rdsSave(links)
