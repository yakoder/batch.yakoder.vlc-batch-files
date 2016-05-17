@echo off
set VLC_HOME=C:\PortableApps\PortableApps\VLCPortable\App\vlc
set LOG_PATH=C:\PortableApps\tmp
set BAD_LOG=%LOG_PATH%\vlcmp3-bad.log

set SOURCE="%~1"
setlocal enabledelayedexpansion
set SOURCE="!SOURCE:~1,-1!"
set OUTPUT="!SOURCE:.mp4=.mp3!"
set OUTPUT=!OUTPUT:~1,-1!
set BACKUP="!OUTPUT:.mp3=.old.mp3!"
set BACKUP=!BACKUP:~1,-1!

if exist "!OUTPUT!" (
    if exist "!BACKUP!" (
        @echo.
        @echo ERROR! Cannot run: "!OUTPUT!" exists with 1 backup
        goto:eof
    ) else (
        @echo.
        @echo WARNING! "!OUTPUT!" exists renaming to "!BACKUP!"
        ren "!OUTPUT!" "!BACKUP!"
    )
)

rem Run VLC...
"%VLC_HOME%\vlc.exe" --qt-start-minimized --no-qt-privacy-ask "!SOURCE:~1,-1!" :sout=#transcode{vcodec=none,acodec=mp3,ab=224,channels=2,samplerate=44100}:std{access=file{no-overwrite},mux=wav,dst=!OUTPUT! } vlc://quit

goto:eof

rem -----------------------------------------------------------------
:USEERR
@echo.
@echo ERROR! Usage: %0 [/f] SOURCE.mp4 [/f]
@echo    /f  optional force deletion of existing backup file
goto:eof

