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

find $directory -name "*.fa" -or -name "*.fasta" | while read i; do
	echo "############################################"
	awk -F'/' '{print $NF}'
	echo "############################################"
	echo
done



#awk -F'/' '{print $NF}' $i





