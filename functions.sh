#!/usr/bin/env sh
# Contains function definitions for Turbo Boost Manager
# inherits variables $DIR and $KEXT_FILE

RED='\033[91m'
GREEN='\033[92m'
NC='\033[0m'

FIND_KEXT()
{
    # looks for the pre-signed kext from Turbo Boost Switcher in relevant locations
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

GET_FILES()
{
    # download the official Turbo_Boost_Switcher_v2.10.2.dmg binary package 
    # mount (attach) the dmg
    # extract the kext files locally in 'tbswitcher_resources' 
    # unmount (detach) the dmg
    # remove the dmg file   

    logfile=$1
    DMG_URL=https://turbo-boost-switcher.s3.amazonaws.com/Turbo_Boost_Switcher_v2.10.2.dmg
    DMG_FILE="$DIR/Turbo_Boost_Switcher_v2.10.2.dmg"
    DMG_DIR="$DMG_FILE.TMP"
    
    curl -v "$DMG_URL" -o "$DMG_FILE" > "$logfile" 2>&1 
    if [ $? -ne 0 ]; then
        echo "Couldn't curl -s $DMG_URL -o $DMG_FILE" >> "$logfile"
        return -1
    fi
    
    hdiutil attach "$DMG_FILE" -readonly -nobrowse -noautoopen -noautoopenro -noautoopenrw -mountpoint "$DMG_DIR" >> "$logfile" 2>&1
    if [ $? -ne 0 ]; then
        echo "Couldn't hdiutil attach $DMG_FILE -readonly -noautoopen -noautoopenro -noautoopenrw -mountpoint $DMG_DIR" >> "$logfile"
        return -1
    fi

    mkdir -p "$DIR/tbswitcher_resources" >> "$logfile" 2>&1
    (cd "$DMG_DIR/tbswitcher_resources" && tar cf - --gid 0 --uid 0 -C "$DMG_DIR/tbswitcher_resources" . ) | (cd "$DIR/tbswitcher_resources" && tar xf - ) >> "$logfile" 2>&1
    if [ $? -ne 0 ]; then
        echo "Couldn't (cd $DMG_DIR/tbswitcher_resources && tar cf - --gid 0 --uid 0 -C $DMG_DIR/tbswitcher_resources . ) | (cd $DIR/tbswitcher_resources && tar xf - )" >> "$logfile"
        return -1
    fi

    hdiutil detach "$DMG_DIR" >> "$logfile" 2>&1
    if [ $? -ne 0 ]; then
        echo "Couldn't hdiutil detach $DMG_DIR" >> "$logfile"
        return -1
    fi

    rm "$DMG_FILE" >> "$logfile" 2>&1
    if [ $? -ne 0 ]; then
        echo "Couldn't rm $DMG_FILE, ignoring the error since everything else should be OK." >> "$logfile"    
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


FIND_SLEEPWATCHER()
{
    SW_TEST=$(sleepwatcher -v 2>/dev/null)
    if [ $? -eq 2 ]; then #sleepwatcher -v exits with a value of 2: https://github.com/fishman/sleepwatcher/blob/media_keys/sources/sleepwatcher.m#L246
        echo 'sleepwatcher'
    else
        BREW_PREFIX=$(brew --prefix 2>/dev/null)
        if [ $? -ne 0 ]; then
            return -1
        fi
        
        SW_FILE="$BREW_PREFIX/Cellar/sleepwatcher/*/sbin/sleepwatcher"
        SW_TEST=$($SW_FILE -v 2>/dev/null)
        if [ $? -eq 2 ]; then #again, se above
            echo "$SW_FILE"
        else
            return -2
        fi
    fi
}