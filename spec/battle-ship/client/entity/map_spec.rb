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


def good_ships
  cases = []

  ship = Ship.new(2, Ship::SOUTH)
  coordinate = [1, 2]
  map = [[Map::ILLEGAL, Map::ILLEGAL, Map::ILLEGAL],
         [Map::ILLEGAL, Map::SHIP, Map::ILLEGAL],
         [Map::ILLEGAL, Map::SHIP, Map::ILLEGAL]]

  cases << [ship, coordinate, map]

  ship = Ship.new(3, Ship::WEST)
  coordinate = [0, 1]
  map = [[Map::ILLEGAL, Map::ILLEGAL, Map::ILLEGAL],
         [Map::SHIP, Map::SHIP, Map::SHIP],
         [Map::ILLEGAL, Map::ILLEGAL, Map::ILLEGAL]]

  cases << [ship, coordinate, map]

  ship = Ship.new(1, Ship::EAST)
  coordinate = [2, 2]
  map = [[Map::EMPTY, Map::EMPTY, Map::EMPTY],
         [Map::EMPTY, Map::ILLEGAL, Map::ILLEGAL],
         [Map::EMPTY, Map::ILLEGAL, Map::SHIP]]

  cases << [ship, coordinate, map]
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

  it "Check map after simple adding ship" do

    map = Map.new(3)

    ship = Ship.new(2, Ship::NORTH)

    map.add_ship(ship, [0, 0])

    expected_map = [[Map::SHIP, Map::ILLEGAL, Map::EMPTY],
                    [Map::SHIP, Map::ILLEGAL, Map::EMPTY],
                    [Map::ILLEGAL, Map::ILLEGAL, Map::EMPTY]]

    map.to_a.should eq expected_map
  end


  it "Check map after adding ship" do
    good_ships.each { |ship, coordinate, expected_map|
      map = Map.new(3)
      map.add_ship(ship, coordinate)
      map.to_a.should eq expected_map
    }

  end


  it "Check sorting ship's area" do
    map = Map.new(3)
    ship = Ship.new(2, :east)
    map.add_ship(ship, [1, 1])

    ship_area = ship.area
    ship_area.should eq [[1, 1], [0, 1]]

  end

  it "Miss by area" do
    map = Map.new(3)
    result = map.shot(0, 0)
    result.should eq :miss
  end

  it "Hit to ship" do
    map = Map.new(3)
    ship = Ship.new(2)
    map.add_ship(ship, [0, 0])

    result = map.shot(0, 0)
    result.should eq :hit
  end

  it "Critical hit to ship" do
    map = Map.new(3)
    ship = Ship.new(1)
    map.add_ship(ship, [0, 0])
    result = map.shot(0, 0)
    result.should eq :critical

  end

  it "Double miss" do
    map = Map.new(3)
    ship = Ship.new(1)
    map.add_ship(ship, [0, 0])

    result = map.shot(0, 0)
    result = map.shot(0, 0)
    result.should eq :already
  end

  it "Check populate ship's extended data" do
    map = Map.new(2)
    ship = Ship.new(1)
    populated_ship = map.add_ship(ship, [1,1])

    populated_ship.dead_area.sort.should  eq [[0,0], [0,1], [1,0]]
    populated_ship.area.sort.should  eq [[1,1]]

  end

end