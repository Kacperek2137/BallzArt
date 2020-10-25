pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- firework particles
-- this sample code shows
-- how to make firework-style
-- particles

function _init()
 -- crate a table for
 -- particles
 particles={}
end

function _update60()
 if btnp(4) then
  --spawn fireworks at
  --a random position
  boom(rnd(128),rnd(128))
 end
 -- update particles
 updateparticles()
end

function _draw()
 --draw particles
 drawparticles()
 
 --draw hint if there are
 --no particles
 if #particles==0 then
  print("press ❎",50,100,5)
 end
end

function boom(_x,_y)
 -- crate 100 particles at a location
 for i=0,100 do
  spawn_particle(_x,_y)
 end
end

function spawn_particle(_x,_y)
 -- create a new particle
 local new={}
 
 -- generate a random angle
 -- and speed
 local angle = rnd()
 local speed = 1+rnd(2)
 
 new.x=_x --set start position
 new.y=_y --set start position
 -- set velocity based on
 -- speed and angle
 new.dx=sin(angle)*speed
 new.dy=cos(angle)*speed
 
 --add a random starting age
 --to add more variety
 new.age=flr(rnd(25))
 
 --add the particle to the list
 add(particles,new)
end

function updateparticles()
 --iterate trough all particles
 for p in all(particles) do
  --delete old particles
  --or if particle left 
  --the screen 
  if p.age > 80 
   or p.y > 128
   or p.y < 0
   or p.x > 128
   or p.x < 0
   then
   del(particles,p)
  else
  
   --move particle
   p.x+=p.dx
   p.y+=p.dy
   
   --age particle
   p.age+=1
   
   --add gravity
   p.dy+=0.15
  end
 end
end

function drawparticles() 
--iterate trough all particles
 local col
 for p in all(particles) do
  --change color depending on age
  if p.age > 60 then col=2
  elseif p.age > 50 then col=1
  elseif p.age > 40 then col=3
  elseif p.age > 30 then col=10
  elseif p.age > 20 then col=9  
  elseif p.age > 0 then col=8
  else col=7 end
  
  --actually draw particle
  line(p.x,p.y,p.x+p.dx,p.y+p.dy,col)
  
  --you can also draw simpler
  --particles like this
  --pset(p.x,p.y,col)

 end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000009000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000009000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000009000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000900000000000000000000a0000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000009000000000000000000a00a000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000090000000000000000000a0a000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000aa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000a00000000000000000000000000000000000000000000000009000000000000000000000000000000000000000000000
