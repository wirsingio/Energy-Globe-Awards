require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

require 'middleman'
require 'middleman-jasmine'
require 'middleman/jasmine/tasks'

$:.unshift File.expand_path('../lib', __FILE__)
require 'energy_globe_awards/reprocess'

# Create `rake test`
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.pattern = "spec/*_spec.rb"
end

DATA_DEST_PATH   = File.expand_path('../source/data/awards.json', __FILE__)
DATA_SRC_PATH    = File.expand_path('../data/awards.json', __FILE__)
INJECT_DEST_PATH = File.expand_path('../data/injectable.yml', __FILE__)

desc "Default task is to ensure injectable data is available"
task :default => [INJECT_DEST_PATH]

desc 'reprocess data to remove bad images, add hyphens'
file DATA_DEST_PATH do
  require 'bundler/setup'
  puts "Reprocessing source data..."
  processor = Reprocess.new(DATA_SRC_PATH, DATA_DEST_PATH)
  processor.reprocess
  puts "Done"
end

desc 'Add first awards to HTML for faster load'
file INJECT_DEST_PATH => DATA_DEST_PATH do
  record_count = 30
  puts "Creating %i records for faster data load..." % record_count
  raw_data     = File.read(DATA_DEST_PATH)
  json         = JSON.parse(raw_data)
  first_awards = json[0...record_count]

  File.open(INJECT_DEST_PATH, 'w') do |f|
    f.write(YAML.dump(first_awards))
  end
  puts "Done"
end
