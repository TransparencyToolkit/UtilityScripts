#! /bin/bash
#
# Start daemons and services to run Harvester
#
# Dependencies:
#
# - mongodb
# - DocManager
# - tika
# - tesseract
# - Harvester

function start() {

	echo "Starting MongoDB"
	sudo service mongodb start
	sleep 2
	echo "Waiting..."
	sleep 4

	echo "Starting Elasticsearch"
	sudo service elasticsearch start
	sleep 2

	# Start Tika --host=localhost --port=1234
	echo "Starting Tika"
	screen -S tika -dm bash -c 'java -jar /srv/tika-server-1.15.jar; exec sh'
	sleep 2

	echo "Starting DocManager in screen session"
	cd $TT_APPS/DocManager
	screen -S docmanager -dm bash -c 'rails server; exec sh'
	sleep 2
	echo "You should be able to access DocManager at:"
	echo "	http://${TT_DM_HOST}:${TT_DM_PORT}"
	sleep 2

	echo "Starting Harvester in screen session"
	cd $TT_APPS/Harvester
	screen -S harvester -dm bash -c 'rails server -b ${TT_HS_HOST} -p ${TT_HS_PORT}; exec sh'
	sleep 3

	echo "Starting Resque"
	cd $TT_APPS/Harvester
	screen -S resque -dm bash -c 'QUEUE=* rake environment resque:work; exec sh'
	sleep 2

	echo "You should now be able to access Harvester at:"
	echo "	http://${TT_HS_HOST}:${TT_HS_PORT}"
	sleep 1

	echo "Harvester is running. Happy researching :)"
}

function quit() {
	echo "Stoping Harvester"
	screen -X -S harvester quit
	sleep 1

	echo "Stoping DocManager"
	screen -X -S docmanager quit
	sleep 1

	echo "Stoping Tika"
	screen -X -S tika quit
	# for session in $(screen -ls | grep -o '[0-9]*\.harvester'); do screen -S "${session}" -X quit; done
	sleep 1

	echo "Stoping Resque"
	screen -X -S resque quit
	sleep 1

	echo "Stoping Elasticsearch"
	sudo service elasticsearch stop
	sleep 1

	echo "Stoping MongoDB"
	sudo service mongodb stop
	sleep 1

	echo "The following should not list sessions: tika, docmanager, harvester"
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
    printf "  -s\t Starts Harvester and services\n"
    printf "  -q\t Stops Harvester and services\n"
	printf "  -r\t Restarts Harvester and services (quit & start)\n"
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
