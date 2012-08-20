# @author
module BattleShip::Server

  class Game
    @@mutex = Mutex.new

    # To change this template use File | Settings | File Templates.

    def initialize
        @current_user = 0
        @started = false
        @users = []
        @maps = [nil, nil]
    end


    def add_gamer(user)
      if @users.size < 2
        @@mutex.synchronize {
          raise 'Too many2 gamers!' if @users.size > 2
          @users << user
          start() if @users.size == 2
        }
      end

      raise 'Too many gamers!'
    end

    def start
      @started = true
    end

    def started?
      @started
    end

    def add_command(user, code, message)
      case code
        when 10
         raise "Game has started already!"
      end
    end

  end


end