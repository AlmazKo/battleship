SPEC_DIR = File.dirname(__FILE__)

require "simplecov"
require "rspec"

require "fake_blocking_stream"
require "battle-ship"


SimpleCov.coverage_dir(SPEC_DIR + '/../.coverage')
SimpleCov.start

$:.push File.expand_path('../lib', __FILE__)
