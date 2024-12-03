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
echo There are $(grep ">" $(find $directory -name "*.fa" -or -name "*.fasta") | awk '{gsub(/:/, " ", $0); print $2}' | sort | uniq -c | wc -l) unique Fasta Ids in this folder
echo

#### creating text file to iterate through for awk names ######

find $directory -name "*.fa" -or -name "*.fasta" > fastafiles.txt



############# Bulk of the assignment ##################

counter="1"
find $directory -name "*.fa" -or -name "*.fasta" | while read i; do
	echo "####################" $(awk -F'/' '{print $NF}' fastafiles.txt | awk "NR == $counter") "########################"
	echo File $counter
	echo The File path for this file is $i
	echo it has $(grep ">" $i | wc -l) sequences
	if [[ -h $i ]]; then 
  		echo This file is a symlink;
  	else
  		echo This file is not a symlink
  	fi
  	echo The total sequence length of this file is: $(echo $(grep ">" -v $i) | awk '!/>/{gsub(/-/, "", $0); print $0}' | awk '!/>/{gsub(/ /, "", $0); print $0}' | wc -c)
  	echo
  	echo $(grep ">" -v $i) | awk '!/>/{gsub(/-/, "", $0); print $0}' | awk '!/>/{gsub(/ /, "", $0); print $0}' > seq.txt
  	if [[ -z $(grep [B,D-F,H-M,O-S,U-Z] seq.txt) ]]; then echo NUCLEOTIDE SEQ; else echo PROTEIN SEQ; fi
  	echo
  	echo
    line_count=$(wc -l < "$i")
    if (( $lines == 0 )); then
    	echo electing to not sneak peak at file contents
  	elif (( $line_count <= 2 * $lines )); then
		cat "$i"
	else
  		head -n "$lines" "$i"
  		echo ...
  		tail -n "$lines" "$i"
	fi
	echo "##################################################################################"
	echo  
	#echo $counter
	counter=$(($counter+1))
done

rm fastafiles.txt


