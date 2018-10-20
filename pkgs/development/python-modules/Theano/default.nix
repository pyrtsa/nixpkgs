{ stdenv
, runCommandCC
, lib
, fetchPypi
, gcc
, buildPythonPackage
, isPyPy
, pythonOlder
, isPy3k
, nose
, numpy
, scipy
, six
, libgpuarray
, cudaSupport ? false, cudatoolkit
, cudnnSupport ? false, cudnn
, nvidia_x11
, version ? "1.0.3"
, sha256 ? "0nhiq95svqlqbj91wjfj4rf0iajs8wc0di6l9pay1x8fshs3nzv3"
}:

assert cudnnSupport -> cudaSupport;

assert cudaSupport -> nvidia_x11 != null
                   && cudatoolkit != null
                   && cudnn != null;

let
  libgpuarray_ = libgpuarray.override { inherit cudaSupport cudatoolkit; };

in buildPythonPackage rec {
  pname = "Theano";
  inherit version;

  disabled = isPyPy || pythonOlder "2.6" || (isPy3k && pythonOlder "3.3");

  src = fetchPypi {
    inherit pname version sha256;
  };

  postPatch = stdenv.lib.optionalString cudaSupport ''
    substituteInPlace theano/configdefaults.py \
      --replace 'StrParam(get_cuda_root)' 'StrParam('\'''${cudatoolkit}'\''')'
  '' + stdenv.lib.optionalString cudnnSupport ''
    substituteInPlace theano/configdefaults.py \
      --replace 'StrParam(default_dnn_base_path)' 'StrParam('\'''${cudnn}'\''')'
  '';

  preCheck = ''
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase
  '';
  doCheck = false;
  # takes far too long, also throws "TypeError: sort() missing 1 required positional argument: 'a'"
  # when run from the installer, and testing with Python 3.5 hits github.com/Theano/Theano/issues/4276,
  # the fix for which hasn't been merged yet.

  # keep Nose around since running the tests by hand is possible from Python or bash
  checkInputs = [ nose ];
  propagatedBuildInputs = [ numpy numpy.blas scipy six libgpuarray_ ];

  meta = with stdenv.lib; {
    homepage = http://deeplearning.net/software/theano/;
    description = "A Python library for large-scale array computation";
    license = licenses.bsd3;
    maintainers = with maintainers; [ maintainers.bcdarwin ];
  };
}
