#!/bin/bash
#Check for argument
if [[ $# -ne 1 ]] ; then
	echo 'Usage:'
	echo './firmhand.sh <path to firmware file>'
	echo 'This script binwalks and extracts firmware files auto-magically'
	echo 'Currently, only supports squashfs - supplied as PoC...'
	exit
fi

#Set variables
FIRMFILE=$1
file="log.txt"

#Get the parts for files:
basefile=$(basename $1)
dirfile=$(dirname $1)
binwalkdir="$dirfile/_$basefile.extracted/"

# Clear the previous log file
rm $file

# GetSize function - just in case it's needed...
function getSize() {
	local param1="$1"
	local size=$(awk -F "[: ]+" '{ for(i=1;i<=NF;i++) if ($i == "size") print $(i+1) }' <<< "$param1")
	echo "$size"
}

# Start the show!
binwalk -e $1 > /tmp/binwalk-output.txt
echo "[i] Binwalk output is:" | tee -a $file
cat /tmp/binwalk-output.txt | tee -a $file
echo "[i] Binwalk made the following files in" $(dirname $1)/_*
ls -d -1 "$bindwalkdir" | tee /tmp/bin-files.txt
for i in `cat /tmp/bin-files.txt`; do unsquashfs $i; done



