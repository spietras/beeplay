# Usage as library

Just copy ```beeplaylib.sh``` to your project, source it and use the ```beeplay``` function to play music from a sheet file.

You should pipe the sheet file as stdin while invoking ```beeplay```.

Because of variety of sound configurations, by default it uses the terminal bell to play notes. However, you can pass your own note-playing function that takes note frequency in ```Hz``` and duration in ```ms```.

Example with default terminal bell:
```sh
. beeplaylib.sh

beeplay < sheet.txt
```

Example with custom function:
```sh
. beeplaylib.sh

beep_note()
{
    beep -f "$1" -l "$2"
}

beeplay beep_note < sheet.txt
```

Also see ```beeplay.sh``` for an example of usage in a more practical setting.

# Testing

You can test your sheet files with ```beeplay.sh``` that uses ```beep``` command to play notes:

```sh
./play.sh [-d] SHEET
```

- ```-d, --default``` - use the default terminal bell instead of [```beep```](http://www.johnath.com/beep/)
- ```SHEET``` - path to the sheet file