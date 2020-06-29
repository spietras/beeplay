#!/bin/bash

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

if ! [ -x "$(command -v beep)" ]
then
    echo "beep is not installed"
    print_usage
    exit 4
fi

makeBeep () {
  beep -f "$1" -l "$2" -D "$3" -r "${4:-1}"
}

while read -r frequency length delay repeats; do
  makeBeep "$frequency" "$length" "$delay" "$repeats"
done < "$1"