We wamt all bites in the focal data frame. But we only want one record per dog in the biter data frame, for linking.

The pipeline cleaned things by record, so we could still have questionable information when looking at the level of a dog. Any dog with two different values of bestInc should have these replaced by NA; similarly for symptoms.started. A dog with two different “suspect” bites (i.e., Suspect in (Yes, To Do, Unkonw)) cannot be listed in the biter data frame. This is so that the left_join will not duplicate bite records.
