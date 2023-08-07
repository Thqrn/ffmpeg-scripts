:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: Copyright 2023 Thqrn. Licensed under the GNU General Public License v3.0.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

:: replace the audio in a video

@echo off
set /p lowqualmusic=Please drag the desired file here, it must be an audio file: 
call :getname %lowqualmusic%
set /p musicstarttime=Enter a specific start time of the music in seconds: 
choice /c CR /n /m "Do you want to [C]opy the streams or [R]eencode?"
if %errorlevel% == 1 (for %%a in (%*) do ffmpeg -loglevel warning -stats -i %%a -ss %musicstarttime% -i %lowqualmusic% -c copy -map 0:v:0 -map 1:a:0 -shortest "%%~dpna (plus %name%).mp4")
if %errorlevel% == 2 (for %%a in (%*) do ffmpeg -loglevel warning -stats -i %%a -ss %musicstarttime% -i %lowqualmusic% -c:v copy -preset slow -c:a aac -b:a 256k -map 0:v:0 -map 1:a:0 -shortest "%%~dpna (plus %name%).mp4")
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit

:getname
set name=%~n1
goto:eof