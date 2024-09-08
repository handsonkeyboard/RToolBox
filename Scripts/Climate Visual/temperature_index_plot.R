# load libraries
library(tidyverse)
library(ggplot2)
library(ggthemes)


# load temperature csv file and skip the first row
df <- read_csv("Data/Climate Visual/GLB.Ts+dSST.csv", skip = 1, na = "***")

# select only annual average temperature 
df_selected <- df %>% select(Year, `J-D`) %>%
                      rename(Avg_Temp = `J-D`)

# plot a static graph 
plot <- df_selected %>% # set Year as the x-axis and Avg_Temp as the y-axis
                        ggplot(aes(x = Year, y = Avg_Temp)) +
                        # add a line graph to the plot 
                        # set the color to a named category 1 for reference in the legend 
                        # show.legend = FALSE -> not show this element's legend 
                        geom_line(aes(color = "1"), size = 1, show.legend = FALSE) +
                        # add points with a white fill over the line graph 
                        # set the points to the color category 1
                        geom_point(fill = "white", aes(color = "1"), shape = 21, show.legend = TRUE) +
                        # add a LOESS smoothed line to help visualize the trend, with no standard error band (se = FALSE)
                        # assign it to color category 2
                        # set the smoothing parameter (span) to be 0.1 for a close fit
                        geom_smooth(aes(color = "2"), se = FALSE, method = "loess", size = 1, span = 0.1, show.legend = FALSE) 
                        # set the x-axis breaks every 20 years from 1880 to 2023
                        scale_x_continuous(breaks = seq(1880, 2023, 20), expand = c(0, 0)) +
                        # set the y-axis limit from -0.5 to 1.5    
                        scale_y_continuous(limits = c(-0.5, 1.5), expand = c(0, 0)) +
                        # manually define color scales
                        # name = NULL -> no title will be displayed for the color legend
                        # breaks = c(1, 2) -> two categories to link the aesthetic specifications with the legend
                        # values = c("gray", "blue") -> map colors to the breaks specified
                        # labels -> provide text for the legend, enhancing the meaning of the breaks
                        # guide -> customise the appearance of the legend symbols
                        scale_color_manual(name = NULL,
                                           breaks = c(1, 2),
                                           values = c("gray", "blue"),
                                           labels = c("Annual Mean", "Lowess Smoothing"),
                                           guide = guide_legend(override.aes = list(shape = 15, size = 3))) +
                        # set labels for axes and add a title and subtitle  
                        labs(x = "YEAR", 
                             y = "Temperature Anomaly (C)",
                             title = "GLOBAL LAND-OCEAN TEMPERATURE INDEX",
                             subtitle = "Data source: NASA's Goddard Institute for Space Studies (GISS)."#,
                             #caption = "Source:"
                             ) +
                        theme_light() +
                        # further customise specific aspects of the plot's theme
                        theme(# remove the tick marks from both the x-axis and y-axis
                              axis.ticks = element_blank(),
                              # set the position of the plot title 
                              # position the title within the plotting area, rather than outside or on top of the plotting margins
                              plot.title.position = "plot",
                              # add a margin below the title (10 points) to provide visual separation from the plot elements
                              # set the title color to red and make the title bold
                              plot.title = element_text(margin = margin(b = 10), color = "red", face = "bold"),
                              # specify the font size of the subtitle 
                              # add a margin below the subtitle
                              plot.subtitle = element_text(size = 10, margin = margin(b = 10)),
                              # specify the position of the legend within the plot
                              legend.position = c(0.15, 0.9),
                              # set the font size of the legend title to 0, effectively hiding it
                              legend.title = element_text(size = 0),
                              # specify the height of the keys (symbols) in the legend 
                              legend.key.height = unit(10, "pt"),
                              # eliminate any extra space around the legend
                              legend.margin = margin(0, 0, 0, 0))
                        
                    

plot


ggsave("Outputs/Climate Visual/Temperature_Index.png", width = 6, height = 4)