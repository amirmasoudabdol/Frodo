# Customize this file!
# The only reaason that this file exists is that RStudio has an
# issue with multiprocess plan and apparently it's not stable,
# so, I'm leaving it out to run it in parallel via the Makefile

suppressWarnings(suppressMessages(library(tidyverse)))
suppressWarnings(suppressMessages(library(furrr)))
suppressWarnings(suppressMessages(library(data.table)))

plan(multiprocess)

project_path <- "outputs/"
project_name <- "marjan_2012_large"

# Currently I'm mainly processing prepared publications datasets as
# they contain most of the data that I need, but you can apply this
# script on other outputs as well, e.g., `stats`.
filenames <- list.files(project_path, pattern = "*_pubs_prepared.csv", full.names = TRUE)

# Reading and summarizing each file
summarize_each_file <- function(fname) {

  df <- fread(fname)
  
  # You can use this snippet as an example of how to summarize your data for
  # later post-processing and plotting.
  df %>% 
    # filter(effect > 0) %>%
    mutate(tnobs = factor(tnobs),
           nobs = nobs,
           covs = factor(experiment_parameters_data_strategy_measurements_covs),
           decision_strategy = factor(researcher_parameters_decision_strategy__name),
           is_hacked = factor(researcher_parameters_is_phacker),
           selection_policy = factor(researcher_parameters_decision_strategy_decision_policies_0_0),
           tmean = experiment_parameters_data_strategy_measurements_means_2,
           effect = effect) %>%
    mutate(eff_abs_diff= effect - tmean) %>%
    group_by(tmean, tnobs, covs, decision_strategy, is_hacked, selection_policy) %>%
    summarize(sigmean = mean(sig[effect > 0.0]),
              mean_nobs = mean(nobs),
              mean_eff = mean(effect),
              mean_eff_diff = mean(eff_abs_diff)) %>%
              mutate(size = "Large") -> agg_df
  
  return(agg_df)
}


# Reading and summarizing all files in parallel
read_all_files <- function(fnames) {

  options(warn =  -1)
  
  tbl <-
    filenames %>%
    future_map_dfr(~summarize_each_file(.), .progress = FALSE)

  return(tbl)

}

df <- read_all_files(filenames)

# Removig the grouping columns
df <- data.frame(df)


write.csv(df, paste(project_path, project_name, "_summarized_df.csv", sep=""), row.names = FALSE)
