find_optimal_ranges <- function(Q_total, V_o_threshold, h_up, h_down, b, C_e = 1.7, C_d = 0.6, g = 9.81) {

  na_list <- list(
    ho_range_min = NA_real_,
    ho_range_max = NA_real_,
    hu_range_min = NA_real_,
    hu_range_max = NA_real_
  )

  h_o_min_req <- 0.3

  if (h_up < h_down) {
    flow = "up"
  } else {
    flow = "down"
  }

  if (flow == "down" && h_up < h_o_min_req) return(na_list)
  if (flow == "up" && h_down < h_o_min_req) return(na_list)
  if (abs(h_up - h_down) < 1e-9) return(na_list)

  # Define the core V_o calculation function
  get_vo <- function(h_o, h_u) {
    if (h_o <= 0 || h_u < 0) return(NA_real_)

    if (flow == "down") {
      Q_u <- ifelse(h_u > 0, C_d * b * h_u * sqrt(2 * g * (h_up - h_down)), 0)
    } else {
      Q_u <- ifelse(h_u > 0, C_d * b * h_u * sqrt(2 * g * (h_down - h_up)), 0)
      Q_u <- Q_u * -1
    }

    Q_o_calc <- Q_total - Q_u
    if (Q_o_calc <= 0) return(NA_real_)

    V_o_calc <- Q_o_calc / (b * h_o)
    return(V_o_calc)
  }

  # --- Find the range of h_u that allows for a solution ---
  hu_search_range <- c(0, max(h_up, h_down))

  # Function to find the h_u that makes V_o = V_o_threshold at a specific h_o
  find_hu_boundary <- function(h_u_val, h_o_val, target_vo) {
    return(get_vo(h_o_val, h_u_val) - target_vo)
  }

  # The h_o value that gives the lowest V_o is usually the highest h_o
  # We find the min and max h_u by checking the boundaries of the h_o search interval
  hu_min_boundary <- try(uniroot(find_hu_boundary, interval = hu_search_range, h_o_val = h_up, target_vo = V_o_threshold), silent = TRUE)
  hu_max_boundary <- try(uniroot(find_hu_boundary, interval = hu_search_range, h_o_val = h_o_min_req, target_vo = V_o_threshold), silent = TRUE)

  if (inherits(hu_min_boundary, "try-error") || inherits(hu_max_boundary, "try-error")) {
    return(na_list)
  }

  hu_range_min <- hu_min_boundary$root
  hu_range_max <- hu_max_boundary$root

  if (hu_range_min > hu_range_max) {
    hu_range_temp <- hu_range_min
    hu_range_min <- hu_range_max
    hu_range_max <- hu_range_temp
  }

  return(list(
    hu_range_min = hu_range_min,
    hu_range_max = hu_range_max
  ))
}
