mkdir build && cd build
cmake ..
make

$PYTHON -m pip install . -vv --no-deps --no-build-isolation