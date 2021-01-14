
#' Connect database
#'
#' @return DBI object
#' @export
#'
#' @rdname db_con
#'
#' @examples
#'
#' con <- db_con()
#'
db_con <- function() {

  DBI::dbConnect(
    drv = RMariaDB::MariaDB(),
    dbname = Sys.getenv("DBNAME"),
    username = Sys.getenv("USERNAME"),
    password = Sys.getenv("PASSWORD"),
    host = Sys.getenv("HOST"),
    port = Sys.getenv("PORT")
  )
}

#' @rdname db_con
#' @param password the password of database
db_con_p <- function(password = askpass::askpass()) {

  DBI::dbConnect(
    drv = RMariaDB::MariaDB(),
    dbname = Sys.getenv("DBNAME"),
    username = Sys.getenv("USERNAME"),
    password = password,   # This is from the `password` argument
    host = Sys.getenv("HOST"),
    port = Sys.getenv("PORT")
  )
}
