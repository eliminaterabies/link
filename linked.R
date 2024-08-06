library(dplyr)
library(shellpipes)

bitten <- rdsRead("bitten")
biters <- rdsRead("biters")

summary(biters)
summary(bitten)

print(biters
	|> select(ID)
	|> distinct()
	|> nrow()
)

print(bitten
	|> select(Biter.ID)
	|> distinct()
	|> nrow()
)

links <- (biters
	|> left_join(bitten
		, by=c("ID"="Biter.ID")
		, suffix=c(".biter", "")
	)
)


summary(links)
rdsSave(links)
