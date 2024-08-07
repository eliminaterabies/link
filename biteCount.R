library(shellpipes)
manageConflicts()
startGraphics()

library(dplyr)

bitten <- rdsRead("bitten")
biters <- rdsRead("biters")
dim(biters)

counts <- (bitten
	|> group_by(Biter.ID)
	|> summarize(bites=n())
	|> ungroup()
)

summary(counts)
summary(biters)

biters <- (left_join(biters, counts, by=c("ID"="Biter.ID"))
	|> mutate(bites = if_else(is.na(bites), 0, bites))
)

summary(biters)

rdsSave(biters)
