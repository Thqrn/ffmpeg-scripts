:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

:: interpolater designed to make videos look worse

@echo off
echo What fps do you want to interpolate from? The lower this value is, the worse the output looks: 
echo Leave this blank to use the input's fps.
set /p "desired= "
set /p "intnum=What do you want to interpolate to: "
if defined desired for %%a in (%*) do ffmpeg -hide_banner -loglevel error -stats -i %%a -vf fps=%desired% "%%~dpna %desired% fps.mp4"
if defined desired for %%a in (%*) do ffmpeg -hide_banner -loglevel error -stats  -i "%%~dpna %desired% fps.mp4" -vf "minterpolate=fps=%intnum%" "%%~dpna %desired% to %intnum%.mp4"
if not defined desired for %%a in (%*) do ffmpeg -hide_banner -loglevel error -stats  -i %%a -vf "minterpolate=fps=%intnum%" "%%~dpna interpolated to %intnum%.mp4"
if defined desired for %%a in (%*) do if exist "%%~dpna %desired% fps.mp4" (del "%%~dpna %desired% fps.mp4")
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit