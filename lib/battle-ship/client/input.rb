# coding: utf-8
module BattleShip::Client
  class Input < ::Thread

    ESC = "\e"
    DOWN = "\e[B"
    UP = "\e[A"
    LEFT = "\e[D"
    RIGHT = "\e[C"
    ENTER = "\r"

    def initialize(stream = STDIN)
      @control = false

      @thread = super(stream) { |stream|
        @stream = stream
        cycle()
      }

      self[:bindings] = {
          on_key_press: {},
          on_submit: nil
      }

    end

    alias stop exit

    # @param [String] key
    # @param [Proc] lambda
    def on_key_press(key, lambda)
      self[:bindings][:on_key_press][key] = lambda
    end

    # @param [Proc] lambda
    def on_submit(lambda)
      #lambda.arity
      self[:bindings][:on_submit] = lambda
    end

    private

    def start_listening
      system 'stty raw -echo'
    end

    def stop_listening
      system 'stty -raw echo'
    end

    #TODO refactor it!
    def cycle
      bindings = self[:bindings]
      start_listening()
      cmd = ''

      loop do
        reading = @stream.getc
        cmd << reading

        if !@control && cmd.length == 1 && cmd[0] == ESC
          @control = true
        end

         if @control
           key = cmd
         else
           key = cmd[-1]
         end

        if bindings[:on_key_press][key]


          bindings[:on_key_press][key].call
          cmd = ''
        end

        if !@control && cmd.length > 1 &&  cmd[-1] == ENTER
          string = cmd.chomp(ENTER)
          bindings[:on_submit].call(string)
          cmd = ''
        end
      end

    ensure
      puts $!.inspect
      stop_listening()
    end

  end
end