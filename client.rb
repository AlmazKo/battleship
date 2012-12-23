# author: Almazko
# 2012


$:.push File.expand_path('../lib', __FILE__)

require "battle-ship/client"

BattleShip::Client::Game.new().start

