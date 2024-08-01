library(shellpipes)
library(dictClean)
manageConflicts()

library(dplyr)

animal <- rdsRead()
cols <- tsvRead()

animal <- animal[names(animal) %in% cols[["fieldName"]]]
names(animal) <- patchDict(names(animal), cols)

animal |> mutate_if(is.character, as.factor) |> summary()

rdsSave(animal)
