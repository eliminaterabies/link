library(shellpipes)
manageConflicts()

library(dplyr)

flag <- list(low=7, high=180)
censor <- list(low=4, high=730)

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

flag <- (intervals
	|> filter(
		(!is.na(bestGen) & !between(bestGen, flag$low, flag$high))
		| (!is.na(bestSerial) & !between(bestSerial, flag$low, flag$high))
	)
	|> select(-c(Date.bitten))
)

## print(flag, n=Inf)

intervals <- (intervals |> mutate(
		bestGen = if_else(between(bestGen, censor$low, censor$high)
			, bestGen, NA
		) , bestSerial = if_else(between(bestSerial, censor$low, censor$high)
			, bestSerial, NA
		)
))

summary(intervals)

rdsSave(intervals)
