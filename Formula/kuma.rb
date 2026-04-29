require "base64"

class Kuma < Formula
  desc "Tiny native Markdown-to-PDF renderer for macOS"
  homepage "https://github.com/subirats345/kuma"
  url "https://github.com/subirats345/kuma/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "9647b7b38482f1a9b1b76701a07288f835a757932a0c5ffddee1a7062318a685"
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

    assert_match "aizome", shell_output("#{bin}/kuma --list-themes")
    system bin/"kuma", "sample.md", "--theme", "aizome", "sample.pdf"
    assert_path_exists testpath/"sample.pdf"
    assert_predicate testpath/"sample.pdf", :size?
  end
end
