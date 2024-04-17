:: cmd
echo "Building %PKG_NAME%."

set "ONNX_ML=1"
set CONDA_PREFIX=%LIBRARY_PREFIX%
set CMAKE_GENERATOR="Visual Studio 16 2019"
set CMAKE_BUILD_TYPE=Release
set CMAKE_ARGS="-DONNX_USE_PROTOBUF_SHARED_LIBS=ON -DProtobuf_USE_STATIC_LIBS=OFF -DONNX_USE_LITE_PROTO=ON"
set "PYTHON_EXECUTABLE=%PYTHON%"
set "PYTHON_LIBRARIES=%LIBRARY_LIB%"
set USE_MSVC_STATIC_RUNTIME=0
%PYTHON% -m pip install --no-deps --ignore-installed --no-build-isolation --verbose .
