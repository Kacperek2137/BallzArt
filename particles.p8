pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- advanced particle system
-- blog.ccatgames.com

function _init()
  make_sparks_ps(64,64)
end

function _update()
	update_psystems()

	if (btnp(1)) then
		currdemo += 1
		if (currdemo>count(demos)) then
		 	currdemo = 1
		 end 
		 deleteallps()
		 demos[currdemo].createfunc()
	end
	if (btnp(0)) then
		currdemo -= 1
		if (currdemo<=0) then
		 	currdemo = count(demos)
		 end 
		 deleteallps()
		 demos[currdemo].createfunc()
	end
	if (btnp(5)) then
		demos[currdemo].createfunc()
		--make_smoke_ps(rnd(107)+10,rnd(107)+10)
	end
end

function _draw()
	cls()
	for ps in all(particle_systems) do
		draw_ps(ps)
	end
	print(demos[currdemo].name,0,0,7)
	print(demos[currdemo].desc,0,8,7)
	print("left/right to change demo", 0, 112, 5)
	print("x to spawn particle system",0,120,5)
	print(stat(1),105,120,3)
end

function deleteallps()
	for ps in all(particle_systems) do
		del(particle_systems, ps)
	end
end

-- demos -------------------------------------------------------
function sparks_demo()
	make_sparks_ps(rnd(107)+10,rnd(107)+10)
end

function explo_demo()
	make_explosion_ps(rnd(107)+10,rnd(107)+10)
end

function richexplo_demo()
	local rx = rnd(107)+10
	local ry = rnd(107)+10
	make_explosmoke_ps(rx,ry)
	make_explosparks_ps(rx,ry)
	make_explosion_ps(rx,ry)
end

function blood_demo()
	make_blood_ps(rnd(64),rnd(90)+10)
end

function smoke_demo()
	make_smoke_ps(rnd(107)+10,rnd(90)+10)
end

function waterfall_demo()
	make_waterfall_ps(rnd(107)+10,rnd(50)+10)
end

function starfield_demo()
	make_starfield_ps()
end

function warp_demo()
	make_3dwarp_ps()
end

function magicsparks_demo()
	make_magicsparks_ps(rnd(107)+10,rnd(107)+10)
end

function butterflies_demo()
	make_butterflies_ps(rnd(107)+10,rnd(54)+64)
end

function bubbles_demo()
	make_bubbles_ps()
end

demos = {
	{name = "sparks", desc = "", createfunc = sparks_demo },
	{name = "explosion", desc = "", createfunc = explo_demo },
	{name = "rich explosion", createfunc = richexplo_demo, desc = "multiple particle systems" },
	{name = "blood", createfunc = blood_demo, desc = "stopzone affector" },
	{name = "smoke", createfunc = smoke_demo, desc = "continuos particle system" },
	{name = "waterfall", createfunc = waterfall_demo, desc = "streak draw bouncezone affector" },
	{name = "starfield", createfunc = starfield_demo, desc = "" },
	{name = "3d warp", createfunc = warp_demo, desc = "attract affector" },
	{name = "magic sparks", createfunc = magicsparks_demo, desc = "rndspr" },
	{name = "bubbles", createfunc = bubbles_demo, desc = "agespr, orbit affector" },
	{name = "butterflies", createfunc = butterflies_demo, desc = "animspr, forcezone affector" },
}
currdemo = 1

-- sample particle system constructors -------------------------
function make_bubbles_ps()
	local ps = make_psystem(0.5,3.0, 1,9,0.5,0.5)
	
	ps.autoremove = false
	add(ps.emittimers,
		{
			timerfunc = emittimer_constant,
			params = {nextemittime = time(), speed = 0.2}
		}
	)
	add(ps.emitters, 
		{
			emitfunc = emitter_box,
			params = { minx = 0, maxx = 127, miny = 100, maxy= 110, minstartvx = 0, maxstartvx = 0, minstartvy = -1.50, maxstartvy=-0.2 }
		}
	)
	add(ps.drawfuncs,
		{
			drawfunc = draw_ps_agespr,
			params = { frames = {16,16,17,17,17,18,18,18,18,18,18,18,18,18,18,19} }
		}
	)
	add(ps.affectors,
		{ 
			affectfunc = affect_orbit,
			params = { phase = 0, speed = 0.005, xstrength = 0.5, ystrength = 0 }
		}
	)
end

function make_magicsparks_ps(ex,ey)
	local ps = make_psystem(0.3,1.7, 1,5,1,5)
	
	add(ps.emittimers,
		{
			timerfunc = emittimer_burst,
			params = { num = 10}
		}
	)
	add(ps.emitters, 
		{
			emitfunc = emitter_box,
			params = { minx = ex-8, maxx = ex+8, miny = ey-8, maxy= ey+8, minstartvx = -1.5, maxstartvx = 1.5, minstartvy = -3, maxstartvy=-2 }
		}
	)
	add(ps.drawfuncs,
		{
			drawfunc = draw_ps_rndspr,
			params = { frames = {32,33,34,35,36}, colors = {8,9,11,12,14} }
		}
	)
	add(ps.affectors,
		{ 
			affectfunc = affect_force,
			params = { fx = 0, fy = 0.3 }
		}
	)

end

function make_butterflies_ps(ex,ey)
	local ps = make_psystem(2,3, 1,9,1,5)
	
	add(ps.emittimers,
		{
			timerfunc = emittimer_burst,
			params = { num = 10}
		}
	)
	add(ps.emitters, 
		{
			emitfunc = emitter_box,
			params = { minx = ex-16, maxx = ex+16, miny = ey-8, maxy= ey+8, minstartvx = 0, maxstartvx = 0, minstartvy = -2, maxstartvy= -1 }
		}
	)
	add(ps.drawfuncs,
		{
			drawfunc = draw_ps_animspr,
			params = { frames = {22,23,24,23}, speed = 0.5, colors = {8,9,11,12,14}, currframe = 1 }
		}
	)
	add(ps.affectors,
		{ 
			affectfunc = affect_forcezone,
			params = { fx = -0.2, fy = 0.0, zoneminx = 64, zonemaxx = 127, zoneminy = 64, zonemaxy = 100 }
		}
	)
	add(ps.affectors,
		{ 
			affectfunc = affect_forcezone,
			params = { fx = 0.2, fy = 0.0, zoneminx = 0, zonemaxx = 64, zoneminy = 30, zonemaxy = 70 }
		}
	)
end

function make_3dwarp_ps()
	local ps = make_psystem(1,2, 1,2,0.5,0.5)
	ps.autoremove = false
	add(ps.emittimers,
		{
			timerfunc = emittimer_constant,
			params = {nextemittime = time(), speed = 0.001}
		}
	)
	add(ps.emitters, 
		{
			emitfunc = emitter_box,
			params = { minx = 62, maxx = 66, miny = 62, maxy= 66, minstartvx = 0, maxstartvx = 0, minstartvy = 0, maxstartvy=0 }
		}
	)
	add(ps.affectors, 
		{
			affectfunc = affect_attract,
			params = { x = 64, y = 64, mradius = 64, strength = 0.01 }
		}
	)
	add(ps.drawfuncs,
		{
			drawfunc = draw_ps_streak,
			params = { colors = {1,1,1,1,1,13,13,13,13,13,6,7,13,6,6,6,7,6,6,7,6,7,7} }
		}
	)
end

function make_starfield_ps()
	local ps = make_psystem(4,6, 1,2,0.5,0.5)
	ps.autoremove = false
	add(ps.emittimers,
		{
			timerfunc = emittimer_constant,
			params = {nextemittime = time(), speed = 0.01}
		}
	)
	add(ps.emitters, 
		{
			emitfunc = emitter_box,
			params = { minx = 125, maxx = 127, miny = 0, maxy= 127, minstartvx = -2.0, maxstartvx = -0.5, minstartvy = 0, maxstartvy=0 }
		}
	)
	add(ps.drawfuncs,
		{
			drawfunc = draw_ps_pixel,
			params = { colors = {7,6,7,6,7,6,6,7,6,7,7,6,6,7} }
		}
	)
end

function make_waterfall_ps(ex,ey)
	local ps = make_psystem(1.5,2, 1,2,0.5,0.5)
	ps.autoremove = false
	add(ps.emittimers,
		{
			timerfunc = emittimer_constant,
			params = {nextemittime = time(), speed = 0.01}
		}
	)
	add(ps.emitters, 
		{
			emitfunc = emitter_box,
			params = { minx = ex-8, maxx = ex+8, miny = ey, maxy= ey+1, minstartvx = -0.5, maxstartvx = 0.5, minstartvy = 0, maxstartvy=0 }
		}
	)
	add(ps.drawfuncs,
		{
			drawfunc = draw_ps_streak,
			params = { colors = {7,12,1,12,12,1,12,1,1,7,7,7} }
		}
	)
	add(ps.affectors,
		{ 
			affectfunc = affect_force,
			params = { fx = 0, fy = 0.3 }
		}
	)
	add(ps.affectors,
		{ 
			affectfunc = affect_bouncezone,
			params = { damping = 0.2, zoneminx = 0, zonemaxx = 127, zoneminy = 100, zonemaxy = 127 }
		}
	)
end

function make_blood_ps(ex,ey)
	local ps = make_psystem(2,3, 1,2,0.5,0.5)
	
	add(ps.emittimers,
		{
			timerfunc = emittimer_burst,
			params = { num = 30}
		}
	)
	add(ps.emitters, 
		{
			emitfunc = emitter_point,
			params = { x = ex, y = ey, minstartvx = 1, maxstartvx = 3, minstartvy = -3, maxstartvy=-2 }
		}
	)
	add(ps.drawfuncs,
		{
			drawfunc = draw_ps_pixel,
			params = { colors = {8} }
		}
	)
	add(ps.affectors,
		{ 
			affectfunc = affect_force,
			params = { fx = 0, fy = 0.3 }
		}
	)
	add(ps.affectors,
		{ 
			affectfunc = affect_stopzone,
			params = { zoneminx = 0, zonemaxx = 127, zoneminy = 100, zonemaxy = 127 }
		}
	)
end

function make_sparks_ps(ex,ey)
	local ps = make_psystem(0.3,0.7, 1,2,0.5,0.5)
	
	add(ps.emittimers,
		{
			timerfunc = emittimer_burst,
			params = { num = 10}
		}
	)
	add(ps.emitters, 
		{
			emitfunc = emitter_point,
			params = { x = ex, y = ey, minstartvx = -1.5, maxstartvx = 1.5, minstartvy = -3, maxstartvy=-2 }
		}
	)
	add(ps.drawfuncs,
		{
			drawfunc = draw_ps_fillcirc,
			params = { colors = {7,10,15,9,4,5} }
		}
	)
	add(ps.affectors,
		{ 
			affectfunc = affect_force,
			params = { fx = 0, fy = 0.3 }
		}
	)
end

function make_explosparks_ps(ex,ey)
	local ps = make_psystem(0.3,0.7, 1,2,0.5,0.5)
	
	add(ps.emittimers,
		{
			timerfunc = emittimer_burst,
			params = { num = 10}
		}
	)
	add(ps.emitters, 
		{
			emitfunc = emitter_point,
			params = { x = ex, y = ey, minstartvx = -1.5, maxstartvx = 1.5, minstartvy = -1.5, maxstartvy=1.5 }
		}
	)
	add(ps.drawfuncs,
		{
			drawfunc = draw_ps_pixel,
			params = { colors = {15,6,13,4,2,1} }
		}
	)
	add(ps.affectors,
		{ 
			affectfunc = affect_force,
			params = { fx = 0, fy = 0.2 }
		}
	)
end

