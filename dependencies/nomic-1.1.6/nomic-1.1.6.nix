{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "nomic";
  version = "1.1.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8be61aeeb9d5f4f591bfb5655c9ae54a12de97498e6d2e24cf22faf9c118cf81";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
The offical Nomic python client.
'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
