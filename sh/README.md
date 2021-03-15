# Usage as library

Just copy ```beeplaylib.sh``` to your project, source it and use the ```beeplay``` function to play music.

```beeplay``` reads commands from stdin and starts or stops notes. Available commands are:
- ```start FREQUENCY``` - starts playing a note at given frequency (if the note is not playing already)
- ```stop FREQUENCY``` - stops playing the note associated with given frequency (if the note is playing)

You can play multiple different notes at the same time, but you can't play multiple notes of the same frequency.

Because of variety of sound configurations, by default it uses the terminal bell to play notes. However, you can pass your own note-playing function that takes note frequency in ```Hz```. Your function will be repeatedly called, unless something blocks inside it. Some functions are provided by the library.

You should pipe event stream to ```beeplay```. For this purpose, you can use supplied emitter functions, which emit events to stdout. For example ```emit_sheet``` emits events from a sheet file.

Example with default terminal bell:
```sh
. beeplaylib.sh

emit_sheet < sheet.txt | beeplay
```

Example with custom function:
```sh
. beeplaylib.sh

note_beep()
{
    beep -f "$1" -l 999999
}

emit_sheet < sheet.txt | beeplay note_beep
```

Also see ```beeplay.sh``` for an example of usage in a more practical setting.

# Testing

You can test your sheet files with ```beeplay.sh``` that uses [```play``` command from ```sox```](http://sox.sourceforge.net/) to play notes:

```sh
./beeplay.sh [-d] [SHEET]
```

- ```-d, --default``` - use the default terminal bell instead of ```play```
- ```SHEET``` - path to the sheet file (when ```SHEET``` is not given or ```-``` is passed, read standard input)
