require "rspec"

require "battle-ship/client/entity"
require "battle-ship/client/entity/ship"

include BattleShip::Client::Entity
describe BattleShip::Client::Entity::Ship do

  it "Ship should have length & direction & sections & hit points" do
      ship = Ship.new(2, :north)
      ship.length.should eq 2
      ship.direction.should eq :north
      ship.sections.should eq [1,1]
      ship.hit_points.should eq 2
  end


  it "Ship must not alive after critical hit" do
    ship = Ship.new(2)

    ship.attack(0)
    ship.alive?.should be_true
    ship.sections.should eq [0,1]

    ship.attack(1)
    ship.alive?.should be_false
    ship.sections.should eq [0,0]
  end

  it "Result double attack ships" do
    ship = Ship.new(2)
    result = ship.attack(0)
    result.should be_true

    result = ship.attack(0)
    result.should be_false
  end


end