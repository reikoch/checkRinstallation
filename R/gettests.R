#' extract tests from tarballs
#'
#' @param tarbs  list of package source tarballs
#'     from which tests have to be extracted
#' @param testDB directory under which package tests will be stored
#'
#' @return named vector of package test locations
#'
#' @examples
gettests <- function(tarbs, testDB = NULL) {
  # create directory for tests if needed
  if (is.null(testDB)) {
    testDB <- tempfile('tests_')
    unlink(testDB, recursive = TRUE, force = TRUE)
    dir.create(testDB)
  }

  # get package names
  pkgs <- vapply(strsplit(basename(tarbs), "_"), function(X) X[[1]], 'character')

  # extract tests
  tests <- vector('character')
  for (tarb in tarbs) {
    newdir <- file.path(testDB, basename(sub('.tar.gz$', '', tarb)))
    pkg <- strsplit(basename(tarb), '_')[[1]][1]
    utils::untar(tarb, files = file.path(unlist(strsplit(basename(tarb), '_'))[1], 'tests')
          , exdir = newdir)
    tests[pkg] <- file.path(newdir, pkg)
  }
  tests
}
