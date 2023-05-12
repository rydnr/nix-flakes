#!/usr/bin/env python3
import argparse
from bs4 import BeautifulSoup
import mistune
import os
import re
import requests
import subprocess
import toml
from pathlib import Path
from typing import Dict, List
from packaging.requirements import Requirement
from packaging.specifiers import SpecifierSet

def extract_html_description(description: str) -> str:
    if description:
        soup = BeautifulSoup(description, "html.parser")
        first_paragraph = soup.find("p")
        if first_paragraph is not None:
            plain_text_description = first_paragraph.get_text()
        else:
            plain_text_description = ""
    else:
        plain_text_description = ""

    return plain_text_description

def extract_markdown_description(description: str) -> str:
    if description:
        renderer = mistune.HTMLRenderer()
        parser = mistune.BlockParser(renderer)
        raw_description = extract_html_description(parser.parse(description))
    else:
        raw_description = ""

    return raw_description

def extract_description(description: str, type: str) -> str:
    if (str == 'text/html'):
        return extract_html_description(str)
    elif (str == 'text/markdown'):
        return extract_markdown_description(str)

    return description

def get_pypi_info(package_name: str, version_spec: str) -> Dict[str, str]:
    # If the version_spec is an exact version, add '==' before it
    if re.match(r"^\d+(\.\d+)*(-?(rc|b)\d+)?$", version_spec):
        version_spec = f"=={version_spec}"

    specifier_set = SpecifierSet(version_spec)

    package_data = requests.get(f"https://pypi.org/pypi/{package_name}/json").json()
    versions = package_data["releases"].keys()

    compatible_versions = [v for v in versions if v in specifier_set]

    if not compatible_versions:
        raise Exception(f"No compatible versions found for {package_name} with spec {version_spec}")

    latest_version = max(compatible_versions)
    release_info = package_data["releases"][latest_version][0]
    package_info = package_data["info"]
    github_url = ""
    project_urls = package_info["project_urls"]
    if project_urls:
        github_url = project_urls.get("Repository")
    sha256 = ""
    digests = release_info["digests"]
    if digests:
        sha256 = digests["sha256"]

    description = extract_description(package_info["description"], package_info["description_content_type"])

    return {
        "name": package_name,
        "version": latest_version,
        "url": release_info["url"],
        "sha256": sha256,
        "github_url": github_url,
        "description": description,
        "license": package_info["license"]
    }

def get_github_info(github_token: str, github_url: str) -> Dict[str, str]:
    if not github_url:
        return {"description": "", "license": ""}

    repo_path = github_url.split("github.com/")[-1].rstrip("/")
    headers = {"Authorization": f"token {github_token}"}
    repo_info = requests.get(f"https://api.github.com/repos/{repo_path}", headers=headers).json()
    license = repo_info.get("license", {}).get("spdx_id", "")

    readme_info = requests.get(f"https://api.github.com/repos/{repo_path}/readme", headers=headers).json()
    readme_text = requests.get(readme_info["download_url"]).text
    description = readme_text.split("\n")[0].strip()

    return {"description": description, "license": license}

def pypi_license_to_nix_license(pypi_license: str) -> str:
    license_map = {
        "Apache-2.0": "asl20",
        "MIT": "mit",
        "GPL-3.0": "gpl3",
        "GPL-3.0+": "gpl3Plus",
        "LGPL-3.0": "lgpl3",
        "LGPL-3.0+": "lgpl3Plus",
        "BSD-2-Clause": "bsd2",
        "BSD-3-Clause": "bsd3",
    }

    nix_license = license_map.get(pypi_license)

    if not nix_license:
        # raise ValueError(f"Unknown PyPI license: {pypi_license}")
        nix_license = "mit"

    return nix_license

