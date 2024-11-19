## Spotify Data Analysis: Top 200 Songs and Artist Performance

This repository contains an analysis of Spotify's Top 200 songs from 2017 to 2021. The primary objective is to explore trends in song popularity, artist performance, and genre dominance over time. Key highlights of the analysis include the investigation of Post Malone's album releases and their impact on his streaming numbers, as well as an exploration of trends in various music genres and featuring vs. solo songs.



## Table of Contents

1. Loading Libraries
2. Loading and Inspecting the Data
3. Handling Missing Data
4. Feature Engineering
5. Top 200 Songs Streams Over Time
6. Genre Performance Over Time
7. Post Malone's Stream Growth
8. December Streaming Trends
9. Featuring vs Solo Songs
10. Saving the Cleaned Data



## 1. Loading Libraries

We start by loading essential libraries for data manipulation, visualization, and date handling. These libraries enable the processing of data, creating compelling visualizations, and analyzing trends.

The key libraries used in this analysis include:

tidyverse: A collection of R packages used for data manipulation and visualization.
lubridate: Helps to work with dates more efficiently.
skimr: Provides an easy way to summarize the dataset and detect issues like missing values.
viridis: A color scale package used for creating visually appealing plots.

## 2. Loading and Inspecting the Data

The dataset used in this analysis contains streaming information for songs in the Top 200. We load the data from a CSV file and inspect its structure. The summary reveals essential insights, such as the number of records, missing data, and basic statistics of the streams.

## 3. Handling Missing Data

Upon inspecting the dataset, we identified missing values. These values were handled by removing rows with missing data points to ensure clean and accurate analysis.

## 4. Feature Engineering

To gain more insight into the dataset, several new features were engineered:

Month, Day, Year: Extracted from the Date column to allow for monthly and yearly aggregations.
Featuring: A binary variable created to indicate whether a track features another artist. This was determined based on the presence of "feat." or "Feat." in the track name.

## 5. Top 200 Songs Streams Over Time

We analyzed how the total streams of the Top 200 songs have increased over time from 2017 to 2021. By grouping the data by date, we calculated the total streams for each day and visualized the trend over the years. A smoothed line was added to show the overall upward trajectory, with the conclusion that streams have been steadily increasing, particularly after 2019.

## 6. Genre Performance Over Time

The genre analysis looked at how different music genres performed over time. The genre data was cleaned and categorized into broader groups such as Electronic, Pop, Hip Hop, Rock, Classical, and Latin. We examined how the proportions of total streams across these genres evolved each month. The analysis revealed that Pop music surged in popularity over the late 2010s, while other genres like Hip Hop and Rock also saw significant streaming activity.

## 7. Post Malone's Stream Growth

Post Malone's streaming growth was a key focus of this analysis. We specifically looked at the impact of his album releases on his song counts in the Top 200. The albums "Beerbongs & Bentleys" (released in April 2018) and "Hollywood's Bleeding" (released in August 2019) caused noticeable spikes in his streams. This was highlighted with red markers in the plot, showing that both releases had a strong positive effect on the number of his songs in the Top 200.

## 8. December Streaming Trends

To explore seasonality, we focused on December, particularly the Christmas period, and its effect on streaming. By visualizing daily streams of top songs in December over several years, we observed significant peaks around Christmas Eve and Christmas Day. The analysis also highlighted popular tracks in December, including Christmas-themed songs, and showed that Christmas-themed songs dominated the December charts.

## 9. Featuring vs Solo Songs

We explored whether featuring artists contributed more to the popularity of songs than solo artists. Using monthly data, we calculated the average streams for both featuring and solo songs, along with their confidence intervals. The analysis showed that featuring songs had consistently higher streams than solo songs, with a marked increase in popularity after the COVID-19 pandemic began.

## 10. Saving the Cleaned Data

After processing and cleaning the data, the final cleaned dataset was saved for future use. This dataset contains the key features we engineered and can be used for further analysis or modeling.