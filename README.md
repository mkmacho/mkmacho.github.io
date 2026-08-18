# Miguel Camacho Horvitz — research website

A small, application-focused academic website built with [Quarto](https://quarto.org). The site is a deliberately curated public export: it is not connected to, generated from, or allowed to crawl the private research vault.

## Local workflow

Requirements: Quarto 1.6 or later, a TeX distribution with `latexmk`, and Python 3 for the lightweight link/content checks.

```bash
make all       # rebuild the sanitised CV and website
make preview   # open a local live preview
make check     # rebuild, then run local checks
```

The generated website lives in `_site/` and is intentionally ignored by Git. The generated public CV at `assets/miguel-camacho-horvitz-cv.pdf` is committed so every rendered site has a stable download.

## Content map

- `index.qmd`: first-impression profile and selected work
- `research.qmd`: research agenda and contribution-labelled outputs
- `cv.qmd`: accessible HTML CV and PDF download
- `cv/miguel-camacho-horvitz-cv.tex`: sanitised public CV source
- `assets/profile.jpg`: homepage portrait (currently a placeholder)
- `assets/robust-inference-weak-instruments.pdf`: co-authored methods paper linked from the research page
- `assets/addressing-enduring-gender-gap-chilean-labour-market.pdf`: co-authored policy note linked from the research page
- `assets/social-card.svg`: editable social-preview artwork (`make social-card` regenerates the PNG)
- `styles.scss`: design system and responsive rules
- `.github/workflows/publish.yml`: GitHub Pages build and deployment

## Replace the portrait placeholder

Overwrite `assets/profile.jpg` with the final photograph; the page markup and crop are already configured. Use a 4:5 head-and-shoulders image, ideally at least 1200 × 1500 pixels, exported as an sRGB JPEG. A natural, uncluttered background and normal academic or everyday professional clothing will fit the site better than a heavily retouched corporate portrait.

After replacing the file, change the image alt text in `index.qmd` from `Portrait placeholder for Miguel Camacho Horvitz` to `Portrait of Miguel Camacho Horvitz`, then run `make check`. Keep the file reasonably small for the web—roughly 300–600 KB is a useful target.

## Public-data boundary

Before any public release, review every staged file. Never copy private profile YAML, campaign trackers, transcripts, references, application materials, raw Vault sources, phone numbers, home addresses, restricted-data details, or unpublished coauthor material into this repository. Confirm that co-authors are comfortable with any joint manuscript before publishing it. The public CV intentionally omits a phone number, grades, planned travel or relocation, and private application strategy.

The email address is included because it was already configured as the contact address in this website repository. Remove it from `_quarto.yml`, the QMD files, and the CV source if that is no longer intended for public use.

## Deployment

The workflow is ready, but deployment has not been enabled and no changes have been pushed. After reviewing and committing the files:

1. In the repository on GitHub, open **Settings → Pages**.
2. Under **Build and deployment**, choose **GitHub Actions**.
3. Push `main` or run the **Publish website** workflow manually.
4. Verify the public site, CV download, and external links.

GitHub Pages output is public even when the source repository is private. Treat every rendered page and linked asset as publicly disclosed.
