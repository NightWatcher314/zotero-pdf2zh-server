class ZoteroPdf2zh < Formula
  desc "Zotero PDF → ZH local server (uv-based)"
  homepage "https://github.com/NightWatcher314/homebrew-zotero-pdf2zh"
  url "https://github.com/NightWatcher314/homebrew-zotero-pdf2zh/archive/refs/tags/v3.0.33.tar.gz"
  sha256 "5ffa2c98189a68a28576a96beaf55c3d5590177461006c9b245f28b5aa56ebdb"

  # For development/use without a release tarball, you can install from HEAD
  # after pushing this repo to a remote and using --HEAD.
  head "https://github.com/NightWatcher314/homebrew-zotero-pdf2zh.git", branch: "main"

  depends_on "uv"

  def install
    # Install the whole project into libexec so we can run it in-place with uv.
    libexec.install Dir["*"]

    # Wrapper: ensures writable config/data live under Homebrew var, then runs via uv.
    (bin/"zotero-pdf2zh").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail
      ROOT="#{opt_libexec}"
      DATA="#{var}/zotero-pdf2zh"
      SRC_CFG="$ROOT/config"
      DST_CFG="$DATA/config"

      mkdir -p "$DST_CFG" "$DATA/translated"
      # Seed example config files into writable config dir (if missing)
      if [ -d "$SRC_CFG" ]; then
        for f in "$SRC_CFG"/*.example; do
          [ -f "$f" ] || continue
          base="$(basename "$f")"
          if [ ! -f "$DST_CFG/$base" ]; then
            cp "$f" "$DST_CFG/$base"
          fi
        done
      fi
      # Link writable data into install tree and run
      cd "$ROOT"
      ln -snf "$DST_CFG" config
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
