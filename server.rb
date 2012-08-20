# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)

require "battle-ship/server"
include BattleShip::Server


Signal.trap("INT") do
  puts "Terminating..."
  exit
end


game_thread = Thread.new {
  Thread.current[:game] = Game.new
}

Server::init

listener_thread = Thread.new {
  server = Listener.new game_thread
  server.cycle
}

notifier_thread = Thread.new {
  Notifier.new
}




main = Thread.main
current = Thread.current
all = Thread.list
all.each { |t| t.join unless t == current or t == main }