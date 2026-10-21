# Agent Guide: RAP 4 MADS 2026

This file provides critical context, constraints, and instructions for AI agents (and human contributors) working on the **Reproducible Analytical Pipelines for the Master of Data Science (2026)** course repository.

---

## 1. Environment Contract (Nix-First)

- **Hermetic Environment**: All builds, tests, and rendering MUST take place inside the Nix environment (`nix develop` or `nix-shell`).
- **No Imperative Installs**: NEVER run `pip install`, `install.packages()`, or `apt-get`. All dependencies (R packages, Python libraries, Julia binaries, Quarto, TeX Live) are defined in `flake.nix` and locked in `flake.lock`.
- **Cachix Substitution**: The repository uses `https://rstats-on-nix.cachix.org` for pre-built binaries. Ensure substituters are preserved.

---

## 2. Project Architecture & Standards

- **Quarto Book**: The course website and lecture notes are written as a Quarto book (`_quarto.yml`).
- **Multi-Format Output**: The book builds into HTML, EPUB, and PDF (`lualatex`). Any edits to `.qmd` files must render cleanly across all three formats.
- **Polyglot Execution**: The course teaches **T** (`tlang`), **R**, and **Python**. Keep code snippets idiomatic and reproducible.
- **Pure Functions**: Code examples inside pipeline nodes must be pure functions with explicit inputs and outputs. Avoid global state.

---

## 3. Language Semantic Guardrails (Mandatory)

When generating or editing Python, R, or T code in this repository, you MUST adhere to these rules:

### Python Standards
- **Immutability**: NEVER use `inplace=True` or mutate argument objects in-place. Always return a modified copy or new object.
- **Scoping**: All functions must be pure. Never reference variables from global or outer scope inside functions; pass all dependencies explicitly.
- **Falsy Checks**: Do NOT use `if df:` or `if series:` (which raise ambiguous truth value errors in pandas). Use `.empty` or explicit length comparisons.
- **Float Comparisons**: Never assert direct float equality (`==`). Always use tolerance-based comparisons (`np.isclose`, `pytest.approx`).
- **Error Handling**: Do NOT use blanket `except Exception:` blocks that return `None`. Errors must fail loudly and informatively.

### R Standards
- **Vector Operations**: Avoid silent vector recycling bugs. Guard operations with explicit length checks or use `{dplyr}` / `{purrr}`.
- **Missingness**: Explicitly differentiate between `NA`, `NULL`, and empty vectors (`character(0)`).
- **Package Discipline**: Declare dependencies explicitly in package descriptions or use `@importFrom` roxygen2 tags.

---

## 4. Verification & Build Commands

Always verify changes before concluding tasks:

| Action | Command |
| :--- | :--- |
| **Enter Development Shell** | `nix develop` |
| **Render the Entire Book** | `nix develop --command quarto render` |
| **Run T Pipeline Tests** | `nix develop --command t test --json` |
| **Verify Nix Shell Derivation** | `nix-build` |
| **Publish to GitHub Pages** | `nix develop --command quarto publish gh-pages --no-prompt --no-browser` |

---

## 5. Testing & Oracles Integrity

- **Ground Truth**: Do NOT modify test assertions or golden datasets to accommodate buggy code. The test oracle is the specification.
- **Git Review**: Review all proposed changes hunk-by-hunk using `git diff` or `git add -p` before committing.
