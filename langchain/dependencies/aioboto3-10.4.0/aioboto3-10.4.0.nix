{ pkgs, fetchgit, lib, mkPoetryApplication, poetry, python, pip, wheel
, packaging, jinja2, markupsafe, aiofiles, chalice, dill, flake8, moto, PyGithub
, pytest, typing, tomli, requests, sphinx, tox, aiobotocore, cryptography, cffi
}:

let
  project = fetchgit {
    url = "https://github.com/terrycain/aioboto3";
    rev = "v10.4.0";
    sha256 = "sha256-lPCkaxbGxXL7pBf6sM082Q+fB5CwnaklaAfZwggkqHI=";
  };

in mkPoetryApplication {
  projectDir = project;
  pname = "aioboto3";
  version = "10.4.0";
  pyModule = "aioboto3";
  python = python;

  overrides = pkgs.poetry2nix.overrides.withDefaults (self: super: {
    pip = pkgs.python3Packages.pip;
    wheel = pkgs.python3Packages.wheel;
    packaging = pkgs.python3Packages.packaging;
    jinja2 = pkgs.python3Packages.jinja2;
    markupsafe = pkgs.python3Packages.markupsafe;
    aiofiles = pkgs.python3Packages.aiofiles;
    chalice = pkgs.python3Packages.chalice;
    dill = pkgs.python3Packages.dill;
    flake8 = pkgs.python3Packages.flake8;
    moto = pkgs.python3Packages.moto;
    PyGithub = pkgs.python3Packages.PyGithub;
    pytest = pkgs.python3Packages.pytest;
    typing = pkgs.python3Packages.typing;
    tomli = pkgs.python3Packages.tomli;
    requests = pkgs.python3Packages.requests;
    sphinx = pkgs.python3Packages.sphinx;
    tox = pkgs.python3Packages.tox;
    aiobotocore = pkgs.python3Packages.aiobotocore;
    cryptography = pkgs.python3Packages.cryptography;
    cffi = pkgs.python3Packages.cffi;
  });

  nativeBuildInputs = with python.pkgs; [
    pip
    wheel
    packaging
    jinja2
    markupsafe
    aiofiles
    chalice
    dill
    flake8
    moto
    PyGithub
    pytest
    typing
    tomli
    requests
    sphinx
    tox
    aiobotocore
    cryptography
    cffi
  ];

  propagatedBuildInputs = with python.pkgs;
    [

    ];

  buildInputs = with python.pkgs;
    [

    ];

  pythonImportsCheck = [ "aioboto3" ];
  meta = with lib; {
    description = ''
      ========================
      Async AWS SDK for Python
      ========================


      .. image:: https://img.shields.io/pypi/v/aioboto3.svg
              :target: https://pypi.python.org/pypi/aioboto3

      .. image:: https://github.com/terrycain/aioboto3/actions/workflows/CI.yml/badge.svg
              :target: https://github.com/terrycain/aioboto3/actions

      .. image:: https://readthedocs.org/projects/aioboto3/badge/?version=latest
              :target: https://aioboto3.readthedocs.io
              :alt: Documentation Status

      .. image:: https://pyup.io/repos/github/terrycain/aioboto3/shield.svg
           :target: https://pyup.io/repos/github/terrycain/aioboto3/
           :alt: Updates

      **Breaking changes for v11: The S3Transfer config passed into upload/download_file etc.. has been updated to that it matches what boto3 uses**

      **Breaking changes for v9: aioboto3.resource and aioboto3.client methods no longer exist, make a session then call session.client etc...**
      This was done for various reasons but mainly that it prevents the default session living longer than it should as that breaks situations where eventloops are replaced.

      **The .client and .resource functions must now be used as async context managers.**

      Now that aiobotocore has reached version 1.0.1, a side effect of the work put in to fix various issues like bucket region redirection and
      supporting web assume role type credentials, the client must now be instantiated using a context manager, which by extension applies to
      the resource creator. You used to get away with calling ``res = aioboto3.resource('dynamodb')`` but that no longer works. If you really want
      to do that, you can do ``res = await aioboto3.resource('dynamodb').__aenter__()`` but you'll need to remember to call ``__aexit__``.

      There will most likely be some parts that dont work now which I've missed, just make an issue and we'll get them resoved quickly.

      Creating service resources must also be async now, e.g.

      .. code-block:: python

          async def main():
              session = aioboto3.Session()
              async with session.resource("s3") as s3:
                  bucket = await s3.Bucket('mybucket')  # <----------------
                  async for s3_object in bucket.objects.all():
                      print(s3_object)


      Updating to aiobotocore 1.0.1 also brings with it support for running inside EKS as well as asyncifying ``get_presigned_url``

      ----

      This package is mostly just a wrapper combining the great work of boto3_ and aiobotocore_.

      aiobotocore allows you to use near enough all of the boto3 client commands in an async manner just by prefixing the command with ``await``.

      With aioboto3 you can now use the higher level APIs provided by boto3 in an asynchronous manner. Mainly I developed this as I wanted to use the boto3 dynamodb Table object in some async
      microservices.

      While all resources in boto3 should work I havent tested them all, so if what your after is not in the table below then try it out, if it works drop me an issue with a simple test case
      and I'll add it to the table.

      +---------------------------+--------------------+
      | Services                  | Status             |
      +===========================+====================+
      | DynamoDB Service Resource | Tested and working |
      +---------------------------+--------------------+
      | DynamoDB Table            | Tested and working |
      +---------------------------+--------------------+
      | S3                        | Working            |
      +---------------------------+--------------------+
      | Kinesis                   | Working            |
      +---------------------------+--------------------+
      | SSM Parameter Store       | Working            |
      +---------------------------+--------------------+
      | Athena                    | Working            |
      +---------------------------+--------------------+


      Example
      -------

      Simple example of using aioboto3 to put items into a dynamodb table

      .. code-block:: python

          import asyncio
          import aioboto3
          from boto3.dynamodb.conditions import Key


          async def main():
              session = aioboto3.Session()
              async with session.resource('dynamodb', region_name='eu-central-1') as dynamo_resource:
                  table = await dynamo_resource.Table('test_table')

                  await table.put_item(
                      Item={'pk': 'test1', 'col1': 'some_data'}
                  )

                  result = await table.query(
                      KeyConditionExpression=Key('pk').eq('test1')
                  )

                  # Example batch write
                  more_items = [{'pk': 't2', 'col1': 'c1'}, \
                                {'pk': 't3', 'col1': 'c3'}]
                  async with table.batch_writer() as batch:
                      for item_ in more_items:
                          await batch.put_item(Item=item_)

          loop = asyncio.get_event_loop()
          loop.run_until_complete(main())

          # Outputs:
          #  [{'col1': 'some_data', 'pk': 'test1'}]


      Things that either dont work or have been patched
      -------------------------------------------------

      As this library literally wraps boto3, its inevitable that some things won't magically be async.

      Fixed:

      - ``s3_client.download_file*``  This is performed by the s3transfer module. -- Patched with get_object
      - ``s3_client.upload_file*``  This is performed by the s3transfer module. -- Patched with custom multipart upload
      - ``s3_client.copy``  This is performed by the s3transfer module. -- Patched to use get_object -> upload_fileobject
      - ``dynamodb_resource.Table.batch_writer``  This now returns an async context manager which performs the same function
      - Resource waiters - You can now await waiters which are part of resource objects, not just client waiters, e.g. ``await dynamodbtable.wait_until_exists()``
      - Resource object properties are normally autoloaded, now they are all co-routines and the metadata they come from will be loaded on first await and then cached thereafter.
      - S3 Bucket.objects object now works and has been asyncified. Examples here - https://aioboto3.readthedocs.io/en/latest/usage.html#s3-resource-objects


      Amazon S3 Client-Side Encryption
      --------------------------------

      Boto3 doesn't support AWS client-side encryption so until they do I've added basic support for it. Docs here CSE_

      CSE requires the python ``cryptography`` library so if you do ``pip install aioboto3[s3cse]`` that'll also include cryptography.

      This library currently supports client-side encryption using KMS-Managed master keys performing envelope encryption
      using either AES/CBC/PKCS5Padding or preferably AES/GCM/NoPadding. The files generated are compatible with the Java Encryption SDK
      so I will assume they are compatible with the Ruby, PHP, Go and C++ libraries as well.

      Non-KMS managed keys are not yet supported but if you have use of that, raise an issue and i'll look into it.



      Documentation
      -------------

      Docs are here - https://aioboto3.readthedocs.io/en/latest/

      Examples here - https://aioboto3.readthedocs.io/en/latest/usage.html


      Features
      ========

      * Closely mimics the usage of boto3.

      Todo
      ====

      * More examples
      * Set up docs
      * Look into monkey-patching the aws xray sdk to be more async if it needs to be.


      Credits
      -------

      This package was created with Cookiecutter_ and the `audreyr/cookiecutter-pypackage`_ project template.
      It also makes use of the aiobotocore_ and boto3_ libraries. All the credit goes to them, this is mainly a wrapper with some examples.

      .. _aiobotocore: https://github.com/aio-libs/aiobotocore
      .. _boto3: https://github.com/boto/boto3
      .. _Cookiecutter: https://github.com/audreyr/cookiecutter
      .. _`audreyr/cookiecutter-pypackage`: https://github.com/audreyr/cookiecutter-pypackage
      .. _CSE: https://aioboto3.readthedocs.io/en/latest/cse.html

    '';
    license = licenses.asl20;
    homepage = "https://github.com/terrycain/aioboto3";
    maintainers = with maintainers; [ ];
  };
}
