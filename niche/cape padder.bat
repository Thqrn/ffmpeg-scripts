:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: Copyright 2023 Thqrn. Licensed under the GNU General Public License v3.0.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

:: this script is designed to add padding to a minecraft cape texture that isn't designed following the quadrants

@echo off

:: input res / wanted output res
set widthscale=0.34375
set heightscale=0.52734375

title super epic cape padder
set total=0
set progress=0
for %%x in (%*) do set /a total+=1
echo [38;2;254;165;0mEncoding...[0m
for %%a in (%*) do (
   call :running "%%~fa"
)
echo.
title [Done] super epic cape padder
echo [92mDone![0m
where /q ffplay || goto aftersound
ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
:aftersound
pause
exit

:running
set /a "progress+=1"
title [%progress%/%total%] super epic cape padder
ffmpeg -hide_banner -stats_period 0.05 -loglevel warning -stats -i %1 -vf pad=w=(iw/%widthscale%):h=(ih/%heightscale%):color=black@0x00 -c:v png "%~n1 (padded).png"
goto :eof