@echo off
:: this file should sync audio and video if you've had trouble with it after using blur

:: set this variable to false if you want to manually find the original file and skip the checks
set automatic=false
:: defines input video
set inputvideo=%~dpn1
:: finds duration of input video
ffprobe -i "%inputvideo%.mp4" -show_entries format=duration -v quiet -of csv="p=0" > %temp%\fileoneduration.txt
::removes " - blur" from the input video's name in an attempt to automatically find the before
if %automatic% == false (
     echo Automatic file finding is disabled. Please drag in the file before it was blurred.
	 goto skipped
)
if %automatic% == true (
     set inputoriginalmaybe=%inputvideo: - blur=%
)
if %automatic% == true (
	 if not exist "%inputoriginalmaybe%.mp4" echo Original file was unable to be found automatically. Maybe you're using detailed filenames?
	 if not exist "%inputoriginalmaybe%.mp4" set automatic=false
	 set inputoriginalmaybe="%inputoriginalmaybe%.mp4"
)
:skipped
if %automatic% == false (
	 echo For reference, the file you're using as the input here is "%inputvideo%.mp4"
	 set /p inputoriginalmaybe=Please drag the original file here: 
)
if "%inputvideo%.mp4" == %inputoriginalmaybe% (
     echo Original file was unable to be found automatically.
	 echo The input file may not have been the output video from blur.
	 set automatic=false
	 goto skipped
)
:: finds duration of original video
ffprobe -i %inputoriginalmaybe% -show_entries format=duration -v quiet -of csv="p=0" > %temp%\filetwoduration.txt
:: sets them to variables
set /p fod=<%temp%\fileoneduration.txt
set /p ftd=<%temp%\filetwoduration.txt
:: sets the speed to the original video duration divided by the input video duration
:: this accounts for whatever weird speed stuff that blur does with videos
set speed=%ftd%/%fod%
:: speeds up the video to match the audio
:: feel free to change the video settings between "-c:a copy" and "-vf" to match what you usually do
ffmpeg -i "%inputvideo%.mp4" -i %inputoriginalmaybe% -map 0:v:0 -map 1:a:0 -shortest -c:a copy -c:v h264_nvenc -rc vbr -preset p7 -b:v 250M -cq 18 -vf "setpts=(%speed%)*PTS" "%~dpn1 (synced audio).mp4"
:: deletes temp files
if exist "%temp%\fileoneduration.txt" (del "%temp%\fileoneduration.txt")
if exist "%temp%\filetwoduration.txt" (del "%temp%\filetwoduration.txt")
:: self explanatory
exit