# coding: utf-8
module BattleShip::Client::Decorator
  class Map

    include BattleShip::Client::Entity

    require "bash-visual"

    include ::Bash_Visual
    include FixedObject

    attr_reader :map

    # @param [BattleShip::Client::Entity::Map] map
    # @param [Console] console
    def initialize(map, console = Console.new)
      @x = 0
      @y = 0

      @left_offset = 2
      @top_offset = 1
      @width = map.width + @left_offset
      @height = map.height + 1
      @map = map
      @console = console

      @builder = Builder.new
      @cursor = [0, 0]
    end

    def move_cursor(offset_x, offset_y)
      new_x = @cursor[0] + offset_x
      new_y = @cursor[1] + offset_y

      unless new_x < 0 or new_x >= @width or new_y < 0 or new_y >= @height
        @cursor = [new_x, new_y]
      end

    end


    def draw

      @console.position = @x, @y

      screen = Screen.new(10)
      make_background(screen)
      make_ships(screen)
      make_cursor(screen)

      title_cols = ' ' * @left_offset
      (1...@width-1).each { |i|
        title_cols << (64+i).chr
      }

      string = @builder.write(title_cols, Font.new([:std], :green))
      @console.write_to_position(1, 1, string)

      map.height.times { |y|

        string = (y+1).to_s.rjust(@left_offset)
        string = @builder.write(string, Font.new([:std], :green))
          screen.get_row(y).each { |symbol, font|
            string << @builder.write(symbol, font)
          }

          pos =  y  + 1 + @top_offset
          @console.write_to_position(1, pos, string)

      }
    end


    private

    def make_background(screen)
      @map.area.each_with_index do |row, y|

        row.each_with_index do |cell, x|
          symbol, type, fg, bg = '~', [:std], :white, :dark_blue

          case cell
            when BattleShip::Client::Entity::Map::EMPTY
              symbol = '~'
              fg = :blue
            when BattleShip::Client::Entity::Map::STRICKEN
              fg = :red
              symbol = '@'
          end

          screen[x, y] = [symbol, Font.new(type, fg, bg)]
        end
      end
    end

    def make_ships(screen)
      @map.ships.each_value { |ship|
        Ship.new(ship).draw(screen)
      }

    end

    def make_cursor(screen)
      symbol, font = screen[*@cursor]
      new_font = Font.new(font.types << :blink, font.foreground, :red)

      screen[*@cursor] = [symbol, new_font]
    end

  end
end
