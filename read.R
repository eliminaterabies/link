library(shellpipes)
manageConflicts()

library(dplyr)
library(readr)

## Read csv
## There is a known problem in column 65, we're not using it.
animal <- csvRead(comment="#", show_col_types=TRUE, col_select = -65)

## Summarize all fields
animal |> mutate_if(is.character, as.factor) |> summary()

## output field names
data.frame(
	fieldName = names(animal)
	, newName = NA
) |> tsvSave(ext="Rout.TSV")

print(dim(animal))

rdsSave(animal)
