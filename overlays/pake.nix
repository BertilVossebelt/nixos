self: super: {
  pake = super.nodePackages.buildNodePackage rec {
    pname = "pake";
    version = "0.7.0";

    src = super.fetchFromGitHub {
      owner = "tw93";
      repo = "Pake";
      rev = "main";
      sha256 = "1qr83wlxi2saizjywb2c9vfn6kb1lksyqrs1whpjq62smz8y6j5h"; # get with nix-prefetch-git
    };

    buildInputs = [ super.rustc super.cargo ];

    meta = with super.lib; {
      description = "Pake - Web app wrapper";
      homepage = "https://github.com/tw93/Pake";
      license = licenses.mit;
      maintainers = [ maintainers.ajv ];
    };
  };
}
