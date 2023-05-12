{
  description = "A Nix flake for opentelemetry-util-http 0.38b0 Python package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        pythonPackages = python.pkgs;
      in rec {
        packages = {
          opentelemetry-util-http-0.38b0 = (import ./opentelemetry-util-http-0.38b0.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          opentelemetry-util-http = packages.opentelemetry-util-http-0.38b0;
          default = packages.opentelemetry-util-http;
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
        };
        defaultPackage = packages.default;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ packages.default ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
