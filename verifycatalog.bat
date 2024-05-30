set SDEFILE=C:\xxx\jdangermond.sde
set BASEPATH=C:\xxx
set CSCLREFRESH=%BASEPATH%\cscl-refresh\
set TOILER=%BASEPATH%\geodatabase-toiler\
set PROPY=c:\Progra~1\ArcGIS\Pro\bin\Python\envs\arcgispro-py3\python.exe
set PYTHONPATH=%TOILER%\src\py;%BASEPATH%\cscl-refresh\src\py
CALL %PROPY% %CSCLREFRESH%verifycatalog.py listoflists