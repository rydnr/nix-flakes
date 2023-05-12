{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "opentelemetry-util-http";
  version = "0.38b0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e5f0451eeb5307b2c628dd799886adc5e113fb13a7207c29c672e8d168eabd8";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
OpenTelemetry Util HTTP
=======================

|pypi|

.. |pypi| image:: https://badge.fury.io/py/opentelemetry-util-http.svg
   :target: https://pypi.org/project/opentelemetry-util-http/


This library provides ASGI, WSGI middleware and other HTTP-related
functionality that is common to instrumented web frameworks (such as Django,
Starlette, FastAPI, etc.) to track requests timing through OpenTelemetry.

Installation
------------

::

    pip install opentelemetry-util-http


Usage (Quart)
-------------

.. code-block:: python

    from quart import Quart
    from opentelemetry.instrumentation.asgi import OpenTelemetryMiddleware

    app = Quart(__name__)
    app.asgi_app = OpenTelemetryMiddleware(app.asgi_app)

    @app.route("/")
    async def hello():
        return "Hello!"

    if __name__ == "__main__":
        app.run(debug=True)


Usage (Django 3.0)
------------------

Modify the application's ``asgi.py`` file as shown below.

.. code-block:: python

    import os
    from django.core.asgi import get_asgi_application
    from opentelemetry.instrumentation.asgi import OpenTelemetryMiddleware

    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'asgi_example.settings')

    application = get_asgi_application()
    application = OpenTelemetryMiddleware(application)


Usage (Raw ASGI)
----------------

.. code-block:: python

    from opentelemetry.instrumentation.asgi import OpenTelemetryMiddleware

    app = ...  # An ASGI application.
    app = OpenTelemetryMiddleware(app)


References
----------

* `OpenTelemetry Project <https://opentelemetry.io/>`_

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
