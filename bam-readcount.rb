require 'formula'

class BamReadcount < Formula
  homepage 'https://github.com/genome/bam-readcount'
  url 'https://github.com/genome/bam-readcount.git', :tag => 'v0.4.4'
  version '0.4.4'
  head 'https://github.com/genome/bam-readcount.git'

  depends_on 'cmake' => :build
  depends_on 'samtools'

  def patches
    unless build.head?
      'https://github.com/genome/bam-readcount/commit/da6a8c626564c741a39e2b807a41ea31bc097052.diff'
    end
  end

  def install
    samtools = Formula.factory('samtools').opt_prefix
    ENV['SAMTOOLS_ROOT'] = "#{samtools}:#{samtools}/include/bam"
    system 'cmake', '.', *std_cmake_args
    system 'make'
    bin.install 'bin/bam-readcount'
  end

  test do
    system 'bam-readcount 2>&1 |grep -q bam-readcount'
  end
end
