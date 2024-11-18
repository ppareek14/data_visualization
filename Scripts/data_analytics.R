# Load the dataset
library(readr)
spotify_data <- read.csv("data_spotify.csv", sep=";")
head(data)

# # Get a random sample of 10% of the rows to feed to chatgpt
# set.seed(123)  # Set seed for reproducibility
# sampled_data <- spotify_data[sample(nrow(spotify_data), size = nrow(spotify_data) / 10), ]
# # Save the sampled dataset to a new file
# write_csv(sampled_data, "sampled_file.csv")

library(ggplot2)
library(dplyr)
library(lubridate)

# Sum total streams per artist and get the top 10
top_artists <- spotify_data %>%
  group_by(Artist) %>%
  summarize(total_streams = sum(Streams)) %>%
  top_n(10, total_streams)

# Plot with Spotify colors
ggplot(top_artists, aes(x = reorder(Artist, total_streams), y = total_streams)) +
  geom_bar(stat = "identity", fill = "#1DB954") + # Spotify green color
  coord_flip() +
  labs(
    title = "Top 10 Most Streamed Artists (2017-2021)",
    x = "",  # Remove the y-axis caption
    y = "Total Streams",
    caption = "Source: Spotify"  # Add source caption
  ) +
  theme_minimal(base_family = "Arial") + # Use Arial font
  theme(
    plot.background = element_blank(),      # White background
    panel.background = element_blank(),     # White panel
    text = element_text(color = "black"),                # Black text for a white theme
    axis.text = element_text(color = "black"),           # Black axis text
    axis.title = element_text(color = "black"),          # Black axis titles
    plot.title = element_text(size = 16, face = "bold", color = "#1DB954"),  # Spotify green for title
    plot.caption = element_text(size = 10, face = "italic", color = "#1DB954", hjust = 1), # Green caption
    legend.position = "none"                             # Remove legend if any
  )

# Ensure Date is in Date format
spotify_data <- spotify_data %>%
  mutate(Date = as.Date(Date, format = "%d/%m/%Y"))

# Calculate total daily streams
daily_streams <- spotify_data %>%
  group_by(Date) %>%
  summarize(total_streams = sum(Streams, na.rm=TRUE))

# Plot with Spotify colors
ggplot(daily_streams, aes(x = Date, y = total_streams)) +
  geom_line(color = "#1DB954", size = 1) +  # Spotify green for the line
  labs(title = "Daily Total Streams Over Time", x = "Date", y = "Total Streams") +
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "black"),      # Black background
    panel.background = element_rect(fill = "black"),     # Black panel
    text = element_text(color = "white"),                # White text
    axis.text = element_text(color = "white"),           # White axis text
    axis.title = element_text(color = "white"),          # White axis titles
    plot.title = element_text(size = 16, face = "bold")  # Bold title
  )



################

library(dplyr)
library(stringr)
library(lubridate)
library(tidyr)

# Step 1: Clean up brackets and split genres
spotify_data_clean <- spotify_data %>%
  mutate(Genre = str_replace_all(Genre, "\\[|\\]|'", "")) %>% # Remove [ ], '
  separate_rows(Genre, sep = ", ") %>% # Split into separate rows for each genre
  group_by(Position, TrackName, Artist, Date, Streams) %>% # Group by unique track details
  summarize(first_genre = first(Genre)) %>% # Keep only the first genre
  ungroup() %>%
  mutate(
    genre_group = case_when(
      str_detect(first_genre, "dance|edm|house") ~ "Electronic",
      str_detect(first_genre, "pop") ~ "Pop",
      str_detect(first_genre, "rap|hip hop|trap") ~ "Hip Hop",
      str_detect(first_genre, "rock") ~ "Rock",
      str_detect(first_genre, "classical|orchestral") ~ "Classical",
      str_detect(first_genre, "latin|reggaeton") ~ "Latin",
      TRUE ~ "Other"  # For genres not covered in specific groups
    ),
    Year = year(Date), # Extract Year
    Month = month(Date), # Extract Month
    Season = case_when(
      Month %in% c(12, 1, 2) ~ "Winter",
      Month %in% c(3, 4, 5) ~ "Spring",
      Month %in% c(6, 7, 8) ~ "Summer",
      Month %in% c(9, 10, 11) ~ "Fall"
    )
  ) %>%
  filter(Year != 2021) # Remove rows from 2021


