{ lib
, buildPythonPackage
, fetchPypi
, jsonpickle
, wrapt
, requests
, future
, botocore
}:

buildPythonPackage rec {
  pname = "aws-xray-sdk";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ajazs3xzkk3rqx7kvzc4pgg7w6fnjsc8xs0w5s1y168ihk3fmgw";
  };

  propagatedBuildInputs = [
    jsonpickle wrapt requests future botocore
  ];

  meta = {
    description = "AWS X-Ray SDK for the Python programming language";
    license = lib.licenses.asl20;
    homepage = https://github.com/aws/aws-xray-sdk-python;
  };

  doCheck = false;
}
