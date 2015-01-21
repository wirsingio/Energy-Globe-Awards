require 'json'

class Reprocess
  def initialize source, destination
    @source = source
    @destination = destination
    @json = nil
  end

  def reprocess
    load_file
    reverse
    print_to_file
  end

  def load_file
    raw = File.read(@source)
    @json = JSON.load(raw)
  end

  def reverse
    @json = @json.reverse
  end

  def print_to_file
    File.open(@destination, 'w') { |f|
      f << "["
      f << "\n#{JSON.dump(@json.shift)}"
      @json.each do |line|
        f << ",\n"
        f << JSON.dump(line)
      end
      f << "\n]"
    }
  end


end
