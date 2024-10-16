We want all bites in the bitten data frame. Maybe it should be called bites. But we only want one record per dog in the biter data frame, for linking. We have decided to separate bitten and biters as separate dataframes pre-linking. 

A dog with two bites with rabies flags (Suspected, bestInc, or Symptoms) should not have any incubation period, because we don't know the start of incubation. Any dog with more than one different Symptoms.started date should not have any Symptom.started date go forward. These dogs are not currently involved in any serial intervals (even though maybe they should be involved in forward serial intervals). These dogs are currently involved in backward generation intervals, which is fine, but are they involved in forward generation intervals.

MLi: We don't need this for R0, but will need it for correlations


2024 Oct 16 (Wed)
=================

Dogs bitten multiple times. The most consistent approach is to delete the symptom date when they are a bitee (because we don't know which dog to link it to), but not when they are a biter. Conversely, we delete the bite date when they are a biter (we don't know which bite started the generation), but now when they are a bitee (because we are ending GIs with any bite).

What we are doing now is more conservative; we delete the symptom date of the bitee, and delete the whole dog if it's a biter. 
