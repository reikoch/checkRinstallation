# download tarballs of all installed packages
# TODO: whatif current option repos does not provide all?

library(remotes)

inst <- installed.packages()[, c('Package','Version')]
tarbs <- apply(inst, 1, remotes::download_version, type='source')
