# coding: utf-8
module BattleShip::Client::Entity
  class Map

    EMPTY = 0b00
    SHIP = 0b01
    STRICKEN = 0b10
    ILLEGAL = 0b100
    MISS = 0b1000

    attr_reader :ships, :height, :width, :area

    def initialize(width = 10, height = width)
      @width = width.to_i
      @height = height.to_i
      @area = [[EMPTY] * @width] * @height
      @ships = {}
    end

    def to_a
      @area
    end

    # @param [BattleShip::Client::Entity::Ship] ship
    # @param [Array] bow_coordinate
    def add_ship(ship, bow_coordinate)

      check_coordinate bow_coordinate

      aft_coordinate = calc_aft_coordinate(ship, bow_coordinate)

      #puts aft_coordinate.inspect
      check_coordinate aft_coordinate

      ship_area, ship_dead_area = ship_to_array(bow_coordinate, aft_coordinate)



      ship_area.each { |coordinate|


        self[coordinate[0], coordinate[1]] = self[coordinate[0], coordinate[1]] | SHIP
      }


      ship_dead_area.each { |coordinate|
        self[coordinate[0], coordinate[1]] = self[coordinate[0], coordinate[1]] | ILLEGAL
      }


      @ships[bow_coordinate] = ship
    end

    private

    def check_coordinate(coordinate)

      raise "wrong coordinate" unless (0..@width).include? coordinate[0]
      raise "wrong coordinate" unless (0..@height).include? coordinate[1]
    end

    def calc_aft_coordinate(ship, bow_coordinate)
      inc = ship.length - 1

      bow_coordinate.dup if inc.zero?

      case ship.direction
        when Ship::NORTH
          [bow_coordinate[0], bow_coordinate[1] + inc]
        when Ship::SOUTH
          [bow_coordinate[0], bow_coordinate[1] - inc]
        when Ship::WEST
          [bow_coordinate[0] + inc, bow_coordinate[1]]
        when Ship::EAST
          [bow_coordinate[0] - inc, bow_coordinate[1]]

      end
    end


    def get_ship_area(x, y)
      raise "illegal locate of ship (chip sets) " unless self[x, y] == EMPTY

      around_cells = get_around_cells(x, y)


      around_cells.each { |coordinate|
        raise "illegal locate of ship (dead zone)" unless (self[coordinate[0], coordinate[1]] & SHIP).zero?
      }
      around_cells
    end

    def ship_to_array(bow_coordinate, aft_coordinate)

      ship = []
      dead_zone = []

      if bow_coordinate[0] == aft_coordinate[0]
        #is vertical
        x = bow_coordinate[0]

        (bow_coordinate[1]..aft_coordinate[1]).each { |y|


          dead_zone += get_ship_area(x, y)
          ship << [x, y]
        }

      else
        #is horizontal
        y = bow_coordinate[1]
        (bow_coordinate[0]..aft_coordinate[0]).each { |x|
          dead_zone += get_ship_area(y, x)
          ship << [x, y]
        }
      end

      [ship, dead_zone - ship]

      #
      #ship = []
      #dead_zone = []
      #if bow_coordinate[1] == aft_coordinate[1]
      #  column = bow_coordinate[0]
      #
      #  (bow_coordinate[1]..aft_coordinate[1]).each { |row|
      #
      #
      #    raise "illegal locate of ship (chip sets) " unless @matrix[row][column] == EMPTY
      #
      #    around_cells = get_around_cells(row, column)
      #
      #    around_cells.each { |coordinate|
      #      raise "illegal locate of ship (dead zone)" unless (@matrix[coordinate[0]][coordinate[1]] & SHIP).zero?
      #      dead_zone << coordinate
      #    }
      #
      #
      #    ship << [row, column]
      #  }
      #else
      #  row = bow_coordinate[1]
      #
      #  (bow_coordinate[1]..aft_coordinate[1]).each { |column|
      #
      #
      #    raise "illegal locate of ship (chip sets) " unless @matrix[row][column] == EMPTY
      #
      #    around_cells = get_around_cells(row, column)
      #
      #    around_cells.each { |coordinate|
      #      raise "illegal locate of ship (dead zone)" unless (@matrix[coordinate[0]][coordinate[1]] & SHIP).zero?
      #      dead_zone << coordinate
      #    }
      #
      #
      #    ship << [row, column]
      #  }
      #end
      #



    end

    #def locate_ship(ship)
    #
    #end

    def cell_ship?(x, y)

      !(@area[x + 1, y] & SHIP).zero?
    end

    def [](x, y)
      return nil if (x < 0 || y < 0)
      @area[y][x]
    end


    def []=(x, y, value)
      new_row = []

      @area[y].each_with_index { |cell, i|
        new_row << ((i==x) ? value : cell)
      }

      @area[y] = new_row
    end

    def get_around_cells(row, column)
      [
          [row + 1, column + 1],
          [row + 1, column],
          [row + 1, column - 1],
          [row, column - 1],
          [row, column + 1],
          [row - 1, column + 1],
          [row - 1, column],
          [row - 1, column - 1],
      ].select { |coordinate|
        !self[coordinate[0], coordinate[1]].nil?
      }

    end
    #def add_ship
    #  tmp = @map[@cursor[1]].dup
    #  tmp[@cursor[0]] = SHIP
    #  @map[@cursor[1]] = tmp
    #end
    #
    #
    #def remove_ship
    #  tmp = @map[@cursor[1]].dup
    #  tmp[@cursor[0]] = EMPTY
    #  @map[@cursor[1]] = tmp
    #end
  end
end