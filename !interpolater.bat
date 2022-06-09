:: made by Frost#5872
:: https://github.com/Thqrn/ffmpeg-scripts
@echo off
set /p desired=What fps do you want to interpolate from? The lower this value is, the worse the output looks: 
set /p intnum=What do you want to interpolate to: 
for %%a in (%*) do ffmpeg -hide_banner -loglevel error -stats -i %%a -vf fps=%desired% "%%~dpna %desired% fps.mp4"
for %%a in (%*) do ffmpeg -hide_banner -loglevel error -stats  -i "%%~dpna %desired% fps.mp4" -vf "minterpolate=fps=%intnum%" "%%~dpna %desired% to %intnum%.mp4"
for %%a in (%*) do if exist "%%~dpna %desired% fps.mp4" (del "%%~dpna %desired% fps.mp4")