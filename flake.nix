{
  description = "@bazel_central_registry//tools:mcp_server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    bazel-central-registry = {
      url = "github:bazelbuild/bazel-central-registry";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, self, ... }@inputs:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system} = {
        default = self.packages.${system}.bcr-mcp-server;
        bcr-mcp-server = pkgs.writeShellApplication {
          name = "bcr-mcp-server";
          runtimeInputs = [ pkgs.bazelisk ];
          text = ''
            cd ${inputs.bazel-central-registry}
            bazelisk run //tools:mcp_server
          '';
        };
      };
    };
}
