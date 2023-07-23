:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

:: changes a video's framerate

@echo off
set /p fpsq=New FPS: 
echo [N]VENC
echo [C]PU
echo [A]MF
echo [Q]uicksync
choice /c NCAQ /n /m "Select an encoder: "
set ch=%errorlevel%
if %ch% == 1 set encodingargs=-c:v h264_nvenc -preset p7 -rc vbr -b:v 250M -cq 14
if %ch% == 2 set encodingargs=-c:v libx264 -preset slow -crf 17 -aq-mode 3
if %ch% == 3 set encodingargs=-c:v h264_amf -quality quality -qp_i 16 -qp_p 18 -qp_b 22
if %ch% == 4 set encodingargs=-c:v h264_qsv -preset veryslow -global_quality:v 15
for %%a in (%*) do ffmpeg -i %%a -r %fpsq% %encodingargs% -c:a copy "%%~dpna (%fpsq% FPS).mp4"
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit