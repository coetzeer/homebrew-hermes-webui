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
    (var/"hermes-webui").mkpath
  end

  service do
    run [opt_bin/"hermes-webui", "serve", "--port", "8787"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    working_dir var/"hermes-webui"
    log_path var/"log/hermes-webui.log"
    error_log_path var/"log/hermes-webui.error.log"
  end

  test do
    # Test that the console script is available and shows version
    assert_match "hermes-webui", shell_output("#{bin}/hermes-webui --help 2>&1")
  end

  def caveats
    <<~EOS
      Start the service (user-level deployment):
        brew services start #{name}

      On Linux, enable lingering so the service persists after logout and starts on boot:
        loginctl enable-linger $USER

      On macOS, launchd services run under restricted OS security policies (TCC).
      If hermes-webui requires access to protected user directories (e.g. ~/Desktop,
      ~/Downloads, ~/Documents), grant "Full Disk Access" to your terminal application
      and the node/python binaries in System Settings > Privacy & Security.
    EOS
  end
end
