require "base64"

class Kuma < Formula
  desc "Tiny native Markdown-to-PDF renderer for macOS"
  homepage "https://github.com/subirats345/kuma"
  url "https://github.com/subirats345/kuma/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "e6739be02e81a0c1384e28b48beff402b8e219f7a340e134406389232dac1687"
  license "MIT"
  depends_on :macos
  depends_on macos: :sonoma

  def install
    system "swift", "build", "--configuration", "release", "--disable-sandbox"
    bin.install ".build/release/kuma"
    bin.install_symlink "kuma" => "ku"
  end

  test do
    (testpath/"sample.md").write <<~MARKDOWN
      # Kuma

      hello@example.com

      ![sample](sample.png)

      ## Notes

      - Native PDF output
      - Small Markdown input

      ```text
      height = lines * line_height
      ```
    MARKDOWN

    sample_png = <<~BASE64
      iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADUlEQVR4nGP4z8AAAAMBAQDJ/pLvAAAAAElFTkSuQmCC
    BASE64
    (testpath/"sample.png").binwrite(Base64.decode64(sample_png))

    assert_match "Kuma 0.4.0", shell_output("#{bin}/kuma --version")
    system bin/"kuma", "sample.md", "sample.pdf"
    assert_path_exists testpath/"sample.pdf"
    assert_predicate testpath/"sample.pdf", :size?
  end
end
