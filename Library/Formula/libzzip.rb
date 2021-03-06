require 'formula'

class Libzzip < Formula
  homepage 'http://sourceforge.net/projects/zziplib/'
  url 'https://downloads.sourceforge.net/project/zziplib/zziplib13/0.13.62/zziplib-0.13.62.tar.bz2'
  sha1 'cf8b642abd9db618324a1b98cc71492a007cd687'

  bottle do
    cellar :any
    revision 1
    sha1 "5a1b7004e05d64c363169b7437df6df13dcf442a" => :yosemite
    sha1 "9ba90a192f579f08425969b07abf9da33cf06b96" => :mavericks
    sha1 "986d13aa3974d0b7c2621a8447f1aad640f11d92" => :mountain_lion
  end

  option 'with-sdl', 'Enable SDL usage and create SDL_rwops_zzip.pc'
  option :universal

  deprecated_option "sdl" => "with-sdl"

  depends_on 'pkg-config' => :build
  depends_on 'sdl' => :optional

  conflicts_with 'zzuf', :because => 'both install `zzcat` binaries'

  def install
    if build.universal?
      ENV.universal_binary
      # See: https://sourceforge.net/tracker/?func=detail&aid=3511669&group_id=6389&atid=356389
      ENV["ac_cv_sizeof_long"] = "(LONG_BIT/8)"
    end

    args = %W[
      --without-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--enable-sdl" if build.with? "sdl"
    system './configure', *args
    system 'make install'
    ENV.deparallelize   # fails without this when a compressed file isn't ready
    system 'make check' # runing this after install bypasses DYLD issues
  end
end
