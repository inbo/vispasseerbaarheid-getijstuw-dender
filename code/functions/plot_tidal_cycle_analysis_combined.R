library(dplyr)
library(ggplot2)
library(tidyr)
library(zoo)

# --- New Function to plot multiple variables with separate y-axes ---
plot_tidal_cycle_analysis_combined <- function(data, chosen_date) {

  # Filter the data for the requested day
  plot_data <- data %>%
    dplyr::filter(date == chosen_date) %>%
    # Calculate h_si and combine the fish passage variables for easy plotting
    mutate(
      h_si = case_when(
        h_upstream > h_downstream ~ h_upstream - h_o,
        h_upstream < h_downstream ~ h_downstream - h_o,
        TRUE ~ NA_real_
      ),
      passage_over = ifelse(passeerbaar_stroomopwaarts_over_stuw == "yes", "Over Sluice", NA_character_),
      passage_under = ifelse(passeerbaar_stroomopwaarts_onder_stuw == "yes", "Under Sluice", NA_character_)
    )

  # Prepare data for plotting
  plot_data_long <- plot_data %>%
    select(date_utc, h_upstream, h_downstream, h_o, h_si, sluice_opening, V_o, V_u) %>%
    pivot_longer(
      cols = -date_utc,
      names_to = "variable",
      values_to = "value"
    ) %>%
    mutate(
      category = case_when(
        variable %in% c("h_upstream", "h_downstream", "h_o", "h_si", "sluice_opening") ~ "Height (m)",
        variable %in% c("V_o", "V_u") ~ "Velocity (m/s)"
      ),
      variable = factor(variable, levels = c("h_upstream", "h_downstream", "h_o", "h_si", "sluice_opening", "V_o", "V_u"))
    )

  # Create the combined plot using facets
  ggplot(plot_data) +
    # Highlight periods of fish passage as a background
    geom_rect(
      aes(xmin = date_utc, xmax = lead(date_utc), ymin = -Inf, ymax = Inf, fill = passage_over),
      alpha = 0.2
    ) +
    geom_rect(
      aes(xmin = date_utc, xmax = lead(date_utc), ymin = -Inf, ymax = Inf, fill = passage_under),
      alpha = 0.2
    ) +
    geom_line(data = plot_data_long, aes(x = date_utc, y = value, color = variable), size = 1) +
    facet_wrap(~category, ncol = 1, scales = "free_y") +
    labs(
      title = paste("Tidal Cycle", chosen_date),
      subtitle = "Water Levels, Head, and Velocities",
      x = "Time",
      y = "Value",
      color = "Variable",
      fill = "Fish Passage"
    ) +
    scale_fill_manual(
      values = c("Over Sluice" = "green", "Under Sluice" = "purple"),
      na.value = "transparent"
    ) +
    scale_color_manual(
      values = c("h_upstream" = "blue", "h_downstream" = "darkblue", "h_o" = "red", "h_si" = "orange", "sluice_opening" = "black", "V_o" = "red", "V_u" = "darkred")
    ) +
    theme_minimal()
}
