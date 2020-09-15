pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init()
	pad_x = 55
	pad_y = 63
	pad_position = ""
	pad_width = 20
	pad_height = 2
	pad_color = 6

	-- ball setup
	ball_radius = 2
	ball_x = 37
	ball_y = 20
	ball_dx = 3
	ball_dy = 2


	-- target setup
	target_x = rnd(100)
	target_y = 6
	target_radius = 5
	target_dx = 1
	target_dy = 0
	target_d = 1


	-- bad target setup
	badtarget_x = rnd(100)
	badtarget_y = 122
	badtarget_radius = 5
	badtarget_dx = -0.1


	--debug monitor cleanup
	for i=1, 100 do
		printh("")
	end

end

function _update()

-- target movement

target_x += target_dx
target_y += target_dy

-- top right corner hit
if target_x > 120 and target_y < 120 then
	target_dx = 0
	target_dy = 1
end

-- bottom right corner hit
if target_x > 120 and target_y > 120 then
	target_dx = -1
	target_dy = 0
end


-- bottom left corner hit
if target_x < 7 and target_y > 120 then
	target_dx = 0
	target_dy = -1
end

-- top left corner hit
if target_x < 7 and target_y < 7 then
	target_dx = 1
	target_dy = 0
end
printh(target_dx)

-- badtarget movement

badtarget_x += badtarget_dx

if badtarget_x > 127 then
	badtarget_dx = -0.1
end

if badtarget_x < 0 then
	badtarget_dx = 0.1
end

printh(target_dx)

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

-- vertical 

-- if (btn(2)) then
--  pad_y -= 3
-- end

-- if (btn(3)) then
--  pad_y += 3
-- end

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
	target_x = 5
	target_y = 6
	target_dx = 1
	target_dy = 0

end


-- badtarget collision
if ball_box(badtarget_x, badtarget_y, badtarget_radius, badtarget_radius) then
	badtarget_x = rnd(100)
	badtarget_y = rnd(20) + 100

end



end

function _draw()
	cls()
	-- background
	rectfill(0,0,127,127,15)

	-- tray of line
	rect(5,5,122,122,5)

	-- target
	circfill(target_x,target_y,target_radius,11)

	
	-- bad target
	--circfill(badtarget_x,badtarget_y,badtarget_radius,8)

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
