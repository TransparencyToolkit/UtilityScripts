for pcap_file in $1/*
do
	filename="${pcap_file%%.*}"
	destination=$2
	echo $destination

	if [[ -z $destination ]]; then
		# Convert pcap to text in directory
		echo converting file: $pcap_file
		tcpflow -r $pcap_file
	else
		echo converting file: $pcap_file to: $destination
		#mkdir $destination
		tcpflow -r $pcap_file -o $destination
	fi

done
