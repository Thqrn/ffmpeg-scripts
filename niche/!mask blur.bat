:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

:: masks a video that has been interpolated with a blurred version of the original video
:: requires the original video and the blurred video

@echo off
setlocal enabledelayedexpansion

:: ##########################################################################################
:: SETTINGS
:: ##########################################################################################
:: set this variable to false if you want to manually find the original file and skip the checks
set automatic=true
:: resample the original video when masking to help it blend in better
set resample=true
:: set this to the path of the mask
if exist "%temp%/maskblurtemp" (rmdir /s /q "%temp%/maskblurtemp")
:: ##########################################################################################

mkdir "%temp%/maskblurtemp"
set maskblurtemp=%temp%/maskblurtemp
set mask="%maskblurtemp%/blurmask.png"

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

:: for each input, find an output and mask it
for %%a in (%*) do (
    call :maskvideo %%a
)
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit

:maskvideo
:: defines blurred video
set "blurredvid=%1"
:: tries to find the original video
if "%automatic%" == "true" (
    set "ogvid=%blurredvid: - blur=%"
    if exist !ogvid! (
        if !ogvid! NEQ %blurredvid% goto afterfound
    )
    set ogvid="%~dpn1 - blur%~x1"
    if not exist !ogvid! (
        goto skipped
    ) else (
        set blurredvid=!ogvid!
        set "ogvid=%blurredvid%"
    )
)
:afterfound
echo Original Input Video: !ogvid!
echo Blurred Video: !blurredvid!
echo Mask: %mask%
echo Resample Enabled: %resample%
:: finds framerate of blurred video
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -i %blurredvid% -of csv=p=0 > %maskblurtemp%\fpsv.txt
set /p fpsvalue=<%maskblurtemp%\fpsv.txt
set /a fpsvalue=%fpsvalue%
:: finds framerate of original video
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -i %ogvid% -of csv=p=0 > %maskblurtemp%\fpsv.txt
set /p fpsvalueOG=<%maskblurtemp%\fpsv.txt
set /a fpsvalueOG=%fpsvalueOG%
if exist "%maskblurtemp%\fpsv.txt" (del "%maskblurtemp%\fpsv.txt")
:: checks if the framerate is too high (possibly used unblurred video as input?)
if %fpsvalue% gtr %fpsvalueOG% (
    echo WARNING: Your unblurred video is at %fpsvalue% FPS, while your blurred video is at %fpsvalueOG% FPS.
    echo This may indicate that you input the unblurred video instead of the blurred video.
    echo Proceed? [Y/N]
    set /p "continue="
    if not "!continue!" == "Y" exit
)
echo Output FPS: %fpsvalue%
if not exist %mask% (curl -s -o %mask% https://i.ibb.co/SrBPSsM/mask.png > nul)
if %resample% == true (
    ffmpeg -hide_banner -stats_period 0.5 -loglevel error -stats -i %ogvid% -i %mask% -pix_fmt rgba -c:v png -an -filter_complex "tmix=frames=(%fpsvalueOG%/%fpsvalue%),fps=%fpsvalue%,alphamerge" "%maskblurtemp%\thisisanexample.mov"
) else (
    ffmpeg -hide_banner -stats_period 0.5 -loglevel error -stats -i %ogvid% -i %mask% -pix_fmt rgba -c:v png -an -filter_complex "fps=%fpsvalue%,alphamerge" "%maskblurtemp%\thisisanexample.mov"
)
ffmpeg -hide_banner -stats_period 0.5 -loglevel error -stats -i %blurredvid% -i "%maskblurtemp%\thisisanexample.mov" -filter_complex overlay -c:a copy %encodingargs% "%~dpn1 (masked).mp4"
:: deletes maskblurtemp files
if exist "%maskblurtemp%\thisisanexample.mov" (del "%maskblurtemp%\thisisanexample.mov")
if exist maskblurtemp (rmdir /s /q maskblurtemp)
goto :eof

:skipped
echo ERROR: Original (unblurred) file not found. Please provide it manually.
echo For reference, the blurred file should be %blurredvid%.
set /p ogvid=Please drag in the pre-blur file here: 
goto afterfound