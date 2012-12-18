# @author
module BattleShip::Server
  @@mutex = Mutex.new

  class Server
    NAME = 'Battleship-server v.0.1'
    # @param [Game] game
    def initialize(game)
      @game = game
      @server = ::TCPServer.open(2000)
      puts 'Battleship-server v.0.1 is ready!'
      @sockets = [@server]
      @users = {}
    end


    # @return [User]
    def client_identify(client)
      _, port, host, ip = client.peeraddr

      user_session = client.object_id
      if @users.key? ip
        user = @users[user_session]
        log "Reconnect %s:%s. User id: %s, registration date: %s" %
                [ip, port, user.id, user.register_date.strftime('%Y-%m-%d %H:%M:%S')]
      else
        user = @users[user_session] = User.new(ip, port)
        log "Connect %s:%s. New user id: %s, registration date: %s" %
                [ip, port, user.id, user.register_date.strftime('%Y-%m-%d %H:%M:%S')]
      end
      user
    end

    def cycle
      loop do

        readable = select(@sockets)[0]
        if(@sockets.size > 2)
          @sockets[1].puts 'ping'
        end
        readable.each do |socket|
          if socket == @server

            client = @server.accept
            @sockets << client

            client.puts "#{NAME} connect"
            user = client_identify(client)

            begin
              @game.add_gamer(user)
              user.auth = true
            rescue
              client.puts $!

            else
              client.puts "You have been include to game"
            end
            puts @sockets.inspect
          else

            begin
              input = socket.recv(1024)
              unless input
                puts "client %s:%s disconnect" % [socket.peeraddr[2], socket.peeraddr[1]]
                socket.delete(socket)
                socket.close
                next
              end

              input = input.unpack('C*')
              puts "<#{input}"


              code, body = input.shift, input
              user = @users[socket.object_id]

              if code == 30
                socket.puts 'Good bue!'
                puts "User #%s, %s:%s disconnect" % [user.id, user.ip, user.port]
                @sockets.delete(socket)
                socket.close
              elsif user.auth?

                begin
                  @game.add_command(user, code, body)
                rescue
                  socket.puts $!
                end

              end
            rescue
              puts $!.inspect
              puts "Error, client disconnect"
              @sockets.delete(socket)
              socket.close
            end
          end
        end
      end
    end


    def puts string
      super (Time.now.strftime("%H:%M:%S:%3N") << ' ' << string)
    end

    def log string
      puts string
    end

  end

end