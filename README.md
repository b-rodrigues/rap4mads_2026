# Reproducible Analytical Pipelines - Master of Data Science (2026)

This is the 2026 edition of the course taught in the Master of Data Science at the University of Luxembourg.

If you are looking for previous editions:
- 2025 edition: https://github.com/b-rodrigues/rap4mads_2025
- 2024 edition: https://github.com/b-rodrigues/rap4mads_2024

This course is based on my book [Reproducible Polyglot Data Science](https://github.com/b-rodrigues/reproducible-data-science).

In this edition, the course puts **T** (`tlang`) at the center: an experimental domain-specific language purpose-built for polyglot reproducible analytical pipelines (R, Python, Julia), backed by Nix for hermetic, bit-for-bit reproducible environments.

## Online Website

You can read the online course website [here](https://b-rodrigues.github.io/rap4mads_2026/).

## Rendering Locally

You can render the book locally using Nix:

1. Fork and clone this repository.
2. Enter the development shell:
   ```bash
   nix develop
   ```
   (or `nix-shell`)
3. Render the Quarto book:
   ```bash
   quarto render
   ```

## License

The code in this repo is licensed under the WTFPL.

<a href="http://www.wtfpl.net/"><img
       src="http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-4.png"
       width="80" height="15" alt="WTFPL" /></a>
