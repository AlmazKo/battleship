module BattleShip::Server
  class Notifier < Server

    def initialize
      puts 'Notifier-server has started!'

      loop do

        puts @@sockets.inspect
        if @@sockets[1]
          puts 'OK...'
          @@sockets[1].puts 'CHECK'
        else
          puts 'succ...'
        end
        sleep 1
      end

    end


  end
end
