{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "tensorflow-macos";
  version = "2.11.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bdbd1bb564d01bd735d6d11451f0658c3dd8187369ee9dd3ed6de6bbdd6df53";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
[![Python](https://img.shields.io/pypi/pyversions/tensorflow.svg?style=plastic)](https://badge.fury.io/py/tensorflow)
[![PyPI](https://badge.fury.io/py/tensorflow.svg)](https://badge.fury.io/py/tensorflow)

TensorFlow is an open source software library for high performance numerical
computation. Its flexible architecture allows easy deployment of computation
across a variety of platforms (CPUs, GPUs, TPUs), and from desktops to clusters
of servers to mobile and edge devices.

Originally developed by researchers and engineers from the Google Brain team
within Google's AI organization, it comes with strong support for machine
learning and deep learning and the flexible numerical computation core is used
across many other scientific domains. TensorFlow is licensed under [Apache
2.0](https://github.com/tensorflow/tensorflow/blob/master/LICENSE).

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
