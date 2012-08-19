# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)

require "battle-ship/client"
include BattleShip::Client

map = ShipDisposal::start

client = BattleShip::Client::Client.new
client.to_send(Client::MAP, map)
client.start()


