:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

@echo off
choice /c me /n /m "Press [m] to remux (faster) or [e] to reencode (slower)" 
if %errorlevel% == 1 for %%a in (%*) do ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats -i %%a -c copy "%%~dpna.mp4"
if %errorlevel% == 2 for %%a in (%*) do ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats -i %%a -c:v libx264 -preset slow -crf 17 -aq-mode 3 -c:a aac -b:a 256k "%%~dpna.mp4"
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit