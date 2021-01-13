get_resident_data <- function(data_table = FALSE) {
  residents_per_sector <- db_con("residents_per_sector")
  if (data_table) {
    data.table::as.data.table(residents_per_sector)
  } else {
    tibble::as_tibble(residents_per_sector)
  }
}
