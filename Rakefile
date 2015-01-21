require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

require 'middleman'
require 'middleman-jasmine'
require 'middleman/jasmine/tasks'

require_relative './lib/energy_globe_awards/reprocess'

desc 'reprocess data to remove bad images, add hyphens'
task :reprocess do
  Reprocess.new(File.expand_path('../source/data/awards.json', __FILE__))
end
