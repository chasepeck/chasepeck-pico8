pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
//title screen
function _init()
	game_state=0
	enable_mus=true
	
	menuitem(1,"toggle music",
	function()
		music(-1)
		if(enable_mus)then
			enable_mus=false
		else
			enable_mus=true
		end
 end)
	
	camx=0
	camy=0
	playmusic(4)

end
function _update()
	if(game_state==0)then
		if(btn(🅾️))then
			sfx(61)
			start_game()
		end
	elseif(game_state==1)then
		update_game()
	elseif(game_state==2)then
		update_menu()
	end
end
function _draw()
	cls()
	if(game_state==0)then
		color(1)
		print("global thermonuclear war",15,40+sin(time())*2+1)
		color(8)
		print("global thermonuclear war",15,40+sin(time())*2)
		color(14)
		print("🅾️: 1 player\n❎: 2 player",38,80)
		color(1)
		print("2021 organic games llc",0,122)
	elseif(game_state==1)then
		draw_game()
	elseif(game_state==2)then
		draw_menu()
	end
end

//other functions
function playmusic(mus)
	if(enable_mus)music(mus)
end

function check_table_contains(table,value)
	for i=1,count(table) do
		if(table[i]==value) return true
	end
	return false
end

//game
function start_game()
	game_state=1
	choose=true
	select_mode=0
	select_prompt=true
	camx=0
	camy=0
	slct=1
	playmusic(0)
	
	p1_data={ctrl={},silos={},bases={},radars={}}
	p2_data={ctrl={},silos={},bases={},radars={}}
	
	game_data={
	cooldown=5,
	defcon=5
	}
	
	cities={
	{4,3,"toronto",2.5},
	{1,4,"los angeles",3.8},
	{3,6,"mexico city",8.7},
	{5,8,"panama",0.8},
	{8,11,"brasilia",2.4},
	{8,13,"buenos aires",3.0},
	{12,3,"reykjavik",0.1},
	{15,3,"london",7.6},
	{15,5,"paris",2.2},
	{17,4,"berlin",3.4},
	{18,2,"moscow",10.4},
	{19,6,"new delhi",12.2},
	{15,8,"cairo",6.7},
	{14,15,"cape town",3.5},
	{23,4,"beijing",8.5},
	{23,6,"seoul",10.4},
	{21,8,"bangkok",5.7},
	{22,10,"singapore",5.6},
	{27,6,"tokyo",12.7},
	{27,12,"sydney",4.3},
	{33,12,"wellington",0.2}
	}
	
	pop={}
	for i=1,count(cities) do
		pop[i]=cities[i][4]
	end
	
	mset(cities[1][1],cities[1][2],3)
end
function update_game()

	//menu
	if(btnp(🅾️) and not select_prompt)then
		sfx(60)
		game_state=2		
		init_menu()
	end

	//selecting cities
	if(select_prompt or btn(❎))then
		if(btnp(➡️)) then
			if(slct+1>count(cities)) then
				slct=1
				//mset(cities[count(cities)][1],cities[count(cities)][2],2)
			else
				//mset(cities[slct][1],cities[slct][2],2)
				slct+=1
			end
			camx=cities[slct][1]*8-64
			camy=cities[slct][2]*8-64
			//mset(cities[slct][1],cities[slct][2],3)
			sfx(63)
		elseif(btnp(⬅️)) then
			if(slct-1<1) then
				slct=count(cities)
				//mset(cities[1][1],cities[1][2],2)
			else
				//mset(cities[slct][1],cities[slct][2],2)
				slct-=1
			end
			camx=cities[slct][1]*8-64
			camy=cities[slct][2]*8-64
			//mset(cities[slct][1],cities[slct][2],3)
			sfx(63)
		end
		if(btnp(🅾️) and not choose)then
			select_mode=0
			select_prompt=false
			sfx(57)
		end
		if(btnp(❎) and not choose)then
			if(select_mode==1)then
				if(check_table_contains(p1_data.ctrl,slct))then
					add(p1_data.silos,slct)
					sfx(61)
					select_mode=0
					select_prompt=false
				else sfx(56) end
			end
		end
	end
	
	//selecting starting city
	if(btnp(❎) and choose) then
		add(p1_data.ctrl,slct)
		sfx(61)
		playmusic(7)
		choose=false
		select_prompt=false
	end
	
	//controlled cities
	for i=1,count(p1_data.ctrl) do
		if not(slct==p1_data.ctrl[i])then
			mset(cities[p1_data.ctrl[i]][1],cities[p1_data.ctrl[i]][2],4)
		end
	end
	
	//silos, bases, radars
	for i=1,count(p1_data.silos)do
		if not(slct==p1_data.silos[i])then
			mset(cities[p1_data.silos[i]][1],cities[p1_data.ctrl[i]][2],10)
		end
	end
	for i=1,count(p1_data.bases)do
		if not(slct==p1_data.bases[i])then
			mset(cities[p1_data.bases[i]][1],cities[p1_data.ctrl[i]][2],9)
		end
	end
	for i=1,count(p1_data.radars)do
		if not(slct==p1_data.radars[i])then
			mset(cities[p1_data.radars[i]][1],cities[p1_data.ctrl[i]][2],11)
		end
	end
		

	//camera movement
	if(select_prompt==false and not btn(❎))then
		if(btn(⬆️) and camy>0) then
			camy-=2
			sfx(62)
		end
		if(btn(⬇️) and camy<20) then
			camy+=2
			sfx(62)
		end
		if(btn(⬅️) and camx>0) then
			camx-=2
			sfx(62)
		end
		if(btn(➡️) and camx<144) then
			camx+=2
			sfx(62)
		end
	end
	
	if(camx<0)camx=0
	if(camx>144)camx=144
	if(camy<0)camy=0
	if(camy>20)camy=20
	camera(camx,camy)
	
