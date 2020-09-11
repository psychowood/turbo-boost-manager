#!/usr/bin/env sh
# Re-enables turbo boost by disabling the kext that enabled it

RED='\033[91m'
GREEN='\033[92m'
CYAN='\033[96m'
NC='\033[0m'

echo "Checking status of Turbo Boost..."
result=`kextstat | grep -c com.rugarciap.DisableTurboBoost`
if [ $result -gt 0 ]
then 
    
    echo "TurboBoost is currently [${RED}enabled${NC}]"
    echo
    echo "[${RED}!${NC}]Unloading kext now...${NC}"
    sudo /sbin/kextunload -q '/Applications/Turbo Boost Switcher.app/Contents/Resources/DisableTurboBoost.64bits.kext'
    echo "Kext ${GREEN}unloaded${NC}. Turbo Boost status: ${RED}enabled${NC}"
    exit 0
fi

echo "[${RED}Kext is not loaded${NC}]"
echo "Turbo Boost status: ${RED}enabled${NC}"
exit 0

