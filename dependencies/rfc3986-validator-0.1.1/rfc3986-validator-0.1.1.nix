{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "rfc3986-validator";
  version = "0.1.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2f235c432ef459970b4306369336b9d5dbdda31b510ca1e327636e01f528bfa9";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
# rfc3986-validator

A pure python RFC3986 validator


[![image](https://img.shields.io/pypi/v/rfc3986_validator.svg)](https://pypi.python.org/pypi/rfc3986_validator)
[![Build Status](https://travis-ci.org/naimetti/rfc3986-validator.svg?branch=master)](https://travis-ci.org/naimetti/rfc3986-validator)

# Install

```shell script
pip install rfc3986-validator
```

# Usage

```pycon
>>> from rfc3986_validator import validate_rfc3986
>>> validate_rfc3986('http://foo.bar?q=Spaces should be encoded')
False

>>> validate_rfc3986('http://foo.com/blah_blah_(wikipedia)')
True
```

It also support validate [URI-reference](https://tools.ietf.org/html/rfc3986#page-49) rule 

```pycon
>>> validate_rfc3986('//foo.com/blah_blah', rule='URI_reference')
True
```

  - Free software: MIT license




'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
