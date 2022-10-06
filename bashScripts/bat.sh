#!/bin/bash
#title          :bat
#description    :display battery status
#author         :Geoff Buchanan
#create date    :20220708
#update date    :20220713
#bash version   :
#notes          :reads values from /sys/class/power_supply/BAT* and displays
#changelog      :

# --- HELP/VERSION --------------------------

display_help() {
echo "Display battery status in terminal.

Usage: $(basename $0) [OPTION...] [-f/--format \"FORMAT\"]

Mandatory arguments to long options are mandatory for short options too.

  -b, --battery BAT     battery device as listed in /sys/class/power_supply, e.g. BAT0
  -c, --color n         1 (enable color) or 0 (disable color)
  -f, --format \"OUTPUT FORMAT\"
                        output format, including any combination of the following keys:
                            {DEV}       battery device
                            {CHG%}      charge percentage (without %)
                            {STAT}      charging status, e.g. Full, Charging, Discharging
                            {CAP%}      battery capacity percentage (without %)
                        default format: \"{DEV} Charge: {CHG%}% ({STAT}) Cap: {CAP%}%\"
      --help            display this help, and exit
      --version         display version information, and exit

If output is piped, defaults to no color.

Exit codes: 0=success, 1=unknown argument"
}

display_version() {
echo "$(basename $0) 1.0 (2022/07/13)

This is free software.  You may modify and redistribute freely,
provided the original author's name is retained.

There is NO WARRANTY, to the extent permitted by law.

Written by Geoff Buchanan"
}

case $1 in
    --help)         display_help; exit 0;;
    --version)      display_version; exit 0;;
esac


# --- OPTIONS/ARGS --------------------------

# make options case-insensitive
shopt -s nocasematch

# defaults
if [ -t 1 ]; then ENABLE_COLOR=1; else ENABLE_COLOR=0; fi
OUTPUT_FORMAT="{DEV} Charge: {CHG%}% ({STAT}) Cap: {CAP%}%"
BAT_SPECIFIED=""

# command arguments
while [ ! -z "$1" ]; do
    case "$1" in
        -b | --battery)         BAT_SPECIFIED="$2"; shift;;
        -c | --color)           ENABLE_COLOR="$2"; shift;;
        -f | --format)          OUTPUT_FORMAT="$2"; shift;;
        *)                      echo "$1: unrecognized argument"; exit 1;;
    esac
    shift
done

# --- MAIN ------------------------------

