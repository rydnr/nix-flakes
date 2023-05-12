{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "elastic-transport";
  version = "8.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19db271ab79c9f70f8c43f8f5b5111408781a6176b54ab2e54d713b6d9ceb815";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
# elastic-transport-python

[![PyPI](https://img.shields.io/pypi/v/elastic-transport)](https://pypi.org/elastic-transport)
[![Python Versions](https://img.shields.io/pypi/pyversions/elastic-transport)](https://pypi.org/elastic-transport)
[![PyPI Downloads](https://pepy.tech/badge/elastic-transport)](https://pepy.tech/project/elastic-transport)
[![CI Status](https://img.shields.io/github/workflow/status/elastic/elastic-transport-python/CI/main)](https://github.com/elastic/elastic-transport-python/actions)

Transport classes and utilities shared among Python Elastic client libraries

This library was lifted from [`elasticsearch-py`](https://github.com/elastic/elasticsearch-py)
and then transformed to be used across all Elastic services
rather than only Elasticsearch.

### Installing from PyPI

```
$ python -m pip install elastic-transport
```

Versioning follows the major and minor version of the Elastic Stack version and
the patch number is incremented for bug fixes within a minor release.                      |

## Documentation

Documentation including an API reference is available on [Read the Docs](https://elastic-transport-python.readthedocs.io).

## License

`elastic-transport-python` is available under the Apache-2.0 license.
For more details see [LICENSE](https://github.com/elastic/elastic-transport-python/blob/main/LICENSE).

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
