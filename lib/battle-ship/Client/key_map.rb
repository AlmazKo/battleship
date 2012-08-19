# coding: utf-8
module BattleShip::Client
  class KeyMap

    ESC   = "\e"
    DOWN  = "\e[B"
    UP    = "\e[A"
    LEFT  = "\e[D"
    RIGHT = "\e[C"
    ENTER = "\r"

    STOP = false



    def initialize(stream = STDIN)
      @binds = {}
      @stream = stream
      trap("INT") do
        puts "Client terminating..."
        exit
      end
    end

    def start
      system 'stty raw -echo'
      cmd = ''
      loop do
        cmd << @stream.getc
        if @binds[cmd]
          if @binds[cmd].call == false
            self.stop
            return
          end
          cmd = ''
        end

        cmd = '' if cmd[0] != "\e"
      end
    end

    def stop
      system 'stty -raw echo'
    end

    def bind(key, proc)


      @binds[key] = proc
    end

  end

end