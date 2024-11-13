Trying to build shared code for linking the output of the pipeline

The input file is focused on bites and has information about bitten dogs with a link to suspected biters

We should:

* Clean the data (clean.R?)

See bitten.md: bitten.R cleans up some things, and counts how many times each bitten dog had a bite that led to some consequences (e.g., symptoms, suspicion). The idea is that bites not associated with flags count as end points (the biter bit and so it's a potential generation interval) but not for other purposes.

After these “rabies flags” are counted, we drop previously calculated incubation periods for any dog with more than one flagged bite. If a dog has more than one symptom date reported we should drop these dates and report situation to Glasgow.

