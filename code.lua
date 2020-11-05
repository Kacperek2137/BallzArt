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

	-- game start sfx
	sfx(26)

	music(4,5000)



end

function _update60()


	--debug
	debug = ''
	-- if x is pressed
	if btnp(5) then

		ball_frosted = true
		frosted_timer = 100
		-- frost SFX
		sfx(27)
	end

	if ball_frosted == true then
		frosted_timer -= 1
		ball_col = 12
		outline_col = 12
		
		if frosted_timer < 0 then
			ball_frosted = false
			ball_col = 9
			outline_col = 8
			-- unfrost sfx
			sfx(28)
		end
	end



	-- debug
	if btnp(4) then
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
	pad_x = mid(16,pad_x, 91)
	pad_y = mid(26,pad_y,85)

	if pad_position == "horizontal" then

		pad_x += pad_dx
	end

	if pad_position == "vertical" then

		pad_y += pad_dy

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
			ball_y -= abs(pad_dx + pad_dy)
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









function _draw()

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
	addpart(_x,_y,8,60,8,0)
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
			circfill(_p.x,_p.y,sin(_p.age) * 10,_p.col)
			pset(_p.x,_p.y,_p.col)
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
	

	-- top left corner
	spr(6,0,0,2,2)

	-- top right corner
	spr(8,112,0,2,2)

	-- bottom left corner
	spr(38,0,96,2,2)

	-- bottom right corner
	spr(6,112,96,2,2,true,true)


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
				--sfx of explosion
				sfx(29)
				order_time -= 10
				shake+=1
				spawnboom(ing.x,ing.y)
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
