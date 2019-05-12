# extract tests from tarballs

# create directory for tests
testdir <- tempfile('tests_')
unlink(testdir, recursive = TRUE, force = TRUE)
dir.create(testdir)

# get package names
pkgs <- vapply(strsplit(basename(tarbs), "_"), function(X) X[[1]], 'character')

# extract tests
for (tarb in tarbs) {
  untar(tarb, files = file.path(unlist(strsplit(basename(tarb), '_'))[1], 'tests'), exdir = testdir)
}
