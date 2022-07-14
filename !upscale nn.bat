:: made by Frost#5872
:: https://github.com/Thqrn/ffmpeg-scripts
@echo off
set /p width=width: 
set /p height=height: 
for %%a in (%*) do ffmpeg -i %%a -vf "scale=%width%:%height%:flags=neighbor,setsar=1:1" "%%~dpna (scaled to %width%x%height%)%%~xa"
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit