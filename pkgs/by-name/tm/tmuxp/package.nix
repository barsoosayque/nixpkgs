{
  lib,
  fetchPypi,
  installShellFiles,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "tmuxp";
  version = "1.50.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v7k0S0dMmpmwZkCJhPKiE+sEtVkOL+tE4Io66EIEXP0=";
  };

  build-system = with python3Packages; [
    hatchling
    shtab
  ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = with python3Packages; [
    colorama
    libtmux
    pyyaml
  ];

  # No tests in archive
  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd tmuxp \
      --bash <(shtab --shell=bash -u tmuxp.cli.create_parser) \
      --zsh <(shtab --shell=zsh -u tmuxp.cli.create_parser)
  '';

  meta = {
    description = "tmux session manager";
    homepage = "https://tmuxp.git-pull.com/";
    changelog = "https://github.com/tmux-python/tmuxp/raw/v${version}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "tmuxp";
  };
}
