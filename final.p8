pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init()
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
	ball_x = 37
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

	-- game start sfx
	sfx(26)

	music(4,5000)

	scene = "menu"
	-- game scenes:
	-- menu
	-- game
	-- gameover



end

function _update60()

	if scene == "menu" then
		-- x to start the game
		if btnp(5) then
			scene = "game"
		end

		-- moving between rooms in the menu scene
		-- we start in the room 0
		
		-- right
		if btn(1) then
			if cameramoving == false and (camera_active_room == 0 or camera_active_room == -1) then
				cameramoving = true
				camera_direction = 1
			end
		end

		-- left
		if btn(0) then
			if cameramoving == false and (camera_active_room == 0 or camera_active_room == 1) then
				cameramoving = true
				camera_direction = -1
			end
		end

		update_camera()

			
	end


	if scene == "gameover" then

	end

	if scene == "game" then


		--debug
		debug = ''


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
			spawnboom(50,50)
			outline_col += 1
			-- debug
			if outline_col > 15 then
				outline_col = 0
			end
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

		-- target movement
		target_x += target_dx
		target_y += target_dy

		-- top right corner hit
		if target_x > 120 and target_y < 120 then
			target_dx = 0
			target_dy = target_dm
		end

		-- bottom right corner hit
		if target_x > 120 and target_y > 120 then
			target_dx = -target_dm
			target_dy = 0
		end


		-- bottom left corner hit
		if target_x < 7 and target_y > 120 then
			target_dx = 0
			target_dy = -target_dm
		end

		-- top left corner hit
		if target_x < 7 and target_y < 7 then
			target_dx = target_dm
			target_dy = 0
		end


		-- sectarget movement

		sectarget_x += sectarget_dx
		sectarget_y += sectarget_dy

		-- top right corner hit
		if sectarget_x > 120 and sectarget_y < 120 then
			sectarget_dx = 0
			sectarget_dy = sectarget_dm
		end

		-- bottom right corner hit
		if sectarget_x > 120 and sectarget_y > 120 then
			sectarget_dx = -sectarget_dm
			sectarget_dy = 0
		end


		-- bottom left corner hit
		if sectarget_x < 7 and sectarget_y > 120 then
			sectarget_dx = 0
			sectarget_dy = -sectarget_dm
		end

		-- top left corner hit
		if sectarget_x < 7 and sectarget_y < 7 then
			sectarget_dx = sectarget_dm
			sectarget_dy = 0
		end

		-- badtarget movement

		badtarget_x += badtarget_dx
		badtarget_y += badtarget_dy

		-- top right corner hit
		if badtarget_x > 120 and badtarget_y < 120 then
			badtarget_dx = 0
			badtarget_dy = badtarget_dm
		end

		-- bottom right corner hit
		if badtarget_x > 120 and badtarget_y > 120 then
			badtarget_dx = -badtarget_dm
			badtarget_dy = 0
		end


		-- bottom left corner hit
		if badtarget_x < 7 and badtarget_y > 120 then
			badtarget_dx = 0
			badtarget_dy = -badtarget_dm
		end

		-- top left corner hit
		if badtarget_x < 7 and badtarget_y < 7 then
			badtarget_dx = badtarget_dm
			badtarget_dy = 0
		end

		-- ball movement

		-- ball frosting 
		if ball_frosted == false then
			ball_x += ball_dx
			ball_y += ball_dy
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

		end

		if ball_x < 0 + ball_radius then
			ball_dx = ball_dm
			ball_dy = 1 * sign(ball_dy)
			-- wall collision sfx
			sfx(1)
		end

		if ball_y > 111 - ball_radius then
			ball_dy = -ball_dm
			ball_dx = 1 * sign(ball_dx)
			-- wall collision sfx
			sfx(1)
		end

		if ball_y < 0 + ball_radius then
			ball_dy = ball_dm
			ball_dx = 1 * sign(ball_dx)
			-- wall collision sfx
			sfx(1)
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
			if ball_box(pad_hitbox_x - 1, pad_hitbox_y + 1,1,pad_hitbox_height / 2) then
				ball_x -= abs(pad_dx + pad_dy)

			end

			-- right pad check
			if ball_box(pad_hitbox_x + pad_hitbox_width, pad_hitbox_y + 1,1,pad_hitbox_height / 2) then
				ball_x += abs(pad_dx + pad_dy)

			end


		end

		if pad_position == "vertical" then

			-- top pad check
			if ball_box(pad_hitbox_x + pad_hitbox_width /2, pad_hitbox_y - 1, pad_hitbox_width / 2, pad_hitbox_width / 2) then
				ball_y -= abs(pad_dx + pad_dy) * 2

			end


			-- bottom pad check
			if ball_box(pad_hitbox_x + pad_hitbox_width / 2, pad_hitbox_y + pad_hitbox_height, pad_hitbox_width / 2, pad_hitbox_width /2) then
				ball_y += abs(pad_dx + pad_dy)

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
		spr(129,35,20,8,7)
		print("press — to start",33,80,8)
		print("‘ highscore",45,90,8)
		print("‹ credits",45,100,8)
		--debug
		rectfill(128,0,256,127,9)
		rectfill(140,50,150,60,7)

		drawcredits()
		drawhighscore()
		-- cross pattern
		--spr(137,0,30,2,2)
		--spr(141,112,46,2,2)
		camera(camerax,0)

		--debug

		--debug
		pset(0,0,7)

	end

	if scene == "gameover" then
		cls()
		rectfill(0,0,127,127,0)
		spr(64,35,20,8,4)
		print("press x to start",33,80,8)
		print("game over",33,70,8)
	end

	if scene == "game" then

		cls()

		doshake()


		-- background from mockup
		drawbackground()


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




		-- ing system draw
		draw_ing()

		drawserveboxes()

		--debug
		
		-- draw the white frame on the explosion
		if whiteframe < 5 then
			rectfill(0,0,127,127,7)
			whiteframe += 1

		end
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
			-- dodaj przesuniÄ™cie na b Å¼eby symetria byÅ‚a gdzie indziej

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

			circfill(_p.x + rnd(5),_p.y + rnd(3),bigrange,col1)
			circfill(_p.x - rnd(5),_p.y,bigrange /2,col2)
			circfill(_p.x,_p.y + rnd(3),bigrange /4, col3)
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
	rect(13,13,114,98,4)





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



	print(debug,30,30,1)
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

	-- previously 120
	-- testing with 180
	if tic > 180 then

		--local top_type = flr(rnd(5) + 1)
		--local bottom_type = flr(rnd(5) + 1)


		if order_time > 0 then

			add_ing(1,3,flr(rnd(5) + 1),"TOP")
			add_ing(115,101,flr(rnd(5) + 1),"BOTTOM")
			--add_ing(1,3,top_type,"TOP")
			--add_ing(115,101,bottom_type,"BOTTOM")
			tic = 0
			--sfx of new ing added
			sfx(7)
			-- bomb comming
		end
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
			spr(33,13 + n * 8,13 + row * 8)
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
		spr(139,0 + n,30,2,2)
		spr(139,0 + n,46,2,2)
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

	pset(0 -xoffset,0,7)

	local n = 0
	for i=0,7 do
		spr(139,0 + n - xoffset,30,2,2)
		spr(139,0 + n - xoffset,46,2,2)
		n += 16
	end

	-- printing the credits
	print("credits", 50 - xoffset, 10,7)
