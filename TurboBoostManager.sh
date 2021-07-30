#!/usr/bin/env sh

RED='\033[91m'
GREEN='\033[92m'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIR/functions.sh"

while true
do
	CHECK_STATUS
    if [ $result -eq 0 ]; then
        echo "  ---- Turbo Boost Manager ----"
        echo "TurboBoost: [${RED}enabled${NC}]"
    else
        echo "  ---- Turbo Boost Manager ----"
        echo "TurboBoost: [${GREEN}disabled${NC}]"
	KEXT_FILE=$(FIND_KEXT)

    if [ -z "$KEXT_FILE" ]; then
        echo "Turbo Boost Switcher (TBS) files missing, downloading locally, please wait a few minutes..."
        GET_FILES "$DIR/downloadTBS.log"
        KEXT_FILE=$(FIND_KEXT)
        if [ -z "$KEXT_FILE" ]; then
            echo "Couldn't download Turbo Boost Switcher (TBS) files, sorry. Please check $DIR/downloadTBS.log for errors"
            exit -1;
        else
            echo "Files downloaded. Don't forget to

    sudo chown -R root:wheel '$DIR/tbswitcher_resources'

before running Turbo Boost Manager again, otherwise you'll get permission-related errors on load."
            rm "$DIR/downloadTBS.log"
            exit 0;
        fi
    fi
	printf '
	1) Disable Turbo Boost
	2) Enable Turbo Boost
	3) Re-Disable
	4) Check status
	5) Exit
	  
	Enter: ';
	read var;
	# option #3 Re-disable unloads the kext and loads it again
	case $var in
	    1)  
	        CHECK_STATUS
            if [ $result -eq 0 ]; then
                LOAD
                break
            else
                PRINT_STATUS
                sleep 0.5
            fi
            ;;
        2) 
            CHECK_STATUS
            if [ $result -eq 0 ]; then
                PRINT_STATUS
                sleep 0.5
            else
                UNLOAD
                break
            fi
            ;;
        3)
            PRINT_STATUS
            UNLOAD
            sleep 3 # give time to the system to do unload the kext properly
            LOAD
            break
            ;;
        4)
            PRINT_STATUS
            sleep 0.5
            ;;
        5)
            echo "Bye"
            exit 0
            ;;
        *)
            echo
            echo "Valid range of choices [1-5]."
            echo "Try again..."
            echo
            sleep 0.5
            continue
    esac
done
sudo -k 
exit 0