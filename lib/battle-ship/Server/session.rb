# @author
module BattleShip::Server

  class Session
    @@gid = 0
    @@mutex = Mutex.new

    attr_reader :id, :ip, :port, :last_activity_date

    def initialize(ip, port)
      @ip, @port, @last_activity_date = ip, port, Time.now
      @auth = false

      @@mutex.synchronize {
        @@gid += 1
        @id = @@gid
      }
    end


  end
end