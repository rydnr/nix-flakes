{ buildPythonPackage, fetchPypi, lib, setuptools }:

buildPythonPackage rec {
  pname = "anthropic";
  version = "0.2.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf4b69a9d25d573162accbe8aa9e022331c67a82519250ac30573ad506a1f663";
  };

  nativeBuildInputs = [ setuptools  ];

  propagatedBuildInputs = [  ];

  buildInputs = [  ];

  meta = with lib; {
    description = ''
# Anthropic Python SDK

This python repo provides access to Anthropic's safety-first language model APIs.

For more information on our APIs, please check out [Anthropic's documentation](https://console.anthropic.com/docs).

## How to use

```
pip install .
export ANTHROPIC_API_KEY=<insert token here>
python examples/basic_sync.py
python examples/basic_stream.py
python examples/count_tokens.py
```
'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
