# Course Template Repository

This repository is a draft template for teaching GitHub, Codespaces, R, and Quarto.

It is designed for a simple student workflow:

1. Create a personal repository from the template.
2. Open the personal repository in GitHub Codespaces.
3. Wait for the default environment to install the required packages.
4. Open `starter_analysis.qmd`.
5. Edit, render, and open `starter_analysis.html`.

## Repository Structure

- `starter_analysis.qmd`: main starter file for the first session
- `second_demo.qmd`: second demonstration file
- `starter_analysis_ja.qmd`: Japanese starter file
- `second_demo_ja.qmd`: Japanese second demonstration file
- `quarto_markdown_html_typst_presentation_JPN.qmd`: Japanese Typst presentation source
- `data/`: small data files
- `scripts/`: setup and validation scripts
- `.devcontainer/devcontainer.json`: Codespaces configuration

## Codespaces Setup

The repository includes a default dev container configuration.
When a codespace is created, GitHub Codespaces should:

1. start an R development container
2. install Quarto
3. install the Quarto and R editor extensions listed in `devcontainer.json`
4. open `README.md` and `starter_analysis.qmd`
5. run `scripts/post_create_setup.sh`

The standard document workflow is:

1. open a `.qmd` file
2. edit and save the file
3. run `quarto render starter_analysis.qmd`, `quarto render second_demo.qmd`, `quarto render starter_analysis_ja.qmd`, or `quarto render second_demo_ja.qmd`
4. open the rendered `.html` file created next to the `.qmd` file

The Japanese HTML demos stay general on purpose:

1. the document text is in Japanese
2. the plot labels stay in plain variable names for portability
3. there is no custom font setup inside the `.qmd` files

The Japanese Typst presentation workflow is:

1. open `quarto_markdown_html_typst_presentation_JPN.qmd`
2. edit and save the file
3. run `quarto render quarto_markdown_html_typst_presentation_JPN.qmd`
4. open the rendered `.pdf` file

The post-create setup script:

1. installs the required R packages
2. installs `opencode`
3. checks that `opencode` is available with `opencode --version`

## Intended R Package Set

The current draft template is designed to install:

- `tidyverse`
- `ragg`
- `quarto`
- `rmarkdown`
- `languageserver`
- `ggthemes`
- `ggformula`
- `openintro`
- `easystats`
- `modelsummary`
- `tinyplot`

## Maintainer Notes

Before this repository is used as a GitHub template:

1. confirm the final list of required R packages
2. run `Rscript scripts/validate_template.R`
3. test `starter_analysis.qmd`, `second_demo.qmd`, `starter_analysis_ja.qmd`, and `second_demo_ja.qmd` in a fresh codespace
4. verify that package installation and `opencode` installation succeed without manual intervention
5. confirm that `quarto render quarto_markdown_html_typst_presentation_JPN.qmd` creates the expected PDF
6. confirm that `quarto render ...` writes output files beside the source files
7. turn the repository into a GitHub template in repository settings
