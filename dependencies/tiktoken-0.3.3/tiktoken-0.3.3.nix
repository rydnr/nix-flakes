{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "tiktoken";
  version = "0.3.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1f37fa75ba70c1bc7806641e8ccea1fba667d23e6341a1591ea333914c226a9";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
# ⏳ tiktoken

tiktoken is a fast [BPE](https://en.wikipedia.org/wiki/Byte_pair_encoding) tokeniser for use with
OpenAI's models.

```python
import tiktoken
enc = tiktoken.get_encoding("cl100k_base")
assert enc.decode(enc.encode("hello world")) == "hello world"

# To get the tokeniser corresponding to a specific model in the OpenAI API:
enc = tiktoken.encoding_for_model("gpt-4")
```

The open source version of `tiktoken` can be installed from PyPI:
```
pip install tiktoken
```

The tokeniser API is documented in `tiktoken/core.py`.

Example code using `tiktoken` can be found in the
[OpenAI Cookbook](https://github.com/openai/openai-cookbook/blob/main/examples/How_to_count_tokens_with_tiktoken.ipynb).


## Performance

`tiktoken` is between 3-6x faster than a comparable open source tokeniser:

![image](https://raw.githubusercontent.com/openai/tiktoken/main/perf.svg)

Performance measured on 1GB of text using the GPT-2 tokeniser, using `GPT2TokenizerFast` from
`tokenizers==0.13.2`, `transformers==4.24.0` and `tiktoken==0.2.0`.


## Getting help

Please post questions in the [issue tracker](https://github.com/openai/tiktoken/issues).

If you work at OpenAI, make sure to check the internal documentation or feel free to contact
@shantanu.


## Extending tiktoken

You may wish to extend `tiktoken` to support new encodings. There are two ways to do this.


**Create your `Encoding` object exactly the way you want and simply pass it around.**

```python
cl100k_base = tiktoken.get_encoding("cl100k_base")

# In production, load the arguments directly instead of accessing private attributes
# See openai_public.py for examples of arguments for specific encodings
enc = tiktoken.Encoding(
    # If you're changing the set of special tokens, make sure to use a different name
    # It should be clear from the name what behaviour to expect.
    name="cl100k_im",
    pat_str=cl100k_base._pat_str,
    mergeable_ranks=cl100k_base._mergeable_ranks,
    special_tokens={
        **cl100k_base._special_tokens,
        "<|im_start|>": 100264,
        "<|im_end|>": 100265,
    }
)
```

**Use the `tiktoken_ext` plugin mechanism to register your `Encoding` objects with `tiktoken`.**

This is only useful if you need `tiktoken.get_encoding` to find your encoding, otherwise prefer
option 1.

To do this, you'll need to create a namespace package under `tiktoken_ext`.

Layout your project like this, making sure to omit the `tiktoken_ext/__init__.py` file:
```
my_tiktoken_extension
├── tiktoken_ext
│   └── my_encodings.py
└── setup.py
```

`my_encodings.py` should be a module that contains a variable named `ENCODING_CONSTRUCTORS`.
This is a dictionary from an encoding name to a function that takes no arguments and returns
arguments that can be passed to `tiktoken.Encoding` to construct that encoding. For an example, see
`tiktoken_ext/openai_public.py`. For precise details, see `tiktoken/registry.py`.

Your `setup.py` should look something like this:
```python
from setuptools import setup, find_namespace_packages

setup(
    name="my_tiktoken_extension",
    packages=find_namespace_packages(include=['tiktoken_ext*']),
    install_requires=["tiktoken"],
    ...
)
```

Then simply `pip install ./my_tiktoken_extension` and you should be able to use your
custom encodings! Make sure **not** to use an editable install.


'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}