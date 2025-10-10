class ZoteroPdf2zh < Formula
  desc "Zotero PDF → ZH local server (uv-based)"
  homepage "https://github.com/NightWatcher314/homebrew-zotero-pdf2zh"
  # Replace the following url/sha256 with your own release tarball when publishing.
  # Example: a release created from this repository containing the project files at root.
  # url "https://github.com/<you>/<repo>/archive/refs/tags/vX.Y.Z.tar.gz"
  # sha256 "<fill-me>"

  # For development/use without a release tarball, you can install from HEAD
  # after pushing this repo to a remote and using --HEAD.
  head "https://github.com/NightWatcher314/homebrew-zotero-pdf2zh.git", branch: "main"

  depends_on "uv"
  # Optional but recommended so uv can prefer system Python instead of downloading one.
  depends_on "python@3.12"

  def install
    # Install the whole project into libexec so we can run it in-place with uv.
    libexec.install Dir["*"]

    # Wrapper: ensures writable config/data live under Homebrew var, then runs via uv.
    (bin/"zotero-pdf2zh").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail
      ROOT="#{opt_libexec}"
      DATA="#{var}/zotero-pdf2zh"
      # Prefer the Homebrew Python if available to avoid downloads
      export UV_PYTHON_DOWNLOADS="prefer-system"
      # Prepare writable directories and link them into the install tree
      mkdir -p "$DATA/config" "$DATA/translated"
      cd "$ROOT"
      ln -snf "$DATA/config" config
      ln -snf "$DATA/translated" translated
      # Run the server (pass through any extra args)
      exec "#{Formula["uv"].opt_bin}/uv" run server.py "$@"
    SH
    chmod 0755, bin/"zotero-pdf2zh"
  end

  service do
    # Use the wrapper and default to the port used in run.sh
    run [opt_bin/"zotero-pdf2zh", "--port", "47700", "--check_update", "false"]
    keep_alive true
    # Run from libexec so relative paths resolve consistently
    working_dir opt_libexec
    log_path var/"log/zotero-pdf2zh.log"
    error_log_path var/"log/zotero-pdf2zh.log"
  end

  test do
    # Ensure the wrapper is callable and prints help without starting the server
    system bin/"zotero-pdf2zh", "--help"
  end
end

