require "rspec"

require "battle-ship/client/entity"
require "battle-ship/client/entity/map"
require "battle-ship/client/entity/ship"

include BattleShip::Client::Entity

def wrong_coordinates_ships
  [
      [Ship.new(1, Ship::NORTH), [-1, 0]],
      [Ship.new(4, Ship::NORTH), [9, 9]],
      [Ship.new(4, Ship::EAST), [0, 0]],
      [Ship.new(14, Ship::SOUTH), [9, 9]],
  ]

end

describe BattleShip::Client::Entity::Map do

  it "Map should haven't ships at the beginning" do
    map = Map.new(10, 10)
    map.ships.should have(0).ships
  end

  it "Map should be able convert to array" do
    map = Map.new(10, 10)
    map.to_a.should eq [[Map::EMPTY] * 10] * 10
  end

  it "Map should be able adds ships" do
    map = Map.new(10, 10)
    ship = Ship.new(1, Ship::NORTH)
    map.add_ship(ship, [0, 0])

    map.ships.should have(1).ships
    map.ships.key?([0, 0]).should be_true
    map.ships.value?(ship).should be_true
  end

  it "Can't add ships out the map" do
    map = Map.new(10, 10)

    wrong_coordinates_ships().each { |ship, coordinate|
      expect { map.add_ship(ship, coordinate) }.to raise_error
    }
  end

  it "Adding ships shouldn't not intersect" do

    map = Map.new(10, 10)

    first_ship = Ship.new(1)
    second_ship = Ship.new(3)

    map.add_ship(first_ship, [0, 0])

    expect { map.add_ship(second_ship, [0, 0]) }.to raise_error
  end

  it "Check map after adding ship" do

    map = Map.new(3)

    ship = Ship.new(2, Ship::NORTH)

    map.add_ship(ship, [0, 0])

    expected_map = [[5,    Map::ILLEGAL, Map::EMPTY],
                    [5,    Map::ILLEGAL, Map::EMPTY],
                    [Map::ILLEGAL, Map::ILLEGAL, Map::EMPTY]]

    puts expected_map.inspect.gsub('],', "],\n")
    puts map.to_a.inspect.gsub('],', "],\n")

    map.to_a.should eq expected_map
  end


end