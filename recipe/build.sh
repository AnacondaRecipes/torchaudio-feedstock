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
    # CUDA 12.8: cap at 10.0 (pytorch 2.10.0 doesn't support arch 10.1)
    export TORCH_CUDA_ARCH_LIST="5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9;9.0;10.0+PTX"
    export USE_CUDA=1
    export BUILD_CUDA_CTC_DECODER=1
fi

# Install package
${PYTHON} -m pip install . -vv --no-deps --no-build-isolation