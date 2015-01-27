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

desc 'reprocess data to remove bad images, add hyphens'
task :reprocess do
  require 'bundler/setup'
  source = File.expand_path('../data/awards.json', __FILE__)
  destination = File.expand_path('../source/data/awards.json', __FILE__)
  processor = Reprocess.new(source, destination)
  processor.reprocess
end
