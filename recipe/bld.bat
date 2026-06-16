@echo off

REM 2.11.0 build flags (consumed by tools/setup_helpers/extension.py):
REM BUILD_RNNT, BUILD_ALIGN, USE_OPENMP, USE_CUDA, BUILD_CUDA_CTC_DECODER, BUILD_CPP_TEST.
REM USE_FFMPEG/BUILD_SOX/BUILD_TORCHAUDIO_PYTHON_EXTENSION dropped: 2.11.0 no longer uses CMake.
set USE_OPENMP=ON

:: Point the build system towards torch .lib files (needed for CUDA builds)
:: CUDA 13.x installs .lib files to Library\lib\x64 (added unconditionally; harmless on 12.x since the directory simply doesn't exist there)
set "LIB=%PREFIX%\Lib\site-packages\torch\lib;%LIBRARY_LIB%;%LIBRARY_PREFIX%\lib\x64;%LIB%"

:: Point to build env's CUDA (nvcc is in build env, not host env)
set "CUDA_HOME=%BUILD_PREFIX%\Library"
set "CUDA_PATH=%BUILD_PREFIX%\Library"

:: Match pytorch-feedstock's CUDA arch list. CUDA 12.9 on Win-MSVC hits a
:: clusterlaunchcontrol.h inline-asm bug (uses "l" 64-bit constraint with 32-bit
:: long2.x on Windows LLP64; fixed in CUDA 12.9.1 / 13.x). Drop sm_100/sm_120
:: on CUDA 12.x to avoid pulling that header in via torchaudio's
:: forced_align/gpu/compute.cu. CUDA 13.x keeps the full list.
if "%cuda_compiler_version:~0,2%" == "12" (
  set "TORCH_CUDA_ARCH_LIST=7.5;8.0;8.6;9.0"
) else (
  set "TORCH_CUDA_ARCH_LIST=7.5;8.0;8.6;9.0;10.0;12.0+PTX"
)

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
