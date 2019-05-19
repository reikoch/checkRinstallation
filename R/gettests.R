# extract tests from tarballs

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
    untar(tarb, files = file.path(unlist(strsplit(basename(tarb), '_'))[1], 'tests')
          , exdir = newdir)
    tests[pkg] <- file.path(newdir, pkg)
  }
  tests
}
