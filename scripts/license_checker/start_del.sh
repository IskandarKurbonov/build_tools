#!/bin/bash

REPO_DIR="document-server-integration/"

DELETED_LOG="deleted.log"
NOMATCH_LOG="nomatch.log"

touch "$DELETED_LOG"
touch "$NOMATCH_LOG"

LICENSE_REGEX="^\/\*\*"
LICENSE_END_REGEX="\*\/$"
COPYRIGHT_FILE="copyright.txt"

deleted=false
not_deleted=false

COPYRIGHT_CONTENT=$(<"$COPYRIGHT_FILE")  # Read copyright content from file

find "$REPO_DIR" -type f ! \( -path "*/.git/*" -o -path "*/.github/*" -o -iname "*.jpg" -o -iname "*.png" -o -iname "*.svg" -o -iname "*.gif" -o -iname "*.ico" -o -iname "*lock*" -o -iname "*license*" -o -iname "*.yml" -o -iname "*.chm" -o -iname "*.dll" -o -iname "*.proj" \) | while read -r file; do
    if grep -q "Ascensio System" "$file"; then
        if grep -qE "$LICENSE_REGEX" "$file" && grep -qE "$LICENSE_END_REGEX" "$file"; then
            # Delete existing license
            sed -i -e "/$LICENSE_REGEX/,/$LICENSE_END_REGEX/d" "$file"
            # Insert new copyright at the beginning of the file
            echo -e "$COPYRIGHT_CONTENT\n$(cat "$file")" > "$file"
            echo "$file" >> "$DELETED_LOG"
            deleted=true
        else
            echo "$file" >> "$NOMATCH_LOG"
            not_deleted=true
        fi
    fi
done

if "$deleted"; then
    echo "License is deleted"
else
    echo "No licenses were deleted"
fi

if "$not_deleted"; then
    echo "License is not deleted"
else
    echo "All licenses were deleted successfully"
fi
