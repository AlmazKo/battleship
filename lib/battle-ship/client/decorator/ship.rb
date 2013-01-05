# coding: utf-8
module BattleShip::Client::Decorator
  class Ship

    include ::Bash_Visual

    attr_reader :ship

    def initialize(ship)
      @ship = ship
      @builder = Builder.new
    end


    def rotate(angle=90)

    end


    def draw(console)
      if @ship.length == 1
        symbol = get_symbol_small_ship ship
      else
        symbol = get_body_symbol_ship ship
      end

      @ship.area.each {|x,y|

        string = @builder.write(symbol, Font.new(:bold, :yellow))
        console.write_to_position(x+3, y+2, string)
      }
    end

    private

    def get_symbol_small_ship ship
      case ship.direction
        when :north
          '△'
        when :south
          '▽'
        when :west
          '◁'
        when :east
          '▷'
        else
          '△'
      end
    end

    def get_body_symbol_ship ship
      if ship.direction == :north || ship.direction == :south
        '║'
      else
        '═'
      end
    end

  end
end