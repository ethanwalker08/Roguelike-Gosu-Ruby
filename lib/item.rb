class Item < GameObject
	def initialize(window, x, y, object_name, blocks=false)
		super
		if name == 'healing potion'
			@healing_amount = 4
			@image = $image_tiles[40]
		
		elsif name == 'Sword of finality'
		 	@image = $image_tiles[62]
		end
		@visible = false
	end

	def pick_up
		if $bag.length >= 5
			Messager.message("Inventory is full!")
		elsif name == 'Sword of finality'
			self.end_game
		else
			$bag << self
			$items.delete(self)
			Messager.message("You picked up a " + self.name)
		end

		$monsters.each do |monster|
			monster.take_turn
		end
	end

	def use
		if name == 'healing potion'
			if $player.hp == $player.max_hp
				Messager.message("Already at full health!")
			elsif $player.hp + @healing_amount < $player.max_hp
				$player.hp += @healing_amount
				$bag.delete(self)
				Messager.message("Used a " + name)
			else
				$player.hp = $player.max_hp
				$bag.delete(self)
				Messager.message("Used a " + name)
			end
		end
	end

	def draw
		if visible == true
			@image.draw(@x * 31 - 5, @y * 31 - 5, 1, 1, 1)
		end
	end
	def end_game
		window.close
		puts ''
		puts''
		puts 'YOU HAVE WON THE GAME! Congratulations... NERD'
	end
end

class Scroll < Item
	def initialize(window, x, y, object_name, blocks=false)
		super
		if name == 'lightning scroll'
			@image = $image_tiles[49]
			@l_range = 5
			@l_damage = 30
		end
		if name == 'confuse scroll'
			@image = $image_tiles[49]
			@c_range = 5
		end
	end

		def use
			if name == 'lightning scroll'
				monster = $player.closest_monster(@l_range)
				if monster == nil
					Messager.message("No enemy close enough to target!")
				else
					Messager.message("A lightning bolt strikes the " + monster.name)
					monster.take_damage(@l_damage)
					$bag.delete(self)
				end
			elsif name == 'confuse scroll'
				monster = $player.closest_monster(@c_range)
				r_num = rand(100)
				if monster == nil
					Messager.message("No enemy close enough to target!")
				else
					if r_num < 75
						Messager.message(monster.name + " is confused!")
						monster.ai = 'confused'
					else
						Messager.message(monster.name + " resists!")
					end
					$bag.delete(self)
				end
			end
		end
end