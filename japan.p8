pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init()
	pad_x = 50
	pad_y = 50
	pad_position = ""
	pad_width = 20
	pad_height = 2
	pad_color = 6

	-- ball setup
	ball_radius = 2
	ball_x = 37
	ball_y = 20
	ball_dx = 1
	ball_dy = 1

	--debug monitor cleanup
	for i=1, 100 do
		printh("")
	end

end

function _update()
ball_x += ball_dx
ball_y += ball_dy

if ball_x > 127 then
	ball_dx = -1
end

if ball_x < 0 then
	ball_dx = 1
end

if ball_y > 127 then
	ball_dy = -1
end

if ball_y < 0 then
	ball_dy = 1
end

-- horizontal
if (btn(0)) then
 pad_x -= 3
 pad_position = "horizontal"
end

if (btn(1)) then
 pad_x += 3
 pad_position = "horizontal"
end

-- vertical 

if (btn(2)) then
 pad_y -= 3
 pad_position = "vertical"
end

if (btn(3)) then
 pad_y += 3
 pad_position = "vertical"
end

pad_color = 7
-- check if ball hit pad
if ball_box(pad_x, pad_y, pad_width, pad_height) then
	-- deal with collision
	pad_color = 8
	sfx(0)
	-- ball_dy = - ball_dy
end


end

function _draw()
	cls()
	-- background
	rectfill(0,0,127,127,15)

	
	-- player pad
	if pad_position == "horizontal" then
		rectfill(pad_x, pad_y, pad_x + pad_width, pad_y + pad_height, pad_color)
	end
	
	if pad_position == "vertical" then
		rectfill(pad_x + pad_width / 2 - pad_height / 2 - pad_height / 2 ,pad_y - pad_width / 2 ,pad_x + pad_width /2, pad_y + pad_width / 2, pad_color)
	end
	
	--ball
	circfill(ball_x,ball_y,ball_radius, 9)

end

function ball_box(box_x, box_y, box_width, box_height)
	--checks the collision of a ball with a rectangle
	if pad_position == "horizontal" then
		-- we do nothing
		printh("collision")
	end

	if pad_position == "vertical" then
		-- we need to change the box values
		box_x = box_x + box_width / 2 - box_height / 2 
		--printh(box_x)
		box_y = box_y - box_width / 2

		box_width = box_height
		box_height = box_width

		printh(box_x, box_y)

	end
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
