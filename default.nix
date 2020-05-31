{ nixpkgs ? import ./nix/nixpkgs.nix
}:

with nixpkgs;

let filterSource = with lib; builtins.filterSource (path: type:
      type != "unknown" &&
      baseNameOf path != "target" &&
      baseNameOf path != "result" &&
      baseNameOf path != ".git" &&
      (baseNameOf path == "build" -> type != "directory") &&
      (baseNameOf path == "nix" -> type != "directory")
    );
in
naersk.buildPackage {
  root = filterSource ./.;

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
  buildInputs = [ onnxruntime.dev pkg-config clang ];

  doDoc = true;
  doCheck = true;
}
