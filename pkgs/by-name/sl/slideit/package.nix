{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  chromium,
  nix-update-script,
  withPdf ? true,
}:

buildNpmPackage (finalAttrs: {
  pname = "slideit";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "geraldserafin";
    repo = "md-slides";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7estwD3tWD76TtGsaDovslZUyAOZo0OKqUfhYyTKIgI=";
  };

  npmDepsHash = "sha256-h8P1rQ8hGqd+8E3kkbG9cbB4zf1tf/WcJQnMtt6qKhI=";

  nativeBuildInputs = [ makeWrapper ];

  # the plain-JS markup modules (lib/) and the prebuilt viewers (viewer/) that the package ships
  npmBuildScript = "build:package";

  # the pdf target prints with Chromium
  postInstall = lib.optionalString withPdf ''
    wrapProgram $out/bin/slides --set-default CHROMIUM ${lib.getExe chromium}
    wrapProgram $out/bin/slideit --set-default CHROMIUM ${lib.getExe chromium}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Presentations written in a small tag markup, with code transitions animated by an AST diff";
    homepage = "https://github.com/geraldserafin/md-slides";
    changelog = "https://github.com/geraldserafin/md-slides/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    mainProgram = "slides";
    maintainers = with lib.maintainers; [ geraldserafin ];
    platforms = lib.platforms.unix;
  };
})
