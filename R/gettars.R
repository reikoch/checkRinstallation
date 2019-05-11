# download tarballs of all installed packages
# TODO: whatif current option repos does not provide all?

library(remotes)

i <- installed.packages()
inst <- i[is.na(i[,'Priority']) | i[,'Priority'] != 'base', c('Package','Version')]
rm(i)
avail <- available_packages()[, c('Package', 'Repository')]
pkgsrc <- merge(inst, avail)

# retrieve tarball from repo, in second attempt from repo/Archive
getsrc <- function(pkg, version, repo, destdir) {
  fi <- paste0(repo, '/', pkg, "_", version, '.tar.gz')
  if (!(attr(curlGetHeaders(fi), 'status', exact = TRUE) %in% c(200, 0))) {
    fi <- paste0(repo, '/Archive/', pkg, '/', pkg, "_", version, '.tar.gz')
  }
  curl::curl_download(fi, file.path(destdir, basename(fi)))
}

# create donwload directory and do it
dir.create(dwnld <- tempfile('pkgs_'))
tarbs <- apply(pkgsrc, 1, function(X) getsrc(X[1], X[2], X[3], destdir=dwnld))
