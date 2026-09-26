(*
1. Save as an Application: Script Editor > File > Export… > File Format: Application
2. Check "Stay open after run handler"
3. Run the app or add it to your login items: System Preferences > Users & Groups > User > Login Items > Press the "+" button

# http://apple.stackexchange.com/questions/269174/disable-the-sleep-function-of-the-macbook-touch-bar
*)

on idle
    tell application "System Events" to keystroke (key code 63) -- press fn key
    delay 60
end idle
