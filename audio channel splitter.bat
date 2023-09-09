:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: Copyright 2023 Thqrn. Licensed under the GNU General Public License v3.0.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

:: splits the audio channels of a file into multiple audio files

@echo off
set name=%~n1
ffprobe -v error -select_streams a:0 -show_entries stream=channels -of csv="p=0" %1 > %temp%/channels.txt
set /p channels=<%temp%/channels.txt
set /a channels=%channels:~0,1%
del %temp%/channels.txt
set total=0
:chanloop
set filter=%filter% -map_channel 0.1.%total% "audio channels/%name%_%total%.wav"
set /a total=%total%+1
if %total% lss %channels% goto :chanloop
ffmpeg -stats_period 0.05 -hide_banner -loglevel fatal -stats -i %1%filter%
pause
exit