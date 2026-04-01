#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(realpath "$PROJECT_DIR")"

find "$PROJECT_DIR" -maxdepth 2 -name "*.html" | while read -r html_file; do
  html_file="$(realpath "$html_file")"
  rel="${html_file#$PROJECT_DIR/}"
  dir=$(dirname "$rel")

  if [[ "$dir" != "." && "$dir" != "blog" ]]; then
    continue
  fi

  og_image="${html_file%.html}.png"

  echo "📸 Screenshotting $html_file..."
  firefox --headless --screenshot "$og_image" --window-size=1200,630 "file://$html_file" 2>/dev/null

  echo "✅ Saved $og_image"
done

echo "Done."
