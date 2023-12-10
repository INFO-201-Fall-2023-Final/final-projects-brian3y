library(dplyr)
library(stringr)
library(tidyr)


# Load in dataset
homeless_df <- read.csv("Homeless_Data.csv")
housing_df <- read.csv("Housing_Data.csv")


mutate_dataframe <- function(homeless_df, housing_df) {
  # Add new column state_code that stores two letters abbreviation
  housing_df <- mutate(housing_df,
                       state_code = state.abb[match(housing_df$State.Name, state.name)])
  
  homeless_df <- filter(homeless_df,
                        homeless_df$Year >= '1/1/2007',
                        homeless_df$Year <= '1/1/2011')
  
  housing_df <- filter(housing_df,
                       housing_df$Start.Year >= '1/1/2007',
                       housing_df$End.Year <= '1/1/2011')
  
  homeless_df$Count <- gsub(",", "", homeless_df$Count)
  homeless_df$Count <- as.integer(homeless_df$Count)
  
  homeless_df <- homeless_df %>%
                   group_by(State, Measures) %>%
                     summarise(total_count = sum(Count, na.rm = TRUE), .groups = 'keep')
  
  homeless_df <- pivot_wider(homeless_df, names_from = Measures, values_from = total_count)
  
  df <- merge(x = housing_df,
              y = homeless_df,
              by.x = 'state_code',
              by.y = 'State')
  
  df <- df %>%
    select(-Start.Year, -End.Year, -geoid)
  
  return(df)
}


final_df <- mutate_dataframe(homeless_df = homeless_df, housing_df = housing_df)

