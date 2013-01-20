# coding: utf-8
module BattleShip::Client::Decorator
  class Ship

    include ::Bash_Visual

    attr_reader :ship

    def initialize(ship)
      @ship = ship
      @builder = Builder.new
    end

    def draw(screen)



      @ship.blind_spot.each { |x,y|
        symbol, font = screen[x, y]
        screen[x,y] = [symbol, Font.new(font.types, :white, font.background)]
      }

      if @ship.length == 1
        symbol = get_symbol_small_ship ship
      else
        symbol = get_body_symbol_ship ship
      end

      @ship.area.each {|x,y|
        _, font = screen[x, y]
        font = Font.new(:bold, :yellow, font.background)
        screen[x,y] = [symbol, font]
      }
    end

    private

    def get_symbol_small_ship ship
      case ship.direction
        when :north
          '^'
        when :south
          'v'
        when :west
          '<'
        when :east
          '>'
        else
          '^'
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