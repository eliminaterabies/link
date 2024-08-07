library(dplyr)
library(shellpipes)

bitten <- rdsRead("bitten")
biters <- rdsRead("biters")

summary(biters)

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

links <- (bitten
	|> right_join(biters
		, by=c("Biter.ID"="ID")
		, suffix=c("", ".biter")
	)
)

print(links
	|> select(Biter.ID)
	|> distinct()
	|> nrow()
)

summary(links)
rdsSave(links)
