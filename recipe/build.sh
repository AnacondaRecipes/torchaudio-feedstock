#!/bin/bash

# Build flags since 2.11.0 (consumed by tools/setup_helpers/extension.py):
# BUILD_RNNT, BUILD_ALIGN, USE_CUDA, BUILD_CUDA_CTC_DECODER, BUILD_CPP_TEST.
# BUILD_RNNT is left at upstream's default (on), matching bld.bat. USE_OPENMP is
# read but has no effect since 2.11.0 (no OpenMP flags or pragmas), so it is not set.

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
fi

# Install package
${PYTHON} -m pip install . -vv --no-deps --no-build-isolation
