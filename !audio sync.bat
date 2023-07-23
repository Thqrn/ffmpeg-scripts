:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

:: this file should sync audio and video if you've had trouble with it after using blur
:: to change the suffix, see lines 27 and 29

@echo off
SET mypath=%~dp0
for %%a in (%*) do (
    call :audiofix %%a
)
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit

:audiofix
:: this file should sync audio and video if you've had trouble with it after using blur

:: set this variable to false if you want to manually find the original file and skip the checks
set automatic=true

echo [N]VENC
echo [C]PU
echo [A]MF
echo [Q]uicksync
choice /c NCAQ /n /m "Select an encoder: "
set ch=%errorlevel%
if %ch% == 1 set encodingargs=-c:v h264_nvenc -preset p7 -rc vbr -b:v 250M -cq 14
if %ch% == 2 set encodingargs=-c:v libx264 -preset slow -crf 17 -aq-mode 3
if %ch% == 3 set encodingargs=-c:v h264_amf -quality quality -qp_i 16 -qp_p 18 -qp_b 22
if %ch% == 4 set encodingargs=-c:v h264_qsv -preset veryslow -global_quality:v 15

:: defines input video
set "inputvideo=%~dpn1"
:: finds duration of input video
ffprobe -i "%inputvideo%.mp4" -show_entries format=duration -v quiet -of csv="p=0" > %temp%\fileoneduration.txt
::removes " - blur" from the input video's name in an attempt to automatically find the before
if %automatic% == false (
    echo Automatic file finding is disabled.
    goto skipped
)
:: CHANGE THE " - blur" TO WHATEVER YOUR SUFFIX IS
if %automatic% == true (
    set "inputoriginalmaybe=%inputvideo: - blur=%"
)
if %automatic% == true (
    if exist "%inputoriginalmaybe%.mp4" set inputoriginalmaybe="%inputoriginalmaybe%.mp4"
    if exist "%inputoriginalmaybe%.mp4" goto actualstuff
)
if %automatic% == true (
    if exist "%inputoriginalmaybe%).mp4" set inputoriginalmaybe="%inputoriginalmaybe%).mp4"
    if exist "%inputoriginalmaybe%).mp4" goto skipped
)
:skipped
if %automatic% == false (
    echo For reference, the file you're using as the input here is "%inputvideo%.mp4"
    set /p inputoriginalmaybe=Please drag in the pre-blur file here: 
    goto actualstuff
)
:actualstuff
if "%inputvideo%.mp4" == %inputoriginalmaybe% (
    echo Original file was unable to be found automatically. The input file may not have been the post-blur video.
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
ffmpeg -hide_banner -loglevel error -stats -i "%inputvideo%.mp4" -i %inputoriginalmaybe% -map 0:v:0 -map 1:a:0 -shortest -c:a copy %encodingargs% -vf "setpts=(%speed%)*PTS" "%~dpn1 (synced audio).mp4"
:: deletes temp files
if exist "%temp%\fileoneduration.txt" (del "%temp%\fileoneduration.txt")
if exist "%temp%\filetwoduration.txt" (del "%temp%\filetwoduration.txt")
goto :eof