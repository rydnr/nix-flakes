{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "opentelemetry-semantic-conventions";
  version = "0.38b0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0ba36e8b70bfaab16ee5a553d809309cc11ff58aec3d2550d451e79d45243a7";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
OpenTelemetry Semantic Conventions
==================================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-semantic-conventions.svg
   :target: https://pypi.org/project/opentelemetry-semantic-conventions/

This library contains generated code for the semantic conventions defined by the OpenTelemetry specification.

Installation
------------

::

    pip install opentelemetry-semantic-conventions

Code Generation
---------------

These files were generated automatically from code in semconv_.
To regenerate the code, run ``../scripts/semconv/generate.sh``.

To build against a new release or specific commit of opentelemetry-specification_,
update the ``SPEC_VERSION`` variable in
``../scripts/semconv/generate.sh``. Then run the script and commit the changes.

.. _opentelemetry-specification: https://github.com/open-telemetry/opentelemetry-specification
.. _semconv: https://github.com/open-telemetry/opentelemetry-python/tree/main/scripts/semconv


References
----------

* `OpenTelemetry Project <https://opentelemetry.io/>`_
* `OpenTelemetry Semantic Conventions YAML Definitions <https://github.com/open-telemetry/opentelemetry-specification/tree/main/semantic_conventions>`_
* `generate.sh script <https://github.com/open-telemetry/opentelemetry-python/blob/main/scripts/semconv/generate.sh>`_

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
