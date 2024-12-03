#!/bin/bash

#### FASTASCAN SCRIPT ####
#### ALG MIDTERM 3 ####

# Last edited Tues Dec 3

# This is the chatgpt script, i did my best to force it to only use syntax i understood and keep it correct

################################ Argument Handling ################################

# Set default directory
if [[ -z "$directory" ]]; then
    directory="."
fi

# Set default lines
if [[ -z "$lines" ]]; then
    lines="0"
fi

if [[ ! -d "$directory" ]]; then
    echo "Error: '$directory' is not a valid directory. Please check the path and try again."
    exit 1
fi

# Get a list of all FASTA files and count them
fasta_files=$(find "$directory" -name "*.fa" -or -name "*.fasta")
numfafiles=$(echo "$fasta_files" | wc -l)


if [[ $numfafiles -eq 0 ]]; then
    echo "No FASTA files found in '$directory'. Exiting."
    exit 1
fi

################################ Welcome Message ##################################

# thought i would keep this in here in this form since i thought it was cool and i like how elegant it is, though i dont remember ever using this syntax in class
cat << EOF

Hello, bash user!

Welcome to fastascan.sh, your friendly FASTA file analyzer.

Syntax:
  bash /path/to/fastascan.sh [directory] [numlines]

Defaults:
  - directory: Current folder
  - numlines: 0 (no file preview)

Let's get started!
-------------------------------------------------------------------------------

EOF

################################ File and ID Summary ################################

echo "Found $numfafiles FASTA files in '$directory'."
echo
unique_ids=$(find "$directory" -name "*.fa" -or -name "*.fasta" \
    -exec grep ">" {} + | awk '{gsub(/>/, ""); print $1}' | sort -u | wc -l)

echo "There are $unique_ids unique FASTA IDs in this directory."
echo

################################## Main Analysis ###################################

counter=1
find "$directory" -name "*.fa" -or -name "*.fasta" | while read -r file; do
    echo "#################### File $counter ########################"
    filename=${file##*/}
    echo "File Name: $filename"
    echo "File Path: $file"
    
    sequence_count=$(grep -c ">" "$file")
    echo "Number of sequences: $sequence_count"
    
    if [[ -h "$file" ]]; then
        echo "This file is a symlink."
    else
        echo "This file is not a symlink."
    fi

    # Calculate total sequence length
# god i wish i had thought of this, though i think it is not completely right
    total_length=$(grep -v ">" "$file" | tr -d " \n" | wc -c)
    echo "Total sequence length: $total_length"
    
    # Determine sequence type
# i need to work on my regular expressions cause this is so much better (had to add Nn, chatgpt didnt include it and the resulting script called nuc seqs proteins)
# chat gpt also forgot to remove > lines, i told it to resolve this
  if grep -v ">" "$file" | grep -q "[^ACGTNacgtn]"; then
    echo "Sequence Type: Protein"
else
    echo "Sequence Type: Nucleotide"
fi
# this next part is similar to what i had just formatted better
    # File preview
    line_count=$(wc -l < "$file")
    if (( lines == 0 )); then
        echo "Skipping file preview."
    elif (( line_count <= 2 * lines )); then
        echo "File Content:"
        cat "$file"
    else
        echo "File Content (Preview):"
        head -n "$lines" "$file"
        echo "..."
        tail -n "$lines" "$file"
    fi

    echo "###############################################################"
    echo
    ((counter++))
done

################################ Closing Statement ##################################

echo "All done! Hope this was informative. Happy bashing!"