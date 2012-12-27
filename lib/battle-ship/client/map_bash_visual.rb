# coding: utf-8
module BattleShip::Client
  class MapBashVisual

    require "bash-visual"

    include ::Bash_Visual
    include FixedObject

    attr_reader :map

    # @param [BattleShip::Client::Entity::Map] map
    # @param [Console] console
    def initialize(map, console = Console.new)
      @x = 0
      @y = 0
      @width = map.width
      @height = map.height
      @map = map
      @console = console
    end

    def move_cursor(offset_x, offset_y)
      new_x = @cursor[0] + offset_x
      new_y = @cursor[1] + offset_y

      unless new_x < 0 or new_x >= @width or new_y < 0 or new_y >= @height
        @cursor = [new_x, new_y]
      end

    end

    def draw
      @builder = Builder.new

      @console.position = @x, @y
      @map.area.each_with_index do |row, y|
        string = ''
        row.each_with_index do |cell, x|

          if ([x, y] == @cursor)
            is_cursor = true
          else
            is_cursor = false
          end

          symbol, type, fg, bg = '~', [:std], :white, :dark_blue

          case cell
            when Entity::Map::EMPTY
              symbol = '~'
              fg = :blue
            when Entity::Map::SHIP
              fg = :yellow
              symbol = '='
            when Entity::Map::STRICKEN
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
