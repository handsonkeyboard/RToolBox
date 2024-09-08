# load libraries
library(tidyverse)
library(ggplot2)
library(ggthemes)


# load temperature csv file and skip the first row
df <- read_csv("Data/Climate Visual/GLB.Ts+dSST.csv", skip = 1, na = "***")

# select only annual average temperature 
df_selected <- df %>% select(Year, `J-D`) %>%
                      rename(Avg_Temp = `J-D`)

#