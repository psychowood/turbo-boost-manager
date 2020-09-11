#!/usr/bin/env sh
# disables turbo boost by enabling a pre-signed kext
# (taken from the core of TurboBoost Switcher, but avoids their crappy interface)

RED='\033[91m'
GREEN='\033[92m'
CYAN='\033[96m'
NC='\033[0m'

echo "Checking status of Turbo Boost..."
results=`kextstat | grep -c com.rugarciap.DisableTurboBoost`
if [ $results -gt 0 ]
then
    echo "${CYAN}Kext 'com.rugarciap.DisableTurboBoost' is already loaded.${NC}"
    echo "Turbo Boost status: ${GREEN}disabled${NC}"
    exit 0
fi

echo "Turbo Boost status: ${RED}enabled${NC}"
echo
echo "[${RED}!${NC}]Disabling TurboBoost now...${NC}"
sudo /usr/bin/kextutil -q '/Applications/Turbo Boost Switcher.app/Contents/Resources/DisableTurboBoost.64bits.kext'
echo "Kext ${GREEN}loaded${NC}.Turbo Boost status: ${GREEN}disabled.${NC}"
exit 0