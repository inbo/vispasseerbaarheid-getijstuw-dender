find_parameter_combinations_to_optimize_vo <- function(Q_total, V_o_target, h_up, h_down, b, C_e = 1.7, C_d = 0.6, g = 9.81, h_o_min = 0.01, h_o_max = h_up, step = 0.01) {

  if (h_up < h_down) {
    stop("This function is configured for 'downstream' flow (h_up > h_down).")
  }

  if (V_o_target >= 1) {
    stop("Target overflow velocity must be less than 1.")
  }

  # Initialize a data frame to store valid combinations
  solutions_df <- data.frame(h_o = numeric(), h_si = numeric(), Q_o = numeric(), Q_u = numeric(), h_u = numeric(), V_o = numeric(), V_u = numeric())

  # Create a sequence of h_o values to test
  h_o_values <- seq(from = h_o_min, to = h_o_max, by = step)

  # Iterate through each possible h_o
  for (h_o in h_o_values) {

    # 1. Calculate the required Q_o to meet the velocity target
    Q_o_req <- V_o_target * b * h_o

    # 2. Calculate the corresponding Q_u needed to meet the total discharge
    Q_u_req <- Q_total - Q_o_req

    # 3. Solve for the required h_u
    # The sluice flow equation is Q_u = C_d * b * h_u * sqrt(2 * g * (h_up - h_down))
    # Rearranging for h_u:
    if (Q_u_req >= 0 && (h_up - h_down) > 0) {
      h_u_req <- Q_u_req / (C_d * b * sqrt(2 * g * (h_up - h_down)))
    } else {
      # This h_o value is not physically plausible, skip it
      next
    }

    # 4. Check if the resulting h_u is physically possible
    if (h_u_req >= 0 && h_u_req <= h_up) {

      # 5. Calculate the corresponding h_si
      h_si_req <- h_up - h_o
      V_u_req = Q_u_req/(h_u_req*b)

      # Store this valid combination
      solutions_df <- rbind(solutions_df, data.frame(
        h_o = h_o,
        h_si = h_si_req,
        Q_o = Q_o_req,
        Q_u = Q_u_req,
        h_u = h_u_req,
        V_o = V_o_target,
        V_u = V_u_req
      ))
    }
  }

  return(solutions_df)
}
