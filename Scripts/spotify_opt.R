# Loading Libraries

library(tidyverse)
library(plotly)
library(patchwork)
library(ggmosaic)
library(ggthemes) 
library(ggrepel)

# Data Prep ####


# Data Cleaning

spotify_df <- read.delim2("data_vz.csv", sep = "#")


# Data Transformation

spotify_df <- spotify_df %>% 
  
  # Adding Year, Month, and Day variables from Date
  mutate(Year = year(Date),
         
         Month = month(Date, label = TRUE, abbr = TRUE),
         
         Day = day(Date)) %>% 
  
  # Renaming Track.Name as Track
  rename(Track = Track.Name)



# Visualizations ####


# Heat Map


# We create a data frame with information about the tiles we want to highlight

highlight_dates <- data.frame(
  
  # Dates for Christmas eve and day
  date_of_month = c(24, 25),
  
  # Dates are in December
  month_categorical = factor("Dec")
)


# Data Transformation:

spotify_df %>% 
  
  #filter out 2021 due to incomplete data
  filter(Year != 2021) %>% 
  
  # We want our calculations to be on a daily basis for each month
  group_by(Month, Day) %>%
  
  # Calculating the total streams for each day of every month
  summarise(total_streams = sum(Streams)) %>%
  

# Plotting
  
  ggplot() + 
  
  aes(x = Day, 
      y = Month, 
      fill = total_streams) +
  
  # Heatmap with white borders
  geom_tile(color = "white") +
  
  # Viridis color scale (continuous) with reversed direction for better highlights
  scale_fill_viridis_c(
    name = "Total Streams",
    option = "viridis",
    direction = -1,
    labels = scales::label_comma(),
    guide = guide_colorbar(
      barwidth = 20, barheight = 0.3, position = "bottom"
    )
  ) +
  
  # Adding titles and caption
  labs(
    title = "Spotify Streaming Peaks Around Christmas",
    subtitle = "Daily streaming of top 200 Spotify hits (2017 - 2020)",
    caption = "Source: Spotify"
  ) +
  
  # Ensure x-axis displays all days in the month
  scale_x_continuous( breaks = 1:31) +
  
  # Minimal theme for a clean plot
  theme_minimal(base_family = "Lato") +
  
  # Customize plot elements
  theme(
    panel.grid = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.text.x = element_text(size = 7, color = "#191414"),
    axis.text.y = element_text(size = 8, color = "#191414"),
    legend.title = element_text(size = 10, hjust = 0.5, color = "#191414", face = "bold"),
    legend.title.position = "bottom",
    legend.text = element_text(size = 5, color = "#191414", hjust = 0.5),
    plot.caption = element_text(size = 8, color = "#1DB954", hjust = 1, face = "bold"),
    plot.title = element_text(size = 10, face = "bold", color = "#1DB954"),
    plot.subtitle = element_text(size = 9, color = "#191414")
  ) +
  
  # Highlight tiles for Dec 24 and Dec 25
  geom_tile(
    data = highlight_dates,
    aes(x = date_of_month, y = month_categorical),
    color = "red", fill = NA, size = 1.1)
  


# Christmas Themed Songs

# Define tracks to highlight
tracks_to_highlight <- c("Dance Monkey", "Blinding Lights")


# Prepare the data

spotify_df %>%
  
  # Filter for Decemeber
  filter(Month == "Dec") %>% 
  
  # We want results for individual tracks
  group_by(Track) %>% 
  
  # Total streams of each top 200 track on Spotify
  summarise(total_streams = sum(Streams), .groups = 'drop') %>% 
  
  # Arranging from most to least streamed
  arrange(desc(total_streams)) %>% 
  
  # Selecting top 10 tracks in December
  slice_head(n = 10) %>% 
  
  # Track is now an ordered factor variable with levels set according to no. of streams
  mutate(
    Track = fct_reorder(Track, total_streams, .desc = TRUE),
    Category = if_else(Track %in% tracks_to_highlight, "Other", "Christmas Theme")
  ) %>% 
  
  
  # Plotting
  
  ggplot(aes(x = Track, y = total_streams, fill = Category)) +
  
  # We want bar graphs
  geom_col() +
  
  # Using Christmas themes
  scale_fill_manual(
    name = "Song Category",
    values = c("Christmas Theme" = "#c60f0f", "Other" = "#1DB954")
  ) +
  
  # Minimal theme for visual appeal
  theme_minimal() +
  
  # Adding titles and caption 
  labs(
    title = "8 of the Top 10 Songs in December are Christmas-Themed",
    caption = "Source: Spotify"
  ) +
  
  # Adjusting Plot elements
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(angle = 45, 
                               hjust = 1, vjust = 1, face = "bold", size = 7, color = "#191414"),
    axis.text.y =element_text( size = 11, face = "bold",
                              color = "#191414"),
    axis.title = element_blank(),
    plot.title = element_text(
      size = 14, face = "bold", color = "#1DB954"),
    plot.caption = element_text(size = 12, 
                                color = "#1DB954", 
                                hjust = 1, face = "bold"),
    legend.text = element_text(size = 7)) +
  
  # Adding labels to each individual column
  geom_text(
    aes(label = sprintf("%.2f", total_streams / 1e6)), 
    vjust = -0.5, size = 3.5) +
  
  # We want custom y labels to make it clear that the scale is in millions
  scale_y_continuous(labels = scales::comma_format(scale = 1e-6, suffix = "M"))


