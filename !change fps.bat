@echo off
:: sets the title of the windoww and sends some ascii word art
title Speed Changer
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
:: checks if someone used the script correctly
if %1check == check (
     echo ERROR: no input file
     echo Drag this .bat into the SendTo folder - press Windows + R and type in shell:sendto
     echo After that, right click on your video, drag over to Send To and click on this bat there.
     pause
     exit
)
if not 1%2 == 1 set starttime=0
if not 1%2 == 1 set time=32727
if not 1%2 == 1 goto fpsquestion
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
:fpsquestion
:: speed
set fpsq=default
if not 1%2 == 1 set fpsq=%2
if not 1%2 == 1 goto skipthispart
set /p fpsq=New FPS: 
:skipthispart
:cont
:filters
:: defines filters
set filters=-vf "fps=%fpsq%"
:encoding
echo\
echo Encoding...
echo\
color 06
:: option one, no extra music
:optionone
ffmpeg -hide_banner -loglevel error -stats ^
-ss %starttime% -t %time% -i %1 ^
%filters% ^
-c:v libx264 ^
-c:a copy ^
-preset medium -vsync vfr -movflags +faststart "%~dpn1 (%fpsq% FPS).mp4"
goto end
:end
echo\
echo Done!
echo\
color 0A