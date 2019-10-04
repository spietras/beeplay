#!/bin/bash

# requires play command from sox package: http://sox.sourceforge.net/ 

makeBeep () {
  for i in $(seq 1 $4);
  do
    play -n synth `bc -l <<< "$2/1000"` sine $1 &> /dev/null
    sleep `bc -l <<< "$2/1000"`
  done
}

makeBeep        440        40        80         4
makeBeep        440        80        160
makeBeep        440        40        80         5
makeBeep        440        80        160
makeBeep        587.33     40        80         6
makeBeep        587.33     80        160
makeBeep        523.25     40        80
makeBeep        587.33     40        80         5
makeBeep        523.25     80        160
makeBeep        392        80        160
makeBeep        440        40        80         4
makeBeep        440        80        160
makeBeep        440        40        80         5
makeBeep        440        80        160
makeBeep        587.33     40        80
makeBeep        440        40        80         5
makeBeep        440        80        160
makeBeep        440        40        80         5
makeBeep        440        80        160
makeBeep        587.33     40        80         2
makeBeep        440        40        80         2
makeBeep        440        80        160        2
makeBeep        440        40        80         4
makeBeep        440        80        160
makeBeep        523.25     160       320
makeBeep        440        40        80         2
makeBeep        440        80        160        2
makeBeep        440        40        80         4
makeBeep        440        80        160
makeBeep        523.25     80        160        2
makeBeep        440        40        80         2
makeBeep        440        80        160        2
makeBeep        440        40        80         4
makeBeep        440        80        160        2
makeBeep        587.33     40        8          4
makeBeep        587.33     80        160        2
makeBeep        523.25     40        80         4
makeBeep        523.25     80        160        2
makeBeep        392        80        160
makeBeep        440        40        80         2
makeBeep        440        80        160        2
makeBeep        440        40        80         4
makeBeep        440        80        160
makeBeep        523.25     80        160        2
makeBeep        440        40        80         2
makeBeep        440        80        160        2
makeBeep        440        40        80         4
makeBeep        440        80        160
makeBeep        523.25     80        160        2
makeBeep        440        40        80         2
makeBeep        440        80        160
makeBeep        523.25     80        160        2
makeBeep        440        40        80         2
makeBeep        440        80        160
makeBeep        523.25     80        160        2
makeBeep        440        40        80         2
makeBeep        440        80        160
makeBeep        523.25     80        160        2
makeBeep        440        40        80         2
makeBeep        440        80        160
makeBeep        523.25     80        160        2
makeBeep        440        40        80         2
makeBeep        523.25     80        160
makeBeep        440        40        80         2
makeBeep        523.25     80        160
makeBeep        440        40        80         2
makeBeep        523.25     80        160
makeBeep        440        40        80         2
makeBeep        523.25     80        160
makeBeep        440        40        80         2
makeBeep        523.25     80        160
makeBeep        440        40        80         2
makeBeep        523.25     80        160
makeBeep        440        40        80         2
makeBeep        523.25     80        160
makeBeep        440        40        80         2
makeBeep        523.25     80        160
makeBeep        587.33     640       10         4