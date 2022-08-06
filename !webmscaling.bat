@echo off
set /p "increment=Bouncing speed: "
set /p "minimum=Minimum scale relative to original from 0.0 to 1.0: "
choice /c WHB /m "Stretch width, height, or both?"
set selection=%errorlevel%
ffmpeg -hide_banner -stats_period 0.05 -loglevel warning -stats -i "%~1" -c:a libopus -c:v libvpx "%~n1 webmifed.webm"
ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -i "%~1" -of csv=p=0 > "%temp%\frames.txt"
set /p frames=<"%temp%\frames.txt"
del "%temp%\frames.txt"
ffprobe -v error -select_streams v:0 -show_entries stream=width -i "%~1" -of csv=p=0 > %temp%\width.txt
ffprobe -v error -select_streams v:0 -show_entries stream=height -i "%~1" -of csv=p=0 > %temp%\height.txt
set /p height=<%temp%\height.txt
set /p width=<%temp%\width.txt
del "%temp%\width.txt"
del "%temp%\height.txt"
set /a frames=%frames%
mkdir "%temp%\qmframes"
:loopframes
set /a loopn+=1
echo %loopn%/%frames%
set /a frametograb=%loopn%-1
if %selection% == 1 (
    ffmpeg -hide_banner -loglevel fatal -vsync drop -i "%~n1 webmifed.webm" -vf "select=eq(n\,%frametograb%),scale=%width%*(((cos(%loopn%*(%increment%/10)))/2)*((1/%minimum%-1)/(1/%minimum%))+((1+%minimum%)/2)):%height%" -an "%temp%\qmframes\framenum%loopn%.webm"
) else (
    if %selection% == 2 (
    ffmpeg -hide_banner -loglevel fatal -vsync drop -i "%~n1 webmifed.webm" -vf "select=eq(n\,%frametograb%),scale=%width%:%height%*(((cos(%loopn%*(%increment%/10)))/2)*((1/%minimum%-1)/(1/%minimum%))+((1+%minimum%)/2))" -an "%temp%\qmframes\framenum%loopn%.webm"
    ) else (
        ffmpeg -hide_banner -loglevel fatal -vsync drop -i "%~n1 webmifed.webm" -vf "select=eq(n\,%frametograb%),scale=%width%*(((cos(%loopn%*(%increment%/10)))/2)*((1/%minimum%-1)/(1/%minimum%))+((1+%minimum%)/2)):%height%*(((cos(%loopn%*(%increment%/12)))/2)*((1/%minimum%-1)/(1/%minimum%))+((1+%minimum%)/2))" -an "%temp%\qmframes\framenum%loopn%.webm"
    )
)
echo file '%temp%\qmframes\framenum%loopn%.webm' >> "%temp%\qmframes\filelist.txt"
if %loopn% lss %frames% goto loopframes
ffmpeg -hide_banner -stats_period 0.05 -loglevel warning -stats -f concat -safe 0 -i %temp%\qmframes\filelist.txt -i "%~n1 webmifed.webm" -map 1:a -map 0:v -c copy "%~n1 weird.webm"
del "%~n1 webmifed.webm"
rmdir "%temp%\qmframes" /s /q
pause
exit



rem ^
(((cos(%loopn%*(%increment%/10)))/2)*((1/%minimum%-1)/(1/%minimum%))+((1+%minimum%)/2))