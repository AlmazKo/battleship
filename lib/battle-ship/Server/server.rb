# @author
module BattleShip::Server
  @@mutex = Mutex.new

  class Server
    NAME    = 'Battleship-server v.0.1'
    @@mutex = Mutex.new
    @@server
    @@sockets = []

    @@sessions   = {}
    @@protocol = BattleShip::Protocol.new

    def self.init(port = 2001)
      @@server  = ::TCPServer.open(port)
      @@sockets = [@@server]
      @@sessions   = {}

      puts "Open port: #{port}"
    end

    def puts string
      @@mutex.synchronize do
        super (Time.now.strftime("%H:%M:%S:%3N") << ' ' << string)
      end
    end

    def log string
      puts string
    end

  end

end