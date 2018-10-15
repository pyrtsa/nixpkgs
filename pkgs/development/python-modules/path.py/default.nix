{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, importlib-metadata
, backports_os
, setuptools_scm
, pytestrunner
, pytest
, glibcLocales
, packaging
, pythonOlder
}:

with lib;

buildPythonPackage rec {
  pname = "path.py";
  version = "11.5.0";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jxkf91syzxlpiwgm83fjfz1m5xh3jrvv4iyl5wjsnkk599pls5n";
  };

  checkInputs = [ pytest pytestrunner glibcLocales packaging ];
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [
    importlib-metadata
    (optional (pythonOlder "3" && stdenv.isLinux) backports_os)
  ];

  LC_ALL="en_US.UTF-8";

  meta = {
    description = "A module wrapper for os.path";
    homepage = https://github.com/jaraco/path.py;
    license = lib.licenses.mit;
  };

  prePatch = ''
    # `test_import_time` is overly brittle, even on Python 3.6 sometimes.
    # See https://github.com/jaraco/path.py/issues/153.
    substituteInPlace test_path.py \
      --replace "limit = datetime.timedelta(milliseconds=100)" \
                "limit = datetime.timedelta(milliseconds=400)"
    '';

  checkPhase = ''
    # Ignore pytest configuration
    rm pytest.ini
    py.test test_path.py
  '';
}
