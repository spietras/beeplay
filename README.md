# beep-player

beep music player

listen to music the way your machine hears it

# Usage

- On Linux:
    
    ```
    ./play.sh platform sheet
    ```

    For example: 
    ```
    ./play.sh Linux/sh sheets/darude_sandstorm.txt
    ```

- On Windows:

    TODO

# Supported Platforms:

- Linux:
    - sh :heavy_check_mark:
    - C :heavy_check_mark:
    - Python :grey_question:
    - Java :grey_question:

- Windows:
    - TODO

Legend:
- :heavy_check_mark: - Done
- :white_check_mark: - Working on
- :grey_question: - Don't know if possible yet
- :heavy_multiplication_x: - Not possible

# Goal

Support a lot of platforms and for each be able to use ```beep-player``` as:
- a binary that can be compiled and run using only the platform's tooling (e.g. compile with ```gcc``` and run from terminal)
- a library that can be used in code by the platform's language (e.g. use it natively in your ```C``` application)

# TODO

- reorganize directory structure into libraries and "frontends"
- better Windows support
