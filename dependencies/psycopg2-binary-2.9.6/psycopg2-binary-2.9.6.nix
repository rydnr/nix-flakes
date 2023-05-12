{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "psycopg2-binary";
  version = "2.9.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d26e0342183c762de3276cca7a530d574d4e25121ca7d6e4a98e4f05cb8e4df7";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
Psycopg is the most popular PostgreSQL database adapter for the Python
programming language.  Its main features are the complete implementation of
the Python DB API 2.0 specification and the thread safety (several threads can
share the same connection).  It was designed for heavily multi-threaded
applications that create and destroy lots of cursors and make a large number
of concurrent "INSERT"s or "UPDATE"s.

Psycopg 2 is mostly implemented in C as a libpq wrapper, resulting in being
both efficient and secure.  It features client-side and server-side cursors,
asynchronous communication and notifications, "COPY TO/COPY FROM" support.
Many Python types are supported out-of-the-box and adapted to matching
PostgreSQL data types; adaptation can be extended and customized thanks to a
flexible objects adaptation system.

Psycopg 2 is both Unicode and Python 3 friendly.


Documentation
-------------

Documentation is included in the ``doc`` directory and is `available online`__.

.. __: https://www.psycopg.org/docs/

For any other resource (source code repository, bug tracker, mailing list)
please check the `project homepage`__.

.. __: https://psycopg.org/


Installation
------------

Building Psycopg requires a few prerequisites (a C compiler, some development
packages): please check the install_ and the faq_ documents in the ``doc`` dir
or online for the details.

If prerequisites are met, you can install psycopg like any other Python
package, using ``pip`` to download it from PyPI_::

    $ pip install psycopg2

or using ``setup.py`` if you have downloaded the source package locally::

    $ python setup.py build
    $ sudo python setup.py install

You can also obtain a stand-alone package, not requiring a compiler or
external libraries, by installing the `psycopg2-binary`_ package from PyPI::

    $ pip install psycopg2-binary

The binary package is a practical choice for development and testing but in
production it is advised to use the package built from sources.

.. _PyPI: https://pypi.org/project/psycopg2/
.. _psycopg2-binary: https://pypi.org/project/psycopg2-binary/
.. _install: https://www.psycopg.org/docs/install.html#install-from-source
.. _faq: https://www.psycopg.org/docs/faq.html#faq-compile

:Linux/OSX: |gh-actions|
:Windows: |appveyor|

.. |gh-actions| image:: https://github.com/psycopg/psycopg2/actions/workflows/tests.yml/badge.svg
    :target: https://github.com/psycopg/psycopg2/actions/workflows/tests.yml
    :alt: Linux and OSX build status

.. |appveyor| image:: https://ci.appveyor.com/api/projects/status/github/psycopg/psycopg2?branch=master&svg=true
    :target: https://ci.appveyor.com/project/psycopg/psycopg2/branch/master
    :alt: Windows build status

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
