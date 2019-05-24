# download tarballs of all installed packages
# TODO: whatif current active repos do not provide all tarballs?

#' retrieve source tarballs of installed packages
#'
#' @param pkgs  matrix of package names and versions
#' @param srcDB directory where all source tarballs are collected
#'
#' @return vector of 
#' @export
#'
#' @examples
#'   tarbs <- gettars()
gettars <- function(pkgs = NULL, srcDB = tempfile('pkgs_')) {
  # find sources for all installed packages
  if (is.null(pkgs)) {
    pkgs <- utils::installed.packages()
    pkgs <- pkgs[is.na(pkgs[,'Priority']) | pkgs[,'Priority'] != 'base'
                 , c('Package','Version')]
  }
  # if (is.null(srcDB)) srcDB <-

  # TODO: announce packages where no sources were found
  pkgsrc <- merge(pkgs, utils::available.packages()[, c('Package', 'Repository')])

  # retrieve tarball from repo, in second attempt from repo/Archive
  getsrc <- function(pkg, version, repo, destdir) {
    fi <- paste0(repo, '/', pkg, "_", version, '.tar.gz')
    if (!(attr(curlGetHeaders(fi), 'status', exact = TRUE) %in% c(200, 0))) {
      fi <- paste0(repo, '/Archive/', pkg, '/', pkg, "_", version, '.tar.gz')
    }
    # TODO: check for potential failures here
    curl::curl_download(fi, file.path(destdir, basename(fi)))
    fi
  }

  # create download directory and do it
  dir.create(srcDB, showWarnings = FALSE)
  tarbs <- apply(pkgsrc, 1, function(X) getsrc(X[1], X[2], X[3], destdir=srcDB))
  tarbs
}
