# Find Stan files
stan_files <- list.files(
  ".",
  pattern = "\\.stan$",
  recursive = TRUE,
  full.names = TRUE
)

print(stan_files)

# Replace old Stan scalar-array declarations
pattern <- paste0(
  "(?m)^([ \\t]*)",
  "(int|real)(<[^>]+>)?",
  "[ \\t]+([A-Za-z_][A-Za-z0-9_]*)",
  "\\[([^]\\r\\n]+)\\];"
)

replacement <- "\\1array[\\5] \\2\\3 \\4;"

for (file in stan_files) {

  code <- paste(readLines(file, warn = FALSE), collapse = "\n")

  updated <- gsub(
    pattern,
    replacement,
    code,
    perl = TRUE
  )

  if (!identical(code, updated)) {
    writeLines(updated, file)
    message("Updated: ", file)
  }
}

#check
for (f in stan_files) {
  cat("Checking:", f, "\n")
  rstan::stanc(file = f)
}

# found some errors in the tests regarding the plotting 
packageVersion("ggplot2")