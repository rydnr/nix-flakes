{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "jupyter-server-terminals";
  version = "0.4.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "75779164661cec02a8758a5311e18bb8eb70c4e86c6b699403100f1585a12a36";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
# Jupyter Server Terminals

[![Build Status](https://github.com/jupyter-server/jupyter_server_terminals/actions/workflows/test.yml/badge.svg?query=branch%3Amain++)](https://github.com/jupyter-server/jupyter_server_terminals/actions?query=branch%3Amain++)
[![codecov](https://codecov.io/gh/jupyter-server/jupyter_server_terminals/branch/main/graph/badge.svg?token=6OPBSEMMUG)](https://codecov.io/gh/jupyter-server/jupyter_server_terminals)
[![Documentation Status](https://readthedocs.org/projects/jupyter-server-terminals/badge/?version=latest)](http://jupyter-server-terminals.readthedocs.io/en/latest/?badge=latest)

Jupyter Server Terminals is a Jupyter Server Extension providing support for terminals.

## Installation and Basic usage

To install the latest release locally, make sure you have
[pip installed](https://pip.readthedocs.io/en/stable/installing/) and run:

```
pip install jupyter_server_terminals
```

Jupyter Server Terminals currently supports Python>=3.6 on Linux, OSX and Windows.

### Testing

See [CONTRIBUTING](./CONTRIBUTING.rst#running-tests).

## Contributing

If you are interested in contributing to the project, see [CONTRIBUTING](./CONTRIBUTING.rst).

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}