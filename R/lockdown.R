#' Lock down a file or variable
#'
#' @param fp The file path.
#' @param x The variable.
#' @return Invisibly, returns \code{NA} if the file was not found in the cache,
#'   and \code{TRUE} if the file matches its value in the cache.  Will produce
#'   a VERY LOUD ERROR MESSAGE if the file was found in the cache and it does
#'   not match.
#' @name lockdown
NULL

#' Remove a file or variable from the lockdown cache
#'
#' @param fp The file path.
#' @param x The variable.
#' @return Invisibly, returns \code{NA} if the file was not found in the cache,
#'   and \code{TRUE} if the file was found and removed.
#' @name lockdownremove
NULL

#' @rdname lockdown
#' @export
lockdown_file <- function (fp, cache_fp=".lockdown_files.rds") {
  new_md5 <- tools::md5sum(fp)
  result <- .lockdown_check(cache_fp, fp, new_md5)
  result
}

#' @rdname lockdown
#' @export
lockdown_variable <- function (x, cache_fp=".lockdown_vars.rds") {
  xname <- deparse(substitute(x))
  new_md5 <- digest::digest(x)
  result <- .lockdown_check(cache_fp, xname, new_md5)
  result
}

#' @rdname lockdownremove
#' @export
lockdown_remove_file <- function (fp, cache_fp=".lockdown_files.rds") {
  result <- .lockdown_remove(cache_fp, fp)
  result
}

#' @rdname lockdownremove
#' @export
lockdown_remove_variable <- function (x, cache_fp=".lockdown_vars.rds") {
  xname <- deparse(substitute(x))
  result <- .lockdown_remove(cache_fp, xname)
  result
}

.lockdown_remove <- function (cache_fp, name) {
  cache <- .load_cache(cache_fp)
  if (name %in% names(cache)) {
    cache[[name]] <- NULL
    saveRDS(cache, cache_fp)
    TRUE
  } else {
    NA
  }
}

.lockdown_check <- function (cache_fp, key, val) {
  cache <- .load_cache(cache_fp)
  if (key %in% names(cache)) {
    cached_val <- cache[[key]]
    if (cached_val != val) {
      msg <- paste(
        "SOMETHING CHANGED!",
        "Previous value", cached_val,
        "does not match current value", val)
      stop(msg)
    }
    TRUE
  } else {
    cache[[key]] <- val
    saveRDS(cache, cache_fp)
    NA
  }
}

.load_cache <- function (cache_fp) {
  if (file.exists(cache_fp)) {
    readRDS(cache_fp)
  } else {
    list()
  }
}
