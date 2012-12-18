# coding: utf-8
module BattleShip::Client
  class ShipDisposal
    include Bash_Visual

    def self.start
      console = Console.new
      console.clear
      map = Map.new
      map.extend MapBashVisual

      console.draw_window(map, 'Map')
      map.draw
      console.position=[0, 13]
      console.write_ln 'Moving: arrows. Build ship: "b". Remove ship: "r". Clear All: "c", Done: "Enter"'


      kb = KeyMap.new

      kb.bind KeyMap::UP, -> { map.move_cursor(0, -1); map.draw }
      kb.bind KeyMap::DOWN, -> { map.move_cursor(0, 1); map.draw }
      kb.bind KeyMap::LEFT, -> { map.move_cursor(-1, 0); map.draw }
      kb.bind KeyMap::RIGHT, -> { map.move_cursor(1, 0); map.draw }
      kb.bind 'b', -> { map.add_ship; map.draw }
      kb.bind 'r', -> { map.remove_ship; map.draw }
      kb.bind KeyMap::ENTER, -> { KeyMap::STOP }
      kb.start

      console.position=[0, 14]
      map
    end




    def ships_arrangement

    end
  end

end