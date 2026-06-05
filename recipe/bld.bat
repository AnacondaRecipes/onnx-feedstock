@echo on
setlocal enabledelayedexpansion
set "ONNX_ML=1"
set CONDA_PREFIX=%LIBRARY_PREFIX%
set CMAKE_BUILD_TYPE=Release

REM MSVC reads CL for all compiles; avoids brittle CMAKE_CXX_FLAGS batch quoting
set "CL=/DPROTOBUF_USE_DLLS=1 /EHsc /std:c++17 %CL%"

REM Host python has nanobind; cmake find_package(Python) picks worker python on Windows
for /f "usebackq delims=" %%i in (`%PYTHON% -m nanobind --cmake_dir`) do set "NANOBIND_CMAKE_DIR=%%i"
if not defined NANOBIND_CMAKE_DIR (
  echo Failed to locate nanobind cmake config via %PYTHON% -m nanobind --cmake_dir
  exit /b 1
)
set "NB_DIR=!NANOBIND_CMAKE_DIR:\=/!"
set "PY_EXE=%PYTHON:\=/!"

set "CMAKE_ARGS=%CMAKE_ARGS% -DONNX_USE_PROTOBUF_SHARED_LIBS=ON -DProtobuf_USE_STATIC_LIBS=OFF -DONNX_USE_LITE_PROTO=ON -DNPY_TARGET_VERSION=NPY_1_19_API_VERSION -DFETCHCONTENT_FULLY_DISCONNECTED=ON -Dnanobind_DIR=!NB_DIR! -DPython_EXECUTABLE=!PY_EXE!"
set USE_MSVC_STATIC_RUNTIME=0
%PYTHON% -m pip install --no-deps --ignore-installed --no-build-isolation --verbose .
