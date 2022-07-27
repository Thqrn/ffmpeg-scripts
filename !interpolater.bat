:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: made by Frost#5872
:: https://github.com/Thqrn/ffmpeg-scripts
@echo off
set /p desired=What fps do you want to interpolate from? The lower this value is, the worse the output looks: 
set /p intnum=What do you want to interpolate to: 
for %%a in (%*) do ffmpeg -hide_banner -loglevel error -stats -i %%a -vf fps=%desired% "%%~dpna %desired% fps.mp4"
for %%a in (%*) do ffmpeg -hide_banner -loglevel error -stats  -i "%%~dpna %desired% fps.mp4" -vf "minterpolate=fps=%intnum%" "%%~dpna %desired% to %intnum%.mp4"
for %%a in (%*) do if exist "%%~dpna %desired% fps.mp4" (del "%%~dpna %desired% fps.mp4")
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit