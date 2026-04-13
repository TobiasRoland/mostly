#!/usr/bin/env bash

set -euo pipefail
# PROJECT_DIR to the first argument ($1); default to current directory (.) if empty.
PROJECT_DIR="${1:-.}"
# to absolute path
PROJECT_DIR="$(realpath "$PROJECT_DIR")"

# Find all .html files, looking only 2 levels deep to avoid scanning deep asset folders.
find "$PROJECT_DIR" -maxdepth 2 -name "*.html" | while read -r html_file; do

  # ... also make that an absolute path.
  html_file="$(realpath "$html_file")"
  # strip $PROJECT_DIR prefix
  rel="${html_file#"$PROJECT_DIR"/}"
  # dir: Extracts the directory name (if rel is "blog/post.html", dir is "blog").
  dir=$(dirname "$rel")
  # Only process files in the root (".") or the "blog" directory.
  if [[ "$dir" != "." && "$dir" != "blog" ]]; then
    continue
  fi
  # Define the output PNG filename by stripping '.html' and adding '.png'.
  og_image="${html_file%.html}.png"
  echo "\t Screenshotting $html_file..."
  firefox --headless --screenshot "$og_image" --window-size=1200,630 "file://$html_file" 2>/dev/null
  echo "Saved $og_image"
done

echo "Done."