# # Ensure Date is in Date format and calculate daily streams per genre
# spotify_data_clean <- spotify_data_clean %>%
#   mutate(Date = as.Date(Date, format = "%d/%m/%Y"))

# Summarise daily streams per genre
daily_genre_trends <- spotify_data_clean %>%
  filter(!is.na(Date), !is.na(Streams), !is.na(genre_group)) %>% # Remove NA values
  group_by(Date, genre_group) %>%
  summarise(total_streams = sum(Streams, na.rm = TRUE)) %>% # Summarize streams by genre group
  ungroup() %>%
  group_by(Date) %>%
  mutate(proportion_streams = total_streams / sum(total_streams, na.rm = TRUE)) %>% # Calculate proportions
  mutate(proportion_streams = proportion_streams / sum(proportion_streams)) %>%  # Normalize proportions  
  ungroup() %>%
  mutate(
    genre_group = factor(
      genre_group,
      levels = rev(c("Pop", "Hip Hop", "Electronic", "Latin", "Rock", "Classical", "Other")
    )) # Set custom stacking order
  )

# Plot with adjustments
ggplot(daily_genre_trends, aes(x = Date, y = total_streams, color = genre_group)) +
  geom_line(size = 1) +
  scale_y_log10() +  # Apply log scale to better visualize a wide range of values
  labs(title = "Daily Genre Trends Over Time", x = "Date", y = "Total Streams (Log Scale)") +
  scale_color_viridis_d() +  # Use color palette suitable for many categories
  theme_minimal() 

ggplot(daily_genre_trends, aes(x = Date, y = total_streams, fill = genre_group)) +
  geom_area(alpha = 0.5) +  # Add transparency for overlapping areas
  labs(title = "Daily Genre Trends Over Time", x = "Date", y = "Total Streams") +
  scale_fill_viridis_d() +  # Use a palette suitable for multiple categories
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "black"),
    panel.background = element_rect(fill = "black"),
    text = element_text(color = "white"),
    axis.text = element_text(color = "white"),
    axis.title = element_text(color = "white"),
    plot.title = element_text(size = 16, face = "bold", color = "white")
  )

monthly_genre_trends <- spotify_data_clean %>%
  filter(!is.na(Date), !is.na(Streams), !is.na(genre_group)) %>% # Remove NA values
  mutate(Month = floor_date(Date, unit = "month")) %>% # Aggregate by month
  group_by(Month, genre_group) %>%
  summarise(total_streams = sum(Streams, na.rm = TRUE)) %>% # Total streams per month
  ungroup() %>%
  group_by(Month) %>%
  mutate(proportion_streams = total_streams / sum(total_streams, na.rm = TRUE)) %>% # Calculate proportions
  ungroup()

# Calculate initial proportions
initial_proportions <- monthly_genre_trends %>%
  group_by(genre_group) %>%
  filter(Month == min(Month)) %>%  # Find the earliest month for each genre
  summarize(initial_proportion = mean(proportion_streams, na.rm = TRUE)) %>% # Average if there are duplicates
  arrange(desc(initial_proportion))  # Sort by initial proportion in descending order

# Reorder genre_group based on initial proportions
monthly_genre_trends <- monthly_genre_trends %>%
  mutate(
    genre_group = factor(genre_group, levels = initial_proportions$genre_group)
  )

ggplot(monthly_genre_trends, aes(x = Month, y = proportion_streams, fill = genre_group)) +
  geom_area(alpha = 0.7) +  # White borders for clarity
  labs(
    title = "Pop dominates the music scene in the late 2010s",
    x = "",
    y = "Proportion of Total Streams",
    caption = "Source: Spotify"
  ) +
  scale_y_continuous(labels = scales::percent, expand = c(0, 0)) +  # Percent y-axis and remove gaps
  scale_x_date(expand = c(0, 0)) +  # Remove gaps on x-axis
  scale_fill_brewer(palette = "Set3") +  # Use a clear color palette for genres
  theme_classic() +  # Use a classic, clean theme
  theme(
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 12, face = "bold"),
    plot.title = element_text(size = 14, face = "bold",, color = "#1DB954"),
    plot.caption = element_text(size = 10, face = "bold", hjust = 1, color = "#1DB954"), # Green caption
    legend.position = "right",
    legend.title = element_blank()
  )