end

function draw_game()
	map(0,0,0,0,35,20)
	
	//ui
	
		//backgrounds
	rectfill(0+camx,116+camy,128+camx,128+camy,1)
	rectfill(0+camx,0+camy,128+camx,4+camy,1)
	
		//selected city
	color(12)
	print(">"..cities[slct][3],0+camx,122+camy)
	
	spr(23,cities[slct][1]*8,cities[slct][2]*8)
	
		//button controls
	color(6)
	if(select_prompt and choose)then print("⬅️➡️:change\n  ❎:select",85+camx,116+camy)
	elseif(select_prompt and not choose)then print("          ⬅️➡️:change\n  🅾️:cancel ❎:select",45+camx,116+camy)
	else print("❎+⬅️➡️:change\n       🅾️:menu",73+camx,116+camy) end

		//defcon
	if not(select_prompt)then 
		color(12-(5-game_data.defcon))
		print("defcon "..game_data.defcon,0+camx,0+camy)
		color(11)
		print("pop.: "..pop[slct].."MIL",0+camx,116+camy)
		
		//select prompts
	elseif(choose)then
		color(8)
		print("choose starting city",0+camx,0+camy)
		color(11)
		print("pop.: "..cities[slct][4].."MIL",0+camx,116+camy)
	else
		if(select_mode==1)then
			color(8)
			print("choose silo build location",0+camx,0+camy)
		end
	end
end

//menu

function init_menu()
	menuselected=1
end
function update_menu()
	if(btnp(🅾️))then
		sfx(59)
		game_state=1
	end
end
function draw_menu()

	local menuitems={
	{"build silo",5},
	{"build base",5},
	{"build radar",5},
	{"claim city",5},
	{"battle for city",4},
	{"launch nuke",3}}

	local p1_totalpop=0
	local p2_totalpop=0

	for i=1,count(p1_data.ctrl) do
		p1_totalpop+=pop[p1_data.ctrl[i]]
	end
	
	camera(0,0)
	print("\fbtotal pop.: "..
	p1_totalpop..
	"MIL\n\fcnO. controlled cities: "..
	count(p1_data.ctrl)..
	"\n\fbnO. silos: "..
	count(p1_data.silos)..
	"\n\fcnO. bases: "..
	count(p1_data.bases)..
	"\n\fbnO. radars: "..
	count(p1_data.radars)..
	"\n\f7\*z…",0,0)
	
	for i=1,count(menuitems) do
		if(menuselected==i) then 
			color(9)
			print("◆"..menuitems[i][1])
		else 
			color(7)
			print("  "..menuitems[i][1]) 
		end
	end
	
	print("\f7\*z…"..
	"\n\f9defcon: "..game_data.defcon..
	"\n\fanuke cooldown: "..game_data.cooldown.." TURNS"..
	"\n\f6❎:select - 🅾️:back"
	,0,96)
	
	if(btnp(⬆️) and menuselected>1)then
		menuselected-=1
		sfx(58)
	end
	if(btnp(⬇️) and menuselected<count(menuitems))then
		menuselected+=1
		sfx(58)
	end
	if(menuitems[menuselected][2]<game_data.defcon) then
		print("\#8\f0defcon must be "..menuitems[menuselected][2].." or lower\*z ",0,96)
	end
	
	if(btnp(❎))then
		sfx(61)
		select_mode=menuselected
		select_prompt=true
		game_state=1
	end
