
df <- read.csv("final.csv")
distinct_state <- slice(group_by(df, State.Name), 1)