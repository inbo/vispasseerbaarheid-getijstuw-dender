library(dplyr)
library(ggplot2)
library(tidyr)
library(zoo)

# --- New Function to plot multiple variables with separate y-axes ---
plot_tidal_cycle_analysis_combined <- function(data, chosen_date) {

  # Filter the data for the requested day
  if (class(chosen_date)[1]=="POSIXct") {plot_data <- data %>% dplyr::filter(date == chosen_date)}
  else {plot_data <- data %>% dplyr::filter(V_o < 10)}

  # Calculate h_si and combine the fish passage variables for easy plotting
  plot_data <- plot_data %>%
    mutate(
      h_si = case_when(
        h_upstream > h_downstream ~ h_upstream - h_o,
        h_upstream < h_downstream ~ h_downstream - h_o,
        TRUE ~ NA_real_
      ),
      passage_over = ifelse(passeerbaar_stroomopwaarts_over_stuw == "yes", "Over stuw", NA_character_),
      passage_under = ifelse(passeerbaar_stroomopwaarts_onder_stuw == "yes", "Onder stuw", NA_character_)
    )

  # Prepare data for plotting
  plot_data_long <- plot_data %>%
    select(date_utc, h_upstream, h_downstream, h_o, h_si, sluice_opening, V_o, V_u) %>%
    pivot_longer(
      cols = -date_utc,
      names_to = "parameter",
      values_to = "value"
    ) %>%
    mutate(
      category = case_when(
        parameter %in% c("h_upstream", "h_downstream", "h_o", "h_si", "sluice_opening") ~ "Hoogte (m)",
        parameter %in% c("V_o", "V_u") ~ "Stroomsnelheid (m/s)"
      ),
      parameter = factor(parameter, levels = c("h_upstream", "h_downstream", "h_o", "h_si", "sluice_opening", "V_o", "V_u"))
    )

  # Create the combined plot using facets
  g<-ggplot(plot_data) +
    # Highlight periods of fish passage as a background
    geom_rect(
      aes(xmin = date_utc, xmax = lead(date_utc), ymin = -5, ymax = 15, fill = passage_over),
      alpha = 0.2
    ) +
    geom_rect(
      aes(xmin = date_utc, xmax = lead(date_utc), ymin = -5, ymax = 15, fill = passage_under),
      alpha = 0.2
    ) +
    geom_line(data = plot_data_long, aes(x = date_utc, y = value, color = parameter, linetype = parameter), size = 1) +
    facet_wrap(~category, ncol = 1, scales = "free_y") +
    labs(
      title = paste("Getijcycli", chosen_date),
      subtitle = "Waterpeil, hoogteverschil en stroomsnelheden",
      x = "Tijd",
      y = "Waarde",
      color = "parameter",
      fill = "Vispassage"
    ) +
    scale_fill_manual(
      values = c("Over stuw" = "lightgreen", "Onder stuw" = "darkgreen"),
      na.value = "transparent",
      na.translate = FALSE
    ) +
    scale_color_manual(
      values = c("h_upstream" = "blue", "h_downstream" = "darkblue", "h_o" = "darkred", "h_si" = "darkgrey", "sluice_opening" = "black", "V_o" = "blue", "V_u" = "black")
    ) +
    # Add manual scale for linetype
    scale_linetype_manual(
      values = c(
        "h_upstream" = "solid",
        "h_downstream" = "solid",
        "h_o" = "dotted",
        "h_si" = "dashed",
        "sluice_opening" = "dashed",
        "V_o" = "solid",
        "V_u" = "solid"
      )
    ) +
    theme_minimal()
  if (class(chosen_date)[1]!="POSIXct"){g <- g + theme(legend.position="none")}
  g
}
