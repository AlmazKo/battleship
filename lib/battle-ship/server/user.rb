# @author
module BattleShip::Server

  class User
    @@gid = 0
    @@mutex = Mutex.new

    attr_reader :id, :ip, :port, :name, :register_date
    attr_writer :auth

    def initialize(ip, port)
      @ip, @port, @register_date = ip, port, Time.now
      @auth = false

      @@mutex.synchronize {
        @@gid += 1
        @id = @@gid
      }
    end

    def auth?
      @auth
    end

  end
end