display_output() {
    # current charge percent
    CHARGE_PERCENT="?"
    if [ -e $BAT_PATH/capacity ]; then CHARGE_PERCENT=$(cat $BAT_PATH/capacity); fi

    # charging status
    CHARGING_STATUS="?"
    if [ -e $BAT_PATH/status ]; then CHARGING_STATUS=$(cat $BAT_PATH/status); fi

    # capacity
    if [ -e $BAT_PATH/charge_full ]; then
        CAPACITY_FULL_DESIGN=$(cat $BAT_PATH/charge_full_design)
        CAPACITY_FULL=$(cat $BAT_PATH/charge_full)
    elif [ -e $BAT_PATH/energy_full ]; then
        CAPACITY_FULL_DESIGN=$(cat $BAT_PATH/energy_full_design)
        CAPACITY_FULL=$(cat $BAT_PATH/energy_full)
    else
        CAPACITY_FULL_DESIGN=""
        CAPACITY_FULL=""
    fi
#    if [ -n $CAPACITY_FULL -a -n $CAPACITY_FULL_DESIGN ]; then
    if [[ $CAPACITY_FULL =~ ^[0-9]+$ && $CAPACITY_FULL_DESIGN =~ ^[0-9]+$ ]]; then
        CAPACITY_PERCENT=$(echo "scale=2; $CAPACITY_FULL/$CAPACITY_FULL_DESIGN*100" | bc | cut -d'.' -f1)
    else
        CAPACITY_PERCENT="?"
    fi

    # colorize
    if [ $ENABLE_COLOR -eq 1 ]; then
        # color definitions
        FULL_COLOR="\e[1;37m" # light white
        NORMAL_COLOR="\e[1;32m" # light green
        LOW_COLOR="\e[1;33m" # yellow
        CRIT_COLOR="\e[1;31;5m" # light red blinking
        CHARGED_COLOR="\e[1;37m" # light white
        CHARGING_COLOR="\e[1;32m" # light green
        DISCHARGING_COLOR="\e[1;31m" # light red
        RESET_COLOR="\e[0m" # reset
    else
        FULL_COLOR=""
        NORMAL_COLOR=""
        LOW_COLOR=""
        CRIT_COLOR=""
        CHARGED_COLOR=""
        CHARGING_COLOR=""
        DISCHARGING_COLOR=""
        RESET_COLOR=""
    fi

    # battery charge
    if [[ $CHARGE_PERCENT =~ ^[0-9]+$ ]]; then
        if [ $CHARGE_PERCENT -eq 100 ]; then CHARGE_PERCENT_COLOR=$FULL_COLOR
        elif [ $CHARGE_PERCENT -gt 30 ]; then CHARGE_PERCENT_COLOR=$NORMAL_COLOR
        elif [ $CHARGE_PERCENT -gt 10 ]; then CHARGE_PERCENT_COLOR=$LOW_COLOR
        else CHARGE_PERCENT_COLOR=$CRIT_COLOR
        fi
        CHARGE_PERCENT=$CHARGE_PERCENT_COLOR$CHARGE_PERCENT$RESET_COLOR
    fi

    # charging status
    if [ $CHARGING_STATUS = "Full" ]; then CHARGING_STATUS_COLOR=$CHARGED_COLOR
    elif [ $CHARGING_STATUS = "Charging" ]; then CHARGING_STATUS_COLOR=$CHARGING_COLOR
    elif [ $CHARGING_STATUS = "Discharging" ]; then CHARGING_STATUS_COLOR=$DISCHARGING_COLOR
    fi
    CHARGING_STATUS=$CHARGING_STATUS_COLOR$CHARGING_STATUS$RESET_COLOR

    # capacity/health
    if [[ $CAPACITY_PERCENT =~ ^[0-9]+$ ]]; then
        if [ $CAPACITY_PERCENT -eq 100 ]; then CAPACITY_PERCENT_COLOR=$FULL_COLOR
        elif [ $CAPACITY_PERCENT -gt 70 ]; then CAPACITY_PERCENT_COLOR=$NORMAL_COLOR
        elif [ $CAPACITY_PERCENT -gt 50 ]; then CAPACITY_PERCENT_COLOR=$LOW_COLOR
        else CAPACITY_PERCENT_COLOR=$CRIT_COLOR
        fi
        CAPACITY_PERCENT=$CAPACITY_PERCENT_COLOR$CAPACITY_PERCENT$RESET_COLOR
    fi

    # output
    OUT="$OUTPUT_FORMAT"
    OUT="$(echo -en $OUT | sed s/{DEV}/$(basename $BAT_PATH)/g)"
    OUT="$(echo -en $OUT | sed s/{CHG%}/$CHARGE_PERCENT/g)"
    OUT="$(echo -en $OUT | sed s/{STAT}/$CHARGING_STATUS/g)"
    OUT="$(echo -en $OUT | sed s/{CAP%}/$CAPACITY_PERCENT/g)"
    OUT="$(echo -en $OUT | sed 's/e\[/\\e\[/g')" # escape char gets lost.  need to re-add backslash
    echo -e "$OUT"
}

if [[ -n $BAT_SPECIFIED ]]; then # display output for specified battery
    BAT_PATH="/sys/class/power_supply/$BAT_SPECIFIED"
    display_output
else # iterate through all batteries
    for BAT_PATH in $(find /sys/class/power_supply -name BAT*)
    do
        display_output
    done
fi
