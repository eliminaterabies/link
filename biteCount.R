library(shellpipes)
manageConflicts()
startGraphics()

library(dplyr)

linked <- rdsRead("linked")
biters <- rdsRead("biters")
dim(biters)

counts <- (linked
	|> group_by(Biter.ID)
	|> summarize(bites=n())
	|> ungroup()
)

summary(counts)
summary(biters)

biters <- (full_join(biters, counts, by=c("ID"="Biter.ID"))
	|> mutate(bites = if_else(is.na(bites), 0, bites))
)

summary(biters)
dim(biters)
