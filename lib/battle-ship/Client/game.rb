# coding: utf-8
module BattleShip::Client
  class Game
    def start
      raise 'Fail auth!' unless auth()

      game = game_join()

      map = ship_disposal()

      send_map(map);

      while game.run?

        if game.current_gamer?
          get_command()
          send_command
        end
        draw_map
        waiting()
        draw_map
      end

      if game.win?
        puts 'You win!'
      else
        puts 'You looser!'
      end

      show_all_ships()



      #msg = Protocol::send_map(map)

    end
  end
end