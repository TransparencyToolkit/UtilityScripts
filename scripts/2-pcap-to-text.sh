for pcap_file in $1/*
do
	destination=$2

	# Strips off file extensions
	# filename="${pcap_file%%.*}"

	# This will get the directory of a file path
	# directory=$(dirname "${pcap_file}")

	# Use basename command to get the file
	# Use command substitution $( ... )
	# Another approach is to use "backquotes" method like
	# test=`basename "$file" .deb`
	# but backquotes is not reccommended

	# Create directory based on filename
	filename=$(basename "$pcap_file" .pcap)
	echo "mkdir: " $destination/$filename
	mkdir $destination/$filename

	if [[ -z $destination ]]; then
		# convert pcap to text in current directory
		echo converting file: $pcap_file to: $filename/
		tcpflow -Fk -r $pcap_file -o $filename/ 
	else
		# convert pcap into specified directory
		echo converting file: $pcap_file to: $destination/$filename/
		tcpflow -Fk -r $pcap_file -o $destination/$filename/
	fi

done
