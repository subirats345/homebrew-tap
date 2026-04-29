class Kuma < Formula
  desc "Tiny native Markdown-to-PDF renderer for macOS"
  homepage "https://github.com/subirats345/kuma"
  url "https://github.com/subirats345/kuma/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d86679e5cb2aee257893d32ca096e39d85245aa844f26044eb4f85773efde15f"
  license "MIT"

  def install
    system "swift", "build", "--configuration", "release", "--disable-sandbox"
    bin.install ".build/release/kuma"
    bin.install_symlink "kuma" => "ku"
  end

  test do
    (testpath/"sample.md").write <<~MARKDOWN
      # Kuma

      hello@example.com

      ## Notes

      - Native PDF output
      - Small Markdown input
    MARKDOWN

    system bin/"kuma", "sample.md", "sample.pdf"
    assert_path_exists testpath/"sample.pdf"
    assert_predicate testpath/"sample.pdf", :size?
  end
end
