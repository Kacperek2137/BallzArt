pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init()
	-- pad setup
	pad_x = 55
	pad_y = 63
	pad_position = ""
	pad_width = 20
	pad_height = 2
	pad_color = 6

	-- ball setup
	ball_radius = 5
	ball_x = 37
	ball_y = 20
	ball_dx = 3
	ball_dy = 2


	-- target setup
	target_x = rnd(100)
	target_y = 6
	target_radius = 5
	-- max speed
	target_dm = 0.5
	-- initial setup for top left of the screen
	target_dx = target_dm
	target_dy = 0


	-- sec target setup

	sectarget_x = 6
	sectarget_y = rnd(100)
	sectarget_radius = 5
	-- max speed
	sectarget_dm = 0.5
	-- initial setup for top left of the screen
	sectarget_dx = 0
	sectarget_dy = -target_dm
	-- max speed


	-- bad target setup
	badtarget_x = rnd(100)
	badtarget_y = 122
	badtarget_radius = 5
	-- max speed
	badtarget_dm = 0.5
	-- initial setup for bottom right corner
	badtarget_dx = - badtarget_dm
	badtarget_dy = 0

	--score setup
	score = 0


	--debug monitor cleanup



end

function _update()

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

if ball_x > 127 then
	ball_dx = -2
end

if ball_x < 0 then
	ball_dx = 2
end

if ball_y > 127 then
	ball_dy = -2
end

if ball_y < 0 then
	ball_dy = 2
end

-- horizontal
if (btn(0)) then
 pad_x -= 3
end

if (btn(1)) then
 pad_x += 3
end

-- vertical pad movement 

 if (btn(2)) then
  pad_y -= 3
	end

 if (btn(3)) then
  pad_y += 3
 end

pad_color = 7
-- check if ball hit pad
if ball_box(pad_x, pad_y, pad_width, pad_height) then
	-- deal with collision
	pad_color = 8
	sfx(0)
	ball_dy = - ball_dy
end


-- target collision
if ball_box(target_x, target_y, target_radius, target_radius) then
	--target_x = rnd(100)
	target_x = 5 + rnd (100)
	target_y = 6
	target_dx = target_dm
	target_dy = 0
	score += 1

end


-- sectarget collision
if ball_box(sectarget_x, sectarget_y, sectarget_radius, sectarget_radius) then
	--target_x = rnd(100)
	sectarget_x = 5 + rnd (100)
	sectarget_y = 6
	sectarget_dx = sectarget_dm
	sectarget_dy = 0
	score += 1

end
-- badtarget collision
if ball_box(badtarget_x, badtarget_y, badtarget_radius, badtarget_radius) then
	badtarget_x =  5
	badtarget_y = 5 + rnd(100)
	badtarget_dx = 0
	badtarget_dy = -badtarget_dm
	score -= 1

end



end


function _draw()
	cls()
	-- background
	rectfill(0,0,127,127,15)

	-- target score
	print(score,63,75,11)

	--timer
	print(flr(time()), 63, 85, 0)

	-- tray of line
	rect(5,5,122,122,5)

	-- target
	circfill(target_x,target_y,target_radius,11)

	-- sectarget
	circfill(sectarget_x,sectarget_y,sectarget_radius,11)
	
	-- bad target
	circfill(badtarget_x,badtarget_y,badtarget_radius,8)


	-- player pad
	rectfill(pad_x, pad_y, pad_x + pad_width, pad_y + pad_height, pad_color)
	
	
	--ball
	circfill(ball_x,ball_y,ball_radius, 9)

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
	return true

end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001654014500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
010100002f0542d05429054270542405423054200541f0541b054190541805416054130501205010050100500e0500c0500c05009050080500705006050050500405001050000500005000000000000000000000
__music__
03 00014344

