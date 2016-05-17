@echo off
setlocal
set VLC_HOME=C:\PortableApps\PortableApps\VLCPortable\App\vlc
set OUT_PATH=C:\PortableApps\tmp
set OUT_FILE=%OUT_PATH%\vlcmp4-out.mp4
set BAD_LOG=%OUT_PATH%\vlcmp4-bad.log

if [%1]==[/f] (
    set FORCE=1
    if [%2]==[] (goto USEERR) else (set URL=%2)
    if [%3]==[] (goto USEERR) else (set "TITLE=%~3")
) else (
    if [%1]==[] (goto USEERR) else (set URL=%1)
    if [%2]==[] (goto USEERR) else (set "TITLE=%~2")
    if [%3]==[/f] (set FORCE=1) else (set FORCE=0)
)

if [%FORCE%]==[1] (
    if exist "%TITLE%.old.mp4" (
        del /f "%TITLE%.old.mp4"
    )
)

if exist %OUT_FILE% (
    del /f %OUT_FILE%
)

if exist "%TITLE%.mp4" (
    if exist "%TITLE%.old.mp4" (
        echo.
        echo ERROR! Cannot run: "%TITLE%.mp4" exists with 1 backup
        goto:eof
    ) else (
        echo.
        echo WARNING! "%TITLE%.mp4" exists renaming to "%TITLE%.old.mp4"
        ren "%TITLE%.mp4" "%TITLE%.old.mp4"
    )
)

rem Run VLC...
"%VLC_HOME%\vlc.exe" --qt-start-minimized --no-qt-privacy-ask %URL% :sout=#file{dst=%OUT_FILE:\=\\%,no-overwrite} :sout-all :sout-keep vlc://quit

if exist %OUT_FILE% (
    ren %OUT_FILE% "%TITLE%.mp4"
    if errorlevel 1 (
        echo.
        echo ERROR! Cannot rename: "%TITLE%.mp4"
    ) else (
        echo.
        echo SUCCESS! Video saved to "%TITLE%.mp4"
    )
)
goto:eof

rem -----------------------------------------------------------------
:USEERR
echo.
echo ERROR! Usage: %0 [/f] URL TITLE [/f]
echo    /f  optional force deletion of existing backup file
goto:eof

