@echo off

set USE_FFMPEG=OFF
set BUILD_SOX=OFF
set USE_OPENMP=ON
set BUILD_TORCHAUDIO_PYTHON_EXTENSION=ON

:: Point the build system towards torch .lib files (needed for CUDA builds)
:: CUDA 13.x installs .lib files to Library\lib\x64 (changed from Library\lib in 12.x)
set LIB=%PREFIX%\Lib\site-packages\torch\lib;%LIBRARY_LIB%;%LIBRARY_PREFIX%\lib\x64;%LIB%

:: Point to build env's CUDA (nvcc is in build env, not host env)
set CUDA_HOME=%BUILD_PREFIX%\Library
set CUDA_PATH=%BUILD_PREFIX%\Library

:: CUDA 13.x: dropped compute_50-61, min is 7.5 (Turing)
set TORCH_CUDA_ARCH_LIST=7.5;8.0;8.6;8.9;9.0;10.0;10.3;12.0;12.1+PTX

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
