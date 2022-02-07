# beeplay

turn your crappy PC into a music player 🎶

# Features

- Unix only
- POSIX-compliant
- pure shell scripts
- highly extensible
- supports tty and MIDI as input

# `keyplay`

You can play notes with your keyboard using `keyplay`:

```sh
./keyplay
```

Keyboard layout is similar to [the one used in FL Studio](https://www.image-line.com/fl-studio-learning/fl-studio-online-manual/html/img_glob/qwerty_keyboard.png).
By default [the `play` command from `sox`](http://sox.sourceforge.net/) is used to play notes.
See `./keyplay --help` for more info.

# `midiplay`

You can play notes from MIDI files:

```sh
./midiplay -f file.mid
```

And also from MIDI devices (like USB Keyboard on port 1):

```sh
./midiplay -p 1
```

Only one track and one channel can be played, by default it's track 0 and channel 1.
Also by default [the `play` command from `sox`](http://sox.sourceforge.net/) is used to play notes.
See `./midiplay --help` for more info.

# Usage as library

Just copy `beeplaylib.sh` to your project, source it and use the `beeplay` function to play music.

`beeplay` reads commands from stdin and starts or stops notes. Available commands are:

- `s FREQUENCY` - starts playing a note at given frequency (if the note is not playing already)
- `e FREQUENCY` - stops playing the note associated with given frequency (if the note is playing)

You can play multiple different notes at the same time, but you can't play multiple notes of the same frequency.

Because of variety of sound configurations, by default it uses the terminal bell to play notes.
However, you can pass your own note-playing function that takes note frequency in `Hz`.
Your function will be repeatedly called, unless something blocks inside it.
Some functions are provided by the library.

You should pipe event stream to `beeplay`.
For this purpose, you can use bundled emitter functions, which emit events to stdout.
For example `emit_midifile` emits events from a MIDI file.

Example with default terminal bell:

```sh
. beeplaylib.sh

emit_midifile < file.mid | beeplay
```

Example with custom function:

```sh
. beeplaylib.sh

note_beep()
{
    beep -f "$1" -l 999999
}

emit_midifile < file.mid | beeplay note_beep
```
