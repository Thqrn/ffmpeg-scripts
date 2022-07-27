:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: made by Frost#5872
:: https://github.com/Thqrn/ffmpeg-scripts
@echo off
title Speed Changer
color 0f
set /p speedq=Speed (0.5-100): 
for %%a in (%*) do ffmpeg -i %%a -vf "setpts=(1/%speedq%)*PTS" -af "atempo=%speedq%" -c:v libx264 -preset slower -x264-params aq-mode=3 -crf 17 "%%~dpna (%speedq%x speed).mp4"
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit