pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init()
	-- STRAJK KOBIET
	-- WSZYSTKIEGO NAJLEPSZEGO

	win = false

	endscreentimer = 0

	current_deletion = nil

	protesttimer = 0
	
	protest_col = 8

	music(0)
	shake = 0
	background_col = 5

	pis_array = {}

	timer = 0
	addtext("PIS",64,64,7)
	sfx(2)

	-- ***** ***
	possible_texts = {

		"PIS",
		"KACZOR",
		"KONFEDERACJA",
		"KORWIN",
		"BOSAK",
		"CZARNEK",
		"SZUMOWSKI",
		"KAJA G.",
		"BRAUN",
		"DUDA",
		"KOSCIOL",
		"TRYBUNAL",
		"ZIOBRO",
		"ORDO IURIS",
		"SASIN",
		"KURSKI"
	}

end
function _update()

	timer += 1

	protesttimer += 1


	if win == false then

		if timer == 15 then
			addtext(possible_texts[ceil(rnd(#possible_texts))],rnd(128),rnd(128),7)
			sfx(2)
			timer = 1
		end
	end

	updatetext()


	if btnp(5) then
		killtext()

	end

	if ismusicplaying == true then
	end


	if #pis_array == 0 then
		win = true
		music(-1,2000)
	end


end
function _draw()


rectfill(0,0,127,127,background_col)


drawtext()

if btnp(5) and win == false then

	lightningrod()

end



if #pis_array != 0 and protesttimer > 60 then

	print("PRESS ❎ TO PROTEST",30,65,8)
end






 	
	if win == true then
		endscreentimer += 1
		if endscreentimer >= 90 then
			print("STRAJK KOBIET",38,100,8)
			print("PROTESTUJ",44,110,8)
			zspr(1,2,2,32,10,5)
		elseif endscreentimer >= 60 then
			print("STRAJK KOBIET",38,100,8)
			zspr(1,2,2,32,10,5)
		elseif endscreentimer >= 30 then

			zspr(1,2,2,32,10,5)
		end

	end

end
-- PIS particles

-- adds a particle
function addtext(_text,_x,_y,_col)
	local _p = {}
	_p.text = _text
	_p.x = _x
	_p.y = _y
	_p.col = _col
	-- we're adding a particle to particle array
	add(pis_array,_p)
end

function updatetext()
	local _p
	for i=#pis_array,1, -1 do
		_p = pis_array[i]
		_p.x += rnd(2) -1
		_p.y += rnd(2) -1
	end
end

function drawtext()
	for i = 1,#pis_array do
		_p = pis_array[i]
		print(_p.text,_p.x,_p.y,_p.col)
		--print(_p.tpe,1,20,10)
		-- checks if particle is trail type
		if _p.tpe == 0 then
			--print("PSET", 1,10, 10)
			pset(_p.x,_p.y,_p.col)
		else
		end
	end
end



function zspr(n,w,h,dx,dy,dz,fx,fy)
 sspr(8*(n%16),8*flr(n/16),8*w,8*h,dx,dy,8*w*dz,8*h*dz,fx,fy)
end


function killtext()

	local killed = {}



	ismusicplaying = true
	current_deletion = rnd(#pis_array) +1
	killed = pis_array,current_deletion
	deli(pis_array,current_deletion)



	sfx(1)

end


function lightningrod()
	local x1 = rnd(128)
	local y1 = -1 
	local x2 = rnd(128)
	local y2 = 128
	local lazertimer = 0
	line(x1,y1,x2,y2,8)

end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000788888887000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000007888888870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700007888888700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000078888887000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000078888877770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000788888888870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777778888700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000078887000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000788870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000788700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000787000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010600002273022700007000070000700007000070000700227300070000700007000070000700007000070022730007000000000000000000000000000000000000000000000000000000000000000000000000
010200001f63420627236151960017600126000f6000f6000f600176001e6002a6000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
00010000160200f020120200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000405003050020500105001050000500100001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300000305001050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
03 00424344
