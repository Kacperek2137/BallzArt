pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init()
	--debug
	collision = false
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
	ball_radius = 6
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


end

function _update60()


collision = false



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

end

if ball_x < 0 + ball_radius then
	ball_dx = ball_dm
	ball_dy = 1 * sign(ball_dy)
end

if ball_y > 111 - ball_radius then
	ball_dy = -ball_dm
	ball_dx = 1 * sign(ball_dx)
end

if ball_y < 0 + ball_radius then
	ball_dy = ball_dm
	ball_dx = 1 * sign(ball_dx)
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
	sfx(1)
	--target_x = rnd(100)
	target_x = 5 + rnd (100)
	target_y = 6
	target_dx = target_dm
	target_dy = 0
	score += 1


end



-- sectarget collision
if ball_box(sectarget_x, sectarget_y, sectarget_radius, sectarget_radius) then
	sfx(1)
	--target_x = rnd(100)
	sectarget_x = 5 + rnd (100)
	sectarget_y = 6
	sectarget_dx = sectarget_dm
	sectarget_dy = 0
	score += 1

end
-- badtarget collision
if ball_box(badtarget_x, badtarget_y, badtarget_radius, badtarget_radius) then
	sfx(1)
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



end








function _draw()

	cls()
	-- background
	rectfill(0,0,128,128,0)


	-- big box
	rect(0,0,127,111,line_col)

	-- small box
	rect(13,13,114,98,line_col)
	
	-- serve boxes
	rectfill(0,48,13,67,line_col)
	rectfill(115,48,128,67,line_col)


	-- test sprites
	spr(1,60,101)
	spr(1,117,81)
	spr(1,3,23)


	-- progress bar box
	rect(0,124,127,127,line_col)

	-- progress bar 
	rectfill(0,124,84,127,line_col)

	-- counter

	-- counter 1
	print(99,6,115)
	-- sprite 1
	spr(1,16,114)


	-- counter 2
	print(99,30,115)
	-- sprite 2
	spr(1,40,114)


	-- counter 3
	print(99,54,115)
	-- sprite 3
	spr(1,64,114)


	-- counter 4
	print(99,78,115)
	-- sprite 4
	spr(1,88,114)
	
	-- score bar
	print(09999,102,115)

	print(score,63,75,11)

	--timer
	print(flr(time()), 63, 85, 0)


	-- target
	circfill(target_x,target_y,target_radius,11)

	-- sectarget
	circfill(sectarget_x,sectarget_y,sectarget_radius,11)
	
	-- bad target
	--circfill(badtarget_x,badtarget_y,badtarget_radius,8)
	spr(badtarget_sprite,badtarget_x,badtarget_y)

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
	
	--ball
	circfill(ball_x,ball_y,ball_radius, 9)


	--camera(pad_x - 64,pad_y - 64 )

	-- bouncebox left setup
	--rectfill(pad_bouncebox_left_x,pad_bouncebox_left_y,10,10)



	-- debug

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

-- 15:21 
__gfx__
00000000000bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001654014500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
000100000c5540f554105540d5540b554075540555404554075540d55410554185541d55025550265500e5000f5001050013500155001750018500175001a5001d5001f500005000050000500005000050000500
__music__
03 00014344

