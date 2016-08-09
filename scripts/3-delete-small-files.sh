#!/bin/bash

# Recursively traverses a directories and

function traverse() {   
    for item in $(ls "$1")
    do
        if [[ ! -d ${1}/${item} ]]; then
			actualsize=$(wc -c < "$1/$item")
			extension="${item##*.}"
			if [[ $extension = "xml" ]]; then
				echo " "file $1/$item is a $extension delete
				rm $1/$item	
			elif [[ $actualsize -le $minimumsize ]]; then
				echo " "file $1/$item is less $actualsize bytes delete
				rm $1/$item
			elif [[ $actualsize -ge $minimumsize ]]; then
				echo " "file $1/$item is greater $minimumsize bytes keep                                                                    
			else             
				echo " "invalid item
				exit 1
			fi
        else
            echo "entering recursion with: ${1}${item}"
            traverse "${1}/${item}"
        fi
    done
}

function main() {
	minimumsize=$2
	echo Filtering out bigger than $minimumsize
    traverse $1 $minimumsize
}

main $1 $2
