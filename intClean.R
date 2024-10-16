library(shellpipes)
manageConflicts()

library(dplyr)

calcs <- rdsRead()

pickFirst <- function(...){
	vlist <- list(...)
	len <- length(vlist)
	if (len==0) return(NULL)
	v <- vlist[[1]]
	if (len>1) for(i in 2:len){
		v <- if_else(is.na(v), vlist[[i]], v)
	}
	return(v)
}

intervals <- (calcs
	|> mutate(bestGen = pickFirst(combGen, dateGen))
	|> mutate(bestSerial = pickFirst(combSerial, dateSerial))
)

summary(intervals)

## Four manually suspected dogs
summary(intervals
	|> filter((ID %in% c(161, 628, 7966, 7967)))
)

## All were dropped from biter frame
summary(intervals
	|> filter((Biter.ID %in% c(161, 628, 7966, 7967)))
)
