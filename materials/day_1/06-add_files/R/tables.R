#' Create gt table for donations by sector
#'
#' @inheritParams count_donations
#'
#' @return a `gt` table
#' @export
#' @rdname gt
gt_donations <- function(donations = get_donation_data()) {
  gt::gt(donations)
}

#' @rdname gt
#' @export
gt_data_dictionary <- function(){
  data("data_dictionary")
  gt_donations(data_dictionary)
}
