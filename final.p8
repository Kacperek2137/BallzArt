pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init()
	--debug
	collision = false
	debugnum = 10
	game_scene_freeze = false

	-- logo
	logo_angle = 0
	logo_y = 20
	logo_tic = 0

	top_type = flr(rnd(5) + 1)
	bottom_type = flr(rnd(5) + 1)

	--debug outline
	outline_col = 0
	-- animation sprite number
	s = 17
	-- animation delay
	d = 30
	-- background setup
	line_col = 7
	-- pad setup
	pad_x = 55
	pad_y = 63
	--pad speed
	pad_dx = 0
	pad_dy = 0
	pad_position = "horizontal"
	pad_width = 30
	pad_height = 3
	pad_color = 2

	pad_hitbox_x = 0
	pad_hitbox_y = 0
	pad_hitbox_width = 0
	pad_hitbox_height= 0
	pad_speed = 5


	-- bouncebox left setup
	--pad_bouncebox_left_x = 0
	--pad_bouncebox_left_y = 0


	-- ball setup
	ball_radius = 3
	ball_x = 30
	ball_y = 20
	-- max speed
	ball_dm = 0.5
	ball_dx = ball_dm
	ball_dy = ball_dm

	ball_ang = 0

	ball_col = 9



	-- freeze
	freezetimer = 0
	ball_frosted = false
	frosted_timer = 0
	-- target setup
	target_x = rnd(100)
	target_y = 6
	target_radius = 5
	-- max speed
	target_dm = 0.25
	-- initial setup for top left of the screen
	target_dx = target_dm
	target_dy = 0


	-- sec target setup

	sectarget_x = 6
	sectarget_y = rnd(100)
	sectarget_radius = 5
	-- max speed
	sectarget_dm = 0.25
	-- initial setup for top left of the screen
	sectarget_dx = 0
	sectarget_dy = -target_dm
	-- max speed


	-- bad target setup
	badtarget_sprite = 1
	badtarget_x = rnd(100)
	badtarget_y = 122
	badtarget_radius = 5
	-- max speed
	badtarget_dm = 0.3
	-- initial setup for bottom right corner
	badtarget_dx = - badtarget_dm
	badtarget_dy = 0

	--score setup
	score = 0



	-- particles setup
	part = {}


	-- order system variables

	order_time = 0

	ingr_total_number = 5
	total_orders = 0

	-- number of n per ingredient
	ing_1 = 0
	ing_2 = 0 
	ing_3 = 0
	ing_4 = 0 
	ing_5 = 0

	-- starting ing_types array
	ing_types_start = {ing_1,ing_2,ing_3,ing_4,ing_5}

	-- how many ing types will be in play in this round
	ing_ammount = 0

	-- how many ings in this order are left to be disposed between ing types
	ing_to_dispose = 0

	-- how many total ings are on the start
	start_ing_to_dispose = 0

	-- ing speed
	ing_speed = 0.5


	-- order system update
	frame = 0
	sec = 0
	order_time_procentage = 0
	bar_col = 7
	bar_x = 0

	-- ingredient control setup
	ing_list = {}

	-- order new ing adding
	tic = 0
	ings_avaible = {}

	-- game over screen effect
	ing_matrix_tic = 0

	-- player score var
	player_score = 0


	--screen shake vars
	shake = 0

	-- order is starting now debug
	new_order()


	-- white frame 
	whiteframe = 0

	frosted_cooldown = 0


	-- camera moving
	camerax = 0
	camera_direction = 0 
	cameratimer = 0
	cameramoving = false


	-- in which room are we now? 
	-- -1 credits
	-- 0 splash
	-- 1 highscore
	camera_active_room = 0

	-- if true the bombs can go off
	-- fixes the double bomb row
	safebomb = false

	-- high score
	cartdata("lkg_picomaki")

	hs = {}
	loadhs()
	sort_high_score()

	-- order showing part
	rows_table = {}
	rows_number = 0

	scene = "menu"
	-- game scenes:
	-- menu
	-- tutorial
	-- game
	-- gameover
	--

	coin = 0

	-- advance and skiping of tutorial
	tutorial_part = 0

	music(1)

	--reseths()

end

