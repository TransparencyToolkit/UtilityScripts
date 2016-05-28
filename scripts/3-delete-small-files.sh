minimumsize=$2
echo delete files smaller than $minimumsize
for this_file in $1/*
do
	# print variable "$file"
	# echo $file
	# stat --printf="%s" $file
	# newline

	# Delete is smaller 1000 bytes
	actualsize=$(wc -c <"$this_file")

	if [ $actualsize -le $minimumsize ]; then
		echo $this_file is $actualsize bytes delete
		rm $this_file
	else
		echo $this_file is $minimumsize bytes keep
	fi

done
