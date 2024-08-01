library(dplyr)
library(shellpipes)

bitten <- rdsRead()

## potential biters, these are suspected dogs.
biters <- (bitten 
	%>% select(-Biter.ID)
	%>% filter(Suspect %in% c("Yes","To Do", "Unknown"))
)

## These are potential biters that got bitten more than once
print(repbiters <- biters %>% group_by(ID) %>% summarize(count=n()) %>% filter(count>1)) 
print(bitten %>% filter(ID %in% repbiters$ID))

print(dim(biters))

biterCount <- (bitten
	%>% filter(!is.na(Biter.ID))
	%>% group_by(Biter.ID)
	%>% summarize(secondaryInf=n())
	%>% arrange(desc(secondaryInf))
	%>% select(ID=Biter.ID, secondaryInf)
)

print(biterCount)

## number of biters, We may or may not have all biter information
print(nrow(biterCount))

## If biterID not in ID, then that means we don't have information of the dog

## Here we are linking all the biter that have ID and linkable.
links <- (bitten
	%>% left_join(., biters
		, by=c("Biter.ID"="ID")
		, suffix=c("", ".biter")
		, relationship = "many-to-many"
	)
	%>% left_join(.,biterCount, by="ID")
)

## Focal dog bitten more than once
print(links %>% filter(timesBitten > 1))

print(nrow(bitten))
print(nrow(links))

## the reason why we have extra rows in links is because some biters are bitten more than once (see above) and some of these are in the biters list
## Should we take care of this here? 

## Not sure why we need this calculation
print(nrow(links) - nrow(biterCount))
summary(biterCount)

## this is the mean biting frequency, but not all biters have all info
print(mean_biting_freq <- mean(biterCount$secondaryInf))

## This is the alternative way 
print(mean_biting_freq <- mean(biterCount %>% filter(ID %in% bitten$ID) %>% pull(secondaryInf)))

## Secret data in .rds; public in .rda
rdsSave(links)
saveVars(mean_biting_freq)

