#!/usr/bin/env sh

RED='\033[91m'
GREEN='\033[92m'
CYAN='\033[96m'
NC='\033[0m'

CHECK_STATUS()
{
    result=`kextstat | grep -c com.rugarciap.DisableTurboBoost`
}

PRINT_STATUS()
{
    echo
    echo "Checking status of Turbo Boost..."
    CHECK_STATUS
    if [ $result -eq 0 ]; then
        echo "[${RED}Kext is not loaded${NC}]" 
        echo "TurboBoost is currently [${RED}enabled${NC}]"
    else
        echo "[${CYAN}Kext 'com.rugarciap.DisableTurboBoost' is loaded.${NC}]"
        echo "Turbo Boost status: ${GREEN}disabled${NC}"
    fi
    echo
}

LOAD()
{    
    # Disables Turbo Boost
    # loads the pre-signed kext from Turbo Boost Switcher
    echo "[${RED}!${NC}]Disabling TurboBoost now...${NC}"
    sudo /usr/bin/kextutil -q '/Applications/Turbo Boost Switcher.app/Contents/Resources/DisableTurboBoost.64bits.kext'
    PRINT_STATUS
}

UNLOAD()
{
    # Enables Turbo Boost
    # unloads the pre-signed kext from Turbo Boost Switcher
    echo "[${RED}!${NC}]Unloading kext now...${NC}"
    sudo /sbin/kextunload '/Applications/Turbo Boost Switcher.app/Contents/Resources/DisableTurboBoost.64bits.kext'
    PRINT_STATUS    
}

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
            fi
            break
            ;;
        2) 
            CHECK_STATUS
            if [ $result -eq 0 ]; then
                PRINT_STATUS
            else
                UNLOAD
                break
            fi
            ;;
        3)
            PRINT_STATUS
            UNLOAD
            LOAD
            PRINT_STATUS
            break
            ;;
        4)
            PRINT_STATUS
            ;;
        5)
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