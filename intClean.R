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
