set DB=xxxXXxxx
set ENV=xxx
set BASEPATH=X:\xxx
set READONLYROLE=CSCL_READ_ONLY
set EDITORROLE1=DOITT_EDITOR
set EDITORROLE2=DCP_EDITOR
set EDITORROLE3=BASIC
set SDEFILE=%BASEPATH%\Connections\oracle19c\%ENV%\CSCL-%DB%\cscl.sde
set CSCLREFRESH=%BASEPATH%\cscl-refresh\
set TOILER=%BASEPATH%\geodatabase-toiler\
set PYTHON1=C:\Progra~1\ArcGIS\Pro\bin\Python\envs\arcgispro-py3\python.exe
set PYTHON2=C:\Users\%USERNAME%\AppData\Local\Programs\ArcGIS\Pro\bin\Python\envs\arcgispro-py3\python.exe
if exist "%PYTHON1%" (
    set PROPY=%PYTHON1%
) else if exist "%PYTHON2%" (
    set PROPY=%PYTHON2%
) 
set PYTHONPATH=%TOILER%\src\py;%BASEPATH%\cscl-refresh\src\py
REM READ
CALL %PROPY% %CSCLREFRESH%grantall.py publicsafetyfeatureclasses view %READONLYROLE% 
CALL %PROPY% %CSCLREFRESH%grantall.py featuredatasets view %READONLYROLE% 
CALL %PROPY% %CSCLREFRESH%grantall.py featureclasses view %READONLYROLE% 
CALL %PROPY% %CSCLREFRESH%grantall.py tables view %READONLYROLE% 
REM EDIT1
CALL %PROPY% %CSCLREFRESH%grantall.py featuredatasets edit %EDITORROLE1% 
CALL %PROPY% %CSCLREFRESH%grantall.py featureclasses edit  %EDITORROLE1% 
CALL %PROPY% %CSCLREFRESH%grantall.py tables edit %EDITORROLE1% 
REM EDIT2
CALL %PROPY% %CSCLREFRESH%grantall.py featuredatasets edit %EDITORROLE2% 
CALL %PROPY% %CSCLREFRESH%grantall.py featureclasses edit  %EDITORROLE2% 
CALL %PROPY% %CSCLREFRESH%grantall.py tables edit %EDITORROLE2% 
REM EDIT3
CALL %PROPY% %CSCLREFRESH%grantall.py featuredatasets edit %EDITORROLE3% 
CALL %PROPY% %CSCLREFRESH%grantall.py featureclasses edit  %EDITORROLE3% 
CALL %PROPY% %CSCLREFRESH%grantall.py tables edit %EDITORROLE3% 
