# coding: utf-8
module BattleShip::Client::Entity
  class Map

    EMPTY = 0b00
    SHIP = 0b01
    STRICKEN = 0b10
    ILLEGAL = 0b100
    MISS = 0b1000

    attr_reader :ships, :height, :width, :area, :ships_extended

    def initialize(width = 10, height = width)
      @width = width.to_i
      @height = height.to_i
      @area = [[EMPTY] * @width] * @height
      @ships = {}
      @ships_extended = []
    end

    def to_a
      @area
    end

    # @param [BattleShip::Client::Entity::ShipDecorator] ship
    # @param [Array] bow_coordinate
    def add_ship(ship, bow_coordinate)


      check_coordinate bow_coordinate

      aft_coordinate = calc_aft_coordinate(ship, bow_coordinate)

      check_coordinate aft_coordinate

      ship_area, ship_dead_area = ship_to_array(bow_coordinate, aft_coordinate)

      ship_area.each { |coordinate|
        self[coordinate[0], coordinate[1]] = self[coordinate[0], coordinate[1]] | SHIP
      }



      ship_dead_area.each { |coordinate|
        self[coordinate[0], coordinate[1]] = self[coordinate[0], coordinate[1]] | ILLEGAL
      }


      ship.dead_area = ship_dead_area
      ship.area = ship_area
      @ships[bow_coordinate] = ship
    end

    def shot(*target)
      @ships.each_value { |ship|

        ship.area.each_with_index { |coordinate, i|
          if target == coordinate

            if ship.attack(i)
              return ship.alive? ? :hit : :critical
            end

            return :already
          end
        }
      }

      :miss
    end

    private

    def check_coordinate(coordinate)

      raise "wrong coordinate" unless (0..@width).include? coordinate[0]
      raise "wrong coordinate" unless (0..@height).include? coordinate[1]
    end

    def calc_aft_coordinate(ship, bow_coordinate)

      inc = ship.length - 1
      return bow_coordinate.dup if inc.zero?

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

      around_cells = get_around_ship_cells(x, y)

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

        if (bow_coordinate[1] > aft_coordinate[1])
          ship_enum = (aft_coordinate[1]..bow_coordinate[1]).to_a.reverse
        else
          ship_enum = (bow_coordinate[1]..aft_coordinate[1]).to_a
        end

        ship_enum.each { |y|
          dead_zone += get_ship_area(x, y)
          ship << [x, y]
        }

      else
        #is horizontal
        y = bow_coordinate[1]

        if (bow_coordinate[0] > aft_coordinate[0])
          ship_enum = (aft_coordinate[0]..bow_coordinate[0]).to_a.reverse
        else
          ship_enum = (bow_coordinate[0]..aft_coordinate[0]).to_a
        end

        ship_enum.each { |x|
          dead_zone += get_ship_area(x, y)
          ship << [x, y]
        }
      end

      [ship, dead_zone - ship]
    end

    def [](x, y)
      return nil if (x < 0 || y < 0)
      return nil if @area[y].nil?

      @area[y][x]
    end


    def []=(x, y, value)
      new_row = []

      @area[y].each_with_index { |cell, i|
        new_row << ((i==x) ? value : cell)
      }

      @area[y] = new_row
    end

    def get_around_ship_cells(x, y)
      [
          [x + 1, y + 1],
          [x + 1, y],
          [x + 1, y - 1],
          [x,     y - 1],
          [x,     y + 1],
          [x - 1, y + 1],
          [x - 1, y],
          [x - 1, y - 1],
      ].select { |coordinate|
        !self[coordinate[0], coordinate[1]].nil?
      }

    end
  end
end