class ButtonHandler

  def self.button_down(id, window)
    if $game_state == 'playing'
      case id
        when id = Gosu::Button::KbEscape
          window.close
        when id = Gosu::Button::KbJ
          $player.move_or_attack(-1,0)
          $map_obj.do_fov($player_x, $player_y, 5)
        when id = Gosu::Button::KbK
          $player.move_or_attack(1, 0)
          $map_obj.do_fov($player_x, $player_y, 5)
        when id = Gosu::Button::KbH
          $player.move_or_attack(0, -1)
          $map_obj.do_fov($player_x, $player_y, 5)
        when id = Gosu::Button::KbL
          $player.move_or_attack(0, 1)
          $map_obj.do_fov($player_x, $player_y, 5)
        when id = Gosu::Button::KbLeft
          $player.move_or_attack(-1,0)
          $map_obj.do_fov($player_x, $player_y, 5)
        when id = Gosu::Button::KbRight
          $player.move_or_attack(1, 0)
          $map_obj.do_fov($player_x, $player_y, 5)
        when id = Gosu::Button::KbUp
          $player.move_or_attack(0, -1)
          $map_obj.do_fov($player_x, $player_y, 5)
        when id = Gosu::Button::KbDown
          $player.move_or_attack(0, 1)
          $map_obj.do_fov($player_x, $player_y, 5)
        when Gosu::Button::KbR
          $player.rest
        when Gosu::Button::KbS
          $game_state = ButtonHandler.toggle
        when Gosu::Button::KbF
          $items.each do |i|
            if i.x == $player.x && i.y == $player.y
              i.pick_up
            end
          end
      end
    elsif $game_state == 'dead'
      if id == Gosu::Button::KbSpace
        reset_game
      elsif id == Gosu::Button::KbEscape
        self.close
      end
    elsif $game_state == 'inventory'
      ButtonHandler.button_handle(id)
    end
  end

  def self.toggle
    if $game_state == 'inventory'
      $game_state = 'playing'
    elsif $game_state == 'playing'
      $game_state = 'inventory'
    end
  end

  def self.move(direction)
    case direction
      when direction = :up
      when direction = :down
      when direction = :left
      when direction = :right
    end
  end

  def self.button_handle(id)
    if id == Gosu::Button::KbEscape
      toggle
    elsif id == Gosu::Button::KbA
      index = 0
      $bag[index].use
    elsif id == Gosu::Button::KbB
      index = 1
      $bag[index].use
    elsif id == Gosu::Button::KbC
      index = 2
      $bag[index].use
    elsif id == Gosu::Button::KbD
      index = 3
      $bag[index].use
    elsif id == Gosu::Button::KbF
      index = 4
      $bag[index].use
    end
  end

  def self.convert_button(id)
    case id
      when 0
        97
      when 11
        98
      when 8
        99
      when 2
        100
      when 14
        101
      when 3
        102
      when 5
        103
      when 4
        104
      when 34
        105
      when 38
        106
      when 40
        107
      when 37
        108
      when 46
        109
      when 45
        110
      when 31
        111
      when 35
        112
      when 12
        113
      when 15
        114
      when 1
        115
      when 17
        116
      when 32
        117
      when 9
        118
      when 13
        119
      when 7
        120
      when 16
        121
      when 6
        122
      else
        0
    end
  end
end