#!/usr/bin/env Rscript
# Strip the `Remotes:` block from DESCRIPTION before building a CRAN tarball.
#
# Remotes is used during CI/development so dependent packages can pull
# unreleased versions of sibling packages from GitHub. CRAN rejects any
# package whose DESCRIPTION contains a Remotes field, so it must be removed
# from the tarball that is submitted.
#
# Usage (from the package root):
#   Rscript tools/strip-remotes.R           # rewrites DESCRIPTION in place
#   Rscript tools/strip-remotes.R --build   # also runs R CMD build on the cleaned source
#
# The --build flag produces <pkg>_<version>.tar.gz in the parent directory
# (R CMD build's default), then restores DESCRIPTION so the working tree
# is left as it was.

args <- commandArgs(trailingOnly = TRUE)
do_build <- "--build" %in% args

desc_path <- "DESCRIPTION"
if (!file.exists(desc_path)) {
  stop("DESCRIPTION not found. Run this script from the package root.")
}

original <- readLines(desc_path, warn = FALSE)

# A DESCRIPTION field starts at column 1; continuation lines are indented.
# Drop the line matching `^Remotes:` and any continuation lines that follow.
field_start <- grepl("^[^[:space:]]", original)
remotes_idx <- which(grepl("^Remotes:", original))

if (length(remotes_idx) == 0) {
  message("No Remotes: field found in DESCRIPTION; nothing to strip.")
  cleaned <- original
} else {
  drop <- integer()
  for (i in remotes_idx) {
    drop <- c(drop, i)
    j <- i + 1L
    while (j <= length(original) && !field_start[j]) {
      drop <- c(drop, j)
      j <- j + 1L
    }
  }
  cleaned <- original[-drop]
  message("Stripped Remotes block (", length(drop), " line(s)).")
}

if (do_build) {
  # Snapshot the original so we can restore it after R CMD build.
  backup <- tempfile("DESCRIPTION-")
  file.copy(desc_path, backup, overwrite = TRUE)
  on.exit({
    file.copy(backup, desc_path, overwrite = TRUE)
    unlink(backup)
    message("Restored original DESCRIPTION.")
  }, add = TRUE)

  writeLines(cleaned, desc_path)
  status <- system2("R", c("CMD", "build", "."))
  if (status != 0) {
    stop("R CMD build failed (exit ", status, ").")
  }
} else {
  writeLines(cleaned, desc_path)
  message("DESCRIPTION rewritten in place. Re-run with --build to produce a tarball,",
          " or restore from git when done submitting.")
}
