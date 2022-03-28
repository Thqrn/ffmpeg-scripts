@echo off
color 0f
:: checks if ffmpeg is installed, and if it isn't, it'll send a tutorial to install it. 
where /q ffmpeg
if errorlevel 1 (
     echo You either don't have ffmpeg installed or do not have it in PATH.
	 echo Please install it as it's needed for this program to work.
	 echo Here is a tutorial https://www.youtube.com/watch?v=WwWITnuWQW4
     pause
	 exit
) else (
    goto inputcheck
)
:inputcheck
if %1check == check (
     echo ERROR: no input file
     echo Drag this .bat into the SendTo folder - press Windows + R and type in shell:sendto
     echo After that, right click on your video, drag over to Send To and click on this bat there.
     pause
     exit
)
:startquestion
set /p starttime=Where do you want your clip to start (in seconds): 
:: checks if it's a positive number, if not then goes back to asking for start time
if 1%starttime% NEQ +1%starttime% (
     echo\
     echo Not a valid number, please enter ONLY whole numbers!
	 echo\
	 goto startquestion
)
if "%starttime%" == " " (
     echo\
     echo Not a valid number, please enter ONLY whole numbers!
	 echo\
	 goto startquestion
)
:: asks length of clip
:timequestion
set /p time=How long after the start time do you want it to be: 
:: checks if it's a postive number, if not then goes back to asking how long it should be
if 1%time% NEQ +1%time% (
     echo\
     echo Not a valid number, please enter ONLY whole numbers!
	 echo\
	 goto timequestion
)
if "%time%" == " " (
     echo\
     echo Not a valid number, please enter ONLY whole numbers!
	 echo\
	 goto timequestion
)
:: defines things for music and asks if they want music
:lowqualmusicq
set musicstarttime=0
set musicstartest=0
set lowqualmusicquestion=n
set filefound=y
set lowqualmusicquestion=y
if "%lowqualmusicquestion%" == " " (
     echo\
     echo Not a valid option, please try again!
	 echo\
	 goto lowqualmusicq
)
:addingthemusic
:: asks for a specific file to get music from
if %lowqualmusicquestion% == y (
     set yeahlowqual=y
	 set /p lowqualmusic=Please drag the desired file here, it must be an audio file: 
)
:: sets a variable if it's a valid file
if %lowqualmusicquestion% == y (
     set filefound=n
     if exist %lowqualmusic% set filefound=y
)
:: if its not a valid file it sends the user back to add a valid file
if %filefound% == n (
     echo\
	 echo Invalid file! Please drag an existing file from your computer!
	 echo\
	 goto addingthemusic
)
:musicstartq
:: asks the user when the music should start
if %lowqualmusicquestion% == y (
	 set /p musicstarttime=Enter a specific start time of the music in seconds: 
)
if %lowqualmusicquestion% == y (
	 if "%musicstarttime%" == " " (
         echo\
         echo Not a valid number, please enter ONLY whole numbers!
	     echo\
	     goto musicstartq
     )
)
:: tests if it's a number
if %lowqualmusicquestion% == y (
	 set /a musicstartest=%musicstarttime%
)
:: if its not a number it makes them go back and do it again
if %lowqualmusicquestion% == y (
	 if NOT %musicstarttime% == %musicstartest% (
         echo\
         echo Not a valid number, please enter ONLY whole numbers!
	     echo\
	     goto musicstartq
     )
	 if "%musicstarttime%" == " " (
         echo\
         echo Not a valid number, please enter ONLY whole numbers!
	     echo\
	     goto musicstartq
     )
	 goto filters
)
set yeahlowqual=n
:filters
set filters=-vf "format=yuv420p%videofilters%"
:encoding
echo\
echo Encoding...
echo\
color 06
:optiontwo
ffmpeg -loglevel warning -stats ^
-ss %starttime% -t %time% -i %1 -ss %musicstarttime% -t %time% -i %lowqualmusic% ^
-c:v copy -preset slow ^
-c:a copy ^
-map 0:v:0 -map 1:a:0 -shortest ^
-vsync vfr -movflags +faststart "%~dpn1 (added audio).mp4"
:end
echo\
echo Done!
echo\
color 0A
pause