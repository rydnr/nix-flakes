{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "posthog";
  version = "2.4.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c7c37de997d955aea61bf0aa0069970e71f0d9d79c9e6b3a134e6593d5aa3d6";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''

PostHog is developer-friendly, self-hosted product analytics. posthog-python is the python package.

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
