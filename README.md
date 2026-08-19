# Miguel Camacho Horvitz — research website

A small, application-focused academic website built with [Quarto](https://quarto.org). The site is a deliberately curated public export: it is not connected to, generated from, or allowed to crawl private resources such as the research vault.

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
- `assets/profile.jpg`: profile picture (large, ~3MB)
- `assets/profile-small.jpg`: profile picture (small, ~500KB)
- `photo-diary.qmd`: personal photo-diary page
- `assets/photo-diary/`: public photos used on that page
- `assets/robust-inference-weak-instruments.pdf`: co-authored methods paper linked from the research page
- `assets/addressing-enduring-gender-gap-chilean-labour-market.pdf`: co-authored policy note linked from the research page
- `assets/social-card.svg`: editable social-preview artwork (`make social-card` regenerates the PNG)
- `styles.scss`: design system and responsive rules
- `.github/workflows/publish.yml`: GitHub Pages build and deployment


## Adding photos to the diary

Put web-ready images in `assets/photo-diary/`. On your Mac, copy an image into that folder, give it a simple descriptive filename (for example `2026-08-mulanje-sunrise.jpg`), then add one entry to the `photo-diary.qmd` gallery. Each entry has an image, meaningful alternative text, and a caption directly underneath it:

```markdown
<figure class="diary-entry">
<img src="assets/photo-diary/2026-08-mulanje-sunrise.jpg" alt="Sun rising behind Mount Mulanje">
<figcaption>Mount Mulanje, Malawi · August 2026</figcaption>
</figure>
```

Keep photos to about 1600 pixels on the long edge and, when possible, below 1 MB. Remove location metadata for images that reveal a private home or sensitive location. Then run `make check`, commit the image and `photo-diary.qmd`, and push `main`; GitHub Pages will publish the update.

You can also upload through GitHub’s website: open the repository, navigate to `assets/photo-diary/`, choose **Add file → Upload files**, then edit `photo-diary.qmd` in the browser to add the matching caption block. Only upload images you are comfortable making public.

## Public-data boundary

Before any public release, review every staged file. Never copy private profile YAML, campaign trackers, transcripts, references, application materials, raw Vault sources, phone numbers, home addresses, restricted-data details, or unpublished coauthor material into this repository. Confirm that co-authors are comfortable with any joint manuscript before publishing it. The public CV intentionally omits a phone number, grades, planned travel or relocation, and private application strategy.

The email address is included because it was already configured as the contact address in this website repository. Remove it from `_quarto.yml`, the QMD files, and the CV source if that is no longer intended for public use.

## Deployment

The repository’s workflow renders the site and deploys it to GitHub Pages after each push to `main`. If Pages ever needs to be reconfigured:

1. In the repository on GitHub, open **Settings → Pages**.
2. Under **Build and deployment**, choose **GitHub Actions**.
3. Push `main` or run the **Publish website** workflow manually.
4. Verify the public site, CV download, and external links.

This repository and its GitHub Pages site are public. Treat every committed file and linked asset as publicly disclosed.
