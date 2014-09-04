@echo off 
rem path=C:\D\dmd2\windows\bin;C:\D\dm\bin;
rem path=C:\D\dmd.2.064.2\windows\bin;
rem set path=c:\D\dmd.2.065.0\windows\bin;c:\D\dm\bin;
set path=c:\D\dmd.2.065.0\windows\bin;c:\D\dm\bin;

rem dmd foo.d -O -inline -release
@echo on

dmd -g debuglog.d main.d
@if errorlevel 1 goto END
:RUN

debuglog.exe

:END
pause
