#! /bin/bash
#
# Start daemons and services to run LookingGlass
#
# Dependencies:
#
# - Elasticsearch
# - PostGres
# - Standford NER
# - DocManager
# - Catalyst
# - LookingGlass
#
# Add the following environment variables in .profile or .bashrc:
#
# export TT_APPS="/home/user/tt-ansible"
# export TT_DATA="/home/user/data"
# export TT_DM_HOST="0.0.0.0"
# export TT_DM_PORT="3000"
# export TT_HS_HOST="0.0.0.0"
# export TT_HS_PORT="3002"
# export TT_CT_HOST="0.0.0.0"
# export TT_CT_PORT="3003"
# export TT_LG_HOST="0.0.0.0"
# export TT_LG_PORT="3001"
# export TT_ELASTIC="/home/user/elasticsearch/bin"
# export TT_NER_PATH="/home/user/stanford-ner/"

function start() {
    if [[ $TT_ELASTIC != "" ]]; then
        echo "Starting Elasticsearch manually"
        cd $TT_ELASTIC
        screen -S elasticsearch -dm /bin/bash -c './elasticsearch; exec sh'
    else
	    echo "Starting Elasticsearch service"
	    sudo service elasticsearch start
    fi
    sleep 3
    echo "Waiting..."
    sleep 4

	echo "Starting PostGres"
	sudo service postgresql start
	sleep 3
	echo "Waiting..."
	sleep 4

    echo "Starting Stanford NER..."
    cd $TT_NER_PATH
    screen -S ner -dm bash -c 'java -mx1000m -cp stanford-ner.jar:lib/* edu.stanford.nlp.ie.NERServer -loadClassifier classifiers/english.all.3class.distsim.crf.ser.gz -port 9002 -outputFormat inlineXML; exec sh'
    sleep 2

    echo "Starting Catalyst"
    cd $TT_APPS/Catalyst
    screen -S catalyst -dm bash -c 'rails server -b 0.0.0.0 -p 9004; exec sh'
    sleep 2

	echo "Starting DocManager in a screen session"
	cd $TT_APPS/DocManager
	screen -S docmanager -dm /bin/bash -c 'rails server; exec sh'
	sleep 3
	echo "DocManager should be accessible at:"
	echo "	http://${TT_DM_HOST}:${TT_DM_PORT}"
	sleep 2

	echo "Starting LookingGlass in a screen session"
	cd $TT_APPS/LookingGlass
	screen -S lookingglass -dm /bin/bash -c 'rails server -b ${TT_LG_HOST} -p ${TT_LG_PORT}; exec sh'
	sleep 3
	echo "You should now be able to access LookingGlass at:"
	echo "	http://${TT_LG_HOST}:${TT_LG_PORT}"
	sleep 4

	echo "LookingGlass is running. Happy viewing :)"
}

function dev() {

	cd $TT_APPS/LookingGlass
    echo "Running sass compiler on 'default' theme"
    screen -S sass -dm /bin/bash -c 'watch default; exec sh'

    echo "Open default/theme.scss in screen: stylez"
	screen -S stylez -dm /bin/bash -c 'vim public/default/theme.scss; exec sh'
	sleep 2

    echo "Open specified file ${1} in screen: dev "
	screen -S dev -dm /bin/bash -c 'vim ${1}; exec sh'

	echo "Happy hacking :)"
}

function uploader() {

    cd $TT_APPS/IndexServer
    echo "Runing IndexSever in screen: indexer"
    screen -S indexer -dm /bin/bash -c 'rackup -p 9494; exec sh'
    sleep 1

    cd $TT_APPS/OCRServer
    echo "Runing OCRServer in screen: ocr":
    screen -S ocr -dm /bin/bash -c 'rackup -p 9393; exec sh'
    sleep 1

	cd $TT_APPS/DocUpload
    echo "Runing DocUpload in screen: upload'"
    screen -S upload -dm /bin/bash -c 'rackup config.ru --host 0.0.0.0; exec sh'
    sleep 1

    echo "All done runing toos to upload dox. View interface at:"
    echo "\n\thttp://localhost:9292/upload/archive_test"
}

function quit() {

    echo "Stoping Indexer"
	screen -X -S indexer quit
	sleep 1

    echo "Stoping OCRServer"
	screen -X -S ocr quit
	sleep 1

    echo "Stoping DocUpload"
	screen -X -S upload quit
	sleep 1

    echo "Stoping LookingGlass"
	screen -X -S lookingglass quit
	sleep 1

	echo "Stoping Catalyst"
	screen -X -S catalyst quit
	sleep 1

	echo "Stoping NER"
	screen -X -S ner quit
	sleep 1

	echo "Stoping DocManager"
	screen -X -S docmanager quit
	sleep 1

    if [[ $TT_ELASTIC != "" ]]; then
	    echo "Stoping Elasticsearch manually"
        screen -X -S elasticsearch quit
    else
	    echo "Stoping Elasticsearch service"
	    sudo service elasticsearch stop
    fi
    sleep 1

	echo "Stoping PostGres"
	sudo service postgresql stop
	sleep 1

	echo "You should not see sessions: docmanager, lookingglass, elasticsearch"
	screen -list
}

function restart() {
	quit;
    sleep 2
	start;
}

function build() {
    build_path="${TT_APPS}/LookingGlass/public/"
    cd $build_path
    themes_path="themes/"
    for theme in "${themes_path[@]}"*; do
        theme_name="$(echo $theme | sed 's/themes\///')"
        echo "Building theme: ${theme_name}"
        echo "sass ${theme}/theme.scss:css/${theme_name}.css"
        sass ${theme}/theme.scss:css/${theme_name}.css
        sleep 1
    done
    echo "Done building themes"
}

usage() {
    prog="${0##*/}"
    printf "Usage: %s [-s|-d|-q|-u|-r|-b]\n" "$prog"
    printf "\n"
    printf "Options:\n\n"
    printf "  -s\t Starts LookingGlass, Catalyst and services\n"
    printf "  -s\t Run dev tools for front-end and other code\n"
    printf "  -q\t Stops all apps and services services\n"
    printf "  -u\t Starts DocUploader and other services\n"
    printf "  -r\t Restarts LookingGlass, Catalyst and services (quit & start)\n"
    printf "  -b\t Build all LookingGlass themes with SASS\n"
    printf "\n"
}

if [[ "$#" == "0" ]] ; then
    usage;
else
    while getopts "sdqurbw:" opt; do
        case $opt in
	    	s)
                echo "Starting LookingGlass and dependencies"
                start;;
	    	d)
                echo "Run SASS compiler, open default theme, and file in dev"
                start;;
            q)
                echo "Quitting LookingGlass and dependencies"
                quit;;
            u)
                echo "Starts DocUploader and services"
                uploader;;
            r)
                echo "Restarting LookingGlass and dependencies"
                restart;;
            b)
                echo "Using SASS to build LookingGlass themes"
                build;;
            h)  usage;;
        esac
    done
fi
