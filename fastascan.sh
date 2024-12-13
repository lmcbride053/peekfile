#!/bin/bash

#### FASTASCAN SCRIPT ####

#### ALG MIDTERM 3 ####

# Last edited Mon Dec 2


################################# Identifying the arguments (directory and number of lines) ###############################

directory="$1" 

lines="$2"


# default directory is current dir
if [[ -z "$directory" ]]; then
	directory="."
fi

# default num lines is 0
if [[ -z "$lines" ]]; then
	lines="0"
fi


# Check if directory is real and is a directory
if [[ ! -d "$directory" ]]; then
	echo $directory does not exist or is not a directory, try a different one or maybe check your spelling 
	exit 1
fi

# Check if there are fasta files in directory
numfafiles=$(find $directory -name "*.fa" -or -name "*.fasta" | wc -l)
if [[ $numfafiles -eq 0 ]]; then
	echo There are no fasta files in this folder to examine. Try a different folder 
	exit 1
fi




############################################## Welcome message ##########################################

echo Hello bash user!
echo
echo We are just going to be taking a quick look around at the fasta files in the folder you chose with help from your little friend fastascan.sh.
echo 
echo
echo For reference, the standard syntax for running this script is:
echo
echo $ bash /path/to/fastascan.sh directory numlines
echo
echo If you do not enter directory or line inputs, the default will be current folder and 0 lines
echo
echo
echo Lets get started!
echo ------------------------------------------------------------------------

echo


########### Identifying num fasta files and unique ids in 'directory'  ##############


echo It looks like there are $numfafiles fasta files in this directory
echo
# listing all the fasta ids sorted and then one line for each unique id, then counting. has to be different depending on whether there are one or more files (name of file is $1 when there are more than one file)
if [[ $numfafiles -gt 1 ]]; then
	echo There are $(grep ">" $(find $directory -name "*.fa" -or -name "*.fasta") | awk '{gsub(/>/, " ", $0); print $2}' | sort | uniq -c | wc -l) unique Fasta Ids in this folder
else echo There are $(grep ">" $(find $directory -name "*.fa" -or -name "*.fasta") | awk '{gsub(/>/, " ", $0); print $1}' | sort | uniq -c | wc -l) unique Fasta Ids in this folder
fi
echo

#### creating text file to iterate through for awk names ######

find $directory -name "*.fa" -or -name "*.fasta" > fastafiles.txt



############# Bulk of the assignment ##################

counter="1" # creating counter to match names of files to the right order
# doing a while read loop to go through each file in fastafiles.txt
find $directory -name "*.fa" -or -name "*.fasta" | while read i; do
# creating a header
	echo "####################" $(awk -F'/' '{print $NF}' fastafiles.txt | awk "NR == $counter") "########################"
# listing the file number
	echo File $counter
# listing the file path
	echo The File path for this file is $i
# counting the number of sequences by counting the number of > in the file
	echo it has $(grep ">" $i | wc -l) sequences
# using an if statement to test if it is a symlink
	if [[ -h $i ]]; then 
  		echo This file is a symlink;
  	else
  		echo This file is not a symlink
  	fi
# this removes all lines with > (sequence names) and puts all the sequences into one echo'ed line (echo turns return characters into spaces), removes all spaces then counts the number of characters to count the number of aa or nucs 
  	echo The total sequence length of this file is: $(echo $(grep ">" -v $i) | awk '!/>/{gsub(/-/, "", $0); print $0}' | awk '!/>/{gsub(/ /, "", $0); print $0}' | wc -c)
  	echo
# this creates a file with all the nucs or aa counted above
  	echo $(grep ">" -v $i) | awk '!/>/{gsub(/-/, "", $0); print $0}' | awk '!/>/{gsub(/ /, "", $0); print $0}' > seq.txt
# if there are any non ATCG capitals in the sequences, it is a protein seq, if not then its a nucleotide seq
  	if [[ -z $(grep [B,D-F,H-M,O-S,U-Z] seq.txt) ]]; then echo NUCLEOTIDE SEQ; else echo PROTEIN SEQ; fi
  	echo
  	echo
# this part comes from the earlier script we wrote, counts the number of lines in each file
    line_count=$(wc -l < "$i")
# added a part that says if the number of lines inputted to the script is 0 then we are not peeking at file contents
    if (( $lines == 0 )); then
    	echo electing to not sneak peek at file contents
# otherwise if the number of lines is less than or equal to twice the number of lines inputted will print the whole file
  	elif (( $line_count <= 2 * $lines )); then
		cat "$i"
# otherwise will print the number of lines requested at the beginning and end with ... in the middle
	else
  		head -n "$lines" "$i"
  		echo ...
  		tail -n "$lines" "$i"
	fi
	echo "##################################################################################"
	echo  
	#echo $counter
# counter goes up for next file
	counter=$(($counter+1))
done

################################ CLOSING STATEMENT #####################################
echo
echo And there you have it, hope this was informative. Happy bashing!
echo

# removing temporary files used for iterating

rm fastafiles.txt

rm seq.txt
