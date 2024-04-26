#!/bin/bash

REPO="document-server-integration/"

search_and_replace() {
    local file="$1"
    perl -i -0777 -pe 's|/\*.*?Copyright Ascensio System SIA.*?\*/||gs' "$file"
}

find "$REPO" -type f \( -name "*.js" -o -name "*.java" -o -name "*.css" \) \
  -not \( -path "$REPO/.git/*" -o -path "$REPO/.github/*" \) | while read -r file; do
    if grep -q "Copyright Ascensio System SIA" "$file"; then
        search_and_replace "$file"
        echo "$file" >> success.log
    fi
done
