# download tarballs of all installed packages
# TODO: whatif current active repos do not provide all tarballs?

library(remotes)

gettars <- function(pkgs = NULL, srcDB = tempfile('pkgs_')) {
  # find sources for all installed packages
  if (is.null(pkgs)) {
    pkgs <- installed.packages()[is.na(i[,'Priority']) | i[,'Priority'] != 'base'
                                 , c('Package','Version')]
  }
  # if (is.null(srcDB)) srcDB <-

  # TODO: announce packages where no sources were found
  pkgsrc <- merge(pkgs, available_packages()[, c('Package', 'Repository')])

  # retrieve tarball from repo, in second attempt from repo/Archive
  getsrc <- function(pkg, version, repo, destdir) {
    fi <- paste0(repo, '/', pkg, "_", version, '.tar.gz')
    if (!(attr(curlGetHeaders(fi), 'status', exact = TRUE) %in% c(200, 0))) {
      fi <- paste0(repo, '/Archive/', pkg, '/', pkg, "_", version, '.tar.gz')
    }
    # TODO: check for potential failures here
    curl::curl_download(fi, file.path(destdir, basename(fi)))
  }

  # create download directory and do it
  dir.create(srcDB, showWarnings = FALSE)
  tarbs <- apply(pkgsrc, 1, function(X) getsrc(X[1], X[2], X[3], destdir=srcDB))
  tarbs
}
