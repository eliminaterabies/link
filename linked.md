For linked we only keep rows where we have linked to a potential biter to a bitee, so we are going to use an inner join. For other bites,  we need to go back to the “bitten” table. For other potential biters, we go back to the biters table.

Missing biters show up in the original Biter.ID column, but never in the ID column. Have we discussed this with Glasgow?

We use an inner join. The missingBiters get dropped, but this should not affect us; they have no IDs, and so they are not in our denominator or numerator. Should we make a little script to check that we understand this correctly?
