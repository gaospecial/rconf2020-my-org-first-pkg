theme_avalanche <- function() {
  ggplot2::theme_minimal(base_size = 14) +
    ggplot2::theme(panel.grid.minor = element_blank())
}

theme_avalanche_h <- function(){
  ggplot2::theme_minimal(base_size = 14) +
    ggplot2::theme(panel.grid.minor = element_blank(), panel.grid.major.y = element_blank())
}
