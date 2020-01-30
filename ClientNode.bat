@echo off 

TITLE Client Node

REM This is parameter value reading

set Host=%1
set dir=%2
echo Parameter host: %HOST% 
echo Paramter direcoty path: %dir%

Echo.
Echo Connecting to grid hub sever, please wait...
Echo.

java -jar %dir%\selenium-server-standalone-3.141.59.jar -role node -browser browserName=chrome -hub http://%Host%:4444/grid/register -port 5555
