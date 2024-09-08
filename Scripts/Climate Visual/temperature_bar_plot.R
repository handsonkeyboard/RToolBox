# clear workspace
rm(list=ls())

# load libraries
library(tidyverse)
library(ggplot2)
library(ggthemes)
library(scales)


# load temperature csv file and skip the first row
df <- read_csv("Data/Climate Visual/GLB.Ts+dSST.csv", skip = 1, na = "***")

# select only annual average temperature 
t_data <- df %>% select(Year, `J-D`) %>%
                      rename(Avg_Temp = `J-D`) %>%
                      drop_na()

# label initial and final years
annotation <- t_data %>% arrange(Year) %>%
                         slice(1, n()) %>%
                         mutate(Avg_Temp = 0, 
                                x = Year + c(-5, 5))
                         

# plot a bar chart
t_bar <- t_data %>% ggplot(aes(x = Year, y = Avg_Temp, fill = Avg_Temp)) +
                    geom_col(show.legend = FALSE) +
                    geom_text(data = annotation, aes(x = x, label = Year), color = "white") +
                    geom_text(x = 1880, y = 1, label = "Global temperatures have increased by over 1.2\u00B0C since 1880", 
                              color = "white", 
                              hjust = 0) +
                    # scale_fill_gradient2(low = "darkblue", mid = "white", high = "darkred", midpoint = 0,
                    #                      limits = c(-0.5, 1.5)) +
                    scale_fill_gradientn(colors = c("darkblue", "white", "darkred"),
                                         values = rescale(c(min(t_data$Avg_Temp), 0, max(t_data$Avg_Temp))),
                                         limits = c(min(t_data$Avg_Temp), max(t_data$Avg_Temp)),
                                         n.breaks = 10) +
                    theme_void() +
                    theme(plot.background = element_rect(fill = "black"),
                          legend.text =  element_text(colour = "white"))

t_bar

ggsave("Outputs/Climate Visual/Temperature_Bar.png", width = 8, height = 4)
