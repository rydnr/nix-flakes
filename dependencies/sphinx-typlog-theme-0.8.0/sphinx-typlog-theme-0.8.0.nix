{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "sphinx-typlog-theme";
  version = "0.8.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0ab728ab31d071523af0229bcb6427a13493958b3fc2bb7db381520fab77de4";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
Sphinx Typlog Theme
===================

A sphinx theme sponsored by Typlog_, created by `Hsiaoming Yang`_.

.. image:: https://badgen.net/badge/donate/lepture/ff69b4
   :target: https://lepture.com/donate
   :alt: Donate lepture
.. image:: https://badgen.net/badge//patreon/f96854?icon=patreon
   :target: https://patreon.com/lepture
   :alt: Become a patreon
.. image:: https://badgen.net/pypi/v/sphinx-typlog-theme
   :target: https://pypi.python.org/pypi/sphinx-typlog-theme/
   :alt: Latest Version
.. image:: https://img.shields.io/pypi/wheel/sphinx-typlog-theme.svg
   :target: https://pypi.python.org/pypi/sphinx-typlog-theme/
   :alt: Wheel Status

.. _Typlog: https://typlog.com/
.. _`Hsiaoming Yang`: https://lepture.com/

Examples
--------

Here are some examples which are using this theme:

- https://sphinx-typlog-theme.readthedocs.io/
- https://docs.authlib.org/
- https://webargs.readthedocs.io/



'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
