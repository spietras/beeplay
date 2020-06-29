#!/bin/sh

print_usage()
{
    echo
    echo "Correct usage is : $0 sheet"
    echo
    echo "sheet - file with notes"
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

if [ -x "$(command -v play)" ]
then
    makeBeep () 
    {
        for i in $(seq 1 "${4:-1}");
        do
            play -n synth "$(echo "$2/1000" | bc -l)" sine "$1" >/dev/null 2>&1
            sleep "$(echo "$3/1000" | bc -l)"
        done
    }
elif [ -x "$(command -v beep)" ]
then
    makeBeep () 
    {
        beep -f "$1" -l "$2" -D "$3" -r "${4:-1}"
    }
else
    echo "neither play nor beep is installed"
    print_usage
    exit 4
fi

while read -r frequency length delay repeats; do
    makeBeep "$frequency" "$length" "$delay" "$repeats"
done < "$1"