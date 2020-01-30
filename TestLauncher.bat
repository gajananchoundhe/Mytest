@echo off 

TITLE Automation Test Lanucher

SET dir=%USERPROFILE%\ShortlistAutomationTest
REM SET Host=localhost


Echo -----
Echo %dir%

If not exist %dir% (
     Echo Creating directory %dir%
     mkdir %dir%
) else (
Echo Directory found.. )

cd %dir%



Set ipFile=IPAddress.txt

If not exist %ipFile% (
     Echo fetching IP file
     curl https://raw.githubusercontent.com/gajananchoundhe/Mytest/master/IPAddress.txt -O
) else (
REM Echo IP file found.. 
)



set /p Host=<IPAddress.txt
IF "%Host%" NEQ "" ( 
echo IP Address: %Host%
) else (
Host=localhost
) 


If exist %ipFile% (
     
     del IPAddress.txt
     Echo IP file deleted
)



ECHO  Select you choice from below 
Echo -------------------------------------------------
ECHO  Step 1 - Which environment you want to run test?
Echo -------------------------------------------------
ECHO   1 - QA 
ECHO   2 - Production

:Environment_Block
set /p Env=" Please enter your choice 1 or 2: "

IF "%Env%"=="1" (
  SET Env=QA
) ELSE IF "%Env%"=="2" (
  SET Env=Prod
) ELSE (
  echo.	
  echo Wrong choice, please enter choice 1 or 2
  echo.
  goto Environment_Block
)

Echo.
Echo -------------------------------------------------
ECHO  Step 2 - Which browser you want to run test?
Echo -------------------------------------------------
ECHO   1 - Chrome
ECHO   2 - Firefox

:Browser_Block
set /p Browser=" Please enter your choice 1 or 2: "

IF "%Browser%"=="1" (
  SET Browser=Chrome
) ELSE IF "%Browser%"=="2" (
  SET Browser=Firefox
) ELSE (
  echo.	
  echo Wrong choice, please enter choice 1 or 2
  echo.
  goto Browser_Block
)

Echo.
Echo ------------------------------------------------------
ECHO Step 3 - Which machine do you want to run test?
Echo ------------------------------------------------------
ECHO   1 - Local Machine
ECHO   2 - Remote Machine

:Machine_Block
set /p RunTestOnRemote=" Please enter your choice 1 or 2: "

IF "%RunTestOnRemote%"=="1" (
  SET RunTestOnRemote=Local
) ELSE IF "%RunTestOnRemote%"=="2" (
  SET RunTestOnRemote=Remote
) ELSE (
  echo.	
  echo Wrong choice, please enter choice 1 or 2
  echo.
  goto Machine_Block
)

Echo.
echo ...........................................
echo Test Configuration details 
echo ...........................................
echo Environment: %Env%
echo Browser: %Browser%
echo Machine: %RunTestOnRemote%
echo.


Echo Checking configuration details 


REM TIMEOUT /T 10


If not exist %dir%\jenkins-cli.jar (
     Echo System downloading dependencies files, please wait moments...	
     Echo Downloading jenkin CLI JAR, please wait ....
     REM curl http://%Host%:8080/jnlpJars/jenkins-cli.jar -O
         curl https://candidate-automation-report.s3.amazonaws.com/jenkins-cli.jar -O
    
)

If not exist %dir%\selenium-server-standalone-3.141.59.jar (
     Echo Downloading Selenium Server Jar, please wait ....
     curl https://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-3.141.59.jar -O
     Echo Downloading completed
)


If not exist %dir%\ClientNode.bat (
     Echo Downloading client node, please wait moments...	
     curl https://raw.githubusercontent.com/gajananchoundhe/Mytest/master/ClientNode.bat -O
     Echo Downloading completed	
    
)




if %ERRORLEVEL% neq 0  Echo Error occured while download jenkin jar

Echo Testing starting ...........

java -jar jenkins-cli.jar -s http://%Host%:8080/ build ShotlistAutomationTest  -s -v -p Browser=%Browser% -p TestEnvironment=%Env% -p JobID=Test -p TestType=sanitytest


IF "%RunTestOnRemote%"=="Local" (

start /MIN cmd /k %dir%\ClientNode.bat %Host% %dir%

Echo Client node connecting to server, please wait a moment
TIMEOUT /T 10

Echo Testing running on your machine - local machine

) else (
Echo Testing running on remote machine
)


if %ERRORLEVEL% neq 0  Echo Error occured while running test..

REM Echo Closing client node in seconds
REM TIMEOUT /T 10

REM taskkill /IM cmd.exe /FI "Windowtitle eq Client Node"

pause



