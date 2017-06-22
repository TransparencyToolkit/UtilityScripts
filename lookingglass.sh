#! /bin/bash
#
# Start daemons and services to run LookingGlass
#
# Dependencies:
#
# - elasticsearch
# - mongodb
# - DocManager
# - LookingGlass

function start() {
	echo "Starting Elasticsearch"
	sudo service elasticsearch start
	sleep 2

	echo "Starting MongoDB"
	sudo service mongodb start
	sleep 2
	echo "Waiting..."
	sleep 3

	echo "Starting DocManager in a screen session"
	cd $TT_APPS/DocManager
	screen -S docmanager -dm bash -c 'rails server; exec sh'
	sleep 1
	echo "You should be able to access DocManager at:"
	echo "	http://${TT_DM_HOST}:${TT_DM_PORT}"
	sleep 1

	echo "Starting LookingGlass in a screen session"
	cd $TT_APPS/LookingGlass
	screen -S lookingglass -dm bash -c 'rails server -b ${TT_LG_HOST} -p ${TT_LG_PORT}; exec sh'
	sleep 2
	echo "You should now be able to access LookingGlass at:"
	echo "	http://${TT_LG_HOST}:${TT_LG_PORT}"
	sleep 4

	echo "LookingGlass is running. Happy viewing :)"
}

function quit() {
	echo "Stoping LookingGlass"
	screen -X -S lookingglass quit
	sleep 1

	echo "Stoping DocManager"
	screen -X -S docmanager quit
	sleep 1

	echo "Stoping Elasticsearch"
	sudo service elasticsearch stop
	sleep 1

	echo "Stoping MongoDB"
	sudo service mongodb stop
	sleep 1

	echo "The following should not list sessions: docmanager, lookingglass"
	screen -list
}

function restart() {
	quit;
	start;
}

usage() {
    prog="${0##*/}"
    printf "Usage: %s [-s|-q|-r]\n" "$prog"
    printf "\n"
    printf "Options:\n\n"
    printf "  -s\t Starts LookingGlass and services\n"
    printf "  -q\t Stops LookingGlass and services\n"
	printf "  -r\t Restarts LookingGlass and services (quit & start)\n"
    printf "\n"
}

if [[ "$#" == "0" ]] ; then
    usage;
else
    while getopts sqr x; do
        case $x in
	    	s)  start;;
            q)  quit;;
            r)  restart;;
            h)  usage;;
        esac
    done
fi
