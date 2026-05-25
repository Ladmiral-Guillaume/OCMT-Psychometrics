fail <- function(...) {
  stop(sprintf(...), call. = FALSE)
}

require_line <- function(lines, pattern, file) {
  if (!any(grepl(pattern, lines, perl = TRUE))) {
    fail("%s is missing expected content matching: %s", file, pattern)
  }
}

run_command <- function(command, args, step) {
  stdout_file <- tempfile()
  stderr_file <- tempfile()
  on.exit(unlink(c(stdout_file, stderr_file), force = TRUE), add = TRUE)

  status <- system2(command, args, stdout = stdout_file, stderr = stderr_file)
  output <- c(
    readLines(stdout_file, warn = FALSE),
    readLines(stderr_file, warn = FALSE)
  )

  if (length(output) > 0) {
    message(paste(output, collapse = "\n"))
  }

  if (!identical(status, 0L)) {
    fail("%s failed with exit status %s.", step, status)
  }
}

required_files <- c(
  ".devcontainer/devcontainer.json",
  ".gitignore",
  "README.md",
  "data/example_data.csv",
  "scripts/check_setup.R",
  "scripts/install_required_packages.R",
  "scripts/post_create_setup.sh",
  "scripts/validate_template.R",
  "second_demo.qmd",
  "starter_analysis.qmd",
  "second_demo_ja.qmd",
  "starter_analysis_ja.qmd",
  "quarto_markdown_html_typst_presentation_JPN.qmd"
)

missing_files <- required_files[!file.exists(required_files)]
if (length(missing_files) > 0) {
  fail("Missing required repository files: %s", paste(missing_files, collapse = ", "))
}

quarto_path <- Sys.which("quarto")
if (!nzchar(quarto_path)) {
  fail("Quarto CLI is not available in this environment.")
}

rscript_path <- file.path(
  R.home("bin"),
  if (.Platform$OS.type == "windows") "Rscript.exe" else "Rscript"
)

if (!file.exists(rscript_path)) {
  fail("Rscript is not available in this environment.")
}

devcontainer_config <- readLines(".devcontainer/devcontainer.json", warn = FALSE)
require_line(devcontainer_config, '"quarto\\.quarto"', ".devcontainer/devcontainer.json")
require_line(devcontainer_config, '"REditorSupport\\.r"', ".devcontainer/devcontainer.json")

gitignore_lines <- readLines(".gitignore", warn = FALSE)
required_gitignore_entries <- c(
  "*.knit.md",
  "*.html",
  "*.pdf",
  "*.docx"
)

missing_gitignore_entries <- required_gitignore_entries[
  !required_gitignore_entries %in% gitignore_lines
]

if (length(missing_gitignore_entries) > 0) {
  fail(
    ".gitignore is missing required entries: %s",
    paste(missing_gitignore_entries, collapse = ", ")
  )
}

message("Running setup validation...")
run_command(rscript_path, c("scripts/check_setup.R"), "scripts/check_setup.R")

starter_analysis_lines <- readLines("starter_analysis.qmd", warn = FALSE)
require_line(starter_analysis_lines, "^format:$", "starter_analysis.qmd")
require_line(starter_analysis_lines, "^  html:$", "starter_analysis.qmd")
require_line(starter_analysis_lines, "^    embed-resources: true$", "starter_analysis.qmd")

second_demo_lines <- readLines("second_demo.qmd", warn = FALSE)
require_line(second_demo_lines, "^format:$", "second_demo.qmd")
require_line(second_demo_lines, "^  html:$", "second_demo.qmd")
require_line(second_demo_lines, "^    embed-resources: true$", "second_demo.qmd")

starter_analysis_ja_lines <- readLines("starter_analysis_ja.qmd", warn = FALSE)
require_line(starter_analysis_ja_lines, "^format:$", "starter_analysis_ja.qmd")
require_line(starter_analysis_ja_lines, "^  html:$", "starter_analysis_ja.qmd")
require_line(starter_analysis_ja_lines, "^    embed-resources: true$", "starter_analysis_ja.qmd")

second_demo_ja_lines <- readLines("second_demo_ja.qmd", warn = FALSE)
require_line(second_demo_ja_lines, "^format:$", "second_demo_ja.qmd")
require_line(second_demo_ja_lines, "^  html:$", "second_demo_ja.qmd")
require_line(second_demo_ja_lines, "^    embed-resources: true$", "second_demo_ja.qmd")

message("Rendering starter analysis...")
run_command(quarto_path, c("render", "starter_analysis.qmd"), "quarto render starter_analysis.qmd")

message("Rendering second demo...")
run_command(quarto_path, c("render", "second_demo.qmd"), "quarto render second_demo.qmd")

message("Rendering Japanese starter analysis...")
run_command(quarto_path, c("render", "starter_analysis_ja.qmd"), "quarto render starter_analysis_ja.qmd")

message("Rendering Japanese second demo...")
run_command(quarto_path, c("render", "second_demo_ja.qmd"), "quarto render second_demo_ja.qmd")

message("Rendering Japanese Typst presentation...")
run_command(
  quarto_path,
  c("render", "quarto_markdown_html_typst_presentation_JPN.qmd"),
  "quarto render quarto_markdown_html_typst_presentation_JPN.qmd"
)

expected_outputs <- c(
  "starter_analysis.html",
  "second_demo.html",
  "starter_analysis_ja.html",
  "second_demo_ja.html",
  "quarto_markdown_html_typst_presentation_JPN.pdf"
)

missing_outputs <- expected_outputs[!file.exists(expected_outputs)]
if (length(missing_outputs) > 0) {
  fail("Expected rendered files are missing: %s", paste(missing_outputs, collapse = ", "))
}

cleanup_targets <- c(
  "starter_analysis.html",
  "second_demo.html",
  "starter_analysis_ja.html",
  "second_demo_ja.html",
  "quarto_markdown_html_typst_presentation_JPN.pdf",
  "quarto_markdown_html_typst_presentation_JPN.typ",
  "starter_analysis.knit.md",
  "second_demo.knit.md",
  "starter_analysis_ja.knit.md",
  "second_demo_ja.knit.md",
  "starter_analysis_files",
  "second_demo_files",
  "starter_analysis_ja_files",
  "second_demo_ja_files",
  ".quarto"
)

file_targets <- cleanup_targets[file.exists(cleanup_targets)]
dir_targets <- cleanup_targets[dir.exists(cleanup_targets)]

remaining_targets <- cleanup_targets

for (attempt in seq_len(3)) {
  file_targets <- cleanup_targets[file.exists(cleanup_targets)]
  dir_targets <- cleanup_targets[dir.exists(cleanup_targets)]

  if (length(file_targets) > 0) {
    unlink(file_targets, force = TRUE)
  }

  if (length(dir_targets) > 0) {
    unlink(dir_targets, recursive = TRUE, force = TRUE)
  }

  remaining_targets <- cleanup_targets[
    file.exists(cleanup_targets) | dir.exists(cleanup_targets)
  ]

  if (length(remaining_targets) == 0) {
    break
  }

  Sys.sleep(0.5)
}

if (length(remaining_targets) > 0) {
  fail(
    "Cleanup left generated artifacts behind: %s",
    paste(remaining_targets, collapse = ", ")
  )
}

message("Template validation passed.")
