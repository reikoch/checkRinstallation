

- download all source tarballs
- extract PKG/tests,
  if needed via   `untar('R353/Matrix_1.2-17.tar.gz', 'Matrix/tests')`
- R CMD BATCH through all tests
- if corresponding .save file exists
  Rdiff them
- .prev file processing
