#!/bin/bash

# requires beep: http://www.johnath.com/beep/

# Credit : https://github.com/TheKiwi5000/BeepingPenguin/blob/master/sandstorm.sh

makeBeep () {
  beep -f $1 -l $2 -D $3 -r ${4:-1}
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