class HermesWebui < Formula
  desc "Lightweight, dark-themed web interface for Hermes Agent"
  homepage "https://github.com/nesquena/hermes-webui"
  url "https://github.com/nesquena/hermes-webui/archive/refs/tags/exp-v0.52.264.tar.gz"
  sha256 "b6f89476986da87182b69a30d319db39d3c85679b392c2bca73a8ffe8fd5941b"
  license "MIT"
  head "https://github.com/nesquena/hermes-webui.git", branch: "master"

  depends_on "python@3.12"

  def install
    # The package uses setuptools with a console script entry point
    # Install into a dedicated prefix and link the console script
    system "pip3", "install", *std_pip_args, "."

    # Create state directories (like hermes-workspace formula)
    (var/"lib/hermes-webui").mkpath
    (var/"log/hermes-webui").mkpath
  end

  service do
    run [opt_bin/"hermes-webui", "serve", "--port", "8787"]
    keep_alive true
    log_path var/"log/hermes-webui/hermes-webui.log"
    error_log_path var/"log/hermes-webui/hermes-webui.log"
  end

  test do
    # Test that the console script is available and shows version
    assert_match "hermes-webui", shell_output("#{bin}/hermes-webui --help 2>&1")
  end
end
