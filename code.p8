pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--some code

bx = 62
by = 62

bdx = 3
bdy = 3



function _init()
cls()

end

function _update()

bx += bdx
by += bdy

-- x
if bx > 127 then
	bdx = -3
end

if bx < 0 then
	bdx = 3
end

--y

if by > 127 then
	bdy = -3
end

if by < 0 then
	bdy = 3
end



if (btn(0)) then 
	bx -= 1
end

if (btn(1)) then
	bx += 1
end	

if (btn(3)) then 
	by += 1
end

if (btn(2)) then
	by -= 1
end	


end



function _draw()
	cls()
	circ(63,63,65,2)
	--player ball
	circfill(bx,by,3,9)

end
__gfx__
00000000006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000060000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700600000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000600000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000600000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700600000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000060000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
