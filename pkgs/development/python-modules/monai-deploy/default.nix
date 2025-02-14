{
  lib,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  networkx,
  numpy,
  pytest-lazy-fixture,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typeguard,
  versioneer,
}:

buildPythonPackage rec {
  pname = "monai-deploy";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Project-MONAI";
    repo = "monai-deploy-app-sdk";
    tag = version;
    hash = "sha256-a5WtU+1XjsYsXB/uZS8ufE0fOOWDf+Wy7mOX2xPEQEg=";
  };

  postPatch = ''
    # Asked in https://github.com/Project-MONAI/monai-deploy-app-sdk/issues/450
    # if this patch can be incorporated upstream.
    substituteInPlace pyproject.toml \
      --replace-fail 'versioneer-518' 'versioneer'
  '';

  build-system = [
    versioneer
    setuptools
  ];

  dependencies = [
    numpy
    networkx
    colorama
    typeguard
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-lazy-fixture
  ];

  disabledTests = [
    # requires Docker daemon:
    "test_packager"
  ];

  pythonImportsCheck = [
    "monai.deploy"
    "monai.deploy.core"
    # "monai.deploy.operators" should be imported as well but
    # requires some "optional" dependencies
    # like highdicom and pydicom
  ];

  meta = with lib; {
    description = "Framework and tools to design, develop and verify AI applications in healthcare imaging";
    mainProgram = "monai-deploy";
    homepage = "https://monai.io/deploy.html";
    changelog = "https://github.com/Project-MONAI/monai-deploy-app-sdk/blob/main/docs/source/release_notes/v${version}.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
