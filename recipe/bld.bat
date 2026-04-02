@echo off

set USE_FFMPEG=OFF
set BUILD_SOX=OFF
set USE_OPENMP=ON
set BUILD_TORCHAUDIO_PYTHON_EXTENSION=ON

:: Point the build system towards torch .lib files (needed for CUDA builds)
set LIB=%PREFIX%\Lib\site-packages\torch\lib;%LIB%

:: CUDA 13.x: dropped compute_50-61, min is 7.0 (Volta)
set TORCH_CUDA_ARCH_LIST=7.0;7.5;8.0;8.6;8.9;9.0;10.0+PTX

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation