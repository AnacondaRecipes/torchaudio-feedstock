@echo off

set USE_FFMPEG=OFF
set BUILD_SOX=OFF
set USE_OPENMP=ON
set BUILD_TORCHAUDIO_PYTHON_EXTENSION=ON

:: Point the build system towards torch .lib files (needed for CUDA builds)
set LIB=%PREFIX%\Lib\site-packages\torch\lib;%LIB%

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation