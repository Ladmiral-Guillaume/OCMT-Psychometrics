required_packages <- c(
  "tidyverse",
  "ragg",
  "quarto",
  "rmarkdown",
  "languageserver",
  "ggthemes",
  "ggformula",
  "openintro",
  "easystats",
  "modelsummary",
  "tinyplot"
)

installed_packages <- rownames(installed.packages())
missing_packages <- setdiff(required_packages, installed_packages)

if (length(missing_packages) == 0) {
  message("All required packages are already installed.")
  quit(save = "no", status = 0)
}

message("Installing required packages: ", paste(missing_packages, collapse = ", "))

install.packages(
  missing_packages,
  repos = "https://cloud.r-project.org"
)

message("Package installation finished.")
