require "rspec"

require "battle-ship/client/entity"
require "battle-ship/client/entity/ship"

include BattleShip::Client::Entity
describe BattleShip::Client::Entity::Ship do

  it "Ship should have length & direction" do
      ship = Ship.new(2, :north)
      ship.length.should eq 2
      ship.direction.should eq :north
  end
end