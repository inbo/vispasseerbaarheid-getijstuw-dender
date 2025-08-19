analyze_flow_and_passage <- function(data) {

  # Total number of observations
  total_rows <- nrow(data)

  # --- 1. Determine Flow Conditions ---
  # 'flow_over' is TRUE if Q_o_required is greater than 0
  flow_over <- data$Q_o != 0

  # 'flow_under' is TRUE if Q_u_required is greater than 0
  flow_under <- data$Q_u != 0

  # 'no_flow' is TRUE if neither flow_over nor flow_under is TRUE
  no_flow <- !(flow_over | flow_under)

  # 'both_flow' is TRUE if both flow_over and flow_under are TRUE
  both_flow <- flow_over & flow_under

  free_flow_over <- data$freeflow_via_weir == "yes"

  free_flow_under <- data$freeflow_via_sluice == "yes"

  # --- 2. Calculate Flow Distribution Percentages ---
  pct_flow_over <- sum(flow_over) / total_rows * 100
  pct_flow_under <- sum(flow_under) / total_rows * 100
  pct_no_flow <- sum(no_flow) / total_rows * 100
  pct_both_flow <- sum(both_flow) / total_rows * 100
  pct_free_flow_over <- sum(free_flow_over) / total_rows * 100
  pct_free_flow_under <- sum(free_flow_under) / total_rows * 100

  # --- 3. Calculate Fish Passage Success Rates ---

  # Percentage of fish passage over the sluice
  # Handle division by zero if there's no flow over the sluice
  if (sum(flow_over) > 0) {
    pct_passeerbaar_over <- sum(data$passeerbaar_stroomopwaarts_over_stuw == "yes" & flow_over) / sum(flow_over) * 100
    pct_bereikbaar_over <- sum(data$bereikbaar_stroomopwaarts_over_stuw == "yes" & flow_over) / sum(flow_over) * 100
    pct_passeerbaar_free_flow_over <- sum(data$passeerbaar_stroomopwaarts_over_stuw == "yes" & free_flow_over) / sum(free_flow_over) * 100
  } else {
    pct_passeerbaar_over <- NA_real_
    pct_bereikbaar_over <- NA_real_
    pct_passeerbaar_free_flow_over <- NA_real_
  }

  # Percentage of fish passage under the sluice
  # Handle division by zero if there's no flow under the sluice
  if (sum(flow_under) > 0) {
    pct_passeerbaar_under <- sum(data$passeerbaar_stroomopwaarts_onder_stuw == "yes" & flow_under) / sum(flow_under) * 100
    pct_passeerbaar_free_flow_under <- sum(data$passeerbaar_stroomopwaarts_onder_stuw == "yes" & free_flow_under) / sum(free_flow_under) * 100
  } else {
    pct_passeerbaar_under <- NA_real_
    pct_passeerbaar_free_flow_under <- NA_real_
  }

  # --- 4. Return Results as a Data Frame ---
  analysis_results <- tibble(
    Analysis = c(
      "Water gaat over de stuw",
      "Water gaat onder de stuw",
      "Er gaat geen water voorbij de stuw",
      "Water gaat zowel boven als onder de stuw",
      "Vissen kunnen de stuw bereiken wanneer er water over gaat.",
      "Vissen kunnen de stuw passeren wanneer er water over gaat.",
      "Vissen kunnen de stuw passeren wanneer er water onder gaat.",
      "Vissen kunnen de stuw passeren wanneer er 'vrije stroming' is over de stuw.",
      "Vissen kunnen de stuw passeren wanneer er vrije stroming is onder de stuw."
    ),
    Percentage = round(c(
      pct_flow_over,
      pct_flow_under,
      pct_no_flow,
      pct_both_flow,
      pct_bereikbaar_over,
      pct_passeerbaar_over,
      pct_passeerbaar_under,
      pct_passeerbaar_free_flow_over,
      pct_passeerbaar_free_flow_under
    )
    ,digits=1))

  return(analysis_results)
}
