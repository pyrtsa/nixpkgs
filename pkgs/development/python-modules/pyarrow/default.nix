{ lib, buildPythonPackage, python, isPy3k, fetchurl, arrow-cpp, cmake, cython, futures, JPype1, jdk, numpy, pandas, pytest, pytestrunner, pkgconfig, setuptools_scm, six }:

let
  _arrow-cpp = arrow-cpp.override { inherit python; };
in

buildPythonPackage rec {
  pname = "pyarrow";

  inherit (_arrow-cpp) version src;

  sourceRoot = "apache-arrow-${version}/python";

  nativeBuildInputs = [ cmake cython pkgconfig setuptools_scm ];
  propagatedBuildInputs = [ numpy six ] ++ lib.optionals (!isPy3k) [ futures ];
  checkInputs = [ pandas pytest pytestrunner JPype1 jdk ];

  PYARROW_BUILD_TYPE = "release";
  PYARROW_CMAKE_OPTIONS = "-DCMAKE_INSTALL_RPATH=${ARROW_HOME}/lib";

  arrowToolsJar = fetchurl {
    url = "https://search.maven.org/remotecontent?filepath=org/apache/arrow/arrow-tools/${version}/arrow-tools-${version}-jar-with-dependencies.jar";
    sha256 = "0snj0d72nfxfj2zl0r9fq6lf1yqmp4h4kxg8i585l951rqnw5mxz";
  };

  preCheck = ''
    rm pyarrow/tests/test_hdfs.py
    rm pyarrow/tests/test_cuda.py

    # fails: "ArrowNotImplementedError: Unsupported numpy type 22"
    substituteInPlace pyarrow/tests/test_feather.py --replace "test_timedelta_with_nulls" "_disabled"

    # runs out of memory on @grahamcofborg linux box
    substituteInPlace pyarrow/tests/test_feather.py --replace "test_large_dataframe" "_disabled"

    # probably broken on python2
    substituteInPlace pyarrow/tests/test_feather.py --replace "test_unicode_filename" "_disabled"
  '';

  checkPhase = ''
    mkdir pyarrow-tests-alone
    cp -r pyarrow/tests pyarrow-tests-alone/tests

    export ARROW_TOOLS_JAR=${arrowToolsJar}
    PYARROW_PYTEST_FLAGS=" -r sxX --durations=15 --parquet"
    ${pytest}/bin/pytest $PYARROW_PYTEST_FLAGS pyarrow-tests-alone/tests
  '';

  ARROW_HOME = _arrow-cpp;
  PARQUET_HOME = _arrow-cpp;

  setupPyBuildFlags = ["--with-parquet" ];

  meta = with lib; {
    description = "A cross-language development platform for in-memory data";
    homepage = https://arrow.apache.org/;
    license = lib.licenses.asl20;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
