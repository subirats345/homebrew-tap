require "base64"

class Kuma < Formula
  desc "Tiny native Markdown-to-PDF renderer for macOS"
  homepage "https://github.com/subirats345/kuma"
  url "https://github.com/subirats345/kuma/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "28e5e1ee54eb3fb050a60d102c4668891972f47380b3ab9ac24d2487a31f96b6"
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

      Kuma supports **bold**, *italic*, `inline code`, [links](https://example.com), and ~~strikethrough~~.

      - Native PDF output
      - [x] Small Markdown input
      - [ ] Tables and lists

      1. Parse Markdown
      2. Render PDF

      | Feature | Status |
      | --- | --- |
      | Tables | Done |

      ```text
      height = lines * line_height
      ```
    MARKDOWN

    sample_png = <<~BASE64
      iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADUlEQVR4nGP4z8AAAAMBAQDJ/pLvAAAAAElFTkSuQmCC
    BASE64
    (testpath/"sample.png").binwrite(Base64.decode64(sample_png))

    assert_match "Kuma 0.10.0", shell_output("#{bin}/kuma --version")
    system bin/"kuma", "init", "starter.md"
    assert_path_exists testpath/"starter.md"
    system bin/"kuma", "starter.md", "starter.pdf"
    assert_path_exists testpath/"starter.pdf"
    assert_predicate testpath/"starter.pdf", :size?

    system bin/"kuma", "sample.md", "sample.pdf"
    assert_path_exists testpath/"sample.pdf"
    assert_predicate testpath/"sample.pdf", :size?

    interactive_output = pipe_output("#{bin}/kuma", "sample.md\ninteractive.pdf\nn\nn\n", 0)
    assert_match "Interactive PDF render", interactive_output
    assert_path_exists testpath/"interactive.pdf"
    assert_predicate testpath/"interactive.pdf", :size?
  end
end