function _update60()

	if scene == "menu" then
		-- x to start the game
		if btnp(5) then
			scene = "tutorial"
		end

		-- moving between rooms in the menu scene
		-- we start in the room 0
		
		-- right
		if btn(1) then
			if cameramoving == false and (camera_active_room == 0 or camera_active_room == -1) then
				cameramoving = true
				camera_direction = 1
				sfx(34)
			end
		end

		-- left
		if btn(0) then
			if cameramoving == false and (camera_active_room == 0 or camera_active_room == 1) then
				cameramoving = true
				camera_direction = -1
				sfx(34)
			end
		end

		update_camera()


		--logo smooth movement
		logo_tic += 1
		if logo_tic >= 1 then
			logo_angle += 0.03 / 0.02
			--logo_y += sin(logo_angle / 200) 
			logo_tic = 0
		end

			
	end


	if scene == "gameover" then
		whiteframe = 10
		if btn(5) then
			game_vars_fresh_start()
			scene = "game"
			music(4,5000)
		end

		if btn(4) then
			game_vars_fresh_start()
			scene = "menu"
		end

	end

	if scene == "tutorial" then
			if btnp(5) then
				tutorial_part += 1
				sfx(34)
			end

			if btnp(4) then
				tutorial_part -= 1
				sfx(34)
			end

			if tutorial_part == 0 then
				scene = "menu"
				tutorial_part = 0
				sfx(34)

			end

			if tutorial_part == 5 then
				tutorial_part = 0
				scene = "game"
				sfx(34)
				music(4,5000)

			end

			

	end

	if scene == "game" then

		-- game start sfx
		--sfx(26)


		--debug
		debug = ''


		-- ball collision against the serve boxes
		if ball_box(0,0,16,16) then
			-- bottom wall 
			if ball_x < 16 then
				ball_dy = - ball_dy
			else
				ball_dx = - ball_dx
			end

		end

		-- bottom serve box
		if ball_box(111,96,16,16) then
			-- top
			if ball_x >= 111 then
				ball_dy = - ball_dy
			else
				ball_dx = - ball_dx
			end

		end

		frosted_cooldown -= 1


		--display that you can frost
		if frosted_cooldown <= 0 then
			outline_col = 7
			-- TODO sfx loaded

		end
		-- if x is pressed
		if btnp(5) then

			-- player can frost every 3 seconds
			if frosted_cooldown <= 0 then

				ball_frosted = true
				frosted_timer = 100
				-- frost SFX
				sfx(27)
				frosted_cooldown = 180
			end
		end

		if ball_frosted == true then
			frosted_timer -= 1
			--ball_col = 12
			--outline_col = 12
			ball_col = 12
			outline_col = 12
			
			if frosted_timer < 0 then
				ball_frosted = false
				ball_col = 8
				outline_col = 2
				-- unfrost sfx
				sfx(28)
			end
		end



		-- debug
		if btnp(4) then

			--player_score += 8001
			--
			--outline_col += 1
			
			-- debug
			--if outline_col > 15 then
				--outline_col = 0
			--end
		end


		collision = false

		-- debug animation
		tomatoblink()


		update_order()


		-- local var if any button pressed
		local butpress = false

		-- trail particle
		spawntrail(ball_x, ball_y)

		-- updating the particles
		updateparts()


		-- ball movement

		-- ball frosting 
		if ball_frosted == false then
			ball_x += ball_dx
			ball_y += ball_dy

			
			-- bug fix ball going out of border
		else

			ball_x += 0
			ball_y += 0
		end
		-- ball wall bouncing
		-- radius is added or removed for better collision detection
		if ball_x > 127 - ball_radius then
			ball_dx = -ball_dm
			ball_dy = 1 * sign(ball_dy)
			-- wall collision sfx
			sfx(1)

			-- ball out of space bug fix
			ball_x = mid(0,ball_x,127)
		

		end

		if ball_x < 0 + ball_radius then
			ball_dx = ball_dm
			ball_dy = 1 * sign(ball_dy)
			-- wall collision sfx
			sfx(1)

			ball_x = mid(0,ball_x,127)
		end

		if ball_y > 111 - ball_radius then
			ball_dy = -ball_dm
			ball_dx = 1 * sign(ball_dx)
			-- wall collision sfx
			sfx(1)

			ball_y = mid(0,ball_y,111)
		end

		if ball_y < 0 + ball_radius then
			ball_dy = ball_dm
			ball_dx = 1 * sign(ball_dx)
			-- wall collision sfx
			sfx(1)


			ball_y = mid(0,ball_y,111)
		end

		-- horizontal

		-- only one button can be held at a time
		-- the second variable is moving
		if (btn(0)) and not (btn(2)) and not (btn(3)) then
			--pad_x -= 3

			--pad_dx = - pad_speed
			pad_dx = pad_dx - 0.75
			butpress = true
			pad_position = "horizontal"
		end

		if (btn(1)) and not (btn(2)) and not (btn(3))then
			--pad_x += 3
			
			--pad_dx = pad_speed
			pad_dx = pad_dx + 0.75
			butpress = true
			pad_position = "horizontal"
		end

		-- vertical pad movement 

		if (btn(2)) and not (btn(0)) and not (btn(1)) and not (btn(3)) then
			--pad_y -= 3

			--pad_dy = - pad_speed
			pad_dy =  pad_dy - 0.75
			butpress = true
			pad_position = "vertical"
		end

		if (btn(3)) and not (btn(0)) then
			--pad_y += 3

			--pad_dy = pad_speed
			pad_dy = pad_dy + 0.75
			butpress = true
			pad_position = "vertical"
		end

		if not(butpress) then
			pad_dx = pad_dx/1.7
			pad_dy = pad_dy/1.7
		end






		if pad_x <= 13 or pad_x >= 84 then
			if abs(pad_dx) > 1 then


				if sign(pad_dx) == -1 then
					pad_x = 100
					pad_dx = -1
				end


				if sign(pad_dx) == 1 then
					pad_dx = 1
				end

			
			end

		end








		--pad clamp border
		--pad_x = mid(16,pad_x, 91)
		--pad_y = mid(26,pad_y,85)

		if pad_position == "horizontal" then

			pad_x += pad_dx
			pad_x = mid(14,pad_x, 84)
		end

		if pad_position == "vertical" then

			pad_y += pad_dy
			pad_y = mid(29,pad_y,82)

		end
		pad_color = 2
		-- check if ball hit pad

		-- pad horizontal collision
		if (pad_position == "horizontal") then
			--everything is alright
			pad_hitbox_x = pad_x
			pad_hitbox_y = pad_y
			pad_hitbox_width = pad_width
			pad_hitbox_height = pad_height

			-- bouncebox left setup
			--pad_bouncebox_left_x = pad_hitbox_x
			--pad_bouncebox_left_y = pad_hitbox_y
		end
		-- pad vertical coliistion
		if (pad_position == "vertical") then
			-- addusting the variables for the hitbox
			pad_hitbox_x = pad_x + pad_width / 2 - pad_height / 2 
			pad_hitbox_y = pad_y - pad_width / 2
			pad_hitbox_width = pad_height
			pad_hitbox_height = pad_width

			-- bouncebox left setup
			-- left meaning on top
		end



		--if ball_box(pad_bouncebox_left_x,pad_bouncebox_left_y,pad_bouncebox_left_x,pad_bouncebox_left_y + pad_hitbox_height) then


		-- if (ball_box(pad_x - 1,pad_y,pad_x-1,pad_y + pad_height)) then
		-- 	ball_x = 5
		-- 
		-- 	pad_color = 11

		-- end



		-- pad collision check against the new variables
		if (ball_box(pad_hitbox_x, pad_hitbox_y, pad_hitbox_width, pad_hitbox_height)) then
			-- deal with collision

			pad_color = 8
			sfx(0)

			-- ball angle change
			-- absolute value

			--horizontal check
			if abs(pad_dx) > 1 then
				-- change angle
				if sign(pad_dx) == sign(ball_dx) then

					-- pad and ball moving in the same direction
					-- flatten the angle
					-- mid locks value above 0 
					setang(mid(0,ball_ang-1,2))
				else
					-- raise angle
					if ball_ang==2 then
						ball_dx = - ball_dx
					else
						setang(mid(0,ball_ang+1,2))
					end
				end


			end


			if abs(pad_dy) > 1 then
				-- change angle
				if sign(pad_dy) == sign(ball_dy) then

					-- pad and ball moving in the same direction
					-- flatten the angle
					-- mid locks value above 0 
					setang(mid(0,ball_ang+1,2))
				else
					-- raise angle
					if ball_ang==2 then
						ball_dy = - ball_dy
					else
						setang(mid(0,ball_ang-1,2))
					end
				end


			end

			if (pad_position == "horizontal") then
				ball_dy = - ball_dy
			end

			if (pad_position == "vertical") then
				ball_dx = - ball_dx
			end
		end




		if pad_position == "horizontal" then


			-- left pad check
			--if ball_box(pad_hitbox_x - 1, pad_hitbox_y + 1,1,pad_hitbox_height / 2) then
			--if ball_box(pad_hitbox_x -1, pad_hitbox_y,1,pad_hitbox_height) then
			if ball_box(pad_hitbox_x -3, pad_hitbox_y,3,pad_hitbox_height) then
				--debug = "left hit"
				ball_x -= abs(pad_dx + pad_dy) * 2 + 5
				ball_dx = - ball_dx
				sfx(0)

			end

			-- right pad check
			--if ball_box(pad_hitbox_x + pad_hitbox_width, pad_hitbox_y + 1,1,pad_hitbox_height / 2) then
			--if ball_box(pad_hitbox_x + pad_hitbox_width +1, pad_hitbox_y,1,pad_hitbox_height) then
			if ball_box(pad_hitbox_x + pad_hitbox_width +3, pad_hitbox_y,3,pad_hitbox_height) then
				--debug = "right hit"
				ball_x += abs(pad_dx + pad_dy) * 2 + 5
				ball_dx = - ball_dx
				sfx(0)

			end


		end

		if pad_position == "vertical" then

			-- top pad check
			if ball_box(pad_hitbox_x + pad_hitbox_width /2, pad_hitbox_y - 3, pad_height , 3) then
			--if ball_box(pad_hitbox_x + pad_hitbox_width /2, pad_hitbox_y - pad_hitbox_width /2 -1, pad_hitbox_height, 1) then
				ball_y -= abs(pad_dx + pad_dy) * 2 + 5
				ball_dy = - ball_dy
				sfx(0)
				--debug = "top hit"

			end


			-- bottom pad check
			--if ball_box(pad_hitbox_x + pad_hitbox_width / 2, pad_hitbox_y + pad_hitbox_height, pad_hitbox_width / 2, pad_hitbox_width /2) then
			if ball_box(pad_hitbox_x + pad_hitbox_width / 2, pad_hitbox_y + pad_width, pad_height , 3) then
				ball_y += abs(pad_dx + pad_dy) * 2 + 5
				ball_dy = - ball_dy
				sfx(0)
				--debug = "bottom hit"
			end
		end


		--rectfill(pad_bouncebox_left_x,pad_bouncebox_left_y,pad_bouncebox_left_x,pad_bouncebox_left_y + pad_hitbox_height)

		--if pad_position == "horizontal" then

		--if ball_box(pad_bouncebox_left_x,pad_bouncebox_left_y,pad_bouncebox_left_x + 0,pad_bouncebox_left_y+3) then
		--	ball_x = 5
		--	pad_color = 11
		--end


		--end


		-- ing system update
		update_ing()

		-- if we've got order rolling
		spawnnew_ing()

		if ing_1 == 0 and ing_2 == 0 and ing_3 == 0 and ing_4 == 0 and ing_5 == 0 then
			player_score += 250

			show_completed_order()
			new_order()
			--generate_new_sushi_set(5)
			--new order sfx
			sfx(6)
		end




	end


end







function _draw()

	if scene == "menu" then
		cls()
		-- background color
		rectfill(0,0,127,127,0)
		-- background pattern
		drawbackgroundpattern()
		-- logo
		spr(96,12,10,12,12)
		outline("press x to start",33,80,8,1)
		outline("➡️ highscore",45,90,1,8)
		outline("⬅️ credits",45,100,1,8)
		--debug

		drawcredits()
		drawhighscore()
		-- cross pattern
		--spr(137,0,30,2,2)
		--spr(141,112,46,2,2)
		camera(camerax,0)

		--debug

		--debug
		--pset(0,0,7)

	end

	if scene == "gameover" then
		cls()

		whiteframe += 10

		local y_offset = 15

		local is_on_highscore = false

		ing_matrix_tic += 0.1

		draw_game_scene()

		rectfill(0,45 -y_offset,127,104 -y_offset,2)
		rect(0,45 -y_offset,127,104 -y_offset,10)
		--print("game over",45,50,7)
		outline("game over", 45,50 -y_offset,8,0)

		-- high score


		print("score:",42,68 -y_offset,7)
		--print(player_score,70,60,7)
		print(player_score,70,68 -y_offset,7)
		outline("x restart",45,85 -y_offset,8,1)
		outline("z menu",50,95 -y_offset,1,8)

		spr(ing_matrix_tic,20,50 -y_offset)
		spr(ing_matrix_tic,101,50 -y_offset)

		if ing_matrix_tic >= 5 then
			ing_matrix_tic = 1
		end
		-- TODO
		-- spritey skわ🐱adnikれはw
	end


	if scene == "tutorial" then
		if tutorial_part == 1 then

			
			cls()
			local onboarding_buttons_x_offset = -5
			rectfill(0,0,127,127,13)

			print("welcome chef",5,5,7)
			print("your goal is to", 5,25,7)
			print("complete sushi orders",5,35,7)
			spr(71,93,33,2,1)
			spr(75,107,33)
			print("by collecting",5,55,7)
			print("the ingriedients",5,65,7)
			spr(1,73,63)
			spr(2,86,63)
			spr(3,99,63)
			spr(4,112,63)
			print("with the cook ball",5,85,7)

			circ(84,87,ball_radius + 1,2)
			circfill(84,87,ball_radius,8)

			print("x to continue",72,105,7)
			print("z to go back",5,105,6)
			circfill(53 + onboarding_buttons_x_offset,120,2,7)
			circ(62 + onboarding_buttons_x_offset,120,2,6)
			circ(71 + onboarding_buttons_x_offset,120,2,6)
			circ(80 + onboarding_buttons_x_offset,120,2,6)
		end

		if tutorial_part == 2 then

			
			cls()
			local onboarding_buttons_x_offset = -5

			local gamepad_offset = 5
			local gamepad_offset_y = -27


			local vertical_pad_offset = -10

			rectfill(0,0,127,127,13)

			print("control the cook ball",5,5,7)
			print("with the chef pad", 5,15,7)
			print("using the arrow keys",5,25,7)
			print("you can move",5,45,7)
			print("in all directions",5,55,7)

			-- left arrow
			spr(14,90 + gamepad_offset,43 + gamepad_offset_y)

			-- right arrow
			spr(14,104 + gamepad_offset,43 + gamepad_offset_y,1,1,1,0)

			-- top arrow
			spr(46,97 + gamepad_offset,37 + gamepad_offset_y)

			-- bottom arrow
			spr(46,97 + gamepad_offset,49 + gamepad_offset_y,1,1,1,0)


			local xoffset = -20



			-- left arrow
			spr(14,32 + xoffset,71)

			rectfill(pad_x - 10 + xoffset, pad_y + 10, pad_x + pad_width - 10 + xoffset, pad_y + pad_height + 10, pad_color)

			-- right arrow
			spr(14,81 + xoffset,71,1,1,1,0)

			rectfill(
			pad_x + pad_width / 2 - pad_height / 2 - pad_height / 2 + 30,
			pad_y - pad_width / 2 + 15 + vertical_pad_offset,
			pad_x + pad_width / 2 + 30,
			pad_y + pad_width / 2 + 15 + vertical_pad_offset,
			pad_color
			)

			-- top arrow
			spr(46,95,50 + vertical_pad_offset)

			-- bottom arrow
			spr(46,95,99 + vertical_pad_offset,1,1,1,0)

			--print("the pad can go up and down",5,65,7)
			--print("and left and right",5,75,7)

			print("x to continue",72,105,7)
			print("z to go back",5,105,6)
			circ(53 + onboarding_buttons_x_offset,120,2,6)
			circfill(62 + onboarding_buttons_x_offset,120,2,7)
			circ(71 + onboarding_buttons_x_offset,120,2,6)
			circ(80 + onboarding_buttons_x_offset,120,2,6)
		end

		if tutorial_part == 3 then

			
			cls()
			local onboarding_buttons_x_offset = -5
			rectfill(0,0,127,127,13)

			print("if the ball outline is white", 5,5,7)
			print("you can press x",5,15,7)
			print("to freeze it for a moment",5,25,7)
			print("x",59,50,6)
			print("you can use freeze again",5,65,7)
			print("once the outline goes white",5,75,7)

			-- frosted ball
			circfill(80,41,4,12)

			circ(40,41,ball_radius + 1,7)
			circfill(40,41,ball_radius,8)


			-- arrow in between
			-- left arrow
			spr(31,56,38)

			-- onboarding buttons
			print("x to continue",72,105,7)
			print("z to go back",5,105,6)
			circ(53 + onboarding_buttons_x_offset,120,2,6)
			circ(62 + onboarding_buttons_x_offset,120,2,6)
			circfill(71 + onboarding_buttons_x_offset,120,2,7)
			circ(80 + onboarding_buttons_x_offset,120,2,6)
		end

		if tutorial_part == 4 then

			
			cls()
			local onboarding_buttons_x_offset = -5
			rectfill(0,0,127,127,2)

			print("watch the timer", 5,5,7)

			-- progress bar box
			rect(0,15,127,18,bar_col)

			-- progress bar 
			rectfill(0,15, 80,18,bar_col)


			print("if it goes down to zero",5,25,7)
			print("you loose",5,35,7)

			-- progress bar box
			rect(0,45,127,48,8)

			-- progress bar 
			rectfill(0,15, 80,18,bar_col)





			print("hiting the bombs",5,55,7)
			spr(5,72,53)
			print("damages the timer",5,65,7)
			print("are you ready chef?",5,85,7)


			--print("x to continue",5,95,7)
			print("x to continue",72,105,7)
			print("z to go back",5,105,6)
			circ(53 + onboarding_buttons_x_offset,120,2,6)
			circ(62 + onboarding_buttons_x_offset,120,2,6)
			circ(71 + onboarding_buttons_x_offset,120,2,6)
			circfill(80 + onboarding_buttons_x_offset,120,2,7)
		end
	end

	if scene == "game" then
		draw_game_scene()

	end


end

function ball_box(box_x, box_y, box_width, box_height)
	--checks the collision of a ball with a rectangle
	-- top edge check
	if ball_y - ball_radius > box_y + box_height then
		return false
	end
	-- botton edge check
	if ball_y + ball_radius < box_y then
		return false
	end
	-- left edge check
	if ball_x - ball_radius > box_x + box_width then
		return false
	end
	-- right edge check
	if ball_x + ball_radius < box_x then
		return false
	end

	-- collision occured
	collision = true
	return true

end

-- particles

-- adds a particle
function addpart(_x,_y,_type,_maxage,_col, _oldcol)
	local _p = {}
	_p.x = _x
	_p.y = _y
	_p.tpe = _type
	_p.mage = _maxage
	-- age starts at zero, goes to maxage
	_p.age = 0
	_p.col = _col
	-- color near death
	_p.oldcol = _oldcol

	-- we're adding a particle to particle array
	add(part,_p)
end

-- sprawns a trail
function spawntrail(_x, _y)
	-- random angle
	local _ang =  rnd()
	-- random x and y offset
	local _ox = sin(_ang) * ball_radius * 0.6
	local _oy = cos(_ang) * ball_radius * 0.6

	addpart(_x + _ox,_y + _oy,0,20 + rnd(15), 8, 2)
end

function spawnboom(_x,_y)
	addpart(_x,_y,8,200,8,0)
end

function updateparts()
	local _p
	for i=#part,1, -1 do
		_p = part[i]
		_p.age += 1
		if (_p.age > _p.mage) then
			del(part, part[i])
		else
			if (_p.age / _p.mage) > 0.6 then
				_p.col = _p.oldcol
			end
		end
	end
end

function drawparts()
	for i = 1,#part do
		_p = part[i]
		--print(_p.tpe,1,20,10)
		-- checks if particle is trail type
		if _p.tpe == 0 then
			--print("PSET", 1,10, 10)
			pset(_p.x,_p.y,_p.col)
		else
		end

		-- if bomb
		if _p.tpe == 8 then
			-- big explosion circle range
			local bigrange
			local t = 0

			local col1 = 8
			local col2 = 9
			local col3 = 7
			-- function that I made 
			-- - 1/10 x^2 + 10
			-- dodaj przesuniろ▥cie na b わもeby symetria byわ🐱a gdzie indziej

			--bigrange = mid(0,_p.age,15)
			-- fast function
			--bigrange = - bigrange * (bigrange - 10)
			-- new function
			bigrange = _p.age
			bigrange = (- bigrange / 60) * (bigrange - 120)
			--bigrange = (- bigrange / 20) * (bigrange - 50)

			if _p.age > 0 then
				_p.col = 7 
			end

			if _p.age > 10 then
				_p.col = 10
			end

			if _p.age > 20 then
				_p.col = 9
			end

			if _p.age > 30 then
				_p.col = 8
			end

			if _p.age > 40 then
				_p.col = 0
				col1 = 0
				col2 = 0
				col3 = 0
			end


			circfill(_p.x,_p.y,bigrange,col1)
			circfill(_p.x,_p.y,bigrange /2,col2)
			circfill(_p.x,_p.y,bigrange /4, col3)

			circfill(_p.x + 2,_p.y + 3,bigrange,col1)
			circfill(_p.x - 4,_p.y,bigrange /2,col2)
			circfill(_p.x,_p.y + 2,bigrange /4, col3)
			--pset(_p.x,_p.y,_p.col)
		end
	end
end

