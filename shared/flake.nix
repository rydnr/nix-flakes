{
  description = "Shared functions for my flakes";
  outputs = { self }: { lib = import ./shared.nix; };
}
