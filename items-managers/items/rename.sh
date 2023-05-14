#!/bin/bash

# Find directories with -item or -items
dirs=$(find . -type d \( -name "*-item" -o -name "*-items" \))

# If no such directories found, exit the script
if [[ -z "$dirs" ]]; then
  echo "No directories found with -item or -items"
  exit 0
fi

# Show the directories and ask for confirmation
echo "Directories to be renamed:"
echo "$dirs"

read -p "Are you sure you want to rename these directories? [y/N] " response
case "$response" in
[yY][eE][sS] | [yY]) ;;
*)
  echo "Operation cancelled."
  exit 1
  ;;
esac

# Rename the directories
echo "Renaming directories..."
while IFS= read -r dir; do
  # Create new directory name by removing -item and preserving the s if present
  newdir=$(echo "$dir" | sed 's/-item\(\(s\)\?\)$/\1/')
  mv -- "$dir" "$newdir"
done <<<"$dirs"

echo "Operation completed."
