# coding: utf-8
module BattleShip::Client
  include Entity

  class Game

    @@expected = [:exit]

    attr_reader :user_commands

    def initialize
      @user_commands = ::Queue.new

    end

    def start
      @stream = STDIN #FakeBlockingStream.new
      @input = Input.new @stream
      @output = Output.new(@input, @user_commands)

      @map = Entity::Map.new

     #raise 'Fail auth!' unless auth()

      #game = game_join()


      #
      #client = BattleShip::Client::Client.new
      #client.to_send(Client::MAP, map)
      #client.start()

      @input.on_key_press 'q', -> {

        @user_commands.push(:exit)
      }

      @user_commands.push(:ship_disposal)

      while command = @user_commands.pop

        puts command.inspect

            #if @@expected.include?(command)
              if :exit == command
                return self.send(command)
              else
                self.send(command)
              end
            #end
      end
      #
      #send_map(map)
      #
      #while game.run?
      #
      #  if game.current_gamer?
      #    get_command()
      #    send_command
      #  end
      #  draw_map
      #  waiting()
      #  draw_map
      #end
      #
      #if game.win?
      #  puts 'You win!'
      #else
      #  puts 'You looser!'
      #end
      #
      #show_all_ships()
      #

    ensure

      puts $!.inspect
      @input.exit

    end


    def exit
      puts 'Good b'
    end



    private


    def ship_disposal

      @@expected << :ship_disposal_end
      @output.ship_disposal(@map)
    end


    def ship_disposal_end
          puts '@@@'
    end

    def ui_event(event)


    end
  end
end