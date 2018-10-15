{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm }:
buildPythonPackage rec {
  pname = "py";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "152nyjvd8phqbm9pwlnfx0xi4c6343hakjzg42sp4qw3k1qn74mz";
  };

  # Circular dependency on pytest
  doCheck = false;

  buildInputs = [ setuptools_scm ];

  meta = with stdenv.lib; {
    description = "Library with cross-python path, ini-parsing, io, code, log facilities";
    homepage = http://pylib.readthedocs.org/;
    license = licenses.mit;
  };
}
