estimate_parameters_with_solver_to_optimize_vo <- function(Q_total, V_o_target, h_up, h_down, h_u, b, C_e = 1.7, C_d = 0.6, g = 9.81) {

  if (h_up < h_down) {
    flow = "up"
  } else {
    flow = "down"
  }

  if (V_o_target >= 1) {
    stop("Target overflow velocity must be less than 1.")
  }

  # Compute underflow discharge first
  if (flow == "down") {
    Q_u <- ifelse(h_u > 0, C_d * b * h_u * sqrt(2 * g * (h_up - h_down)), 0)
  } else { # flow=="up"
    Q_u <- ifelse(h_u > 0, C_d * b * h_u * sqrt(2 * g * (h_down - h_up)), 0)
    Q_u <- Q_u * -1
  }

  # Calculate required overflow discharge (Q_o)
  Q_o_req <- Q_total - Q_u

  # Define a robust objective function
  objective_function <- function(h_o) {
    if (h_o <= 0) return(V_o_target + 1)

    # Calculate Q_o based on h_o
    Q_o_calc <- C_e * (2/3) * b * sqrt(2 * g) * (h_o^(3/2))

    # Apply Villemonte Correction if submerged
    if (flow == "down" && h_down >= h_o) {
      Q_o_calc <- Q_o_calc * (1 - (h_o / h_down)^(3/2))^0.385
    } else if (flow == "up" && h_up >= h_o) {
      Q_o_calc <- Q_o_calc * (1 - (h_o / h_up)^(3/2))^0.385
    }

    # Calculate velocity
    V_o_calc <- Q_o_calc / (b * h_o)

    return(V_o_calc - V_o_target)
  }

  # Define the search interval
  interval <- c(0.001, max(h_up, h_down))

  # Check if the signs at the endpoints are opposite before calling uniroot
  f_start <- objective_function(interval[1])
  f_end <- objective_function(interval[2])

  if (sign(f_start) == sign(f_end)) {
    warning("A solution could not be found within the given interval. The target velocity may not be achievable.")
    return(NULL)
  }

  # Use a solver to find the h_o that makes the objective function zero
  h_o_solution <- try(uniroot(f = objective_function, interval = interval), silent = TRUE)

  if (inherits(h_o_solution, "try-error")) {
    warning("uniroot failed to converge. The target velocity may not be achievable.")
    return(NULL)
  }

  h_o_req <- h_o_solution$root

  # Calculate the siltation height (h_si)
  if (flow == "down") {
    h_si_req <- h_up - h_o_req
  } else { # flow=="up"
    h_si_req <- h_down - h_o_req
  }

  # Re-calculate Q_o and V_o with the solved h_o for the return list
  Q_o_required <- Q_o_req
  V_o_actual <- objective_function(h_o_req) + V_o_target

  return(list(
    Q_o_required = Q_o_required,
    Q_u_required = Q_u,
    h_o_required = h_o_req,
    h_si_required = h_si_req,
    V_o_actual = V_o_actual
  ))
}




