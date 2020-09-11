#!/usr/bin/env sh

source '/Users/deepankar/OneDrive - O365 Turun yliopisto/Git/GitHub/forks/turbo-boost-disable/functions.sh'

while true
do
	printf ' -- Turbo Boost Manager -- 
	1) Disable Turbo Boost
	2) Enable Turbo Boost
	3) Full-Cycle Disable
	4) Check status
	5) Exit
	  
	Enter: ';
	read var;
	
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
            sleep 1 # give time to the system to do unload the kext properly
            LOAD
            break
            ;;
        4)
            PRINT_STATUS
            sleep 0.5
            ;;
        5)
            echo "Bye"
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