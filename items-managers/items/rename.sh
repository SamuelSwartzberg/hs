#!/bin/bash

# Find files with -item.lua or -items.lua
files=$(find . -type f \( -name "*-item.lua" -o -name "*-items.lua" \))

# If no such files found, exit the script
if [[ -z "$files" ]]; then
  echo "No files found with -item.lua or -items.lua"
  exit 0
fi

# Show the files and ask for confirmation
echo "Files to be renamed:"
echo "$files"

read -p "Are you sure you want to rename these files? [y/N] " response
case "$response" in
[yY][eE][sS] | [yY]) ;;
*)
  echo "Operation cancelled."
  exit 1
  ;;
esac

# Rename the files
echo "Renaming files..."
while IFS= read -r file; do
  # Create new filename by removing -item and preserving the s if present
  newfile=$(echo "$file" | sed 's/-item\(\(s\)\?\)\.lua/\1.lua/')
  mv -- "$file" "$newfile"
done <<<"$files"

echo "Operation completed."