-- ball angle changing
function setang(ang)
	ball_ang = ang
	if ang == 2 then
		-- 0.50
		-- 1.30
		ball_dx = 0.50 * sign(ball_dx)
		ball_dy = 1.30 * sign(ball_dy) 
	elseif ang == 0 then
		ball_dx = 1.30 * sign(ball_dx)
		ball_dy = 0.50 * sign(ball_dy)

	else
		ball_dx = 1 * sign(ball_dx)
		ball_dy = 1 * sign(ball_dy)

	end
end

-- returns a sign (+,-) of a variable
function sign(n)
	if n<0 then
		return -1
	elseif n>0 then
		return 1
	else 
		return 0
	end
end

function drawbackground()

	-- background
	rectfill(0,0,128,128,0)

	drawsmallbox()

	-- big box - ramka
	


	-- top right corner
	spr(8,112,0,2,2)

	-- bottom left corner
	spr(38,0,96,2,2)



	-- wall joining the corners
	drawwall()
	-- outline of big box
	--rect(0,0,127,111,line_col)


	-- small box
	-- pattern test
	-- fillp(0b1000010000100001)
	-- rectfill(13,13,114,98,4)
	-- fillp()


	-- pattern inside small box
	--rect(13,13,114,98,4)





	-- progress bar box
	rect(0,124,127,127,bar_col)

	-- progress bar 
	rectfill(0,124,bar_x,127,bar_col)

	-- counter

	-- number 1
	if ing_1 == 0 then
		print(ing_1,4,116,11)
	else
		print(ing_1,4,116,9)
	end
	-- sprite 1
	spr(1,13,114)

	-- number 2
	if ing_2 == 0 then
		print(ing_2,30,116,11)
	else
		print(ing_2,30,116,9)
	end
	-- sprite 2
	spr(2,39,114)

	-- number 3
	if ing_3 == 0 then
		print(ing_3,56,116,11)
	else
		print(ing_3,56,116,9)
	end
	-- sprite 3
	spr(3,65,114)

	-- number 4
	if ing_4 == 0 then
		print(ing_4,82,116,11)
	else
		print(ing_4,82,116,9)
	end
	-- sprite 4
	spr(4,91,114)


	-- score bar
	print(player_score,108,116,7)

	--print(order_time,60,80,8)
	--print(frame,60,90,9)
	--print(order_time_procentage,60,70,10)



end


function drawserveboxes()
	-- serve boxes
	-- rectfill(0,0,12,12,line_col)
	 --rectfill(115,99,127,111,line_col)
	-- top left corner
	spr(6,0,0,2,2)

	-- top right corner
	--spr(8,112,0,2,2)

	-- bottom left corner
	--spr(38,0,96,2,2)

	-- bottom right corner
	spr(6,112,96,2,2,true,true)
end

-- debug
function tomatoblink()
	d -= 1
	if d < 0 then
		s += 1
		if s > 20 then
			s = 17
		end
		d = 30
	end

end

function new_order()
	-- time to complete the order
	order_time = 60

	total_orders += 1

	-- bar green
	bar_col = 11

	-- getting a num in <1,4> range
	ing_ammount = flr(rnd(4)) + 1
	ing_ammount = mid(1,ing_ammount,4)

	-- setting which ing_types will be used


	ing_to_dispose = flr(rnd(total_orders)) + 1
	ing_to_dispose = mid(ing_ammount * 2,ing_to_dispose,20)
	-- ing_to_dispose = mid(total_orders,ing_to_dispose,20)
	start_ing_to_dispose = ing_to_dispose


	-- assigning all ings to buckets

	-- first ing type operation
	if flr(rnd(1)) ==  0 then
		ing_1 = flr(rnd(ing_to_dispose) / 2)
		ing_to_dispose -= ing_1
	else
		ing_1 = flr(rnd(ing_to_dispose))
		ing_to_dispose -= ing_1

	end

	ing_2 = flr(rnd(ing_to_dispose))
	ing_to_dispose -= ing_2

	ing_3 = flr(rnd(ing_to_dispose))
	ing_to_dispose -= ing_3

	ing_4 = flr(rnd(ing_to_dispose))
	ing_to_dispose -= ing_4


	-- temporary disabled due to UI
	--ing_5 = flr(ing_to_dispose)
	--ing_to_dispose -= ing_2

	-- 0 0 0 0 0 ing bug fix
	if ing_1 == 0 and ing_2 == 0 and ing_3 == 0 and ing_4 == 0 and ing_5 == 0 then
		ing_1 = 1
		ing_3 = 2

	end


	-- fixing the bug with 0 0 0 0 0
end

function update_order()
	-- decreasing order time
	-- making a countdown timer from 60 to 1 in every second
	frame += 1
	if frame > 60 then
		frame = 0
		sec += 1
	end

	if sec == 1 then
		order_time -= 1
		sec = 0
	end

	-- if timer reaches 0 it doesn't go negative
	if order_time < 0 then
		order_time = 0
		scene = "gameover"
		music(10)

		insertscoretohighscore()
		sort_high_score()
		savehs()
		
	end

	-- translating the order_time to % value
	order_time_procentage = flr(order_time / 60 * 100)
	bar_x = 128 * (order_time_procentage / 100)

	if order_time_procentage < 60 then
		bar_col = 9
	end
	if order_time_procentage < 30 then
		bar_col = 8
	end

	if order_time_procentage == 0 then
		bar_col = 7
	end

	-- the order is completed
	
end


function add_ing(x,y,_type,_tray)
	local ing = {}
	ing.x = x
	ing.y = y
	ing.tpe = _type
	-- _tray referes to the tray type that will serve the ing
	ing.tray = _tray
	-- used to remove the old ings on contact with new tray
	-- it's like a magical trick
	ing.mage = _maxage
	-- age starts at zero, goes to maxage
	ing.age = 0

	-- we're adding an ingredient to ingredient array
	add(ing_list,ing)
end

function update_ing()
	local ing
	-- iterating on each ingrediant in the ingredient list
	for i = #ing_list,1,-1 do
		-- local ing_dx
		local ing_dx = 0
		-- local ing_dy
		local ing_dy = 0

		ing = ing_list[i]
		-- aging of the ing
		ing.age += 1
		-- moving the ing
		-- debug values
		--ing.x += 1
		--ing.y += 1


		-- calculating the movement
		
		if ing.tray == "BOTTOM" then
			-- bottom right corner hit
			if ing.x > 3 and ing.y > 100 then
				ing.x -= ing_speed
			end
			if ing.x <= 3 and ing.y > 3 then
				ing.y -= ing_speed
			end

			if ing.y == 0 then
				del(ing_list,ing)
			end

			-- top left corner hit
			if ing.x <= 117 and ing.y <= 5 then
				del(ing_list,ing)
			end
		end

		if ing.tray == "TOP" then

			-- left upper corner hit
			if ing.x < 117 and ing.y < 101 then
				ing_dx = ing_speed
				ing_dy = 0
			end

			-- top right corner hit
			if ing.x >= 117 and ing.y < 101 then
				ing_dx = 0
				ing_dy = ing_speed
			end

			-- bottom right corner hit
			if ing.x >= 117 and ing.y >= 101 then
				del(ing_list,ing)
			end

		end

		-- moving the ing
		ing.x += ing_dx
		ing.y += ing_dy


		-- hitbox check
		if ball_box(ing.x,ing.y,8,8) then
			-- changing the values of ing types on the UI

			-- if bomb
			if ing.tpe == 5 then
				-- explosion in the middle
				spawnboom(ing.x + 4,ing.y + 4)
				whiteframe = 0
				--sfx of explosion
				sfx(29)
				order_time -= 10
				shake+=1
				--spawnboom(ing.x,ing.y)
			end


			--sfx of good ing
			sfx(3)
			if flr(ing.tpe) == 1 then
				ing_1 -= 1
				ing_1 = mid(0,ing_1,100)
			end

			if flr(ing.tpe) == 2 then
				ing_2 -= 1
				ing_2 = mid(0,ing_2,100)
			end

			if flr(ing.tpe) == 3 then
				ing_3 -= 1
				ing_3 = mid(0,ing_3,100)
			end

			if flr(ing.tpe) == 4 then
				ing_4 -= 1
				ing_4 = mid(0,ing_4,100)
			end

			if flr(ing.tpe) == 5 then
				ing_5 -= 1
				ing_5 = mid(0,ing_5,100)
			end
			del(ing_list,ing)
		end
	end

end


function draw_ing()
	local ing
	for i = 1,#ing_list do
		ing = ing_list[i]
		spr(ing.tpe,ing.x,ing.y)
	end
end

