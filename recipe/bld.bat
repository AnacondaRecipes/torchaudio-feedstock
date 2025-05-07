@echo off

set USE_FFMPEG=ON
set BUILD_SOX=OFF
set USE_OPENMP=ON
set BUILD_TORCHAUDIO_PYTHON_EXTENSION=ON
set FFMPEG_ROOT=%LIBRARY_PREFIX%

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation