echo %MATLAB_HOME%
mex -f "%MATLAB_HOME%\bin\win64\mexopts\msvc100engmatopts.bat" matlabShell.c