function spawnnew_ing()
	tic += 1

	coin = flr(rnd(2))




	local isbomb = flr(rnd(10))

	if ing_1 > 0 then
		ings_avaible[#ings_avaible + 1] = 1
	end

	if ing_2 > 0 then
		ings_avaible[#ings_avaible + 1] = 2
	end

	if ing_3 > 0 then
		ings_avaible[#ings_avaible + 1] = 3
	end

	if ing_4 > 0 then
		ings_avaible[#ings_avaible + 1] = 4
	end


	-- don't overflow 
	if #ings_avaible >= 5 then
		ings_avaible = {}

		if ing_1 > 0 then
			ings_avaible[#ings_avaible + 1] = 1
		end

		if ing_2 > 0 then
			ings_avaible[#ings_avaible + 1] = 2
		end

		if ing_3 > 0 then
			ings_avaible[#ings_avaible + 1] = 3
		end

		if ing_4 > 0 then
			ings_avaible[#ings_avaible + 1] = 4
		end

	end
	-- previously 120
	-- testing with 180
	if tic > 180 then

		if order_time > 0 then

				--top_type = flr(rnd(5) + 1)
				--debug = top_type
				--bottom_type = flr(rnd(5) + 1)
			
				-- do we spawn bombs?

				if rnd(1) >= 0.9 and safebomb == true then
					top_type = 5
					bottom_type = 5
					safebomb = false
				else

					-- do we spawn perfect or inperfect ings?
					if rnd(1) >= 0.5 then
						top_type = ings_avaible[flr(rnd(#ings_avaible) +1)]
						bottom_type = ings_avaible[flr(rnd(#ings_avaible) +1)]

						if top_type == 0 then
							top_type = 1
						end

						if bottom_type == 0 then
							top_type = 2
						end

					else
						top_type = flr(rnd(5) + 1)
						bottom_type = flr(rnd(5) + 1)

					end

					-- that what we want turn
					safebomb = true
						
					end


				end


			--	add_ing(1,3,flr(rnd(5) + 1),"TOP")
			--	add_ing(115,101,flr(rnd(5) + 1),"BOTTOM")
			add_ing(1,3,top_type,"TOP")
			add_ing(115,101,bottom_type,"BOTTOM")
			tic = 0
			sfx(7)
		end
	end

function drawsmallbox()
	local n = 0
	local row = 0
	-- for each row
	for p=1,11 do
		n = 0

		-- filling the row
		for i=1,13 do
			spr(36,13 + n * 8,13 + row * 8)
			n += 1

		end
		row +=1 
	end

end

function drawwall()
	local n = 0
	-- left wall
	for i=1,5 do

		spr(42,0,16 + 16 * n,2,2)
		n += 1
	end

	-- right wall
	n = 0
	for i=1,5 do

		spr(44,112,16 + 16 * n,2,2)
		n += 1
	end

	-- top wall
	n = 0
	for i=1,6 do

		spr(10,16 + 16* n,0,2,2)
		n += 1
	end

	-- bottom wall
	n = 0
	for i=1,6 do

		spr(12,16 + 16* n,96,2,2)
		n += 1
	end

	-- fix for the pattern
	
end

function doshake()
 -- this function does the
 -- shaking
 -- first we generate two
 -- random numbers between
 -- -16 and +16
 local shakex=16-rnd(32)
 local shakey=16-rnd(32)

 -- then we apply the shake
 -- strength
 shakex*=shake
 shakey*=shake
 
 -- then we move the camera
 -- this means that everything
 -- you draw on the screen
 -- afterwards will be shifted
 -- by that many pixels
 camera(shakex,shakey)
 
 -- finally, fade out the shake
 -- reset to 0 when very low
 shake = shake*0.95
 if (shake<0.05) shake=0 end


function drawbackgroundpattern()
	local n = 0
	for i=0,8 do
		spr(206,0 + n,30,2,2)
		spr(206,0 + n,46,2,2)
		n += 16
	end
end


function update_camera()

	-- if camera in main menu and moving right
	if camera_active_room == 0 and cameramoving == true and camera_direction == 1 then
		-- if camera moving right
			if camerax < 127 then
				--camerax += 5
				camerax = camerax * 1.2 + 3

			else
				camera_active_room = 1
				cameramoving = false

			end

	end

	-- if camera in main menu and moving left
	if camera_active_room == 0 and cameramoving == true and camera_direction == -1 then
		-- if camera moving left
			if camerax > -128 then
				--camerax -= 5
				camerax = camerax * 1.2 - 3


			else
				camera_active_room = -1
				cameramoving = false

			end
	end

	-- if camera in high score and moving left
	if camera_active_room == 1 and cameramoving == true and camera_direction == -1 then
		-- if camera moving left
			if camerax > 0 then
				camerax -= 5
				camerax = mid(0,camerax,128)

			else
				camera_active_room = 0
				cameramoving = false

			end
	end

	-- if camera in credits and moving right
	if camera_active_room == -1 and cameramoving == true and camera_direction == 1 then
		-- if camera moving left
			if camerax < 0 then
				camerax += 5
				camerax = mid(-128,camerax,0)

			else
				camera_active_room = 0
				cameramoving = false

			end
	end
	camerax = mid(-128,camerax,128)
end



function drawcredits()
	-- left from the start
	local xoffset = 128

	--debug
	--pset(0 -xoffset,0,7)

	local n = 0
	for i=0,7 do
		spr(206,0 + n - xoffset,30,2,2)
		spr(206,0 + n - xoffset,46,2,2)
		n += 16
	end

	-- printing the credits
	-- header background
	rectfill(45 -xoffset,8,82 -xoffset,30,2)
	rect(45 -xoffset,8,82 -xoffset,30,10)
	print("credits", 50 - xoffset, 12,7)

	categories = {"code", "graphics","sfx", "music","ux/ui", "degign", "vfx", "mentoring"}
	authors = {"gabriel", "ola", "kacper,kornel", "kacper/kornel", "gabriel", "gabriel","gabriel","konrad,jedrzej,kamil"}
	local highsocrexoffset = -35
	local highsocreyoffset = 10

	--pset(0 -xoffset,0,7)

	local n = 0
	for i=0,7 do
		spr(206,0 + n - xoffset + highsocrexoffset,30,2,2)
		spr(206,0 + n - xoffset + highsocrexoffset,46,2,2)
		n += 16
	end

	-- header
	-- bottom text
	outline("menu ➡️",50 -xoffset,115,1,8)

	-- box
	rectfill(33 -xoffset + highsocrexoffset + 4,20,75-xoffset + highsocrexoffset + 85,108,2)
	rect(33 -xoffset + highsocrexoffset + 4,20,75-xoffset + highsocrexoffset + 85,108,10)

	line(46 -xoffset,20,81 -xoffset,20,2)
	-- letters
	for i=1,8 do
		print(categories[i],40 -xoffset + highsocrexoffset, 17 + i*10,7)
		print(authors[i],79 -xoffset + highsocrexoffset, 17 + i*10,7)
		--print(i,39 -xoffset + highsocrexoffset, 17 + i*10,7)

	end
end

function drawhighscore()
	local xoffset = -128

	local highsocrexoffset = 0
	local highsocreyoffset = 10

	--pset(0 -xoffset,0,7)

	-- background pattern
	local n = 0
	for i=0,7 do
		spr(206,0 + n - xoffset + highsocrexoffset,30,2,2)
		spr(206,0 + n - xoffset + highsocrexoffset,46,2,2)
		n += 16
	end


	-- box
	rectfill(33 -xoffset + highsocrexoffset,20,94-xoffset + highsocrexoffset,78,2)
	rect(33 -xoffset + highsocrexoffset,20,94-xoffset + highsocrexoffset,78,10)
	-- letters
	for i=1,5 do
		print(hs[i],50 -xoffset + highsocrexoffset, 17 + i*10,7)
		print(i,39 -xoffset + highsocrexoffset, 17 + i*10,7)

	end

	rectfill(41 -xoffset,8,87 -xoffset,20,2)
	rect(41 -xoffset,8,87 -xoffset,20,10)
	line(42 -xoffset,20,86 -xoffset,20,2)
	-- header
	print("high score", 45 - xoffset, 12,7)
	-- bottom text
	outline("⬅️ menu",50 -xoffset,100,1,8)
end

-- resets the highscore
function reseths()
	hs={500,7000,300,200,1000}
	savehs()
end


function loadhs()
	local _slot = 0

	if dget(0) == 1 then
		-- load the data
		_slot += 1
		for i=1,5 do

			hs[i] = dget(_slot)
			_slot += 1
		end
	else
		reseths()

	end

end

function savehs()
	local _slot = 0
	dset(0, 1)

	if dget(0) == 1 then
		-- load the data
		_slot = 1
		for i=1,5 do
			dset(_slot,hs[i])
			_slot += 1
		end
		debug = dget(1)
	else
		hs={500,400,300,200,100}
		savehs()

	end
end

function insertscoretohighscore()
	-- appends the high score to the end of the list
	hs[#hs + 1] = player_score

end


-- sorts the high score and deletes the last bit
function sort_high_score()
    for i=1,#hs do
        local j = i
        while j > 1 and hs[j-1] < hs[j] do
            hs[j],hs[j-1] = hs[j-1],hs[j]
            j = j - 1
        end

	end

	hs[6] = nil
end

function game_vars_fresh_start()
	--debug
	collision = false
	debugnum = 10


	--debug outline
	outline_col = 0
	-- animation sprite number
	s = 17
	-- animation delay
	d = 30
	-- background setup
	line_col = 7
	-- pad setup
	pad_x = 55
	pad_y = 63
	--pad speed
	pad_dx = 0
	pad_dy = 0
	pad_position = "horizontal"
	pad_width = 30
	pad_height = 3
	pad_color = 3

	pad_hitbox_x = 0
	pad_hitbox_y = 0
	pad_hitbox_width = 0
	pad_hitbox_height= 0
	pad_speed = 5


	-- bouncebox left setup
	--pad_bouncebox_left_x = 0
	--pad_bouncebox_left_y = 0


	-- ball setup
	ball_radius = 3
	ball_x = 30
	ball_y = 20
	-- max speed
	ball_dm = 0.5
	ball_dx = ball_dm
	ball_dy = ball_dm

	ball_ang = 0

	ball_col = 9

	-- freeze
	freezetimer = 0
	ball_frosted = false
	frosted_timer = 0
	-- target setup
	target_x = rnd(100)
	target_y = 6
	target_radius = 5
	-- max speed
	target_dm = 0.25
	-- initial setup for top left of the screen
	target_dx = target_dm
	target_dy = 0


	-- sec target setup

	sectarget_x = 6
	sectarget_y = rnd(100)
	sectarget_radius = 5
	-- max speed
	sectarget_dm = 0.25
	-- initial setup for top left of the screen
	sectarget_dx = 0
	sectarget_dy = -target_dm
	-- max speed


	-- bad target setup
	badtarget_sprite = 1
	badtarget_x = rnd(100)
	badtarget_y = 122
	badtarget_radius = 5
	-- max speed
	badtarget_dm = 0.3
	-- initial setup for bottom right corner
	badtarget_dx = - badtarget_dm
	badtarget_dy = 0

	--score setup
	score = 0



	-- particles setup
	part = {}


	-- order system variables

	order_time = 0

	ingr_total_number = 5
	total_orders = 0

	-- number of n per ingredient
	ing_1 = 0
	ing_2 = 0 
	ing_3 = 0
	ing_4 = 0 
	ing_5 = 0

	-- starting ing_types array
	ing_types_start = {ing_1,ing_2,ing_3,ing_4,ing_5}

	-- how many ing types will be in play in this round
	ing_ammount = 0

	-- how many ings in this order are left to be disposed between ing types
	ing_to_dispose = 0

	-- how many total ings are on the start
	start_ing_to_dispose = 0

	-- ing speed
	ing_speed = 0.5


	-- order system update
	frame = 0
	sec = 0
	order_time_procentage = 0
	bar_col = 7
	bar_x = 0

	-- ingredient control setup
	ing_list = {}

	-- order new ing adding
	tic = 0

	-- player score var
	player_score = 0


	--screen shake vars
	shake = 0

	-- order is starting now debug
	new_order()


	-- white frame 
	whiteframe = 0

	frosted_cooldown = 0


	-- camera moving
	camerax = 0
	camera_direction = 0 
	cameratimer = 0
	cameramoving = false


	-- in which room are we now? 
	-- -1 credits
	-- 0 splash
	-- 1 highscore
	camera_active_room = 0

	music(1)
end

function draw_game_scene()

		if game_scene_freeze == false then
			cls()

			doshake()


			-- background from mockup
			drawbackground()

			-- ing system draw
			draw_ing()

			
			drawserveboxes()



			-- test sprites
			-- spr(1,60,101)
			-- spr(2,117,81)
			-- spr(3,3,23)
			-- spr(4,84,3)

			-- animation test
			-- spr(s,60,40)



			-- target
			-- circfill(target_x,target_y,target_radius,11)

			-- sectarget
			-- circfill(sectarget_x,sectarget_y,sectarget_radius,11)

			-- bad target
			--circfill(badtarget_x,badtarget_y,badtarget_radius,8)
			-- spr(badtarget_sprite,badtarget_x,badtarget_y)

			-- player pad
			--rectfill(pad_x, pad_y, pad_x + pad_width, pad_y + pad_height, pad_color)

			--rectfill(pad_hitbox_x, pad_hitbox_y, pad_hitbox_x + pad_width, pad_hitbox_y + pad_height, 10)

			if pad_position == "horizontal" then
				rectfill(pad_x, pad_y, pad_x + pad_width, pad_y + pad_height, pad_color)
			end

			if pad_position == "vertical" then
				rectfill(
				pad_x + pad_width / 2 - pad_height / 2 - pad_height / 2,
				pad_y - pad_width / 2,
				pad_x + pad_width /2,
				pad_y + pad_width / 2,
				pad_color
				)
			end

			-- particles
			drawparts()
			--print(#part,1,1,10)


			-- ball outline
			circfill(ball_x,ball_y,ball_radius + 1, outline_col)
			--ball
			circfill(ball_x,ball_y,ball_radius, ball_col)



			--camera(pad_x - 64,pad_y - 64 )

			-- bouncebox left setup
			--rectfill(pad_bouncebox_left_x,pad_bouncebox_left_y,10,10)






			--debug
			
			-- draw the white frame on the explosion
			if whiteframe < 5 then
				rectfill(0,0,127,127,7)
				whiteframe += 1

			end
		end
	end


function outline(s,x,y,c1,c2)
	for i=0,2 do
	 for j=0,2 do
	  if not(i==1 and j==1) then
	   print(s,x+i,y+j,c1)
	  end
	 end
	end
	print(s,x+1,y+1,c2)
end

function show_completed_order()

end
__gfx__
00000000000770000000a0000000000000fee700000890009222222222222ed1d1d1d1d1d1d1d1d0d1d1d1d1d1d1d1d100000000000000000011100000022200
00000000007af70000003b0a000000000fef7e800000a0002f8f8f89898e8213131313131313131d13131313131313130000000000000000011910000002f220
0070070009ff798000b003b000afaa9908f7ffe0005dd60028f8989898e8e21111111111111111311111111111111111d1d1d1d1d1d1d1d111e8111122229a22
000770000fa7f7f0a00b5b300a4999a0028f8f800555dd602f8f89898e8e8211111111111111111d111111111111111113131313131313131e888881299999a2
000770007a6777f70b33b300a9994a000288e8f005555d5028989898e8e8e2111111111111111131111111111111111111111111111111111888882128999992
0070070077767779005333b00000000002e88ee00e5555502f89888888888211111111111111111d111111111111111111111111111111111188111122229922
0000000087f77f690000a530000000000228888002d5552028989888888882111111111111111131111111111111111111111111111111110118100000029220
0000000008aff98000000abd000000000022e800002552002989888888888211111111111111111d111111111111111111111111111111110011100000022200
015113b0000770000333b3b000000000002ff800faf99faf2898988888888211111111111111113111111111111111111111111111111111f76a9fef00033300
100100010077770035555b5b0000000002ff7f80ff9ff9ff298e888888888211111111111111111d111111111111111111111111111111116f76f9ff0003f330
5010005b07f777a0355355b309999aaf088ff880a9f99f9f28e8e88888888211111111111111113111111111111111111111111111111111676767673333ba33
15010503077777705555b55b9aaaaaa908e88e80ff9ff9fa2e8e888888888211111111111111111d11111111111111111111111111111111767676763bbbbba3
1010000b7f777f7a55555353aaa9999a08e88e80faf99faf28e8e88888888213131311111111113113131313131313131111111111111111676767673cbbbbb3
11030503777777f7555555539a9aaa4008e88e80ff9ff9ffe2222222222228d1d1d111111111111dd1d1d1d1d1d1d1d11111111111111111767676763333bb33
2030500357777f753555555b00000000028e8880a9f99f9f1311111111113100001311111111113100000000000000001313131313131313f76a9fef0003b330
0213133005ffff500b5553300000000000288800ff9ff9fad111111111111d0000d111111111111d0000000000000000d1d1d1d1d1d1d1d16f7ff9ff00033300
00000000f6f77f6f00000000000000009a9ff9a9f76a9fef13111111111131000013111111111131131111111111310000131111111111310022220000000000
00faaaa9ff7ff7ff007ff94000799f0099f99f996f76f9ffd111111111111d0000d111111111111dd111111111111d0000d111111111111d022a922000000000
0aafaa98f7f77f7f07f97f9207ff99f0ef9ff9f9f76a9fef13111111111131d1d18222222222222e1311111111113100001311111111113122a9992200000000
f9944940ff7ff7ff797f99fe7f99f99f99f99f9e6f7ff9ffd11111111111131313288888888e8e82d111111111111d0000d111111111111d2f99999200000000
0f9aaaa0f6f77f6ff999fef899f99fef9a9ff9a9f76a9fef1311111111111111112888888888e8e2131111111111310000131111111111312229922200000000
9af99a98ff7ff7ff7f9efe20e99f9fe499f99f996f76f9ffd11111111111111111288888888e8e82d111111111111d0000d111111111111d0029920000000000
00444980f7f77f7f09fe24000eefee40ef9ff9f9f76a9fef1311111111111111112888888888e8e2131111111111310000131111111111310029820000000000
00000000ff7ff7ff000000000000000099f99f9e6f7ff9ffd1111111111111111128888888898982d111111111111d0000d111111111111d0022220000000000
00000000000000000000a00000000000000ee000f76a9fef13111111111111111128888888889892131111111111310000131111111111310000000000000000
00000000000f700000003b0a00000000008f7e00ff76f9ffd1111111111111111128888888898982d111111111111d0000d111111111111d0000000000000000
0000000000777a0000b003b000afaa9900e77e00f76a9fef131111111111111111288888888898f2131111111111310000131111111111310000000000000000
000000000777f770a00b5b300a4999a0008f7e00ff7ff9ffd111111111111111112e8e8989898982d111111111111d0000d111111111111d0000000000000000
0000000077a777a70b33b300a9994a0000eeee00f76a9fef13111111111111111128e8e89898f8f2131111111111310000131111111111310000000000000000
00000000a7af7af7005333b000000000008eee00ff76f9ffd111111111111111112e8e8989898f82d111111111111d0000d111111111111d0000000000000000
00000000077777700000a53000000000000ee000f76a9fef1d131313131313131328e89898f8f8f2131111111111310000131111111111310000000000000000
0000000000ffff0000000abd0000000000000000ff7ff9ff01d1d1d1d1d1d1d1d1e2222222222229d111111111111d0000d111111111111d0000000000000000
000011111111000000002222222200000000005555500000000000000000000800000000033330000ffff0000055500099999000000000000099900000077f70
00011999e821100000022fa99982200000000557c350000000000000000000888800000037989300f7ea7f0005777500a99a55000007700009999a0000777770
000199e8888210000002fa9999982000000055abb3500000000000000008888800000000798e770077a9a7005749775079995999007777009757990007777770
00019e21188210000002f9822a98200000055abbb350000000000000008888870000000037978300f9779f0059b93950777559a90777777095b7990079597770
0001921118821000000298222a9820000005acbbb350000000000000088887770000000033333300ffffff00573875500775777777777777975790007f99f770
000111119882100000022222f99220000005cb5cb3500000000000008877770000000000033330000ffff000055555500005777777555577099a0000775f9770
0000111e8821100000000022998200000005555bb350000000000000077770000000000000000000000000000055550000000000075555700000000000777000
00000118882110000000002f992200000000005bb350000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000118882100000000229982000000000005bb350000000000000000000000000000000000008000000000000000000000000000000000055555000000000
0000110118821000000002f9922000000000005bb350000000000000000000000000000000000088880000000000000000000000000000000577777500000000
000111111e82100000000299820000000000005bb350000000000000000000000000000000088888000000000000000000000000000000005778897750000000
000199119882100000022f99222220000000005bb350000000000000000000000000000000888887000000000000000000000000000000005778997750000000
0001e888888210000002aa9822f820000000005bb350000000000000000000000000000008888777000000000000000000000000000000005577777550000000
00011388882210000002a999999820000000005cb350000000000000000000000000000088777700000000000000000000000000000000005555555550000000
000012222221100000022c9999822000000000593350000000000000000000000000000007777000000000000000000000000000000000005555555550000000
00001111111100000000222222220000000000555550000000000000000000000000000000000000000000000000000000000000000000000555555550000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555500000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000fff0000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000fffff0000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000ffffff00000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000fffffff000000000000000000000000000444424244444242444444444
00000000000000000000000000000000000000000000000000000000000000000000affffff00000000000000000000000000000444442424444424244444444
000000000000000000000000002222222222222220022222002222222222200000fffff222222220000000000000000000000000444424244444242444444444
0000000000000000000000000222222222222222222222220022222222222200fffff22222222222200000000000000000000000444442424444424244444444
0000000000000000000000000222faaaa999999f222ffae2022ffa999999e22ffff2222131313132220000000000000000000000444424242424242424242424
000000000000000000000000022ffaaa999999999e2fa982222fa9999999982fff222b1313131313222200000000000000000000444442424242424242424242
000000000000000000000000022aaf9999999f99982a998222f9999999a9982f222b313fff7fff3131222000000000f000000000444424242424242424242424
000000000000000000000000022aa9e2222222a9982999822fa998222299982222b31fff77ff77f71312220000000fff00000000444442424242424242424242
000000000000000000000000022aa9822222229998299982299a8222229998222b3fffe7ff77ffff7f3b220000000fff00000000444444449494444494944444
000000000000000000000000022a99820000229998299982299982ff22999822b3fffaffffff7f7e77f312200000fff000000000444444444949444449494444
0000000000000000000000000229998200002299982999822999ffff22a9982231f77ff7fabaaf7ffff132200000fff000000000444444449494444494944444
0000000000000000000000000229998200022299c329998299ffffff22fac82b177ffffaababa3ff7f7f1322000fff0000000000444444444949444449494444
0000000000000000000000000229998200222a9982299982ffffff00222222213fff7fabaabaa33f8f7f3122000fff0000000000444444449494444494942424
000000000000000000000000022999820222a999822999ffffff2000222222b3f7af79babaaab844fffff3b220fff00000000000444444444949444449424242
00000000000000000000000002299982222a99982229ffffff982000000022317ff7f99999ab4444f7f7713220fff00000000000444444449494444494242424
0000000000000000000000000229998222a9998222ffffff99982000000022137ef7999ff994444847fff3122fff000000000000444444444949444442424242
00000000000000000000000002299a9999999822ffffff8299982000000022317f7fe9f9999484444ff731322fff000000000000949494949494949494949494
00000000000000000000000002299999999982ffffff99829998200000002213ff7f8e99ff98448487f7f312fff0000000000000494949494949494949494942
0000000000000000000000000229999999c32fffff2999829998200000002231f7fefe9f99944844f7fff132fff0000000000000949494949494949494949424
000000000000000000000000022999e2222fffff02299982f998200000002213f7fff8e999ff4444fff7f3b2ff00000000000000494949494949494949494242
000000000000000000000000022999822fffff000229998229998200022222213ff7ff8e9f99484f7aff312fff00000000000000444444449494444444442424
000000000000000000000000022999822fff000002299982299982002222222b1f8ffffeeee844ffff8f132ff000000000000000444444444949444444444242
000000000000000000000000022999822f000000022999822999820022fa982231fa7f8ff888ff77fff132fff000000000000000444444449494444444442424
000000000000000000000000f229998220000000022999822f99822222a9982213fffff77fffffef7f7312ff0000000000000000444444444949444444444242
0000000000000000000000fff22999822000000002299982229998222a99c3222b3fff7fff7f77ff713b2fff0000000000000000000000000000000000000000
00000000000000000000fffff2299982200000000229998222a999999999822222131ffffe7fff7f13122ff00000000000000000000000000000000000000000
000000000000000000fffffff22a99b220000000022a99822222999999982220222b3137fff7ff3131222ff00000000000000000000000000000000000000000
0000000000000000ffffffff022fac3220000000022fac320222a99999c32200022223131313131b2222ff000000000000000000000000000000000000000000
00000000000000ffffffff0002222222200000000222222200222222222220000002222b31313122220fff000000000000000000000000000000000000000000
000000000000ffffffff00000222222220000000022222220002222222222002222222222222222222222f000000000000000000000000000000000000000000
0000000000ffffffff00000002222222200000000002222200002222222222222222202222222222222220000000000000000000000000000000000000000000
000000000fffffff00000000022ffae220000000022ffae200022ffa99999b22ffae200022ffae2ffae220000000000000000000000000000000000000000000
000000000fffff0000000000022fa98222000002222fa98200022fa999999982fa98200022fa982fa98220000000000000000000000000000000000000000000
0000000000fff00000000000022a99982220002222fa998200222a9999a99982a998200022a9982a998220000000000000000000000000000000000000000000
00000000000000000000000002299999a8200022fa9999820022fa9e22fa99829998200022999829998220000000000000000000000000000000000000000000
0000000000000000000000000229999998200022a99999820022999822299982a998200022999829998220000000000000000000000000000000000000000000
0000000000000000000000000229999998200022999999820222a998222999829998200222a99829998220000000000000000000000000000000000000000000
000000000000000000000000022999999820002299999982022f999822299982999820222f998229998220000000000000000000000000000000000000000000
000000000000000000000000022999999820002299999982022a99982229998299982222a9998229998220000000000000000000000000000000000000000000
000000000000000000000000022999a99982022999a99982022a9982222999829998222f99982229998220000000000000000000000000000000000000000000
00000000000000000000000002299f89998202299a8999820229998222299982999822f99982222999822000000000001dd1111111111dd13166363661616631
0000000000000000000000000229998a9998229999899982222a99822229998299a99999982202299982200000000000d11111111111111d1666161663636663
0000000000000000000000000229998fa99822999989998222f99a999999998299999999822002299982200000000000d111111dd111111d3c663636616166c1
000000000000000000000000022999822a9989999829998222a999999999998299999999820002299982200000000000111111dddd11111113cc1c1cc3c3cc13
000000000000000000000000022999822a999999c3299982229999999999998299982999820002299982200000000000111dd1dddd1dd1113131313131313131
000000000000000000000000022999822fa999998229998222a998222229998299982f9998200229998220000000000011dddddddddddd111316131663136313
0000000000000000000000000229998222a99998222999822f99982222299982999822999820ff29998220000000000011ddddd11ddddd1131c1313cc1313c31
00000000000000000000000002299982222a9982222999822a99822002299982999822a9998fff299982200000000000111ddd1111ddd1116313166316631316
00000000000000000000000002299982022fa982022999822a9982000229998299982229998fff29998220000000000011111dd11dd11111c13136c13c613136
00000000000000000000000002299982022222220229998229998200022999829998222f99fff22999822000000000001111dddddddd11111313131663131313
0000000000000000000000000229998200222220022999822a998200022999829998202299fff2299982200000000000111dddddddddd1116166313cc1316636
000000000000000000000000022999820000000002299982f99982000229998299982022afff22299982200000000000111ddddd1dddd1116366631313166616
000000000000000000000000022999820000000002299982a998220002299982999820022fff922999822000000000001111ddd111dd11116166c136613c6636
000000000000000000000000022a998200000000022a9982a9982000022a9982a9982002fff9982a9982200000000000d11111111111111dc36c131cc313c61c
000000000000000000000000022fac3200000000022fac3299c32000022fac32fac32000fffac32fac32200000000000d11111111111111d3131313131313131
00000000000000000000000002222222000000000222222222222000022222222222200ffff2222222222000000000001dd1111111111dd11313131663131313
00000000000000000000000002222222000000000222222222222000022222222222200fff2222222222200000000000111111111111111111dd1d1dd1d1dd11
0000000000000000000000000000000000000000000000000000000000000000000000ffff000000000000000000000011111111111111111ddd1d1dd1d1ddd1
0000000000000000000000000000000000000000000000000000000000000000000000fff0000000000000000000000011111111111111111ddd1d1dd1d1ddd1
000000000000000000000000000000000000000000000000000000000000000000000ffff00000000000000000000000111111111111111111dd1d1dd1d1dd11
000000000000000000000000000000000000000000000000000000000000000000000fff00000000000000000000000011111111111111111111111111111111
00000000000000000000000000000000000000000000000000000000000000000000ffff00000000000000000000000011111111111111111113111dd1113111
00000000000000000000000000000000000000000000000000000000000000000000fff000000000000000000000000011111111111111111131111dd1111311
0000000000000000000000000000000000000000000000000000000000000000000ffff00000000000000000000000001111111111111111d1111dd11dd1111d
000000000000000000000000000000000000000000000000000000000000000000ffff000000000000000000000000001111111111111111d1111dd11dd1111d
000000000000000000000000000000000000000000000000000000000000000000ffff0000000000000000000000000011111111111111111111111dd1111111
00000000000000000000000000000000000000000000000000000000000000000ffff0000000000000000000000000001111111111111111d1dd111dd111dd1d
0000000000000000000000000000000000000000000000000000000000000000fffff0000000000000000000000000001111111111111111d1ddd111111ddd1d
0000000000000000000000000000000000000000000000000000000000000000ffff00000000000000000000000000001111111111111111d1ddd113311ddd1d
0000000000000000000000000000000000000000000000000000000000000000ffff00000000000000000000000000001111111111111111d1dd11133111dd1d
00000000000000000000000000000000000000000000000000000000000000000ff0000000000000000000000000000011111111111111111111111111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111dd1111111
__sfx__
01010000113501b3401a3351a3251a3151a3150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000012140121301612016125165001650013700183001a4001a4001b4001c400112000f3000e3000f0000b000000000000000000000000000000000000000000000000000000000000000000000000000000
010a0000240301e3201e3250030000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a0000150401a7401a7450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600002403130025000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000e5341c300250511175400000135450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01090000150301a0451d0452204525055270552a0552c0552f0553105534055000000000037000370000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600001473023730001001800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600001503117031190411b0411e041240512d05136051000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010900001e4401c4401a4401a4301943018430174301643015430144201342012420114200f4200e420175001b500185001b5001d5001d5001b5001b500000001b5001b500000000000000000000000000000000
011e00001f5301f5221f51222530235312b5322953026530275302752227512265302753027522225302252024530245222451224512000002452500000275250000026525000000000000000000000000000000
011e00000f725037251895005725077250a72518950077250c7250a725189500772500100007251895003725087250070518950077250872500005189500000508725077251895005725051000a725189500e725
011e0000275302752227512295302a5302953027530295302553025522255121e5301e52220530205222051222530235302a53029531275302553025522255122551225512000000000000000000000000000000
00120000030530554505535050351162505535050550554503053055450552505045116250551505045055150305301545011250154511625010450d5220153503043035350f5250304511635035450f0450f525
01120000115351f0251103527524145351f0251103527525115351f0251103527524145351f0251103527525115351f0251103522524145351f0251103522525115351f0251103525524145351f0251103525525
00120000030000550003053050451163505535050550554503033055250854508045116250854203045035250304301535011250154511635010250d5120153503053035450f5350304511625035450304503525
001200000d5351f0251103518525145351f02211034185250d5351f0251103518525145351f02211035185210f5351f0251103518525145351f022115341f0250f5351f0251103518525145351f022115321f024
001200000305301545011250154511625010350d522015350305301545011250155511625010450d5220153503053035450f525030551162503545030250353203053035450f5220305511625035420f02503535
0101000016714177100c7201a7301c7301f73021730237301a7301d7302273036720357103f71526700287002a7002d70032700367003c7003f70025700277002a7002c7002e7003270035700397003d70000700
010300001502515115151252420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600003013100000301310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010700001f61413614000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01070000180361b0261f0262201517100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
011200001153524725115351b5441453524025115351b5251153524025115351a5441453524725115351a525105351f7251053519544145351f0251053519525105351f0251053518544145351f7251053518525
01120000030000550003053050451163505525050450552503053055450553505045116250551505045055350305301545011350154511625010250d54201535030530c5450c5350c025116350c535180450c525
011200001153524025115351b5241453524725115351b5251153524725115351a5241453524025115351a5251353522025135351d5241453522725135351d5250f5351f7250f53516524145351f7250f53516525
010a00000e0500e0500e0550000000000000010e0500e0500e0551900000000000002605026050260502605026050260502605000000000000000000000000000000000000000000000000000000000000000000
010100000c2540d2500d2500e2500f250102401124013240162401e23026230272300e20000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200
0101000025250212501d2501b2501924017240152401424013230112350f2350f2350e60000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200
0006000004672046720567206672066720767207672146421564216642166321763218632196321a6221a6221b6221c6221e622216121f6122161222615000050000000000000000000000000000000000000000
011200001c5511c551000000000013552135521355013550000000000000000131001c5511c55000000000001d5521d550000000000015552155521555015550000000000000000000001d5521d5521d5501d550
011200001f5511f5501c5501c55018552185521855218552185501855018550185501f5511f5501f5501f5502155221552215501f55021552215502155023550245522455224550235502155221552215501f550
011200000013000130000000000000130001300000000000001300013000000000000013000130000000000002130021300000000000021300213000000000000213002130000000000002130021300000000000
011200000413004130000000000004130041300000000000041300413000000000000413004130000000000005130051300000000000051300513000000000000513005130000000000005130051300000000000
000700000000016031160142210400000000000000000000000001b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0110000000000107501c7600400000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011400001a550000000b555000001a550000000b555000001a550000000b555000001a550000000b555000001a550000000b555000001a550000000b555000001a550000000b555000001a550000000b55500000
010c00001a550000000b555000001a550000000b555000001a550000000b555000001a550000000b555000001a550000000b555000001a550000000b555000001a550000000b555000001a550000000b55500000
__music__
01 0a0b4344
02 0b0c4344
00 41424344
00 0d424344
01 0e0f4344
00 10114344
00 17184344
00 10114344
02 18194344
00 41424344
01 1e214344
02 1f214344

