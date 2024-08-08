library(shellpipes)
manageConflicts()
library(ggplot2); theme_set(theme_bw())

calcs <- rdsRead()

## print(summary(calcs))

print(ggplot(calcs)
	+ aes(dateGen, combGen)
	+ geom_point()
	+ scale_x_log10() + scale_y_log10()
	+ geom_abline()
)

print(ggplot(calcs)
	+ aes(dateSerial, combSerial)
	+ geom_point()
	+ scale_x_log10() + scale_y_log10()
	+ geom_abline()
)


