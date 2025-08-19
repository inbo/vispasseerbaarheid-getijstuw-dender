# Function to plot a single day
plot_tidal_cycle_analysis <- function(data, chosen_date) {

  # Filter the data for the requested day
  plot_data <- data %>%
    dplyr::filter(date == chosen_date) %>%
    # Calculate h_si and combine the fish passage variables for easy plotting
    mutate(
      passage_over = ifelse(passeerbaar_stroomopwaarts_over_stuw == "yes", "Over Sluice", NA_character_),
      passage_under = ifelse(passeerbaar_stroomopwaarts_onder_stuw == "yes", "Under Sluice", NA_character_)
    )

  # Reshape the data for a single-line plot
  plot_data_long <- plot_data %>%
    select(date_utc, h_upstream, h_downstream, h_o, sluice_opening, sluice_height) %>%
    pivot_longer(
      cols = -date_utc,
      names_to = "variable",
      values_to = "value"
    ) %>%
    mutate(
      variable = factor(variable, levels = c("h_upstream", "h_downstream", "h_o", "sluice_opening", "sluice_height"))
    )

  # Create the plot
  ggplot(plot_data) +
    # Highlight periods of fish passage as a background
    geom_rect(
      aes(xmin = date_utc, xmax = lead(date_utc), ymin = -Inf, ymax = Inf, fill = passage_over),
      alpha = 0.3, show.legend = FALSE
    ) +
    geom_rect(
      aes(xmin = date_utc, xmax = lead(date_utc), ymin = -Inf, ymax = Inf, fill = passage_under),
      alpha = 0.3, show.legend = FALSE
    ) +
    # Add the main lines for each variable
    geom_line(data = plot_data_long, aes(x = date_utc, y = value, color = variable), size = 1) +
    # Add a separate line for the sluice opening, as its values are smaller
    geom_line(aes(x = date_utc, y = sluice_opening), color = "black", linetype = "dashed", size = 1) +
    labs(
      title = paste("Tidal Cycle", chosen_date),
      subtitle = "Water Levels, Head, and Sluice Opening",
      x = "Time",
      y = "Height (m)",
      color = "Variable"
    ) +
    scale_fill_manual(
      name = "Fish Passage",
      values = c("Over Sluice" = "green", "Under Sluice" = "purple"),
      na.value = "transparent",
      aesthetics = "fill"
    ) +
    scale_color_manual(
      values = c(
        "h_upstream" = "blue",
        "h_downstream" = "darkblue",
        "h_o" = "red",
        "sluice_opening" = "orange",
        "sluice_height" = "black"
      )
    ) +
    theme_minimal()
}
