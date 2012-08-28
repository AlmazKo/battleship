# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)

require "battle-ship/server"
include BattleShip::Server


Signal.trap("INT") do
  puts "Terminating..."
  exit
end


commands_queue = Queue.new

game_thread = Thread.new(commands_queue) do |commands_queue|
  Thread.current[:game] = Game.new(commands_queue)
end

Server::init

listener_thread = Thread.new (commands_queue) do |commands_queue|
  server = Listener.new commands_queue
  server.cycle
end

notifier_thread = Thread.new {
  Notifier.new
}




main = Thread.main
current = Thread.current
all = Thread.list
all.each { |t| t.join unless t == current or t == main }