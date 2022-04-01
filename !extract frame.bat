@echo off
if "1%2" == "1" goto skipped
set "input=%1"
set input=%input:.mp4=%
set input=%input:"=%
ffmpeg -i %1 -vf "select=eq(n\,%framenum%)" -frames:v 1 "%input% (frame %framenum%).png"
exit

:skipped
@echo off
set input=%*
set input=%input:.mp4=%
set input=%input:"=%
set /p framenum=Frame num, starts at 0: 
ffmpeg -hide_banner -loglevel error -stats -i %* -vf "select=eq(n\,%framenum%)" -frames:v 1 "%input% (frame %framenum%).png"