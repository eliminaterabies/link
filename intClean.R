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

## See README.md for a little more on the NA logic
intervals <- (calcs
	|> mutate(
		bestGen = pickFirst(combGen, dateGen)
		, bestSerial = pickFirst(combSerial, dateSerial)
		, bestGen = if_else(bittenFlags.biter>1, NA, bestGen)
		, bestSerial = if_else(bittenFlags>1, NA, bestSerial)
	) |> select(
		Biter.ID, ID, Date.bitten, bestInc, bestInc.biter
		, waitingTime, bestGen, bestSerial
	)
)

summary(intervals)

dog <- 6199
print(intervals |> filter((ID==dog) | (Biter.ID==dog)) |> as.data.frame())
