@REM ----------------------------------------------------------------------------
@REM Copyright 2001-2004 The Apache Software Foundation.
@REM
@REM Licensed under the Apache License, Version 2.0 (the "License");
@REM you may not use this file except in compliance with the License.
@REM You may obtain a copy of the License at
@REM
@REM      http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing, software
@REM distributed under the License is distributed on an "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM See the License for the specific language governing permissions and
@REM limitations under the License.
@REM ----------------------------------------------------------------------------
@REM

@echo off

set ERROR_CODE=0

:init
@REM Decide how to startup depending on the version of windows

@REM -- Win98ME
if NOT "%OS%"=="Windows_NT" goto Win9xArg

@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" @setlocal

@REM -- 4NT shell
if "%eval[2+2]" == "4" goto 4NTArgs

@REM -- Regular WinNT shell
set CMD_LINE_ARGS=%*
goto WinNTGetScriptDir

@REM The 4NT Shell from jp software
:4NTArgs
set CMD_LINE_ARGS=%$
goto WinNTGetScriptDir

:Win9xArg
@REM Slurp the command line arguments.  This loop allows for an unlimited number
@REM of arguments (up to the command line limit, anyway).
set CMD_LINE_ARGS=
:Win9xApp
if %1a==a goto Win9xGetScriptDir
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto Win9xApp

:Win9xGetScriptDir
set SAVEDIR=%CD%
%0\
cd %0\..\.. 
set BASEDIR=%CD%
cd %SAVEDIR%
set SAVE_DIR=
goto repoSetup

:WinNTGetScriptDir
set BASEDIR=%~dp0\..

:repoSetup


if "%JAVACMD%"=="" set JAVACMD=java

if "%REPO%"=="" set REPO=%BASEDIR%\repo

set CLASSPATH="%BASEDIR%"\etc;"%REPO%"\org\springframework\boot\spring-boot-starter\1.4.0.RELEASE\spring-boot-starter-1.4.0.RELEASE.jar;"%REPO%"\org\springframework\boot\spring-boot\1.4.0.RELEASE\spring-boot-1.4.0.RELEASE.jar;"%REPO%"\org\springframework\boot\spring-boot-autoconfigure\1.4.0.RELEASE\spring-boot-autoconfigure-1.4.0.RELEASE.jar;"%REPO%"\org\springframework\boot\spring-boot-starter-logging\1.4.0.RELEASE\spring-boot-starter-logging-1.4.0.RELEASE.jar;"%REPO%"\ch\qos\logback\logback-classic\1.1.7\logback-classic-1.1.7.jar;"%REPO%"\ch\qos\logback\logback-core\1.1.7\logback-core-1.1.7.jar;"%REPO%"\org\slf4j\jcl-over-slf4j\1.7.21\jcl-over-slf4j-1.7.21.jar;"%REPO%"\org\slf4j\jul-to-slf4j\1.7.21\jul-to-slf4j-1.7.21.jar;"%REPO%"\org\slf4j\log4j-over-slf4j\1.7.21\log4j-over-slf4j-1.7.21.jar;"%REPO%"\org\springframework\spring-core\4.3.2.RELEASE\spring-core-4.3.2.RELEASE.jar;"%REPO%"\org\yaml\snakeyaml\1.17\snakeyaml-1.17.jar;"%REPO%"\org\springframework\spring-context-support\4.3.2.RELEASE\spring-context-support-4.3.2.RELEASE.jar;"%REPO%"\org\springframework\spring-beans\4.3.2.RELEASE\spring-beans-4.3.2.RELEASE.jar;"%REPO%"\org\springframework\spring-context\4.3.2.RELEASE\spring-context-4.3.2.RELEASE.jar;"%REPO%"\org\springframework\spring-aop\4.3.2.RELEASE\spring-aop-4.3.2.RELEASE.jar;"%REPO%"\org\springframework\spring-expression\4.3.2.RELEASE\spring-expression-4.3.2.RELEASE.jar;"%REPO%"\org\springframework\spring-tx\4.3.2.RELEASE\spring-tx-4.3.2.RELEASE.jar;"%REPO%"\org\quartz-scheduler\quartz\2.2.1\quartz-2.2.1.jar;"%REPO%"\c3p0\c3p0\0.9.1.1\c3p0-0.9.1.1.jar;"%REPO%"\org\slf4j\slf4j-api\1.7.21\slf4j-api-1.7.21.jar;"%REPO%"\com\restfb\restfb\1.30.0\restfb-1.30.0.jar;"%REPO%"\org\springframework\boot\spring-boot-starter-data-mongodb\1.4.0.RELEASE\spring-boot-starter-data-mongodb-1.4.0.RELEASE.jar;"%REPO%"\org\mongodb\mongodb-driver\3.2.2\mongodb-driver-3.2.2.jar;"%REPO%"\org\mongodb\mongodb-driver-core\3.2.2\mongodb-driver-core-3.2.2.jar;"%REPO%"\org\mongodb\bson\3.2.2\bson-3.2.2.jar;"%REPO%"\org\springframework\data\spring-data-mongodb\1.9.2.RELEASE\spring-data-mongodb-1.9.2.RELEASE.jar;"%REPO%"\org\springframework\data\spring-data-commons\1.12.2.RELEASE\spring-data-commons-1.12.2.RELEASE.jar;"%REPO%"\ChatbotRepository\Chatbotrepo\0.0.1-SNAPSHOT\Chatbotrepo-0.0.1-SNAPSHOT.jar;"%REPO%"\PostFBNotification\PostFBNotification\0.0.1-SNAPSHOT\PostFBNotification-0.0.1-SNAPSHOT.jar
set EXTRA_JVM_ARGUMENTS=
goto endInit

@REM Reaching here means variables are defined and arguments have been captured
:endInit

%JAVACMD% %JAVA_OPTS% %EXTRA_JVM_ARGUMENTS% -classpath %CLASSPATH_PREFIX%;%CLASSPATH% -Dapp.name="worker" -Dapp.repo="%REPO%" -Dbasedir="%BASEDIR%" Main %CMD_LINE_ARGS%
if ERRORLEVEL 1 goto error
goto end

:error
if "%OS%"=="Windows_NT" @endlocal
set ERROR_CODE=1

:end
@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" goto endNT

@REM For old DOS remove the set variables from ENV - we assume they were not set
@REM before we started - at least we don't leave any baggage around
set CMD_LINE_ARGS=
goto postExec

:endNT
@endlocal

:postExec

if "%FORCE_EXIT_ON_ERROR%" == "on" (
  if %ERROR_CODE% NEQ 0 exit %ERROR_CODE%
)

exit /B %ERROR_CODE%
