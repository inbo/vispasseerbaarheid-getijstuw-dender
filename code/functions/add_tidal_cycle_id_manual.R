add_tidal_cycle_id_manual <- function(data, smoothing_hours = 3) {
  time_diffs <- as.numeric(diff(data$date_utc), units = "mins")
  data_resolution_in_minutes <- median(time_diffs, na.rm = TRUE)
  if (is.na(data_resolution_in_minutes) || data_resolution_in_minutes <= 0) {
    stop("Could not determine data resolution from 'date_utc' column.")
  }
  smoothing_window <- round((smoothing_hours * 60) / data_resolution_in_minutes)
  if (smoothing_window < 3) {
    warning("Smoothing window is too small, setting to 3.")
    smoothing_window <- 3
  }
  if (smoothing_window > nrow(data)) {
    stop("Smoothing window size is larger than the number of data points.")
  }
  data <- data %>%
    mutate(
      smoothed_h_downstream = rollmean(h_downstream, k = smoothing_window, fill = NA, align = "center")
    ) %>%
    mutate(
      is_low_tide = (smoothed_h_downstream < dplyr::lag(smoothed_h_downstream, default = first(smoothed_h_downstream))) &
        (smoothed_h_downstream < lead(smoothed_h_downstream, default = last(smoothed_h_downstream))),
      new_cycle_start = ifelse(is.na(is_low_tide), FALSE, is_low_tide),
      tidal_cycle_id = cumsum(new_cycle_start)
    ) %>%
    mutate(
      tide_direction_raw = diff(c(NA, smoothed_h_downstream)),
      tide_direction = case_when(
        tide_direction_raw > 0 ~ "Vloed",
        tide_direction_raw < 0 ~ "Eb",
        TRUE ~ NA_character_
      )
    ) %>%
    select(-smoothed_h_downstream, -is_low_tide, -new_cycle_start, -tide_direction_raw)
  return(data)
}
