# coding: utf-8
module BattleShip::Client
  class Output < ::Thread

    include Bash_Visual

    def initialize(input, game_queue, stream = STDOUT)
      @game_tasks = game_queue
      @stream = stream
      @input = input
      @console = Console.new(Font.new, Console::OUTPUT_WITHOUT_BLOCK)

      @thread = super() {

      }

    end


    def ship_disposal(map = map.dup, drawing_map = MapBashVisual.new(map, @console))

      @console.clear

      #
      @console.draw_window(drawing_map, 'Map')
      drawing_map.draw
      #
      #@console.position=[0, 13]
      #@console.write_ln 'Moving: arrows. Build ship: "b". Remove ship: "r". Clear All: "c", Done: "Enter"'
      #@console.position=[0, 14]

      #@input.on_key_press 'b', -> { map.add_ship; map.draw }
      #@input.on_key_press 'r', -> { map.remove_ship; map.draw }
      @input.on_key_press Input::UP, -> { map.move_cursor(0, -1); drawing_map.draw }
      @input.on_key_press Input::DOWN, -> { map.move_cursor(0, 1); drawing_map.draw }
      @input.on_key_press Input::LEFT, -> { map.move_cursor(-1, 0); drawing_map.draw }
      @input.on_key_press Input::RIGHT, -> { map.move_cursor(1, 0); drawing_map.draw }
      @input.on_key_press Input::ENTER, -> { @game_tasks.push(:ship_disposal_end) }
      @input.on_key_press 'q', -> {

        @game_tasks.push(:exit)
      }

    end

  end
end