{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "pkgutil-resolve-name";
  version = "1.3.10";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca27cc078d25c5ad71a9de0a7a330146c4e014c2462d9af19c6b828280649c5e";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
pkgutil-resolve-name
====================

A backport of Python 3.9's ``pkgutil.resolve_name``.
See the `Python 3.9 documentation <https://docs.python.org/3.9/library/pkgutil.html#pkgutil.resolve_name>`__.

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
