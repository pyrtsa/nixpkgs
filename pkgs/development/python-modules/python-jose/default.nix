{ stdenv, buildPythonPackage, fetchFromGitHub
, future, six, rsa, ecdsa, pycryptodome, pytest, pytestcov, cryptography
}:

buildPythonPackage rec {
  pname = "python-jose";
  version = "3.0.1";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "mpdavis";
    repo = "python-jose";
    rev = version;
    sha256 = "1ahq4m86z504bnlk9z473r7r3dprg5m39900rld797hbczdhqa4f";
  };

  checkInputs = [
    pytest
    pytestcov
    cryptography # optional dependency, but needed in tests
  ];
  checkPhase = ''
    py.test
  '';

  propagatedBuildInputs = [ future six rsa ecdsa pycryptodome ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mpdavis/python-jose;
    description = "A JOSE implementation in Python";
    license = licenses.mit;
    maintainers = [ maintainers.jhhuh ];
  };
}
