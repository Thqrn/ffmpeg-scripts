:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

:: basic nearest neighbor / point upscaler

@echo off
set /p "width=width: "
set /p "height=height: "
for %%a in (%*) do ffmpeg -i %%a -vf "scale=%width%:%height%:flags=neighbor,setsar=1:1" "%%~dpna (scaled to %width%x%height%)%%~xa"
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit