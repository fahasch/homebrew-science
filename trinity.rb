require 'formula'

class Trinity < Formula
  homepage 'http://trinityrnaseq.sourceforge.net'
  version 'r2013-02-25'
  url 'http://downloads.sourceforge.net/trinityrnaseq/trinityrnaseq_r2013-02-25.tgz'
  sha1 '5fdb2682f861828750add2152154ec515e6e78c8'

  depends_on 'bowtie'

  fails_with :clang do
    build 425
    cause <<-EOS.undent
      clang does not support OpenMP, and including omp.h fails
    EOS
  end

  def install
    system "make"
    # The Makefile is designed to build in place, so we copy all of the needed
    # subdirectories to the prefix.
    prefix.install %w(Trinity.pl Inchworm Chrysalis Butterfly trinity-plugins util)

    # Trinity.pl (the main wrapper script) must remain in the prefix directory,
    # because it uses relative paths to the in-place build. So we create a
    # symlink in bin to put the wrapper in the user's path.
    mkdir_p bin
    ln_s prefix/'Trinity.pl', bin/'Trinity.pl'

    # Also install a small test case.
    (prefix + 'sample_data').install 'sample_data/test_Trinity_Assembly'
  end

  def test
    ohai "Testing Trinity assembly on a small data set (requires ~2GB of memory)"
    cd prefix/'sample_data/test_Trinity_Assembly'
    system "./runMe.sh"
    system "./cleanme.pl"
  end
end
