# coding: utf-8
module BattleShip::Client
  class Client
    require 'socket'

    MAP  = 10
    FIRE = 20
    QUIT = 30

    def initialize(host = 'localhost', port = 2001)
      puts 'Connecting....'
      @socket = TCPSocket.open(host, port)
      puts 'Done!'
    end

    def to_send(type, message = nil)
      case type
        when MAP
          data = message.map.flatten.unshift(MAP)
          @socket.write data.pack('C*')
        when QUIT

          @socket.write [QUIT].pack('C*')  if @socket
        else
          return
      end
      @socket.flush
    end

    def start
      cycle()
    ensure
      @socket.close if @socket
    end

    def cycle
      local, peer = @socket.addr, @socket.peeraddr
      puts "Осуществлено подключение к #{peer[2]}:#{peer[1]}"
      puts "Используется локальный порт #{local[1]}"

      Thread.new {
        loop do
          response = @socket.readpartial(1024).chop
          puts "RESPONSE "+response
        end
      }
      kb = KeyMap.new
      kb.bind 'q', -> { to_send(QUIT); next KeyMap::STOP }
      kb.start
    end
  end

end