{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "atomicwrites";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hwhp1z0dswl7mpj4bfdg2maprk2kd5w4fbkxwchkyg01zak8qz1";
  };

  meta = with stdenv.lib; {
    description = "Atomic file writes on POSIX";
    homepage = https://pypi.python.org/pypi/atomicwrites;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
