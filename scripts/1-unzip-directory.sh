for zip_file in $1/*
do
	echo unzipping: $zip_file
	unzip $zip_file -d $1/

done
