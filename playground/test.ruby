# Used by configure and make to download or update mirrored Ruby and GCC
# files. This will use HTTPS if possible, falling back to HTTP.

require 'fileutils'
require 'open-uri'
require 'pathname'
begin
  require 'net/https'
rescue LoadError
  https = 'http'
else
  https = 'https'

  # open-uri of ruby 2.2.0 accepts an array of PEMs as ssl_ca_cert, but old
  # versions do not.  so, patching OpenSSL::X509::Store#add_file instead.
  class OpenSSL::X509::Store
    alias orig_add_file add_file
    def add_file(pems)
      Array(pems).each do |pem|
        if File.directory?(pem)
          add_path pem
        else
          orig_add_file pem
        end
      end
    end
  end
  # since open-uri internally checks ssl_ca_cert using File.directory?,
  # allow to accept an array.
  class <<File
    alias orig_directory? directory?
    def File.directory? files
      files.is_a?(Array) ? false : orig_directory?(files)
    end
  end
end

class Downloader
  def self.find(dlname)
    constants.find do |name|
      return const_get(name) if dlname.casecmp(name.to_s) == 0
    end
  end

end
