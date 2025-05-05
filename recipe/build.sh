#!/bin/bash

# Common settings for all Unix systems
export USE_FFMPEG=ON
export BUILD_SOX=OFF
export BUILD_TORCHAUDIO_PYTHON_EXTENSION=ON
export FFMPEG_ROOT=${PREFIX}

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
    export TORCH_CUDA_ARCH_LIST="5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9;9.0+PTX"
    export CUDA_TOOLKIT_ROOT_DIR=${PREFIX}
    export CUDA_HOME=${PREFIX}
    export USE_CUDA=1
    export BUILD_CUDA_CTC_DECODER=1
    # Ensure CUDA paths are set correctly
    export CMAKE_ARGS="-DCUDA_TOOLKIT_ROOT_DIR=${PREFIX} -DCUDA_INCLUDE_DIRS=${PREFIX}/include"
fi

# Install package
${PYTHON} -m pip install . -vv --no-deps --no-build-isolation