end

function drawhighscore()
	local xoffset = -128

	pset(0 -xoffset,0,7)

	local n = 0
	for i=0,7 do
		spr(139,0 + n - xoffset,30,2,2)
		spr(139,0 + n - xoffset,46,2,2)
		n += 16
	end
end
__gfx__
0000000000077000015113b00000000000fee700000890007aaafaaa9a9999e9c3c3c3c3c3c3c3c0c3c3c3c3c3c3c3c300000000000000000000000000000000
00000000007af7001001000100faaaa90fef7e800000a000a99999999999999e1111111111111113111111111111111100000000000000000000000000000000
0070070009ff79805010005b0aafaa9808f7ffe0005dd600a97feeede8e82899111111111111111c111111111111111128282828282828280000000000000000
000770000fa7f7f015010503f9944940028f8f800555dd60a9ffe2d22222229e1111111111111113111111111111111111111111111111110000000000000000
000770007a6777f71010000b0f9aaaa00288e8f005555d50f9eef22222222299111111111111111c111111111111111111111111111111110000000000000000
0070070077767779110305039af99a9802e88ee00e555550a9e22f22222222991111111111111113111111111111111111111111111111110000000000000000
0000000087f77f6920305003004449800228888002d55520a9ed22222222229e111111111111111c111111111111111111111111111111110000000000000000
0000000008aff98002131330000000000022e80000255200a9d22222222222e91111111111111113111111111111111111111111111111110000000000000000
00000000000770000333b3b000000000002ff8000000000099e222222222229e111111111111111c111111111111111111111111111111110000000000000000
000000000077770035555b5b0000000002ff7f8000799f00a9822222222222981111111111111113111111111111111111111111111111110000000000000000
0000000007f777a0355355b309999aaf088ff88007ff99f099e222222222229e111111111111111c111111111111111111111111111111110000000000000000
00000000077777705555b55b9aaaaaa908e88e807f99f99f99822222222e2f981111111111111113111111111111111111111111111111110000000000000000
000000007f777f7a55555353aaa9999a08e88e8099f99fef992222222222ed94111111111111111c111111111111111111111111111111110000000000000000
00000000777777f7555555539a9aaa4008e88e80e99f9fe499822222222fdf988281111111111113828282828282828211111111111111110000000000000000
0000000057777f753555555b00000000028e88800eefee40e999999e99999998002111111111111c000000000000000011111111111111110000000000000000
0000000005ffff500b5553300000000000288800000000009e9e99e9e8e84884008111111111111300000000000000003c3c3c3c3c3c3c3c0000000000000000
00000000f6f77f6f00089000000000000000000000000000311111111111180000000000000000003111111111111800002111111111111c0000000000000000
00000000ff7ff7ff0000a000007ff9400000000000000000c1111111111112000000000000000000c11111111111120000811111111111130000000000000000
00000000f7f77f7f005dd60007f97f920000000000000000311111111111182800000000000000003111111111111800002111111111111c0000000000000000
00000000ff7ff7ff0555dd60797f99fe0000000000000000c1111111111111110000000000000000c11111111111120000811111111111130000000000000000
00000000f6f77f6f05555d50f999fef80000000000000000311111111111111100000000000000003111111111111800002111111111111c0000000000000000
00000000ff7ff7ff0e5555507f9efe200000000000000000c1111111111111110000000000000000c11111111111120000811111111111130000000000000000
00000000f7f77f7f02d5552009fe24000000000000000000311111111111111100000000000000003111111111111800002111111111111c0000000000000000
00000000ff7ff7ff00255200000000000000000000000000c1111111111111110000000000000000c11111111111120000811111111111130000000000000000
000000000000000000000000000000000000000000000000311111111111111100000000000000003111111111111800002111111111111c0000000000000000
000000000000000000000000000000000000000000000000c1111111111111110000000000000000c11111111111120000811111111111130000000000000000
000000000000000000000000000000000000000000000000311111111111111100000000000000003111111111111800002111111111111c0000000000000000
000000000000000000000000000000000000000000000000c1111111111111110000000000000000c11111111111120000811111111111130000000000000000
000000000000000000000000000000000000000000000000311111111111111100000000000000003111111111111800002111111111111c0000000000000000
000000000000000000000000000000000000000000000000c1111111111111110000000000000000c11111111111120000811111111111130000000000000000
000000000000000000000000000000000000000000000000311111111111111100000000000000003111111111111800002111111111111c0000000000000000
0000000000000000000000000000000000000000000000000c3c3c3c3c3c3c3c0000000000000000c11111111111120000811111111111130000000000000000
00000000000011111111000000002222222200000000005555500000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000011999e821100000022fa99982200000000557c3500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000199e8888210000002fa9999982000000055abb3500000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000019e21188210000002f9822a98200000055abbb3500000000000000000000000000000000000000000000000000000000000000000000000000000
000000000001921118821000000298222a9820000005acbbb3500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000111119882100000022222f99220000005cb5cb3500000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000111e8821100000000022998200000005555bb3500000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000118882110000000002f992200000000005bb3500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000118882100000000229982000000000005bb3500000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000110118821000000002f9922000000000005bb3500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000111111e82100000000299820000000000005bb3500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000199119882100000022f99222220000000005bb3500000000000000000000000000000000000000000000000000000000000000000000000000000
000000000001e888888210000002aa9822f820000000005bb3500000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000011388882210000002a999999820000000005cb3500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000012222221100000022c99998220000000005933500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000011111111000000002222222200000000005555500000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000088888888888888800888880088888888888000000000088888880000000000011dd1d1dd1d1dd113166363661616631d1ccdcdcc1c1ccd100000000
0000000088888888888888888888888008888888888880000000888888888880000000001ddd1d1dd1d1ddd116661616636366631ccc1c1ccdcdcccd00000000
00000000888a99999999999888a9928088a99999999288000088881111111888800000001ddd1d1dd1d1ddd13c663636616166c1dcccdcdcc1c1ccc100000000
0000000088a999999999999928999288889999999999280088881111111111188880000011dd1d1dd1d1dd1113cc1c1cc3c3cc131dcc1c1ccdcdcc1d00000000
000000008899999999999999289992888a99999999992808881111fffffff1111888000011111111111111113131313131313131d1d1d1d1d1d1d1d100000000
00000000889992888888899928999288a9992888899928888111fffffffffff1118880001113111dd111311113161316631363131d1c1d1ccd1dcd1d00000000
00000000889992888888899928999288999288888999288811fff8fffffffffff11880001131111dd111131131c1313cc1313c31d1c1d1dcc1d1dcd100000000
0000000088999280000889992899928899928008899928811fffafffffffff8fff118800d1111dd11dd1111d6313166316631316cd1d1ccd1ccd1d1c00000000
0000000088999280000889992899928899928008899928811fffffffabaaffffff118800d1111dd11dd1111dc13136c13c613136c1d1dcc1dcc1d1dc00000000
000000008899928000888999289992899992800889992811ffffffaababa3ffffff118801111111dd111111113131316631313131d1d1d1ccd1d1d1d00000000
000000008899928008889992889992899928800888888811fffffabaabaa33f8fff11880d1dd111dd111dd1d6166313cc1316636c1ccd1dcc1d1ccdc00000000
00000000889992808889999288999289992800088888811ffaff9babaaab844fffff1188d1ddd111111ddd1d6366631313166616cdcccd1d1d1ccc1c00000000
00000000889992888899992888999289992800000008811fffff99999ab4444fffff1188d1ddd113311ddd1d6166c136613c6636c1ccc1dcc1dcccdc00000000
00000000889992888999928888999289992800000008811f8ff999ff99444484ffff1188d1dd11133111dd1dc36c131cc313c61ccdcc1d1ccd1dcc1c00000000
00000000889999999999288088999289992800000008811ffffe9f9999484444fff1118811111111111111113131313131313131d1d1d1d1d1d1d1d100000000
00000000889999999992880088999289992800000008811ffff8e99ff9844848ffff11881111111dd111111113131316631313131d1d1d1ccd1d1d1d00000000
00000000889999999928800088999289992800000008811fff8fe9f99944844fffff118801dd0d0dd1d1dd010155050551515501000000000000000000000000
00000000889992888888000088999289992800000008811fffff8e999ff4444fffff11881ddd1d1dd0d0ddd01555151550505550000000000000000000000000
000000008899928888800000889992889992800088888811fffff8e9f99484ffaff1188002dd0d0dd1d1dd210255050551515521000000000000000000000000
000000008899928000000000889992889992800888888811f8ffffeeee844ffff8f1188010221212202022101022121220202210000000000000000000000000
0000000088999280000000008899928899928008899928811faff8ff888fffffff11880001010101010101010101010101010101000000000000000000000000
0000000088999280000000008899928899928888899928811ffffffffffff8ffff1188001013101dd01030101013101550103010000000000000000000000000
00000000889992800000000088999288899928889999288811ffffffffffffff1118800001310102210103010151010221010501000000000000000000000000
0000000088999280000000008899928889999999999288888111ffff8ffffff111888000d0101dd01dd0101d5010155015501015000000000000000000000000
000000008899928000000000889992888889999999288008881111fffffff1111888000021010d2102d101022101052102510102000000000000000000000000
0000000088999280000000008899928088899999992800008888111111111118888000001010101dd01010101010101550101010000000000000000000000000
000000008888888000000000888888800888888888800000008888111111188880000000d1dd01022101dd0d5155010221015505000000000000000000000000
000000008888888000000000888888800088888888880088888888888888888888800000d0ddd010101ddd1d5055501010155515000000000000000000000000
000000008888888000000000008888800008888888888888888808888888888888800000d1dd21033102dd0d5155210331025505000000000000000000000000
0000000088aa92800000000088aa92800088a9999999288a992800088a9928a99280000020221013301022122052101550102512000000000000000000000000
0000000088a992888000008888a99280008899999999928999280008899928999280000001010101010101010101010101010101000000000000000000000000
0000000088999928880008888999928008889999999992899928000889992899928000001010101dd01010101010101550101010000000000000000000000000
00000000889999992800088999999280088a99288999928999280008899928999280000000000000000000000000000000000000000000000000000000000000
00000000889999992800088999999280088999288899928999280008899928999280000000000000000000000000000000000000000000000000000000000000
00000000889999992800088999999280888999288899928999280088899928999280000000000000000000000000000000000000000000000000000000000000
0000000088999999280008899999928088a999288899928999280888999288999280000000000000000000000000000000000000000000000000000000000000
00000000889999992800088999999280889999288899928999288889999288999280000000000000000000000000000000000000000000000000000000000000
00000000889999999280889999999280889992888899928999288899992888999280000000000000000000000000000000000000000000000000000000000000
00000000889992999280889992999280889992888899928999288999928888999280000000000000000000000000000000000000000000000000000000000000
00000000889992999928899992999288889992888899928999999999288088999280000000000000000000000000000000000000000000000000000000000000
00000000889992999928899992999288899999999999928999999992880088999280000000000000000000000000000000000000000000000000000000000000
00000000889992889992999928999288899999999999928999999992800088999280000000000000000000000000000000000000000000000000000000000000
00000000889992889999999928999288899999999999928999289992800088999280000000000000000000000000000000000000000000000000000000000000
00000000889992889999999288999288899928888899928999289999280088999280000000000000000000000000000000000000000000000000000000000000
00000000889992888999992888999288999928888899928999288999280088999280000000000000000000000000000000000000000000000000000000000000
00000000889992888899928888999288999288008899928999288999928088999280000000000000000000000000000000000000000000000000000000000000
00000000889992808899928088999288999280008899928999288899928088999280000000000000000000000000000000000000000000000000000000000000
00000000889992808888888088999288999280008899928999288899992888999280000000000000000000000000000000000000000000000000000000000000
00000000889992800888880088999288999280008899928999280889992888999280000000000000000000000000000000000000000000000000000000000000
00000000889992800000000088999289999280008899928999280889999288999280000000000000000000000000000000000000000000000000000000000000
00000000889992800000000088999289992880008899928999280088999288999280000000000000000000000000000000000000000000000000000000000000
00000000889992800000000088999289992800008899928999280088999928999280000000000000000000000000000000000000000000000000000000000000
00000000889992800000000088999289992800008899928999280008899928999280000000000000000000000000000000000000000000000000000000000000
00000000888888800000000088888888888800008888888888880008888888888880000000000000000000000000000000000000000000000000000000000000
00000000888888800000000088888888888800008888888888880000088888888880000000000000000000000000000000000000000000000000000000000000

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
01010000113501b3401a3351a3251a3151a3150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103000012540125321652216525165001650013700183001a4001a4001b4001c400112000f3000e3000f0000b000000000000000000000000000000000000000000000000000000000000000000000000000000
010a0000240201e3101e3150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a0000150401a5401a5450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600002403130025000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000e5341c300250511175400000135450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01090000150301a0451d0452205525055270550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600001453023530001001800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
010100000c2540d2500d2500e2500f250102501125013250162501e25026250272500e20000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200
0101000025250212501d2501b2501925017250152501425013250112550f2550f2550e20000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200
0106000004672046720567206672066720767207672146421564216642166321763218632196321a6221a6221b6221c6221e6221f612216122261500005000000000000000000000000000000000000000000000
011200001c5511c551000000000013552135521355013550000000000000000131001c5511c55000000000001d5521d550000000000015552155521555015550000000000000000000001d5521d5521d5501d550
011200001f5511f5501c5501c55018552185521855218552185501855018550185501f5511f5501f5501f5502155221552215501f55021552215502155023550245522455224550235502155221552215501f550
011200000013000130000000000000130001300000000000001300013000000000000013000130000000000002130021300000000000021300213000000000000213002130000000000002130021300000000000
011200000413004130000000000004130041300000000000041300413000000000000413004130000000000005130051300000000000051300513000000000000513005130000000000005130051300000000000
01100000000000a1510a1132210000000000000000000000000001b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0110000000000107501c7600400000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

