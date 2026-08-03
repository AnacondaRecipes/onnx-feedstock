@echo on
set "ONNX_ML=1"
set CONDA_PREFIX=%LIBRARY_PREFIX%
set CMAKE_BUILD_TYPE=Release
set CMAKE_BUILD_PARALLEL_LEVEL=%CPU_COUNT%
set CMAKE_GENERATOR_PLATFORM=
set CMAKE_GENERATOR_TOOLSET=
SET CMAKE_GENERATOR=Ninja

REM MSVC reads CL for all compiles; avoids brittle CMAKE_CXX_FLAGS batch quoting
set "CL=/DPROTOBUF_USE_DLLS=1 /EHsc /std:c++17 %CL%"

REM conda-build rewrites bld.bat (%PYTHON:\=/% breaks; !VAR! is not expanded)
for /f "usebackq delims=" %%i in (`%PYTHON% -c "import os,subprocess,sys; nb=subprocess.check_output([sys.executable,'-m','nanobind','--cmake_dir'],text=True).strip().replace(chr(92),'/'); py=sys.executable.replace(chr(92),'/'); args=os.environ.get('CMAKE_ARGS',''); args+=' -DONNX_USE_PROTOBUF_SHARED_LIBS=ON -DProtobuf_USE_STATIC_LIBS=OFF -DONNX_USE_LITE_PROTO=ON -DNPY_TARGET_VERSION=NPY_1_19_API_VERSION -DFETCHCONTENT_FULLY_DISCONNECTED=ON'; args+=f' -Dnanobind_DIR={nb} -DPython_EXECUTABLE={py}'; print(args)"`) do set "CMAKE_ARGS=%%i"

set USE_MSVC_STATIC_RUNTIME=0
%PYTHON% -m pip install --no-deps --ignore-installed --no-build-isolation --verbose .
if errorlevel 1 exit /b 1

cmake -S . -B .setuptools-cmake-build %CMAKE_ARGS% ^
    -DONNX_BUILD_PYTHON=OFF ^
    -DBUILD_SHARED_LIBS=ON ^
    -DONNX_INSTALL=ON
if errorlevel 1 exit /b 1

cmake --build .setuptools-cmake-build
if errorlevel 1 exit /b 1

cmake --install .setuptools-cmake-build
if errorlevel 1 exit /b 1
