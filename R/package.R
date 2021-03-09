#' @title Get list of known and unknown functions and used packages
#' in an R file or path
#' @description Return list of lists of known and unknown function
#' and package names
#' used in an R file or path
#' @param name path or name of R file
#' @param special include special functions like "\%>\%" or similar
#' @param base vector of default R packages, "default" returns
#' installed packages with priority base
#' @param expand boolean variable, tries to find full package::function
#' specification if TRUE
#' @return list of function and package names
#' @export
#' @family package
#' @author david.breuer
#' @examples \donttest{full <- get_package_functions(name)}
get_package_functions <- function(name,
                                  special = TRUE,
                                  base = "default",
                                  expand = FALSE) {
  if (endsWith(name, ".R")) {
    calls <- utils::getParseData(parse(name, keep.source = TRUE))
    calls <- calls[c("token", "text")]
  } else {
    files <- list.files(
      name,
      pattern = ".R$",
      recursive = TRUE,
      full.names = TRUE
    )
    calls <- lapply(files, function(f) {
      utils::getParseData(parse(f, keep.source = TRUE))
    })
    ctoken <- unlist(lapply(calls, function(x) x$token))
    ctext <- unlist(lapply(calls, function(x) x$text))
    calls <- data.frame(token = ctoken, text = ctext, stringsAsFactors = FALSE)
  }

  rows <- grep("SYMBOL_FUNCTION_CALL", calls$token, fixed = TRUE)

  bool1 <- bool2 <- rep(FALSE, length(rows))
  # check if previous row contains "NS_GET" = ::
  bool1[rows > 1] <- (calls$token[rows[rows > 1] - 1] == "NS_GET")
  # check if previous row contains "SYMBOL_PACKAGE" = package name
  bool2[rows > 2] <- (calls$token[rows[rows > 2] - 2] == "SYMBOL_PACKAGE")
  # rows[which(bool1 & bool2)]
  # sum(bool1 & bool2)
  fncs <- vapply(seq(rows), function(i) {
    r <- rows[i]
    # if explicit package::function
    if (bool1[i] && bool2[i]) {
      # get and append full function name
      fnc <- paste0(calls$text[(r - 2):r], collapse = "")
    } else {
      # try to find function in known/imported packages
      fnc <- calls$text[r]
    }
    fnc
  }, "")
  fncs <- sort(unique(fncs))

  # set default packages
  if (base == "default") {
    default <- rownames(utils::installed.packages(priority = "base"))
  }

  bool1 <- grepl("::", fncs, fixed = TRUE)
  full <- vapply(seq(fncs), function(i) {
    fnc <- fncs[i]
    if (!bool1[i]) {
      pkg <- utils::find(fnc)
      if (length(pkg) > 0) {
        # TODO solve multiple occurences: find("system.file") [1]
        # "devtools_shims" "package:base"
        pkg <- strsplit(pkg, ":", fixed = TRUE)[[1]][2]
        # expand function if in base or expand == TRUE
        if (is.element(pkg, default) || expand) {
          # get and append full function name
          fnc <- paste(pkg, fnc, sep = "::")
        }
      }
    }
    fnc
  }, "")
  full <- sort(unique(full))

  output <- list()
  wh <- grep("::", full, fixed = TRUE)
  output$known <- full[wh]
  output$unknown <- full[-wh]
  package_splits <- strsplit(output$known, "::", fixed = TRUE)
  output$packages <- sort(unique(vapply(package_splits, function(s) s[1], "")))

  # subtract default packages
  output$packages <- setdiff(output$packages, default)

  # add special functions
  if (special) {
    spec <- grep("SPECIAL", calls$token, fixed = TRUE)
    output$unknown <- sort(unique(append(output$unknown, calls$text[spec])))
  }

  output
}

#' @title Get list of packages in DESCRIPTION file
#' @description Return list of lists packages in DESCRIPTION file,
#' grouped by \"Depends\", \"Imports\", \"Suggests\", \"Remotes\"
#' @param name package name
#' @return list of package names
#' @export
#' @family package
#' @author david.breuer
#' @examples pkgs <- get_package_description("hlpr")
get_package_description <- function(name) {
  # read DESCRIPTION
  desc <- utils::packageDescription(name)
  pkgs <- list()
  for (i in c("Depends", "Imports", "Suggests", "Remotes")) {
    # get line
    lin <- desc[[i]]
    if (is.null(lin)) next
    # split list of packages
    st <- strsplit(lin, ",")[[1]]
    # remove explicit package versions
    st <- gsub("\\s*\\([^\\)]+\\)", "", st)
    # remove git repo
    st <- gsub(".*/", "", st)
    # trim and sort package names
    pkgs[[i]] <- sort(trimws(st))
  }
  # add current package name
  pkgs$Depends <- append(pkgs$Depends, desc$Package)
  pkgs
}

#' @title Check if packages are installed and throw error if missing
#' @description Check if packages are installed and throw error if missing
#' @param packages vector of package names
#' @param versions vector of minimum required package version, optional
#' @param quietly logical: should progress and error messages be suppressed?
#' @param call. logical, indicating if the call should become
#' part of the error message
#' @param error logical, return TRUE/NULL by default, TRUE/FALSE otherwise
#' @return Throw error if packages missing
#' @export
#' @family package
#' @author david.breuer
#' @examples \donttest{
#' require_namespaces(c("base", "baseXY"), versions = c("3.0.0", NA))
#' }
require_namespaces <- function(packages, versions = NA, quietly = TRUE,
                               call. = FALSE, error = TRUE) {
  errors <- 0
  missing <- NULL
  lenp <- length(packages)
  lenv <- length(versions)
  if (!any(is.na(versions)) && lenv != lenp) {
    msg <- "Please provide one version number or NA per package."
    stop(msg)
  }
  for (i in seq(packages)) {
    package <- packages[i]
    version <- versions[i]
    misp <- !requireNamespace(package, quietly = quietly)
    if (misp == FALSE) {
      if (is.na(version)) {
        package_version <- package
        misv <- FALSE
      } else {
        current <- utils::packageVersion(package)
        package_version <- paste0(package, " (", current, " < ", version, ")")
        misv <- (current < version)
      }
    } else {
      package_version <- package
    }
    if (misp || misv) {
      errors <- errors + 1
      missing <- c(missing, package_version)
    }
  }
  res <- TRUE
  if (errors > 0) {
    missing <- paste(missing, collapse = ", ")
    msg <- "Please install the following package(s) for this function to work:"
    output <- paste(msg, missing)
    if (error) {
      stop(output, call. = call.)
    }
    warning(output)
    res <- FALSE
  }
  invisible(res)
}
