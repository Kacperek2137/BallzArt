pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init()

ingr_total_number = 5
total_orders = 0

-- number of n per ingredient
ing_1 = 0
ing_2 = 0 
ing_3 = 0
ing_4 = 0 
ing_5 = 0

-- starting ing_types array
ing_types_start = {ing_1,ing_2,ing_3,ing_4,ing_5}

-- how many ing types will be in play in this round
ing_ammount = 0

-- how many ings in this order are left to be disposed between ing types
ing_to_dispose = 0

-- how many total ings are on the start
start_ing_to_dispose = 0
end

function _update()

-- if x is pressed
if btnp(5) then
new_order()
end


end

function _draw()
cls()

print("ing_1",30,50,2)
print(ing_1,60,50,2)

print("ing_2",30,60,3)
print(ing_2,60,60,3)

print("ing_3",30,70,4)
print(ing_3,60,70,4)

print("ing_4",30,80,8)
print(ing_4,60,80,8)

print("ing_5",30,90,6)
print(ing_5,60,90,6)

print("ing_types_ammount",10,100,8)
print(ing_ammount,100,100,8)


print("total_orders",10,110,9)
print(total_orders,100,110,9)


print("start_ing_to_dispose",11,10,11)
print(start_ing_to_dispose,100,10,11)

end

function new_order()
total_orders += 1

-- getting a num in <1,4> range
ing_ammount = flr(rnd(4)) + 1
ing_ammount = mid(1,ing_ammount,4)

-- setting which ing_types will be used


ing_to_dispose = flr(rnd(total_orders)) + 1
ing_to_dispose = mid(ing_ammount * 2,ing_to_dispose,20)
-- ing_to_dispose = mid(total_orders,ing_to_dispose,20)
start_ing_to_dispose = ing_to_dispose


-- assigning all ings to buckets

-- first ing type operation
ing_1 = flr(rnd(ing_to_dispose))
ing_to_dispose -= ing_1

ing_2 = flr(rnd(ing_to_dispose))
ing_to_dispose -= ing_2

ing_3 = flr(rnd(ing_to_dispose))
ing_to_dispose -= ing_3

ing_4 = flr(rnd(ing_to_dispose))
ing_to_dispose -= ing_4


ing_5 = flr(ing_to_dispose)
ing_to_dispose -= ing_2
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
