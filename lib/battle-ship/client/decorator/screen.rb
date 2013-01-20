# coding: utf-8
module BattleShip::Client::Decorator
  class Screen


    attr_reader :height, :width, :area

    def initialize(width = 10, height = width)
      @width = width.to_i
      @height = height.to_i
      @area = [[' '] * @width] * @height
    end



    #def sum(screen, offset = [0,0])
    #  new_row = []
    #
    #  screen.each { |y|
    #    row.each_with_index { |cell, x|
    #       if (self[x + offset[0], y + offset])
    #
    #      new_row << ((i==x) ? value : cell)
    #    }
    #  }
    #
    #  @area[y].each_with_index { |cell, i|
    #    new_row << ((i==x) ? value : cell)
    #  }
    #
    #  @area[y] = new_row
    #end

    def [](x, y)
      return nil if (x < 0 || y < 0)
      return nil if @area[y].nil?

      @area[y][x]
    end


    def get_row(y)
      @area[y]
    end

    def []=(x, y, value)
      new_row = []

      @area[y].each_with_index { |cell, i|
        new_row << ((i==x) ? value : cell)
      }

      @area[y] = new_row
    end


    def to_a
      area
    end
  end
end