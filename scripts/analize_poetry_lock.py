#!/usr/bin/env python3
import argparse
import json
import os
import re
import subprocess
from typing import List

def extract_package_names(poetry_lock: str) -> List[str]:
    with open(poetry_lock, 'r') as f:
        content = f.read()
    package_names = re.findall(r'^name\s*=\s*"([^"]+)"', content, re.MULTILINE)
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
    parser = argparse.ArgumentParser(description="Check if packages in poetry.lock are in nixpkgs")
    parser.add_argument("poetry_lock", help="Path to the poetry.lock file")
    args = parser.parse_args()

    package_names = extract_package_names(args.poetry_lock)

    not_in_nixpkgs = []

    for package_name in package_names:
        if not is_package_in_nixpkgs(package_name):
            not_in_nixpkgs.append(package_name)

    print("\n".join(not_in_nixpkgs))

if __name__ == "__main__":
    main()
