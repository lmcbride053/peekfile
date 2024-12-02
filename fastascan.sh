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

############################################## Welcome message ##########################################

echo Hello bash user! Welcome to $directory!
echo
echo We are just going to be taking a quick look around at the fasta files in this folder with help from your little friend fastascan.sh.
echo
echo Lets get started!
echo

########### Identifying num fasta files and unique ids in 'directory'  ##############

numfafiles=$(find $directory -name "*.fa" -or -name "*.fasta" | wc -l)

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
  	echo sneak peak at contents:
  	echo
    line_count=$(wc -l < "$i")
  	if (( $line_count <= 2 * $lines )); then
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


