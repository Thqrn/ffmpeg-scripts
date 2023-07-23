:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts
@echo off
:: removing and making temp folder
rmdir %temp%\propertiesfinder /s /q > nul 2> nul
mkdir %temp%\propertiesfinder
set newtemp=%temp%\propertiesfinder
choice /n /m "Show total frame counts? (slower)"
cls
if %errorlevel% == 1 set showfc=y
if %errorlevel% == 2 set showfc=n
:: for each file used as an input, find its properties
for %%a in (%*) do (
    set inputvideo=%%a
    set inputviduserfriendly=%%~nxa
    call :findproperties
    echo -----------------------------------------------------------------------------------------------------------------------
)
:: deleting temp folder
rmdir %temp%\propertiesfinder /s /q
where /q ffplay || goto aftersound
if not exist "C:\Windows\Media\notify.wav" (goto aftersound) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
:aftersound
pause
exit

:findproperties
:: reset variables
set "vformat="
set "aformat="
set "height="
set "width="
set "fpsvalue="
set "duration="
set "frames="
:: video format
ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 -i %inputvideo% > %newtemp%\vformat.txt
set /p vformat=<%newtemp%\vformat.txt
if "%vformat%1" == "1" (set vformat=[38;2;120;0;9mN/A) else set vformat=[38;2;255;1;19m%vformat%
:: audio format
ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 -i %inputvideo% > %newtemp%\aformat.txt
set /p aformat=<%newtemp%\aformat.txt
if "%aformat%1" == "1" (set aformat=[38;2;125;41;0mN/A) else set aformat=[38;2;255;110;40m%aformat%
:: width and height
ffprobe -v error -select_streams v:0 -show_entries stream=width -i %inputvideo% -of csv=p=0 > %newtemp%\width.txt
ffprobe -v error -select_streams v:0 -show_entries stream=height -i %inputvideo% -of csv=p=0 > %newtemp%\height.txt
set /p height=<%newtemp%\height.txt
set /p width=<%newtemp%\width.txt
set wbh=[38;2;235;218;11m%width%[90m by [38;2;235;218;11m%height%[0m
if "%width%1" == "1" set wbh=[38;2;121;113;6mN/A[0m
:: frames per second
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -i %inputvideo% -of csv=p=0 > %newtemp%\fps.txt
set /p fpsvalue=<%newtemp%\fps.txt
if "%fpsvalue%1" == "1" (set fpsvalue=[38;2;0;105;43mN/A) else set fpsvalue=[38;2;0;211;86m%fpsvalue%
set fpsvalue=%fpsvalue:/1=%
:: duration
ffprobe -i %inputvideo% -show_entries format=duration -v quiet -of csv="p=0" > %newtemp%\fileduration.txt
set /p duration=<%newtemp%\fileduration.txt
if "%duration%1" == "1" (set duration=[38;2;5;83;109mN/A) else set duration=[38;2;9;157;207m%duration%
:: if frame count is off, skip and display now
if %showfc% == n goto noshowframecount
:: frame count
ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -i %inputvideo% -of csv=p=0 > %newtemp%\frames.txt
set /p frames=<%newtemp%\frames.txt
if "%frames%1" == "1" (set frames=[38;2;97;7;125mN/A) else set frames=[38;2;172;13;221m%frames%
:: display file properties
echo  ^> [38;2;232;138;154m%inputviduserfriendly%[0m
echo    video format[20G^| audio format[38G^| resolution [57G^| frames per second [80G^| duration (in seconds)[107G^| Frames
echo    %vformat% [0m[20G^| %aformat% [0m[38G^| %wbh% [57G^| %fpsvalue%[0m[80G^| %duration%[0m[107G^| %frames%[0m
goto :eof

:noshowframecount
:: display file properties (excluding frame count)
echo  ^> [38;2;232;138;154m%inputviduserfriendly%[0m
echo    video format[20G^| audio format[38G^| resolution [57G^| frames per second [80G^| duration (in seconds)
echo    %vformat% [0m[20G^| %aformat% [0m[38G^| %wbh% [57G^| %fpsvalue%[0m[80G^| %duration%[0m
goto :eof