#!/usr/bin/env sh
# Contains function definitions for Turbo Boost Manager

RED='\033[91m'
GREEN='\033[92m'
NC='\033[0m'

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
        echo "TurboBoost: [${GREEN}disbled${NC}]"
    fi
    echo
}

LOAD()
{    
    # Disables Turbo Boost
    # loads the pre-signed kext from Turbo Boost Switcher
    echo "[${GREEN}!${NC}]Disabling TurboBoost now...${NC}"
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
