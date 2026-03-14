class Grepdef < Formula
  desc "Quick search for symbol definitions in various programming languages"
  homepage "https://github.com/sirbrillig/grepdef"
  version "3.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sirbrillig/grepdef/releases/download/v3.5.0/grepdef-aarch64-apple-darwin.tar.gz"
      sha256 "2cdc0265eb9bfababccd2fac8fff70c4b0d1e620cdaa272f8df593156c3eef6a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sirbrillig/grepdef/releases/download/v3.5.0/grepdef-x86_64-apple-darwin.tar.gz"
      sha256 "d146de4af7ea2339b130e8b58836265eac0eb8c9d17c2df0eb73ef18b5157d6a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/sirbrillig/grepdef/releases/download/v3.5.0/grepdef-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a0838125e97171b66d3da9393619673058b93428f92dca57485e104127845e24"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "grepdef" if OS.mac? && Hardware::CPU.arm?
    bin.install "grepdef" if OS.mac? && Hardware::CPU.intel?
    bin.install "grepdef" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
