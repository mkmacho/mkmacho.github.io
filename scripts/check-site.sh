#!/usr/bin/env bash
set -euo pipefail

site_dir="${1:-_site}"

if [[ ! -d "$site_dir" ]]; then
  echo "Missing rendered site: $site_dir" >&2
  exit 1
fi

required_files=(
  "$site_dir/index.html"
  "$site_dir/research.html"
  "$site_dir/cv.html"
  "$site_dir/404.html"
  "$site_dir/assets/miguel-camacho-horvitz-cv.pdf"
  "$site_dir/assets/robust-inference-weak-instruments.pdf"
  "$site_dir/assets/addressing-enduring-gender-gap-chilean-labour-market.pdf"
  "$site_dir/assets/profile.jpg"
)

for required_file in "${required_files[@]}"; do
  if [[ ! -s "$required_file" ]]; then
    echo "Missing or empty required file: $required_file" >&2
    exit 1
  fi
done

python - "$site_dir" <<'PY'
from __future__ import annotations

import html.parser
import pathlib
import sys
import urllib.parse
from collections import Counter

site = pathlib.Path(sys.argv[1]).resolve()
errors: list[str] = []


class PageParser(html.parser.HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.links: list[str] = []
        self.images: list[tuple[str, str | None]] = []
        self.ids: list[str] = []
        self.main_count = 0
        self.h1_count = 0
        self.html_lang: str | None = None
        self.title_depth = 0
        self.title_text: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        values = dict(attrs)
        if values.get("id"):
            self.ids.append(values["id"] or "")
        if tag == "html":
            self.html_lang = values.get("lang")
        elif tag == "main":
            self.main_count += 1
        elif tag == "h1":
            self.h1_count += 1
        if tag == "a" and values.get("href"):
            self.links.append(values["href"] or "")
        elif tag == "img" and values.get("src"):
            self.images.append((values["src"] or "", values.get("alt")))
        elif tag == "title":
            self.title_depth += 1

    def handle_endtag(self, tag: str) -> None:
        if tag == "title" and self.title_depth:
            self.title_depth -= 1

    def handle_data(self, data: str) -> None:
        if self.title_depth:
            self.title_text.append(data)


for page in sorted(site.rglob("*.html")):
    parser = PageParser()
    parser.feed(page.read_text(encoding="utf-8"))
    if not "".join(parser.title_text).strip():
        errors.append(f"{page.relative_to(site)}: missing document title")
    if parser.main_count != 1:
        errors.append(f"{page.relative_to(site)}: expected one main landmark, found {parser.main_count}")
    if parser.h1_count != 1:
        errors.append(f"{page.relative_to(site)}: expected one h1, found {parser.h1_count}")
    if not parser.html_lang:
        errors.append(f"{page.relative_to(site)}: html element lacks a lang attribute")
    duplicate_ids = sorted(value for value, count in Counter(parser.ids).items() if count > 1)
    if duplicate_ids:
        errors.append(f"{page.relative_to(site)}: duplicate ids {', '.join(duplicate_ids)}")
    for src, alt in parser.images:
        if alt is None:
            errors.append(f"{page.relative_to(site)}: image lacks alt attribute ({src})")
    for href in parser.links:
        parsed = urllib.parse.urlparse(href)
        if parsed.scheme or href.startswith(("#", "mailto:", "tel:")):
            continue
        clean = urllib.parse.unquote(parsed.path)
        if not clean:
            continue
        target = (site / clean.lstrip("/")) if clean.startswith("/") else (page.parent / clean)
        if target.is_dir():
            target = target / "index.html"
        if not target.exists():
            errors.append(f"{page.relative_to(site)}: broken local link {href}")

if errors:
    print("\n".join(errors), file=sys.stderr)
    raise SystemExit(1)

print(f"Checked {len(list(site.rglob('*.html')))} HTML pages: local links and image alt attributes pass.")
PY

if rg -n -i '(\+1[[:space:]]+412|reportable_through|secure_pointer|95_career|planned_location)' "$site_dir" --glob '!site_libs/**'; then
  echo "Potential private-profile content found in rendered output." >&2
  exit 1
fi

if command -v pdftotext >/dev/null 2>&1; then
  if pdftotext "$site_dir/assets/miguel-camacho-horvitz-cv.pdf" - | rg -q -i '(\+1[[:space:]]+412|412[[:space:]-]+523|planned relocation|GPA:)'; then
    echo "Potential private-profile content found in the public CV." >&2
    exit 1
  fi
fi

echo "Site checks passed."
