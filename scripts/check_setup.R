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

quarto_path <- Sys.which("quarto")
opencode_path <- Sys.which("opencode")

if (!nzchar(quarto_path)) {
  stop("Quarto CLI is not available in this environment.")
}

required_files <- c(
  ".devcontainer/devcontainer.json",
  ".gitignore",
  "README.md",
  "starter_analysis.qmd",
  "second_demo.qmd",
  "starter_analysis_ja.qmd",
  "second_demo_ja.qmd",
  "quarto_markdown_html_typst_presentation_JPN.qmd",
  "data/example_data.csv",
  "scripts/install_required_packages.R",
  "scripts/check_setup.R",
  "scripts/post_create_setup.sh"
)

missing_files <- required_files[!file.exists(required_files)]

if (length(missing_files) > 0) {
  stop(
    "Missing required files: ",
    paste(missing_files, collapse = ", ")
  )
}

missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages) > 0) {
  stop(
    "Missing required packages: ",
    paste(missing_packages, collapse = ", ")
  )
}

message("Quarto path: ", quarto_path)
if (!nzchar(opencode_path)) {
  stop("OpenCode CLI is not available in this environment.")
}
message("OpenCode path: ", opencode_path)
message("All required packages are available.")
message("Setup check passed.")
