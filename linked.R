library(dplyr)
library(shellpipes)

bitten <- rdsRead("bitten")
biters <- rdsRead("biters")

links <- (bitten
	|> left_join(., biters
		, by=c("Biter.ID"="ID")
		, suffix=c("", ".biter")
	)
)

## Secret data in .rds; public in .rda
rdsSave(links)

