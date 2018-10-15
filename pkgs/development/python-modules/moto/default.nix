{ buildPythonPackage, fetchPypi, jinja2, werkzeug, flask
, requests, pytz, backports_tempfile, cookies, jsondiff, botocore, aws-xray-sdk, docker, responses
, six, boto, httpretty, xmltodict, nose, sure, boto3, freezegun, dateutil, mock, pyaml, python-jose }:

buildPythonPackage rec {
  pname = "moto";
  version = "1.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fwwf0234v0fk6wqqr6623qfpz0cg4anq51cq00s1nfbal6hmzjq";
  };

  postPatch = ''
    # dateutil upper bound was just to keep compatibility with Python 2.6
    # see https://github.com/spulec/moto/pull/1519 and https://github.com/boto/botocore/pull/1402
    # regarding aws-xray-sdk: https://github.com/spulec/moto/commit/31eac49e1555c5345021a252cb0c95043197ea16
    substituteInPlace setup.py \
      --replace "python-dateutil<2.7.0" "python-dateutil<3.0.0" \
      --replace "aws-xray-sdk<0.96," "aws-xray-sdk" \
      --replace "jsondiff==1.1.1" "jsondiff>=1.1.1" \
      --replace "boto3>=1.6.16,<1.8" "boto3>=1.6.16,<1.10" \
      --replace "botocore>=1.9.16,<1.11" "botocore>=1.9.16,<1.13" \
      --replace "python-jose<3.0.0" "python-jose<3.1.0"
  '';

  propagatedBuildInputs = [
    aws-xray-sdk
    boto
    boto3
    dateutil
    flask
    httpretty
    jinja2
    pytz
    werkzeug
    requests
    six
    xmltodict
    mock
    pyaml
    backports_tempfile
    cookies
    jsondiff
    botocore
    docker
    responses
    python-jose
  ];

  checkInputs = [ boto3 nose sure freezegun ];

  checkPhase = "nosetests";

  # TODO: make this true; I think lots of the tests want network access but we can probably run the others
  doCheck = false;
}
