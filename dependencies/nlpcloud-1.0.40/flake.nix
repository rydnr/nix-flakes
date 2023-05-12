{
  description = "A Nix flake for nlpcloud 1.0.40 Python package";

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
          nlpcloud-1.0.40 = (import ./nlpcloud-1.0.40.nix) {
            inherit (pythonPackages)
              buildPythonPackage fetchPypi
             inherit (pkgs) lib;
          };
          nlpcloud = packages.nlpcloud-1.0.40;
          default = packages.nlpcloud;
          meta = with lib; {
            description = ''
NLP Cloud serves high performance pre-trained or custom models for NER, sentiment-analysis, classification, summarization, paraphrasing, grammar and spelling correction, keywords and keyphrases extraction, chatbot, product description and ad generation, intent classification, text generation, image generation, blog post generation, code generation, question answering, automatic speech recognition, machine translation, language detection, semantic search, semantic similarity, tokenization, POS tagging, embeddings, and dependency parsing. It is ready for production, served through a REST API.

This is the Python client for the API.

More details here: https://nlpcloud.io

Documentation: https://docs.nlpcloud.io

Github: https://github.com/nlpcloud/nlpcloud-python


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
