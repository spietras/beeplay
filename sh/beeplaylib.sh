#!/bin/sh

_beeplay_mili_to_seconds()
{
    # Convert miliseconds to seconds
    # $1    - time value in miliseconds
    # Returns time value in seconds

    echo "$1/1000" | bc -sl
}

beeplay_bell()
{
    # Play single note using terminal bell
    # $1    - frequency in Hz (ignored)
    # $2    - length in ms

    LENGTH="$2"

    printf '\a'
    sleep "$(_beeplay_mili_to_seconds "$LENGTH")"  # Simulate sound duration by just waiting
}

beeplay()
{
    # Play music from a sheet file
    # $1    - function that plays a single note, given frequency and length (optional, defaults to terminal bell)

    PLAY_NOTE="${1:-beeplay_bell}"
    IFS_VAL=' \t\n'

    while IFS="$IFS_VAL" read -r FREQUENCY LENGTH DELAY REPEATS; do
        # make beep in background and wait
        # background ignores signals (so sound will not be interrupted)
        # but main shell exits immediately
        (
            trap '' 1 2 3 6 15
            I=1
            END="${REPEATS:-1}"
            while [ $I -le "$END" ]; do
                $PLAY_NOTE "$FREQUENCY" "$LENGTH" && sleep "$(_beeplay_mili_to_seconds "$DELAY")"
                I=$((I+1))
            done
        ) & wait
    done
}