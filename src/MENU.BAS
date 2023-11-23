SELECTEDENTRY = 0
CURRENTPAGE = 0
TOTALPAGES = 0
PAGESIZE = 10
SIDE$ = "L"
1 CLS
PRINT " /$$$$$$$                   /$$$$$$$$         /$$$$$$           "
PRINT "| $$  \ $$  /$$$$$$   /$$$$$$$| $$  /$$$$$$ | $$  \__/  /$$$$$$ "
PRINT "| $$  | $$ /$$__  $$ /$$_____/| $$ /$$__  $$| $$ /$$$$ /$$__  $$"
PRINT "| $$  | $$| $$  \ $$|  $$$$$$ | $$| $$  \ $$| $$|_  $$| $$  \ $$"
PRINT "| $$  | $$| $$  | $$ \____  $$| $$| $$  | $$| $$  \ $$| $$  | $$"
PRINT "| $$$$$$$/|  $$$$$$/ /$$$$$$$/| $$|  $$$$$$/|  $$$$$$/|  $$$$$$/"
PRINT "|_______/  \______/ |_______/ |__/ \______/  \______/  \______/0.1 (C)Nycosoft"

PRINT ""

OPEN ENVIRON$("DOSTOGO") + "\LIST.TXT" FOR INPUT AS #1
I = 0

SELECTEDPATH$ = ""
SELECTEDNAME$ = ""
FILENAME$ = ""
WHILE NOT EOF(1)
	INPUT #1, NAME$, PATH$, FILE$
	IF I > (CURRENTPAGE * PAGESIZE) - 1 AND I < (CURRENTPAGE * PAGESIZE) + PAGESIZE THEN
		IF SELECTEDENTRY = I THEN
			IF SIDE$ = "L" THEN PRINT "� Run � Browse", "["; NAME$; "]"
			IF SIDE$ = "R" THEN PRINT "� Run � Browse", "["; NAME$; "]"
			SELECTEDPATH$ = PATH$
			FILENAME$ = FILE$
			SELECTEDNAME$ = NAME$
		END IF
		IF SELECTEDENTRY <> I THEN PRINT "  Run   Browse", " "; NAME$; " "
	END IF

	IF I MOD PAGESIZE = 0 THEN TOTALPAGES = I / PAGESIZE

	I = I + 1
	
WEND
CLOSE #1
IF CURRENTPAGE = TOTALPAGES THEN
	FOR T = 0 TO ((CURRENTPAGE + 1) * PAGESIZE - 1 - I)
		PRINT ""
	NEXT T
END IF
PRINT ""


PRINT (CURRENTPAGE + 1); "/"; TOTALPAGES + 1
PRINT "(Q)uit, (P)age change, (E)xecute, (A)dd line, (R)emove line"
DO
	WHILE k$ = ""
	k$ = INKEY$
WEND


