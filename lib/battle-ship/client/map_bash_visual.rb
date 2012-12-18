# coding: utf-8
module BattleShip::Client
  module MapBashVisual

    require "bash-visual"

    include ::Bash_Visual
    include FixedObject


    def draw
    @builder = Builder.new
    @console = Console.new

      @console.position = @x, @y
      @map.each_with_index do |row, y|
        string = ''
        row.each_with_index do |cell, x|

          if ([x, y] == @cursor)
            is_cursor = true
          else
            is_cursor = false
          end

          symbol, type, fg, bg = '~', [:std], :white, :dark_blue

          case cell
            when Map::EMPTY
              symbol = '~'
              fg = :blue
            when Map::SHIP
              fg = :yellow
              symbol = '='
            when Map::STRICKEN
              fg = :red
              symbol = 'X'
          end

          if is_cursor
            type << :blink
            bg = :red
          end

          string << @builder.write(symbol, Font.new(type, fg, bg))

        end
        @console.write_to_position(1, y+1, string)
      end

    end
  end
end
