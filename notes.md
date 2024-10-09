2024 Oct 9 (Wed)
================

We need to read over both MS to determine what info is needed in what ms. 

For R0, we need sddogs which is processed rabiesTZ, and then everything in linked. Do we want redo hampson et al GI construction method or just cite the 2009 paper? We actually do need bitestats but for linked to do GI sampling. 

For correlations, we will need the biteStats before linked. 


2024 Aug 13 (Tue)
=================

Try to reconcile earlier and later decisions about floors and ceilings. There is stuff recorded in the html report in the pipeline repo, but it is incomplete (no ceiling for long intervals!) and doesn't seem to match what we said yesterday.

There seems to be no ceiling recorded for long incubation periods because there aren't any very long ones. But we need to worry about generations; we should also add the medium-long incubation periods to the pipeline repo.

How to split repos? Right now we have split between pre-link and linking; this probably means that each repo needs to do its own reporting and curating.

2024 Aug 12 (Tue)
=================

Not sure how I'm feeling about these new numbers; apparently we all forgot that there were old numbers in the pipeline repo.

Expecting to hear back from Sikana about clean up, hopefully soon. Once we hear from him, will try to do some checking and communicate back.

> Most of our calculated symptomatic waiting periods are 0 days, which
> kind of seems fine. The proportion is suspiciously high, but I think
> there is no question that 0 should be our floor.

## Short intervals (waiting times, infectious period)

> Ceiling.

Throw out: 14
Check: 10

> Floor

> I don't remember any discussions of floors for generation intervals or
> incubation periods, but I kind of think we should have one. 

0d (check as well as throw out, of course). There are too many 0d intervals, and we should think about this for a future statistical model.

> Ceiling, the current code has examples with 100, 150 and 1000 days.

## Long intervals (generations and incubation)

how long is the incubation period for canine rabies in domestic dogs?

> Floor (still waiting for Katie)
Check: 14d
Reject: 10d

> Ceiling
Check: 180d
Reject: 730d


----------------------------------------------------------------------

What data do we need for each project? What decisions should we make? Do any of them need to be different?

MLi: Figure out what are the overlaps for R0 and correlations
	- linked (link biters with bitees)
		- Multiple exposures are a problem, do we handle them here? 
		- The major problem is when both the biter and/or bitee have multiple exposures thus, it will create multiple links. 
		- For example, if my biter have multiple exposures, then I have mutliple links. If I have multiple exposures, then I will have multiple links for each of my exposures.
	- calc (calculate time intervals from dates)
	- once (Dropping animals bitten more than once)
	- incubations (biter, bitee, weighted incubations)
	- intervals (tidy time intervals and compute statistics)

## R0 paper

bitten. and linked. are just lists of scalars; intervals is a list of computed intervals

## Correlations paper

