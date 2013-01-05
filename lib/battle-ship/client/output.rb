# coding: utf-8
module BattleShip::Client
  class Output < ::Thread

    include Bash_Visual
    include Entity

    def initialize(input, game_queue, stream = STDOUT)
      @game_tasks = game_queue
      @stream = stream
      @input = input
      @console = Console.new(Font.new, Console::OUTPUT_WITHOUT_BLOCK)
      @builder = Builder.new
      @thread = super() {

      }

    end


    def ship_disposal(map = map.dup, drawing_map = MapBashVisual.new(map, @console))

      ship = Entity::Ship.new(1, :east)
      map.add_ship(ship, [1, 0])

      ship = Entity::Ship.new(2)
      map.add_ship(ship, [3, 3])

      ship = Entity::Ship.new(4, :west)
      map.add_ship(ship, [1, 8])
      @console.clear

      #
      @console.draw_window(drawing_map, 'Map')
      drawing_map.draw

      #
      @console.position=[0, 14]
      @console.write_ln 'Moving: arrows. Build ship: "b". Remove ship: "r". Clear All: "c", Done: "Enter"'

      @console.position=[15, 1]
      @console.write_ln 'Mov'




      @console.position=[0, 15]
      #@input.on_key_press 'b', -> { map.add_ship; map.draw }
      #@input.on_key_press 'r', -> { map.remove_ship; map.draw }
      @input.on_key_press Input::UP, -> { drawing_map.move_cursor(0, -1); drawing_map.draw }
      @input.on_key_press Input::DOWN, -> { drawing_map.move_cursor(0, 1); drawing_map.draw }
      @input.on_key_press Input::LEFT, -> { drawing_map.move_cursor(-1, 0); drawing_map.draw }
      @input.on_key_press Input::RIGHT, -> { drawing_map.move_cursor(1, 0); drawing_map.draw }
      @input.on_key_press Input::ENTER, -> { @game_tasks.push(:ship_disposal_end) }


    end

    def show_available_ships

      available = {
         1 => 5,
         2 => 4,
         3 => 3,
         4 => 2,
         5 => 1
      }
      start_x = 15
      start_y = 3

      available.each { |size, amount|

      }



      ship = Entity::Ship.new(1, :west)
      ship.area = [[shipe_x, shipe_y]]


      @console.write_to_position(12, 5, '4: ')
      Decorator::Ship.new(ship).draw(@console)
    end

  end
end