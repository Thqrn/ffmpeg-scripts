:: made by Frost#5872
:: https://github.com/Thqrn/ffmpeg-scripts
for %%a in (%*) do ffmpeg -i %%a -c copy -map_metadata 0 -map_metadata:s:v 0:s:v -map_metadata:s:a 0:s:a -f ffmetadata "%%~dpna metadata.txt"