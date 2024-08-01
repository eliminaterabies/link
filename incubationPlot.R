## incubation plots
library(dplyr)
library(ggplot2);theme_set(theme_bw())
library(cowplot)
library(ggforce)

library(shellpipes)
startGraphics()

loadEnvironments()

minDays <- 0
maxDays <- 100

ggbites <- (ggplot(bites, aes(x=count))
   + geom_histogram(fill="grey", color="black", guide=FALSE)
	+ xlab("Bites")
	+ facet_wrap(~"Bites")
)
		
gg_hist <- (ggplot(incubations, aes(x=Days, group=Type))
	+ facet_wrap(~Type,ncol=2, scale="free_y")
	+ geom_histogram(aes(y=after_stat(count)))
	+ geom_density(aes(y=after_stat(count)*5))
	## JD: magic number here!
)

gg_dens <- (ggplot(incubations, aes(x=Days, colour=Type))
	+ geom_density(aes(y=after_stat(count))
	)
)

gg_incubations <- (ggplot(incubations, aes(Days, fill = Type, color="black"))
	+ geom_histogram()
	+ geom_density(aes(y=after_stat(count)*5),alpha=0)
	+ facet_wrap(~Type, scale="free_y")
	+ scale_fill_manual(values=c("blue","red","grey","grey"))
	+ scale_color_manual(values=rep("black",4))
	+ theme(legend.position="none"
		, panel.spacing = unit(0,"lines")
		)
	+ xlim(c(minDays,maxDays))
)

print(gg_incubations)

print(plot_grid(gg_incubations,ggbites,ncol=2, rel_widths=c(1.5,1)))