##################################################################

season_counts <- spotify_data_clean %>%
  group_by(Season) %>%
  summarize(count = n())

print(season_counts)

# Summarize streams by genre group and season
seasonal_genres <- spotify_data_clean %>%
  group_by(Season, genre_group) %>%
  summarise(total_streams = sum(Streams)) %>%
  filter(!is.na(Season)) 

# Plot heatmap with seasonal popularity of genre groups
ggplot(seasonal_genres, aes(x = Season, y = genre_group, fill = total_streams)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "#1DB954") +
  labs(title = "Seasonal Popularity of Genre Groups", x = "Season", y = "Genre Group") +
  theme_minimal()

###################################"

track_trends <- spotify_data_clean %>%
  group_by(TrackName, Artist, Date) %>%
  summarize(daily_streams = sum(Streams), .groups = "drop") %>%
  arrange(TrackName, Date)

track_lifespan <- track_trends %>%
  group_by(TrackName, Artist) %>%
  summarize(
    first_day = min(Date),  # Date of first recorded stream
    first_day_streams = daily_streams[which.min(Date)],  # Streams on the first day
    last_day = max(Date),   # Date of last recorded stream
    lifespan_days = as.numeric(last_day - first_day),  # Total lifespan in days
    peak_day = Date[which.max(daily_streams)],  # Day with highest streams
    peak_streams = max(daily_streams),  # Highest daily streams
    total_streams = sum(daily_streams), # Total streams across lifespan
    days_to_peak = as.numeric(peak_day - first_day),  # Days to reach peak
    decline_rate = (peak_streams - daily_streams[n()]) / lifespan_days,  # Simple decline rate
    rise_rate = ifelse(days_to_peak > 0, 
                       (peak_streams - first_day_streams) / days_to_peak, 
                       NA),  # Avoid dividing by zero
    .groups = "drop"
  )

track_lifespan <- track_lifespan %>%
  mutate(
    classification = case_when(
      lifespan_days <= 30 & decline_rate > 0.5 * peak_streams ~ "Viral",
      lifespan_days > 30 & decline_rate <= 0.3 * peak_streams ~ "Sustained",
      TRUE ~ "Other"
    )
  )

ggplot(track_lifespan, aes(x = lifespan_days)) +
  geom_histogram(bins = 100, alpha = 0.7, position = "dodge") +
  labs(title = "Lifespan Distribution of Tracks", x = "Lifespan (days)", y = "Number of Tracks") +
  scale_fill_brewer(palette = "Set3") +
  theme_minimal()

ggplot(track_lifespan, aes(y = lifespan_days)) + 
  geom_boxplot() + 
  scale_y_log10()

ggplot(track_lifespan, aes(x = lifespan_days, y = rise_rate)) +
  geom_point(alpha = 0.7, size = 3) +
  labs(
    title = "Longevity vs Virality of Tracks",
    x = "Lifespan (Days)",
    y = "Rise Rate (Streams/Day)",
    color = "Classification"
  ) +
  # scale_x_log10() +
  # scale_y_log10() +
  scale_color_brewer(palette = "Set2") +  # Clear color distinction
  theme_minimal() +
  theme(
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 12, face = "bold"),
    plot.title = element_text(size = 14, face = "bold"),
    legend.position = "right"
  )

# ggplot(track_trends %>% left_join(track_lifespan, by = c("TrackName", "Artist")),
#        aes(x = Date, y = daily_streams, group = TrackName, color = classification)) +
#   geom_line(alpha = 0.7) +
#   labs(title = "Daily Streams for Viral vs Sustained Tracks", x = "Date", y = "Daily Streams") +
#   scale_y_log10() +
#   scale_color_brewer(palette = "Set2") +
#   theme_minimal()


