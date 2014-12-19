require 'json'

class JSONWriter
  def initialize(awards, data_path)
    @awards = awards
    @data_path = data_path
  end

  def write!
    data = serialize_list
    raw = JSON.dump(data)
    File.open(@data_path, 'w') { |f| f.write(raw) }
  end

  def serialize_list
    @awards.map { |award| award.to_json }
  end
end
