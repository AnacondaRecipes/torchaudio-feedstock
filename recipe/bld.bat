@echo off

REM Build flags since 2.11.0 (consumed by tools/setup_helpers/extension.py):
REM BUILD_RNNT, BUILD_ALIGN, USE_CUDA, BUILD_CUDA_CTC_DECODER, BUILD_CPP_TEST.
REM BUILD_RNNT is left at upstream's default (on), matching build.sh. USE_OPENMP is
REM read but has no effect since 2.11.0 (no OpenMP flags or pragmas), so it is not set.

REM Point the build system towards torch .lib files (needed for CUDA builds)
REM CUDA 13.x installs .lib files to Library\lib\x64 (added unconditionally; harmless on 12.x since the directory simply doesn't exist there)
set "LIB=%PREFIX%\Lib\site-packages\torch\lib;%LIBRARY_LIB%;%LIBRARY_PREFIX%\lib\x64;%LIB%"

REM Point to build env's CUDA (nvcc is in build env, not host env)
set "CUDA_HOME=%BUILD_PREFIX%\Library"
set "CUDA_PATH=%BUILD_PREFIX%\Library"

REM CUDA 13.x: same arch list as pytorch-feedstock's win-64 build.
REM CUDA 12.9 (incl. nvcc 12.9.86 on pkgs/main): CCCL's cuda/__ptx clusterlaunchcontrol.h
REM fails under MSVC for sm_100/sm_120 (asm operand size 4 vs constraint 'l'; hit by
REM forced_align/gpu/compute.cu), so stop at sm_90 and ship compute_90 PTX, which the
REM driver JIT-compiles on Blackwell and newer GPUs.
if "%cuda_compiler_version:~0,2%" == "12" (
  set "TORCH_CUDA_ARCH_LIST=7.5;8.0;8.6;9.0+PTX"
) else (
  set "TORCH_CUDA_ARCH_LIST=7.5;8.0;8.6;9.0;10.0;12.0+PTX"
)

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
