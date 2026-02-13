set SDEFILE=C:\xxx\jdangermond.sde
set BASEPATH=C:\xxx
set CSCLREFRESH=%BASEPATH%\cscl-refresh\
set TOILER=%BASEPATH%\geodatabase-toiler\
if exist "%PYTHON1%" (
    set PROPY=%PYTHON1%
) else if exist "%PYTHON2%" (
    set PROPY=%PYTHON2%
) 
set PYTHONPATH=%TOILER%\src\py;%BASEPATH%\cscl-refresh\src\py
CALL %PROPY% %CSCLREFRESH%verifycatalog.py listoflists