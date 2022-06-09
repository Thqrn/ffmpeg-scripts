:: made by Frost#5872
:: https://github.com/Thqrn/ffmpeg-scripts
@echo off
rmdir %temp%\propertiesfinder /s /q > nul 2> nul
mkdir %temp%\propertiesfinder
set newtemp=%temp%\propertiesfinder
for %%a in (%*) do (
   set inputvideo=%%a
   set inputvideo2=%%~na
   call :this
)
rmdir %temp%\propertiesfinder /s /q
if exist "%newtemp%\fileduration.txt" (del "%newtemp%\fileduration.txt")
if exist "%newtemp%\height.txt" (del "%newtemp%\height.txt")
if exist "%newtemp%\width.txt" (del "%newtemp%\width.txt")
if exist "%newtemp%\fps.txt" (del "%newtemp%\fps.txt")
echo.
pause
exit

:this
ffprobe -v error -select_streams v:0 -show_entries stream=width -i %inputvideo% -of csv=p=0 > %newtemp%\width.txt
ffprobe -v error -select_streams v:0 -show_entries stream=height -i %inputvideo% -of csv=p=0 > %newtemp%\height.txt
set /p height=<%newtemp%\height.txt
set /p width=<%newtemp%\width.txt
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -i %inputvideo% -of csv=p=0 > %newtemp%\fps.txt
set /p fpsvalue=<%newtemp%\fps.txt
ffprobe -i %inputvideo% -show_entries format=duration -v quiet -of csv="p=0" > %newtemp%\fileduration.txt
set /p duration=<%newtemp%\fileduration.txt
echo "%inputvideo2%" 
echo [45G^|  [38;2;254;165;0m%width%[90mx[38;2;254;165;0m%height%[0m [65G^|  [92m%fpsvalue% fps[0m [85G^|  [95m%duration% seconds[0m
echo -----------------------------------------------------------------------------------------------------------------------
goto :eof