library(shellpipes)
manageConflicts()
library(dplyr)
library(ggplot2); theme_set(theme_bw())

calcs <- rdsRead()

## print(summary(calcs))

## Would be good to use log1p and scale_size_area to get a better idea of this stuff, but not very worried for now.

gensonly <- (calcs
	|> filter(!is.na(dateGen+combGen))
	|> select(dateGen, combGen)
	|> add_count(dateGen, combGen)
)

print(summary(gensonly))

print(ggplot(gensonly, aes(x=dateGen, y=combGen, size=n))
	+ geom_point()
	+ scale_x_log10() + scale_y_log10()
	+ geom_abline()
	+ scale_size_area()
)

sersonly <- (calcs
	|> filter(!is.na(dateSerial+combSerial))
	|> select(dateSerial, combSerial)
	|> add_count(dateSerial, combSerial)
)

print(summary(sersonly))

print(ggplot(sersonly, aes(x=dateSerial, y=combSerial, size=n))
	+ geom_point()
	+ scale_x_log10() + scale_y_log10()
	+ geom_abline()
	+ scale_size_area()
)
