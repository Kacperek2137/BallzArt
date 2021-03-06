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


	-- high score
	cartdata("lkg_picomaki")

	hs = {}
	loadhs()
	sort_high_score()


	scene = "menu"
	-- game scenes:
	-- menu
	-- game
	-- gameover

	coin = 0

	music(1)

	--reseths()

end

function _update60()

	if scene == "menu" then
		-- x to start the game
		if btnp(5) then
			scene = "game"
			music(4,5000)
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
		end

		if btn(4) then
			game_vars_fresh_start()
			scene = "menu"
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
			new_order()
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
		outline("press ❎ to start",33,80,8,1)
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
		for i=1,#hs do
			-- if we have a match
			if hs[i] == player_score then

				if i == 1 then
					print("first",22,70 -y_offset,10)
					is_on_highscore = true
					
				end

				if i == 2 then
					print("second",22,70 -y_offset,6)
					is_on_highscore = true
				end

				if i == 3 then
					print("third",22,70 -y_offset,9)
					is_on_highscore = true
				end

				if i == 4 then
					print("fourth",20,70 -y_offset,7)
					is_on_highscore = true
				end

				if i == 5 then
					print("fifth",32,70 -y_offset,7)
					is_on_highscore = true
				end



			end

				if is_on_highscore == true then

						print("on the highscore", 56, 70 -y_offset,7)
				end

				if is_on_highscore == false then
					print("not", 30,70 -y_offset,7)
					print("on the highscore", 46, 70 -y_offset,7)

				end
		end

		print("score:",42,60 -y_offset,7)
		--print(player_score,70,60,7)
		print(player_score,70,60 -y_offset,7)
		outline("❎ restart",42,85 -y_offset,8,1)
		outline("🅾️ menu",47,95 -y_offset,1,8)

		spr(ing_matrix_tic,20,50 -y_offset)
		spr(ing_matrix_tic,101,50 -y_offset)

		if ing_matrix_tic >= 5 then
			ing_matrix_tic = 1
		end
		-- TODO
		-- spritey skわ🐱adnikれはw
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
				if rnd(1) >= 0.7 then
					top_type = 5
					bottom_type = 5
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
						
					end

				end


			--	add_ing(1,3,flr(rnd(5) + 1),"TOP")
			--	add_ing(115,101,flr(rnd(5) + 1),"BOTTOM")
			add_ing(1,3,top_type,"TOP")
			add_ing(115,101,bottom_type,"BOTTOM")
			tic = 0
			sfx(7)
				-- bomb comming
			--end
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

	categories = {"code", "ux/ui", "degign", "vfx", "graphics", "sfx", "music", "mentoring"}
	authors = {"gabriel", "gabriel", "gabriel,kacper", "gabriel", "ola", "kacper,kornel","kacper,kornel","konrad,jedrzej,kamil"}
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
__gfx__
0000000000077000015113b00000000000fee700000890009222222222222e313131313131313100313131313131313100000000000000000000000000000000
00000000007af7001001000100faaaa90fef7e800000a0002f8f8f89898e82131313131313131310131313131313131300000000000000000000000000000000
0070070009ff79805010005b0aafaa9808f7ffe0005dd60028f8989898e8e2010101010101010131010101010101010131313131313131310000000000000000
000770000fa7f7f015010503f9944940028f8f800555dd602f8f89898e8e82111111111111111013111111111111111113131313131313130000000000000000
000770007a6777f71010000b0f9aaaa00288e8f005555d5028989898e8e8e2111111111111111131111111111111111111111111111111110000000000000000
0070070077767779110305039af99a9802e88ee00e5555502f898888888882111111111111111013111111111111111111111111111111110000000000000000
0000000087f77f6920305003004449800228888002d5552028989888888882111111111111111131111111111111111111111111111111110000000000000000
0000000008aff98002131330000000000022e8000025520029898888888882111111111111111013111111111111111111111111111111110000000000000000
00000000000770000333b3b000000000002ff8000000000028989888888882111111111111111131111111111111111111111111111111110000000000000000
000000000077770035555b5b0000000002ff7f8000000000298e8888888882111111111111111013111111111111111111111111111111110000000000000000
0000000007f777a0355355b309999aaf088ff8800000000028e8e888888882111111111111111131111111111111111111111111111111110000000000000000
00000000077777705555b55b9aaaaaa908e88e80000000002e8e8888888882111111111111111013111111111111111111111111111111110000000000000000
000000007f777f7a55555353aaa9999a08e88e800000000028e8e888888882131313111111111131131313131313131311111111111111110000000000000000
00000000777777f7555555539a9aaa4008e88e8000000000e2222222222228313131111111111013313131313131313101010101010101010000000000000000
0000000057777f753555555b00000000028e88800000000013111111111131000013111111111131000000000000000013131313131313130000000000000000
0000000005ffff500b55533000000000002888000000000031011111111113000031111111111013000000000000000031313131313131310000000000000000
00000000f6f77f6f00000000000000009a9ff9a90000000013111111111131000000000000000000131111111111310000131111111111310000000000000000
00000000ff7ff7ff007ff94000799f0099f99f990000000031011111111113000000000000000000310111111111130000311111111110130000000000000000
00000000f7f77f7f07f97f9207ff99f0ef9ff9f90000000013111111111131310000000000000000131111111111310000131111111111310000000000000000
00000000ff7ff7ff797f99fe7f99f99f99f99f9e0000000031011111111113130000000000000000310111111111130000311111111110130000000000000000
00000000f6f77f6ff999fef899f99fef9a9ff9a90000000013111111111111110000000000000000131111111111310000131111111111310000000000000000
00000000ff7ff7ff7f9efe20e99f9fe499f99f990000000031011111111111110000000000000000310111111111130000311111111110130000000000000000
00000000f7f77f7f09fe24000eefee40ef9ff9f90000000013111111111111110000000000000000131111111111310000131111111111310000000000000000
00000000ff7ff7ff000000000000000099f99f9e0000000031011111111111110000000000000000310111111111130000311111111110130000000000000000
00000000000000000000b00000000000000ee0000000000013111111111111110000000000000000131111111111310000131111111111310000000000000000
00000000000f700000003b0000000000008f7e000000000031011111111111110000000000000000310111111111130000311111111110130000000000000000
0000000000777a0000b0033000afaa9900e77e000000000013111111111111110000000000000000131111111111310000131111111111310000000000000000
000000000777f770b0030b300a4999a0008f7e000000000031011111111111110000000000000000310111111111130000311111111110130000000000000000
0000000077a777a703333300a9994a0000eeee000000000013111111111111110000000000000000131111111111310000131111111111310000000000000000
00000000a7af7af70b33330000000000008eee000000000031010101010101010000000000000000310111111111130000311111111110130000000000000000
00000000077777700000033000000000000ee0000000000003131313131313130000000000000000131111111111310000131111111111310000000000000000
0000000000ffff00000000b000000000000000000000000000313131313131310000000000000000310111111111130000311111111110130000000000000000
00000000000011111111000000002222222200000000005555500000000000000000000000000000000000000000055500000000000000000000000000000000
0000000000011999e821100000022fa99982200000000557c3500000000000000000000000000000000000000000577750000000000000000000000000000000
00000000000199e8888210000002fa9999982000000055abb3500000000000000000000000000033330000000005749775000000009999900000000000000000
0000000000019e21188210000002f9822a98200000055abbb35000000000000000000000000003798930000000059b939500000000a99a550000000000000000
000000000001921118821000000298222a9820000005acbbb3500000000055555000000000000798e77000000005738755000000007999599900000000000000
00000000000111119882100000022222f99220000005cb5cb350000000057777750000000000037978300000000055555500000000777559a900000000000000
000000000000111e8821100000000022998200000005555bb3500000005778897750000000000333333000000000055550000000000775777700000000000000
0000000000000118882110000000002f992200000000005bb3500000005778997750000000000033330000000000000000080000000005777700000000000000
00000000000000118882100000000229982000000000005bb3500000005577777550000000000000000000000000000000888800000000000000000000000000
000000000000110118821000000002f9922000000000005bb3500000005555555550000000000000000000000000000888880000000000000007700000000000
00000000000111111e82100000000299820000000000005bb35000000055555555500000000000ffff0000000000008888870000000000000077770000000000
00000000000199119882100000022f99222220000000005bb3500000000555555550000000000f7ea7f000000000088887770000000000000777777000000000
000000000001e888888210000002aa9822f820000000005bb350000000005555550000000000077a9a7000000000887777000000000000007777777700000000
0000000000011388882210000002a999999820000000005cb3500000000000000000000000000f9779f000000000077770000000000000007755557700000000
00000000000012222221100000022c99998220000000005933500000000000000000000000000ffffff000000000000000000000000000000755557000000000
000000000000111111110000000022222222000000000055555000000000000000000000000000ffff0000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099900000077f700000000
000000000000000000000000000000000000000000000000000000000000000000000000000099f0000000000000000000000000009999a00007777770000000
0000000000000000000000000000000000000000000000000000000000000000000000000099fff0000000000000000000000000097579900077777770000000
000000000000000000000000000000000000000000000000000000000000000000000000ffffff00000000000000000000000000095b799007959777f0000000
00000000000000000000000000000000000000000000000000000000000000000000000fffff00000000000000000000000000000975790007f99f7770000000
000000000000000000000000000000000000000000000000000000000000000000000ffffff00000000000000000000ff00000000099a0000775f97700000000
0000000000000000000000000000000000000000000000000000000000000000000f99fff00000000000000000000ffff0000000000000000007770000000000
000000000000000000000000000000000000000000000000000000000000000000999ff000000000000000000000f9ff00000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000099fff0000000000000000000000f9ff00000000000000000000000000000000
00000000000000000000000000888888888888888008888800888888888880099fff00088888880000000000000f99ff00000000000000000000000000000000
000000000000000000000000088888888888888888888888008888888888880fff0008888888888800000000000f9ff000000000000000000000000000000000
0000000000000000000000000888faaaa999999f888ffae8088ffa999999e88f0008888b31313b888800000000099ff000000000000000000000000000000000
000000000000000000000000088ffaaa999999999e8fa928888fa9999999928008888b1313131313888800000009ff0000000000000000000000000000000000
000000000000000000000000088aaf9999999f99928a992888f9999999a99280888b313fff7fff31318880000009ff0000000000000000000000000000000000
000000000000000000000000088aa9e8888888a9928999288fa992888899928888b31fff77ff77f713188800009ff00000000000000000000000000000000000
000000000000000000000000088aa9288888889992899928899a2888889992888b3fffe7ff77ffff7f3b8800009ff00000000000000000000000000000000000
000000000000000000000000088a99280000889992899928899ffff088999288b3fffaffffff7f7e77f3188000ff000000000000000000000000000000000000
0000000000000000000000000889992800008899928999288fffff0088a9928831f77ff7fabaaf7ffff138800fff000000000000000000000000000000000000
0000000000000000000000000889992800088899c3899928ffff280088fac28b177ffffaababa3ff7f7f13880fff000000000000000000000000000000000000
0000000000000000000000000889992800888a9928899ffffff28800888888813fff7fabaabaa33f8f7f31880ff0000000000000000000000000000000000000
000000000000000000000000088999280888a9992889fffff9928000888888b3f7af79babaaab844fffff3b88ff0000000000000000000000000000000000000
00000000000000000000000008899928888a999288fffff899928000000088317ff7f99999ab4444f7f771388ff0000000000000000000000000000000000000
0000000000000000000000000889992888a999288ffff92899928000000088137ef7999ff994444847fff3188ff0000000000000000000000000000000000000
00000000000000000000000008899a999999928ffff9992899928000000088317f7fe9f9999484444ff731388f00000000000000000000000000000000000000
000000000000000000000000088999999999288ff88999289992800000008813ff7f8e99ff98448487f7f318ff00000000000000000000000000000000000000
0000000000000000000000000889999999c388f0088999289992800000008831f7fefe9f99944844f7fff138f000000000000000000000000000000000000000
000000000000000000000000088999e88888800008899928f992800000008813f7fff8e999ff4444fff7f3b8f000000000000000000000000000000000000000
0000000000000000000000000889992ff88800000889992889992800088888813ff7ff8e9f99484f7aff318ff000000000000000000000000000000000000000
00000000000000000000000008899928ff00000008899928899928008888888b1f8ffffeeee844ffff8f138f0000000000000000000000000000000000000000
0000000000000000000000000889992800000000088999288999280088fa928831fa7f8ff888ff77fff138ff0000000000000000000000000000000000000000
0000000000000000000000000889992800000000088999288f99288888a9928813fffff77fffffef7f7318f00000000000000000000000000000000000000000
000000000000000000000000ff8999280000000008899928889992888a99c3888b3fff7fff7f77ff713b8ff00000000000000000000000000000000000000000
0000000000000000000000fff8899928000000000889992888a999999999288888131ffffe7fff7f13188f000000000000000000000000000000000000000000
00000000000000000000fffff88a99b800000000088a99288888999999928800888b3137fff7ff3131888f000000000000000000000000000000000000000000
00000000000000000009ff00088fac3800000000088fac380888a99999c38000088883131313131b8888ff000000000000000000000000000000000000000000
00000000000000000f99f00008888888000000000888888800888888888800000008888b313131888800f0000000000000000000000000000000000000000000
0000000000000000f9900000088888880000000008888888000888888888800888888888888888888888f0000000000000000000000000000000000000000000
00000000000000ff9900000008888888000000000008888800008888888888888888808888888888888ff0000000000000000000000000000000000000000000
000000000000ff9900000000088ffae800000000088ffae800088ffa99999b88ffae800088ffae8ffaef00000000000000000000000000000000000000000000
0000000000fff99000000000088fa92888000008888fa92800088fa999999928fa92800088fa928fa92f00000000000000000000000000000000000000000000
000000000ff0000000000000088a99928880008888fa992800888a9999a99928a992800088a9928a992800000000000000000000000000000000000000000000
00000000f00000000000000008899999a2800088fa9999280088fa9e88fa99289992800088999289992800000000000000000000000000000000000000000000
00000fff00000000000000000889999992800088a99999280088999288899928a992800088999289992800000000000000000000000000000000000000000000
0000f00000000000000000000889999992800088999999280888a992888999289992800888a99289992800000000000000000000000000000000000000000000
000000000000000000000000088999999280008899999928088f999288899928999280888f992889992800000000000000000000000000000000000000000000
000000000000000000000000088999999280008899999928088a99928889992899928888a9992889992800000000000000000000000000000000000000000000
000000000000000000000000088999a99928088999a99928088a9928888999289992888f99928889992800000000000000000000000000000000000000000000
00000000000000000000000008899f29992808899a2999280889992888899928999288f999288889992800000000000000000000000000003166363661616631
0000000000000000000000000889992a9992889999299928888a99288889992899a9999992880889992800000000000000000000000000001666161663636663
0000000000000000000000000889992fa99288999929992888f99a99999999289999999928800889992800000000000000000000000000003c663636616166c1
000000000000000000000000088999288a9929999289992888a999999999992899999999280008899928000000000000000000000000000013cc1c1cc3c3cc13
000000000000000000000000088999288a999999c389992888999999999999289992899928000889992800000000000000000000000000003131313131313131
000000000000000000000000088999288fa999992889992888a992888889992899928f9992800889992800000000000000000000000000001316131663136313
0000000000000000000000000889992888a99992888999288f99928888899928999288999280ff899928000000000000000000000000000031c1313cc1313c31
00000000000000000000000008899928888a9928888999288a99288008899928999288a99928ff89992800000000000000000000000000006313166316631316
00000000000000000000000008899928088fa928088999288a99280008899928999288899928f88999280000000000000000000000000000c13136c13c613136
00000000000000000000000008899928088888880889992889992800088999289992888f999fff89992800000000000000000000000000001313131663131313
0000000000000000000000000889992800888880088999288a9928000889992899928088999fff89992800000000000000000000000000006166313cc1316636
000000000000000000000000088999280000000008899928f99928000889992899928088a9fff889992800000000000000000000000000006366631313166616
000000000000000000000000088999280000000008899928a9928800088999289992800889fff889992800000000000000000000000000006166c136613c6636
000000000000000000000000088a992800000000088a9928a9928000088a9928a99280088aff928a99280000000000000000000000000000c36c131cc313c61c
000000000000000000000000088fac3800000000088fac3899c38000088fac38fac3800088ffc38fac3800000000000000000000000000003131313131313131
0000000000000000000000000888888800000000088888888888800008888888888880008fff8888888800000000000000000000000000001313131663131313
0000000000000000000000000888888800000000088888888888800008888888888880000ff888888888000000000000000000000000000011dd1d1dd1d1dd11
000000000000000000000000000000000000000000000000000000000000000000000000fff00000000000000000000000000000000000001ddd1d1dd1d1ddd1
000000000000000000000000000000000000000000000000000000000000000000000000ff000000000000000000000000000000000000001ddd1d1dd1d1ddd1
000000000000000000000000000000000000000000000000000000000000000000000000ff0000000000000000000000000000000000000011dd1d1dd1d1dd11
00000000000000000000000000000000000000000000000000000000000000000000000ff9000000000000000000000000000000000000001111111111111111
00000000000000000000000000000000000000000000000000000000000000000000000f90000000000000000000000000000000000000001113111dd1113111
00000000000000000000000000000000000000000000000000000000000000000000000f90000000000000000000000000000000000000001131111dd1111311
0000000000000000000000000000000000000000000000000000000000000000000000f99000000000000000000000000000000000000000d1111dd11dd1111d
0000000000000000000000000000000000000000000000000000000000000000000000f90000000000000000000000000000000000000000d1111dd11dd1111d
000000000000000000000000000000000000000000000000000000000000000000000ff000000000000000000000000000000000000000001111111dd1111111
000000000000000000000000000000000000000000000000000000000000000000000f000000000000000000000000000000000000000000d1dd111dd111dd1d
00000000000000000000000000000000000000000000000000000000000000000000f0000000000000000000000000000000000000000000d1ddd111111ddd1d
00000000000000000000000000000000000000000000000000000000000000000000f0000000000000000000000000000000000000000000d1ddd113311ddd1d
0000000000000000000000000000000000000000000000000000000000000000000f00000000000000000000000000000000000000000000d1dd11133111dd1d
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111dd1111111
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099f0000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000099fff0000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffff00000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000fffff0000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffff00000000000000000000f00000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000f99fff00000000000000000000fff00000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000999ff000000000000000000000f9ff00000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000099fff0000000000000000000000f9ff00000000000000000000
00000000000000000000000000000000000000888888888888888008888800888888888880099fff00088888880000000000000f99ff00000000000000000000
000000000000000000000000000000000000088888888888888888888888008888888888880fff0008888888888800000000000f9ff000000000000000000000
0000000000000000000000000000000000000888faaaa999999f888ffae8088ffa999999e88f0008888b31313b888800000000099ff000000000000000000000
000000000000000000000000000000000000088ffaaa999999999e8fa928888fa9999999928008888b1313131313888800000009ff0000000000000000000000
000000000000000000000000000000000000088aaf9999999f99928a992888f9999999a99280888b313fff7fff31318880000009ff0000000000000000000000
000000000000000000000000000000000000088aa9e8888888a9928999288fa992888899928888b31fff77ff77f713188800009ff00000000000000000000000
000000000000000000000000000000000000088aa9288888889992899928899a2888889992888b3fffe7ff77ffff7f3b8800009ff00000000000000000000000
000000000000000000000000000000000000088a99280000889992899928899ffff088999288b3fffaffffff7f7e77f3188000ff000000000000000000000000
0000000000000000000000000000000000000889992800008899928999288fffff0088a9928831f77ff7fabaaf7ffff138800fff000000000000000000000000
0000000000000000000000000000000000000889992800088899c3899928ffff280088fac28b177ffffaababa3ff7f7f13880fff000000000000000000000000
3166363661616631316636366161663131663889992866888a9928899ffffff28866888888813fff7fabaabaa33f8f7f31883ff6616166313166363661616631
166616166363666316661616636366631666188999286888a9992889fffff9928666888888b3f7af79babaaab844fffff3b88ff6636366631666161663636663
3c663636616166c13c663636616166c13c6638899928888a999288fffff899928c66363688317ff7f99999ab4444f7f771388ff6616166c13c663636616166c1
13cc1c1cc3c3cc1313cc1c1cc3c3cc1313cc1889992888a999288ffff928999283cc1c1c88137ef7999ff994444847fff3188ffcc3c3cc1313cc1c1cc3c3cc13
31313131313131313131313131313131313138899a999999928ffff9992899928131313188317f7fe9f9999484444ff731388f31313131313131313131313131
131613166313631313161316631363131316188999999999288ff88999289992831613168813ff7f8e99ff98448487f7f318ff16631363131316131663136313
31c1313cc1313c3131c1313cc1313c3131c13889999999c388f138899928999281c1313c8831f7fefe9f99944844f7fff138f13cc1313c3131c1313cc1313c31
631316631663131663131663166313166313188999e88888831318899928f992831316638813f7fff8e999ff4444fff7f3b8f663166313166313166316631316
c13136c13c613136c13136c13c613136c1313889992ff888c1313889992889992831388888813ff7ff8e9f99484f7aff318ff6c13c613136c13136c13c613136
13131316631313131313131663131313131318899928ff13131318899928899928138888888b1f8ffffeeee844ffff8f138f1316631313131313131663131313
6166313cc13166366166313cc131663661663889992866366166388999288999286688fa928831fa7f8ff888ff77fff138ff313cc13166366166313cc1316636
6366631313166616636663131316661663666889992866166366688999288f99288888a9928813fffff77fffffef7f7318f66313131666166366631313166616
6166c136613c66366166c136613c66366166ff89992866366166c8899928889992888a99c3888b3fff7fff7f77ff713b8ff6c136613c66366166c136613c6636
c36c131cc313c61cc36c131cc313c61cc3fff8899928c61cc36c1889992888a999999999288888131ffffe7fff7f13188f6c131cc313c61cc36c131cc313c61c
31313131313131313131313131313131fffff88a99b831313131388a99288888999999928831888b3137fff7ff3131888f313131313131313131313131313131
13131316631313131313131663131319ff13188fac3813131313188fac381888a99999c38313188883131313131b8888ff131316631313131313131663131313
31663636616166313166363661616f99f16638888888663131663888888866888888888861616638888b313131888831f1663636616166313166363661616631
1666161663636663166616166363f9931666188888886663166618888888666888888888836888888888888888888888f6661616636366631666161663636663
3c663636616166c13c66363661ff99c13c663888888866c13c663638888866c188888888888888888c8888888888888ffc663636616166c13c663636616166c1
13cc1c1cc3c3cc1313cc1c1cff99cc1313cc188ffae8cc1313cc188ffae8cc188ffa99999b88ffae83cc88ffae8ffaef13cc1c1cc3c3cc1313cc1c1cc3c3cc13
3131313131313131313131fff99131313131388fa92888313138888fa92831388fa999999928fa92813188fa928fa92f31313131313131313131313131313131
131613166313631313161ff6631363131316188a99928883138888fa992863888a9999a99928a992831688a9928a992813161316631363131316131663136313
31c1313cc1313c3131c1f13cc1313c3131c138899999a2813188fa9999283c88fa9e88fa9928999281c188999289992831c1313cc1313c3131c1313cc1313c31
63131663166313166fff16631663131663131889999992866388a99999281388999288899928a992831388999289992863131663166313166313166316631316
c13136c13c613136f13136c13c613136c131388999999286c188999999283888a992888999289992813888a992899928c13136c13c613136c13136c13c613136
131313166313131313131316631313131313188999999283138899999928188f999288899928999283888f992889992813131316631313131313131663131313
6166313cc13166366166313cc13166366166388999999286618899999928688a99928889992899928888a999288999286166313cc13166366166313cc1316636
636663131316661663666313131666166366688999a99928688999a99928688a9928888999289992888f99928889992863666313131666166366631313166616
6166c136613c66366166c136613c66366166c8899f29992868899a2999286889992888899928999288f99928888999286166c136613c66366166c136613c6636
c36c131cc313c61cc36c131cc313c61cc36c1889992a9992889999299928888a99288889992899a999999288c8899928c36c131cc313c61cc36c131cc313c61c
3131313131313131313131313131313131313889992fa99288999929992888f99a99999999289999999928813889992831313131313131313131313131313131
131313166313131313131316631313131313188999288a9929999289992888a99999999999289999999928166889992813131316631313131313131663131313
000000000000000000000000000000000000088999288a999999c389992888999999999999289992899928000889992800000000000000000000000000000000
000000000000000000000000000000000000088999288fa999992889992888a992888889992899928f9992800889992800000000000000000000000000000000
0000000000000000000000000000000000000889992888a99992888999288f99928888899928999288999280ff89992800000000000000000000000000000000
00000000000000000000000000000000000008899928888a9928888999288a99288008899928999288a99928ff89992800000000000000000000000000000000
00000000000000000000000000000000000008899928088fa928088999288a99280008899928999288899928f889992800000000000000000000000000000000
00000000000000000000000000000000000008899928088888880889992889992800088999289992888f999fff89992800000000000000000000000000000000
0000000000000000000000000000000000000889992800888880088999288a9928000889992899928088999fff89992800000000000000000000000000000000
000000000000000000000000000000000000088999280000000008899928f99928000889992899928088a9fff889992800000000000000000000000000000000
000000000000000000000000000000000000088999280000000008899928a9928800088999289992800889fff889992800000000000000000000000000000000
000000000000000000000000000000000000088a992800000000088a9928a9928000088a9928a99280088aff928a992800000000000000000000000000000000
000000000000000000000000000000000000088fac3800000000088fac3899c38000088fac38fac3800088ffc38fac3800000000000000000000000000000000
0000000000000000000000000000000000000888888800000000088888888888800008888888888880008fff8888888800000000000000000000000000000000
0000000000000000000000000000000000000888888800000000088888888888800008888888888880000ff88888888800000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000fff00000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000ff9000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000f90000000000000000000000000000000000000000000
00000000000000000000000000000000088888888888888888888800008888888000088888888800008888888888888888888800000000000000000000000000
00000000000000000000000000000000081118111811188118811800088111118800081118811800088118111811181118111800000000000000000000000000
00000000000000000000000000000000081818181818881888188800081181811800088188181800081888818818181818818800000000000000000000000000
00000000000000000000000000000000081118118811881118111800081118111800008188181800081118818811181188818000000000000000000000000000
00000000000000000000000000000000081888181818888818881800081181811800008188181800088818818818181818818000000000000000000000000000
00000000000000000000000000000000081808181811181188118800088111118800008188118800f81188818818181818818000000000000000000000000000
00000000000000000000000000000000088808888888888888888000008888888000008888888000f88880888888888888888000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000f000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000001111111000011111111111111111111111111111111111110000000000000000000000000000000000
00000000000000000000000000000000000000000000011888881100018181888118818181188118811881888188810000000000000000000000000000000000
00000000000000000000000000000000000000000000018811888100018181181181118181811181118181818181110000000000000000000000000000000000
00000000000000000000000000000000000000000000018811188100018881181181118881888181018181881188100000000000000000000000000000000000
00000000000000000000000000000000000000000000018811888100018181181181818181118181118181818181110000000000000000000000000000000000
00000000000000000000000000000000000000000000011888881100018181888188818181881118818811818188810000000000000000000000000000000000
00000000000000000000000000000000000000000000001111111000011111111111111111111011111111111111110000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000001111111000001111111111111111111111111111000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000011888881100011881888188818811888188811881000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000018881188100018111818181118181181118118111000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000018811188100018101881188118181181018118881000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000018881188100018111818181118181181118111181000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000011888881100011881818188818881888118118811000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000001111111000001111111111111111111111111110000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__sfx__
01010000113501b3401a3351a3251a3151a3150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000012140121301612016125165001650013700183001a4001a4001b4001c400112000f3000e3000f0000b000000000000000000000000000000000000000000000000000000000000000000000000000000
010a0000240301e3201e3250030000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a0000150401a7401a7450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600002403130025000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000e5341c300250511175400000135450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01090000150301a0451d0452205525055270550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
001000000000016031160142210400000000000000000000000001b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

