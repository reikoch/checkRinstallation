#' execute tests
#'
#' @param testdir directory under which all tests are stored
#'
#' @return named list of testresults
#' @export
#'
#' @examples
execute_tests <- function(testdir) {

  testresults <- list()
  for (pkg in list.dirs(testdir, full.names=FALSE, recursive = FALSE)){

    testresults[[pkg]] <- vector('integer')
    workdir <- file.path(testdir, pkg, strsplit(pkg, '_', fixed = TRUE)[[1]][1], 'tests')
    if (dir.exists(workdir)) {
      owd <- setwd(workdir)
      message(gettextf("Running specific tests for package %s",
                       sQuote(pkg)), domain = NA)
      Rfiles <- dir(".", pattern = "\\.[rR]$")
      for (f in Rfiles) {
        message(gettextf("  Running %s", sQuote(f)), domain = NA)
        outfile <- sub("rout$", "Rout", paste0(f, "out"))
  
        res <- callr::rcmd(cmd = 'BATCH',
                           cmdargs = c('--vanilla', '--no-timing', f, outfile),
                           env = c(callr::rcmd_safe_env(), LANGUAGE='C')
                           )
        testresults[[pkg]][f] <- res$status
        write(res$status, 'result')
  
        if (res$status) {
          file.rename(outfile, paste0(outfile, ".fail"))
          # return(invisible(1L))
        }
        savefile <- paste0(outfile, ".save")
        if (all(file.exists(outfile, savefile))) {
          message(gettextf("  comparing %s to %s ...",
                           sQuote(outfile), sQuote(savefile)), appendLF = FALSE,
                  domain = NA)
          res <- tools::Rdiff(outfile, savefile)
          if (!res)
            message(" OK")
        }
      }
      setwd(owd)
    }
  }
  testresults
}
