@echo off

set USE_FFMPEG=OFF
set BUILD_SOX=OFF
set USE_OPENMP=ON
set BUILD_TORCHAUDIO_PYTHON_EXTENSION=ON

:: Point the build system towards torch .lib files (needed for CUDA builds)
set LIB=%PREFIX%\Lib\site-packages\torch\lib;%LIB%

:: Point cmake to conda env's CUDA, not system CUDA (avoids header version mismatch)
set CUDA_HOME=%LIBRARY_PREFIX%
set CUDA_PATH=%LIBRARY_PREFIX%

:: CUDA 13.x: dropped compute_50-61, min is 7.5 (Turing)
set TORCH_CUDA_ARCH_LIST=7.5;8.0;8.6;8.9;9.0;10.0;10.3;12.0;12.1+PTX

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation