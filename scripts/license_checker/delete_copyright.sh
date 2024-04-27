#!/bin/bash

REPO="document-server-integration/"

find "$REPO" -type f \( -name "*.js" -o -name "*.java" -o -name "*.css" \) \
  -not \( -path "$REPO/.git/*" -o -path "$REPO/.github/*" \) | while read -r file; do
    if grep -q "Copyright Ascensio System SIA" "$file"; then
        perl -i -0777 -pe 's|/\*.*?Copyright Ascensio System SIA.*?\*/||gs' "$file"
        reuse annotate --year 2024 --license Apache-2.0 --copyright="Ascensio System SIA" "$file"
    fi
done
