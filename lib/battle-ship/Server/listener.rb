# @author
require 'digest'
module BattleShip::Server

  class Listener <  Server

    # @param [Game] game
    def initialize(commands_queue)
      puts 'Listener-server has started!'
      @in_commands_queue = commands_queue
      @out_commands_queue = Queue.new
    end


    # @return [Session]
    def client_identify(client_socket)
      _, port, host, ip = client_socket.peeraddr

      #session = Digest::MD5.hexdigest(client_socket.object_id)
      session_id = client_socket.object_id
      if @@sessions.key? session_id
        session = @@sessions[session_id]
        log "Reconnect %s:%s. Session id: %s, last activity date: %s" %
                [ip, port, session.id, session.last_activity_date.strftime('%Y-%m-%d %H:%M:%S')]
      else
        session = @@sessions[session_id] = Session.new(ip, port)
        log "Connect %s:%s. New session id: %s" % [ip, port, session.id]
      end

      key = Digest::MD5.hexdigest(user_session)
      @in_commands_queue.enq [session_id, Protocol.auth_accept(key)]
      nil
    end

    def cycle
      loop do
        puts  select(@@sockets).inspect
        readable = select(@@sockets)[0]

        readable.each do |socket|
          if socket == @@server

            new_client_socket = @@server.accept
            @@sockets << new_client_socket

            client.puts "#{NAME} connect"
            user = client_identify(new_client_socket)
            #
            #begin
            #  @game.add_gamer(user)
            #  user.auth = true
            #rescue
            #  client.puts $!
            #
            #else
            #  client.puts "You have been include to game"
            #end
          else

            begin

              user = @@sessions[socket.object_id]
              command = @@protocol.processing(socket)

              case(command.code)
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
                  @in_commands_queue.enq(user, command)
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