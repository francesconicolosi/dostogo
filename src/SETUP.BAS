1 CLS
PRINT " /$$$$$$$                   /$$$$$$$$         /$$$$$$           "
PRINT "| $$  \ $$  /$$$$$$   /$$$$$$$| $$  /$$$$$$ | $$  \__/  /$$$$$$ "
PRINT "| $$  | $$ /$$__  $$ /$$_____/| $$ /$$__  $$| $$ /$$$$ /$$__  $$"
PRINT "| $$  | $$| $$  \ $$|  $$$$$$ | $$| $$  \ $$| $$|_  $$| $$  \ $$"
PRINT "| $$  | $$| $$  | $$ \____  $$| $$| $$  | $$| $$  \ $$| $$  | $$"
PRINT "| $$$$$$$/|  $$$$$$/ /$$$$$$$/| $$|  $$$$$$/|  $$$$$$/|  $$$$$$/"
PRINT "|_______/  \______/ |_______/ |__/ \______/  \______/  \______/0.1 (C)Nycosoft"

PRINT ""
PRINT "This program will install Nycosoft DosToGo on your computer"
PRINT ""
INSTALLPATH$ = "C:\DOSTOGO"
PRINT "Current path: "; INSTALLPATH$
INPUT "ENTER to confirm the path or insert new one without '\' in the end"; PATHPARAM$
IF PATHPARAM$ <> "" THEN INSTALLPATH$ = PATHPARAM$
PRINT "Installing in " + INSTALLPATH$
INPUT "This will update also your autoexec.bat . Confirm (Y/N)"; ANSWER$
IF ANSWER$ = "y" OR ANSWER$ = "Y" THEN
    SHELL "copy GO.BAT " + INSTALLPATH$
    SHELL "copy LASTRUN.BAT " + INSTALLPATH$
    SHELL "copy LIST.TXT " + INSTALLPATH$
    SHELL "copy MENU.EXE " + INSTALLPATH$
    SHELL "copy current.inf " + INSTALLPATH$
    PRINT "done"
    PRINT "updating autoexec.bat"
    OPEN "C:\AUTOEXEC.BAT" FOR APPEND AS #1
    WRITE #1, "SET DOSTOGO=" + INSTALLPATH$
    WRITE #1, "SET PATH=%PATH%;%DOSTOGO%"
    CLOSE #1
    PRINT "setting up your running environment"
    SHELL "SET DOSTOGO=" + INSTALLPATH$
    SHELL "SET PATH=%PATH%;%DOSTOGO%"
    PRINT "done"
    PRINT ""
    PRINT "type 'go' to choose your destiny!"
END IF
END