end
__gfx__
000000000303030303030303998008990c0c0c0c00000aaaaaa0000088000088111111110c0c0c0c0c0c0c0c0c0c0c0c00000000000000000000000000000000
00000000300000003000000090000009c0000000000aaaaaaaaaa0008000000811111111c0000000c0000000c000000000000000000000000000000000000000
007007000000000300000003800000080000000c00aaaaa00aaaaa0000000000111111110000000c0007700c0070070c00000000000000000000000000000000
00077000300000003007700000077000c00770000aaaaa0000aaaaa00008800011111111c0707000c0700700c007070000000000000000000000000000000000
000770000000000300077003000770000007700c0aaaaa0000aaaaa000088000111111110077770c0070070c0000770c00000000000000000000000000000000
00700700300000003000000080000008c0000000aaaaaaaaaaaaaaaa0000000011111111c0777700c0077000c077700000000000000000000000000000000000
000000000000000300000003900000090000000caaaaaaa00aaaaaaa80000008111111110000000c0000000c0000000c00000000000000000000000000000000
00000000303030303030303099800899c0c0c0c0aaaaaa0000aaaaaa8800008811111111c0c0c0c0c0c0c0c0c0c0c0c000000000000000000000000000000000
0000000099800899998008999980089908080808aaaaaa0000aaaaaa998008990000000008080808080808080808080800000000000000000000000000000000
0000000090000009900000099000000980000000aaa00aa00aa00aaa900000090000000080000000800000008000000000000000000000000000000000000000
0000000080000008800770088070070800000008aaa000aaaa000aaa800000080000000000000008000770080070070800000000000000000000000000000000
00000000007070000070070000070700800770000aa0000aa0000aa0000000000000000080707000807007008007070000000000000000000000000000000000
00000000007777000070070000007700000770080aaa000aa000aaa0000000000000000000777708007007080000770800000000000000000000000000000000
000000008077770880077008807770088000000000aaaaaaaaaaaa00800000080000000080777700800770008077700000000000000000000000000000000000
0000000090000009900000099000000900000008000aaaaaaaaaa000900000090000000000000008000000080000000800000000000000000000000000000000
000000009980089999800899998008998080808000000aaaaaa00000998008990000000080808080808080808080808000000000000000000000000000000000
__map__
0808080808080808080808080808080808080808080808080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101080801010101080101080808080808010101010101010108080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0801010101010108080101080808080101010201010101010101010808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0801010102010808080801080208010201010101010101010101010808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0802010101010808080808080808080101020101010101020101080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808010101080808080808080808080201010101010101010101080108080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080201080808080808080808080101010102010101020808080208080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080801010808080808080101010101080801010108080808010108080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808020108080808010101010201080808080208080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808010101080808010101010101010808080108080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080801010101010108080101010101010808080802080801080108080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080801010101020108080801010101010808080808080101010101080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808010101010108080801010101080808080808010101010201010808080208000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080101020808080801010101080108080808010101010101010808080108000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080801010808080808010108080108080808080108080801010808010108000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080801010808080808020108080808080808080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808010808080808080808080808080808080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
090d00200055000500005000050000500005000050000500005000050000500005000050000500000000050001550015000150001500015000150001500015000150001500015000150003550035000350003500
010d00040c63511000110001300013000150001500016000160001500015000130001300011000110000c0000c000110001100013000130001500015000160001600015000150001300013000110001100000000
993200000072400725007240072500724007250072400725007240072500724007250072400725007240072500724007250072400725007240072500724007250072400725007250072401721017200072100720
01190020010000100001000010000100001000010000100001000010001e0300100001000010000100001000010000100001000010000100001000010000100001000010000100001000010001e0300100001000
311900200050000500005000050000500300200050000500005000050000500300200050000500005000050000500300200050000500005000050000500300200050000500005000050000500300200050000000
991a00201c1251a12514105001051a1251c1251a1251c1251c1251a1250010500105181251a1251e1201e1251a125181251410500105181251712518125171251a12518125001050010518125171251b1201b125
010d000028000000000000028000000000000028000000000000028000000000000028000000000000028000000000000028000000002d100341000000034100280000000030100341253212534125321252f125
011000001201412012120121201212012120121201212012120121201212012120121201212012120121201212012120121201212012120121201212012120121201212012120121201212012120121201212012
011000001611416115161141611516114161151611416115161141611516114161151611416115161141611516114161151611416115161141611516114161151611416115161141611516114161151611416115
311000002801000000000000000000000000002801000000000000000000000000002802000000000000000000000000002802000000000000000000000000002802000000000000000000000000002802000000
31080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000028114261152421523215212151d315
011000000c0140c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c0120c012
011500001671416715167141671516714167151671416715167141671516714167151671416715167141671516714167151671416715167141671516714167151671416715167141671516714167151671416715
011e00002b0142b0152b0142b0152b0142b0152b0142b0152b0142b0152b0142b0152b0142b0152b0142b0152b0142b0152b0142b0152b0142b0152b0142b0152b4142b4152b4142b4152b4142b4152b4142b415
790f0000240132400324003000030000300003000030000300003000032d3102d3102d3102d3002d3002d3002d300213002d3002d300213002d3002d3002d3002d3102d310213102d3102d310000000000000000
311800002821000200002000020000200002002821000200002000020000200002002822000200002000020000200002002822000200002000020000200002002822000200002000020000200002002822000200
011000000001000010000100001000010000100001000010000100001000010000100001000020000100001000010000100001000020000200002000010000100001000010000100001000020000100001000010
012c00000071400715007140071500714007150071400715007240072500724007250072400725007240072500714007150071400715007140071500714007150072400725007240072500724007250072400725
012c00000171401715017140171501714017150171401715017140171501714017150171401715017140171501724017250172401725017240172501724017250172401725017240172501724017250172401725
311b00060b6100b610006000000000000000000000000600056130060005613006000561300600006000060000600006000060000600006000060011110131101511017110181101711015110131100000000000
3110000e17714007001371400700117140070010714007000a7140070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000000
3108082012715287152671523715147151271528715267151871524715167151c71528715237152671514715287151d715167151d71514715267152471014715127101a7151671528715247101d715167101a715
091000002871428710287102871528714287102871028715287142871028710287152871428710287102871528714287102871028715287142871028710287152871428710287102871528714287102871028715
091000002971429710297102971529714297102971029715297142971029710297152971429710297102971529714297102971029715297142971029710297152971429710297102971529714297102971029715
311000002871026711247112371122711227112271122711227112271122711227112271122711227112271122711227102271022710227152271422710227102271522714227102271022715227142271022715
011000000001400010000100001500014000150001400015000140001500014000150001400010000100001500014000150001400015000140001500014000150001400015000140001000010000150001400015
791000000c7400c7400c7400c7400d7400d7400d740107400e7400d7400d740021100070002110007000211000700021100070002110007000211000700021100070002110007000211000700021100070002110
c10500202821026210262102821026210282102621028210262102821026210282102621026210282102621028210262102821026210282102621028210262102821026210282102621028210262102821026210
31100620186101861000600186101861000600006000c615006000c615006000c615006000c615006050c615006050c615006000c615006000c615006050c615006050c615006050c61500605006050c6150c615
511a00101c1551c1551a1551a1551815518155171551715521155211551f1551f1551d1551d1551f1551a15500000000000000000000000000000000000000000000000000000000000000000000000000000000
011a0004187530000024623246000c6000c6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
511a001010255102550e2550e2550c2550c2550b2550b255152551525513255132551125511255132550e25500200002000020000200002000020000200002000020000200002000020000200002000020000200
591a00100074400745007440074500744007450074400745007440074500744007450074400745007440074500700007000070000700007000070000700007000070000700007000070000700007000070000700
79100000183401a3411b341183411a3411b341183301a3311b331183311a3311b331183201a3211b321183101a3111b3112461424610246102461024610246102461024610246102461024610246102461024615
411a000010755107550e7550e7550c7550c7550b7550b755157551575513755137551175511755137550e75500700007000070000700007000070000700007000070000700007000070000700007000070000700
591a00100174401745017440174501744017450174401745017440174501744017450174401745017440174500700007000070000700007000070000700007000070000700007000070000700007000070000700
19030f000c05024700267001305026700247002305024700267001f0501c050247001f050210501c0502470026700247002670024700267002470026700247002470026700247002670024700267002670024700
311000001c7101a711187111771116711167111671116711167111671116711167111671116711167111671116711167101671016710167151671416710167101671516714167101671016715167141671016715
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000025500303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011300000e75300003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104000026053240500c0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b000018153101440e1300c12500004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b0000241530c1440e1301012500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
190600000c77328750267402873026720287152670026700267002870026700287002670028700267002870026700287002670500700007000070000700007000070000700007000070000700007000070000700
010200001155500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00000c053181551a1550030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
02 00014045
01 02434445
00 02034445
02 02030445
01 05010045
00 05010045
02 05010006
01 0708090a
00 0b0c4344
00 0742090d
00 090e0f0b
00 07490f47
00 0b490f47
00 07490f47
00 0b490f47
00 080c0e10
00 080c4910
00 11121344
00 11121444
00 11121544
00 16174344
00 16171844
00 16171819
00 16171819
00 150c0944
00 150c090e
02 150c0913
00 210e1902
01 091a1902
00 091a1902
00 1c1b1902
00 1c1b1902
00 1002041b
00 1b1d0144
00 201f011e
00 2022011e
00 2362011e
00 2062011e
00 2362011e
00 1b5d0144
00 1b18011e
00 42248384
00 1b25011e
00 42248384
00 1b18011e
00 42248384
02 1b65011e
00 7f424344
00 7f424344
00 7f424344
00 7f424344
00 7f424344
00 7f424344
00 7f424344
00 7f424344
00 7f424344
00 7f424344
00 7f424344
00 7f424344
00 7f424344
00 7f424344
00 7f424344
00 7f424344
00 7f424344