function make_explosion_ps(ex,ey)
	local ps = make_psystem(0.1,0.5, 9,14,1,3)
	
	add(ps.emittimers,
		{
			timerfunc = emittimer_burst,
			params = { num = 4 }
		}
	)
	add(ps.emitters, 
		{
			emitfunc = emitter_box,
			params = { minx = ex-4, maxx = ex+4, miny = ey-4, maxy= ey+4, minstartvx = 0, maxstartvx = 0, minstartvy = 0, maxstartvy=0 }
		}
	)
	add(ps.drawfuncs,
		{
			drawfunc = draw_ps_fillcirc,
			params = { colors = {7,0,10,9,9,4} }
		}
	)
end

function make_smoke_ps(ex,ey)
	local ps = make_psystem(0.2,2.0, 1,2,3,5)
	
	ps.autoremove = false

	add(ps.emittimers,
		{
			timerfunc = emittimer_constant,
			params = {nextemittime = time(), speed = 0.2}
		}
	)
	add(ps.emitters, 
		{
			emitfunc = emitter_box,
			params = { minx = ex-4, maxx = ex+4, miny = ey, maxy= ey+2, minstartvx = 0, maxstartvx = 0, minstartvy = 0, maxstartvy=0 }
		}
	)
	add(ps.drawfuncs,
		{
			drawfunc = draw_ps_fillcirc,
			params = { colors = {13,5,1} }
		}
	)
	add(ps.affectors,
		{ 
			affectfunc = affect_force,
			params = { fx = 0.003, fy = -0.01 }
		}
	)
end

function make_explosmoke_ps(ex,ey)
	local ps = make_psystem(1.5,2.0, 5,8,17,18)

	add(ps.emittimers,
		{
			timerfunc = emittimer_burst,
			params = { num = 1 }
		}
	)
	add(ps.emitters, 
		{
			emitfunc = emitter_point,
			params = { x = ex, y = ey, minstartvx = 0, maxstartvx = 0, minstartvy = 0, maxstartvy=0 }
		}
	)
	add(ps.drawfuncs,
		{
			drawfunc = draw_ps_fillcirc,
			params = { colors = {1} }
		}
	)
	add(ps.affectors,
		{ 
			affectfunc = affect_force,
			params = { fx = 0.003, fy = -0.01 }
		}
	)
end

-- particle system library -----------------------------------
particle_systems = {}

function make_psystem(minlife, maxlife, minstartsize, maxstartsize, minendsize, maxendsize)
	local ps = {}
	-- global particle system params
	ps.autoremove = true

	ps.minlife = minlife
	ps.maxlife = maxlife
	
	ps.minstartsize = minstartsize
	ps.maxstartsize = maxstartsize
	ps.minendsize = minendsize
	ps.maxendsize = maxendsize
	
	-- container for the particles
	ps.particles = {}

	-- emittimers dictate when a particle should start
	-- they called every frame, and call emit_particle when they see fit
	-- they should return false if no longer need to be updated
	ps.emittimers = {}

	-- emitters must initialize p.x, p.y, p.vx, p.vy
	ps.emitters = {}

	-- every ps needs a drawfunc
	ps.drawfuncs = {}

	-- affectors affect the movement of the particles
	ps.affectors = {}

	add(particle_systems, ps)

	return ps
end

function update_psystems()
	local timenow = time()
	for ps in all(particle_systems) do
		update_ps(ps, timenow)
	end
end

function update_ps(ps, timenow)
	for et in all(ps.emittimers) do
		local keep = et.timerfunc(ps, et.params)
		if (keep==false) then
			del(ps.emittimers, et)
		end
	end

	for p in all(ps.particles) do
		p.phase = (timenow-p.starttime)/(p.deathtime-p.starttime)

		for a in all(ps.affectors) do
			a.affectfunc(p, a.params)
		end

		p.x += p.vx
		p.y += p.vy
		
		local dead = false
		if (p.x<0 or p.x>127 or p.y<0 or p.y>127) then
			dead = true
		end

		if (timenow>=p.deathtime) then
			dead = true
		end

		if (dead==true) then
			del(ps.particles, p)
		end
	end
	
	if (ps.autoremove==true and count(ps.particles)<=0) then
		del(particle_systems, ps)
	end
