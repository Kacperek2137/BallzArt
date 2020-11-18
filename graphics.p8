pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

__gfx__
0000000000077000015113b00000000000fee700000890007aaafaaa9a9999e9c3c3c3c3c3c3c3c0c3c3c3c3c3c3c3c300000000000000000000000000000000
00000000007af7001001000100faaaa90fef7e800000a000a99999999999999e1111111111111113111111111111111100000000000000000000000000000000
0070070009ff79805010005b0aafaa9808f7ffe0005dd600a97feeede8e82899111111111111111c111111111111111128282828282828280000000000000000
000770000fa7f7f015010503f9944940028f8f800555dd60a9ffe2d22222229e1111111111111113111111111111111111111111111111110000000000000000
000770007a6777f71010000b0f9aaaa00288e8f005555d50f9eef22222222299111111111111111c111111111111111111111111111111110000000000000000
0070070077767779110305039af99a9802e88ee00e555550a9e22f22222222991111111111111113111111111111111111111111111111110000000000000000
0000000087f77f6920305003004449800228888002d55520a9ed22222222229e111111111111111c111111111111111111111111111111110000000000000000
0000000008aff98002131330000000000022e80000255200a9d22222222222e91111111111111113111111111111111111111111111111110000000000000000
00000000000770000333b3b000000000002ff8000000000099e222222222229e111111111111111c111111111111111111111111111111110000000000000000
000000000077770035555b5b0000000002ff7f8000799f00a9822222222222981111111111111113111111111111111111111111111111110000000000000000
0000000007f777a0355355b309999aaf088ff88007ff99f099e222222222229e111111111111111c111111111111111111111111111111110000000000000000
00000000077777705555b55b9aaaaaa908e88e807f99f99f99822222222e2f981111111111111113111111111111111111111111111111110000000000000000
000000007f777f7a55555353aaa9999a08e88e8099f99fef992222222222ed94111111111111111c111111111111111111111111111111110000000000000000
00000000777777f7555555539a9aaa4008e88e80e99f9fe499822222222fdf988281111111111113828282828282828211111111111111110000000000000000
0000000057777f753555555b00000000028e88800eefee40e999999e99999998002111111111111c000000000000000011111111111111110000000000000000
0000000005ffff500b5553300000000000288800000000009e9e99e9e8e84884008111111111111300000000000000003c3c3c3c3c3c3c3c0000000000000000
00000000f6f77f6f00089000000000000000000000000000311111111111180000000000000000003111111111111800002111111111111c0000000000000000
00000000ff7ff7ff0000a000007ff9400000000000000000c1111111111112000000000000000000c11111111111120000811111111111130000000000000000
00000000f7f77f7f005dd60007f97f920000000000000000311111111111182800000000000000003111111111111800002111111111111c0000000000000000
00000000ff7ff7ff0555dd60797f99fe0000000000000000c1111111111111110000000000000000c11111111111120000811111111111130000000000000000
00000000f6f77f6f05555d50f999fef80000000000000000311111111111111100000000000000003111111111111800002111111111111c0000000000000000
00000000ff7ff7ff0e5555507f9efe200000000000000000c1111111111111110000000000000000c11111111111120000811111111111130000000000000000
00000000f7f77f7f02d5552009fe24000000000000000000311111111111111100000000000000003111111111111800002111111111111c0000000000000000
00000000ff7ff7ff00255200000000000000000000000000c1111111111111110000000000000000c11111111111120000811111111111130000000000000000
000000000000000000000000000000000000000000000000311111111111111100000000000000003111111111111800002111111111111c0000000000000000
000000000000000000000000000000000000000000000000c1111111111111110000000000000000c11111111111120000811111111111130000000000000000
000000000000000000000000000000000000000000000000311111111111111100000000000000003111111111111800002111111111111c0000000000000000
000000000000000000000000000000000000000000000000c1111111111111110000000000000000c11111111111120000811111111111130000000000000000
000000000000000000000000000000000000000000000000311111111111111100000000000000003111111111111800002111111111111c0000000000000000
000000000000000000000000000000000000000000000000c1111111111111110000000000000000c11111111111120000811111111111130000000000000000
000000000000000000000000000000000000000000000000311111111111111100000000000000003111111111111800002111111111111c0000000000000000
0000000000000000000000000000000000000000000000000c3c3c3c3c3c3c3c0000000000000000c11111111111120000811111111111130000000000000000
00000000000011111111000000002222222200000000005555500000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000011999e821100000022fa99982200000000557c3500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000199e8888210000002fa9999982000000055abb3500000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000019e21188210000002f9822a98200000055abbb3500000000000000000000000000000000000000000000000000000000000000000000000000000
000000000001921118821000000298222a9820000005acbbb3500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000111119882100000022222f99220000005cb5cb3500000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000111e8821100000000022998200000005555bb3500000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000118882110000000002f992200000000005bb3500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000118882100000000229982000000000005bb3500000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000110118821000000002f9922000000000005bb3500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000111111e82100000000299820000000000005bb3500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000199119882100000022f99222220000000005bb3500000000000000000000000000000000000000000000000000000000000000000000000000000
000000000001e888888210000002aa9822f820000000005bb3500000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000011388882210000002a999999820000000005cb3500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000012222221100000022c99998220000000005933500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000011111111000000002222222200000000005555500000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088888888888888800888880088888888888000000000088888880000000000011dd1d1dd1d1dd113166363661616631d1ccdcdcc1c1ccd100000000
0000000088888888888888888888888008888888888880000000888888888880000000001ddd1d1dd1d1ddd116661616636366631ccc1c1ccdcdcccd00000000
00000000888a99999999999888a9928088a99999999288000088881111111888800000001ddd1d1dd1d1ddd13c663636616166c1dcccdcdcc1c1ccc100000000
0000000088a999999999999928999288889999999999280088881111111111188880000011dd1d1dd1d1dd1113cc1c1cc3c3cc131dcc1c1ccdcdcc1d00000000
000000008899999999999999289992888a99999999992808881111fffffff1111888000011111111111111113131313131313131d1d1d1d1d1d1d1d100000000
00000000889992888888899928999288a9992888899928888111fffffffffff1118880001113111dd111311113161316631363131d1c1d1ccd1dcd1d00000000
00000000889992888888899928999288999288888999288811fff8fffffffffff11880001131111dd111131131c1313cc1313c31d1c1d1dcc1d1dcd100000000
0000000088999280000889992899928899928008899928811fffafffffffff8fff118800d1111dd11dd1111d6313166316631316cd1d1ccd1ccd1d1c00000000
0000000088999280000889992899928899928008899928811fffffffabaaffffff118800d1111dd11dd1111dc13136c13c613136c1d1dcc1dcc1d1dc00000000
000000008899928000888999289992899992800889992811ffffffaababa3ffffff118801111111dd111111113131316631313131d1d1d1ccd1d1d1d00000000
000000008899928008889992889992899928800888888811fffffabaabaa33f8fff11880d1dd111dd111dd1d6166313cc1316636c1ccd1dcc1d1ccdc00000000
00000000889992808889999288999289992800088888811ffaff9babaaab844fffff1188d1ddd111111ddd1d6366631313166616cdcccd1d1d1ccc1c00000000
00000000889992888899992888999289992800000008811fffff99999ab4444fffff1188d1ddd113311ddd1d6166c136613c6636c1ccc1dcc1dcccdc00000000
00000000889992888999928888999289992800000008811f8ff999ff99444484ffff1188d1dd11133111dd1dc36c131cc313c61ccdcc1d1ccd1dcc1c00000000
00000000889999999999288088999289992800000008811ffffe9f9999484444fff1118811111111111111113131313131313131d1d1d1d1d1d1d1d100000000
00000000889999999992880088999289992800000008811ffff8e99ff9844848ffff11881111111dd111111113131316631313131d1d1d1ccd1d1d1d00000000
00000000889999999928800088999289992800000008811fff8fe9f99944844fffff118801dd0d0dd1d1dd010155050551515501000000000000000000000000
00000000889992888888000088999289992800000008811fffff8e999ff4444fffff11881ddd1d1dd0d0ddd01555151550505550000000000000000000000000
000000008899928888800000889992889992800088888811fffff8e9f99484ffaff1188002dd0d0dd1d1dd210255050551515521000000000000000000000000
000000008899928000000000889992889992800888888811f8ffffeeee844ffff8f1188010221212202022101022121220202210000000000000000000000000
0000000088999280000000008899928899928008899928811faff8ff888fffffff11880001010101010101010101010101010101000000000000000000000000
0000000088999280000000008899928899928888899928811ffffffffffff8ffff1188001013101dd01030101013101550103010000000000000000000000000
00000000889992800000000088999288899928889999288811ffffffffffffff1118800001310102210103010151010221010501000000000000000000000000
0000000088999280000000008899928889999999999288888111ffff8ffffff111888000d0101dd01dd0101d5010155015501015000000000000000000000000
000000008899928000000000889992888889999999288008881111fffffff1111888000021010d2102d101022101052102510102000000000000000000000000
0000000088999280000000008899928088899999992800008888111111111118888000001010101dd01010101010101550101010000000000000000000000000
000000008888888000000000888888800888888888800000008888111111188880000000d1dd01022101dd0d5155010221015505000000000000000000000000
000000008888888000000000888888800088888888880088888888888888888888800000d0ddd010101ddd1d5055501010155515000000000000000000000000
000000008888888000000000008888800008888888888888888808888888888888800000d1dd21033102dd0d5155210331025505000000000000000000000000
0000000088aa92800000000088aa92800088a9999999288a992800088a9928a99280000020221013301022122052101550102512000000000000000000000000
0000000088a992888000008888a99280008899999999928999280008899928999280000001010101010101010101010101010101000000000000000000000000
0000000088999928880008888999928008889999999992899928000889992899928000001010101dd01010101010101550101010000000000000000000000000
00000000889999992800088999999280088a99288999928999280008899928999280000000000000000000000000000000000000000000000000000000000000
00000000889999992800088999999280088999288899928999280008899928999280000000000000000000000000000000000000000000000000000000000000
00000000889999992800088999999280888999288899928999280088899928999280000000000000000000000000000000000000000000000000000000000000
0000000088999999280008899999928088a999288899928999280888999288999280000000000000000000000000000000000000000000000000000000000000
00000000889999992800088999999280889999288899928999288889999288999280000000000000000000000000000000000000000000000000000000000000
00000000889999999280889999999280889992888899928999288899992888999280000000000000000000000000000000000000000000000000000000000000
00000000889992999280889992999280889992888899928999288999928888999280000000000000000000000000000000000000000000000000000000000000
00000000889992999928899992999288889992888899928999999999288088999280000000000000000000000000000000000000000000000000000000000000
00000000889992999928899992999288899999999999928999999992880088999280000000000000000000000000000000000000000000000000000000000000
00000000889992889992999928999288899999999999928999999992800088999280000000000000000000000000000000000000000000000000000000000000
00000000889992889999999928999288899999999999928999289992800088999280000000000000000000000000000000000000000000000000000000000000
00000000889992889999999288999288899928888899928999289999280088999280000000000000000000000000000000000000000000000000000000000000
00000000889992888999992888999288999928888899928999288999280088999280000000000000000000000000000000000000000000000000000000000000
00000000889992888899928888999288999288008899928999288999928088999280000000000000000000000000000000000000000000000000000000000000
00000000889992808899928088999288999280008899928999288899928088999280000000000000000000000000000000000000000000000000000000000000
00000000889992808888888088999288999280008899928999288899992888999280000000000000000000000000000000000000000000000000000000000000
00000000889992800888880088999288999280008899928999280889992888999280000000000000000000000000000000000000000000000000000000000000
00000000889992800000000088999289999280008899928999280889999288999280000000000000000000000000000000000000000000000000000000000000
00000000889992800000000088999289992880008899928999280088999288999280000000000000000000000000000000000000000000000000000000000000
00000000889992800000000088999289992800008899928999280088999928999280000000000000000000000000000000000000000000000000000000000000
00000000889992800000000088999289992800008899928999280008899928999280000000000000000000000000000000000000000000000000000000000000
00000000888888800000000088888888888800008888888888880008888888888880000000000000000000000000000000000000000000000000000000000000
00000000888888800000000088888888888800008888888888880000088888888880000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00a9aaa9aaa9aaa9aaa9aaa9aaa9aaa900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00b9bab9bab9bab9bab9bab9bab9bab900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00a9aaa9aaa9aaa9aaa9aaa9aaa9aaa900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00b9bab9bab9bab9bab9bab9bab9bab900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00a9aaa9aaa9aaa9aaa9aaa9aaa9aaa900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00b9bab9bab9bab9bab9bab9bab9bab900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
