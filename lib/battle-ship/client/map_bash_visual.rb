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

      @left_padding = 2
      @top_padding = 1
      @width = map.width + @left_padding
      @height = map.height + 1
      @map = map
      @console = console


      @cursor = [0,0]
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


      title_cols = ' ' * @left_padding
      (1...@width-1).each { |i|
        title_cols << (64+i).chr
      }
      string = @builder.write(title_cols, Font.new([:std], :green))
      @console.write_to_position(1, 1, string)

      @map.area.each_with_index do |row, y|

        string = (y+1).to_s.rjust(@left_padding)
        string = @builder.write(string, Font.new([:std], :green))
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
            when Entity::Map::ILLEGAL
              symbol = '~'
              fg = :white
            when Entity::Map::STRICKEN
              fg = :red
              symbol = '◎'
          end

          if is_cursor
            type << :blink
            bg = :red
          end

          string << @builder.write(symbol, Font.new(type, fg, bg))

        end
        @console.write_to_position(1, y+2, string)
      end

      draw_ships

    end

   private

    def draw_ships

       @map.ships.each_value { |ship|
          Decorator::Ship.new(ship).draw(@console)
       }
    end

  end
end
