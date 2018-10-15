{ lib
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
, setuptools_scm
, hypothesis
, future
}:

with lib;

buildPythonPackage rec {
  pname = "backports.os";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c26nyvm05hwk8b7axvnn8glzhshpf62l2y9ish6qc4l629w8wml";
  };

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ (optional (pythonOlder "3") future) ];
  checkInputs = [ hypothesis ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = {
    homepage = https://github.com/pjdelport/backports.os;
    license = lib.licenses.psfl;
    description = "Backport of new features in Python's os module";
  };
}
