module BattleShip
  class Protocol
    DISCONNECT = 1
    QUIT = 30

    MAP  = 10
    FIRE = 20
    QUIT = 30

    def processing(socket)
      input = socket.recv(1024)
      unless input
        return DISCONNECT
      end

      input = input.unpack('C*')
      code, body = input.shift, input

      case(code)
        when QUIT
          return QUIT
        when JOIN_GAME
          return JOIN_GAME
        when SEND_MAP
          return code, body
        when GAME_STATUS
          return GAME_STATUS
        when FIRE
          return code, body
        else
          raise "unrecognized command: #{code}"
      end
    end

    def forwarding(socket, code, body = nil)
      data = [code]
      data.push(body)
      socket.write data.pack('C*')
    end

  end
end
