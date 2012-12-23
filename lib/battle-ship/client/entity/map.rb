# coding: utf-8
module BattleShip::Client::Entity
  class Map

    EMPTY    = 0b00
    SHIP     = 0b01
    STRICKEN = 0b10
    ILLEGAL  = 0b100

    attr_reader :ships, :height, :width

    def initialize(width, height)
      @width = width.to_i
      @height = height.to_i
      @matrix = [[EMPTY] * @width] * @height
      @ships = {}
    end

    def to_a
      @matrix
    end

    # @param [BattleShip::Client::Entity::Ship] ship
    # @param [Array] bow_coordinate
    def add_ship(ship, bow_coordinate)

      check_coordinate bow_coordinate

      aft_coordinate = calc_aft_coordinate(ship, bow_coordinate)
      check_coordinate aft_coordinate



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
          [bow_coordinate[0] + inc, bow_coordinate[1] ]
        when Ship::EAST
          [bow_coordinate[0] - inc, bow_coordinate[1] ]

      end
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