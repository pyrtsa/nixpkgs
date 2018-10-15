{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytest_xdist, virtualenv, process-tests, coverage }:

buildPythonPackage rec {
  pname = "pytest-cov";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qnpp9y3ygx4jk4pf5ad71fh2skbvnr6gl54m7rg5qysnx4g0q73";
  };

  buildInputs = [ pytest pytest_xdist virtualenv process-tests ];
  propagatedBuildInputs = [ coverage ];

  # xdist related tests fail with the following error
  # OSError: [Errno 13] Permission denied: 'py/_code'
  doCheck = false;
  checkPhase = ''
    # allow to find the module helper during the test run
    export PYTHONPATH=$PYTHONPATH:$PWD/tests
    py.test tests
  '';

  meta = with stdenv.lib; {
    description = "Plugin for coverage reporting with support for both centralised and distributed testing, including subprocesses and multiprocessing";
    homepage = https://github.com/pytest-dev/pytest-cov;
    license = licenses.mit;
  };
}
