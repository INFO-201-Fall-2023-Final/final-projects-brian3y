library(dplyr)
library(stringr)


# Load in dataset
homeless_df <- read.csv("Homeless_Data.csv")
housing_df <- read.csv("Housing_Data.csv")


# Add new column state_code that stores two letters abbreviation
housing_df <- mutate(housing_df,
                     state_code = state.abb[match(housing_df$State.Name, state.name)])