{ lib
, buildPythonPackage
, fetchPypi
, cython
, nose
, pytest
, numpy
}:

buildPythonPackage rec {
  pname = "PyWavelets";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p3qv2v66ghnqrb1f98wyyhp9dz71jwcd6kfpsax65sfdpiyqp1w";
  };

  checkInputs = [ nose pytest ];

  buildInputs = [ cython ];

  propagatedBuildInputs = [ numpy ];

  # Somehow nosetests doesn't run the tests, so let's use pytest instead
  checkPhase = ''
    py.test pywt/tests
  '';

  meta = {
    description = "Wavelet transform module";
    homepage = https://github.com/PyWavelets/pywt;
    license = lib.licenses.mit;
  };

}
