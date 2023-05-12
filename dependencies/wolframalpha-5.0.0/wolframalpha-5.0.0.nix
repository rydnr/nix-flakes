{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "wolframalpha";
  version = "5.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "159f5d8fd31e4a734a34a9f3ae8aec4e9b2ef392607f82069b4a324b6b1831d5";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
.. image:: https://img.shields.io/pypi/v/wolframalpha.svg
   :target: `PyPI link`_

.. image:: https://img.shields.io/pypi/pyversions/wolframalpha.svg
   :target: `PyPI link`_

.. _PyPI link: https://pypi.org/project/wolframalpha

.. image:: https://github.com/jaraco/wolframalpha/workflows/tests/badge.svg
   :target: https://github.com/jaraco/wolframalpha/actions?query=workflow%3A%22tests%22
   :alt: tests

.. image:: https://img.shields.io/badge/code%20style-black-000000.svg
   :target: https://github.com/psf/black
   :alt: Code style: Black

.. image:: https://readthedocs.org/projects/wolframalpha/badge/?version=latest
   :target: https://wolframalpha.readthedocs.io/en/latest/?badge=latest

Python Client built against the `Wolfram|Alpha <http://wolframalpha.com>`_
v2.0 API.

Usage
=====

See the self-documenting source in
`the docs <https://wolframalpha.readthedocs.io/en/latest/?badge=latest>`_
for examples to get started.



'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
