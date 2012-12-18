# coding: utf-8
module BattleShip::Client
  class KeyMap

    require 'syslog'
    #@@syslog  = Syslog.open($0, Syslog::LOG_PID | Syslog::LOG_CONS) { |s| s.warning "Danger!" }
    ESC = "\e"
    DOWN = "\e[B"
    UP = "\e[A"
    LEFT = "\e[D"
    RIGHT = "\e[C"
    ENTER = "\r"

    STOP = false

    attr_reader :listener

    def initialize(stream = STDIN)
      @bindings = {}
      @stream = stream
      @listener = nil
      trap("INT") do
        #puts "client terminating..."
        @listener.exit if @listener.alive?
        exit
      end
    end

    def start
      raise 'Don\t set bindings' if @bindings.empty?

      @run = true
      @listener = Thread.new(@stream, @bindings) { |stream, bindings|

        begin
          start_listening()
          cmd = ''

          loop do

            reading = @stream.getc
            unless reading
              sleep 0.01
              next
            end
            cmd << reading

            if @bindings[cmd]

              if @bindings[cmd].call == false
                break
              end
              cmd = ''
            end

            if cmd.length > 8
              stop_listening()
              raise 'Very long command'
            end

            cmd = '' if cmd[0] != "\e"
          end

        ensure
          stop_listening()
          @run = false
        end
      }

    end

    def stop
      @listener.exit
      @run = false
    end

    # @param [String] key
    # @param [Proc] proc
    def bind(key, proc)
      @bindings[key] = proc
    end

    def run?
      @listener && @run
    end

    private

    def start_listening
      system 'stty raw -echo'
    end

    def stop_listening
      system 'stty -raw echo'
    end

  end

end
