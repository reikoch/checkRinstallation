# download tarballs of all installed packages
# TODO: whatif current option repos does not provide all?

library(remotes)

i <- installed.packages()
inst <- i[is.na(i[,'Priority']) | i[,'Priority'] != 'base', c('Package','Version')]
rm(i)
tarbs <- apply(inst, 1, function(X) try(remotes::download_version(X[1], version = X[2], type='source')))
