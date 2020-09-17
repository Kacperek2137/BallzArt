pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- breakout hero (beta)
-- by layz devs

-- sash confusing
-- ? difficult to redirect the ball

function _init()
 pirate=false
 ver,url="v1",stat(102)
 if (url!="www.lexaloffle.com" and url!="v6p9d9t4.ssl.hwcdn.net" and url!="game.itch" and url!="www.playpico.com" and url!="uploads.ungrounded.net" and url!="game296454.konggames.com" and url!=0) pirate=true
 
 cartdata("layzdevs_hero1_v2")
 cls()
 screenbox={left=126,
            right=1,
            top=140,
            bottom=7}
 
 mode="logo"
 lcnt=0
 level=""
 debug=""
 levelnum = 1
 levels={}
 loadlevels()
 startlives=4
 fastmode=false
 sd_brick=nil
 sd_timer=0
 sd_thresh=3
 shake=0
 
 blink_g,blink_g_i=7,1
 blink_w,blink_w_i=7,1
 blink_b,blink_b_i=7,1
 blink_r,blink_r_i=12,1

 
 blinkframe=0
 blinkspeed=8
 
 fadeperc=1
 
 startcountdown=-1
 govercountdown=-1
 goverrestart=false
 arrm=1
 arrm2=1
 arrmframe=0
 
 --particles
 part={}
 
 lasthitx=0
 lasthity=0
 
 spdwind=0 -- speedline windup
 
 --highscrore 
 hs,hst,hs1,hs2,hs3={},{},{},{},{}
 hsb={true,false,false,false,false}
 --reseths()
 loadhs()

 hschars={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"} 
 hs_x=128
 hs_dx=128
 loghs=false
 --typing in intitals
 nitials={1,1,1}
 nit_sel=1
 --sash
 sash_w,sash_dw,sash_tx,sash_tdx,sash_c,sash_tc,sash_text,sash_frames,sash_v,sash_delay_w,sash_delay_t,infcounter=0,0,0,0,8,7,"ohai",0,false,0,0,0
 
 sick={
       "so sick!",
       "yeeee boiii!",
       "impressive!",
       "i can't even...",
       "it's lit!",
       "mah dude!",
       "c-c-combo!",
       "winning!",
       "niiiice!",
       "woah!",
       "seriously now?",
       "maximum pwnage!"
      }
 
 -- music
 music(1)
end

function startgame()
 levelnum=1
 level=levels[levelnum]
 restartlevel()
end

function restartlevel()
 mode="game"
 ball_r=2
 ball_dr=0.5
 ball_spd=1
 if (fastmode) ball_spd=1.5
  
 pad_x,pad_y,pad_dx,pad_wo,pad_w,pad_h,pad_c=64,120,0,24,24,6,7

 pad_dy = 0

 brick_w,brick_h=9,4
 
 buildbricks(level)
 
 lives,points,points2,sticky,chain=startlives,0,0,false,1
 
 timer_mega=0
 timer_mega_w=0
 
 timer_slow=0
 timer_expand=0
 timer_reduce=0
 
 showsash("stage "..levelnum,0,7)
 serveball()
end

function nextlevel()
 mode="game"
 pad_x,pad_y,pad_dx=52,120,0
 levelnum+=1
 if levelnum > #levels then
  wingame()
  return
 end
 level=levels[levelnum]
 buildbricks(level)
 
 chain=1
 sticky = false
 timer_mega,timer_mega_w,timer_slow,timer_expand,timer_reduce=0,0,0,0,0
 
 showsash("stage "..levelnum,0,7)
 serveball()
end

function buildbricks(lvl)
 local i,j,o,chr,last
 bricks={}
 
 j=0
 -- b=normal brick
 -- x=empty space
 -- i=indestructable brick
 -- h=hardened brick
 -- s=sploding brick
 -- p=powerup brick
 
 for i=1,#lvl do
  j+=1
  chr=sub(lvl,i,i)  
  if chr=="b" 
  or chr=="i" 
  or chr=="h"
  or chr=="s"
  or chr=="p" then
   last=chr
   addbrick(j,chr)  
  elseif chr=="x" then
   last="x"
  elseif chr=="/" then
   j=(flr((j-1)/11)+1)*11
  elseif chr>="1" and chr<="9" then
   for o=1,chr+0 do
    if last=="b" 
    or last=="i" 
    or last=="h"
    or last=="s"
    or last=="p" then
    	addbrick(j,last)
    elseif last=="x" then
     --nothing
    end
    j+=1
   end
   j-=1
  end 
 end
end

function resetpills()
 pill={}
end

function addbrick(_i,_t)
 local _b = {
   x=4+((_i-1)%11)*(brick_w+2),
   y=11+flr((_i-1)/11)*(brick_h+2),
   v=true,
   t=_t,
   fsh=0,
   ox=0,
   oy=-(128+rnd(128)),
   dx=0,
   dy=rnd(64),
   hp=1,
 }
 if _t=="h" then
  _b.hp=2
 end
 add(bricks,_b)
end

function levelfinished()
 if #bricks == 0 then return true end 
 for i=1,#bricks do
  if (bricks[i].v == true and bricks[i].t != "i") return false
 end
 return true
end

function serveball()
 ball={}
 ball[1] = newball()
 local mb=ball[1]
 mb.x=pad_x
 mb.y=pad_y-ball_r
 mb.dx=1
 mb.dy=-1
 mb.ang=1
 mb.stuck=true

 sd_brick=nil
 pointsmult=1
 chain=1
 timer_mega=0
 timer_mega_w=0
 timer_slow=0
 timer_expand=0
 timer_reduce=0

 resetpills()
 
 sticky_x=0
 sticky=false
end

function newball()
 return {
   x = 0,
   y = 0,
   dx = 0,
   dy = 0,
   ang = 1,
   stuck = false,
   rammed = false,
   colcount=0,
   collast=nil
 }
end

function copyball(ob)
 return {
   x=ob.x,
   y=ob.y,
   dx=ob.dx,
   dy=ob.dy,
   ang=ob.ang,
   stuck=ob.stuck,
   rammed=ob.rammed,
   colcount=ob.colcount,
   collast=ob.collast
   }
end

function setang(bl,ang)
 bl.ang=ang
 if ang==2 then
  bl.dx=0.50*sign(bl.dx)
  bl.dy=1.30*sign(bl.dy)  
 elseif ang==0 then
  bl.dx=1.30*sign(bl.dx)
  bl.dy=0.50*sign(bl.dy) 
 else
  bl.dx=1*sign(bl.dx)
  bl.dy=1*sign(bl.dy)
 end
end

function multiball()
 local ballnum = flr(rnd(#ball))+1
 local ogball = ball[ballnum]
 
 ball2 = copyball(ogball)

 if ogball.ang==0 then
  setang(ball2,2)
 
 elseif ogball.ang==1 then
  setang(ogball,0)
  setang(ball2,2)
 else
  setang(ball2,0)
 end
 
 ball2.stuck=false
 ball[#ball+1]=ball2
end

function sign(n)
 if n<0 then
  return -1
 elseif n>0 then
  return 1
 else
  return 0
 end
end

function gameover()
 music(7)
 mode="gameoverwait"
 govercountdown=60
 blinkspeed=16
 resethsb()
end

function levelover()
 music(6)
 mode="leveloverwait"
 govercountdown=60
 blinkspeed=16
end

function wingame()
 music(8)
 mode="winnerwait"
 govercountdown=60
 blinkspeed=16
 
 if points2>hst[5] or (points2==hst[5] and points>hs[5]) then
  loghs=true
  nit_sel=1
  nit_conf=false
 else
  loghs=false
  resethsb()
 end
end

function releasestuck()
 for i=1,#ball do
  if ball[i].stuck then
   ball[i].x=mid(3,ball[i].x,124)
   ball[i].stuck=false
  end
 end
end

function pointstuck(sign)
 for i=1,#ball do
  if ball[i].stuck then
   ball[i].dx=abs(ball[i].dx)*sign
  end
 end
end

function powerupget(_p)
 if _p == 1 then
  -- slowdown
  timer_slow = 400
  showsash("slowdown!",9,4)
 elseif _p == 2 then
  -- life
  lives+=1
  showsash("extra life!",7,6)
 elseif _p == 3 then
  -- catch
  hasstuck=false
  for i=1,#ball do
   if ball[i].stuck then
    hasstuck=true
   end
  end
  if hasstuck==false then
   sticky = true
  end
  showsash("sticky paddle!",11,3)
 elseif _p == 4 then
  -- expand
  timer_expand = 600
  timer_reduce = 0
  showsash("expand!",12,1)
 elseif _p == 5 then
  -- reduce
  timer_reduce = 600
  timer_expand = 0
  showsash("reduce!",0,8)
 elseif _p == 6 then
  -- megaball
  timer_mega_w=600
  timer_mega=0
  showsash("megaball!",8,2)
 elseif _p == 7 then
  -- multiball
  multiball()
  showsash("multiball!",10,9)
 end
end

function hitbrick(_b,_combo)
 local fshtime=10

 if _b.t=="s" or _b==sd_brick then
  megaballsmash()
  infcounter=0
  -- sposion brick
  sfx(2+chain)
  shatterbrick(_b,lasthitx,lasthity)
  _b.t="zz"
  
  if _b==sd_brick then
   getpoints(10)
   sd_brick=nil
  else
   getpoints(1)  
  end
  if (_combo) boostchain()
 elseif _b.t=="b" then
  megaballsmash()
  infcounter=0
  -- regular brick
  sfx(2+chain)
  --spawn particles
  shatterbrick(_b,lasthitx,lasthity)
  _b.fsh=fshtime
  _b.v=false
  if _combo then
   getpoints(1)
   boostchain()
  end
 elseif _b.t=="i" then
  --invincible brick
  sfx(10)
 elseif _b.t=="h" then
  megaballsmash()
  infcounter=0
  -- hardened brick  
  if timer_mega>0 then
   sfx(2+chain)
   shatterbrick(_b,lasthitx,lasthity)
   _b.fsh=fshtime
   _b.v=false
   if _combo then
    getpoints(1)
    boostchain()
   end
  else
   sfx(10)
   _b.fsh=fshtime
   --bump the brick
   _b.dx = lasthitx*0.25
   _b.dy = lasthity*0.25
   _b.hp-=1
   if _b.hp<=0 then
    _b.t="b"
   end
  end
 elseif _b.t=="p" then
  megaballsmash()
  infcounter=0
  -- powerup brick
  sfx(2+chain)
  --spawn particles
  shatterbrick(_b,lasthitx,lasthity)
  _b.fsh=fshtime
  _b.v=false
  if _combo then
   getpoints(1)
   boostchain()
  end
  spawnpill(_b.x,_b.y)
 end
end

-- increase chain by one
function boostchain()
 if chain==6 then
  local _si=1+flr(rnd(#sick))
  sfx(44)
  showsash(sick[_si],-1,1)
 end
 chain+=1
 chain=mid(1,chain,7)
end

-- get points
function getpoints(_p)
 if (fastmode) _p=_p*2
 if timer_reduce<=0 then
  points+=_p*chain*pointsmult
 else
  points+=(_p*chain*pointsmult)*10
 end
 if points>=10000 then
  points2+=1
  points-=10000
 end
 
end

function megaballsmash()
 if timer_mega_w>0 then
  timer_mega_w=0
  timer_mega=120
 end
end

function spawnpill(_x,_y)
 local _t = flr(rnd(7))+1
 add(pill,{
  x=_x,
  y=_y,
  t=_t
  })
end

function checkexplosions()
 for i=1,#bricks do
  if bricks[i].t == "zz" and bricks[i].v then
   bricks[i].t="z"
  end
 end
 
 for i=1,#bricks do
  if bricks[i].t == "z" and bricks[i].v then
   explodebrick(i)
   spawnexplosion(bricks[i].x,bricks[i].y)
   if shake<0.4 then
    shake+=0.1
			end
  end
 end
 
 for i=1,#bricks do
  if bricks[i].t == "zz" then
   bricks[i].t="z"
  end
 end
end

function explodebrick(_i)
 bricks[_i].v=false
 for j=1,#bricks do
  if j!=_i
  and bricks[j].v
  and abs(bricks[j].x-bricks[_i].x) <= (brick_w+2)
  and abs(bricks[j].y-bricks[_i].y) <= (brick_h+2)
  then
   hitbrick(bricks[j],false)
  end  
 end
end

function box_box(box1_x,box1_y,box1_w,box1_h,box2_x,box2_y,box2_w,box2_h)
 if box1_y > box2_y+box2_h then return false end
 if box1_y+box1_h < box2_y then return false end
 if box1_x > box2_x+box2_w then return false end
 if box1_x+box1_w < box2_x then return false end
 return true
end

function check_sd()
 local c=0
 if (sd_brick!=nil) return 
 for i=1,#bricks do
  if (bricks[i].v==true and bricks[i].t != "i") c+=1
  if (c>sd_thresh) return
 end
 if (c<=sd_thresh) trigger_sd()
end

function trigger_sd()
 for i=1,#bricks do
  if bricks[i].v == true and bricks[i].t != "i" then
   sd_brick=bricks[i]
   showsash("sudden death!",2,8)
   sd_timer=450
   sd_blinkt=sd_timer/10
   sd_brick.fsh=4
   sfx(29)
  end
 end 
end

function update_sd()
 if sd_brick!=nil then
  sd_timer-=1
  if sd_timer<1 then
   sd_brick.t="zz"
   sd_brick=nil
   return
  end
  sd_blinkt-=1
  
  if sd_blinkt<1 then  
   sd_brick.fsh=4
   sd_blinkt=sd_timer/10
   sfx(29)
  end
  
 end
end
-->8
-- juicy stuff --

function showsash(_t,_c,_tc)
 sash_w=0
 sash_dw=4
 sash_c=_c
 sash_text=_t
 sash_frames=0
 sash_v=true
 sash_tx=-#sash_text*4
 sash_tdx=64-(#sash_text*2)
 sash_delay_w=0
 sash_delay_t=5
 sash_tc=_tc
 
end

function doshake()
 local shakex,shakey=16-rnd(32),16-rnd(32)
  
 camera(shakex*shake,shakey*shake)
 
 shake=shake*0.95
 if shake<0.05 then
  shake=0
 end
end

function doblink()
 local g_seq = {3,11,7,11}
 local w_seq = {5,6,7,6}
 local b_seq = {9,10,7,10,9}
 local r_seq = {8,9,10,11,12}
 blinkframe+=1 
 if blinkframe>blinkspeed then
  blinkframe=0

  blink_g_i+=1
  if blink_g_i > #g_seq then
   blink_g_i=1
  end
  blink_g=g_seq[blink_g_i]
  
  blink_w_i+=1
  if blink_w_i > #w_seq then
   blink_w_i=1
  end
  blink_w=w_seq[blink_w_i]
  
  blink_b_i+=1
  if blink_b_i > #b_seq then
   blink_b_i=1
  end
  blink_b=b_seq[blink_b_i]
  
  blink_r=r_seq[flr(#r_seq*rnd()+1)]
 end
 
 -- trajectory preview anim
 -- first dot
 arrmframe+=1
 if arrmframe>30 then
  arrmframe=0
 end
 arrm=1+(2*(arrmframe/30))
 -- second dot
 local af2=arrmframe+15
 if af2>30 then
  af2 = af2-30
 end
 arrm2=1+(2*(af2/30))
 
end

-- fading
function fadepal(_perc)
 -- 0 means normal
 -- 1 is completely black
 
 local p=flr(mid(0,_perc,1)*100)
 
 local kmax,col,dpal,j,k
 dpal={0,1,1, 2,1,13,6,
          4,4,9,3, 13,1,13,14}
 
 for j=1,15 do
  col = j
  kmax=(p+(j*1.46))/22  
  for k=1,kmax do
   col=dpal[col]
  end
  pal(j,col,1)
 end
end

-- particle stuff
function addpart(_x,_y,_dx,_dy,_type,_maxage,_col,_s)
 add(part,{
   x=_x,
   y=_y,
   dx=_dx,
   dy=_dy,
   tpe=_type,
   mage=_maxage,
   age=0,
   col=_col[1],
   colarr=_col,
   rot=0,
   rottimer=0,
   s=_s,
   os=_s
 })
end

function spawnpuft(_x,_y)
 for i= 0,5 do
  local _ang = rnd()
  local _dx = sin(_ang)*1
  local _dy = cos(_ang)*1
  addpart(_x,_y,_dx,_dy,2,15+rnd(15),{7,6,5},1+rnd(2))
 end
end

function spawnpillpuft(_x,_y,_p)
 for i= 0,20 do
  local _ang = rnd()
  local _dx = sin(_ang)*(1+rnd(2))
  local _dy = cos(_ang)*(1+rnd(2))
  local _mycol
  
  if _p == 1 then
   -- slowdown -- orange
   _mycol={9,9,4,4,0}
  elseif _p == 2 then
   -- life -- white
   _mycol={7,7,6,5,0}
  elseif _p == 3 then
   -- catch -- green
   _mycol={11,11,3,3,0}
  elseif _p == 4 then
   -- expand -- blue
   _mycol={12,12,5,5,0}
  elseif _p == 5 then
   -- reduce -- black
   _mycol={0,0,5,5,6}
  elseif _p == 6 then
   -- megaball -- red
   _mycol={8,8,4,2,0}
  else
   -- multiball -- yellow
   _mycol={10,10,9,4,0}
  end  
  addpart(_x,_y,_dx,_dy,2,20+rnd(15),_mycol,1+rnd(4))
 end
end

function spawndeath(_x,_y)
 for i= 0,30 do
  local _ang = rnd()
  local _dx = sin(_ang)*(2+rnd(4))
  local _dy = cos(_ang)*(2+rnd(4))
  local _mycol
  
  _mycol={10,10,9,4,0}
  addpart(_x,_y,_dx,_dy,2,80+rnd(15),_mycol,3+rnd(6))
 end
end

function spawnexplosion(_x,_y)
 sfx(14)
 for i= 0,20 do
  local _ang = rnd()
  local _dx = sin(_ang)*(rnd(4))
  local _dy = cos(_ang)*(rnd(4))
  local _mycol
  _mycol={0,0,5,5,6}
  addpart(_x,_y,_dx,_dy,2,80+rnd(15),_mycol,3+rnd(6))
 end
 for i= 0,30 do
  local _ang = rnd()
  local _dx = sin(_ang)*(1+rnd(4))
  local _dy = cos(_ang)*(1+rnd(4))
  local _mycol
  _mycol={7,10,9,8,5}
  addpart(_x,_y,_dx,_dy,2,30+rnd(15),_mycol,2+rnd(4))
 end
 
end

function spawntrail(_x,_y)
 if rnd()<0.5 then
  local _ang = rnd()
  local _ox = sin(_ang)*ball_r*0.3
  local _oy = cos(_ang)*ball_r*0.3
 
  addpart(_x+_ox,_y+_oy,0,0,0,15+rnd(15),{10,9},0)
 end
end

function spawnspeedline(_x,_y)
 if rnd()<0.2 then
  local _ox = rnd() * 2.5
  local _oy = rnd() * pad_h
 
  addpart(_x+_ox,_y+_oy,pad_dx,0,6,10+rnd(15),{13},2+rnd(4))
 end
end

function spawnmtrail(_x,_y)
 if rnd() then
  local _ang = rnd()
  local _ox = sin(_ang)*ball_r
  local _oy = cos(_ang)*ball_r
 
  addpart(_x+_ox,_y+_oy,0,0,2,60+rnd(15),{8,2,0},1+rnd(1))
 end
end

function shatterbrick(_b,_vx,_vy)
 if shake<0.5 then
  shake+=0.07
 end
 sfx(13)
 
 _b.dx = _vx*1
 _b.dy = _vy*1
 for _x= 0,brick_w do
  for _y= 0,brick_h do
   if rnd()<0.5 then
    local _ang = rnd()
    local _dx = sin(_ang)*rnd(2)+(_vx/2)
    local _dy = cos(_ang)*rnd(2)+(_vy/2)

    addpart(_b.x+_x,_b.y+_y,_dx,_dy,1,80,{7,6,5},0)
   end
  end
 end
 
 local chunks=1+flr(rnd(10))
 if chunks>0 then
  for i=1,chunks do
   local _ang = rnd()
   local _dx = sin(_ang)*rnd(2)+(_vx/2)
   local _dy = cos(_ang)*rnd(2)+(_vy/2)
   local _spr = 16 + flr(rnd(14))
   addpart(_b.x,_b.y,_dx,_dy,3,80,{_spr},0)
   
  end
 end
 
end
--particles
-- type 0 - static pixel
-- type 1 - gravity pixel
-- type 2 - ball of smoke
-- type 3 - rotating sprite
-- type 4 - blue rotating sprite
-- type 5 - gravity smoke
-- type 6 - speedline

function updateparts()
 local _p
 for i=#part,1,-1 do
  _p=part[i]
  _p.age+=1
  if _p.age>_p.mage then
   del(part,part[i])
  elseif _p.x < -20 or _p.x > 148 then
   del(part,part[i])
  elseif _p.y < -20 or _p.y > 148 then
   del(part,part[i])  
  else
   -- change colors
   if #_p.colarr==1 then
    _p.col = _p.colarr[1]
   else
    local _ci=_p.age/_p.mage
    _ci=1+flr(_ci*#_p.colarr)
    _p.col = _p.colarr[_ci]
   end
   
   --appy gravity
   if _p.tpe == 1 or _p.tpe == 3 then
    _p.dy+=0.05
   end
 
   --appy low gravity
   if _p.tpe == 5 then
    if abs(_p.dy)<1 then
     _p.dy+=0.01
    end
   end
 
   
   --rotate
   if _p.tpe == 3 or _p.tpe == 4 then
    _p.rottimer+=1
    if _p.rottimer>5 then
     _p.rot+=1
     if _p.rot>=4 then
      _p.rot=0
     end
    end
   end
   
   --shrink
   if _p.tpe == 2 or _p.tpe == 5 or _p.tpe == 6 then
    local _ci=1-(_p.age/_p.mage)
    _p.s=_ci*_p.os
   end
   
   --friction
   if _p.tpe == 2 or _p.tpe == 6 then
			 _p.dx=_p.dx/1.2
			 _p.dy=_p.dy/1.2
   end
   
   --move particle
   _p.x+=_p.dx
   _p.y+=_p.dy
  end
 end  
end

-- big particle drawer
function drawparts()
 for i=1,#part do
  _p=part[i]
  -- pixel particle
  if _p.tpe == 0 or _p.tpe == 1 then
   pset(_p.x,_p.y,_p.col)
  elseif _p.tpe == 2 or _p.tpe == 5 then
   circfill(_p.x,_p.y,_p.s,_p.col)
  elseif _p.tpe == 3 or _p.tpe == 4 then
   local _fx,_fy
   if _p.tpe == 3 then
    if _p.rot==2 then
     _fx=false
     _fy=true
    elseif _p.rot==3 then
     _fx=true
     _fy=true
    elseif _p.rot==4 then
     _fx=true
     _fy=false
    else
     _fx=false
     _fy=false
    end
   elseif _p.tpe == 4 then
    pal(7,1) 
   end
   spr(_p.col,_p.x,_p.y,1,1,_fx,_fy)
   pal()
  elseif _p.tpe == 6 then
   if _p.dx<0 then
    line(_p.x,_p.y,_p.x+_p.s,_p.y,_p.col)
   else
    line(_p.x-_p.s,_p.y,_p.x,_p.y,_p.col)   
   end 
  end
 end  
end

function animatebricks()
 for i=1,#bricks do
  local _b=bricks[i]
  if _b.v or _b.fsh>0 then
   if _b.dx~=0 or _b.dy~=0 or _b.ox~=0 or _b.oy~=0 then
    _b.ox+=_b.dx
    _b.oy+=_b.dy
   
    _b.dx-=_b.ox/10
    _b.dy-=_b.oy/10
   
    if abs(_b.dx)>(_b.ox) then
     _b.dx=_b.dx/1.3
    end
    if abs(_b.dy)>(_b.oy) then
     _b.dy=_b.dy/1.3
    end
   
    if abs(_b.ox)<0.2 and abs(_b.dx)<0.25 then
     _b.ox=0
     _b.dx=0
    end
    if abs(_b.oy)<0.2 and abs(_b.dy)<0.25 then
     _b.oy=0
     _b.dy=0
    end
    
   end
  end
 end
end

function startparts()
 for i=0,300 do
  spawnbgparts(false,i)
 end
end

function spawnbgparts(_top,_t)
 if _t%30==0 then
  if partrow==0 then
   partrow=1
  else
   partrow=0
  end
  for i=0,8 do
   if _top then
    _y=-8
   else
    _y=-8+0.4*_t
   end
   if (i+partrow)%2==0 then
    addpart(i*16,_y,0,0.4,0,10000,{1},0)
   else 
    local _spr = 16 + flr(rnd(14))
    addpart((i*16)-4,_y-4,0,0.4,4,10000,{_spr},0)
   end 
  end
 end
 if _t%15==0 then
  if _top then
   _y=-8
  else
   _y=-8+0.8*_t
  end
  for i=0,8 do
   addpart(8+i*16,_y,0,0.8,0,10000,{1},0)
  end
 end
end
-->8
-- update functions

function _update60()
 doblink()
 doshake()
 updateparts()
 update_sash()
 if mode=="game" then
  update_game()
 elseif mode=="logo" then
  update_logo()  
 elseif mode=="start" then
  update_start()
 elseif mode=="gameover" then
  update_gameover()
 elseif mode=="gameoverwait" then
  update_gameoverwait()
 elseif mode=="levelover" then
  update_levelover()
 elseif mode=="leveloverwait" then
  update_leveloverwait()
 elseif mode=="winner" then
  update_winner()
 elseif mode=="winnerwait" then
  update_winnerwait() 
 end
end

function update_sash()
 if sash_v then
  sash_frames+=1
  if sash_delay_w>0 then
   sash_delay_w-=1 
  else
   sash_w+=(sash_dw-sash_w)/5
   if abs(sash_dw-sash_w)<0.3 then
    sash_w=sash_dw
   end
  end
  --animate text
  if sash_delay_t>0 then
   sash_delay_t-=1
  else 
   sash_tx+=(sash_tdx-sash_tx)/10
   if abs(sash_tx-sash_tdx)<0.3 then
    sash_tx=sash_tdx
   end
  end
  --make sash go away
  if sash_frames==75 then
   sash_dw=0
   sash_tdx=160
   sash_delay_w=15
   sash_delay_t=0
  end
  if sash_frames>115 then
   sash_v=false
  end
 end
end

function update_logo()
 lcnt+=1
 if lcnt<100 then
  fadeto(0)
 else
  fadeto(1)
  if fadeperc==1 then
   gotostart()
  end
 end 
end

function gotostart()
 part={}
 mode="start"
 parttimer=0
 partrow=0
 startparts()
end

function update_winnerwait()
 govercountdown-=1
 if govercountdown<=0 then
  govercountdown= -1
  blinkspeed=4
  mode="winner"
 end
end

function update_winner()
 local _ang = rnd()
 local _dx = sin(_ang)*(rnd(0.5))
 local _dy = cos(_ang)*(rnd(0.5))
 local _mycol={12,12,5,5,0}
 local _toprow=40
 local _btnrow=_toprow+52
 
 addpart(flr(rnd(128)),_toprow,_dx,_dy,5,120+rnd(15),_mycol,3+rnd(6))
 addpart(flr(rnd(128)),_btnrow,_dx,_dy,5,120+rnd(15),_mycol,3+rnd(6))
  
 if govercountdown<0 then
  if loghs then
   if btnp(0) then
    sfx(17)
    nit_sel-=1
    if nit_sel<1 then 
     nit_sel = 4
    end
   end
   if btnp(1) then
    sfx(17)
    nit_sel+=1
    if nit_sel>4 then 
     nit_sel = 1
    end
   end
   if btnp(2) then
    if nit_sel<4 then
     sfx(16)
     nitials[nit_sel]-=1
     if nitials[nit_sel]<1 then 
      nitials[nit_sel]=#hschars
     end
    end
   end
   if btnp(3) then
    if nit_sel<4 then
     sfx(16)
     nitials[nit_sel]+=1
     if nitials[nit_sel]>#hschars then 
      nitials[nit_sel]=1
     end
    end
   end
   if btnp(5) then
    if nit_sel==4 then
     addhs(points,points2,nitials[1],nitials[2],nitials[3])
     savehs()
     govercountdown=80
     blinkspeed=1
     sfx(15)     
    end
   end
  else
   if btnp(4) then
    govercountdown=80
    blinkspeed=1
    sfx(15)
   end
  end
 else
  govercountdown-=1
  fadeperc=(80-govercountdown)/80
  if govercountdown<=0 then
   govercountdown= -1
   blinkspeed=8
   gotostart()
   hs_x=128
   hs_dx=0
  end 
 end
end

function update_start()
 -- raining particles
 parttimer=parttimer+1

 spawnbgparts(true,parttimer)
 --slide the high score list
 if hs_x~=hs_dx then
  hs_x+=(hs_dx-hs_x)/5
  if abs(hs_dx-hs_x)<0.3 then
   hs_x=hs_dx
  end
 end
 
 if startcountdown<0 then
  -- fade in game
  fadeto(0)
  if not(pirate) then
   if btnp(5) then
    startcountdown=80
    blinkspeed=1
    sfx(12)
    music(-1,2000)
   end
   if btnp(3) or btnp(2) then
    fastmode=not fastmode
    sfx(16)
   end
   if btnp(0) then
    if hs_dx==128 then
     hs_dx=0
     sfx(20)
    end
   end
   if btnp(1) then
    if hs_dx==0 then
     hs_dx=128
     sfx(20)
    end
   end
  end
 else
  startcountdown-=1
  fadeperc=(80-startcountdown)/80
  if startcountdown<=0 then
   startcountdown= -1
   blinkspeed=8
   part={}
   startgame()
  end
 end
end

function update_gameover()
 local _ang = rnd()
 local _dx = sin(_ang)*(rnd(0.3))
 local _dy = cos(_ang)*(rnd(0.3))
 local _mycol={0,0,2,8}
 local _toprow=60
 local _btnrow=81
 
 addpart(flr(rnd(128)),_toprow,_dx,_dy,5,70+rnd(15),_mycol,3+rnd(6))
 addpart(flr(rnd(128)),_btnrow,_dx,_dy,5,70+rnd(15),_mycol,3+rnd(6))

 if govercountdown<0 then
  if btnp(5) or btnp(1) then
   govercountdown=80
   blinkspeed=1
   sfx(12)
   goverrestart=true
  end
  if btnp(4) or btnp(0) then
   govercountdown=80
   blinkspeed=1
   sfx(12)
   goverrestart=false
  end
 else
  govercountdown-=1
  fadeperc=(80-govercountdown)/80
  if govercountdown<=0 then
   if goverrestart then
    govercountdown= -1
    blinkspeed=8
    part={}
    restartlevel()
   else
    govercountdown= -1
    blinkspeed=8
    gotostart()
    hs_x=128
    hs_dx=128
    music(1) 
   end
  end 
 end
end

function update_gameoverwait()
 govercountdown-=1
 if govercountdown<=0 then
  govercountdown= -1
  mode="gameover"
 end
end

function update_leveloverwait()
 govercountdown-=1
 if govercountdown<=0 then
  govercountdown= -1
  mode="levelover"
 end
end


function update_levelover()
 local _ang = rnd()
 local _dx = sin(_ang)*(rnd(0.3))
 local _dy = cos(_ang)*(rnd(0.3))
 local _mycol={12,12,5,5,0}
 local _toprow=60
 local _btnrow=75
 addpart(flr(rnd(128)),_toprow,_dx,_dy,5,70+rnd(15),_mycol,3+rnd(6))
 addpart(flr(rnd(128)),_btnrow,_dx,_dy,5,70+rnd(15),_mycol,3+rnd(6))

 if govercountdown<0 then
  if btnp(5) or btnp(1) then
   govercountdown=80
   blinkspeed=1
   sfx(15)
  end
 else
  govercountdown-=1
  fadeperc=(80-govercountdown)/80
  if govercountdown<=0 then
   govercountdown= -1
   blinkspeed=8
   part={}
   nextlevel()
  end 
 end
end

function fadeto(_f)
 -- fade in game
 if fadeperc!=_f then
  if abs(fadeperc-_f)<0.05 then
   fadeperc=_f
  else
   fadeperc=fadeperc+(0.05*sgn(_f-fadeperc))
  end
 end
end

function update_game()
 local buttpress=false
 local nextx,nexty,brickhit
 
 fadeto(0)
 
 --infinite loop protection
 if timer_slow > 0 then
  infcounter+=0.5
 else
  infcounter+=1
 end
 
 if timer_expand > 0 then
  -- check if pad should grow
  pad_w = flr(pad_wo * 1.5)
 elseif timer_reduce > 0 then
  -- check if pad should shrink
  pad_w = flr(pad_wo / 2)
  pointsmult=2
 else
  pad_w = pad_wo
  pointsmult=1
 end
 
 if btn(0) then
  pad_dx=-2.5
  buttpress=true
  pointstuck(-1)
 end
 if btn(1) then
  pad_dx=2.5
  buttpress=true
  pointstuck(1)
 end
 if btnp(5) then
  releasestuck()
 end
 if btnp(4) then
  --nextlevel()
 end

 -- vertical movement

 if btn(2) then
  pad_y-=2.5
  buttpress=true
  pointstuck(1)
 end
 
 if btn(3) then
  pad_y+=2.5
  buttpress=true
  pointstuck(1)
 end
 
 if not(buttpress) then
  pad_dx=pad_dx/1.3
  spdwind=0
 else
  spdwind+=1
 end
 
 pad_x+=pad_dx
 local oldx = pad_x
 pad_x=mid(pad_w/2,pad_x,127-(pad_w/2))
 if pad_x!=oldx then
  spdwind=0
 end
 
 if spdwind>5 then
  if pad_dx < 0 then
   spawnspeedline(pad_x+(pad_w/2),pad_y)
  else
   spawnspeedline(pad_x-((pad_w/2)+2.5),pad_y)
  end
 end
  
 -- big ball loop
 for bi=#ball,1,-1 do
  updateball(bi)
 end
 for bi=#ball,1,-1 do
  --check if paddle rammed ball
  padramcheck(ball[bi])
 end
 
 -- move pills
 for i=#pill,1,-1 do
  local p=pill[i]
  p.y+=0.7
  if p.y > 128 then
   -- remove pill
   del(pill,p)
  elseif box_box(p.x,p.y,8,6,pad_x-(pad_w/2),pad_y,pad_w,pad_h) then
   powerupget(p.t)
   spawnpillpuft(p.x,p.y,p.t)
   -- remove pill
   del(pill,p)
   sfx(11)
  end
 end
 
 update_sd()
 
 checkexplosions()

 if levelfinished() then
  _draw()
  if levelnum >= #levels then
   wingame()
  else
   levelover()
  end
 end
 
 -- powerup timers
 if timer_mega > 0 then
  timer_mega-=1
 end
 if timer_mega_w > 0 then
  timer_mega_w-=1
 end 
 if timer_slow > 0 then
  timer_slow-=1
 end
 if timer_expand > 0 then
  timer_expand-=1
 end
 if timer_reduce > 0 then
  timer_reduce-=1
 end
 animatebricks()
  
end
-->8
-- draw functions

function _draw()
 if mode=="game" then
  draw_game()
 elseif mode=="logo" then
  draw_logo()
 elseif mode=="start" then
  draw_start()
 elseif mode=="gameoverwait" then
  draw_game() 
 elseif mode=="gameover" then
  draw_gameover()
 elseif mode=="levelover" then
  draw_levelover()
 elseif mode=="leveloverwait" then
  draw_game()
 elseif mode=="winner" then
  draw_winner()
 elseif mode=="winnerwait" then
  draw_game() 
 end
 -- fade the screen
 pal()
 if fadeperc ~= 0 then
  fadepal(fadeperc)
 end
end

function draw_logo()
 cls(12)
 --rect(0,0,128,128,12)
 sspr(56,32,50,50,39,39)
end

function draw_sash()
 local _c,i
 if sash_v then
  if sash_c==-1 then
   _c = blink_r
  else
   _c = sash_c
  end
  rectfill(0,64-sash_w,128,64+sash_w,_c)
  print(sash_text,sash_tx,62,sash_tc)
  clip(0,64-sash_w,128,sash_w*2+1)
  for i=1,#ball do
   circfill(ball[i].x,ball[i].y,2,sash_tc)
  end
  clip()
 end
end

function draw_winner()
 -- draw game underneath sash
 draw_game()
 
 if loghs then
  --won. type in name
  --for highscore list
  local _y=40
  rectfill(0,_y,128,_y+52,12)
  print("★congratulations!★",26,_y+4,1)
  print("you have beaten the game",15,_y+14,7)
  print("enter your initials",15,_y+20,7)
  print("for the high score list.",15,_y+26,7)
  local _colors = {7,7,7,7}
  _colors[nit_sel] = blink_b
  print(hschars[nitials[1]],53,_y+34,_colors[1])
  print(hschars[nitials[2]],57,_y+34,_colors[2])
  print(hschars[nitials[3]],61,_y+34,_colors[3])
  print("ok",69,_y+34,_colors[4])
 
  print("use ⬅️➡️⬆️⬇️❎",35,_y+42,6)
 else
  --won but no highscore
  local _y=40
  rectfill(0,_y,128,_y+52,12)
  print("★congratulations!★",26,_y+4,1)
  print("you have beaten the game",15,_y+14,7)
  print("but your score is too low",15,_y+20,7)
  print("for the high score list.",15,_y+26,7)
  print("try again!",15,_y+32,7)

  print("press ❎ for main menu",20,_y+42,blink_b)
 end
end

function draw_start()
 cls()
 
 -- particles
 drawparts()
 print(ver,1,1,1)
 --draw logo
 palt(14,true)
 spr(64,(hs_x-128)+36,10,7,5)
 palt()
 print("game dev tutorial at",25+(hs_x-128),50,2)
 print("youtube.com/lazydevs",25+(hs_x-128),56,2)
 
 print("music by grubermusic",25+(hs_x-128),64,2)
 print("patreon.com/gruber99",25+(hs_x-128),70,2)

 prinths(hs_x)
 if hs_x>=0 and not(pirate) then
  if fastmode then
   print("fast mode",46,84,blink_w)
  end  

  print("press ❎ to start",30,92,blink_g)
  print("press ⬆️⬇️ to toggle fast mode",4,115,3)
  if hs_x==128 then
   print("press ⬅️ for high score list",9,109,3)
  end
 end
 
 if (pirate) print(stat(102),9,109,1)

end

function draw_gameover()
 -- draw particles
 draw_game()
 
 local _c1, _c2
 rectfill(0,60,128,81,0)
 print("game over",46,62,7)
 if govercountdown<0 then
  _c1,_c2=blink_w,blink_w
 else
  if goverrestart then
   _c1,_c2=blink_w,5
  else
   _c2,_c1=blink_w,5
  end
 end
 print("press ❎ or ➡️ to retry level",8,68,_c1)
 print("press 🅾️ or ⬅️ for main menu",8,74,_c2)
end

function draw_levelover()
 draw_game()
 
 rectfill(0,60,128,75,12)
 print("stage clear!",46,62,1)
 print("press ❎ or ➡️ to continue",12,68,blink_b)
end

function draw_game()
 local i
 cls()
 --cls(1)
 rectfill(0,0,127,127,1)
 
 --draw brick
 local _bsprite=false
 local _bspritex=64
 
 for i=1,#bricks do
  local _b=bricks[i]
  if _b.v or _b.fsh>0 then
   if _b.fsh>0 then
    brickcol = 7
    _b.fsh-=1
    _bsprite=false
   elseif _b.t == "b" then
    brickcol = 14
    _bsprite=false
   elseif _b.t == "i" then
    brickcol = 6
    _bsprite=true
    _bspritex=74
   elseif _b.t == "h" then
    brickcol = 15
    _bsprite=true
    _bspritex=94
   elseif _b.t == "s" then
    brickcol = 9
    _bsprite=true
    _bspritex=64
   elseif _b.t == "p" then
    brickcol = 12
    _bsprite=true
    _bspritex=84
   elseif _b.t == "z" or bricks[i].t == "zz" then
    brickcol = 7
   end
   local _bx=_b.x+_b.ox
   local _by=_b.y+_b.oy
   local _bx2=_bx+brick_w
   local _by2=_by+brick_h
   rectfill(_bx+1,_by+1,_bx2+1,_by2+1,0)
   if _bsprite and _b.fsh==0 then
    palt(0,false)
    sspr(_bspritex,0,10,5,_bx,_by)
    palt()
   else
    rectfill(_bx,_by,_bx2,_by2,brickcol)
   end
  end
 end 

 -- particles
 drawparts()
 
 -- pills
 for i=1,#pill do
  local p=pill[i]
  palt(0,false)
  palt(13,true)
  spr(p.t,p.x,p.y)
  palt()
 end
 
 -- balls
 for i=1,#ball do
  local _ballspr,b=34,ball[i]
  if timer_mega_w>0 or timer_mega>0 then
   _ballspr=35
  end
  palt(1,true)
  spr(_ballspr,b.x-3,b.y-3)
  palt()
  if b.stuck then
   -- draw trajectory preview dots
   pset(b.x+b.dx*4*arrm,
        b.y+b.dy*4*arrm,
        10)
   pset(b.x+b.dx*4*arrm2,
        b.y+b.dy*4*arrm2,
        10) 
  end
 end
 
 --pad
 local _px=pad_x-(pad_w/2)
 palt(1,true)
 if not(sticky) then
  sspr(0,16,5,6,_px,pad_y)
  sspr(8,16,5,6,_px+pad_w-4,pad_y)
  for i=5,pad_w-5 do
   sspr(5,16,1,6,_px+i,pad_y)
  end 
 else
  sspr(0,24,6,8,_px-1,pad_y-1)
  sspr(9,24,6,8,_px+pad_w-4,pad_y-1)
  for i=5,pad_w-5 do
   sspr(6,24,1,8,_px+i,pad_y-1)
  end 
 end

 palt()

 --ui
 rectfill(0,0,128,6,0)
 if debug!="" then
  print(debug,1,1,7)  
 else
  print("lives:"..lives,1,1,7)
  print("score:"..pointstring(points2,points),60,1,7)
  local _ct=chain.."x"
  local _cc=7
  if timer_reduce>0 then
   _ct=(chain*10).."x"
   _cc=8
  end
  print(_ct,126-(#_ct*4),1,_cc)
  
 end
 
 draw_sash()
end

function pointstring(s2,s1)
 if (s1==0 and s2==0) return "0"
 local ret=""
 if s2>0 then
  ret=ret..s2
  if s1==0 then
   ret=ret.."0000"
  elseif s1<10 then
   ret=ret.."000"..s1
  elseif s1<100 then
   ret=ret.."00"..s1
  elseif s1<1000 then
   ret=ret.."0"..s1
  else
   ret=ret..s1
  end
 else
  ret=ret..s1
 end
 ret=ret.."0"
 return ret
end
-->8
--highscore tab

--add a new high score
function addhs(_score,_score2,_c1,_c2,_c3)
 add(hs,_score)
 add(hst,_score2)
 add(hs1,_c1)
 add(hs2,_c2)
 add(hs3,_c3)
 for i=1,#hsb do
  hsb[i]=false
 end
 add(hsb,true)
 sorths()
end

function resethsb()
 for i=1,#hsb do
  hsb[i]=false
 end
 hsb[1]=true
end

--sort high score list
function sorths()
 for i=1,#hs do
  local j=i
  while j>1 and ((hst[j-1]==hst[j] and hs[j-1]<hs[j]) or hst[j-1]<hst[j]) do
   hs[j],hs[j-1]=hs[j-1],hs[j]
   hst[j],hst[j-1]=hst[j-1],hst[j]
   hs1[j],hs1[j-1]=hs1[j-1],hs1[j]
   hs2[j],hs2[j-1]=hs2[j-1],hs2[j]
   hs3[j],hs3[j-1]=hs3[j-1],hs3[j]
   hsb[j],hsb[j-1]=hsb[j-1],hsb[j]
   j=j-1
  end
 end
end

--resets the high score list
function reseths()
 --create default values
 hs={0,0,0,0,0}
 hst={0,0,0,0,0}
 hs1={11,11,11,11,11}
 hs2={18,18,18,18,18}
 hs3={19,19,19,19,19}
 hsb={true,false,false,false,false}

 sorths()
 savehs()
end

--load the highscore list
function loadhs()
 local _slot=0
 
 if dget(0)==1 then
  --load the data
  _slot+=1
  for i=1,5 do
   hs[i]=dget(_slot)
   hst[i]=dget(_slot+1)
   hs1[i]=dget(_slot+2)
   hs2[i]=dget(_slot+3)
   hs3[i]=dget(_slot+4)
   _slot+=5
  end
  sorths()
 else
  --file is empty
  reseths()
 end
end

--save the high score list
function savehs()
 local _slot
 dset(0, 1)
 --load the data
 _slot=1
 for i=1,5 do
  dset(_slot,hs[i])
  dset(_slot+1,hst[i])
  dset(_slot+2,hs1[i])
  dset(_slot+3,hs2[i])
  dset(_slot+4,hs3[i])
  _slot+=5
 end
end

--prints the high score list
function prinths(_x)
 rectfill(_x+29,8,_x+99,16,8)
 print("high score list",_x+36,10,7)

 for i=1,5 do
  -- number of rank
  print(i.." - ",_x+30,14+7*i,5) 
  --name
  local _c=7
  if hsb[i] then
   _c=blink_w
  end
  local _name = hschars[hs1[i]]
  _name = _name..hschars[hs2[i]]
  _name = _name..hschars[hs3[i]]
  
  print(_name,_x+45,14+7*i,_c)
  
  -- actual score
  local _score=" "..pointstring(hst[i],hs[i])
  
  print(_score,(_x+100)-(#_score*4),14+7*i,_c)
 end
end
-->8
-- nu collision
function intercept(_x1,_y1,_x2,_y2,_x3,_y3,_x4,_y4,_d)
 _denom=((_y4-_y3)*(_x2-_x1))-((_x4-_x3)*(_y2-_y1))
 if _denom != 0 then
  _ua=(((_x4-_x3)*(_y1-_y3))-((_y4-_y3)*(_x1-_x3)))/_denom
  if _ua>=0 and _ua<=1 then
   _ub=(((_x2-_x1)*(_y1-_y3))-((_y2-_y1)*(_x1-_x3)))/_denom
   if _ub>=0 and _ub<=1 then
    _x = _x1+(_ua * (_x2-_x1))
    _y = _y1+(_ua * (_y2-_y1))
    return {x=_x,y=_y,d=_d}
   end
  end
 end
 return nil
end

function ballintercept(_b,_box,_nx,_ny)
 local _pt=nil
 if _ny<_b.y then
  _pt = intercept(_b.x,_b.y,_nx,_ny, 
                  _box.left   - ball_r, 
                  _box.bottom + ball_r, 
                  _box.right  + ball_r, 
                  _box.bottom + ball_r, 
                  "bottom")
 elseif _ny>_b.y then
  _pt = intercept(_b.x,_b.y,_nx,_ny, 
                  _box.left   - ball_r, 
                  _box.top    - ball_r, 
                  _box.right  + ball_r, 
                  _box.top    - ball_r, 
                  "top")
 end 
 if _pt==nil then
  if _nx<_b.x then
   _pt = intercept(_b.x,_b.y,_nx,_ny, 
                   _box.right  + ball_r, 
                   _box.top    - ball_r, 
                   _box.right  + ball_r, 
                   _box.bottom + ball_r, 
                   "right")
  elseif _nx>_b.x then
   _pt = intercept(_b.x,_b.y,_nx,_ny,
                   _box.left   - ball_r, 
                   _box.top    - ball_r, 
                   _box.left   - ball_r, 
                   _box.bottom + ball_r, 
                   "left")
  end
 end 
 return _pt
end

function updateball(bi)
 myball = ball[bi]
 if myball.stuck then
  myball.x=pad_x+sticky_x
  myball.y=pad_y-ball_r-1
  infcounter=0
 else
  --regular ball physics
  if timer_slow > 0 then
   nextx=myball.x+(myball.dx/2*ball_spd)
   nexty=myball.y+(myball.dy/2*ball_spd)
  else
   nextx=myball.x+myball.dx*ball_spd
   nexty=myball.y+myball.dy*ball_spd
  end

  local _cols={}
  local _mcols={}
  local _tmpcol=nil
  local _box
  --check if ball hit wall
  _tmpcol=ballintercept(myball,screenbox,nextx,nexty)
  if _tmpcol~=nil then
   _tmpcol.t="wall"
   add(_cols,_tmpcol)
  end
  
  --collision with pad
  _box=getpadbox()
  _tmpcol=ballintercept(myball,_box,nextx,nexty)
  if _tmpcol~=nil then
   _tmpcol.t="pad"
   add(_cols,_tmpcol)
  end
    
  --collision with bricks
  for i=1,#bricks do
   -- check if ball hit brick
   if bricks[i].v then
    _box=getbrickbox(bricks[i])
    _tmpcol=ballintercept(myball,_box,nextx,nexty)
    if _tmpcol~=nil then
     _tmpcol.t="brick"
     _tmpcol.brick=bricks[i]
     if ((timer_mega > 0 or timer_mega_w>0) and bricks[i].t=="i") 
     or (timer_mega<=0 and timer_mega_w<=0) then     
      add(_cols,_tmpcol)
     else
      add(_mcols,_tmpcol)
     end
    end
   end
  end 
  
  --save speed before collision
  lasthitx=myball.dx
  lasthity=myball.dy  
  
  --see if there is collisions
  if #_cols==0 then
   --no collisions
   myball.x=nextx
   myball.y=nexty   
  else
   -- some collision
   local _coli=1
   if #_cols>1 then
    -- more than one collisiom
    -- find the closest
    local _coldst=coldist(myball,_cols[1])
    for i=2,#_cols do
     local _dst=coldist(myball,_cols[i])
     if _dst<_coldst then
      _coldst=_dst
      _coli=i
     end
    end
   end
   --deal with the collision
   collide(myball,_cols[_coli]) 
  end
  
  -- do megaball collisions
  if #_mcols>0 then
   for i=1,#_mcols do
    hitbrick(_mcols[i].brick,true)
   end
  end
  
  --trail particles
  if timer_mega > 0 or timer_mega_w > 0 then
   spawnmtrail(myball.x,myball.y)
  else
   spawntrail(myball.x,myball.y)
  end
  
  -- check if ball left screen
  if myball.y > 127 then
   sfx(2)
   spawndeath(myball.x,myball.y)
   if #ball > 1 then
    shake+=0.15
    del(ball,myball)
   else
    sd_brick=nil
    shake+=0.4
    lives-=1
    if lives<0 then
     lives=0
     gameover()
    else
     serveball()
    end
   end
  end
  
  -- check if ball is stuck
  if myball.colcount > 60 then
   spawndeath(myball.x,myball.y)
   releasestuck()
   del(ball,myball)
   serveball()
  end
  
 end -- end of sticky if
end

function collide(_b,_c)
 --set postion
 _b.x=_c.x
 _b.y=_c.y
 _b.colcount+=1
    
 if _c.t=="wall" then
  ----------------
  --wall collision
  ----------------
  reflect(_b,_c.d)
  --puft and sound
  checkinf(_b)
  spawnpuft(_b.x,_b.y)
  sfx(0)
 elseif _c.t=="pad" then
  ----------------
  --pad collision
  ---------------- 
  local bend,angf=false,false
  chain=1
  infcounter=0
  check_sd()
  --hit side. save?
  if _c.d=="left" or _c.d=="right" then
   if _b.y+ball_r>pad_y+3 then
    -- lost ball
    _b.rammed=true
   else
    bend=true
    angf=false
    _c.d="top"
    _b.y=pad_y-ball_r
   end
  end
  reflect(_b,_c.d)
   
  --change angle
  if _c.d=="top" then
   --change angle
   if bend==false and abs(pad_dx)>1 then
    bend=true
    if sign(pad_dx)==sign(_b.dx) then
     angf=true
    else
     angf=false
    end
   end 
   if bend then
    if angf then
     --flatten angle
     setang(_b,mid(0,_b.ang-1,2))
    else
     --raise angle
     if _b.ang==2 then
      _b.dx=-_b.dx
     else
      setang(_b,mid(0,_b.ang+1,2))
     end
    end
   end
   --reset pos
   _b.y=pad_y-ball_r-1
   
   --catch powerup
   if sticky then
    releasestuck()
    sticky = false
    _b.stuck = true
    sticky_x = _b.x-pad_x
   end
  end
  --puft and sound
  sfx(1)
  spawnpuft(_b.x,_b.y)  
 elseif _c.t=="brick" then
  ----------------
  --brick collision
  ----------------
  if _b.collast==nil then
   _b.collast=_c.brick
  else
   if _b.collast!=_c.brick then
    _b.colcount=0
   end
  end
  reflect(_b,_c.d)
  checkinf(_b)
  hitbrick(_c.brick,true)
  if _c.brick.t=="i" then
   spawnpuft(_b.x,_b.y)
  end 
 end
 
end

function reflect(_b,_d)
 --reflect ball
 if _d=="left" or _d=="right" then
  _b.dx=-_b.dx
 else
  _b.dy=-_b.dy 
 end
end
 
function checkinf(_b)
 if infcounter>600 then
  
  infcounter=0
  local _nuang
  repeat
   _nuang=flr(rnd(3))  
  until _nuang~=_b.ang
  setang(_b,_nuang)
 end
end

function coldist(_b,_col)
 return dist(_b.x,_b.y,_col.x,_col.y)
end

function dist(x1,y1,x2,y2)
 local dx = x1 - x2
 local dy = y1 - y2
 return sqrt(dx*dx+dy*dy)
end

function getpadbox()
 local _l=flr(pad_x-(pad_w/2))
 local _r=_l+pad_w
 local _t=pad_y
 local _b=pad_y+pad_h
 return {left=_l,right=_r,top=_t,bottom=_b} 
end

function getbrickbox(_b)
 local _l=_b.x
 local _r=_b.x+brick_w
 local _t=_b.y
 local _b=_b.y+brick_h
 return {left=_l,right=_r,top=_t,bottom=_b} 
end

function padramcheck(_b)
 if _b.stuck then
  return
 end
 local _pbox = getpadbox()
 if box_box(_pbox.left+1,
            _pbox.top+1,
            pad_w-2,
            pad_w,
            _b.x-ball_r,
            _b.y-ball_r,
            ball_r*2,
            ball_r*2
 										) then
  if _b.dy<0 then
   -- ball flying up.
   return
  end
  if _b.y+ball_r>pad_y+3 then
   -- change speed of the ball
   if sign(_b.dx)==sign(pad_dx) then
    _b.dx+=pad_dx
   else
    _b.dx=-_b.dx
    _b.dx+=pad_dx
   end
   -- reset ball postion
   if _b.x<pad_x then
    _b.x=_pbox.left-ball_r
   else
    _b.x=_pbox.right+ball_r
   end
   -- puft and sound
   if _b.rammed~=true then
    sfx(1)
    spawnpuft(_b.x,_b.y)
    _b.rammed=true
   end
  else
   local _c={}
   _c.d="top"
   _c.t="pad"
   _c.x=_b.x
   _c.y=_b.y
   collide(_b,_c)
  end
 end
end
-->8
function loadlevels()

--01 simple breakout
levels={"///xb8xxb8xxbpbbpbbpbxxb8xxb8x"

--02 stairway to heaven
        ,"/b/bb/bbp/b3/b4/b4p/b6/bsb5/b7p/h9s"

--03 invader
        ,"xxsxxxxxs/xxsxxxxxs/xxxsxxxs/xxxbbbbbxxxxxbbbbbbbxxxbbbbbbbbbxxbbpbbbpbbxxbbbbbbbbbxxbbbbbbbbbxxbxbxxxbxbxxbxbxxxbxbxxxxxbxb/"

--04 twin towers
        ,"//xbbbhxbbbhxxbphbxbphbxxbhpbxbhpbxxhbbbxhbbbxxbbbbxbbbbxxbbbhxbbbhxxbphbxbphbxxbhpbxbhpbxxhbbbxhbbbx"

--05 get inside
        ,"pi//xi/xixxxhh/xixxhbbh/xixhpbbph/xixhbssbh/xixxhbbh/xixxxhh/xi/xi/xi/si9"

--08 cups high
        ,"/xixixxxixixxixixxxixixxisixxxisixxiiixxxiiix/xxxbbpbb/xxxbbbbb/xxxpbpbp/xxxbbbbb/xxxbbpbb/"

--14 clogged lanes
        ,"//pxpxpxpxpxpbxbxbxbxbxbbxbxbxbxbxbbxbxbxbxbxbbxisisisixbbxbxbxbxbxbbxbxbxbxbxbsxixsxsxixsbxbxbxbxbxb"

--16 enegry core
        ,"//xibpbpbpbixxixxxxxxxixxixxxxxxxixxixiiiiixixxixibsbixixxixibsbixixxixibpbixixxixxxxxxxixxixxxxxxxixxiiiiiiiiix"

--11 oreo
        ,"///xi8xxbbpbbbpbbxxbbbbbbbbbxxpbbbpbbbpxxbbbbbbbbbxxbbpbbbpbbxxi8x"

--17 shelves
        ,"//xbxbxpxbxbxxixixixixixpxbxbxbxbxpixixixixixixbxpxsxpxbxxixixixixixbxbxbxbxbxbixixixixixixpxbxpxbxpxxixixixixix"

--12 border wall
        ,"/bbbsbbbsbbbpxxxxxxxxxpb9b/biiiixiiiibxpxxxpxxxpxhiiiiiiiiih/bbpbbbbbpbbpxxxxxxxxxpb9b"

--10 mellow center
        ,"/ph8pbxxxxxxxxxbbxhhhphhhxbbxhxxxxxhxbbxhxhhhxhxbbxpxhshxpxbbxhxhhhxhxbbxhxxxxxhxbbxhhhhhhhxbpxxxxxxxxxph9h"

--13 lungs
        ,"///bbbpixipbbbhbbiixiibbhbbbsixisbbbbpbsixisbpbihiiixiiihibbbpixipbbbbbbbixibbbb"

--15 diagonal
        ,"///bb/bbbb/bbbbbbb/bsbbbbbbb/pbpbbbbbbbbihbbpbpbbbbxxihbbbbpbbxxxxihibbsbxxxxxxxhibpxxxxxxxxxhi"

--18 lazy devs
        ,"//xxxxbpb/xbpbihibpbxbihixxxihibbixxxxxxxibpibxxsxxbipbibxxxxxbibxbibxxxbibxxbibbbbbibxxxbibbbib/xxxbihib/"
}
end
__gfx__
00000000dd6666dddd6666dddd6666dddd6666dddd6666dddd6666dddd6666dd5aa55aa55a776666666677766667777777777777000000000000000000000000
00000000d660066dd660066dd660066dd660066dd660066dd660066dd660066d9900990099ddddddd6ddccddddddcceeeeeeeeee000000000000000000000000
00700700660440556606605566033055660110556600005566022055660aa0559009900990dddd6dddddccddccddcceeeeeeeeee000000000000000000000000
00077000604744056067670560373b0560171c05600705056027280560a7aa050099009900d6ddddddd6ccddddddcceeeeeeeeee000000000000000000000000
0007700060444905606677056033bb056011cc05600055056022880560aaaa0504400440045555555555ddd5555ddddddddddddd000000000000000000000000
007007006604905566077055660bb055660cc0556605505566088055660aa0550000000000000000000000000000000000000000000000000000000000000000
00000000d650055dd650055dd650055dd650055dd650055dd650055dd650055d0000000000000000000000000000000000000000000000000000000000000000
00000000dd5555dddd5555dddd5555dddd5555dddd5555dddd5555dddd5555dd0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000077000000000000000000000000000000000000000000
00070000000070000007000000000000000700000000000000000700000070000000770000000000007777000000000000007700000000000000000000000000
00777000000077000077700000070000000770000077700000077700007770000007700000077700007777000007777000777700000770000000000000000000
00077000000070000077700000077000000770000007770000077000000770000007770000077000077777000007707000077000007770000000000000000000
00000000000000000000000000000000000000000000700000000000000000000000000000007000000770000000000000000000000770000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1ddd1ddd1ddd11111111111111888111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d666d666d666d11111aaa11118000811000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d676d777d676d1111a7aaa1180700081000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d666d666d666d1111aaa9a1180005081000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d666d666d666d1111a999a1180555081000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1ddd1ddd1ddd111111aaa11118000811000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111888111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11bbb1bbb1bbb1110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1bdddbdddbdddb110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bd666d666d666db10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bd676d777d676db10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bd666d666d666db10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bd666d666d666db10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1bdddbdddbdddb110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11bbb1bbb1bbb1110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeaaaaeeecccccccccccccccccc777cccc777777777cccccccccccccccc0000000000000000000000
eeeeeeeeeeeeeeeeeee7eeeeeeeeeeeeeeeeeeeeeeeeeeeeaaaaaaeecccccccccccccccccc7777ccc77777777c777ccccccccccccc0000000000000000000000
eeeeeeeeeeeeeeeeeeee7eeeeeeeeeeeeeeeeeee7eeeeeeaa7aaa9aeccccccccc77cccccc77777cccc777777cc777cc7777ccccccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeee77eeeeeeeeeeeeeeeeeeeeeeeeaa7aaa9aeccccc7cc777cccccc77777ccccccc777ccc77777777c7ccccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeee77eeeeeeeeeeeeeeeeeeeeeeeaaaaa99aecccc77cc777cccccc777777ccccc777cccc7777777cc77cccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeee767eeeeeeeeeeeeeeeeeeee7eaaaa999aeccc777cc777ccccc777c777cccc7777ccccc77777ccc777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeee777eeeeeeeeeeeeeeeeeee7eea9999aeeccc777cc777ccccc777c777cccc777ccccccc777cccc777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeee7777eeeeeeeeeeeeeeeeee77eeaaaaeeeccc777cc777cccc777777777cc777cccccccc777cccc777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeee777eeeee7eeeeeeeeeee777eeeeeeeeccc777cc777cccc777777777cc7777777cccc777cccc777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeee767eeeee7e7ee7ee7e77777777eeeeccc777cc777777c777ccc777c77777777cccc777cccc777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeee777eeeeeeeeeeeeee7777777eeeeeccc777cc777777c77ccccc77c77777777cccc777cccc777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeee767ee7eeee7e77ee777777eeeeeeccc777cc7777cccccccccccccccccccccccccc7ccccc777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeee7eee777eee77eee77ee77777eeeeeeeccc777cccccccccccccccccccccccccccccccccccccc777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeee767ee777eeeee77777eeeeeeeeccc777cccc7777cccc777777c777cccc777cc7777ccc777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeee7ee777ee777eeee7777eeeeeeeeeccc777cc77777777cc777777c777ccc7777c777777cc777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee767ee77e7ee777eee7eeeeeeccc777cc777777777c777ccccc777cc777c777777ccc777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeee77e7eeee767eeeeee777eee77eeeeeeccc777cc777cc7777c777ccccc777cc777c777cccccc777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeee77eeee7ee767e77ee77ee7e77eeeeeeccc777cc777ccc777c777777cc777c777cc77777cccc777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeee77eeeeeeeeeeee77e77ee7eeeeeeeee7eeecccc77ccc777cc777c777777ccc777777ccc77777ccc777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeee7ee7e777eeee7777eeee777eeeeeeeecccc777cc777cc777c777cccccc77777cccccc7777cc77cccc0000000000000000000000
eeeeeeeeeeeeeeeee77eeeeeeeeeee777eeee77777eee777ee7ee77ecccc777cc777c7777c777cccccc77777ccc7ccc777c777cccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeee777777eeeeee77777777777eeeeeeeeeeecccc777cc7777777cc777777cccc777ccc77777777c777cccc0000000000000000000000
11111ee11111ee111111ee111ee1111111ee111ee111e11111111111cccc777cc777777ccc777777cccc777cccc777777cc777cccc0000000000000000000000
177771e177771e177771e17771e1771771e17771e177177117777771cccc777ccc77cccccccccccccccccccccccc7777ccc777cccc0000000000000000000000
1ddddd11ddddd11dddd11ddddd11dd1dd11ddddd11dd1dd11dddddd1cccccccccccccccccccccccc7777cccccccccccccccccccccc0000000000000000000000
1dd1dd11dd1dd11dd1111dd1dd11dd1dd11dd1dd11dd1dd1111dd111cccc777777777777777777777777777777777777777777cccc0000000000000000000000
166661e166666116661e1666661166661e16616611661661ee1661ee777777777777777777777777777777777777777777777777770000000000000000000000
1666661166661e16661e1666661166661e16616611661661ee1661ee7777777777777ccc77ccc77ccc77cccc7c777c7777777777770000000000000000000000
1771771177177117711e1771771177177117717711771771ee1771eec777777ccc77c77777c7c77c77c7c7777cc7cc7c777c77777c0000000000000000000000
177777117717711777711771771177177117222222227221e22271eec77777cc7cc7c7777c777c7c77c7cccc7c7c7c7cc7cc77777c0000000000000000000000
177771e177177117777117717711771771e1282828882882288821eecc7777c777c7c7777c777c7c77c7c7777c777c77ccc77777cc0000000000000000000000
11111ee1111111111111111e111111e111ee282828222828282821eecc7777ccccc7c7777ccccc7c77c7c7777c777c777c777777cc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee288882882888282282eeeccc777c777c77ccc7c777c7ccc77cccc7c777c777c77777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeee2e2e22e22222e28282882282828282eeeecccc7777777777777777777777777777777777777777777ccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee28282888282828882eeeecccc777777777777777777777777777777777777777777cccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeee2e2e22e222222222222222e222e222eeeeeccccc7777777777cccccccccccccccccccc7777777777ccccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeecccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeccccccccccccccc77777ccccccccccc7777ccccccccccccccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeecccccccccccccccc77777cccccccc77777cccccccccccccccc0000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeccccccccccccccccc7777777cc7777777ccccccccccccccccc0000000000000000000000
00000000000000000000000000000000000000000000000000000000ccccccccccccccccccc777777777777ccccccccccccccccccc0000000000000000000000
00000000000000000000000000000000000000000000000000000000ccccccccccccccccccccc77777777ccccccccccccccccccccc0000000000000000000000
00000000000000000000000000000000000000000000000000000000cccccccccccccccccccccccc77cccccccccccccccccccccccc0000000000000000000000
__label__
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1111111111111111111111111111111111111
111111111111111eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1111111111111111111111111111111111111
111111111111111eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1111111111111111111111111111111111111
111111111111111eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1111111111111111111111111111111111111
111111111111111eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1111111111111000000000000111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000000000111111111111
111111111111111eeeeeeeeee1eeeeeeeeee1eeeeeee000000eeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee0000aaaaaaaa00001111111111
111111111111111eeeeeeeeee1eeeeeeeeee1eeeeeee000000eeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee1eeeeeeeeee0000aaaaaaaa00001111111111
111111111111111eeeeeeeeee1eeeeeeeeee1eeeeeee00770000eeeeee1eeeeeeeeee1eeeeeeeeee1eeeee000000eeeeeeee0000aaaaaaaaaaaa000011111111
111111111111111eeeeeeeeee1eeeeeeeeee1eeeeeee00770000eeeeee1eeeeeeeeee1eeeeeeeeee1eeeee000000eeeeeeee0000aaaaaaaaaaaa000011111111
111111111111111eeeeeeeeee1eeeeeeeeee1eeeeeee000077000000ee1eeeeeeeeee1eeeeeeeeee1eeeee007700eeeeeeee00aaaa77aaaaaa99aa0011111111
111111111111111111111111111111111111111111110000770000001111111111111111111111111111110077001111111100aaaa77aaaaaa99aa0011111111
111111111111111eeeeeeeeee177766667771eeeeeeeee000077770000177766667771eeeeeeeeee1111110000000076666700aaaa77aaaaaa99aa0000111111
111111111111111eeeeeeeeee1ccddddddcc1eeeeeeeee0000777700001ccddddddcc1eeeeeeeeee11111100000000dddddd00aaaa77aaaaaa99aa0000111111
111111111111111eeeeeeeeee1ccddccddcc1eeeeeeeeee1000077770000cddccddcc1eeeeeeeeee11111111110000dd000000aaaaaaaaaa9999aa0000111111
111111111111111eeeeeeeeee1ccddddddcc1eeeeeeeeee1000077770000cddddddcc1eeeeeeeeee11111111110000dd000000aaaaaaaaaa9999aa0000111111
111111111111111eeeeeeeeee1ddd5555ddd1eeeeeeeeee1ee0077667700005555ddd1eeeeeeeeee111111111111ddd5007700aaaaaaaa999999aa0000111111
111111111111111111111111111111111111111111111111110077667700001111111111111111111111111111111111007700aaaaaaaa999999aa0000111111
111111111111111eeeeeeeeee1eeeeeeeeee1eeeeeeeeee111000077777700001111111111111111111111111111eeee00770000aa99999999aa000000111111
111111111111111eeeeeeeeee1eeeeeeeeee1eeeeeeeeee111000077777700001111111111111111111111111111eeee00770000aa99999999aa000000111111
111111111111111eeeeeeeeee1eeeeeeeeee1eeeeeeeeee111110077777777000011111100000011111111111111eeee0077770000aaaaaaaa00000000111111
111111111111111eeeeeeeeee1eeeeeeeeee1eeeeeeeeee111110077777777000011111100000011111111111111eeee0077770000aaaaaaaa00000000111111
111111111111111eeeeeeeeee1eeeeeeeeee1eeeeeeeeee111110000007777770000111100770000000000000000000000777777000000000000000011111111
11111111111111111111111111111111111111111111111111110000007777770000111100770000000000000000000000777777000000000000000011111111
111111111111111eeeeeeeeee1111111111111111111111111111111000077667700001100007700770000770000770077777777777777770000001111111111
111111111111111eeeeeeeeee1111111111111111111111111111111000077667700001100007700770000770000770077777777777777770000001111111111
111111111111111eeeeeeeeee1111111111111111111111111111111110000777777000000000000000000000000000077777777777777000000111111111111
111111111111111eeeeeeeeee1111111111111111111111111111111110000777777000000000000000000000000000077777777777777000000111111111111
111111111111111eeeeeeeeee1111111111111111111111111111111000000007766770000770000000077007777000077777777777700000000111111111111
11111111111111111111111111111111111111111111111111111111000000007766770000770000000077007777000077777777777700000000111111111111
11111111111111111111111111111111111111111111111111111111007700000077777700000077770000007777000077777777770000000011111111111111
11111111111111111111111111111111111111111111111111111111007700000077777700000077770000007777000077777777770000000011111111111111
11111111111111111111111111111111111111111111111111111111000000000000776677000077777700000000007777777777000000001111111111111111
11111111111111111111111111111111111111111111111111111111000000000000776677000077777700000000007777777777000000001111111111111111
11111111111111111111111111111111111111111111111111111111111100007700007777770000777777000000007777777700000000111111111111111111
11111111111111111111111111111111111111111111111111111111111100007700007777770000777777000000007777777700000000111111111111111111
11111111111111111111111111111111111111111111111111111111000000000000000077667700007777007700007777770000007700111111111111111111
11111111111111111111111111111111111111111111111111111111000000000000000077667700007777007700007777770000007700111111111111111111
11111111111111111111111111111111111111111111111111111111007777007700000000776677000000000000777777000000777700001111111111111111
11111111111111111111111111111111111111111111111111111111007777007700000000776677000000000000777777000000777700001111111111111111
11111111111111111111111111111111111111111111111100000000007777000000007700007766770077770000777700007700777700000000111111111111
11111111111111111111111111111111111111111111111100000000007777000000007700007766770077770000777700007700777700000000111111111111
11111111111111111111111111111111111111111111111100777700000000000000000000000077770077770000770000000000000000007700111111111111
11111111111111111111111111111111111111111111111100777700000000000000000000000077770077770000770000000000000000007700111111111111
11111111111111111111111111111111111111110000000000000000007700007700777777000000007777777700000000777777000000000000000011111111
11111111111111111111111111111111111111110000000000000000007700007700777777000000007777777700000000777777000000000000000011111111
11111111111111111111111111111111111111110077770011000000000000000000777777000000007777777777000000777777000077000077770011111111
11111111111111111111111111111111111111110077770011000000000000000000777777000000007777777777000000777777000077000077770011111111
11111100000000000000000000000000000000000000000000007777777777770000000000007777777777777777777777000000000000000000000000111111
11111100000000000000000000000000000000000000000000007777777777770000000000007777777777777777777777000000000000000000000000111111
11111100111111111100001111111111000011111111111100001111110000111111111111110000111111000011111100111111111111111111111100111111
11111100111111111100001111111111000011111111111100001111110000111111111111110000111111000011111100111111111111111111111100111111
11111100117777777711001177777777110011777777771100117777771100117777117777110011777777110011777711777711117777777777771100001111
11111100117777777711001177777777110011777777771100117777771100117777117777110011777777110011777711777711117777777777771100001111
1111110011dddddddddd1111dddddddddd1111dddddddd1111dddddddddd1111dddd11dddd1111dddddddddd1111dddd11dddd1111dddddddddddd1100001111
1111110011dddddddddd1111dddddddddd1111dddddddd1111dddddddddd1111dddd11dddd1111dddddddddd1111dddd11dddd1111dddddddddddd1100001111
1111110011dddd11dddd1111dddd11dddd1111dddd11111111dddd11dddd1111dddd11dddd1111dddd11dddd1111dddd11dddd11111111dddd11111100001111
1111110011dddd11dddd1111dddd11dddd1111dddd11111111dddd11dddd1111dddd11dddd1111dddd11dddd1111dddd11dddd11111111dddd11111100001111
11111100116666666611001166666666661111666666110011666666666611116666666611001166661166661111666611666611000011666611000000001111
11111100116666666611001166666666661111666666110011666666666611116666666611001166661166661111666611666611000011666611000000001111
11111100116666666666111166666666110011666666110011666666666611116666666611001166661166661111666611666611000011666611000000001111
11111100116666666666111166666666110011666666110011666666666611116666666611001166661166661111666611666611000011666611000000001111
11111100117777117777111177771177771111777711110011777711777711117777117777111177771177771111777711777711000011777711000011111111
11111100117777117777111177771177771111777711110011777711777711117777117777111177771177771111777711777711000011777711000011111111
11111100117777777777111177771177771111777777771111777711777711117777117777111177222222222222222277222211002222227711000011111111
11111100117777777777111177771177771111777777771111777711777711117777117777111177222222222222222277222211002222227711000011111111
11111100117777777711001177771177771111777777771111777711777711117777117777110011228822882288888822888822228888882211000011111111
11111100117777777711001177771177771111777777771111777711777711117777117777110011228822882288888822888822228888882211000011111111
11111100111111111100001111111111111111111111111111111100111111111111001111110000228822882288222222882288228822882211000011111111
11111100111111111100001111111111111111111111111111111100111111111111001111110000228822882288222222882288228822882211000011111111
11111100000000000000000000000000000000000000000000000000000000000000000000000022888888882288882288888822882222882200000011111111
11111100000000000000000000000000000000000000000000000000000000000000000000000022888888882288882288888822882222882200000011111111
11111111110000000000001100000000000000000000000000002200220022220022222222220022882288228888222288228822882288220000000011111111
11111111110000000000001100000000000000000000000000002200220022220022222222220022882288228888222288228822882288220000000011111111
11111111111111111111111111111111111111111111111100000000000000000000000000000022882288228888882288228822888888220000001111111111
11111111111111111111111111111111111111111111111100000000000000000000000000000022882288228888882288228822888888220000001111111111
11111111111111111111111111111111111111111111111100220022002222002222222222222222222222222222220022222200222222000000111111111111
11111111111111111111111111111111111111111111111100220022002222002222222222222222222222222222220022222200222222000000111111111111
11111111111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000000000000000111111111111
11111111111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000000000000000111111111111
11111111111111111111111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000011111111111111
11111111111111111111111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000011111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111ddd1ddddddddddddddd1ddd11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111d666d666666666666666d666d1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111d676d777777777777777d676d1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111d666d666666666666666d666d1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111d666d666666666666666d666d1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111ddd1ddddddddddddddd1ddd11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111

__sfx__
01010000183601836018350183301832018310013002130021300213002130021300213001d7001c7001c7001b7001b7001b7001c7001d7001d7001d7001e7001e70000000000000000000000000000000000000
010100002436024360243502433024320243100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000204501e4501b450184501645013450104500d4500a4500745003450014500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200002a36030360303503033030300163001330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200002c36032360323503233030300163001330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200002e36034360343503433035300163001330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000303603636036350363303a300163001330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000323603836038350383303c3003b3001330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000343603a3603a3503a3303e3003b3001330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000363603c3603c3503c3303f3003b3001330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200003946035460354503543030300163001330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100003a0503505030050290403b0503b0503b0501f0401d0200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0105000028050280502f0302f03027020270202f0202f02028010280102f0102f01028010280152f0102f01028010280102e0002e000280002800000000000000000000000000000000000000000000000000000
010400003d6302d630206301c6301562013615106240f6150e6140d6150d614000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300003f6732d673396711f6511465112651116510f6530f6420f6320b6320a6320a63209632096320762203622036120361203612036120361503614036150361401615016140161501613000000000000000
010300002805128051310303103036030390301f0301f0302803128031310303103036030390301f0101f01028010280103101031010360103901010010100102801028010310103101036010390161001610016
00030000294202e4201d3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200000e42012420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300002805128051310303103036000390001f0001f0002800028000310003100036000390001f0001f00028000280003100031000360003900010000100002800028000310003100036000390001000010000
000200003105131051280302803036000390001f0001f0002800028000310003100036000390001f0001f00028000280003100031000360003900010000100002800028000310003100036000390001000010000
000100000c6100f6101061013610186101a610216102a6103e6203d6203c6203b62030620206201d61018610156100e6100b61009610066100461000000000000000000000000000000000000000000000000000
011800000c04325025275252c0253c6152a0252c525270250c04325525270252c5253c6152c52527025275250c04325025275252c0253c6152a5252c025275250c04325025275252c5253c615360253852533525
011800000f415123251421516425193150f225124151432516315192250c0111b111275260c0111b111314150f415123251421516425193150f225124151432516215194251b1110c511275261b1110c51128711
01180000061350604506135120450613506045121350604506135060451071114711177111a7111d7112071106135060450613512045061350604512135120450613506045217111f7111b71113711227112f711
0118000025325273252c3252e3262a3252c325273252e30525325273272c3252a3252c32527320273152e30525325273272c3252e3262a3252c324273252e30525325273212c3252e32536327384253321033215
01180000123151442516215193251b415122251431516425192151b3253d405271013d4050f4050f4050c000123451443516225193151b425122451433516425192451b3353d405271013d4050f4050f4050c000
011800000313503045031350f04503135030450f1350304503135030451071114711177111a7111d711207110313503045031350f04503135030450f1350f0450313503045217111f7111b71113711227112f711
0118000000002000022a0422a0322a0222a0022a0422c0422c0322c022250422503225002250422704127032270222e0422e0322c0422c032270462c042330322c0222c022270472c04225042250322704127035
01180000000022c0422c0322c0222c012000002c0422e0422e0322e0222703225002270422a0412a0322a02231042310322e0422e0322e0002a0462c0422a0422e0422e0322a0473104233042330323604236035
000a00003705000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0118000025315273152c3152e3162a3152c315273152e30525315273172c3152a3152c31527310273152e30525315273172c3152e3162a3152c314273152e30525315273112c3152e31536317384153321033215
01180000081350804508135140450813508045141350804508135080451071114711177111a7111d711207110a1350a0450a135160450a1350a04516135160450a1350a045217111f7111b71113711227112f711
0109000011015130251603518045000000f0051301515025180351a045020050200515015170251a0351c0451f055230552605528050280402803228022280122801500005000050000500005000050000500005
000900000070011715137151672518725007000f7051371515715187251a725027050270515715177151a7151c7151f7152372526720267202672026710267102671526705007050070500705007050070500705
010900000c0430f035110351361516705187050c043110251302515615187051a7050c0431302515025170251a0251c0252102523615230202302023010230102301523700237050070500705007050070500705
0109000005115071150a1250c125001000310507115091150c1250e1250010500105091150b1150e1251012513135171351a1351c1301c1301c1221c1221c1121c11500100001000010000100001000010000100
010b00002b41529425274352444522405244052841526425244352144500405004052541523425214351e4451c4451944517445154451245012440124321242212412124121241011411104110f4110e4110d411
010b0000003002b31529315273152430522305243052831526315243152130500305003052531523315213151e3251c3251932517325103201032010322103121031510312103100f3110e3110d3110c3110b311
010b00000c04324425224252461500000000000c043214251f4252461500000000000c0431e4251c4251942517425154251242510425246450d1100d4120d4120d4120d4120d4100c4110b4110a4110941108411
010b00001f1151d1251b1351814516105181051c1151a1251813515145001050010519115171251513512145101450d1450b14509145061500614006132061220611206112061120511104111031110211101111
011000000904322025245252902539615270252952524025090432252524025295253961529525240252452509043220252452529025396152752529025245250904322025245252952539615330253552530525
011000000313503045031350f04503135030450f1350304503135030450d7011170114701177011a7011d7010a1350a0450a135160450a1350a04516135160450a1350a0451e7011c70118701107011f7012c701
011000001b3141d3241f31422324243141b3241d3141f32422314243241b026393103a3113a3123a3123a2121b3141d3241f31422324243141b3241d3141f32422314243241b0262d3102e3112e3122e4122e412
01100000000001b0101d0101f01022010240101b0101d0101f01022010240102b0102e010300102b7152e715307151b0101d0101f01022010240101b0101d0101f01022010240102b0102e010300102b7152e715
000b00001f05523055260552805028040280322802228012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000071350704507135130450713507045131350704507135070450d7111171114711177111a7111d711051350504505135110450513505045111351104505135050451e7111c71118711107111f7112c711
011000000030027340303403334033332333223534033340303402b3302b3222b3122e3402e3302e3222e3122e31529340293302734127340273322732227312243402734027336293402b3402e3402e3322e322
0110000029300303402e34029346273322732227340293402e3402e3302b3222b312273412733027322273122e300243402433227340303402b346293402734024340223402434627340293402b3403033233322
__music__
00 15161a18
00 15161a18
00 15191718
00 151b1a1e
00 151b171e
02 151c1f1e
04 20212223
04 24252627
01 28292a2b
00 282d2a2b
00 28292a2b
00 282d2a2b
00 28292e2b
00 282d2f2b
00 28292e2b
02 282d2f2b

