# coding: utf-8
module BattleShip::Client
  class Map
    EMPTY = 0
    SHIP = 1
    STRICKEN = 2
    DEAD_ZONE = 10

    attr_reader :map

    def initialize
      @width = 10
      @height = 10
      @x = 0
      @y = 0
      @map = [[EMPTY] * @width] * @height
      @cursor = [0, 0]

    end

    def move_cursor(offset_x, offset_y)
      new_x = @cursor[0] + offset_x
      new_y = @cursor[1] + offset_y

      unless new_x < 0 or new_x >= @width or new_y < 0 or new_y >= @height
        @cursor = [new_x, new_y]
      end

    end

    def add_ship
      tmp = @map[@cursor[1]].dup
      tmp[@cursor[0]] = SHIP
      @map[@cursor[1]] = tmp
    end


    def remove_ship
      tmp = @map[@cursor[1]].dup
      tmp[@cursor[0]] = EMPTY
      @map[@cursor[1]] = tmp
    end
  end
end