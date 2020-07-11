#!/bin/sh

print_usage()
{
    echo
    echo "Correct usage is : $0 sheet"
    echo
    echo "sheet - file with notes"
}

is_available()
{
    [ -x "$(command -v "$1")" ]
}

round()
{
    echo "$1" | awk '{print int($1+0.5)}'
}

mili_to_seconds()
{
    echo "$1/1000" | bc -sl
}

if [ "$#" -ne 1 ]
then
    echo "Exactly one argument is needed"
    print_usage
    exit 1
fi

if [ ! -f "$1" ]
then
    echo "$1 is not a file"
    print_usage
    exit 2
fi

if [ ! -r "$1" ]
then
    echo "$1 is not readable"
    print_usage
    exit 3
fi

if is_available 'play'
then
    makeBeep () 
    {
        for i in $(seq 1 "${4:-1}");
        do
            play -q -n synth "$(mili_to_seconds "$2")" sine "$1" && sleep "$(mili_to_seconds "$3")"
        done
    }
elif is_available 'pactl'
then
    makeBeep () 
    {
        for i in $(seq 1 "${4:-1}");
        do
            # setsid is here because pactl probably has its own trap logic that doesn't unload the module
            # more here: https://unix.stackexchange.com/a/350056 and https://unix.stackexchange.com/a/461803
            module="$(setsid pactl load-module module-sine frequency="$(round "$1")")" && {
                sleep "$(mili_to_seconds "$2")"
                setsid pactl unload-module "$module"
                sleep "$(mili_to_seconds "$3")"
            }
        done
    }
elif is_available 'speaker-test'
then
    makeBeep () 
    {
        for i in $(seq 1 "${4:-1}");
        do
            # it's hard to make speaker-test work, 
            # setting channels to 32 gave the best results, i don't know why
            # but then i only have sound on the left side
            timeout -s SIGHUP "$(mili_to_seconds "$2")" speaker-test -t sine -f "$1" -c 32 >/dev/null
            sleep "$(mili_to_seconds "$3")"
        done
    }
else
    echo 'No usable command found. Using generic console sound'
    makeBeep () 
    {
        for i in $(seq 1 "${4:-1}");
        do
            printf '\a'  
            sleep "$(mili_to_seconds "$2")"
            sleep "$(mili_to_seconds "$3")"
        done
    }
fi

while read -r frequency length delay repeats; do
    # make beep in background and wait
    # background ignores signals (so sound will not be interrupted)
    # but main shell exits immediately
    (
        trap '' 1 2 3 6 15
        makeBeep "$frequency" "$length" "$delay" "$repeats"
    ) & wait
done < "$1"