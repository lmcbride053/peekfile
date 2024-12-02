#### FASTASCAN SCRIPT ####

#### ALG MIDTERM 3 ####

# Last edited Mon Nov 25


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

########### Identifying fasta files in 'directory'  ##############

#find $directory -name "*.fa" -or -name "*.fasta"

numfafiles=$(find $directory -name "*.fa" -or -name "*.fasta" | wc -l)

echo It looks like there are $numfafiles fasta files in this directory
echo


#### Iterating through fasta files ######
#find $directory -name "*.fa" -or -name "*.fasta" > fastafiles.txt

#awk -F'/' '{print "############################################"; 
#print "######  " $NF "  #####";
#print "############################################" "\n"}' fastafiles.txt


#awk '/^>/{print $0}' cysd_archaea.uniprot.fa | wc -l

#for file in fastafiles.txt; do
#	echo "############################################"
#	echo "######  " $file "  #####"
#	echo "############################################"
#	echo
#done
counter="1"
find $directory -name "*.fa" -or -name "*.fasta" | while read i; do
	echo "############################################"
	awk -F'/' '{print $NF}' fastafiles.txt | awk "NR == $counter"
	echo The File path for this file is $i
	echo it has $(grep ">" $i | awk -F' ' '{print $1}' | sort | uniq -c | wc -l) unique fasta IDs
	echo it has $(grep ">" $i | wc -l) sequences
	if [[ -h $i ]]; then 
  		echo This file is a symlink;
  	else
  		echo This file is not a symlink
  	fi
  	echo The total sequence length of this file is: $(echo $(grep ">" -v $i) | awk '!/>/{gsub(/-/, "", $0); print $0}' | awk '!/>/{gsub(/ /, "", $0); print $0}' | wc -c)
	echo "############################################"
	echo  
	#echo $counter
	counter=$(($counter+1))
done

#find $directory -name "*.fa" -or -name "*.fasta" | while read i; do
#	echo "############################################"
#	grep ">" $i | awk -F' ' '{print $1}' | sort | uniq -c | wc -l
#	echo "############################################"
#	echo
#done


#awk -F' ' '{print $1}' $i | sort | uniq -c

#awk -F'/' '{print $NF}' $i


# echo $(grep ">" -v cysd_archaea.uniprot.fa) | awk '!/>/{gsub(/-/, "", $0); print $0}' | awk '!/>/{gsub(/ /, "", $0); print $0}' | wc -c