SELECT CASE k$
	CASE "a"
		SHELL "CD > " + ENVIRON$("DOSTOGO") + "\current.inf"
		OPEN ENVIRON$("DOSTOGO") + "\current.inf" FOR INPUT AS #3
		IF LOF(3) THEN LINE INPUT #3, NEWPATH$
		CLOSE #3
		PRINT NEWPATH$
		INPUT "ENTER to confirm the path or insert new one"; PATHPARAM$
		IF PATHPARAM$ <> "" THEN NEWPATH$ = PATHPARAM$
		INPUT "Insert the name of the game"; NEWNAME$
		INPUT "Insert the executable filename"; NEWFILENAME$
		OPEN ENVIRON$("DOSTOGO") + "\LIST.TXT" FOR APPEND AS #4
		NEWLINE$ = NEWNAME$ + CHR$(34) + "," + CHR$(34) + NEWPATH$ + CHR$(34) + "," + CHR$(34) + NEWFILENAME$
		WRITE #4, NEWLINE$
		CLOSE #4

	CASE "q"
		OPEN ENVIRON$("DOSTOGO") + "\LASTRUN.BAT" FOR OUTPUT AS #1
		PRINT #1, "@echo off"
		PRINT #1, "cls"
		PRINT #1, "echo Thanks for using Nycosoft DosToGo"
		END
	CASE "p"
		IF CURRENTPAGE = TOTALPAGES THEN
			CURRENTPAGE = 0
			SELECTEDENTRY = 0
		ELSE
			CURRENTPAGE = CURRENTPAGE + 1
			SELECTEDENTRY = CURRENTPAGE * PAGESIZE + PAGESIZE
		END IF
	CASE "r"
		PRINT "Removing " + SELECTEDNAME$
		INPUT "Confirm (Y/N)"; ANSWER$
		IF ANSWER$ = "y" OR ANSWER$ = "Y" THEN
		CLS
		SHELL "COPY " + ENVIRON$("DOSTOGO") + "\LIST.TXT " + ENVIRON$("DOSTOGO") + "\LIST.BAK "
		OPEN ENVIRON$("DOSTOGO") + "\LIST.BAK" FOR INPUT AS #5
		OPEN ENVIRON$("DOSTOGO") + "\LIST.TXT" FOR OUTPUT AS #6
		REMOVINGINDEX = 0
		WHILE NOT EOF(5)
			INPUT #5, OLDNAME$, OLDPATH$, OLDFILENAME$
			NEWLINE$ = CHR$(34) + OLDNAME$ + CHR$(34) + "," + CHR$(34) + OLDPATH$ + CHR$(34) + "," + CHR$(34) + OLDFILENAME$ + CHR$(34)
			IF REMOVINGINDEX <> SELECTEDENTRY THEN PRINT #6, NEWLINE$ ELSE PRINT "Removing line ", SELECTEDENTRY
			REMOVINGINDEX = REMOVINGINDEX + 1
		WEND
		CLOSE #5
		CLOSE #6
		SHELL "DEL " + ENVIRON$("DOSTOGO") + "\LIST.BAK "
		SELECTEDENTRY = 0
		END IF
	CASE "e"
		CLS
		OPEN ENVIRON$("DOSTOGO") + "\LASTRUN.BAT" FOR OUTPUT AS #1
		PRINT #1, "@echo off"
		PRINT #1, "cd\"
		PRINT #1, "cd "; SELECTEDPATH$
		IF SIDE$ = "L" THEN
			PRINT #1, FILENAME$
		END IF
		PRINT #1, "cls"
		PRINT #1, "echo Thanks for using Nycosoft DosToGo"
		END
	CASE CHR$(0) + CHR$(72)
		IF SELECTEDENTRY > (CURRENTPAGE * PAGESIZE) - 1 AND SELECTEDENTRY < (CURRENTPAGE * PAGESIZE) + PAGESIZE AND CURRENTPAGE > 0
			THEN SELECTEDENTRY = SELECTEDENTRY - 1
			ELSE CURRENTPAGE = CURRENTPAGE - 1
			END IF
		IF SELECTEDENTRY < PAGESIZE THEN CURRENTPAGE = CURRENTPAGE - 1
	CASE CHR$(0) + CHR$(80)
		IF SELECTEDENTRY > (CURRENTPAGE * PAGESIZE) - 1 AND SELECTEDENTRY < (CURRENTPAGE * PAGESIZE) + PAGESIZE AND CURRENTPAGE <= TOTALPAGES
			THEN SELECTEDENTRY = SELECTEDENTRY - 1
			ELSE CURRENTPAGE = CURRENTPAGE + 1
			END IF
	CASE CHR$(0) + CHR$(75)
		IF SIDE$ = "R" THEN SIDE$ = "L" ELSE SIDE$ = "R"
	CASE CHR$(0) + CHR$(77)
		IF SIDE$ = "L" THEN SIDE$ = "R" ELSE SIDE$ = "L"
	
	
END SELECT
k$ = ""
GOTO 1
LOOP

