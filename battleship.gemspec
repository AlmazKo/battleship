# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)


Gem::Specification.new do |gem|
  gem.name          = 'battleship'
  gem.author        = 'Alexander Suslov'
  gem.email         = ['a.s.suslov@gmail.com']
  gem.description   = %q{Client-server game}
  gem.summary       = gem.description
  gem.homepage      = 'https://github.com/AlmazKo/BashVisual'

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = `git ls-files -- {test}/*`.split($\)
  gem.require_paths = ['lib']
  gem.version       = 0.01
  gem.license       = 'MIT'
end
