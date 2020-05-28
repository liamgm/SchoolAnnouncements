@echo off
:: Fix a problem I had with getting a large file into the repository
If Not Exist ".\OBS\obs-plugins\64bit\libcef.dll" copy /B ".\OBS\obs-plugins\64bit\libcef1.dll+.\OBS\obs-plugins\64bit\libcef2.dll" ".\OBS\obs-plugins\64bit\libcef.dll"
:: groan.

:: Copy profiles to user directory
If Not Exist "%APPDATA%\obs-studio\basic\profiles\MPEG2TS\basic.ini" robocopy ".\OBS_Profiles\MPEG2TS" "%APPDATA%\obs-studio\basic\profiles\MPEG2TS" basic.ini
If Not Exist "%APPDATA%\obs-studio\basic\profiles\WEBM\basic.ini" robocopy ".\OBS_Profiles\WEBM" "%APPDATA%\obs-studio\basic\profiles\WEBM" basic.ini

:: Have one of these SET lines uncommented, with no double colon at the start to choose which profile to load on start
SET OBSPROFILE=MPEG2TS
::SET OBSPROFILE=WEBM

:: Start OBS using our basic Profile
start /B /D .\OBS\bin\64bit .\OBS\bin\64bit\obs64.exe --profile %OBSPROFILE% --studio-mode


:: Show candidate URLs to use, ideally the FQDN of the machine

setlocal enabledelayedexpansion
echo Try these URLs:
for /f "usebackq tokens=1-2 delims=:" %%f in (`ipconfig /all`) do (
    set "item=%%f"
    if not "!item!"=="!item:Host Name=!" (
      set "hostname=%%g"
      if "!hostname:~0,1!" == " " (
          set "hostname=!hostname:~1!"
      )
      if not "!dnsSuffix!" == "" (
          echo http://!hostname!.!dnsSuffix!:8000
      )
    ) else if not "!item!"=="!item:Primary Dns Suffix=!" (
      set "dnsSuffix=%%g"
      if "!dnsSuffix:~0,1!" == " " (
          set "dnsSuffix=!dnsSuffix:~1!"
      )
      if "!dnsSuffix!" == "" if not "!hostname!" == "" (
          echo http://!hostname!:8000
      )
      if not "!hostname!" == "" (
          echo http://!hostname!.!dnsSuffix!:8000
      )
    ) else if not "!item!"=="!item:IPV4 Address=!" (
        set "ipaddy=%%g"
        if "!ipaddy:~0,1!" == " " (
            set "ipaddy=!ipaddy:~1!"
        )
        if "!ipaddy:~-12!" == "(Preferred) " (
            set "ipaddy=!ipaddy:~0,-12!"
        )
        echo http://!ipaddy!:8000
     )
)

echo If prompted to permit a change to your firewall rules, approve it to allow others to watch your live stream...
echo Close this window to stop the Icecast server
:: Start IceCast
.\Icecast\bin\icecast.exe -c .\Icecast.xml