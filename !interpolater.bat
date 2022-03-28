@echo off
:: made by Frost#5872
set inputvideo=%*
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -i %inputvideo% -of csv=p=0 > %temp%\fps.txt
set /p fpsvalue=<%temp%\fps.txt
set /a fpsvalue=%fpsvalue%
set /p desired=What fps do you want to interpolate from? The lower this value is, the worse the output looks: 
if %fpsvalue% gtr %desired% (
     echo Input video is above that number, changing it now...
     ffmpeg -hide_banner -loglevel error -stats -i %inputvideo% -vf fps=%desired% "%~dpn1 %desired% fps.mp4"
)
if %fpsvalue% gtr %desired% (
     set inputvideo="%~dpn1 %desired% fps.mp4"
)
set /p intnum=What do you want to interpolate to: 
ffmpeg -hide_banner -loglevel error -stats  -i %inputvideo% -vf "minterpolate=fps=%intnum%" "%~dpn1 %desired% to %intnum%.mp4"
if exist "%~dpn1 %desired% fps.mp4" (del "%~dpn1 %desired% fps.mp4")
if exist "%temp%\fps.txt" (del "%temp%\fps.txt")
echo Done!
pause
exit