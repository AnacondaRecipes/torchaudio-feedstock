@echo off

REM 2.11.0 build flags (consumed by tools/setup_helpers/extension.py):
REM BUILD_RNNT, BUILD_ALIGN, USE_OPENMP, USE_CUDA, BUILD_CUDA_CTC_DECODER, BUILD_CPP_TEST.
REM USE_FFMPEG/BUILD_SOX/BUILD_TORCHAUDIO_PYTHON_EXTENSION dropped: 2.11.0 no longer uses CMake.
set USE_OPENMP=ON

:: Point the build system towards torch .lib files (needed for CUDA builds)
:: CUDA 13.x installs .lib files to Library\lib\x64 (changed from Library\lib in 12.x)
if "%cuda_compiler_version:~0,2%" == "13" (
  set LIB=%PREFIX%\Lib\site-packages\torch\lib;%LIBRARY_LIB%;%LIBRARY_PREFIX%\lib\x64;%LIB%
) else (
  set LIB=%PREFIX%\Lib\site-packages\torch\lib;%LIBRARY_LIB%;%LIB%
)

:: Point to build env's CUDA (nvcc is in build env, not host env)
set CUDA_HOME=%BUILD_PREFIX%\Library
set CUDA_PATH=%BUILD_PREFIX%\Library

:: Match pytorch-feedstock's CUDA arch list (libtorch ABI alignment); same for 12.9 and 13.0 on win-64 (x86_64 only)
set TORCH_CUDA_ARCH_LIST=7.5;8.0;8.6;9.0;10.0;12.0+PTX

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
