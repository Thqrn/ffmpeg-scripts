:: made by Frost#5872
:: https://github.com/Thqrn/ffmpeg-scripts
@echo off
set /p framenum=Frame num, starts at 0: 
for %%a in (%*) do ffmpeg -hide_banner -loglevel error -stats -i %%a -vf "select=eq(n\,%framenum%)" -frames:v 1 -c:v png "%%~dpna (frame %framenum%).png"
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit