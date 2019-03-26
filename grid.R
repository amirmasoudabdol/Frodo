#!/usr/local/bin/Rscript
# Point the variable above to your Rscript executable, or run this script 
# using `Rscript grid.R`

suppressWarnings(suppressMessages(library(utils)))

# Adjust the parameters according to your preferences. You can 
# add values to each list, and `expand.grid` creates a data frame
# from all combinations of the supplied vectors.

# NOTES:
# - Use 0 for FALSE, and 1 for TRUE
# - Use the full decimal, e.g., 0.1 instead of .1 or 1.

df <- expand.grid(
		debug=c(0),
		verbose=c(0),
		progress=c(1),
		nsims=c(1),
		masterseed=c(42),
		saveoutput=c(1),
		outputpath=c("output/"),
		outputprefix=c(""),
		metaseed=c(43),
		datastrategy=c("Linear Model"),
		nc=c(1),
		nd=c(2),
		ni=c(0),
		nobs=c(20),
		mu=c(0.25, 0.50, 0.75),
		var=c(0.01),
		cov=c(0.0),
		loadings=c(0.1),
		errvars=c(0.0),
		errcovs=c(0.0),
		teststrategy=c("TTest"),
		testside=c(1),
		testalpha=c(0.05),
		pubbias=c(0.95),
		selectionmodel=c("Significant Selection"),
		maxpubs=c(70),
		journalalpha=c(0.05),
		journalside=c(1),
		ishacker=c(0),
		hackid=c("0"),
		decisionstrategy=c("Patient Decision Maker"),
		decisionpref=c("Min Pvalue")
		)

write.table(df, file="params.pool", sep=" ",
			  row.names = FALSE,
			  col.names = FALSE)