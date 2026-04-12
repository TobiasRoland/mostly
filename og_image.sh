#!/usr/bin/env bash

# Exit immediately if a command fails (-e), an unset variable is used (-u),
# or if any command in a pipeline fails (-o pipefail).
set -euo pipefail

# Set PROJECT_DIR to the first argument ($1); default to current directory (.) if empty.
PROJECT_DIR="${1:-.}"

# Convert the project directory to an absolute path.
PROJECT_DIR="$(realpath "$PROJECT_DIR")"

# Find all .html files, looking only 2 levels deep to avoid scanning deep asset folders.
# The 'while read' loop processes each file path found.
find "$PROJECT_DIR" -maxdepth 2 -name "*.html" | while read -r html_file; do

  # Ensure the current html_file path is also an absolute path.
  html_file="$(realpath "$html_file")"

  # rel: Strips the $PROJECT_DIR prefix from the full path to get the relative path.
  rel="${html_file#$PROJECT_DIR/}"

  # dir: Extracts the directory name (e.g., if rel is "blog/post.html", dir is "blog").
  dir=$(dirname "$rel")

  # Only process files in the root (".") or the "blog" directory.
  # This prevents generating OG images for contact pages or help docs in other folders.
  if [[ "$dir" != "." && "$dir" != "blog" ]]; then
    continue
  fi

  # Define the output PNG filename by stripping '.html' and adding '.png'.
  og_image="${html_file%.html}.png"

  echo "📸 Screenshotting $html_file..."

  # Run Firefox in headless mode (no GUI).
  # --screenshot: Saves the viewport as an image.
  # --window-size: Standard Open Graph dimensions (1200x630).
  # 2>/dev/null: Discards browser logs/warnings to keep the terminal clean.
  firefox --headless --screenshot "$og_image" --window-size=1200,630 "file://$html_file" 2>/dev/null

  echo "✅ Saved $og_image"
done

echo "Done."
