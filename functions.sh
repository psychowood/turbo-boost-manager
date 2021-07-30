#!/usr/bin/env sh
# Contains function definitions for Turbo Boost Manager
# inherits variables $DIR and $KEXT_FILE

RED='\033[91m'
GREEN='\033[92m'
NC='\033[0m'

FIND_KEXT()
{
    APPS_FILE="/Applications/Turbo Boost Switcher.app/Contents/Resources/DisableTurboBoost.64bits.kext"
    APPS_RES_FILE="/Applications/tbswitcher_resources/DisableTurboBoost.64bits.kext"
    LOCAL_RES_FILE="$DIR/tbswitcher_resources/DisableTurboBoost.64bits.kext"

    if [ -e "$LOCAL_RES_FILE" ]; then
        echo "$LOCAL_RES_FILE"
    elif [ -e "$APPS_FILE" ]; then
        echo "$APPS_FILE"
    elif [ -e "$APPS_RES_FILE" ]; then
        echo "$APPS_RES_FILE"
    else
        return -1
    fi
}

CHECK_STATUS()
{
    result=`kmutil showloaded -V release | grep -c com.rugarciap.DisableTurboBoost`
}

PRINT_STATUS()
{
    echo
    echo "Checking status of Turbo Boost..."
    CHECK_STATUS
    if [ $result -eq 0 ]; then
        echo "TurboBoost: [${RED}enabled${NC}]"
    else
        echo "TurboBoost: [${GREEN}disabled${NC}]"
    fi
    echo
}

LOAD()
{    
    # Disables Turbo Boost
    # loads the pre-signed kext from Turbo Boost Switcher
    echo "[${GREEN}!${NC}]Disabling TurboBoost now...${NC}"
    sudo /usr/bin/kextutil -q "$KEXT_FILE"
    PRINT_STATUS
}

UNLOAD()
{
    # Enables Turbo Boost
    # unloads the pre-signed kext from Turbo Boost Switcher
    echo "[${RED}!${NC}]Unloading kext now...${NC}"
    sudo /sbin/kextunload "$KEXT_FILE"
    PRINT_STATUS    
}