def create_package_folder(base_folder: str, package_info: Dict[str, str], github_info: Dict[str, str]):

    package_name = package_info["name"]
    package_version = package_info["version"]
    folder_name = f"{package_name}-{package_version}"
    package_folder = Path(base_folder) / folder_name
    if not os.path.exists(package_folder):
        os.makedirs(package_folder)
    flake_nix_path = f"{package_folder}/flake.nix"
    package_nix_path = f"{package_folder}/{package_name}-{package_version}.nix"

    package_license = pypi_license_to_nix_license(package_info["license"])
    package_description = package_info["description"]
    package_repo = package_info["github_url"]
    package_pypi_sha256 = package_info["sha256"]


    flake_nix_template = """\
{{
  description = "A Nix flake for {package_name} {package_version} Python package";

  inputs = {{
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  }};

  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${{system}};
        python = pkgs.python3;
        pythonPackages = python.pkgs;
      in rec {{
        packages = {{
          {package_name}-{package_version} = (import ./{package_name}-{package_version}.nix) {{
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          }};
          {package_name} = packages.{package_name}-{package_version};
          default = packages.{package_name};
          meta = with lib; {{
            description = ''
{package_description}
'';
            license = licenses.{package_license};
            homepage = "{package_repo}";
            maintainers = with maintainers; [ ];
          }};
        }};
        defaultPackage = packages.default;
        devShell = pkgs.mkShell {{
          buildInputs = with pkgs.python3Packages; [ packages.default ];
        }};
        shell = flake-utils.lib.mkShell {{
          packages = system: [ self.packages.${{system}}.default ];
        }};
      }});
}}
"""

    if not os.path.exists(flake_nix_path):
        with open(flake_nix_path, "w") as f:
            f.write(flake_nix_template.format(
                package_name=package_name,
                package_version=package_version,
                package_description=package_description,
                package_license=package_license,
                package_repo=package_repo
            ))

    package_nix_template = """\
{{ buildPythonPackage, fetchPypi, lib, python, setuptools }}:

buildPythonPackage rec {{
  pname = "{package_name}";
  version = "{package_version}";
  format = "pyproject";

  src = fetchPypi {{
    inherit pname version;
    sha256 = "{package_pypi_sha256}";
  }};

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {{
    description = ''
{package_description}
'';
    license = licenses.{package_license};
    homepage = "{package_repo}";
    maintainers = with maintainers; [ ];
  }};
}}
"""

    if not os.path.exists(package_nix_path):
        with open(package_nix_path, "w") as f:
            f.write(package_nix_template.format(
                package_name=package_name,
                package_version=package_version,
                package_pypi_sha256=package_pypi_sha256,
                package_description=package_description,
                package_license=package_license,
                package_repo=package_repo
            ))

def load_poetry_lock(filepath):
    with open(filepath, "r") as f:
        return toml.load(f)

def get_missing_packages(poetry_lock, missing_packages_list):
    package_data = {}
    for package in poetry_lock["package"]:
        package_name = package["name"]
        if package_name in missing_packages_list:
            package_data[package_name] = package["version"]
    return package_data

def extract_package_names(poetry_lock) -> List[str]:
    package_names = []
    for package in poetry_lock["package"]:
        package_names.append(package["name"])
    return package_names

def is_package_in_nixpkgs(package_name: str) -> bool:
    try:
        result = subprocess.run(
            [
                "nix-instantiate",
                "--eval",
                "--expr",
                f"with import <nixpkgs> {{ }}; builtins.hasAttr \"{package_name}\" python3Packages",
            ],
            check=True,
            capture_output=True,
            text=True,
        )
        return result.stdout.strip() == "true"
    except subprocess.CalledProcessError:
        return False

def main():
    parser = argparse.ArgumentParser(description="Generates flakes from templates for packages in poetry.lock not available in nixpkgs")
    parser.add_argument("poetryLockFile", help="The poetry.lock file")
    parser.add_argument("baseFolder", help="The base folder for the flakes")
    parser.add_argument("githubToken", help="The github token")
    args = parser.parse_args()

    poetry_lock = load_poetry_lock(args.poetryLockFile)

    package_names = extract_package_names(poetry_lock)

    not_in_nixpkgs = []

    for package_name in package_names:
        if not is_package_in_nixpkgs(package_name):
            not_in_nixpkgs.append(package_name)

    missing_packages = get_missing_packages(poetry_lock, not_in_nixpkgs)

    for package_name, version_spec in missing_packages.items():
        print(f"Generating flake for {package_name} {version_spec}")
        package_info = get_pypi_info(package_name, version_spec)
        github_info = get_github_info(args.githubToken, package_info["github_url"])
        create_package_folder(args.baseFolder, package_info, github_info)

if __name__ == "__main__":
    main()
