## This is eliminaterabies/link 2024 Jul 17 (Wed)

cmain = main

current: target
-include target.mk
Ignore = target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

Sources += README.md notes.md ## TODO.md ##

-include ../datalinks.mk

#################################################################

Sources += $(wildcard *.R)

Ignore += sddogs.csv

## The pipeline files are currently remade by making %.report.html
update_dogs:
	$(RM) sddogs.csv
sddogs.csv: | pipeline
	$(LNF) pipeline/SD_dogs.incubation.Rout.csv $@ 

######################################################################

Sources += $(wildcard *.md)

## This repo for now is focused on the Serengeti District dogs
## These are parsed out of wiseMonkey in an upstream repo
## and shared in a Dropbox

## Examine data and decide what fields we need
Ignore += *.Rout.TSV
## read.Rout.TSV: read.R
read.Rout: read.R sddogs.csv
	$(pipeR)

%.Rout.TSV: %.Rout ;
## The summary file read.Rout.TSV is cached in outputs; we can compare with it if data changes

## We can select and optionally rename variables with this file
Sources += $(wildcard *.tsv)
select.tsv: | read.Rout.TSV
	$(pcopy)
select.Rout: select.R read.rds select.tsv
	$(pipeR)

## Breaking out biteStats.R 2024 Aug 02 (Fri)
bitten.Rout: bitten.R select.rds bitten.md
	$(pipeR)

## Pull out _potential_ biters and make a frame
biters.Rout: biters.R bitten.rds
	$(pipeR)

## Count bites of potential biters
biteCount.Rout: biteCount.R biters.rds bitten.rds biteCount.md
	$(pipeR)

## Side branch to maybe calculate some stats; not active 2024 Aug 06 (Tue)
biteStats.Rout: biteStats.R bitten.rds
	$(pipeR)

## Link focal individuals to their biters
linked.Rout: linked.R bitten.rds biteCount.rds linked.md
	$(pipeR)

## Calculate waiting times and best intervals
## Split into checking script and pipeline script
calcs.Rout: calcs.R linked.rds calcs.md
	$(pipeR)

calcPlots.Rout: calcPlots.R calcs.rds calcs.md
	$(pipeR)

intClean.Rout: intClean.R calcs.rds
	$(pipeR)

######################################################################

## Needs to be rebuilt or eliminated?
## Filter intervals to drop animals _bitten_ more than once
once.Rout: once.R calcs.rda
	$(pipeR)

incubation.Rout: incubation.R once.rds
	$(pipeR)

incubationPlot.Rout: incubationPlot.R incubation.rda
	$(pipeR)

######################################################################

## Get rid of all of this including content.mk

.PRECIOUS: %.R
%.R:
	$(CP) ../egfRabies/$*.R .

Sources += content.mk

######################################################################

## Sent this to Ningrui Summer 2024

## borrow.rda: borrow.R
borrow.Rout: borrow.R bitten.rds
	$(pipeR)

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/00.stamp
makestuff/%.stamp:
	- $(RM) makestuff/*.stamp
	(cd makestuff && $(MAKE) pull) || git clone --depth 1 $(msrepo)/makestuff
	touch $@

-include makestuff/os.mk

-include makestuff/pipeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
