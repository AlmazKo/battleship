# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)

require "battle-ship/server"
include BattleShip::Server


Signal.trap("INT") do
  puts "Terminating..."
  exit
end



game = Game.new
BattleShip::Server::Server.new(game)

