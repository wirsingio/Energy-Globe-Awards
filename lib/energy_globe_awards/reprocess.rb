require 'json'

class Reprocess
  def initialize source, destination
    @source = source
    @destination = destination
  end

  def reprocess
    raw = File.read(@source)
    json = JSON.load(raw)
    json = json.reverse
    output = "["
    output << "\n#{JSON.dump(json.shift)}"
    json.each do |line|
      output << ",\n"
      output << JSON.dump(line)
    end
    output << "\n]"
    File.open(@destination, 'w') { |f| f.puts output }
  end

end
