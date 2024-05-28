set BASEPATH=C:\xxx
set VERYIMPORTANTROLE=XXX
set DB=XXXX
set SDEFILE=%BASEPATH%\Connections\oracle19c\dev\CSCL-%DB%\cscl.sde
set TOILER=%BASEPATH%\geodatabase-toiler\
set PROPY=c:\Progra~1\ArcGIS\Pro\bin\Python\envs\arcgispro-py3\python.exe
set PYTHONPATH=%TOILER%\src\py;%BASEPATH%\cscl-refresh\src\py
CALL %PROPY% %TAXTOILREPO%grantall.py tables view %VERYIMPORTANTROLE% 
