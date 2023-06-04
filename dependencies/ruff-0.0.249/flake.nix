{
  description = "A Nix flake for ruff 0.0.249 Python package";

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
          ruff-0.0.249 = (import ./ruff-0.0.249.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          ruff = packages.ruff-0.0.249;
          default = packages.ruff;
          meta = with lib; {
            description = ''
<!-- Begin section: Overview -->

# Ruff

[![Ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/charliermarsh/ruff/main/assets/badge/v1.json)](https://github.com/charliermarsh/ruff)
[![image](https://img.shields.io/pypi/v/ruff.svg)](https://pypi.python.org/pypi/ruff)
[![image](https://img.shields.io/pypi/l/ruff.svg)](https://pypi.python.org/pypi/ruff)
[![image](https://img.shields.io/pypi/pyversions/ruff.svg)](https://pypi.python.org/pypi/ruff)
[![Actions status](https://github.com/charliermarsh/ruff/workflows/CI/badge.svg)](https://github.com/charliermarsh/ruff/actions)

[**Discord**](https://discord.gg/c9MhzV8aU5) | [**Docs**](https://beta.ruff.rs/docs/) | [**Playground**](https://play.ruff.rs/)

An extremely fast Python linter, written in Rust.

<p align="center">
  <img alt="Shows a bar chart with benchmark results." src="https://user-images.githubusercontent.com/1309177/212613257-5f4bca12-6d6b-4c79-9bac-51a4c6d08928.svg">
</p>

<p align="center">
  <i>Linting the CPython codebase from scratch.</i>
</p>

- ⚡️  10-100x faster than existing linters
- 🐍  Installable via `pip`
- 🛠️  `pyproject.toml` support
- 🤝  Python 3.11 compatibility
- 📦  Built-in caching, to avoid re-analyzing unchanged files
- 🔧  Autofix support, for automatic error correction (e.g., automatically remove unused imports)
- 📏  Over [500 built-in rules](https://beta.ruff.rs/docs/rules/)
- ⚖️  [Near-parity](https://beta.ruff.rs/docs/faq/#how-does-ruff-compare-to-flake8) with the built-in Flake8 rule set
- 🔌  Native re-implementations of dozens of Flake8 plugins, like flake8-bugbear
- ⌨️  First-party editor integrations for [VS Code](https://github.com/charliermarsh/ruff-vscode) and [more](https://github.com/charliermarsh/ruff-lsp)
- 🌎  Monorepo-friendly, with [hierarchical and cascading configuration](https://beta.ruff.rs/docs/configuration/#pyprojecttoml-discovery)

Ruff aims to be orders of magnitude faster than alternative tools while integrating more
functionality behind a single, common interface.

Ruff can be used to replace [Flake8](https://pypi.org/project/flake8/) (plus dozens of plugins),
[isort](https://pypi.org/project/isort/), [pydocstyle](https://pypi.org/project/pydocstyle/),
[yesqa](https://github.com/asottile/yesqa), [eradicate](https://pypi.org/project/eradicate/),
[pyupgrade](https://pypi.org/project/pyupgrade/), and [autoflake](https://pypi.org/project/autoflake/),
all while executing tens or hundreds of times faster than any individual tool.

Ruff is extremely actively developed and used in major open-source projects like:

- [pandas](https://github.com/pandas-dev/pandas)
- [FastAPI](https://github.com/tiangolo/fastapi)
- [Transformers (Hugging Face)](https://github.com/huggingface/transformers)
- [Apache Airflow](https://github.com/apache/airflow)
- [SciPy](https://github.com/scipy/scipy)

...and many more.

Read the [launch blog post](https://notes.crmarsh.com/python-tooling-could-be-much-much-faster) or
the most recent [project update](https://notes.crmarsh.com/ruff-the-first-200-releases).

## Testimonials

[**Sebastián Ramírez**](https://twitter.com/tiangolo/status/1591912354882764802), creator
of [FastAPI](https://github.com/tiangolo/fastapi):

> Ruff is so fast that sometimes I add an intentional bug in the code just to confirm it's actually
> running and checking the code.

[**Nick Schrock**](https://twitter.com/schrockn/status/1612615862904827904), founder of [Elementl](https://www.elementl.com/),
co-creator of [GraphQL](https://graphql.org/):

> Why is Ruff a gamechanger? Primarily because it is nearly 1000x faster. Literally. Not a typo. On
> our largest module (dagster itself, 250k LOC) pylint takes about 2.5 minutes, parallelized across 4
> cores on my M1. Running ruff against our _entire_ codebase takes .4 seconds.

[**Bryan Van de Ven**](https://github.com/bokeh/bokeh/pull/12605), co-creator
of [Bokeh](https://github.com/bokeh/bokeh/), original author
of [Conda](https://docs.conda.io/en/latest/):

> Ruff is ~150-200x faster than flake8 on my machine, scanning the whole repo takes ~0.2s instead of
> ~20s. This is an enormous quality of life improvement for local dev. It's fast enough that I added
> it as an actual commit hook, which is terrific.

[**Timothy Crosley**](https://twitter.com/timothycrosley/status/1606420868514877440),
creator of [isort](https://github.com/PyCQA/isort):

> Just switched my first project to Ruff. Only one downside so far: it's so fast I couldn't believe it was working till I intentionally introduced some errors.

[**Tim Abbott**](https://github.com/charliermarsh/ruff/issues/465#issuecomment-1317400028), lead
developer of [Zulip](https://github.com/zulip/zulip):

> This is just ridiculously fast... `ruff` is amazing.

<!-- End section: Overview -->

## Table of Contents

For more, see the [documentation](https://beta.ruff.rs/docs/).

1. [Getting Started](#getting-started)
1. [Configuration](#configuration)
1. [Rules](#rules)
1. [Contributing](#contributing)
1. [Support](#support)
1. [Acknowledgements](#acknowledgements)
1. [Who's Using Ruff?](#whos-using-ruff)
1. [License](#license)

## Getting Started

For more, see the [documentation](https://beta.ruff.rs/docs/).

### Installation

Ruff is available as [`ruff`](https://pypi.org/project/ruff/) on PyPI:

```shell
pip install ruff
```

You can also install Ruff via [Homebrew](https://formulae.brew.sh/formula/ruff), [Conda](https://anaconda.org/conda-forge/ruff),
and with [a variety of other package managers](https://beta.ruff.rs/docs/installation/).

### Usage

To run Ruff, try any of the following:

```shell
ruff check .                        # Lint all files in the current directory (and any subdirectories)
ruff check path/to/code/            # Lint all files in `/path/to/code` (and any subdirectories)
ruff check path/to/code/*.py        # Lint all `.py` files in `/path/to/code`
ruff check path/to/code/to/file.py  # Lint `file.py`
```

Ruff can also be used as a [pre-commit](https://pre-commit.com) hook:

```yaml
- repo: https://github.com/charliermarsh/ruff-pre-commit
  # Ruff version.
  rev: 'v0.0.261'
  hooks:
    - id: ruff
```

Ruff can also be used as a [VS Code extension](https://github.com/charliermarsh/ruff-vscode) or
alongside any other editor through the [Ruff LSP](https://github.com/charliermarsh/ruff-lsp).

Ruff can also be used as a [GitHub Action](https://github.com/features/actions) via
[`ruff-action`](https://github.com/chartboost/ruff-action):

```yaml
name: Ruff
on: [ push, pull_request ]
jobs:
  ruff:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: chartboost/ruff-action@v1
```

### Configuration

Ruff can be configured through a `pyproject.toml`, `ruff.toml`, or `.ruff.toml` file (see:
[_Configuration_](https://beta.ruff.rs/docs/configuration/), or [_Settings_](https://beta.ruff.rs/docs/settings/)
for a complete list of all configuration options).

If left unspecified, the default configuration is equivalent to:

```toml
[tool.ruff]
# Enable pycodestyle (`E`) and Pyflakes (`F`) codes by default.
select = ["E", "F"]
ignore = []

# Allow autofix for all enabled rules (when `--fix`) is provided.
fixable = ["A", "B", "C", "D", "E", "F", "G", "I", "N", "Q", "S", "T", "W", "ANN", "ARG", "BLE", "COM", "DJ", "DTZ", "EM", "ERA", "EXE", "FBT", "ICN", "INP", "ISC", "NPY", "PD", "PGH", "PIE", "PL", "PT", "PTH", "PYI", "RET", "RSE", "RUF", "SIM", "SLF", "TCH", "TID", "TRY", "UP", "YTT"]
unfixable = []

# Exclude a variety of commonly ignored directories.
exclude = [
    ".bzr",
    ".direnv",
    ".eggs",
    ".git",
    ".hg",
    ".mypy_cache",
    ".nox",
    ".pants.d",
    ".pytype",
    ".ruff_cache",
    ".svn",
    ".tox",
    ".venv",
    "__pypackages__",
    "_build",
    "buck-out",
    "build",
    "dist",
    "node_modules",
    "venv",
]

# Same as Black.
line-length = 88

# Allow unused variables when underscore-prefixed.
dummy-variable-rgx = "^(_+|(_+[a-zA-Z0-9_]*[a-zA-Z0-9]+?))$"

# Assume Python 3.10.
target-version = "py310"

[tool.ruff.mccabe]
# Unlike Flake8, default to a complexity level of 10.
max-complexity = 10
```

Some configuration options can be provided via the command-line, such as those related to
rule enablement and disablement, file discovery, logging level, and more:

```shell
ruff check path/to/code/ --select F401 --select F403 --quiet
```

See `ruff help` for more on Ruff's top-level commands, or `ruff help check` for more on the
linting command.

## Rules

<!-- Begin section: Rules -->

**Ruff supports over 500 lint rules**, many of which are inspired by popular tools like Flake8,
isort, pyupgrade, and others. Regardless of the rule's origin, Ruff re-implements every rule in
Rust as a first-party feature.

By default, Ruff enables Flake8's `E` and `F` rules. Ruff supports all rules from the `F` category,
and a [subset](https://beta.ruff.rs/docs/rules/#error-e) of the `E` category, omitting those
stylistic rules made obsolete by the use of an autoformatter, like
[Black](https://github.com/psf/black).

If you're just getting started with Ruff, **the default rule set is a great place to start**: it
catches a wide variety of common errors (like unused imports) with zero configuration.

Beyond the defaults, Ruff re-implements some of the most popular Flake8 plugins and related code
quality tools, including:

- [autoflake](https://pypi.org/project/autoflake/)
- [eradicate](https://pypi.org/project/eradicate/)
- [flake8-2020](https://pypi.org/project/flake8-2020/)
- [flake8-annotations](https://pypi.org/project/flake8-annotations/)
- [flake8-bandit](https://pypi.org/project/flake8-bandit/) ([#1646](https://github.com/charliermarsh/ruff/issues/1646))
- [flake8-blind-except](https://pypi.org/project/flake8-blind-except/)
- [flake8-boolean-trap](https://pypi.org/project/flake8-boolean-trap/)
- [flake8-bugbear](https://pypi.org/project/flake8-bugbear/)
- [flake8-builtins](https://pypi.org/project/flake8-builtins/)
- [flake8-commas](https://pypi.org/project/flake8-commas/)
- [flake8-comprehensions](https://pypi.org/project/flake8-comprehensions/)
- [flake8-datetimez](https://pypi.org/project/flake8-datetimez/)
- [flake8-debugger](https://pypi.org/project/flake8-debugger/)
- [flake8-django](https://pypi.org/project/flake8-django/)
- [flake8-docstrings](https://pypi.org/project/flake8-docstrings/)
- [flake8-eradicate](https://pypi.org/project/flake8-eradicate/)
- [flake8-errmsg](https://pypi.org/project/flake8-errmsg/)
- [flake8-executable](https://pypi.org/project/flake8-executable/)
- [flake8-gettext](https://pypi.org/project/flake8-gettext/)
- [flake8-implicit-str-concat](https://pypi.org/project/flake8-implicit-str-concat/)
- [flake8-import-conventions](https://github.com/joaopalmeiro/flake8-import-conventions)
- [flake8-logging-format](https://pypi.org/project/flake8-logging-format/)
- [flake8-no-pep420](https://pypi.org/project/flake8-no-pep420)
- [flake8-pie](https://pypi.org/project/flake8-pie/)
- [flake8-print](https://pypi.org/project/flake8-print/)
- [flake8-pyi](https://pypi.org/project/flake8-pyi/)
- [flake8-pytest-style](https://pypi.org/project/flake8-pytest-style/)
- [flake8-quotes](https://pypi.org/project/flake8-quotes/)
- [flake8-raise](https://pypi.org/project/flake8-raise/)
- [flake8-return](https://pypi.org/project/flake8-return/)
- [flake8-self](https://pypi.org/project/flake8-self/)
- [flake8-simplify](https://pypi.org/project/flake8-simplify/)
- [flake8-super](https://pypi.org/project/flake8-super/)
- [flake8-tidy-imports](https://pypi.org/project/flake8-tidy-imports/)
- [flake8-type-checking](https://pypi.org/project/flake8-type-checking/)
- [flake8-use-pathlib](https://pypi.org/project/flake8-use-pathlib/)
- [isort](https://pypi.org/project/isort/)
- [mccabe](https://pypi.org/project/mccabe/)
- [pandas-vet](https://pypi.org/project/pandas-vet/)
- [pep8-naming](https://pypi.org/project/pep8-naming/)
- [pydocstyle](https://pypi.org/project/pydocstyle/)
- [pygrep-hooks](https://github.com/pre-commit/pygrep-hooks) ([#980](https://github.com/charliermarsh/ruff/issues/980))
- [pyupgrade](https://pypi.org/project/pyupgrade/)
- [tryceratops](https://pypi.org/project/tryceratops/)
- [yesqa](https://pypi.org/project/yesqa/)

<!-- End section: Rules -->

For a complete enumeration of the supported rules, see [_Rules_](https://beta.ruff.rs/docs/rules/).

## Contributing

Contributions are welcome and highly appreciated. To get started, check out the
[**contributing guidelines**](https://beta.ruff.rs/docs/contributing/).

You can also join us on [**Discord**](https://discord.gg/c9MhzV8aU5).

## Support

Having trouble? Check out the existing issues on [**GitHub**](https://github.com/charliermarsh/ruff/issues),
or feel free to [**open a new one**](https://github.com/charliermarsh/ruff/issues/new).

You can also ask for help on [**Discord**](https://discord.gg/c9MhzV8aU5).

## Acknowledgements

Ruff's linter draws on both the APIs and implementation details of many other
tools in the Python ecosystem, especially [Flake8](https://github.com/PyCQA/flake8), [Pyflakes](https://github.com/PyCQA/pyflakes),
[pycodestyle](https://github.com/PyCQA/pycodestyle), [pydocstyle](https://github.com/PyCQA/pydocstyle),
[pyupgrade](https://github.com/asottile/pyupgrade), and [isort](https://github.com/PyCQA/isort).

In some cases, Ruff includes a "direct" Rust port of the corresponding tool.
We're grateful to the maintainers of these tools for their work, and for all
the value they've provided to the Python community.

Ruff's autoformatter is built on a fork of Rome's [`rome_formatter`](https://github.com/rome/tools/tree/main/crates/rome_formatter),
and again draws on both the APIs and implementation details of [Rome](https://github.com/rome/tools),
[Prettier](https://github.com/prettier/prettier), and [Black](https://github.com/psf/black).

Ruff is also influenced by a number of tools outside the Python ecosystem, like
[Clippy](https://github.com/rust-lang/rust-clippy) and [ESLint](https://github.com/eslint/eslint).

Ruff is the beneficiary of a large number of [contributors](https://github.com/charliermarsh/ruff/graphs/contributors).

Ruff is released under the MIT license.

## Who's Using Ruff?

Ruff is used in a number of major open-source projects, including:

- [pandas](https://github.com/pandas-dev/pandas)
- [FastAPI](https://github.com/tiangolo/fastapi)
- [Transformers (Hugging Face)](https://github.com/huggingface/transformers)
- [Diffusers (Hugging Face)](https://github.com/huggingface/diffusers)
- [Apache Airflow](https://github.com/apache/airflow)
- [SciPy](https://github.com/scipy/scipy)
- [Zulip](https://github.com/zulip/zulip)
- [Bokeh](https://github.com/bokeh/bokeh)
- [Pydantic](https://github.com/pydantic/pydantic)
- [PostHog](https://github.com/PostHog/posthog)
- [Dagster](https://github.com/dagster-io/dagster)
- [Dagger](https://github.com/dagger/dagger)
- [Sphinx](https://github.com/sphinx-doc/sphinx)
- [Hatch](https://github.com/pypa/hatch)
- [PDM](https://github.com/pdm-project/pdm)
- [Jupyter](https://github.com/jupyter-server/jupyter_server)
- [Great Expectations](https://github.com/great-expectations/great_expectations)
- [ONNX](https://github.com/onnx/onnx)
- [Polars](https://github.com/pola-rs/polars)
- [Ibis](https://github.com/ibis-project/ibis)
- [Synapse (Matrix)](https://github.com/matrix-org/synapse)
- [SnowCLI (Snowflake)](https://github.com/Snowflake-Labs/snowcli)
- [Dispatch (Netflix)](https://github.com/Netflix/dispatch)
- [Saleor](https://github.com/saleor/saleor)
- [Pynecone](https://github.com/pynecone-io/pynecone)
- [OpenBB](https://github.com/OpenBB-finance/OpenBBTerminal)
- [Home Assistant](https://github.com/home-assistant/core)
- [Pylint](https://github.com/PyCQA/pylint)
- [Cryptography (PyCA)](https://github.com/pyca/cryptography)
- [cibuildwheel (PyPA)](https://github.com/pypa/cibuildwheel)
- [build (PyPA)](https://github.com/pypa/build)
- [Babel](https://github.com/python-babel/babel)
- [featuretools](https://github.com/alteryx/featuretools)
- [meson-python](https://github.com/mesonbuild/meson-python)
- [ZenML](https://github.com/zenml-io/zenml)
- [delta-rs](https://github.com/delta-io/delta-rs)
- [Starlite](https://github.com/starlite-api/starlite)
- [telemetry-airflow (Mozilla)](https://github.com/mozilla/telemetry-airflow)
- [Stable Baselines3](https://github.com/DLR-RM/stable-baselines3)
- [PaddlePaddle](https://github.com/PaddlePaddle/Paddle)
- [nox](https://github.com/wntrblm/nox)
- [Neon](https://github.com/neondatabase/neon)
- [The Algorithms](https://github.com/TheAlgorithms/Python)
- [Openverse](https://github.com/WordPress/openverse)
- [MegaLinter](https://github.com/oxsecurity/megalinter)
- [LangChain](https://github.com/hwchase17/langchain)
- [LlamaIndex](https://github.com/jerryjliu/llama_index)

## License

MIT


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