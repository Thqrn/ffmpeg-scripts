@echo off
set /p framenum=Frame num, starts at 0: 
for %%a in (%*) do ffmpeg -hide_banner -loglevel error -stats -i %%a -vf "select=eq(n\,%framenum%)" -frames:v 1 "%%~dpna (frame %framenum%).png"