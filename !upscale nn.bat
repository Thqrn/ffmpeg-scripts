:: made by Frost#5872
:: https://github.com/Thqrn/ffmpeg-scripts
@echo off
set /p width=width: 
set /p height=height: 
for %%a in (%*) do ffmpeg -i %%a -vf "scale=%width%:%height%:flags=neighbor,setsar=1:1" "%%~dpna (scaled to %width%x%height%)%%~xa"