{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "clickhouse-connect";
  version = "0.5.20";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c29cf8b2c90eed6b83366c13ab5ad471ff6ef2e334f35818729330854b9747ac";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
## ClickHouse Connect

A suite of Python packages for connecting Python to ClickHouse:
* Pandas DataFrames
* Numpy Arrays
* PyArrow Tables
* SQLAlchemy 1.3 and 1.4 (limited feature set)
* Apache Superset 1.4+


### Complete Documentation
The documentation for ClickHouse Connect has moved to
[ClickHouse Docs](https://clickhouse.com/docs/en/integrations/language-clients/python/intro) 


### Installation

```
pip install clickhouse-connect
```

ClickHouse Connect requires Python 3.7 or higher.  

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}