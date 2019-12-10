# Customize this file!
# The only reaason that this file exists is that RStudio has an
# issue with multiprocess plan and apparently it's not stable,
# so, I'm leaving it out to run it in parallel via the Makefile

suppressWarnings(suppressMessages(library(tidyverse)))
suppressWarnings(suppressMessages(library(RSQLite)))
suppressWarnings(suppressMessages(library(reshape2)))
suppressWarnings(suppressMessages(library(ggthemes)))
suppressWarnings(suppressMessages(library(showtext)))
suppressWarnings(suppressMessages(library(metafor)))
suppressWarnings(suppressMessages(library(furrr)))
suppressWarnings(suppressMessages(library(data.table)))

plan(multiprocess)

project_path <- "outputs/"
project_name <- "yourprojectname"

filenames <- list.files(project_path, pattern = "*_pubs_prepared.csv", full.names = TRUE)


summarize_each_file <- function(fname) {

  df <- fread(fname)
  
  # You can use this snippet as an example of how to summarize your data for
  # later post-processing and plotting.
  agg_df <- df %>% 
    mutate(tnobs = factor(tnobs),
           n_items = factor(experiment_parameters_data_strategy_n_items),
           n_categories = factor(experiment_parameters_data_strategy_n_categories),
           k = factor(researcher_parameters_pre_processing_methods_0_multipliers_0),
           is_pre_processed = factor(researcher_parameters_is_pre_processing),
           abilities = experiment_parameters_data_strategy_abilities_1,
           difficulties = experiment_parameters_data_strategy_difficulties_0) %>%
    group_by(abilities, k, n_categories, n_items, difficulties, tnobs, is_pre_processed) %>%
    summarize(sig_mean = mean(sig),
              pval_mean = mean(pvalue),
              nobs_mean = mean(nobs)
    )
  
  return(agg_df)
}


read_all_files <- function(fnames) {

  options(warn =  -1)
  
  tbl <-
    files %>%
    map_df(~summarize_each_file(.), progress = TRUE)

  return(tbl)

}


df <- read_all_files(filenames)


write.csv(df, paste(project_path, project_name, "_summarized_df.csv"), row.names = FALSE)
