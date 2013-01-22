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

      @available_ships = {
          1 => 5,
          2 => 4,
          3 => 3,
          4 => 2,
          5 => 1
      }

    end


    def ship_disposal(map = map.dup, drawing_map = Decorator::Map.new(map, @console))

      @console.clear

      #
      @console.draw_window(drawing_map, 'Map')
      drawing_map.draw

      #
      @console.position=[0, 14]
      @console.write_ln 'Moving: arrows. Build ship: "b". Rotate: "r". Clear All: "c", Done: "Enter"'

      show_available_ships

      @console.position=[0, 15]

      @input.on_key_press '1', -> {
        drawing_map.current_ship= Entity::Ship.new(1, :west); drawing_map.draw
        show_available_ships 1
      }

      @input.on_key_press '2', -> {
        drawing_map.current_ship= Entity::Ship.new(2, :west); drawing_map.draw
        show_available_ships 2
      }

      @input.on_key_press '3', -> {
        drawing_map.current_ship= Entity::Ship.new(3, :west); drawing_map.draw
        show_available_ships 3
      }

      @input.on_key_press '4', -> {
        drawing_map.current_ship= Entity::Ship.new(4, :west); drawing_map.draw
        show_available_ships 4
      }

      @input.on_key_press '5', -> {
        drawing_map.current_ship= Entity::Ship.new(5, :west); drawing_map.draw
        show_available_ships 5
      }

      @input.on_key_press 'r', -> {

        if (drawing_map.current_ship.vertical?)
          ship = Entity::Ship.new(drawing_map.current_ship.length, :west)
        else
          ship = Entity::Ship.new(drawing_map.current_ship.length, :north)
        end
        drawing_map.current_ship= ship
        drawing_map.draw
      }

      @input.on_key_press 'b', -> {



        ship = drawing_map.current_ship

        if @available_ships[ship.length].zero?
          break
        end

        begin
          map.add_ship(ship, drawing_map.cursor)

          @available_ships[3] = @available_ships[ship.length] - 1
        rescue

        end


        drawing_map.draw
      }


      @input.on_key_press Input::UP, -> { drawing_map.move_cursor(0, -1); drawing_map.draw }
      @input.on_key_press Input::DOWN, -> {

        drawing_map.move_cursor(0, 1); drawing_map.draw }
      @input.on_key_press Input::LEFT, -> { drawing_map.move_cursor(-1, 0); drawing_map.draw }
      @input.on_key_press Input::RIGHT, -> { drawing_map.move_cursor(1, 0); drawing_map.draw }
      @input.on_key_press Input::ENTER, -> { @game_tasks.push(:ship_disposal_end) }


    end

    def show_available_ships(current = 1)

      @console.position=[15, 1]
      @console.write_to_position(2, 0, 'Available ships:')

      y = 1
      @available_ships.each { |ship_size, available|
        if (current == ship_size)
          font = Font.new(:blink)
        else
          font = Font.new
        end

        if available.zero?
          font = Font.new(font.types, :dark_grey)
        end

        @console.write_to_position(2, y, available.to_s + ': ' + 'o' * ship_size, font)
        y += 1
      }
    end

  end
end