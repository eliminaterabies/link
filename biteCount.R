library(dplyr)
library(shellpipes)

linked <- rdsRead("linked")
biters <- rdsRead("biters")
dim(biters)

(linked
	|> select(Biter.ID)
	|> distinct()
	|> nrow()
)

counts <- (linked
	|> group_by(Biter.ID)
	|> summarize(bites=n())
	|> ungroup()
)

summary(counts)
summary(biters)

biters <- full_join(biters, counts, by=c("ID"="Biter.ID"))

summary(biters)
dim(biters)