end

function draw_ps(ps, params)
	for df in all(ps.drawfuncs) do
		df.drawfunc(ps, df.params)
	end
end

function emittimer_burst(ps, params)
	for i=1,params.num do
		emit_particle(ps)
	end
	return false
end

function emittimer_constant(ps, params)
	if (params.nextemittime<=time()) then
		emit_particle(ps)
		params.nextemittime += params.speed
	end
	return true
end

function emit_particle(psystem)
	local p = {}

	local e = psystem.emitters[flr(rnd(count(psystem.emiters)))+1]
	e.emitfunc(p, e.params)	

	p.phase = 0
	p.starttime = time()
	p.deathtime = time()+rnd(psystem.maxlife-psystem.minlife)+psystem.minlife

	p.startsize = rnd(psystem.maxstartsize-psystem.minstartsize)+psystem.minstartsize
	p.endsize = rnd(psystem.maxendsize-psystem.minendsize)+psystem.minendsize

	add(psystem.particles, p)
end

function emitter_point(p, params)
	p.x = params.x
	p.y = params.y

	p.vx = rnd(params.maxstartvx-params.minstartvx)+params.minstartvx
	p.vy = rnd(params.maxstartvy-params.minstartvy)+params.minstartvy
end

function emitter_box(p, params)
	p.x = rnd(params.maxx-params.minx)+params.minx
	p.y = rnd(params.maxy-params.miny)+params.miny

	p.vx = rnd(params.maxstartvx-params.minstartvx)+params.minstartvx
	p.vy = rnd(params.maxstartvy-params.minstartvy)+params.minstartvy
end

function affect_force(p, params)
	p.vx += params.fx
	p.vy += params.fy
end

function affect_forcezone(p, params)
	if (p.x>=params.zoneminx and p.x<=params.zonemaxx and p.y>=params.zoneminy and p.y<=params.zonemaxy) then
		p.vx += params.fx
		p.vy += params.fy
	end
end

function affect_stopzone(p, params)
	if (p.x>=params.zoneminx and p.x<=params.zonemaxx and p.y>=params.zoneminy and p.y<=params.zonemaxy) then
		p.vx = 0
		p.vy = 0
	end
end

function affect_bouncezone(p, params)
	if (p.x>=params.zoneminx and p.x<=params.zonemaxx and p.y>=params.zoneminy and p.y<=params.zonemaxy) then
		p.vx = -p.vx*params.damping
		p.vy = -p.vy*params.damping
	end
end

function affect_attract(p, params)
	if (abs(p.x-params.x)+abs(p.y-params.y)<params.mradius) then
		p.vx += (p.x-params.x)*params.strength
		p.vy += (p.y-params.y)*params.strength
	end
end

function affect_orbit(p, params)
	params.phase += params.speed
	p.x += sin(params.phase)*params.xstrength
	p.y += cos(params.phase)*params.ystrength
end

function draw_ps_fillcirc(ps, params)
	for p in all(ps.particles) do
		c = flr(p.phase*count(params.colors))+1
		r = (1-p.phase)*p.startsize+p.phase*p.endsize
		circfill(p.x,p.y,r,params.colors[c])
	end
end

function draw_ps_pixel(ps, params)
	for p in all(ps.particles) do
		c = flr(p.phase*count(params.colors))+1
		pset(p.x,p.y,params.colors[c])
	end	
end

function draw_ps_streak(ps, params)
	for p in all(ps.particles) do
		c = flr(p.phase*count(params.colors))+1
		line(p.x,p.y,p.x-p.vx,p.y-p.vy,params.colors[c])
	end	
end

