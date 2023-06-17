rec {
  shellHook-for = { package, nodejs, nixpkgsRelease }: ''
    export PNAME="${package.pname}";
    export PVERSION="${package.version}";
    export NVERSION="${nodejs.name}";
    export NIXPKGSRELEASE="${nixpkgsRelease}";
    export PS1="\033[37m[\[\033[01;33m\]\$PNAME-\$PVERSION\033[01;37m|\033[01;32m\]\$NVERSION\]\033[37m|\[\033[00m\]\[\033[01;34m\]\W\033[37m]\033[31m\$\[\033[00m\] ";
    echo;
    echo -e " \033[32m___________         __                 __             \033[37mMIT\033[0m";
    echo -e " \033[32m\_   _____/__  ____/  |_____________ _/  |_  ___________  _____  \033[0m";
    echo -e " \033[32m |    __)_\  \/  /\   __\_  __ \__  \\   __\/ __ \_  __ \/     \ \033[32mhttps://github.com/nixos/nixpkgs/$NIXPKGSRELEASE\033[0m";
    echo -e " \033[32m |        \>    <  |  |  |  | \// __ \|  | \  ___/|  | \/  Y Y  \\033[33mhttps://extraterm.org\033[0m";
    echo -e " \033[32m/_______  /__/\_ \ |__|  |__|  (____  /__|  \___  >__|  |__|_|  /\033[34https://github.com/sedwards2009/extraterm\033[0m";
    echo -e " \033[32m        \/      \/                  \/          \/            \/ \033[0m";
    echo;
    echo " Thank you for using sedwards2009's Extraterm, and for your appreciation of free software.";
    echo;
  '';
  devShell-for = { package, nodejs, pkgs, nixpkgsRelease }:
    pkgs.mkShell {
      buildInputs = [ package ];
      shellHook = shellHook-for { inherit package nodejs nixpkgsRelease; };
    };
}
