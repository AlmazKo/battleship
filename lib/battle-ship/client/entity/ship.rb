# coding: utf-8
module BattleShip::Client::Entity
  class Ship < ::BasicObject

    NORTH = :north
    SOUTH = :south
    WEST = :west
    EAST = :east

    attr_reader :length, :direction

    def initialize(length, direction = NORTH)
      @length = length
      @direction = direction
    end
  end
end