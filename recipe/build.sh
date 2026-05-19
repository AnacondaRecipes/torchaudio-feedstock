#!/bin/bash

# 2.11.0 build flags (consumed by tools/setup_helpers/extension.py):
# BUILD_RNNT, BUILD_ALIGN, USE_OPENMP, USE_CUDA, BUILD_CUDA_CTC_DECODER, BUILD_CPP_TEST.
# USE_FFMPEG/BUILD_SOX/BUILD_TORCHAUDIO_PYTHON_EXTENSION dropped: 2.11.0 no longer uses CMake.
export BUILD_RNNT=0

# Platform-specific OpenMP settings
if [[ "${target_platform}" == osx* ]]; then
    export USE_OPENMP=ON
else
    export USE_OPENMP=OFF
fi

# CUDA specific settings
if [[ "${gpu_variant}" == "cuda" ]]; then
    # Match pytorch-feedstock's CUDA arch list (libtorch ABI alignment with pytorch on pkgs/main)
    if [[ "$(uname -m)" == "aarch64" ]]; then
        # aarch64 CUDA 13: includes sm_11.0 (Grace-Hopper) and sm_12.1+PTX (Blackwell DGX Spark)
        export TORCH_CUDA_ARCH_LIST="8.0;9.0;10.0;11.0;12.0;12.1+PTX"
    else
        # x86_64 CUDA 12.x / 13.x: same list (12.0+PTX for Blackwell forward-compat)
        export TORCH_CUDA_ARCH_LIST="7.5;8.0;8.6;9.0;10.0;12.0+PTX"
    fi
    export USE_CUDA=1
    export BUILD_CUDA_CTC_DECODER=1
    # CUDA 12.x requires gcc <14.0 per torch/utils/cpp_extension.py CUDA_GCC_VERSIONS,
    # but pkgs/main only ships gcc 14.3.0 — same gcc that built pytorch 2.11. Bypass
    # the consumer-side check; the libstdc++ ABI is consistent.
    if [[ "${cuda_compiler_version:0:2}" == "12" ]]; then
        export TORCH_DONT_CHECK_COMPILER_ABI=1
    fi
fi

# Install package
${PYTHON} -m pip install . -vv --no-deps --no-build-isolation
