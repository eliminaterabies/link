## This is eliminaterabies/link 2024 Jul 17 (Wed)

current: target
-include target.mk
Ignore = target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

## Use Dropboxes to pass and cache data so that we can keep the code open

## Make a local.mk (locally ☺) if you want to reset the Dropbox base directory
Ignore += local.mk
Drop = ~/Dropbox
-include local.mk

## Original data
Ignore += datadir
datadir/%:
	$(MAKE) datadir
datadir: dir=$(Drop)/Rabies_TZ/
datadir:
	$(linkdirname)

## Pipeline outputs (different pointer inside the same Dropbox)
Ignore += pipeline
pipeline/%:
	$(MAKE) pipeline
pipeline: dir=$(Drop)/Rabies_TZ/pipeline/SD_dogs/
pipeline:
	$(linkdirname)

#################################################################

Sources += $(wildcard *.R)

Ignore += dogs.csv

update_dogs:
	$(RM) dogs.csv
dogs.csv: | pipeline
	$(LNF) pipeline/SD_dogs.incubation.Rout.csv $@ 

######################################################################

bitten.Rout: bitten.R dogs.csv
	$(pipeR)

## Link events to parallel events for the upstream biter
## Produces table links
linked.Rout: linked.R bitten.rds
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