0000000000000000000000000000000a000000000000000000a00000000000000000000000000000000900000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000a0000000000000000000000000000000900000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000a0000000000000000000000000000000090000000000000000000000000000000000000000000
00000000000000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000a00000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000009000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00a000000000000000000000000000900a0000000000000000000900000000000009000000900000000000000000000000000000000000000000000000000000
00a000000000000000000000000009000a00000000000090000009a000000000000090000090000a000000000000000000000000000000000000000000000000
0a000000000000000000000000000000000000000000009000000090000000000000900000090000a00000000000000000000000000000000000000000000000
0a000000000000000000000000000000000000000000009000000090000000000090000000090000a00000000000000000000000000000000000000000000000
00000000000000a00000000000000000000000000000009000000000000000000090000000000000000000000000000000000000000000000000000000000000
00000000000000a00000000000000000000000000000000000000000000000009009000000000000000000000000000000000000000900000000000000000000
0000000000000a0000000000a0000000000000000000000000000000000a00009009000000000000000000000000000000000000000090000000000000000000
0000000000000a0000000000a00000000000000000000000000000000000a0000900000000000000000000000000000000000000000009000000000000000000
00000000000000000000000a000000000000000000000000000000000000a0000900000000000000000000000000000000000000000000900000000000000000
00000000000000000000000a0000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000009000000000000000000a0000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000900000000000000000000000000000000a00000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000900000000000000000000000000000000a0000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000a9000000000000000000000000000000000a000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000a000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000a00000000000000a0000000000000000000a00000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000a00000000000000a000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000
00000000000000a00000000000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000
00000000000000a00000000000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000
0000000000000a0000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000
0000000000000a0000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000a0000000a000000000000000a0000000000000000000000a0000000000000000
0000000000000000000000000000000000000000000000000000000000000000a0000000a000000000000000a00000000000000000000000a000000000000000
00000000000000000000000000000000000000000000000000000000000000000a0000000a000000000000000000000000000000000000000a00000000000000
0000000000000a000000000000000000000000000000000000000000000000000a0000000a0000000000000000000000000000000000000000a0000000000000
0000000000000a000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000a00000000000000000000
0000000000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000
000000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000a000000000000000000
000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000a00000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000
00000090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000900000a00000000000000000000000000
00000090000090000000000000000000000000000000000000000000000000000000000000000000000000000000000090000a00000000000000000000000000
00000090000090000000000000000000000000000000000000000000000000000000000000000000000000000000000090000000000000000000000000000000
00000900000090000000000000000000000000000000000000000000000000000000000000000000000000000000000009000000000000000000000000000000
000009000009000000000000000000000000000000000000000000000000000000000000a0000000000000000000000009000000000000000000000000000000
000000000009000000000000000000000000000000000000000000000000000a00000000a00000000000000000a0000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000a000000000a00000000000000000a000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000a000000000a00000000000000000a000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000a00000000a000000000000000000a00000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000a00000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000a000000a000000000000000000000000a00000000000000000000000000000000000000
00000a000000000000000000000000000000000000000000000000000a0000000000000000000000000000000a00000000000000000000000000000000000000
00000a000000000000000000000000000000000000000000000000000a00000000000000000000a00000000000a0000000000000000000000000000000000000
0000a0000000000000000000000000000000000000000000000000000a00000000000000000000a00000000000a0000000000000000000000000000000000000
0000a0000000000000000000000000000000000000000000000000000a00000000000000000000a000000000000a000000000000000000000000000000000000
000a00000000000000000000000000000000000000000000000000000a000000000000000000000a00000000000a000000000009000000000000000000000000
00000000000000000000000000000000a0000000000000000000000000000000000000000000000a000000000000000000000009000000000000000000000000
00000000000000000000000000000000a0000000000000000000000000000000000000000000000a000000000000000000000000900000000000000000000000
00000000000000000000000000000000a00000000000900000000000000000000000000000000000000000000000000000000000900000000000000000000000
00000000000000000000000000000000a000000a0000900000000000000000000000000000000000000000000000000000000000090000000000000000000000
00000000000000000000000000000000a000000a0000900000000000000000000000000000000000000000000000000000000000090000000000000000000000
00000000000000000000000000000000a000000a0000900000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a000000a0000000000000000000000000000a00009000000000000000000000000000000000000000000000000000000000000a0000000000000000000000
000a000000a0000000000000000000000000000a000090900000000000000000000000000000000000000000000000000000000000a000000000000000000000
000a000000a0000000000000000000000000000a0000009000000000000000000000000000000000000000000000000000000000000a00000000000000000000
00a000000a0000000000000000000000000000090000009000000000000000000000000000000000000000000000000000000000a00a00000000000000000000
00a000000a0000000000000000a0a0000000000900000090000000000000000000000000000000000000000000000000000000000a00a0000000000000000000
00a000000a0000000000000000a0a0000000000900000090000000000000000000000000000000000000000000000000000000000a0000000000000000000000
00000000a00000000000000000a0a00000000009000000900000000000000000000000000000000000000000000000000000000000a000000000000000000000
00000000a00000000000000000a0a000000000090000000000000000000000000000000000000000a0000000000000000000000000a000000000000000000000
00000000a00000000000000000a0a000000000090000000000000000000000000000000000000000a00000000000000000000000000a00000000000000000000
0000000a000000000000000000a0a0000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000
0000000a0000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000900000000000000000000000000000000000000000000000000a0000000000000000000000000000000
000000000000000000000000000000000000000000000900000000000000000000000000000000000000000000000000a0000000000000000000000000000000
0000000000000000000000000000000000000000000009000000000000000000000000000000000000000000000000000a000000000000000000000000000000
0000000000000000000000000000000000000000000009000000000000000000000000000000000000000000000000000a000000000000000000000000000000
00000000000000000000900000000000000000000000090000000000000000000000000000000000000000000000000000a00000000000000000000000000000
00000000000000000000900000000000000000000000090000000000000000000000000000000000000000000000000000a00000000000000000000000000000
00000000000000000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000009000000000000000000000000000000000000000000000a000a0000000000000000000000000000000000000000000000000000000000
00000000000000000009000000000000000000a00000000000000000000000000a000a0000000000000000000000000000000000000000000000000000000000
00000000000000000009000000000000000000a00000000000000000000000000a0000a000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000a00000000000000000000000000a0000a000000000000000000000000000000000000000000000000000000000
000000000000000a0000000000000000000000a000000009000009000000000000a000a000009000000000000000000000000000000000000000000000000000
000000000000000a0000000000000000000000a000000009000009000000000000a0000a00009000000000000000000000000000000000000000000000000000
000000000000000a0000000000000000000000a000000009000a09000000000000a0000a00000900000000000000000000000000000000000000000000000000
000000000000000a0000000000000000000000a000000009000a09a0000000000000000000000900000000000000000000000000000000000000000000000000
00000000000000a000000000000000000000000000000009000a09a0000000000000000000000900000000000000000000000000000000000000000000000000
00000000000000a000000000000000000000000000000009000a09a0000000000000000000000090000000000000000000000000000000000000000000000000
00000000000000a000000a000000000000000000000000090000a9a0000000000000000000000090000000000000000000000000000000000000000000000000
000000000000000000000a000000000000000000000000000000a0a0000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000a0000000000000000000000000000000a0a0000000000000000000000000000000000000000000000000000000000000000000000000

