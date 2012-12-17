require "simplecov"
require "rspec"

require "battle-ship"

SimpleCov.coverage_dir('.coverage')
SimpleCov.start

#$:.push File.expand_path('../lib', __FILE__)