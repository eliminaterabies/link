We want all bites in the bitten data frame. Maybe it should be called bites. But we only want one record per dog in the biter data frame, for linking. We have decided to separate bitten and biters as separate dataframes pre-linking. 

A dog with two bites with rabies flags (Suspected, bestInc, or Symptoms) should not have any incubation period. Any dog with two different Symptoms.started should not have any Symptom.started date.


MLi: We don't need this for R0, but will need it for correlations
