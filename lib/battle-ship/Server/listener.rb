# @author
module BattleShip::Server

  class Listener <  Server

    # @param [Game] game
    def initialize(game)
      puts 'Listener-server has started!'
      @game = game[:game]
    end


    # @return [User]
    def client_identify(client)
      _, port, host, ip = client.peeraddr

      user_session = client.object_id
      if @@users.key? ip
        user = @@users[user_session]
        log "Reconnect %s:%s. User id: %s, registration date: %s" %
                [ip, port, user.id, user.register_date.strftime('%Y-%m-%d %H:%M:%S')]
      else
        user = @@users[user_session] = User.new(ip, port)
        log "Connect %s:%s. New user id: %s, registration date: %s" %
                [ip, port, user.id, user.register_date.strftime('%Y-%m-%d %H:%M:%S')]
      end
      user
    end

    def cycle
      loop do
        puts  select(@@sockets).inspect
        readable = select(@@sockets)[0]

        readable.each do |socket|
          if socket == @@server

            client = @@server.accept
            @@sockets << client

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
          else

            begin

              user = @@users[socket.object_id]
              command = @@protocol.processing(socket)

              case(command)
                when Protocol::DISCONNECT
                  puts "Client %s:%s disconnect" % [user.ip, user.port]
                  socket.delete(socket)
                  socket.close
                  next
                when Protocol::QUIT
                  @@sockets.delete(socket)
                  socket.puts 'Good bue!'
                  puts "User #%s, %s:%s left" % [user.id, user.ip, user.port]
                  socket.close
                else
                  @game.add_command(user, command)
              end

            rescue
              puts $!.inspect
              puts "Error, client disconnect"
              @@sockets.delete(socket)
              socket.close
            end
          end
        end
      end
    end
  end

end