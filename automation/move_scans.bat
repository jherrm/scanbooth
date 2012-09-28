@echo off

:: Prefix the filename with a datetime stamp
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-3 delims=/:/ " %%a in ('time /t') do (set mytime=%%a-%%b-%%c)
set mytime=%mytime: =%

:: Loop through all .ply files in the ReconstructMe folder
for /r "C:\ReconstructMe" %%x in (*.ply) do (
move "%%x" "C:\ScanBooth\scans\raw\%mydate%_%mytime%_%%~nx.ply"
:: Clean the scans
call clean_scan.bat "C:\ScanBooth\scans\raw\%mydate%_%mytime%_%%~nx.ply"
:: You can move the cleaned scans to a shared directory to continue editing or send to 3D printer
move "C:\ScanBooth\scans\cleaned\%mydate%_%mytime%_%%~nx.ply.stl" "C:\ScanBooth\scans\cleaned\%mydate%_%mytime%_%%~nx.stl"
)
