require 'typhoeus'
require 'digest'

class CachedRequest
  # expire after one day
  FRESHTIME = ->(){ 60 * 60 * 24 }

  def initialize url
    @url = url
    @cache_dir = ENV['CACHEDIR'] ||
                 File.expand_path("../../../tmp/cache", __FILE__)
  end

  def fetch
    if raw = read_cache_file
      Marshal.load(raw)
    else
      make_and_cache_request
    end
  end

  def cache_filepath
    "%s/%s.cache" % [@cache_dir, Digest::MD5.hexdigest(@url)]
  end

  private

  def read_cache_file
    if File.exists?(cache_filepath) && file_is_fresh?
      File.read(cache_filepath)
    end
  end

  def file_is_fresh?
    (Time.now - File.stat(cache_filepath).mtime).to_f < FRESHTIME.call
  end

  def make_and_cache_request
    res = Typhoeus::Request.get(@url)
    serialized = Marshal.dump(res)
    File.open(cache_filepath, "w") { |f| f.write(serialized) }
    res
  end
end
