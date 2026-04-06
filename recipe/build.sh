#!/bin/bash

# Common settings for all Unix systems
export USE_FFMPEG=OFF
export BUILD_SOX=OFF
export BUILD_RNNT=0
export BUILD_TORCHAUDIO_PYTHON_EXTENSION=ON
# export FFMPEG_ROOT=${PREFIX}

# Platform-specific settings
if [[ "${target_platform}" == osx* ]]; then
    # OSX specific settings
    export USE_OPENMP=ON
else
    # Linux specific settings
    export USE_OPENMP=OFF
fi

# CUDA specific settings
if [[ "${gpu_variant}" == "cuda" ]]; then
    # CUDA 13.x: dropped compute_50-70 (Maxwell/Pascal/Volta), min is 7.5 (Turing)
    export TORCH_CUDA_ARCH_LIST="7.5;8.0;8.6;8.9;9.0;10.0;10.3;12.0;12.1+PTX"
    export USE_CUDA=1
    export BUILD_CUDA_CTC_DECODER=1
fi

# Install package
${PYTHON} -m pip install . -vv --no-deps --no-build-isolation