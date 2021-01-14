#' Get us the DB tables
#'
#' @param con database connection
#'
#' @return
#' @export
#' @rdname tbl_db
#'
#' @examples
#'
#' tbl_daily_users()
#' tbl_revenue()
#' tbl_users()
#'
tbl_daily_users <- function(con = NULL) {

  dplyr::tbl(con, "daily_users")
}

#' @rdname tbl_db
tbl_revenue <- function(con = NULL) {

  dplyr::tbl(con, "revenue")
}

#' @rdname tbl_db
tbl_users <- function(con = NULL) {

  dplyr::tbl(con, "users")
}
