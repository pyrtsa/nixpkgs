{ buildPythonPackage
, fetchPypi
, dateutil
, jmespath
, docutils
, ordereddict
, simplejson
, urllib3
, mock
, nose
}:

buildPythonPackage rec {
  pname = "botocore";
  version = "1.12.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a16zap2n8gps2d0mklsqmzczr6c4sy9r4xvjpky1nj0a3d8xdm8";
  };

  propagatedBuildInputs = [
    dateutil
    jmespath
    docutils
    ordereddict
    simplejson
    urllib3
  ];

  checkInputs = [ mock nose ];

  checkPhase = ''
    nosetests -v
  '';

  # Network access
  doCheck = false;

  meta = {
    homepage = https://github.com/boto/botocore;
    license = "bsd";
    description = "A low-level interface to a growing number of Amazon Web Services";
  };
}
