# coding: utf-8
module BattleShip::Client::Entity
  class Ship < ::BasicObject

    NORTH = :north
    SOUTH = :south
    WEST = :west
    EAST = :east

    attr_reader :length, :direction, :hit_points, :sections, :blind_spot, :area

    def initialize(length, direction = NORTH)
      @length = length
      @direction = direction
      @sections = [1] * length
      @hit_points = @length

      @blind_spot = []
      @area = []
    end

    def dead_area=(area)
      @blind_spot = area
    end

    def area=(area)
      @area = area
    end

    def to_s
      "<Ship #@sections, direction: #@direction>"
    end

    def attack(section)
      if @sections[section] && !@sections[section].zero?
        @hit_points -= 1
        @sections[section] = 0
        true
      else
        false
      end
    end

    def alive?
      @hit_points.zero? ? false : true
    end

  end
end