## This is eliminaterabies/link 2024 Jul 17 (Wed)

current: target
-include target.mk
Ignore = target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

Sources += README.md notes.md ## TODO.md ##

## Use Dropboxes to pass and cache data so that we can keep the code open

## Make a local.mk (locally ☺) if you want to reset the Dropbox base directory
Ignore += local.mk
Drop = ~/Dropbox
-include local.mk

## Pipeline outputs inside a bigger Rabies_TZ Dropbox
Ignore += pipeline
pipeline/%:
	$(MAKE) pipeline
pipeline: dir=$(Drop)/Rabies_TZ/pipeline/SD_dogs/
pipeline:
	$(linkdirname)

#################################################################

Sources += $(wildcard *.R)

Ignore += sddogs.csv

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

## Side branch to maybe calculate some stats; not active 2024 Aug 06 (Tue)
biteStats.Rout: biteStats.R bitten.rds
	$(pipeR)

## Pull out _potential_ biters and make a frame
biters.Rout: biters.R bitten.rds
	$(pipeR)

## Link focal individuals to their biters
linked.Rout: linked.R bitten.rds biters.rds linked.md
	$(pipeR)

## The biteCount table should be at the level of animals, not bites
## What animals should be included, though? All the suspect ones, I guess
## I'm here and confused 2024 Aug 06 (Tue); why do we have NAs for Suspect?
biteCount.Rout: biteCount.R biters.rds linked.rds biteCount.md
	$(pipeR)

## Identify and eliminate outliers
calcs.Rout: calcs.R linked.rds
	$(pipeR)

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
