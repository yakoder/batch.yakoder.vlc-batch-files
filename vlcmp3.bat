@echo off
rem -----------------------------------------------------------------
rem Conversion script to extract MP3 audio from MP4 video files
rem using VLC.
rem -----------------------------------------------------------------

rem -----------------------------------------------------------------
rem IMPORTANT!!! Set VLC_HOME to the directory containing vlc.exe
rem -----------------------------------------------------------------
set VLC_HOME=C:\PortableApps\PortableApps\VLCPortable\App\vlc
rem -----------------------------------------------------------------

rem -----------------------------------------------------------------
rem Temp files for use in conversion
rem Defaults to directory in which this batch file is called
rem May be changed, if desired
rem -----------------------------------------------------------------
set INPUT=in.mp4
set OUTPUT=out.mp3
rem -----------------------------------------------------------------

rem -----------------------------------------------------------------
rem Start of normal processing
rem -----------------------------------------------------------------
rem Clean-up from previous run
if exist "%INPUT%" (
    @echo.
    @echo WARNING! "%INPUT%" exists, deleting.
    @echo.
    del /q /f "%INPUT%"
)
if exist "%OUTPUT%" (
    @echo.
    @echo WARNING! "%OUTPUT%" exists, deleting.
    @echo.
    del /q /f "%OUTPUT%"
)

set SOURCE="%~1"
rem Handle any special characters
setlocal enabledelayedexpansion
rem Remove extra quotes
set SOURCE="!SOURCE:~1,-1!"
rem Create temp-input file to avoid dealing further with special characters
copy /v /y /b !SOURCE! "!INPUT!"
if not exist "!INPUT!" (
    @echo.
    @echo ERROR^^! Cannot proceed: creation of "!INPUT!" from !SOURCE! failed^^!
    @echo.
    goto:eof
)

rem Create one backup of the intended target, just in case of re-run
if exist !TARGET! (
    if exist !BACKUP! (
        @echo.
        @echo ERROR^^! Cannot run: !TARGET! exists with 1 backup
        @echo.
        goto:eof
    ) else (
        @echo.
        @echo WARNING^^! !TARGET! exists, moving to !BACKUP!
        @echo.
        move /y !TARGET! !BACKUP!
    )
)

rem Run VLC...
"%VLC_HOME%\vlc.exe" --qt-start-minimized --no-qt-privacy-ask !INPUT! :sout=#transcode{vcodec=none,acodec=mp3,ab=224,channels=2,samplerate=44100}:std{access=file{no-overwrite},mux=wav,dst=!OUTPUT! } vlc://quit

rem Post-run clean-up of temp-input file
if exist "%INPUT%" (
    del /q /f "%INPUT%"
)

rem Rename temp-output file to target name
if exist "!OUTPUT!" (
    move /y "!OUTPUT!" !TARGET!
) else (
    @echo.
    @echo WARNING^^! "!OUTPUT!" does not exist^^!
    @echo          VLC did not convert !SOURCE! successfully.
    @echo.
)

goto:eof
rem -----------------------------------------------------------------
rem End of normal processing
rem -----------------------------------------------------------------

rem -----------------------------------------------------------------
:USEERR
@echo.
@echo ERROR^^! Usage: %0 [/f] SOURCE.mp4 [/f]
@echo    /f  optional force deletion of existing backup file
@echo.
goto:eof
rem -----------------------------------------------------------------

