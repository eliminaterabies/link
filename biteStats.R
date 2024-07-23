## What stats do we need for the papers? Let's write them down clearly and get rid of the current legacy code. We can always git it back.


library(shellpipes)
manageConflicts()

library(dplyr)

bites <- rdsRead()
summary(bites)

nrow(bites)

print(bites
	|> filter(flags>0)
	|> select(ID)
	|> distinct()
	|> nrow()
)

print(bites
	|> select(Biter.ID)
	|> distinct()
	|> nrow()
)

