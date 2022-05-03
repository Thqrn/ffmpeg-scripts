@echo off
title Speed Changer
color 0f
set /p speedq=Speed (0.5-100): 
for %%a in (%*) do ffmpeg -i %%a -vf "setpts=(1/%speedq%)*PTS" -af "atempo=%speedq%" -c:v libx264 -preset slower -x264-params aq-mode=3 -crf 17 "%%~dpna (%speedq%x speed).mp4"