:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: Copyright 2023 Thqrn. Licensed under the GNU General Public License v3.0.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

:: audio combiner - combine the audio of multiple files into one file

@echo off
setlocal enabledelayedexpansion

where /q ffmpeg.exe || (
    echo [91mERROR: You either don't have ffmpeg installed or don't have it in PATH.[0m
    echo Please install it as it's needed for this script to work.
    choice /n /c gc /m "Press [G] to open a guide on installing it, or [C] to close the script."
    if %errorlevel% == 1 start "" https://www.youtube.com/watch?v=WwWITnuWQW4
    exit
)

:: find the number of inputs
for %%a in (%*) do (
    set /a inputs+=1
    echo [!inputs!] %%~dpnxa
    set values=!values!!inputs!
    if !inputs! GTR 9 echo Too many inputs ^(>9^), exiting... && pause && exit
)
choice /c %values% /n /m "Select the input to use the video of: "
set /a videoinput=%errorlevel%
set /a videoindex=%videoinput%-1
goto :setter
:done

cls

:: find all inputs with an audio stream and put them in a list
for %%a in (%*) do (
    ffprobe -i %%a -show_streams -select_streams a -loglevel error > %temp%\astream.txt
    set /p astream=<%temp%\astream.txt
    if exist "%temp%\astream.txt" (del "%temp%\astream.txt")
    if not 1!astream!==1 (
        set /a audioinputs+=1
        set /a audioinputindex=!audioinputs!-1
        set audios=!audios![!audioinputindex!:a]
    )
    if !audioinputs!==0 echo No audio streams found, exiting... && pause && exit
)

cls

:: need to make sure durations and audio and shit are working

set i=0
:: set a volume for each audio input
for %%a in (%*) do (
    set /a inputindex+=1
    set volume=1.0
    set /p "volume=Input a volume for %%~na (1.0 is default) or leave blank: "
    set start=0
    set /p "start=Input from what point the audio/video from %%~na should start or leave blank: "
    if not defined volume set volume=1.0
    if not defined start set start=0
    if defined volumes set volumes=!volumes!,
    set volumes=!volumes![!i!:a]volume=!volume![out!i!]
    set "ffinputs=!ffinputs! -ss !start! -i %%a"
    set outaudio=!outaudio![out!i!]
    set "volume="
    set /a i+=1
    echo.
)

cls

choice /m "Normalize audio" 
if %errorlevel% == 1 set normalize=1
if %errorlevel% == 2 set normalize=0

cls

ffprobe -i "%videofile%%ext%" -show_entries format=duration -v quiet -of csv="p=0" > %temp%\fileduration.txt
set /p duration=<%temp%\fileduration.txt
if exist "%temp%\fileduration.txt" (del "%temp%\fileduration.txt")
if exist "%videofile% (combined audio)%ext%" (call :renamefile) else (set "filename=%videofile% (combined audio)%ext%")
ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats%ffinputs% -filter_complex "%volumes%;%outaudio%amix=inputs=%audioinputs%:normalize=%normalize%,atrim=duration=%duration%" -shortest -c:v:0 copy -bsf:v:0 null -c:a aac -b:a 320k "%filename%"

where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
pause
exit

:setter
for %%a in (%*) do (
    set /a index+=1
    if %videoinput%==!index! set videofile=%%~dpna&&set ext=%%~xa&&goto done
)
goto done

:renamefile
:: start of the repeat until loop (repeats until the file doesn't exist)
set i=1
:renamefileloop
set /a "i+=1"
if exist "%videofile% (combined audio %i%)%ext%" goto renamefileloop
set "filename=%videofile% (combined audio %i%)%ext%"
goto :eof