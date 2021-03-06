class GameWindow < Gosu::Window
	def initialize
		$window_width = 1440
		$window_height = 1080
		super($window_width, $window_height, true)

		self.caption = "Roguelike"

		$map_width = 100
		$map_height = 100

		@room_max_size = 10
		@room_min_size = 6
		@max_rooms = 10

		$first_room = true
		$player_x = $player_y = 0

		$msg_black = Gosu::Color.new(100, 0, 0, 0)
		$msg_white = Gosu::Color.new(100, 255, 255, 255)
		$white = Gosu::Color.new(255, 255, 255, 255)
		$black = Gosu::Color.new(255, 0, 0, 0)
		$red = Gosu::Color.new(255, 160, 0, 0)

		$image_tiles = Gosu::Image.load_tiles(self, './graphics/fantasy-tileset.png', 32, 32, false)
		$monsters = []
		$items = []
		$bag = []
		$leafs = []
		$game_msgs = []

		@inventory = Inventory.new(self)

		reset_game

		$font = Gosu::Font.new(self, Gosu::default_font_name, 20)
	end

	def update
		
	end

	def draw_hp_bar(x, y, w, h, color1, color2, z=2, object)
		self.draw_quad(x, y, $white, x + w, y, $white, x, y + h, $white, x + w, y + h, $white, z)
		self.draw_quad(x + 1, y + 1, $black, x + w - 1, y + 1, $black, x + 1, y + h - 1, $black, x + w - 1, y + h - 1, $black, z)

		hp = object.hp
		max_hp = object.max_hp

		length = (((hp*w)/100) * 100) / max_hp

		self.draw_quad(x + 1, y + 1, color2, x + length - 1, y + 1, color2, x + 1, y + h - 1, color2, x + length - 1, y + h - 1, color2, z)
	end

	def reset_game
		$monsters.reject! {|monster| true }
		$items.reject! {|item| true}

		$game_state = 'playing'

		$map_obj = Map.new($map_width, $map_height, self)
		$map = $map_obj.init_map
		leaf = Leaf.new(0,0, $map_width, $map_height)

		leaf.create_leafs
		$map_obj.set_tile($player_x, $player_y, 'player')
		$map_obj.do_fov($player_x, $player_y, 5)

		$player = Player.new(self, $player_x, $player_y, 'player', 20, 5, 3)

		$camera_x = [[($player.x * 31 - 5) - $window_width/2, 0].max, $window_width * 31 - 5].min
		$camera_y = [[($player.y * 31 - 5) - $window_height/2, 0].max, $window_height * 31 - 5].min
	end

	def draw
		if $game_state == 'playing'
			translate(-$camera_x, -$camera_y) do
				$map_obj.draw
				$monsters.each do |i|
					i.draw
				end
				$items.each do |i|
					i.draw
				end
			end
			draw_hp_bar($window_width/2 - 50, $window_height - 20, 200, 20, $white, $red, 2, $player)
			$font.draw("HP: ", $window_width/2 - 100, $window_height - 25, 2, 1.25, 1.25, $red)
			Messager.draw_messages(self)
		elsif $game_state == 'inventory'
			@inventory.draw
		elsif $game_state == 'dead'
			$font.draw("GAME OVER", $window_width/2 - 150, $window_height/2, 1, 2.0, 2.0, 0xffffff00)
			$font.draw("Press 'space' to continue", $window_width/2 - 150, $window_height/2 + 30, 1, 2.0, 2.0, 0xffffff00)
		end
	end

	def button_down(id)
        ButtonHandler.button_down(id, self)
	end
end