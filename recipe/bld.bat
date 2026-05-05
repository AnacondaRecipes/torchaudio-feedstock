@echo off

set USE_FFMPEG=OFF
set BUILD_SOX=OFF
set USE_OPENMP=ON
set BUILD_TORCHAUDIO_PYTHON_EXTENSION=ON

:: Point the build system towards torch .lib files (needed for CUDA builds)
set LIB=%PREFIX%\Lib\site-packages\torch\lib;%LIB%

:: Point to build env's CUDA (nvcc is in build env, not host env)
set CUDA_HOME=%BUILD_PREFIX%\Library
set CUDA_PATH=%BUILD_PREFIX%\Library

:: CUDA 12.8: cap at 10.0 (pytorch 2.10.0 doesn't support arch 10.1)
set TORCH_CUDA_ARCH_LIST=5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9;9.0;10.0+PTX

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
