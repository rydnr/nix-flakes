{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "sphinxcontrib-jquery";
  version = "4.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f936030d7d0147dd026a4f2b5a57343d233f1fc7b363f68b3d4f1cb0993878ae";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
======================
 sphinxcontrib-jquery
======================

.. image:: https://img.shields.io/pypi/v/sphinxcontrib-jquery.svg
   :target: https://pypi.org/project/sphinxcontrib-jquery/
   :alt: Package on PyPI

``sphinxcontrib-jquery`` ensures that jQuery is always installed for use in
Sphinx themes or extensions.

To use it, add ``sphinxcontrib.jquery`` as a Sphinx extension:

.. code:: python

   # conf.py

   extensions = [
       "sphinxcontrib.jquery",
   ]
   ...


Configuration
-------------

.. As this is a README, we restrict the directives we use to those which GitHub
   renders correctly. This means that we cannot use ``versionadded``,
   ``confval``, ``warning``, or other similar directives.
   We use a reStructuredText definition list to emulate the ``confval``
   rendering.
   We use inline **bold** syntax as a poor-man's ``.. warning::`` directive.

``jquery_use_sri``
   A boolean value controlling whether to enable  `subresource integrity`_ (SRI)
   checks for JavaScript files that this extension loads.

   The default is ``False``.

   **Warning**: Enabling SRI checks may break documentation when loaded from
   local filesystem (``file:///`` URIs).

   *New in version 4.0.*

   .. _subresource integrity: https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity


'';
    license = licenses.mit;
    homepage = "https://github.com/sphinx-contrib/jquery/";
    maintainers = with maintainers; [ ];
  };
}
