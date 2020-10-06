pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

function _init()

-- ball setup
ball_radius = 6
ball_x = 37
ball_y = 20
-- max speed
ball_dm = 0.5
ball_dx = ball_dm
ball_dy = ball_dm

ball_ang = 0


box_x = 80
box_y = 50
box_radius = 50

end


function _update60()

ball_x += ball_dx
ball_y += ball_dy

if btn(0) then
	box_x -= 3
end

if btn(1) then
	box_x += 3
end
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

-- left box
if ball_box(box_x-1,box_y,box_x,box_y + box_radius) then
	ball_dx = - ball_dx
	ball_x -= 4

end

-- right box
if ball_box(box_x + box_radius,box_y,1,box_radius) then
	ball_dx = - ball_dx
	ball_x += 4

end

end

function _draw()

	cls()

	rectfill(0,0,127,111,4)


	rectfill(box_x,box_y,box_x + box_radius, box_y + box_radius,8)

	-- left box
	rectfill(box_x-1,box_y,box_x,box_y + box_radius,7)

	-- right box
	rectfill(box_x + box_radius,box_y,box_x + box_radius + 1,box_y + box_radius,7)

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
	collision = true
	return true
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



__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
