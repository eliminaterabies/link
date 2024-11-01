## Goes with bitten.R

We want all bites in the bitten data frame. 

## Dogs bitten multiple times

We first screen out bites that are reported to be linked to “no” or “impossible” rabies, _unless_ they have an incubation period or a Symptom date.

We then keep track of how many bites a dog has for the future.

We don't remove anything yet, because we hope to do more better screening downstream. 

2024 Oct 23 (Wed)
=================

Working on this pretty actively now. Not yet fixed downstream.

2024 Nov 01 (Fri)
=================

Problem 1. Date.bitten is no longer a date in our pipeline
* SOLVED: (if_else)

Problem 3. We have repeats that we don't understand; we should not have events in our biter list 

Problem 2. We have one dog that was suspected of rabies twice, and we don't have any date information for one of them; kick back to Glasgow (with pipeline)