function draw_ps_animspr(ps, params)
	params.currframe += params.speed
	if (params.currframe>count(params.frames)) then
		params.currframe = 1
	end
	for p in all(ps.particles) do
		pal(7,params.colors[flr(p.endsize)])
		spr(params.frames[flr(params.currframe+p.startsize)%count(params.frames)],p.x,p.y)
	end
	pal()
end

function draw_ps_agespr(ps, params)
	for p in all(ps.particles) do
		local f = flr(p.phase*count(params.frames))+1
		spr(params.frames[f],p.x,p.y)
	end	
end

function draw_ps_rndspr(ps, params)
	for p in all(ps.particles) do
		pal(7,params.colors[flr(p.endsize)])
		spr(params.frames[flr(p.startsize)],p.x,p.y)
	end	
	pal()
end


__gfx__
000000000088880000cc700000dccc00001ddd0000111d0000010100000001000000000000000000001111000000000000000000000000000000000000000000
00000000088778800c0000000d000070010000c0000000d000000010000000000000000007000000010000100000000000000000000000000000000000000000
0000000088788888d0000000d00000001000000c1000000d000000010000000100000000c0000000100000010000000000000000000000000000000000000000
00000000878888d8d0000000100000000000000c0000000c0000000d0000000170000001c0000000100000010000000000000000000000000000000000000000
00000000878888d8d000000010000000100000070000000c0000000d00000001c0000000c0000000100000010000000000000000000000000000000000000000
0000000088888d881000000010000000000000000000000c0000000d0000000dc0000001d0000001100000010000000000000000000000000000000000000000
00000000088dd88001000000000000000000000000000070000000c0070000d00c0000100d000000010000100000000000000000000000000000000000000000
0000000000888800001010000010000000000000000000000007cc0000cccd0000ddd10000d11100001111000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000cc0000c000000000000000000000077707700000000000000000000000000000000000000000000000000000000000000000000000000
000000000001100000c70c0000c00c00dd0000d00000000007777700000000000000000000000000000000000000000000000000000000000000000000000000
00011000001c01000c7000d00000000000000000100000100077700d7777770d0000000d00000000000000000000000000000000000000000000000000000000
00011000001001000c0001d00000c0000000000010000000007770d0007770d0000000d000000000000000000000000000000000000000000000000000000000
000000000001100000c01d0000c00c0000000000000000000dddd9000dddd9000d77790000000000000000000000000000000000000000000000000000000000
0000000000000000000dd0000000000000d000d00000000000d0d00000d0d0000077700000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000d00010001000000000000000007777770000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000700070707000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00707000007770000007000000707000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a0000077a7700077a7700000a0000007a70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00707000007770000007000000707000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000700070707000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
77707070777077707000777007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70707070707070707000700070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77007070770077007000770077700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70707070707070707000700000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77700770777077707770777077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77700770777007707770777000000000077077707770777077700000777077707770777007707770077077700000000000000000000000000000000000000000
70707000700070007070707000000000707070707070070007000000707070007000700070000700707070700000000000000000000000000000000000000000
777070007700777077707700000c0000707077007700070007000000777077007700770070000700707077000000000000000000000000000000000000000000
7070707070000070700070700700c00c707070707070070007000000707070007000700070000700707070700000000000000000000000000000000000000000
70707770777077007000707070000000770070707770777007000000707070007000777007700700770070700000000000000000000000000000000000000000
000000000000000000000000000000c00000000000000000000000000cc000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000c00c000000000000000000000000c70c00000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000c7000d0000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000c0001d0000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000c01d00000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000dd000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000c70c00000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000c7000d0000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000c0001d0000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000cc000000000000000000c01d00000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000c70c000000000000000000dd000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000c7000d0000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000c0001d0000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000c01d00000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000dd000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000cc0000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000c70c000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000c7000d00000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000c0001d00000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000c01d000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000dd0000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000c00c00000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000cc0000c00c00000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000c70c0000000000000000000000cc000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000c7000d00000000000000000000c70c0000000000000cc00000000000000
000000000000000000000000000000000000000000000000000000000000000000000c0001d0000000000000000000c7000d00000000000c70c0000000000000
0000000000000000000000000000c00000000000000000000000000000000000000000c01d00000000000000000000c0001d0000000000c7000d000000000000
00000000000000000000000000000c00c00000000000000000000000000000000000000dd0000000000000000000000c01d00000000000c0001d000000000cc0
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dd0000000000000c01d000000000c70c
0000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000000000000000000000dd000000000c7000
00000000000000000000000000000c00cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0001
0000000000000000000000000000000c70c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c01d
000000000000000000000000000000c7000d0000000000000000000000cc00000000000000000000000000000000000000000000000000000000000000000dd0
000000000000000000000000000000c0001d000000000000000000000c70c0000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000c01d000000000000000000000c7000d000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000dd0000000000000000000000c0001d000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000c01d0000000000000000000000000000000000000000000000000000000cc0000000000
0000000000000000000000000000000000000000000000000000000000dd0000000000000000000000000000000000000000000000000000000c70c000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c7000d00000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc000c0001d0cc00000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c70c000c01d0c70c0000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c7000d000dd0c7000d000
00000000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000c0001d000000c0001d000
000000000000000000000000000000000000000000000000000000000000000000000c00c00000000000000000000000000000000000c01d00000000c01d0000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dd0000000000dd00000
000000000000000000000000000000000000000000000000000000000cc000000000000c00000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000c70c000000000c00c0000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000c7000d00000000000000000000000000000000000cc0000000000cc000000000000000000
000000000000000000000000000000cc00000000000000000000000c0001d0000000000000000000000000000000000c70c00000000c70c00000000000000000
00000000000000000000000000000c70c00000000000000000000000c01d0000000000000000000000000000000000c7000d000000c7000d0000000000000000
0000000000000000000000000000c7000d00000000000000000000000dd00000000000000000000000000000000000c0001d000000c0001d0000000000000000
0000000000000000000000000c00c0001d0000000000000000000000000000000000000000000000000000000000000c01d00000000c01d00000000000000000
00000000000000000000000000c00c01d00000000000000000000cc00000000000000000000000000000000000000000dd0000000000dd000000000000000000
000000000000000000000000000000dd00000000000000000000c70c000000000000000000000000000000cc0000000000000000000000000000000000000000
0000000000000000000000000000c0000000000000000000000c7000d0000000000000000000000000000c70c000000000000000000000000000000000000000
00000000000000000000000000c00c00000000000cc00000000c0001d000000000000000000000000000c7000d00000000000000000000000000000000000000
0000000000000000000000000000000000000000c70c00000000c01d0000000000000000000000000000c0001d0cc00000000000000000000000000000000000
000000000000000000000000000000000000000cc000d00000cc0dd000000000000000000000000000000c01d0c70c0000000000000000000000000000000000
00000000000000000000000000000000000000c70c01d0000c70c000000000000000000000000000000000dd0c7000d000000000000000000000000000000000
0000000000000000000000000000000000000c70c0dd0000c7000d0000000000000000000000000000000000cc0c01d00000cc00000000000000cc0000000000
000000000000000000000000000000000cc00c0001d00000c0001d000000000000000000000000000000000c70c01d00000c70c000000000000c70c000000000
00000000000000000000000000000000c70c00c01d0000000cc1d0000000000000000000000000000000000c000dd00000c7000d0000000000c7000d00000000
0000000000000000000000000000000c7000d00dd0000000c7dd0000000000000000000000000000000000ccc01d000000c0001d0000000000c0001d00000000
0000000000000000000000000000000c0001d0c70c00000c7000d000000000000cc00000cc00000110000c70cdd00000000c01d000000000000c01d000000000
000000000cc000000000000000000000c01d0c7000d00ccc0001d0c000000000c70c000c70c0001c0100c7000d0000000000dd00000000000000dd0000000000
00000000c70c000000000000000000000dd00c0001d0cc7cc01d000c00c0000c7000d0c7000dcc100100c0001d00000000000000000000000000000000000000
0000000c7000cc000000000000000cc0000000c01d0cc700ddd000000000000c0001d0c0001d70c110000c01d000000000000000000000000000000000000000
0000000c000c70c0000000cc0000c70c0000000dd00cc0011d0000000c000000c01d000c01d7000d000000dd0000000000000000000000000000000000000000
00000000c0c7000d00000cc0c00c7000d00000000000cc11d000000c00c000000dd00110ddc0001d0000000cc000000000000000000000000000000000000000
000000000dc0001d0000c70c0d0c0001d000000000000ddd000000000000000000001c01cc1c01d0000000c70c00000000000000000000000000000000000000
00000000000c01dcc00c7000ddccc01d000000000000000000000000000000000000100c70c0dd0000110c7000d0000000000001100000000000000000000000
000000000000ddc70c0c0c01dc70cdd000000000000000000000000000000000000001c71111cc0001c01c0001d000000000001c010000000000000000000000
0000000000000c7000d0c01dc7000d1100000000000000cc0000000000000000cc0000c001cc10c0010010c01d00000000000010010000000000000000000000
000000000cc00c0001d00dd0c0001dc01000000000000c70c00000000000000c70c0000c01c7100d0011000dd000000000000001100000000000000000cc0000
00000000cc0c00c01d0000000c01d100100000000000c7000d000cc0000000c7000d0000dd11001d00000011000000000000000000000000000000000c70c000
0000000c7cc0d00dd000000000dd0111000000000000c0001d00c7cc000000c0001d0000000c01d00000001100000000000000000000000000000000c7cc0d00
000000c770cdd00011000000001001110000000000000c01d00c700cd110000c01d000000000dd000000000000000000000000000000000000000000cc701d00
000000c7c01d0001c0100000000111c010000000000000dd000c0011d1100000dd000000000000000000000000000000000000000000000000000000cc01dd11
000000cc01dd0001001000000000c10c10000000000000000000c1cd1c11000000000000000000000000000000000000000000000000000000000000c0dd11c0
0000011cddd0000011000000000c7011d000000110000000000001dc11c01000000110000000000000000000000000000000001100000000000000000c01d100
00001c01dd000001c0100000000c0001d000001c010000000000001101001000001c010000000000000000000000000000000011000000000000000000dd0c11
0000100100000001001100000000c01d00000010010000000000000000110000001101000000000000000000000000000000000000000000000000000000c70c
00000110000000001111000000000dd00000000110000011000000000000000000011000000000000000000000000000000000000000000000000000000c7000
000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000c1101
0000000000000000000000000000000000000000000000000000000000000000000000000000001100000000000000000000000000000000000000000000111d
00000000000000000000000000000000000000000000000000000000000000000000000000000011000000000000000000000001100000000000000000000dd0
00000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100000000000000000000000
00000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000000000000000000000000000
00000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000000000000000000000000000
50005550555055500050555055500550505055500000555005500000055050505550550005505550000055005550555005500000000000000000000000000000
50005000500005000500505005005000505005000000050050500000500050505050505050005000000050505000555050500000000000000000000000000000
50005500550005000500550005005000555005000000050050500000500055505550505050005500000050505500505050500000000000000000000000000000
50005000500005000500505005005050505005000000050050500000500050505050505050505000000050505000505050500000000000000000000000000000
55505550500005005000505055505550505005000000050055000000055050505050505055505550000055505550505055000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50500000555005500000055055505550505055000000555055505550555055500550500055500000055050500550555055505550033300000333033303330333
50500000050050500000500050505050505050500000505050505050050005005000500050000000500050505000050050005550030300000003000303030003
05000000050050500000555055505550505050500000555055505500050005005000500055000000555055505550050055005050030300000033033303030033
50500000050050500000005050005050555050500000500050505050050005005000500050000000005000500050050050005050030300000003030003030003
50500000050055000000550050005050555050500000500050505050050055500550555055500000550055505500050055505050033300300333033303330333
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

