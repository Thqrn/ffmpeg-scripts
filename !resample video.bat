:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: made by Frost#5872
:: https://github.com/Thqrn/ffmpeg-scripts
@echo off
if "1%~1" == "1" (
    echo no input
    echo use send to or run the file with a parameter
    pause
    exit
)
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -i %1 -of csv=p=0 > %temp%\fps.txt
set /p infps=<%temp%\fps.txt
if exist "%temp%\fps.txt" (del "%temp%\fps.txt")
set /a infps=%infps%
set /p "outfps=output fps: "
set /p "bluramount=blur amount (default is 1.0): "
set tmixframes=((%infps%*%bluramount%)/%outfps%)
ffmpeg -loglevel warning -stats -i %1 ^
-vf tmix=frames=%tmixframes%:weights="1",fps=%outfps% ^
-c:v libx264 -preset slow -crf 17 -aq-mode 3 -c:a copy "%~dpn1 (resampled %infpsoriginal% to %outfps%).mp4"
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit