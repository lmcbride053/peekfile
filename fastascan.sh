#### FASTASCAN SCRIPT ####

#### ALG MIDTERM 3 ####

# Last edited Mon Nov 25


# Identifying the arguments (directory and number of lines)


directory="$1"

lines="$2"

# default directory is current dir
if [[ -z "$directory" ]]; then
	directory="."
fi

# default num lines is 0
if [[ -z "$lines" ]]; then
	directory="0"
fi

echo $directory is the directory we are searching in and $lines is the number of lines we will be using for displaying content


# Identifying fasta files in 'directory'

find $directory -name "*.fa" -or -name "*.fasta"

