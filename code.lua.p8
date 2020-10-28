pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init()
	--debug
	collision = false
	debugnum = 10


	--debug outline
	outline_col = 8
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
	pad_width = 20
	pad_height = 3
	pad_color = 3

	pad_hitbox_x = 0
	pad_hitbox_y = 0
	pad_hitbox_width = 0
	pad_hitbox_height= 0


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


	-- order system update
	frame = 0
	sec = 0
	order_time_procentage = 0
	bar_col = 7
	bar_x = 0

	-- ingredient control setup
	ing_list = {}



end

function _update60()

	--debug
	debug = ''
	-- if x is pressed
	if btnp(5) then
		new_order()
	end

	-- debug
	if btnp(4) then
		outline_col += 1
		-- debug
		add_ing(1,3,flr(rnd(4) + 1),"TOP")
		add_ing(110,101,flr(rnd(4) + 1),"BOTTOM")
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

	ball_x += ball_dx
	ball_y += ball_dy

	-- ball wall bouncing
	-- radius is added or removed for better collision detection
	if ball_x > 127 - ball_radius then
		ball_dx = -ball_dm
		ball_dy = 1 * sign(ball_dy)
		sfx(1)
	end

	if ball_x < 0 + ball_radius then
		ball_dx = ball_dm
		ball_dy = 1 * sign(ball_dy)
		sfx(1)
	end

	if ball_y > 111 - ball_radius then
		ball_dy = -ball_dm
		ball_dx = 1 * sign(ball_dx)
		sfx(1)
	end

	if ball_y < 0 + ball_radius then
		ball_dy = ball_dm
		ball_dx = 1 * sign(ball_dx)
		sfx(1)
	end

	-- horizontal

	-- only one button can be held at a time
	if (btn(0)) and not (btn(2)) and not (btn(3)) then
		--pad_x -= 3
		pad_dx = -3
		butpress = true
		pad_position = "horizontal"
	end

	if (btn(1)) and not (btn(2)) and not (btn(3))then
		--pad_x += 3
		pad_dx = 3
		butpress = true
		pad_position = "horizontal"
	end

	-- vertical pad movement 

	if (btn(2)) and not (btn(0)) and not (btn(1)) and not (btn(3)) then
		--pad_y -= 3
		pad_dy = -3
		butpress = true
		pad_position = "vertical"
	end

	if (btn(3)) and not (btn(0)) then
		--pad_y += 3
		pad_dy =3
		butpress = true
		pad_position = "vertical"
	end

	if not(butpress) then
		pad_dx = pad_dx/3
		pad_dy = pad_dy/3
	end













	--pad clamp border
	pad_x = mid(7,pad_x,100)
	pad_y = mid(17,pad_y,110)

	if pad_position == "horizontal" then

		pad_x += pad_dx
	end

	if pad_position == "vertical" then

		pad_y += pad_dy

	end
	pad_color = 7
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



	-- target collision
	if ball_box(target_x, target_y, target_radius, target_radius) then
		sfx(3)
		--target_x = rnd(100)
		target_x = 5 + rnd (100)
		target_y = 6
		target_dx = target_dm
		target_dy = 0
		score += 1


	end



	-- sectarget collision
	if ball_box(sectarget_x, sectarget_y, sectarget_radius, sectarget_radius) then
		sfx(2)
		--target_x = rnd(100)
		sectarget_x = 5 + rnd (100)
		sectarget_y = 6
		sectarget_dx = sectarget_dm
		sectarget_dy = 0
		score += 1

	end
	-- badtarget collision
	if ball_box(badtarget_x, badtarget_y, badtarget_radius, badtarget_radius) then
		sfx(2)
		badtarget_x =  5
		badtarget_y = 5 + rnd(100)
		badtarget_dx = 0
		badtarget_dy = -badtarget_dm
		score -= 1


	end

	if pad_position == "horizontal" then


		-- left pad check
		if ball_box(pad_hitbox_x - 1, pad_hitbox_y + 1,1,pad_hitbox_height / 2) then
			ball_x -= 4
			
		end

		-- right pad check
		if ball_box(pad_hitbox_x + pad_hitbox_width, pad_hitbox_y + 1,1,pad_hitbox_height / 2) then
			ball_x += 4
			
		end


	end

	if pad_position == "vertical" then

		-- top pad check
		if ball_box(pad_hitbox_x + pad_hitbox_width /2, pad_hitbox_y - 1, pad_hitbox_width / 2, pad_hitbox_width / 2) then
			ball_y -= 4
		end


		-- bottom pad check
		if ball_box(pad_hitbox_x + pad_hitbox_width / 2, pad_hitbox_y + pad_hitbox_height, pad_hitbox_width / 2, pad_hitbox_width /2) then
			ball_y += 4
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



end








function _draw()

	cls()

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
	circfill(ball_x,ball_y,ball_radius, 9)



	--camera(pad_x - 64,pad_y - 64 )

	-- bouncebox left setup
	--rectfill(pad_bouncebox_left_x,pad_bouncebox_left_y,10,10)




	-- ing system draw
	draw_ing()

	drawserveboxes()



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

	addpart(_x + _ox,_y + _oy,0,20 + rnd(15), 9, 10)
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


	-- big box

	rect(0,0,127,111,line_col)


	-- small box
	-- pattern test
	fillp(0b1000010000100001)
	rectfill(13,13,114,98,4)
	fillp()

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
	print(9999,108,116,7)

	--print(order_time,60,80,8)
	--print(frame,60,90,9)
	--print(order_time_procentage,60,70,10)



	print(debug,30,30,1)
end


function drawserveboxes()
	-- serve boxes
	rectfill(0,0,12,12,line_col)
	rectfill(115,99,127,111,line_col)
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
	sfx(6)
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


	ing_5 = flr(ing_to_dispose)
	ing_to_dispose -= ing_2


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
				ing.x -= 0.5
			end
			if ing.x <= 3 and ing.y > 3 then
				ing.y -= 0.5
			end

			if ing.y == 0 then
				del(ing_list,ing)
			end

		end

		if ing.tray == "TOP" then

			-- left upper corner hit
			if ing.x < 117 and ing.y < 101 then
				ing_dx = 0.5
				ing_dy = 0
			end

			-- top right corner hit
			if ing.x >= 117 and ing.y < 101 then
				ing_dx = 0
				ing_dy = 0.5
			end

			-- bottom right corner hit
			if ing.x >= 117 and ing.y >= 101 then
				ing_dx = -0.5
				ing_dy = 0
				del(ing_list,ing)
			end

		end

		-- moving the ing
		ing.x += ing_dx
		ing.y += ing_dy


		-- hitbox check
		if ball_box(ing.x,ing.y,8,8) then
			-- changing the values of ing types on the UI
			debugnum += 1
			if flr(ing.tpe) == 1 then
				ing_1 -= 1
			end

			if flr(ing.tpe) == 2 then
				ing_2 -= 1
			end

			if flr(ing.tpe) == 3 then
				ing_3 -= 1
			end

			if flr(ing.tpe) == 4 then
				ing_4 -= 1
			end

			if flr(ing.tpe) == 5 then
				ing_5 -= 1
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



__sfx__
0001000024050000002305000000220502205000000200502005022050270501f0502105022050210501705017050240501f0501805020050250501d0501a050260502c050210501905025050000000000000000
0003000000000000000000000000000000000009050000000a0500905008050080500805030050380503905039050380502d0501e0500f0500e0500e0500e0500e0500f050000000000000000000000000000000
__music__
00 41424344
01 01424344
02 41004344

