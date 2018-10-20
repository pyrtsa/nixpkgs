{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, matplotlib ? null
, nose
, numpy
, pytest
, pyyaml
, scikitlearn ? null
, six
, tables ? null
, Theano
}:

buildPythonPackage rec {
  pname = "pylearn2";
  version = "2017-05-25";

  src = fetchFromGitHub {
    owner = "lisa-lab";
    repo = "pylearn2";
    rev = "58ba37286182817301ed72b0f143a89547b3f011";
    sha256 = "11a3y0sqycydgpfbflf939bj8i7j00i3jyrs95b0qhqifv91v4kc";
  };

  checkInputs = [ nose pytest matplotlib scikitlearn tables ];
  buildInputs = [ cython ];
  propagatedBuildInputs = [ numpy pyyaml six Theano ];

  prePatch = ''
    # The developers of pylearn2 don't want to support the `python setup.py
    # install` workflow. But with Nix, their concerns aren't really valid.
    substituteInPlace setup.py \
      --replace "cmdclass.update({'install': pylearn2_install})" \
                "# cmdclass.update({'install': pylearn2_install})"

    # Argparse is nowadays part of the stdlib.
    substituteInPlace setup.py \
      --replace ", 'argparse'" ""
  '';
  patches = [
    ./pylearn2-should-just-import-six.patch
  ];
  postPatch = ''
    rm pylearn2/models/setup.py
    rm pylearn2/models/_kmeans.pyx
  '';

  preBuild = ''
    export THEANO_FLAGS=base_compiledir=$PWD/.theano
  '';

  checkPhase = ''
    echo "### SKIPPING TESTS FOR NOW. TO RESTORE, PLEASE FIX pkgs/development/python-modules/pylearn2/default.nix ###"
  '';

  meta = {
    description = "A machine learning library built on top of Theano.";
    homepage = https://github.com/lisa-lab/pylearn2;
    license = lib.licenses.bsd3;
  };

}
