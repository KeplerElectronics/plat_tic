-- title:  Thwimbly
-- author: ya boi
-- desc:   short description
-- script: jeff

--[[ TODO
-----
					set up time function
					set up death counter

					finish real menu
     get rid of settings menu

					redo w2 music
					
					make cool intro anims
					
					full collision rework
					
					
					BUGZ
					--player can get caught on 
					  corner of climby if 
							upside down
							
							-merbbe fixeed
							
					--jump sometimes doesnt register 
					  though it looks and feels like
							it should
							
							
					--sometimes player clips into
					  ground if jump at same time
							as flip
							
							--maybe bean fixed by checking
							  flipped bonk?
									idk haven't seen it happen
									in a while so mebbe
							
					--player looks like clipping
					  into ground when standing at
							top of stage 
							
					--sticky turns wrong way
					
					--player can get trapped in
					  sticky corners
							
					--player gets trapped in all 
					  stickys
							
					--player can get trapped in 
					  normal corners
							--jump into corner left of
							  w1 spawn
							
					--dying in w2+ sends player back 
					  to w1
							--FIXED BOIS! :D
]]

dpat={1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,2,1,2,1,2,1,2,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,2,2,3,2,3,2,3,2,3,3,2,3,3,3,3,3,3}


function pal(c,r,g,b)
    poke(0x3fc0+c*3,r)
    poke(0x3fc1+c*3,g)
    poke(0x3fc2+c*3,b)
end
--from aspext1090 on discord

function solid(x,y)
    return solids[mget((x)//8,(y)//8+(level-1)*34)]
end

function climby(x,y)
    return climbs[mget((x)//8,(y)//8+(level-1)*34)]
end

function deathy(x,y)
    return deathys[mget((x)//8,(y)//8+(level-1)*34)]
end

function falldeathy(x,y)
    return falldeathys[mget((x)//8,(y)//8+(level-1)*34)]
end

function flaggy(x,y)
    return flaggys[mget((x)//8,(y)//8+(level-1)*34)]
end

function upflip(x,y)
    return upflips[mget((x)//8,(y)//8+(level-1)*34)]
end

function downflip(x,y)
    return downflips[mget((x)//8,(y)//8+(level-1)*34)]
end

function sticky(x,y)
    return stickys[mget((x)//8,(y)//8+(level-1)*34)]
end

function pipe(x,y)
    return pipes[mget((x)//8,(y)//8+(level-1)*34)]
end

function oldcrystal(x,y)
    return oldcrystals[mget((x)//8,(y)//8+(level-1)*34)]
end

function oneway(x,y)
    return oneways[mget((x)//8,(y)//8+(level-1)*34)]
end

function unstable(x,y)
    return unstables[mget((x)//8,(y)//8+(level-1)*34)]
end

function lerp(a,b,t) return (1-t)*a + t*b end
 
 --set level
	world=1
	level=4
	
	cam={
	x=0,
	y=0,
	}
					
	allparticles={}
	wipes = {}
					
	mus= "start"
	
	gamestate = "startup"
	
	upflips = {}
				
	downflips = {}
	
	stickys = {}
	
	solids={[1]=true,[2]=true,[3]=true,
				        [17]=true,[18]=true,[19]=true,
												[33]=true,[34]=true,[35]=true,[36]=true,
												[37]=true,[48]=true,
												[16]=true, [32]=true,
												[211] = true,[227]=true,[176]=true, [184] = true, [185]=true}
	
	pipes={}
	
	oldcrystals={}
	
	climbs={[48]=true}
				
	deathys={[49]=true,[50]=true,[65]=true, [66]=true}
	
	flaggys={[96]=true,[112]=true, 
	         [113]=true,[129]=true}
	
	oneways={[150]=true,[151]=true,[152]=true,
	         [153]=true,[154]=true,[155]=true,
										[172]=true,[173]=true,[174]=true}
										
 unstables={[156]=true,[157]=true,[158]=true}
	
	
	t=0
	
	climb = false
 jump = false
 onceil = false
 onground = false
 
 --has to be out here or player can 
 --get caught in deathloop
 grv = .2
 grvmax = .2 
 dir = "down" 
 
 underwater = false
 
 --settings and stuff
 
 bganim = true
 
	
	difficulty = "easy"
	
	platspeed = 0.5
	
	--signs. text1 is the early sign in
	--level, text 2 is for signs
	--that show up after halfway mark
	
	text1 = {"Welcome to Autumn's Plunge!",
	        "Press up to climb! :)",
									"beware of tattered mushrooms",
									"It's night!",
									--world 2
									"Welcome to spookyville >=)",
									"Caution! Sticky!",
									"Wanch out for beans!", 
									"",
									--world 3
									"",
									"",
									"",
									"",
									--world 4
									"Currents can push you around!",
									"",
									"",
									"",}
									
	text2 = {"Skamtebord",
	        "chill dude",
									":3",
									"nice going sport!",
									--world 2
									"-the sign painter!",
									"enjoy the climb!" }			
						
	lastx = cam.x+70
	lasty = cam.y+140
	lastdir = "down"
	
	ltt = 0 --level transition timer
	lst = 0 --level start timer

 orb = false --warp zone
 
 checkpoint = false -- has player gotten checkpoint
 
 speed = false --orb speedup

 
 ctfr = 0
 starttime = tstamp()
 lastframe = 0
 
 xct = 0 -- xon activation timer

 deathwipe = false
 deathwipetimer = 0
 
 mapcoords = {x=16,y=85}
 
function init()
    shakelength = 0
    
				
												
				
				falldeathys={}
				
    cam={
				x=0,
				y=0,
				}
    
    p={
				x=cam.x+70,
    y=cam.y+160,
    vx=0, --Velocity X
    vy=0, --Velocity Y
				spr=256,
				sprct=0,
				jct=0,
				onground=false,
				onceil=false,
				canjump=false,
				cjct=0,
				jump=false,
				rot=0,
				fl=1,
				dead=false,
				exp=false,
				speed=false,
				stuck = false,
				stuckceil = false,
				inpipe = false,
				onplat = false,
				platent = 0,
				clawed = false,
				insling = false,
				conveyortimer = 1,
				incrystal = false,
				ononeway = false
      }
				
				
				
				gt=0
			
				
				ents={}
				plants = {}
				seabgs={}
				
    k=0
    
    cloud = false
    
    leveltitles = {
    "Welcome to Autumn",
    "Climb Canopy",
    "Shroom Sunset",
    "Danger Nights",
    "Forest of Something",
    "big oof"}
    
    xon = true
end

init() --call init before start

function TIC()



	if gamestate == "startup" then
	 gamestate = "menu"
	elseif gamestate == "menu" then
	 
		if cloud == false then
		 clouds(30,false,5,3)
			cloud = true
		end
		
		clouds(280+cam.x,true,5,3)

	 
		cls()
		rect(60,50,20,150,11)
		rect(100,30,20,150,11)
		rect(230,90,20,150,11)
		
		if #allparticles~=0 then
	  for i,particle in ipairs(allparticles) do
	   if particle.rad ==0 then
	    pix(particle.x-cam.x,particle.y-cam.y,particle.clr)
	   else
	    circ(particle.x-cam.x,particle.y-cam.y,particle.rad,particle.clr)
	   end
			end
		end
		
	 vbank(1)
	 -- set palette entry 15 to transparent
	 poke(0x03FF8, 0)

		
	 cls(0)
		
		spr(344,24,48,0,3,0,0,8,2)
		
	  --[[rotspr(344,100,60,
			math.sin(time()/1000)/10+3.2,
			20,10,0,0,50,20)]]
	
		spr(408,88,100,0,1,0,0,8,1)
		
		vbank(0)
		
		particlelogic()
		
		if btnp(4) or btnp(5) then
		 gamestate = "worldmap"
			gt = 0
			cloud = false
		end
		
	elseif gamestate == "worldmap" then
		
		if btn(3) then
		 mapcoords.x = mapcoords.x+1
		elseif btn(2) then
		 mapcoords.x = mapcoords.x-1
		end
		
		if btn(0) then
		 mapcoords.y = mapcoords.y-1
		elseif btn(1) then
		 mapcoords.y = mapcoords.y+1
		end
		
		cam.x=lerp(cam.x,mapcoords.x-120,0.1)
  cam.y=lerp(cam.y,mapcoords.y-60,0.1)
  
		
		lv={}
		-- x    y          name      level
		lv[2]={[11]={"1-1: Autumn's Plunge",1,1}}
		lv[7]={[13]={"1-2: Beanboy",1,2}}
		
		
		if mapcoords.x<=135 then
		 pal(8,122,48,69)
			pal(9,158,69,57)
			pal(10,205,104,61)
		 pal(11,230,144,78)
		
		elseif mapcoords.x>135 then
		 pal(8,62,53,70)
			pal(9,98,85,101)
			pal(10,127,112,138)
			pal(11,155,171,178)
		
		end
		
		
		
		
		cls()
		
		map(0,0,30,30,-cam.x,-cam.y)
		
		if mget((mapcoords.x+4)//8,(mapcoords.y+8)//8)==5 then
   local string=lv[(mapcoords.x+4)//8][(mapcoords.y+8)//8][1] 		
	 	local width=print(string,0,-6)
			rect(0,0,240,12,8)
   print(string,(240-width)//2,3, 2)
   
   if btnp(4) or btnp(5) then
			 --w2
				pal(5,146,169,132)
			 pal(6,84,126,100)
			 pal(7,55,78,74)
			 pal(8,62,53,70)
				pal(9,98,85,101)
				pal(10,127,112,138)
				pal(11,155,171,178)
				
				
				
				gamestate = "levelstart"
				gt = 0
				worldchange(
				lv[(mapcoords.x+4)//8][(mapcoords.y+8)//8][2],lv[(mapcoords.x+4)//8][(mapcoords.y+8)//8][3])
			end
		end
		
		vbank(1)
		cls()
		
		spr(288,mapcoords.x-cam.x,mapcoords.y-cam.y) 
		vbank(0)
		
		
		
		
		
	elseif gamestate == "levelstart" then
	 cls() 
		vbank(1)
		cls()
		vbank(0) 
		
		particlelogic()
		if #allparticles~=0 then
	  for i,particle in ipairs(allparticles) do
	   if particle.rad ==0 then
	    pix(particle.x-cam.x,particle.y-cam.y,particle.clr)
	   else
	    circ(particle.x-cam.x,particle.y-cam.y,particle.rad,particle.clr)
	   end
			end
		end
		
		wipelogic()
		if ltt>0 then
		ltt = ltt+1
		if ltt>120 then
		 ltt = 0
			lst = 1
		end
		end
		
		
		gt = gt+1
		vbank(1)
		if gt<30 then
		 rect(50-gt/20,0,50,gt*4,3)
		 rect(0,100+gt/20,gt*8,100,12)
		
		elseif gt >=30 and gt<90 then
		 rect(50-gt/20,0,50,140,3)
		 rect(0,100+gt/20,240,100,12)
			local width=print(leveltitles[level+(world-1)*4],0,-6)
   print(leveltitles[level+(world-1)*4],(240-width)//2,120+gt/20,5)
		 
		elseif gt>=90 and gt <140 then
		 rect(50-gt/20,0,50,140-((gt-90)*4),3)
		 rect(0,100+gt/20+((gt-90)*2),240,100,12)
		 local width=print(leveltitles[level+(world-1)*4],0,-6)
   print(leveltitles[level+(world-1)*4],(240-width)//2,120+gt/20+((gt-90)*2),5)
		
		
		else
		 gamestate = "play"
		end
		vbank(0)

	
	elseif gamestate == "play" then
	 play()
	end
	
	--debug prints
	local entct = 0
	local parts = 0
	
	for _ in pairs(ents) do 
	 entct = entct + 1 
	end

	for j in pairs(allparticles) do 
	 parts = parts + 1 
	end
	
	vbank(1)
	
 local fps 
 
 ctfr = ctfr+1
 
 local tim = tstamp()-starttime
 
 
 print(mapcoords.x,0,0,8)
	print(mapcoords.y,0,6,8)
	--print(deathwipetimer,0,6,8)
 print((ctfr/tim)//1,0,12,8)

	vbank(0)
	
	
	
	
end



function play()
 
 camshake()
 
 if cloud == false then
	 if world == 1 then
   clouds(30,false,2,3)
   --rain()
  elseif world == 2 then
   
   clouds(30,false,2,3)
   --rain()
  elseif world == 5 then
   
   clouds(30,false,2,10)
  
  elseif world == 6 then 
   clouds(30,false,5,15)
   --[[ this doesn't work and 
   i don't know why
   
   if math.sin(time()/500) < 0  then
    pal(6,255,159,222)
   else
    pal(6,36,159,222)
   end]]
  elseif world == 7 then
   clouds(30,false,5,7)
  elseif world == 4 then
   --[[seabgmake(40,40)
   seabgmake(100,70)
   seabgmake(200,40)
   seabgmake(0,40)
   seabgmake(70,37)
   seabgmake(-37,10)]]
		end
		
  cloud = true
  --check for ents in whole level
  for i=0,2048,8 do
   for k=0,50,1 do
	    entcheck((i)//8,(-40)//8,k)
	  end
  end
 end
 
 if mus == "start" then
  --music(0,0)
  mus="on"
	elseif mus == "off" then
	 --music()
 end
 
 
 
 if p.dead==false then
  cam.x=lerp(cam.x,p.x-120,0.1)
  
  
  --detect if player flies 
  --off top of screen and lock
 	if p.y>10 and p.y < 280 then
   cam.y=lerp(cam.y,p.y-64,0.1)
  end
  
  
	else
	 gt=gt+1
  if gt<80 then
		 cam.x=lerp(cam.x,p.x-120,0.01)
		elseif gt >=80 then
   gt=0
   --p.deadend = nil
   if difficulty == "easy" then
    init()
    sync(0,world-1,false)
    p.x = lastx
    p.y = lasty
    dir = lastdir
    cam={
				x=0,
				y=0,
				}
   elseif difficulty == "normal" then
    init()
    sync(0,world-1,false)
   elseif difficulty == "hard" then
    init()
    world = 1
    level = 1
    sync(0,world-1,false)
   end
		end					
	end
	
	entlogic()
	if ltt == 0 then
	 control()
 end
	
				
 --Background
	--map(0,102,90,34,-cam.x/2-70,-cam.y/2-260,0,2)
 cls()
 
 if xon == true then
	 solids[178] = true
		solids[180] = false
	elseif xon == false then
	 solids[178] = false
		solids[180] = true
	end

	if bganim == true then
		if world == 2 then
		 rect(60-p.x/100,50,20,150,11)
			rect(100-p.x/100,40,20,150,11)
			rect(230-p.x/100,90,20,150,11)
	  clouds(280+cam.x,true,2,3)
		--	rain()
		elseif world == 3 then
		spr(338,40,20)
   clouds(280+cam.x,true,4,5)
   --rain()
	 elseif world == 6 then
		 clouds(280+cam.x,true,5,15)
	 elseif world == 7 then
	  clouds(280+cam.x,true,5,7)
		elseif world == 4 then
		 tri(60-p.x/100,136,
			    210-p.x/100,30,
			    300-p.x/100,136,15)
			tri(-80-p.x/100,136,
			    40-p.x/100,30,
			    140-p.x/100,136,15)
   
   bubbles(p.x+4,p.y,40,600,1)
  elseif world == 5 then
		 tri(60-p.x/100,136,
			    210-p.x/100,30,
			    300-p.x/100,136,15)
			tri(-80-p.x/100,136,
			    40-p.x/100,30,
			    140-p.x/100,136,15)
							
		 clouds(280+cam.x,true,2,10)
   
  elseif world == 8 then
	  lines()
		end
	end
 
 if #allparticles~=0 then
  particlelogic()
  for i,particle in ipairs(allparticles) do
   if particle.layer == 2 then
    circ(particle.x-cam.x,particle.y-cam.y,particle.rad,particle.clr)
   end
  end
	end
	
	--bottomtrees
	if world == 2 then
		for i = 1,240,1 do
		 circ(i*17-cam.x/2-50+math.sin(time()/600),200-cam.y/2+math.sin(i)*4+math.sin(time()/(800*i)),19,15)
		 circ(i*17-cam.x/2-60+math.sin(time()/300),180-cam.y/2+math.sin(i)*4+math.sin(time()/(800*i)),15,14)
	 end
	elseif world == 4 then
	 if math.sin(time()/9000) <0 then
	  spr(383,math.cos(time()/9000)*160+120,40+math.sin(time()/10000)*10,0,1,1)
	 else
		 spr(383,math.cos(time()/9000)*160+120,40+math.sin(time()/10000)*10,0,1,0)
		end
		--seabglogic()
 end
 
 
 --tiles and stuff
 map(0,0+(level-1)*34,240,33,-cam.x,-cam.y,0,1,remap)
 
 if #allparticles~=0 then
  for i,particle in ipairs(allparticles) do
   if particle.layer == 3 then
    circ(particle.x-cam.x,particle.y-cam.y,particle.rad,particle.clr)
   end
  end
	end
	
	-- not vbank 1 lol
	for i,ent in ipairs(ents) do
	 if world == 2 then
	  if ent.ty == 454 or ent.ty == 199 
		 or ent.ty == 471 then
    circ(ent.ct-cam.x+3,ent.d-cam.y+5,6,5)
   end
  end
	
	
  if ent.ty == 454 then
   
   spr(198,ent.ct-cam.x,ent.d-cam.y,0,1,ent.fl,ent.rot)
   line(ent.x-cam.x+4, ent.y-cam.y+4,ent.ct-cam.x+4, ent.d-cam.y+4,13)
   line(ent.x-cam.x+3, ent.y-cam.y+4,ent.ct-cam.x+3, ent.d-cam.y+4,13)
  
		 spr(ent.ty,ent.x-cam.x,ent.y-cam.y,0,1,ent.fl,ent.rot)
  elseif ent.ty == 199 then
   spr(199,ent.ct-cam.x,ent.d-cam.y,0,1,ent.fl,ent.rot)

   line(ent.x-cam.x+4, ent.y-cam.y+4,ent.ct-cam.x+4, ent.d-cam.y+4,13)
   line(ent.x-cam.x+3, ent.y-cam.y+4,ent.ct-cam.x+3, ent.d-cam.y+4,13)
		
		elseif ent.ty == 466 then
		 line(ent.x+8-cam.x,ent.y+4-cam.y,ent.ct+8-cam.x,ent.d+8-cam.y,13)
		 line(ent.x+9-cam.x,ent.y+4-cam.y,ent.ct+8+1-cam.x,ent.d+8-cam.y,13)
		 line(ent.x+8-cam.x,ent.y+5-cam.y,ent.ct+8-cam.x,ent.d+8-cam.y+1,14)
		 line(ent.x+9-cam.x,ent.y+5-cam.y,ent.ct+8+1-cam.x,ent.d+ 8-cam.y+1,14)
		
			
			spr(466,ent.x-cam.x,ent.y-cam.y,0,1,0,ent.rot)
   spr(466,ent.x+8-cam.x,ent.y-cam.y,0,1,1,ent.rot)
   
   spr(268+(time()/100)%4,ent.x+4-cam.x,ent.y+3-cam.y,0,1,0,ent.rot)
   
   spr(268+(time()/100)%4,ent.ct+8-4-cam.x,ent.d+5-cam.y,0,1,0,ent.rot)
   
		elseif ent.ty == 213 then
		 spr(213,ent.x-cam.x,ent.y-cam.y,0,1,0,ent.rot)
   spr(213,ent.x+8-cam.x,ent.y-cam.y,0,1,1,ent.rot)
  
  --horizontal plat
  elseif ent.ty == 214 then
   line(ent.start-4-cam.x,ent.y+3-cam.y,
        ent.start+ent.range+20-cam.x,ent.y+3-cam.y,2)
		 line(ent.start-4-cam.x,ent.y+4-cam.y,
        ent.start+ent.range+20-cam.x,ent.y+4-cam.y,10)
		 
			spr(214,ent.x-cam.x,ent.y-cam.y,0,1,0,ent.rot)
   spr(214,ent.x+8-cam.x,ent.y-cam.y,0,1,1,ent.rot)
   if ent.move == "right" then
			 spr(268+(ent.ct/10)%4,ent.x+4-cam.x,ent.y+3-cam.y,0,1,0,ent.rot)
   else
    spr(271-(ent.ct/10)%4,ent.x+4-cam.x,ent.y+3-cam.y,0,1,0,ent.rot)
    --this breaks if you use 272. I'm giving up and going to sleep so I can hopefully not screw up the GRE :)
   end
   
   --vert plat
  elseif ent.ty == 230 and ent.start ~= nil then
   line(math.floor(ent.x+7-cam.x),ent.start-4-cam.y,
        math.floor(ent.x+7-cam.x),ent.start+ent.range+12-cam.y,2)
		 line(math.floor(ent.x+8-cam.x),ent.start+ent.range+12-cam.y,
        math.floor(ent.x+8-cam.x),ent.start-4-cam.y,10)
		 
			spr(230,ent.x-cam.x,ent.y-cam.y,0,1,0,ent.rot)
   spr(230,ent.x+8-cam.x,ent.y-cam.y,0,1,1,ent.rot)
   
   if ent.move == "up" then
			 spr(268+(ent.ct/10)%4,ent.x-cam.x,ent.y+3-cam.y,0,1,0,ent.rot)
    spr(268+(ent.ct/10)%4,ent.x+8-cam.x,ent.y+3-cam.y,0,1,1,ent.rot)
   
   else
    spr(271-(ent.ct/10)%4,ent.x-cam.x,ent.y+3-cam.y,0,1,0,ent.rot)
    --this breaks if you use 272. I'm giving up and going to sleep so I can hopefully not screw up the GRE :)
    spr(271-(ent.ct/10)%4,ent.x+8-cam.x,ent.y+3-cam.y,0,1,1,ent.rot)
    --this breaks if you use 272. I'm giving up and going to sleep so I can hopefully not screw up the GRE :)
   
   end
  
   
		elseif ent.ty == 216 
		and ent.xes ~= nil then
		 for i=1,10 do 
			 circ(ent.x+ent.xes[i]-cam.x,
				     ent.y+ent.yes[i]-cam.y,
									ent.rads[i],ent.cols[i])
			end
		
		
		elseif ent.ty == 471 then
		 spr(215,ent.ct-cam.x,ent.d-cam.y,0,1,ent.fl,ent.rot)
  
   line(ent.x-cam.x+4, ent.y-cam.y+4,ent.ct-cam.x+4, ent.d-cam.y+4,13)
   line(ent.x-cam.x+3, ent.y-cam.y+4,ent.ct-cam.x+3, ent.d-cam.y+4,13)
  
		 spr(ent.ty,ent.x-cam.x-2,ent.y-cam.y,0,1,0,ent.rot)
   spr(ent.ty,ent.x-cam.x+2,ent.y-cam.y,0,1,1,ent.rot)
  
		
		
  end
 end
	
	--ent palette change for more colors
 vbank(1)
 -- set palette entry 15 to transparent
 poke(0x03FF8, 0)
 cls(0)
	
 for i,ent in ipairs(ents) do
  if ent.ty ~= 454 and ent.ty ~= 471
  and ent.inpipe == nil 
  and ent.ty ~= 211 
  and ent.ty ~= 227 
  and ent.ty ~= 466
  and ent.ty ~= 213
  and ent.ty ~= 214
  and ent.ty ~= 230  
  and ent.ty ~= 512 then
	
			spr(ent.ty,ent.x-cam.x,ent.y-cam.y,0,1,ent.fl,ent.rot)
	  
	  --mirror sprite if moving plat
	  
			if ent.ty == 220 then
   --spr(220,ent.x-cam.x,ent.y-cam.y,0,1,0,0)
   
   spr(220,ent.x+8-cam.x,ent.y-cam.y,0,1,0,1)
   
   spr(220,ent.x-cam.x,ent.y+8-cam.y,0,1,0,3)
   
   spr(220,ent.x+8-cam.x,ent.y+8-cam.y,0,1,0,2)
   
  
			
	  elseif ent.ty == 197 then
	   spr(ent.ty,ent.x-cam.x+8,ent.y-cam.y,0,1,1)
	   
    if ent.ct<100 or ent.active == false then
	    print("4",ent.x-cam.x+7,ent.y+1-cam.y,2,false,1,true)
	   elseif ent.ct >100 and ent.ct<200 then
	    print("3",ent.x-cam.x+7,ent.y+1-cam.y,2,false,1,true)
	
	   elseif ent.ct >200 and ent.ct<300 then
	    print("2",ent.x-cam.x+7,ent.y+1-cam.y,2,false,1,true)
	
	   elseif ent.ct >300 and ent.ct<400 then
	    print("1",ent.x-cam.x+7,ent.y+1-cam.y,2,false,1,true)
	   else
	    print("0",ent.x-cam.x+7,ent.y+1-cam.y,2,false,1,true)
	   end
			elseif ent.ty == 466 then
			 spr(ent.ty,ent.x-cam.x+8,ent.y-cam.y,0,1,1)
	  
			end
		elseif ent.ty == 512 then
		
		 local string = "Checkpoint!"
		 
		 local width=print(string,0,-6)
		 local bg,fg = 10,5
		 --set foreground and background colors
		 if world == 1 and level == 4 then
		  fg = 11
		 elseif world == 2 then
		  bg = 14
		  fg = 13
		 end
			
		 print(string,(240-width)//2,ent.y,bg)
		 print(string,(240-width)//2-1,ent.y-1,bg)
		 print(string,(240-width)//2,ent.y-1,fg)
		 
			 
		end
 end
 
	if p.onplat == false then
	 spr(p.spr,math.floor(p.x-cam.x),(p.y-cam.y),0,1,p.fl,p.rot)
	 
		--hat
		--spr(p.spr+4,math.floor(p.x-cam.x),(p.y-cam.y)-6,0,1,p.fl,p.rot)
	 --sunglasses w8
		--spr(p.spr+4,math.floor(p.x-cam.x),(p.y-cam.y)-1,0,1,p.fl,p.rot)
	 
	else
	 if ents[p.platent].ploc ~= nil then
	  spr(p.spr,ents[p.platent].x-cam.x+ents[p.platent].ploc,ents[p.platent].y-cam.y-8,0,1,p.fl,p.rot)
	 end
	end
	
	if #allparticles~=0 then
  for i,particle in ipairs(allparticles) do
   if particle.layer >= 5 then
	   if particle.rad == 0 then
	    pix(particle.x-cam.x,particle.y-cam.y,particle.clr)
	   else
				 if particle.typ == 3 then
	     circb(particle.x-cam.x,particle.y-cam.y,particle.rad,particle.clr)
	    else
					 circ(particle.x-cam.x,particle.y-cam.y,particle.rad,particle.clr)
	   
					end
				end
			end
  end
	end
	
	if p.y <-10 then
	 spr(511,p.x-cam.x,0)
	elseif p.y > 260 then
	 spr(511,p.x-cam.x,128)
	end
	
 vbank(0)
 if world == 1 or world == 7 then
  leaves("left",13,4)
 elseif world == 4 then
  leaves("up",5)
 end
 plantlogic()
	
	
	if #allparticles~=0 then
  for i,particle in ipairs(allparticles) do
   if particle.layer == 4 then
	   if particle.rad ==0 then
	    pix(particle.x-cam.x,particle.y-cam.y,particle.clr)
	   else
	    circ(particle.x-cam.x,particle.y-cam.y,particle.rad,particle.clr)
	   end
			end
  end
	end
	
	--signs
 if mget((p.x+4)//8,(p.y+3)//8+(level-1)*34) == 114 
 or mget((p.x+4)//8,(p.y+10)//8+(level-1)*34) == 114 then
 local string
 if p.x<960 then
  string=text1[level+world*4-4]
 else
  string=text2[level+world*4-4]
 end
 
 
 local width=print(string,0,-6)
 local bg,fg = 10,5
 --set foreground and background colors
 if world == 1 and level == 4 then
  fg = 11
 elseif world == 2 then
  bg = 14
  fg = 13
 end
 print(string,(240-width)//2,(136-6)//2-19,bg)
 print(string,(240-width)//2,(136-6)//2-21,bg)
 print(string,(240-width)//2+1,(136-6)//2-20,bg) 
 print(string,(240-width)//2-1,(136-6)//2-20,bg)
 print(string,(240-width)//2,(136-6)//2-20,fg)
 
 end
 
 if lst >0 then
  lst = lst+1
  if lst > 30 then
   lst = 0
  end
 end

	if ltt>0 then
	 ltt = ltt+1
		
	 if ltt>=110 and ltt < 120  then
		 init()

			checkpoint = false
			--[[
   for k in pairs(allparticles) do
    allparticles[k] = nil
   end
			
			for i in pairs(ents) do
    ents[k] = nil
   end
   
   idk if this does anything
   in theory it clears everything, 
   but its still super slow on lv3+]]
			
			--reset checkpoints so 
			--player will start at start
			lastx = cam.x+70
	  lasty = cam.y+70
	  lastdir = "down"
			
			if level < 4 and orb == false then
		  --level=level+1
				--sky changes
				--[[
				if level == 2 then
				 pal(0,77,101,180)
				elseif level == 3 then
					pal(0,72,74,119)
				elseif level == 4 then
				 pal(0,50,51,83)
				end]]
			else
			 --worldchange(world+1,1)
			end
	  gamestate = "worldmap"
			sync(0,0)
			gt = 0
			allparticles = {}
   lst = 1
   ltt = 0
		end
	end
	
	 wipelogic()
		if deathwipe == true then
		deathwipetimer = deathwipetimer+1
		vbank(1)		
		rect(0,136-deathwipetimer*2,240,136*3-deathwipetimer*3,12)
			if deathwipetimer >150 then
			 deathwipe = false
				deathwipetimer = 0
			end
		vbank(0)
		end
		
end

function remap(tile,x,y)
 --[[here's the thing with remap.
     it doesn't change the base tile
     only the visual of the base tile
 
 
 ]]
	local outTile,flip,rotate=tile,0,0
	
	if tile == 176 and xon == true then
	 outTile=177
	elseif tile == 176 and xon == false then
	 outTile=176
	end
	
	--[[if tile == 24 then
	 circ(x*8-cam.x,y*8-cam.y,20,13)
	end]]

	
	if tile == 178 and xon == true then
	 outTile=178
	elseif tile == 178 and xon == false then
	 outTile=179
	end
	
	if tile == 180 and xon == false then
	 outTile=180
	elseif tile == 180 and xon == true then
	 outTile=181
	end
	
	 if tile == 188 then
		 bubbles(x*8,y*8,30,100,6)
		end
		if tile == 189 then
		 bubbles(x*8,y*8,30,100,7)
		end
		if tile == 190 then
		 bubbles(x*8,y*8,30,100,-1)
		end
		if tile == 191 then
		 bubbles(x*8,y*8,30,100,1)
		end
		
		-- munchers
	 if tile==49 
		and math.sin(time()/90) <0.5 then
			outTile=51
		end
		if tile==50 
		and math.sin(time()/90) <0.5 then
			outTile=52
		end
		if tile==65 
		and math.sin(time()/90) <0.5 then
			outTile=67
		end
	 if tile==66 
		and math.sin(time()/90) <0.5 then
			outTile=68
		end
	if world == 1 then
	 
		
	elseif world == 3 then
	 
	 if tile==45
		and math.sin(time()/90) <0.5 then
			outTile=46
		end
		
		if tile==103
		and math.sin(time()/90) <0.5 then
			outTile=104
		end
		
	elseif world == 5 then
	 
	 if tile==60
		and math.sin(time()/90) <0.5 then
			outTile=61
		end
		
		if tile==76
		and math.sin(time()/90) <0.5 then
			outTile=77
		end
		
	elseif world == 6 then
	 -- fans
		if tile==52 
		and math.sin(time()/30) <0.5 then
		 
		outTile=53
		end
	
	elseif world == 7 then
	 -- fans
		if tile==52 
		and math.sin(time()/30) <0.5 then
			outTile=53
		end
		-- conveyor
		if tile == 54 then
		 outTile = math.floor(time()/300)%8+54
		end
		if tile == 61 then
		 outTile = -math.floor(time()/300)%8+54
		end
		--acid
		if tile == 68 then
		 outTile = math.floor(time()/300)%8+68
		end
		
 elseif world == 4 then
  if tile == 9 then
   if math.sin(time()/500) <0.34 then
		  outTile = 9
			elseif math.sin(time()/500) <0.7 then
		  outTile = 10
			else
			 outTile = 11
	  end
		end
		
		if tile == 25 then
   if math.sin(time()/500) <0.34 then
		  outTile = 25
			elseif math.sin(time()/500) <0.7 then
		  outTile = 26
			else
			 outTile = 27
	  end
		end
 
  
		
 
 elseif world == 3 then
 --[[ old crystal noise texture
	 if tile == 93 
		or tile == 94 
		or tile == 95
		or tile == 109 
		or tile == 111
		or tile == 125
		or tile == 126
		or tile == 127 then
		 if math.random (6) == 1 then
	   spawnparticle(x*8+math.random(6)+1,y*8+math.random(7),0,0,0,0,15,5,1,false,0,4)
			else
			 spawnparticle(x*8+math.random(6)+1,y*8+math.random(7),0,0,0,0,15,5,8+math.random(3),false,0,4)
		 end
	 end]]
 
	end
	
	return outTile
end

function BDR(scnline)
 local dither = dpat[scnline+1]
 if world == 2 and level == 1 then
	 if dither == 1 then
	  pal(0,77,155,230)
	  pal(11,77,101,180)
	 elseif dither == 2 then
	  pal(0,77,101,180)
			pal(11,77,101,180)
	 else 
	  pal(0,72,74,119)
			pal(11,72,74,119)
	 end
			elseif world == 2 and level == 2 then
		if dither == 1 then
	  pal(0,77,101,180)
			pal(11,72,74,119)
	 elseif dither == 2 then
	  pal(0,72,74,119)
			pal(11,72,74,119)
	 else
	  pal(0,50,51,83)
			pal(11,50,51,83)
	 end
	elseif world == 2 and level == 3 then
	 --sunset
		if dither == 1 then
	  pal(0,251,107,29)
			pal(11,251,185,84)
	 elseif dither == 2 then
	  pal(0,232,59,59)
			pal(11,251,107,29)
	 else
	  pal(0,174,35,52)
			pal(11,232,59,59)
	 end
		
		--browns
		pal(10,46,34,47)
		pal(1,69,41,63)
		pal(8,158,69,57)
		
	elseif world == 2 and level == 4 then
	 --clouds 1
		pal(3,72,65,119)
		pal(2,62,53,70)
		--grass
		pal(7,55,78,74)
		pal(6,84,126,100)
		pal(5,146,169,132)
		--rocks
		pal(8,110,39,39)
		pal(9,158,69,57)
		pal(10,205,104,61)
		--trees
		pal(15,179,56,49)
		pal(14,234,79,54)
		pal(13,245,125,74)
		--buildings
		pal(11,62,53,70)
		if dither == 1 then
	  pal(0,50,51,83)
	 elseif dither == 2 then
	  pal(0,46,34,47)
	 else
	  pal(0,46,34,47)
	 end
	elseif world == 3 then
	 if dither == 1 then
	  pal(0,72,74,119)
	 
	 elseif dither == 2 then
	  pal(0,50,51,83)
			
	 else 
	  pal(0,46,34,47)
		
	 end
		
		
	elseif world == 4 then
	 if dither == 1 then
	  pal(0,77,155,230)
	 elseif dither == 2 then
	  pal(0,77,101,180)
	 else
		 pal(0,74,72,119)
	  --pal(0,50,51,83)
	 end
	
	elseif world == 5 and level == 1 then
	 if dither == 1 then
	  pal(0,77,155,230)
	 elseif dither == 2 then
	  pal(0,77,101,180)
	 else 
	  pal(0,72,74,119)
	 end
	
	
	end
end

function camshake()
 if shakelength >=1 and shakelength <10 then
  cam.x = cam.x+ math.random (2)-1
  cam.y = cam.y + math.random (2)-1
  shakelength = shakelength +1
 else
  shakelength = 0
 end
end

function control()
 --really more of a player centric function
 if btnp(6) then
  shakelength = 1
 end
	
 if p.dead==false then
  
  
  if p.clawtimer ~= nil then
   p.clawtimer = p.clawtimer + 1
   if p.clawtimer >30 then
    p.clawtimer = nil
   end
  end
		
		--move
		if p.stuck == false 
		and p.clawed == false
		and p.insling== false 
		and p.incrystal == false then
		 local friction,scap
			if mget((p.x+3)//8,(p.y+8)//8+(level-1)*34) == 184 then
			 friction = 0.01
				scap = 1.6
			elseif mget((p.x+3)//8,(p.y+8)//8+(level-1)*34) == 185 then
			 friction = 0.5
				scap = 3
			else
			 friction = 0.2
				scap = 1.6
			end
 
   if speed == true then scap = scap*1.6 end
		
	  if btn(2) then 
			    if p.vx>-scap then 
							 p.vx=p.vx-friction
							 p.fl =1
							--air speed cap i think
							elseif p.vy<0 and p.vx>-2 then
							 p.vx=p.vx-friction
							end 
	  elseif btn(3) then 
	      if p.vx<scap then 
							 p.vx=p.vx+friction
								p.fl = 0
							elseif p.vy<0 and p.vx<2 then
							 p.vx=p.vx+friction 
							end
			else
	      if p.vx>0.1 then 
	       p.vx=p.vx-friction 
							elseif p.vx<-0.1 then 
							 p.vx=p.vx+friction  
							elseif p.vx<.5 and p.vx>-.5 then 
							 p.vx=0
							end
	  end
		elseif p.clawed == false then	
			
	 end
		--climbing, duh 
		if dir == "down" then
			if climby(p.x+8+p.vx,p.y) or climby(p.x+8+p.vx,p.y+7) then
	      if btn(0) then 
							    p.vy=p.vy-.4	
											climb=true
											p.rot = 3
							else
							 grv = 0.6*grvmax
							end		
			elseif climby(p.x-1+p.vx,p.y) or climby(p.x-1+p.vx,p.y+7) then	
			    if btn(0) then 
							    p.vy=p.vy-.4	
											climb=true
											p.rot=3
											p.fl=1
							else
							 grv = 0.6*grvmax
							end		
			else
			    climb=false
							grv = grvmax
			end
		else
		 if climby(p.x+8+p.vx,p.y) or climby(p.x+8+p.vx,p.y+7) then
	      if btn(1) then 
							    p.vy=p.vy+.4	
											climb=true
											p.rot = 3
							else
							 grv = -0.6*grvmax
							end		
			elseif climby(p.x-1+p.vx,p.y) or climby(p.x-1+p.vx,p.y+7) then	
			    if btn(1) then 
							    p.vy=p.vy+.4	
											climb=true
											p.rot=3
											p.fl=1
											
							else
							 grv = -0.6*grvmax
							end		
			else
			    climb=false
							grv = -grvmax
			end
		end
	end
	
 playeranim()
 
	if p.y < 240 and p.y > 0 then  
	 collision()
	elseif p.y <-200 then
		death(false)
	elseif p.y < 0 and dir == "up" then
			death(false)
	elseif p.y > 260 and dir == "down" then
			death(false)
	end
	--falling out of world.
	--player can still die if they go 
	--above though
	 
  if p.cjct > 0 then
   p.cjct = p.cjct-1
  elseif p.cjct <=0 then
   p.canjump = false
  end
 
		
		--jump
		if p.canjump==true 
		or p.onplat == true then
		 if btn(4) then
			  p.vy=0
		   p.jump=true
					p.stuck = false
     p.canjump = false
     p.cjct = 0
     p.onplat = false
     if p.inpipe ~= true then
      dustpoofs()
     end
			end
  end

	 if p.stuck == true then
   if btnp(4) then
		   p.jump=true
					p.stuck = false
					onground = false
					onceil = false
     p.onplat = false
     p.cjct = 0
			end
		end
	
		if p.jump==true then
		 if btn(4) then
			 p.jct=p.jct+1
			else
			 p.jct=0
				p.jump=false
			end
			if p.jct<=7 then
			
			  --try setting up based on ceil
					--and floor to enable this to
					--work with sticky too
					
				 if p.stuckceil == true then
					 p.vy=p.vy+.2
					elseif grv>0 then
					 p.vy=p.vy-.6			
					elseif grv<0 then
					 p.vy=p.vy+.6
					end
				--[[if btnp(5)then
				 if p.speed==true then
				  p.vx=p.vx*2
					end
				end]]
			elseif p.jct>7 then
				p.jct = 0
				p.jump=false
				p.stuckceil = false
			end
		end
		
		
		--ok so whats broken;
		--if player has vx abs val above 4.5
		--they dont get s
		
	-- conveyor
	if world == 7 then
		if onground == true 
		and mget((p.x+7)//8,(p.y+8)//8+(level-1)*34) == 54 
	 or mget((p.x)//8,(p.y+8)//8+(level-1)*34) == 54 then
	  
		  if btn(2) then
		    p.vx = p.vx*0.9
		  elseif btn(3) then
				 if p.vx <= 3 
					and p.vx > 0 then
				  p.vx = p.vx*1.5
					else 
					 p.vx = 3
					end
				else
				 if p.vx < 5 then
		    p.vx = p.vx+.1*p.conveyortimer
		  end
			end
			
			 if p.conveyortimer <0 
				or p.conveyortimer >7  then 
				 p.conveyortimer = 1
				end
		
				
			p.conveyortimer = p.conveyortimer + 1
			
	 -- reverse
	 elseif onground == true 
		and mget((p.x+7)//8,(p.y+8)//8+(level-1)*34) == 61 
	 or mget((p.x)//8,(p.y+8)//8+(level-1)*34) == 61 then
	  
		  if btn(2) then
				 if p.vx >= -3 
					and p.vx < 0then
		    p.vx = p.vx*1.5
					else 
					 p.vx = -3
					end
		  elseif btn(3) then
	
				  p.vx = p.vx*0.9
	
				else
				 if p.vx > -5 then
		    p.vx = p.vx+.1*p.conveyortimer
					end
		  end
				if p.conveyortimer >0 
				or p.conveyortimer <-7 then 
				 p.conveyortimer = -1
				end
				p.conveyortimer = p.conveyortimer - 1
				
	 else
	 
	  p.conveyortimer = 1
	 end	
 end
	
	if onground == true 
	or onceil==true then
	
 else
  local watermult = 1
  if p.stuck == false 
  and p.inpipe == false then
   --regrab ability
	   if underwater == true then
	    if p.vy<1 then
	     watermult = 0.6
	    elseif p.vy>1 then
	     watermult = 0.3
	    end
	   end
   
   if p.clawed == false
   and p.insling == false 
   and p.incrystal == false then
    --regrab
	   if btn(4) then
	    
					if p.vy > 1 then
					 p.spr = 272
						p.vy=p.vy+grv*0.6*watermult
					else 
					 p.vy=p.vy+grv*0.85*watermult
					end
				--fastfall
				elseif btn(1) then
					p.vy=p.vy+grv*1.3*watermult
					p.spr = 273
				else
	    p.vy=p.vy+grv*watermult
	   end
   end
  end
 end
	
	if p.inpipe==false 
	and p.clawed == false 
	and p.insling == false then
	 --if p.onplat == false then
		 p.x=p.x+p.vx
		 p.y=p.y+p.vy
		--else
			--p.x = p.x+platspeed
		--end
 end
	p.sprct=p.sprct+1
	
end

function landing()
 if p.incrystal == true 
	and p.vy>1 then
		death()
 
 else
  if p.vy > 1 and p.inpipe ~= true then
   dustpoofs()
  end
  
  p.vy=0
  jump=false
		p.canjump = true
		p.cjct=7
	 p.jct=0
	 onground=true
		p.stuckceil = false
  
 end
	
	if sticky(p.x+1,p.y+8+p.vy) 
	or sticky(p.x+6,p.y+8+p.vy) then
  stick()
	 p.y = math.floor(p.y/8+0.5)*8+1
	end 
end

function stick()
 p.vx=0
 p.vy=0
 p.stuck = true
 p.jump = false
 jump=false
end

function collision()

 if oldcrystal(p.x+7,p.y+p.vy)
 or oldcrystal(p.x,p.y+p.vy)
 or oldcrystal(p.x+7,p.y+p.vy+7)
 or oldcrystal(p.x,p.y+p.vy+7) then
  p.incrystal = true
 else
  if p.incrystal == true then
   p.crystaltimer = 1
   p.incrystal = false
  end
 end
 
 --oldplace boosting
 if p.crystaltimer ~= nil
 and p.crystaltimer <30 then
  p.crystaltimer = p.crystaltimer + 1
  if btnp(4) then
   p.vx = p.vx * 1.5
   p.vy = p.vy * 1.5
  end 
 elseif p.crystaltimer ~= nil 
 and p.crystaltimer >= 30 then
  p.crystaltimer = nil
 end

 --pipessss

 if pipe(p.x+4,p.y+p.vy) then
  p.inpipe = true
  p.vy=0
  p.vx=0
  p.x = (p.x+4)//8*8
  p.pipedir = "up"
  p.lastdir = 0
 elseif pipe(p.x+4,p.y+8+p.vy) then
  p.inpipe = true
  p.vy=0
  p.vx=0
  p.y = p.y+2
  p.x = (p.x+4)//8*8
  p.pipedir = "down"
  p.lastdir = 0
 end
 
 
 if p.inpipe == true then
  local tile
  tile = mget((p.x)//8,(p.y)//8+(level-1)*34)

  if tile == 25 or tile == 41 
  or tile == 31 or tile== 45 
  or tile == 26 then
   p.y=p.y-3
    
   --go up
   p.pipedir = "up"
   p.lastdir = -1
   
  elseif tile == 9 or tile == 10 
  or tile == 29 or tile == 42 then
   p.x=p.x+1
   -- go right
   p.pipedir = "right"
   
  elseif tile == 11
  or tile == 27 
  or tile == 28 
  or tile == 14 
  or tile == 15 
  or tile == 43 then
   p.y = p.y+1
   p.pipedir = "down"
   p.lastdir = 1
   
  elseif tile == 12 or tile == 13 
  or tile == 44 or tile == 30 then
   p.x = p.x-1
   p.pipedir = "left"

  else 
  --exit pipe
 


   if p.pipedir == "up"  then
	   p.x = p.x//8*8
	   p.y = p.y//8*8
				p.vy = -2
	  elseif p.pipedir == "down" then
    --entering the pipe breaks 
    --if I add any more in the exit code
				p.y = p.y-6
				p.vy = 2
			elseif p.pipedir == "left" then
			 p.x = p.x//8*8+12
	   p.y = p.y//8*8
				p.vx = -2
			
			elseif p.pipedir == "right" then
				p.x = p.x//8*8
	   p.y = p.y//8*8
				p.vx = 2
		  
	  end
   p.inpipe = false
  end 
 end
 
 --acid
 if world == 7 then
  if mget((p.x+4)//8,(p.y+7)//8+(level-1)*34) == 68 then
   death(false)
  end
 end
 
 --checkpoint flags
 
 if mget((p.x+7)//8,(p.y+7)//8+(level-1)*34) == 128 
 or mget((p.x)//8,(p.y+7)//8+(level-1)*34) == 128 
 or mget((p.x+7)//8,(p.y)//8+(level-1)*34) == 128 
 or mget((p.x)//8,(p.y)//8+(level-1)*34) == 128 
 or mget((p.x+7)//8,(p.y+7)//8+(level-1)*34) == 144 
 or mget((p.x)//8,(p.y+7)//8+(level-1)*34) == 144 
 or mget((p.x+7)//8,(p.y)//8+(level-1)*34) == 144 
 or mget((p.x)//8,(p.y)//8+(level-1)*34) == 144 then

 	lastx = p.x
		lasty = p.y
		lastdir = dir
	
	 if checkpoint == false then
			for i=0,6,1 do
	   spawnparticle(p.x+4,p.y+4,math.random(6)-3,math.random(6)-6,0,.2,3000,5,5,false,0,4)
	  end
			
			entmake(p.x,p.y-cam.y,0,0,512,0,0,false,0,0,false)
			
			
			checkpoint = true
  end
 end
 
 --right bubbles
 if mget((p.x+7)//8,(p.y+7)//8+(level-1)*34) == 188 
 or mget((p.x)//8,(p.y+7)//8+(level-1)*34) == 188 
 or mget((p.x+7)//8,(p.y)//8+(level-1)*34) == 188 
 or mget((p.x)//8,(p.y)//8+(level-1)*34) == 188 then
  p.vx = p.vx + 0.3
 end
 
 --left bubbles
 if mget((p.x+7)//8,(p.y+7)//8+(level-1)*34) == 189 
 or mget((p.x)//8,(p.y+7)//8+(level-1)*34) == 189 
 or mget((p.x+7)//8,(p.y)//8+(level-1)*34) == 189 
 or mget((p.x)//8,(p.y)//8+(level-1)*34) == 189 then
  p.vx = p.vx - 0.3
 end
 
 
 --jet bubbles
 if mget((p.x+7)//8,(p.y+7)//8+(level-1)*34) == 191 
 or mget((p.x)//8,(p.y+7)//8+(level-1)*34) == 191 
 or mget((p.x+7)//8,(p.y)//8+(level-1)*34) == 191 
 or mget((p.x)//8,(p.y)//8+(level-1)*34) == 191 then
  p.vy = p.vy - 0.3
 end
 
 --quicksand bubbles
 if mget((p.x+7)//8,(p.y+7)//8+(level-1)*34) == 190 
 or mget((p.x)//8,(p.y+7)//8+(level-1)*34) == 190 
 or mget((p.x+7)//8,(p.y)//8+(level-1)*34) == 190 
 or mget((p.x)//8,(p.y)//8+(level-1)*34) == 190 then
  p.vy = p.vy + 0.3
 end
 
 --falling and landing
 if grv>0 then
 
		if solid(p.x+1,p.y+7+p.vy) 
		or solid(p.x+6,p.y+7+p.vy) 
		or mget((p.x+1)//8,(p.y+7+p.vy)//8+(level-1)*34) == 182 
  or mget((p.x+6)//8,(p.y+7+p.vy)//8+(level-1)*34) == 182 
  then
		 landing()
	 else
			if climb==false then
	   jump=true
			end
			onground=false
	 end
 elseif grv<0 then
	 if solid(p.x+1,p.y-1+p.vy) 
		or solid(p.x+6,p.y-1+p.vy) 
		or mget((p.x+1)//8,(p.y-1+p.vy)//8+(level-1)*34) == 182 
  or mget((p.x+6)//8,(p.y-1+p.vy)//8+(level-1)*34) == 182 
  then
		 landing()
	 else
			if climb==false then
	   jump=true
			end
			onground=false
	 end
 end
 
 if unstable(p.x+1,p.y+7+p.vy) 
	or unstable(p.x+6,p.y+7+p.vy) then
  if grv>0 and p.vy >.2 then
   p.vy=0
	  jump=false
			p.canjump = true
			p.cjct=7
		 p.jct=0
		 onground=true
			p.stuckceil = false
   
  end
 end
		
	
	if oneway(p.x+1,p.y+7+p.vy) 
	or oneway(p.x+6,p.y+7+p.vy) then
  if grv>0 and p.vy >.2 then
   ononeway=true
  end
 else
  ononeway=false
 end
 
 
 
 if ononeway == true then
  p.vy=0
  jump=false
		p.canjump = true
		p.cjct=7
	 p.jct=0
	 onground=true
		p.stuckceil = false
 end

 if deathy(p.x,p.y+7+p.vy) or deathy(p.x+7,p.y+7+p.vy) or deathy(p.x,p.y+p.vy) or deathy(p.x+7,p.y+p.vy) then
		death()
	end
  
  if upflip(p.x,p.y+7+p.vy) or upflip(p.x+7,p.y+7+p.vy) or upflip(p.x,p.y+p.vy) or upflip(p.x+7,p.y+p.vy) then
      if dir ~= "up" then
       dir = "up"
       onground=false
      end
      
  
  elseif downflip(p.x,p.y+7+p.vy) or downflip(p.x+7,p.y+7+p.vy) or downflip(p.x,p.y+p.vy) or downflip(p.x+7,p.y+p.vy) then
      if dir ~= "down" then
       dir = "down"
       onceil=false
      end
  
  end
  
  if flaggy(p.x,p.y+8+p.vy) or flaggy(p.x+3,p.y+p.vy) then
			p.vx = 0
			checkpoint = false
			
			if p.canjump == true then
			 ltt = 1 --level transition timer
			end
  end

 --ORB
  if mget((p.x+7)//8,(p.y+p.vy)//8+(level-1)*34) == 160 
  or mget((p.x)//8,(p.y+p.vy)//8+(level-1)*34) == 160 
  or mget((p.x+7)//8,(p.y+7+p.vy)//8+(level-1)*34) == 160 
  or mget((p.x)//8,(p.y+7+p.vy)//8+(level-1)*34) == 160 then 
   --level = 4
   p.vx = 0
   p.vy = 0
   orb = true
			--if p.canjump == true then
			 ltt = 1 --level transition timer
			--end
  end

  --walls
 if solid(p.x+7+p.vx,p.y+p.vy+5) 
 or solid(p.x+7+p.vx,p.y+p.vy+3) then
 
  if sticky(p.x+8+p.vx,p.y+5) 
  or sticky(p.x+8+p.vx,p.y+1)then
   stick()
   p.rot = 1
   p.fl = 1
   p.x = math.floor(p.x/8+0.5)*8+1
  end
  
  if p.incrystal == true then
   
				death()
   
  else
	  if p.vx >0 then
	   p.vx=0
	  end
  end
  
 elseif solid(p.x+p.vx,p.y+p.vy+6) 
 or solid(p.x+p.vx,p.y+3+p.vy) then

  if  sticky(p.x-1+p.vx,p.y+5)
  or sticky(p.x-1+p.vx,p.y+1)then 
   stick()
   p.rot = 1
   p.fl = 2
   p.x = math.floor(p.x/8+0.5)*8+1
  end
  
  if p.incrystal == true then
   
			death()
   
  else
	  if p.vx <0 then
	   p.vx=0
	  end
	  if climb == false then
	   --was something in here at 1 pt?
	  end
		end 
 end
 
 --only place solid blocks, 
 --otherwise it won't work
 
 if mget((p.x+7)//8,(p.y+p.vy-2)//8+(level-1)*34) == 176 
 or mget((p.x+3)//8,(p.y+p.vy-2)//8+(level-1)*34) == 176 
 or mget((p.x)//8,(p.y+p.vy-2)//8+(level-1)*34) == 176 then 
  --p.vy = 30
  if xon == true and p.vy<0 and xct ==0 then
	  xon = false
			xct = 1
	 elseif xon == false and p.vy<0 and xct == 0 then
	  xon = true
			xct = 1
	 end
 end
 
 --onoff xon timer to prevent multi triggers
 
 if xct>0 then xct = xct+1 end
 
 if xct>10 then xct = 0 end
  
  --bonk 
 if solid(p.x+1,p.y+p.vy*1.2) 
 or solid(p.x+7,p.y+p.vy*1.2) then
  
  if sticky(p.x+1,p.y-2+p.vy) 
  or sticky(p.x+6,p.y-2+p.vy) then
   stick()
   p.y = math.floor(p.y/8+0.5)*8+1
  end
  
  if p.incrystal == true then
			death()
  else
	  if grv<0 then
	   jump=false
			 p.jct=0
			 p.onground=true
	  end
			
			--nudging/corner correction attempt
			--holy cow that was too easy lol
			
			if not solid(p.x+4,p.y+p.vy*1.2) 
			and not solid(p.x,p.y+p.vy*1.2) 
			and p.vy <0 then
				p.x = p.x-3
			elseif not solid(p.x+4,p.y+p.vy*1.2) 
			and not solid(p.x+8,p.y+p.vy*1.2) 
			and p.vy <0 then
				p.x = p.x+3
			else
			 if p.vy<0 then
		   p.vy=0
				end
			end
  end
 end 

 if dir == "up" then
	 -- bonk but upside down
	 if solid(p.x+1,p.y+7+p.vy*1.2) 
	 or solid(p.x+7,p.y+7+p.vy*1.2) then
	  
	  if sticky(p.x+1,p.y-2+p.vy) 
	  or sticky(p.x+6,p.y-2+p.vy) then
	   stick()
	   p.y = math.floor(p.y/8+0.5)*8+1
	  end
	  
	  if p.incrystal == true then
				death()
	  else
		  if grv>0 then
		   jump=false
				 p.jct=0
				 p.onceil=true
		  end
				
				--nudging/corner correction attempt
				--holy cow that was too easy lol
				
				if not solid(p.x+1,p.y+7+p.vy*1.2)
				and p.vy >0 then
					p.x = p.x-3
				elseif not solid(p.x+7,p.y+7+p.vy*1.2) 
				and p.vy >0 then
					p.x = p.x+3
		
				else
				 if p.vy>0 then
			   p.vy=0
					end
				end
	  end
	 end 
 end
 
 if p.stuck == true and
 sticky(p.x+3,p.y-3) then
  p.stuckceil = true
  p.rot = 2
  p.fl = 1
 end
 
end

function playeranim()
 if climb == false and p.stuck == false then
  p.rot = 0
 end
 
 if dir == "down" then
  p.rot = 0
 else
  p.rot = 2
 end
		
	if p.exp==false then
  if p.stuck == true 
  or onground == true 
  or onceil == true 
  or p.onplat == true then
   if grv>0 then
	   if p.sprct<8 then
	    p.spr=256
	 		elseif p.sprct>16 and p.sprct<33 then
	 		 p.spr=257
	 		elseif p.sprct>32 then
	 		 p.sprct=0
		 	end
			else
			 if p.sprct<8 then
	    p.spr=272
	 		elseif p.sprct>16 and p.sprct<33 then
	 		 p.spr=273
	 		elseif p.sprct>32 then
	 		 p.sprct=0
		 	end
				
		--clean up and just flip the sprite
			
		 end
	 elseif onground == false or onceil == false then
   if p.sprct<8 then
    p.spr=258
	 	elseif p.sprct>8 and p.sprct<17 then
		  p.spr=259
		 elseif p.sprct>16 then
		  p.sprct=0
				p.portaled = false
		 end
		end
	else
	 p.spr=0
	end
	if p.inpipe == true then
	 p.spr = 0
	end
	
end

function death(exp)

 if p.dead == false then
  gt=0
 end
 if exp == nil then exp = true end
 p.dead=true
 deathwipe = true
	p.exp=true
	p.vx=0
	p.vy=0
 if gt<15 and exp == true then
	 for i=1,6,1 do
		 spawnparticle(p.x+4,p.y+4,(math.random(60)-30)/10,(math.random(60)-60)/10,0,.2,3000,0,6+math.random(1),false,0,8)
	 end
 end
 --p.deadend = true
end

function splat(x,y)
 for i=1,6,1 do
	 spawnparticle(x,y,(math.random(60)-30)/10,(math.random(60)-60)/10,0,.2,3000,0,6+math.random(1),false,0,8)
 end
end

function bubbles(x,y,f,l,dir)
 local r = math.random(f)
 if r==1 then
  if dir <5 then
		 spawnparticle(x,y,0,-0.5*dir,0,0,l,
		               3,11,false,math.random(3),
		               5)
	 elseif dir == 6 then --right
		 spawnparticle(x,y,0.5,0,0,0,l,
		               3,11,false,math.random(3),
		               5)
		elseif dir == 7 then -- left
		 spawnparticle(x,y,-0.5,0,0,0,l,
		               3,11,false,math.random(3),
		               5)
		end
 end
end

function leaves(dir,c1,c2)
 local vx,vy,xloc,yloc,life,
       layer,coldist,amt
 if dir == "left" then
  vx =-2
  vy = 0
  xloc = p.x+150
  yloc = math.random(300)
  life = 600
  layer = 4
  amt = 10
 elseif dir == "up" then
  vx = 0
  vy = -0.5
  xloc = math.random(240)+p.x-120
  yloc = p.y+100
  life = 1200
  layer = 4--5 if vbank 1
  amt = 60
 end
 
 local r = math.random(amt)
 
 local r2 = math.random(2)
 
 if r==1 and r2 == 1 then
  
		spawnparticle(xloc,yloc,
		vx,vy,
		0,0,life,2,c1,
		false,math.random(2),layer)
	elseif r==1 and r2==2 then
	 spawnparticle(xloc,yloc,
		vx,vy,
		0,0,life,2,c2,
		false,math.random(2),layer)
 end
end



function spawnparticle(x,y,vx,vy,ax,ay,l,typ,clr,wall,rad,layer)
	particle = {
		x = x,
		y = y,
		vx = vx,
		vy = vy, 
		ax = ax,
		ay = ay,
		life = l,
		typ = typ,
		clr = clr,
		wall=wall,
		rad=rad,
		layer=layer
	}
	table.insert(allparticles, particle)
end

function particlelogic()
	for i,particle in ipairs(allparticles) do
	  if particle.wall==false then
	   particle.vx = particle.vx + particle.ax
				particle.vy = particle.vy + particle.ay
    particle.x = particle.x + particle.vx
    particle.y = particle.y + particle.vy 
   else
    particle.x = math.floor(particle.x)
    particle.y = math.floor(particle.y)
   end
   
   particle.life = particle.life-1
   
   if particle.life <=0 then
			 table.remove(allparticles,i)
			end
   
			if particle.typ==0 then
			 if solid(particle.x,particle.y) then
     particle.wall = true
	   end
			else if particle.typ == 2 then
			 particle.ax = math.sin(tstamp()+math.random(50))/50
			 particle.ay = math.sin(tstamp())/200
			elseif particle.typ == 3 then
			 --bubbles
				
				--accelerate based on sin
			 particle.ax = math.sin(tstamp()+math.random(50))/50
			 particle.ay = -0.00005+math.sin(tstamp())/200
				--change radius as life decreases
				if particle.rad < 3 then
				 particle.rad = particle.rad+2/particle.life
			 end
				
				if mget((particle.x)//8,(particle.y)//8+(level-1)*34) == 188 then
				 particle.vx = 0.5
				elseif mget((particle.x)//8,(particle.y)//8+(level-1)*34) == 189 then
				 particle.vx = -0.5
				elseif mget((particle.x)//8,(particle.y)//8+(level-1)*34) == 190 then
				 particle.vy = 0.5
				elseif mget((particle.x)//8,(particle.y)//8+(level-1)*34) == 191 then
				 particle.vy = -0.5
				elseif solid(particle.x,particle.y) then
				 table.remove(allparticles,i)
				end
				
				
				
				--rain
			elseif particle.typ==4 then
			 if solid(particle.x,particle.y) then
     table.remove(allparticles,i)
	   end
			--dust poofs
			elseif particle.typ == 5 then
			 	 particle.rad = particle.rad-20/(particle.life)
			
			elseif particle.typ == 6 then
			   if particle.life <= 90 then
						 particle.grav = true
						end
			end
		end
	end
end

function dustpoofs()
 spawnparticle(p.x+7,p.y+8,0,0,0,0,100,5,2,false,3,4)
 spawnparticle(p.x+1,p.y+8,0,0,0,0,100,5,2,false,3,4)
end

function entmake(x,y,vx,vy,ty,ct,d,active,fl,rot,clawed,bns)
 ent={x=x,
      y=y,
			 		vx=vx,
	 				vy=vy,
		 			ty=ty,
			 		ct=ct,
				 	d=d,
						active=active,
						rot=rot,
						fl=fl,
						clawed = clawed,
						bns=bns}
 table.insert(ents,ent)
end

function entlogic()
 for i,ent in pairs(ents) do
  if ent.y < 0 then
   table.remove (ents,i)
  end
  
  
  
  if ent.ty == 498 or ent.ty == 454 
  or ent.ty == 466 or ent.ty == 199 
  or ent.ty == 215 or ent.ty == 471 then
	 
		else
			ent.ct = ent.ct+1
		end
		
		if ent.clawed == false 
		and ent.stuck == nil 
		and ent.ty ~= 211 
		and ent.ty ~= 227 
		and ent.ty ~= 213 
		and ent.ty ~= 214 
		and ent.ty ~= 230 then
	  ent.x = ent.x+ent.vx
		 ent.y = ent.y+ent.vy
		end
		
		if ent.stuck ~= nil then
		 ent.ct = 0
		end
		
		if sticky(ent.x+1,ent.y+8+ent.vy) 
			or sticky(ent.x+6,ent.y+8+ent.vy) then
			 
				if ent.ty ~= 201 then
					ent.vx=0
				 ent.vy=0
				 ent.stuck = true
				 ent.y = math.floor(ent.y/8+0.5)*8+1
				end
			end 
		
		if pipe(ent.x+4,ent.y+ent.vy) then
	  ent.inpipe = true
	  ent.vy=0
	  ent.vx=0 
	  ent.pipedir = "up"
	 elseif pipe(ent.x+4,ent.y+8+ent.vy) then
	  ent.inpipe = true
	  ent.vy=0
	  ent.vx=0 
	  ent.pipedir = "down"
	 end
	 
	 if ent.inpipe == true then
	  local dir
	  if ent.pipedir =="up" then
	   dir = -1
	  else
	   dir = 1
	  end
	
	
	  local tile = mget((ent.x//8*8+4)//8,(ent.y+dir)//8+(level-1)*34)
	
	  if tile == 25 or tile == 41 then
	   ent.y=ent.y-2
	  elseif tile == 9 or tile == 10 
	  or tile == 29 then
	   ent.x=ent.x+2
	   
	  elseif tile == 11 or tile == 27 
	  or tile == 28 or tile == 14 or tile == 15 then
	   ent.y = ent.y+2
	   
	  elseif tile == 12 or tile == 13 then
	   ent.x = ent.x-2
	   
	  elseif tile == 42 then
	   ent.x = ent.x+2
	   ent.vx = ent.vx + 1
	   
	  else 
	   ent.x = ent.x//8*8
	   ent.y = ent.y//8*8+8
	   ent.inpipe = nil
	  end 
	 end
				
		
--falling and landing and bonking
		if solid(ent.x+8,ent.y+7+ent.vy)
		or solid(ent.x,ent.y+7+ent.vy)
		or solid(ent.x,ent.y+ent.vy)
		or solid(ent.x+8,ent.y+ent.vy)
		or oneway(ent.x+8,ent.y+7+ent.vy)
		or oneway(ent.x,ent.y+7+ent.vy)
		or oneway(ent.x,ent.y+ent.vy)
		or oneway(ent.x+8,ent.y+ent.vy)
		or deathy(ent.x+8,ent.y+7+ent.vy) 
		or deathy(ent.x,ent.y+7+ent.vy) 
		or mget((ent.x+7)//8,(ent.y+7+ent.vy)//8+(level-1)*34) == 183 
  or mget((ent.x)//8,(ent.y+7+ent.vy)//8+(level-1)*34) == 183
 then
 --mgets above for 1f0 type thing
   if ent.ty==208 
   or ent.ty==464 
   or ent.ty == 224
   or ent.ty == 480 
   or ent.ty == 225
   or ent.ty == 481 
   or ent.ty == 212 then
    ent.vy=0
   end
   
  else
   
   
  	if ent.ty == 192 or ent.ty ==272 
   or ent.ty==208 or ent.ty==464 
   or ent.ty == 224
   or ent.ty == 480 
   or ent.ty == 225 or ent.ty == 481 
   or ent.ty == 212 then
   
   
			
      --ent.y = ent.y//8*8+1
      --ent.x = ent.x//8*8
      
      --ents falling
      if ent.ty==208 
		    or ent.ty==464 
						or ent.ty == 224
      or ent.ty == 480 
      or ent.ty == 225
      or ent.ty == 481 
      or ent.ty == 212 then
						 if ent.clawed == false then
        ent.vy = ent.vy + 0.2
       end
      end
   end
  end
  
 
  

  --animations and specific logic
  
 --rotate to stick to walls
		if ent.ty==192 
		or ent.ty==448 then
		 if solid(ent.x,ent.y+8) then
			 
			elseif solid(ent.x,ent.y-8) then
			 ent.fl = 2
			elseif solid(ent.x+8,ent.y) then
			 ent.rot = 3
			elseif solid(ent.x-8,ent.y) then
			 ent.rot = 1
			end
		end
		
		--static bouncebois
		if ent.ty==192 
		or ent.ty==448 
		or ent.ty == 449 then
  
			if p.x>ent.x-8 and p.x<ent.x+8 then
    if p.y>ent.y-10 and p.y<ent.y+4 then
					if ent.fl == 0 
					and ent.rot == 0 then
					 p.vy=-6
					elseif ent.fl == 2 
					and ent.rot == 0 then
					 p.vy = 4
					elseif ent.rot == 1 then
					 p.vx=6
						if p.vy<3 then
						 p.vy=p.vy-2
						else
						 p.vy=0
						end
						
						--idk if i like this
					elseif ent.rot == 3 then
					 p.vx=-6
						if p.vy<3 then
						 p.vy=p.vy-2
						else
						 p.vy=0
						end
					end
					
					splat(p.x+4,p.y+4)
					ent.ty=449
					sfx(60,50,10,3)	
			 end
		 end
			
			
		for k,ent in pairs(ents) do
		 if ents[i] ~= nil and ents[k] ~= nil then
			 if ents[i].x > ents[k].x-8 
				and ents[i].x < ents[k].x+8 then
	    if ents[i].y > ents[k].y-7 
	    and  ents[i].y<ents[k].y+4 
			  and k ~= i and ents[k].ty ~= 196
					and ents[k].ty ~= 200
					and ents[k].ty ~= 198
					and ents[k].ty ~= 199
					and ents[k].ty ~= 194
					and ents[k].ty ~= 458
					and ents[k].ty ~= 498 then
					--don't bounce coins or portals
					--or claws or etc.
						
						if ents[i].fl == 0 
						and ents[i].rot == 0 
						and ents[k].vy > -2 then
						 ents[k].vy = ents[k].vy -4
						elseif ents[i].fl == 2 
						and ents[i].rot == 0 then
						 ents[k].vy = ents[k].vy + 4
						elseif ents[i].rot == 1 then
						 ents[k].vx = 6
							if ents[k].vy>5 then
							 ents[k].vy=0
							else
							 ents[k].vy=ents[k].vy-2.5
							end
						elseif ents[i].rot == 3 then
						 ents[k].vx=-6
							if ents[k].vy>5 then
							 ents[k].vy=0
							else
							 ents[k].vy=ents[k].vy-2.5
							end
						end
						
						
					end
				end
			end
	 end			


		 if ent.ty ~= 449 then
			 if ent.ct<32 then
	    ent.ty=192
		 	elseif ent.ct>32 and ent.ct<65 then
			  ent.ty=448
			 elseif ent.ct>64 then
			  ent.ct=0
			 end
		 end
			
		--walken bounceboi
		elseif ent.ty==208	or ent.ty==464 then
		 
			if p.x>ent.x-8 and p.x<ent.x+8 then
    if p.y>ent.y-10 and p.y<ent.y+4 then
			  p.vy=-6
					sfx(60,50,10,3)	
					splat(p.x+4,p.y+4)
				end
			end
			
		 if ent.vx == 0 then
		  ent.vx = -0.5
   end
   
			if solid(ent.x+8,ent.y) then
			 ent.vx = -0.5
				ent.fl=0
			elseif solid(ent.x,ent.y) then
			 ent.vx = 0.5
				ent.fl=1
			elseif solid(ent.x,ent.y-1) then
			 ent.vy = 0.5
				--idk what this does, 
				--but if it isnt commented, 
				--ent will come out of pipe sideways

				--ent.rot = 3
				ent.fl = 0
			else

   end
   
   for k,ent in pairs(ents) do
			 if ents[i].x > ents[k].x-8 and ents[i].x < ents[k].x+8 then
	    if ents[i].y > ents[k].y-7 and  ents[i].y<ents[k].y+4 
			  and k ~= i	and ents[i].vy > -2 then
					 if ents[k].ty ~= 192 and ents[k].ty ~= 448 then 
						 ents[k].vy = ents[k].vy -4
							sfx(60,50,10,3)	
						end
					end
				end
			end
		
		 if ent.ct<32 then
    ent.ty=208
	 	elseif ent.ct>32 and ent.ct<65 then
		  ent.ty=464
		 elseif ent.ct>64 then
		  ent.ct=0
		 end
				
				
		--walken deathboi
		elseif ent.ty==224	or ent.ty==480 then
		 
			if p.x>ent.x-8 and p.x<ent.x+8 then
    if p.y>ent.y-10 and p.y<ent.y+4 then
					death()
				end
			end
			
		 if ent.vx == 0 then
		  ent.vx = -0.5
   end
   
			if solid(ent.x+8,ent.y) then
			 ent.vx = -0.5
				ent.fl=0
			elseif solid(ent.x,ent.y) then
			 ent.vx = 0.5
				ent.fl=1
			elseif solid(ent.x,ent.y-1) then
			 ent.vy = 0.5
				ent.rot = 3
				ent.fl = 0
			else
			
	
			
   end
    --do we want it to eat other ents?
   for k,ent in pairs(ents) do
			 if ents[i].x > ents[k].x-8 
				and ents[i].x < ents[k].x+8 then
	    if ents[i].y > ents[k].y-7 
					and  ents[i].y<ents[k].y+4 
			  and k ~= i	and ents[i].vy > -2 then
						if ents[k].ty ~= 192 and ents[i].ct > 20
					 and ents[k].ty ~= 448 then 
						 ents[i].ct = 0
						 ents[k].vx = -ents[k].vx 
							ents[i].vx = -ents[i].vx
						end
					end
				end
			end
		
		 if ent.ct<32 then
    ent.ty=224
	 	elseif ent.ct>32 and ent.ct<65 then
		  ent.ty=480
		 elseif ent.ct>64 then
		  ent.ct=0
		 end
		
		--jumpin deathboi
		elseif ent.ty == 225 or ent.ty == 481 then
		 if p.x>ent.x-8 and p.x<ent.x+8 then
    if p.y>ent.y-10 and p.y<ent.y+4 then
					death()
				end
			end
			
			if ent.ct<=25 then
    ent.ty=481
    
	 	elseif ent.ct>25 and ent.ct<26 then
		  ent.ty=225
			elseif ent.ct>26 and ent.ct <28 then
			 ent.ty = 225
			 ent.vy = -4
			elseif ent.ct > 28 and ent.ct <80 then
			 ent.ty = 225
			elseif ent.ct >80 and ent.ct <=180 then
			 ent.ty = 481

	
		 elseif ent.ct>100 then
		  ent.ct=0
		 end
			
		--shell 2.0
		elseif ent.ty == 212 then
		 if mget((ent.x+9)//8,(ent.y+6+ent.vy)//8+(level-1)*34) == 176 
   or mget((ent.x-1)//8,(ent.y+6+ent.vy)//8+(level-1)*34) == 176 then
    if xon == true then
			  xon = false
			 elseif xon == false then
			  xon = true
			 end
   end
   			
		 if solid(ent.x+8,ent.y)
			or solid(ent.x,ent.y) then
			 ent.vx = -ent.vx

		 elseif p.x>ent.x-8 and p.x<ent.x+8 then
    if p.y>ent.y-5 and p.y<ent.y+4 then
     local op
     --compare values of vx and vy 
     --to decide whether to kick or bounce
     if math.abs(p.vy)>=math.abs(p.vx) then
      op = "bounce"
     elseif math.abs(p.vy)<math.abs(p.vx) then
      op = "kick"
     end
     
     if op == "bounce" and p.vy <= 0 then
				  p.vy = -3
					elseif op == "kick" 
					and p.vx>0 and math.abs(p.vx)>1 then
					 ent.vx = 2
					elseif op == "kick" 
					and p.vx<0 and math.abs(p.vx)>1 then
						ent.vx = -2
					end
			 end
		 end
			
		--up/down linked platform
		elseif ent.ty == 213 then
		 --store original position so it 
			--can travel back to it
			
			--I need to set up some sort of
			--messaging system to tell the
			--other plat that it shouldn't
			--move back, but I don't want to rn
		 
			
			if ent.oy == nil then
				ent.oy = ent.y
			end
		
		 --ent will eat ent if link is null
			--eaten ent's type will be stored 
			--as linked type.
			--we can look for other portals
			--with same type
			--right above seems to work pretty consistently
		 if ent.link == nil then
			 for k,ent in pairs(ents) do
     if ents[i].x > ents[k].x-10 and ents[i].x < ents[k].x+10 then
		    if ents[i].y > ents[k].y-20 and  ents[i].y < ents[k].y+20 
				  and k ~= i and ents[k].ty ~= 213 then
	      ents[i].link = ents[k].ty
							table.remove(ents,k)
						end
					end
				end
			--if ent.link is filled, and the x
			--tp location is not filled, 
			--we look for another ent that
			--has the same link type
			--and store it's xy coords
			elseif ent.lx == nil then
			 for k,ent in pairs(ents) do
     if ents[i].link == ents[k].link
     and k~=i and ents[k].ty == 213 then
						ents[i].lx = k
						ents[k].lx = i
					end
				end
			end

		 if (p.x+p.vx) < ent.x+16 
			and (p.x+p.vx) > ent.x-7 
			and p.y+8+p.vy > ent.y 
   and p.y+p.vy < ent.y 
			and p.vy > 0 then
			 if ent.ploc == nil then
				 ent.ploc = p.x-ent.x
				 
				end
				p.platent = i
    p.onplat = true
				p.vy = 0
				jump=false
			 p.canjump = true
			 p.cjct=7
		  p.jct=0
		  onground=true

    if btn(2) then
     ent.ploc = ent.ploc - 1
    elseif btn(3) then
     ent.ploc = ent.ploc + 1
    end
    
    
				p.x=math.ceil(ent.x+ent.ploc)
				p.y=math.ceil(ent.y-8)
				
				
				--trace(ents[i].linked)
				
				ent.y = ent.y+0.5
			 ents[ents[i].lx].on = true
			else 
			 p.onplat = false
			 ent.ploc = nil
   end
	
	 --crashes on level transition if
		--we don't check if ents[i] ~= nil
	 if ents[i] ~= nil then
			if ents[i].on ~= nil then
			 ents[i].y = ents[i].y-0.5
	   ents[i].on = nil
	  elseif ents[i].oy ~= nil then
			 
	   if ents[i].y < ents[i].oy-1 then
	    ents[i].y = ents[i].y + 0.1
	   elseif ents[i].y > ents[i].oy+1 then
	    ents[i].y = ents[i].y - 0.1
	   end
	  end
  end
  --ent.vx = 0
  
  elseif ent.ty == 214 then
   if ent.start == nil then ent.start = ent.x end
		 if ent.move == nil then ent.move = "right" end
   
   if ent.range == nil then ent.range= 50 end
   
   if ent.move == "right" then
   	if ent.x < ent.start+ent.range then
    ent.x = ent.x+0.3
    else ent.move = "left" end
    
   elseif ent.move == "left" then
    if ent.x > ent.start then
    ent.x = ent.x-0.3
    else ent.move = "right" end
   end
   


		 if (p.x+p.vx) < ent.x+13 
			and (p.x+p.vx) > ent.x-7 then
    if  p.y+8+p.vy > ent.y 
    and p.y+p.vy < ent.y 
				and p.vy > 0 then
				 if ent.ploc == nil then
					 ent.ploc = p.x-ent.x
					end

					p.platent = i
     p.onplat = true
					p.vy = 0
					jump=false
				 p.canjump = true
				 p.cjct=7
			  p.jct=0
			  onground=true
					ent.active = true
					

     if btn(2) then
      ent.ploc = ent.ploc - 1
     elseif btn(3) then
      ent.ploc = ent.ploc + 1
     end
     
     
					p.x=math.ceil(ent.x+ent.ploc)
					p.y=math.ceil(ent.y-8)
					
				else 
			  ent.ploc = nil
					p.onplat = false
				end
			else 
			 p.onplat = false
			 ent.ploc = nil
   end 
				
		--vertplat
		elseif ent.ty == 230 then
   if ent.start == nil 
    then ent.start = ent.y 
   end
   
		 if ent.move == nil then 
			 ent.move = "down" 
			end
  
   if ent.range == nil then 
    ent.range = 50 
   end
   
   if ent.move == "down" then
   	if ent.y < ent.start+ent.range then
     ent.y = ent.y+0.3
    else ent.move = "up" end
    
   elseif ent.move == "up" then
    if ent.y > ent.start then
     ent.y = ent.y-0.3
    else ent.move = "down" end
   end
   
		 if (p.x+p.vx) < ent.x+13 
			and (p.x+p.vx) > ent.x-7 then
    if  p.y+8+p.vy > ent.y 
    and p.y+p.vy < ent.y 
				and p.vy > 0 then
				 if ent.ploc == nil then
					 ent.ploc = p.x-ent.x
					end

					p.platent = i
     p.onplat = true
					p.vy = 0
					jump=false
				 p.canjump = true
				 p.cjct=7
			  p.jct=0
			  onground=true
					ent.active = true
					

     if btn(2) then
      ent.ploc = ent.ploc - 1
     elseif btn(3) then
      ent.ploc = ent.ploc + 1
     end
     
     
					p.x=math.ceil(ent.x+ent.ploc)
					p.y=math.ceil(ent.y-8)
					
				else 
			  ent.ploc = nil
					p.onplat = false
				end
			else 
			 p.onplat = false
			 ent.ploc = nil
   end 
   
  elseif ent.ty == 220 then
   ent.y = ent.y+math.sin(time()/400)/5
		
		local vel = 5
		
		
		if ent.ct>50 then
			if p.x>ent.x-8 and p.x<ent.x+16 then
	    if p.y>ent.y and p.y<ent.y+16 then
	     
	     if btn(0) then
	      p.vy = -vel
							ent.ct = 0
	     elseif btn(1) then
	      p.vy = vel
							ent.ct = 0
	     end
	     
	     if btn(2) then
	      p.vx = -vel
							ent.ct = 0
	     elseif btn(3) then
	      p.vx = vel
							ent.ct = 0
	     end
	    end
	   end
			end
		
		
		--coin
		elseif ent.ty==196 or ent.ty==452 then
		 local timer = math.sin(time()/600)*8
			
			ent.y = ent.y + timer/64
			
			if timer <=4 then
			 ent.ty = 196
				ent.fl = 0
			elseif timer >4  then
			 ent.ty = 452
			end
			
			if p.x>ent.x-8 and p.x<ent.x+8 then
    if p.y>ent.y-5 and p.y<ent.y+4 then
     table.remove(ents,i)
					sfx(61,G6,30,3)	
			 end
		 end
			
		--portals
		elseif ent.ty == 200 then
		 --ent will eat ent if link is null
			--eaten ent's type will be stored 
			--as linked type.
			--we can look for other portals
			--with same type
			--right above seems to work pretty consistently
		 if ent.link == nil then
			 for k,ent in pairs(ents) do
     if ents[i].x > ents[k].x-10 and ents[i].x < ents[k].x+10 then
		    if ents[i].y > ents[k].y-20 and  ents[i].y < ents[k].y+20 
				  and k ~= i and ents[k].ty ~= 200 then
	      ents[i].link = ents[k].ty
							table.remove(ents,k)
						end
					end
				end
			--if ent.link is filled, and the x
			--tp location is not filled, 
			--we look for another ent that
			--has the same link type
			--and store it's xy coords
			elseif ent.lx == nil then
			 for k,ent in pairs(ents) do
     if ents[i].link == ents[k].link
     and k~=i and ents[k].ty == 200 then
						ents[i].lx = ents[k].x
						ents[i].ly = ents[k].y
					 ents[k].lx = ents[i].x
						ents[k].ly = ents[i].y
					end
				end
			end
			
			--this eats ents for some reaason 
			--but mostly works
		
		 if --[[ent.lx ~=nil and]] p.portaled == false then
			 if p.x>ent.x-8 and p.x<ent.x+8 then
	    if p.y>ent.y-5 and p.y<ent.y+4 then
	     p.portaled = true
						--p.sprct = 0
						p.x = ent.lx
	     p.y = ent.ly
				 end
			 end
			end
			
			--spawnparticle(ent.x,ent.y,3*math.cos(time()),3*math.sin(time()),0,0,150,5,1,false,1,4)

			
			if ent.ct == 15 then
			 ent.rot = ent.rot+1
				 
				--[[
			ax = ax,
		ay = ay,
		life = l,
		typ = typ,
		clr = clr,
		wall=wall,
		rad=rad,
		layer=layer]]
			
			elseif ent.ct >15 then
			 ent.ct = 0
			end
			

	 --circlin spikeboi (deathboi)
	 elseif ent.ty == 201 then
		 if ent.active == false then
			 ent.vx = 0.3
		  ent.dir = "up"
	
				
				--which way ent is moving
				ent.active = true
				ent.wait = false
				--make the ent not check for
				--ground when it is travelling
				--around a corner
			end
			
			if p.x>ent.x-8 and p.x<ent.x+8 then
    if p.y>ent.y-10 and p.y<ent.y+4 then
					death()
				end
			end
			
			if ent.dir == "up" then
			 if solid (ent.x-1,ent.y+12) then ent.wait = false end
			
			 if ent.wait == false and not solid (ent.x-1,ent.y+12) then
				 ent.vx = 0
					ent.vy = 0.3
					ent.rot = 1
					ent.dir = "right"
					ent.wait = true
				end
			elseif ent.dir == "right" then
			--check if ent is back on land
			 if solid(ent.x-3,ent.y-1) then 
				 ent.wait = false 
				end
							
			 if ent.wait == false 
				and not solid (ent.x-6,ent.y-1) then
				 ent.vx = -0.3
					ent.vy = 0
					ent.rot = 2
					ent.dir = "down"
					ent.wait = true
				end
			elseif ent.dir == "down" then
			--check if ent is back on land
			 if solid (ent.x+7,ent.y-4) then ent.wait = false end
							
			 if ent.wait == false and not solid (ent.x+7,ent.y-4) then
				 ent.vx = 0
					ent.vy = -0.3
					ent.rot = 3
					ent.dir = "left"
					ent.wait = true
				end
			elseif ent.dir == "left" then
			--check if ent is back on land
			 if solid (ent.x+12,ent.y+7) then 
				 ent.wait = false 
				end
							
			 if ent.wait == false 
				and not solid (ent.x+12,ent.y+7) then
				 ent.vx = 0.3
					ent.vy = 0
					ent.rot = 0
					ent.dir = "up"
					ent.wait = true
				end
			end
	
	
	--circlin platboi
	 elseif ent.ty == 202 then
		 if ent.active == false then
			 ent.vx = 0.3
				ent.dir = "up"
				--which way spike is pointing
				ent.active = true
				ent.wait = false
				--make the ent not check for
				--ground when it is travelling
				--around a corner
			end
			
			
		 if (p.x+p.vx) < ent.x+8 
			and (p.x+p.vx) > ent.x-5 then
    if  p.y+8+p.vy > ent.y 
    and p.y+p.vy < ent.y 
				and p.vy > 0 then
				 if ent.ploc == nil then
					 ent.ploc = p.x-ent.x
					end
					
					if ent.active == false then
					 ent.ct = 0
				 end
					p.platent = i
     p.onplat = true
					p.vy = 0
					jump=false
				 p.canjump = true
				 p.cjct=7
			  p.jct=0
			  onground=true
					ent.active = true
					
					

     
     --prevent player from clipping
     --into walls when on plat
     if solid(p.x-2*ent.vx,p.y) 
     or solid(p.x-2*ent.vx,p.y+8)then
      ent.ploc = ent.ploc-2
     elseif solid(p.x+2*ent.vx,p.y)
     or solid(p.x+2*ent.vx,p.y+8) then
      ent.ploc = ent.ploc+2
     else
	     if btn(2) then
						 if not
							solid(p.x-5,p.y)and not 
							solid(p.x-5,p.y+8) then
	       ent.ploc = ent.ploc - 1
							end
	     elseif btn(3) then
						 if not
							solid (p.x+7,p.y) and not
							solid (p.x+7,p.y+8)then
	      	ent.ploc = ent.ploc + 1
							end
	     end
     end
     
     
					p.x=math.ceil(ent.x+ent.ploc)
					p.y=math.ceil(ent.y-8)
					
				else 
			  ent.ploc = nil
					p.onplat = false
				end
			else 
			 p.onplat = false
			 ent.ploc = nil
   end
			
			if ent.dir == "up" then
			 if solid (ent.x-1,ent.y+12) then ent.wait = false end
			
			 if ent.wait == false and not solid (ent.x-1,ent.y+12) then
				 ent.vx = 0
					ent.vy = 0.3
					ent.rot = 1
					ent.dir = "right"
					ent.wait = true
				end
			elseif ent.dir == "right" then
			--check if ent is back on land
			 if solid (ent.x-3,ent.y-1) then ent.wait = false end
							
			 if ent.wait == false and not solid (ent.x-6,ent.y-1) then
				 ent.vx = -0.3
					ent.vy = 0
					ent.rot = 2
					ent.dir = "down"
					ent.wait = true
				end
			elseif ent.dir == "down" then
			--check if ent is back on land
			 if solid (ent.x+7,ent.y-4) then ent.wait = false end
							
			 if ent.wait == false and not solid (ent.x+7,ent.y-4) then
				 ent.vx = 0
					ent.vy = -0.3
					ent.rot = 3
					ent.dir = "left"
					ent.wait = true
				end
			else
			--check if ent is back on land
			 if solid (ent.x+12,ent.y+7) then ent.wait = false end
							
			 if ent.wait == false and not solid (ent.x+12,ent.y+7) then
				 ent.vx = 0.3
					ent.vy = 0
					ent.rot = 0
					ent.dir = "up"
					ent.wait = true
				end
			end
			
		--jumpcrystals
		elseif ent.ty == 194 or ent.ty == 450 then
		 if p.x>ent.x-8 and p.x<ent.x+8 then
    if p.y>ent.y-5 and p.y<ent.y+4 then
     p.canjump = true
     p.cjct = 20
     table.remove(ents,i)
					sfx(4,A8,30,3)	
			 end
		 end
			if ent.ct<16 then
    ent.vy=.1
    ent.ty = 194
	 	elseif ent.ct>16 and ent.ct<32 then
		  ent.vy=-.1
				ent.ty = 450
		 elseif ent.ct>32 then
		  ent.ct=0
		 end
		
		--treecircles
		elseif ent.ty == 216 then
		
		 if ent.xes == nil then
			 ent.xes = {}
				ent.yes = {}
				ent.rads = {}
				ent.cols = {}
				for i=1,10 do
				 ent.xes[i] = math.random(20)-10
					ent.yes[i] = math.random(20)-10
					ent.rads[i] = math.random (7)+10
					if world == 1 then
					 ent.cols[i] = math.random(2)+13
					elseif world == 2 then
					 ent.cols[i] = math.random(2)+5
					end
				end
		 end
		 
			for i=1,10 do
			 local x,y
				x = math.sin(time()/(500))
				y = math.sin(time()/(500))
				if math.random(1,5) == 1 then
				 ent.xes[i] = ent.xes[i]+x/20
				 ent.yes[i] = ent.yes[i]+y/20
    end
			end
		 
		--linear bats
		elseif ent.ty == 217 or ent.ty == 473 then
		 if solid(ent.x+9,ent.y) then
			 ent.vx = -0.5
				ent.rot = 0
	   ent.fl = 0
			elseif solid(ent.x-2,ent.y) then
			 ent.vx = 0.5
				ent.fl = 1
	
			elseif solid(ent.x+2,ent.y-4) then
			 ent.vy = 0.5
				ent.rot = 3
	
			elseif solid(ent.x+6,ent.y+13) then
    ent.vy = -0.5
    ent.rot = 1
   end
   
   if math.abs(ent.vx) >0 then
    ent.vy=0
    ent.rot = 0
   else
    ent.vx = -0.5
   end
   
   ent.y = ent.y - math.sin(time()/200)/2
   
   if p.x>ent.x-8 and p.x<ent.x+8 then
    if p.y>ent.y-5 and p.y<ent.y+4 then
			  if p.vy <0 then

						death()
					else
					 p.vy = -5
						sfx(60,50,10,3)	
					end
				end
			end
		
		 if ent.ct<32 then
    ent.ty=217
	 	elseif ent.ct>32 and ent.ct<65 then
		  ent.ty=473
		 elseif ent.ct>64 then
		  ent.ct=0
		 end
		
		--fallin bats 
		elseif ent.ty == 218 then
		
		 if p.x > ent.x - 80 and ent.dislodged == nil then
			 ent.dislodged = true
				ent.ct = 0
				ent.vy = 0.75
				ent.vx = -0.25
			end
			
		
		 if ent.dislodged ~= nil 
			and ent.ct > 50 then
			 ent.ty = 217
			end
		
		
		--gravity
		elseif ent.ty == 219 then
		 if p.x>ent.x-24 and p.x<ent.x+32 then
    if p.y>ent.y-24 and p.y<ent.y+32 then
			  local dist = math.sqrt((p.x-ent.x)*(p.x-ent.x)+(p.y-ent.y)*(p.y-ent.y))/50
					
					 p.vx = p.vx+0.025*dist*(ent.x-p.x)
					 p.vy = p.vy+0.025*dist*(ent.y-p.y) 

				end
			end
			
			if math.random(7) == 1 then
		  spawnparticle(ent.x+4,
				             ent.y+4,
																	math.random(5)-2,
																	math.random(5)-2,
																	0,0,
																	200,6,12,false,0,3)
   end
		 
		  for k,particle in ipairs(allparticles) do
		   if particle.typ == 6 then
				  if particle.x>ent.x-24 and particle.x<ent.x+32 then
			    if particle.y>ent.y-24 and particle.y<ent.y+32 then
						  local dist = math.sqrt((particle.x-ent.x)*(particle.x-ent.x)+(particle.y-ent.y)*(particle.y-ent.y))/50
								
								 particle.vx = particle.vx+0.025*dist*(ent.x-particle.x)
								 particle.vy = particle.vy+0.025*dist*(ent.y-particle.y) 
			
				   end
				  end
				  
				 end
				end
				
				
				
				
	 --count platforms
	 elseif ent.ty == 197 then
		
   if ent.active == true then
    ent.x = ent.x+platspeed
   end	
   
   if ent.ct > 400 then
    ent.y = ent.y+2
   end
		
		 if (p.x+p.vx) < ent.x+13 
			and (p.x+p.vx) > ent.x-7 then
    if  p.y+8+p.vy > ent.y 
    and p.y+p.vy < ent.y 
				and p.vy > 0 then
				 if ent.ploc == nil then
					 ent.ploc = p.x-ent.x
					end
					
					if ent.active == false then
					 ent.ct = 0
				 end
					p.platent = i
     p.onplat = true
					p.vy = 0
					jump=false
				 p.canjump = true
				 p.cjct=7
			  p.jct=0
			  onground=true
					ent.active = true
					

     if btn(2) then
      ent.ploc = ent.ploc - 1
     elseif btn(3) then
      ent.ploc = ent.ploc + 1
     end
     
     
					p.x=math.ceil(ent.x+ent.ploc)
					p.y=math.ceil(ent.y-8)
					
				else 
			  ent.ploc = nil
					p.onplat = false
				end
			else 
			 p.onplat = false
			 ent.ploc = nil
   end
			
		
		-- slingshot!
		elseif ent.ty == 199 then
		 
		 if ent.ang == nil then
			 ent.ang = math.pi
				ent.angv = 0
				ent.anga = 0
				ent.v = 0
				ent.clawtimer = 0
				ent.clawed = false
				ent.ct = ent.x
				ent.d = ent.y
				ent.len = 0
			else
		
    
				ent.x = ent.len*math.sin(ent.ang) + ent.ct
				ent.y = ent.len*math.cos(ent.ang) + ent.d
		 end
		
		
		 if p.x>ent.x-8 and p.x<ent.x+8 then
    if p.y>ent.y-7 and p.y<ent.y+4 then
			  if p.clawed == false
					--and p.insling == false 
					and ents[i].clawtimer == 0 
					then
		    
		    p.insling = true
						p.entkey = i
					end
					
				end
			end
			
			if p.insling == true then
	   
				if btnp(4) then
				 buttoning = false
				end
	
				if btn(1) or btn(2) 
				or btn(0) or btn(3) then
				 buttoning = true
				else
				 if buttoning ~= nil then
				  buttoning = false
					end
				end
				
				if buttoning == true then

					if btn(1) then
					 ents[p.entkey].ang = ents[p.entkey].ang-0.04
					elseif btn(0) then
					 ents[p.entkey].ang = ents[p.entkey].ang+0.04
					end
					
					if btn(3) then
					 if ents[p.entkey].len<18 then
					  ents[p.entkey].len = ents[p.entkey].len +1
						end
					elseif btn(2) then
					 if ents[p.entkey].len>-18 then
					  ents[p.entkey].len = ents[p.entkey].len-1
						end
	    end
					
				elseif buttoning == false then
				 p.insling = false
					p.vx = -ents[p.entkey].len*math.sin(ents[p.entkey].ang)/2
				 p.vy = -ents[p.entkey].len*math.cos(ents[p.entkey].ang)/2
     ents[p.entkey].ang = 0
     ents[p.entkey].len = 0
     ents[p.entkey].clawtimer = 1
					buttoning = nil
				end
				p.x = ents[p.entkey].x
				p.y = ents[p.entkey].y
			end
				
			if ent.clawtimer >= 1 then
			 ents[i].clawtimer= ents[i].clawtimer + 1
				if ents[i].clawtimer >30 then
				 ents[i].clawtimer = 0
				end
			end
		
		elseif ent.ty == 198 then
		
		 entmake(
   ent.x+18,ent.y+18,0,0,
   454,ent.x,ent.y,
   false,0,0)
		
	  table.remove(ents,i)
		
			
		--clawwwwww
		
		elseif ent.ty == 454 then
		
		 local len,damp = 18,0.985
					
		
			if ent.ang == nil then
			 ent.ang = 0
				ent.angv = 0
				ent.anga = 0
				ent.v = 0
				ent.clawtimer = 0
				ent.clawed = false
			else
			
				ent.anga = -math.sin(ent.ang)/(len*2)
					
				ent.angv = damp*(ent.angv + ent.anga)
				
				ent.ang = ent.ang + ent.angv*0.7
    
				ent.x = len*math.sin(ent.ang) + ent.ct
				ent.y = len*math.cos(ent.ang) + ent.d
					
			end
			
			

		 if p.x>ent.x-8 and p.x<ent.x+8 then
    if p.y>ent.y-5 and p.y<ent.y+4 then
			  if p.clawed == false and ent.clawed == false
					and p.clawtimer == nil then
		    
		    ent.angv = ent.angv + p.vx/5
						
						p.vy=0
						p.vx=0
						p.clawed = true
						ent.clawed = true
						p.entkey = i
					else
					 ent.angv = ent.angv + p.vx/5
					end
					
				end
			end
			
			--allow ents to get clawed
			--[[i is claw, k is other
			for k,ent in pairs(ents) do
			 if ents[i].x > ents[k].x-10 
				and ents[i].x < ents[k].x+10 then
	    if ents[i].y > ents[k].y-5 
					and ents[i].y < ents[k].y+4 
			  and k ~= i  then
					 
						ents[k].clawed = true
						ents[i].clawed = true
					 ents[k].vx = 0
						ents[k].vy = 0
						ents[i].angv = ents[i].angv + ents[i].vx
						ents[k].clawtarget = i
					end
				end
			end
			]]
			if p.clawed == true then

    
    if btnp(2) then
				 ents[p.entkey].angv = ents[p.entkey].angv-0.2
				elseif btnp(3) then
				 ents[p.entkey].angv = ents[p.entkey].angv+0.2
				end
				
				p.x = ents[p.entkey].x
		 	p.y = ents[p.entkey].y
				
				
    if btnp(4) then
				 p.clawed = false
					ents[p.entkey].clawed = false
					p.vx = ents[p.entkey].angv*math.cos(ent.ang)*20
				 p.vy = -ents[p.entkey].angv*math.sin(ent.ang)*20
				 p.clawtimer = 1
					
				end
			end
			
 		if ent.angv < -.5 then
			 ent.angv = -.5
			elseif ent.angv > .5 then
			 ent.angv = .5
			end
			
		elseif ent.ty == 215 then
		
		 entmake(
   ent.x+18,ent.y+18,0,0,
   471,ent.x,ent.y,
   false,0,0)
		
	  table.remove(ents,i)
			
		--swinging axe
		
		elseif ent.ty == 471 then
		
		 local len,damp = 15,1
					
		
			if ent.ang == nil then
			 ent.ang = 1.7
				ent.angv = 0
				ent.anga = 0
				ent.v = 0
				ent.clawtimer = 0
				ent.clawed = false
			else
			
				ent.anga = -math.sin(ent.ang)/(len*2)
					
				ent.angv = damp*(ent.angv + ent.anga)
				
				ent.ang = ent.ang + ent.angv*0.2
    
				ent.x = len*math.sin(ent.ang) + ent.ct
				ent.y = len*math.cos(ent.ang) + ent.d
			end

		 if p.x>ent.x-12 and p.x<ent.x+12 then
    if p.y>ent.y-5 and p.y<ent.y+4 then

					death()
				end
			end
			
	
		-- circle platforms spawn
	 elseif ent.ty == 210 then
		
		 entmake(
   ent.x+32,ent.y,0,0,
   466,ent.x-4,ent.y,
   false,0,0,0,0)
   
   table.remove(ents,i)
   
  --rotating platforms
  elseif ent.ty == 466 then
   local len = 36
   
   
   
   
   	if ent.ang == nil then
			 ent.ang = 0
	
    ents[i].angv = 0.01
    
    for k,ent in pairs(ents) do
				 if ents[k].x+10 > ents[i].ct 
					and ents[k].x-10 < ents[i].ct
					and ents[k].y+20 > ents[i].d 
					and ents[k].y-20 < ents[i].d 
					and k~=i then
					 ents[i].angv = -0.01
						table.remove(ents,k)
						break
					end
				end
				
				ent.anga = 0
				ent.v = 0
				ent.clawtimer = 0
				ent.clawed = false
			else
			
			 if ent.angv == nil then
				 
				else
					
				ent.angv = (ent.angv + ent.anga)
				
				ent.ang = ent.ang + ent.angv
    
				ent.x = len*math.sin(ent.ang) + ent.ct
				ent.y = len*math.cos(ent.ang) + ent.d
			 end
			end

   if (p.x+p.vx) < ent.x+13 
			and (p.x+p.vx) > ent.x-7 then
    if  p.y+8+p.vy > ent.y 
    and p.y+p.vy < ent.y 
				and p.vy > 0 then
				 if ent.ploc == nil then
					 ent.ploc = p.x-ent.x
					 
					end
					p.platent = i
     p.onplat = true
					p.vy = 0
					jump=false
				 p.canjump = true
				 p.cjct=7
			  p.jct=0
			  onground=true

     if btn(2) then
      ent.ploc = ent.ploc - 1
     elseif btn(3) then
      ent.ploc = ent.ploc + 1
     end
     
     
					p.x=math.ceil(ent.x+ent.ploc)
					p.y=math.ceil(ent.y-8)
					
					--[[
					p.vx = ent.angv*math.cos(ent.ang)*len
					p.vy = -ent.angv*math.sin(ent.ang)*len
				]]
				else 
			  ent.ploc = nil
					p.onplat = false
				end
			else 
			 p.onplat = false
			 ent.ploc = nil
   end
   
  elseif ent.ty == 512 then
  
   ent.vy = -0.5
   
   if ent.y <= -20 then
    table.remove(ents,i)
   end

  --rotating deathboi
		--chill mines to relax and explode with
  elseif ent.ty == 193 then
   
   entmake(
   ent.x+32,ent.y,0,0,
   498,ent.x,ent.y,
   false,0,0)
   
   entmake(
   ent.x+32,ent.y,1,0,
   498,ent.x,ent.y,
   false,0,0)
   
   entmake(
   ent.x+32,ent.y,2,0,
   498,ent.x,ent.y,
   false,0,0)
   
   entmake(
   ent.x+32,ent.y,3,0,
   498,ent.x,ent.y,
   false,0,0)
   
   table.remove(ents,i)
   
  --mines
  elseif ent.ty == 498 then
   --[[ngl this bad boi is completely
       hecked. 
       ent.ct is origin x
       ent.d is origin y
       ent.vx is phi offset (90 degs apart)
   
   ]]
   ent.x = ent.ct+40*math.cos(time()/1000+ent.vx*0.5*math.pi)
   ent.y = ent.d+40*math.sin(time()/1000+ent.vx*0.5*math.pi)
   
   if p.x>ent.x-8 and p.x<ent.x+8 then
    if p.y>ent.y-5 and p.y<ent.y+4 then

					death()
				end
			end
		
		--bullet
		elseif ent.ty == 228 then
		 if p.x>ent.x-4 and p.x<ent.x+8 then
    if p.y>ent.y-5 and p.y<ent.y+4 then
		
					death()
				end
			end
			
			if solid(ent.x+2,ent.y+2) 
			or solid(ent.x+6,ent.y+6) 
		 or solid(ent.x+6,ent.y+2) 
			or	solid(ent.x+2,ent.y+6) then
			 table.remove(ents,i)
			end
			
		--feesh
		elseif ent.ty == 209 then
		 if solid(ent.x+4,ent.y+4) then
    table.remove(ents,i)
    splat(ent.x+4,ent.y+4)
   elseif solid(ent.x+9,ent.y) then
			 ent.vx = -0.5
				ent.rot = 0
	   ent.fl = 0
			elseif solid(ent.x-2,ent.y) then
			 ent.vx = 0.5
				ent.fl = 1
	
			elseif solid(ent.x+2,ent.y-4) then
			 ent.vy = 0.5
				ent.rot = 3
	
			elseif solid(ent.x+6,ent.y+8) then
    ent.vy = -0.5
    ent.rot = 1
   end
   
   if math.abs(ent.vx) >0 then
    ent.vy=0
    ent.rot = 0
   end
   
   if p.x>ent.x-8 and p.x<ent.x+8 then
    if p.y>ent.y-5 and p.y<ent.y+4 then
	
					death()
				end
			end
			
			
		--orb
		elseif ent.ty==195 then 
		 local r = math.random(3)
			if r==3 then
		  spawnparticle(ent.x+math.random(6),ent.y+7,0,0,0,.01,20,1,6,false,1,3)
   end
		 if ent.ct<32 then
    ent.vy=.1
	 	elseif ent.ct>32 and ent.ct<65 then
		  ent.vy=-.1
		 elseif ent.ct>64 then
		  ent.ct=0
		 end
			
			if p.x>ent.x-8 and p.x<ent.x+8 then
    if p.y>ent.y-5 and p.y<ent.y+2 then
			  speed=true
					table.remove(ents,i)
			 end
		 end
			
		--launchybois (bullet bull)
		elseif ent.ty == 211 
		or ent.ty == 227 then
		--pick direction
		 if ent.ldir == nil then
			 if solid(ent.x-6,ent.y+2) 
				or solid(ent.x+2,ent.y-6) then
					ent.ldir = 1
				else
					ent.ldir = -1
				end
			end
		
		--eat
		--[[MAKE SUPER SURE THE ENTS AROUND
		    ARE LAUNCHABLE
						
						i spent an hour debugging this
						and it turned out that it was
						eating a slingshot
						
						:(
						
						]]
		 if ent.lty == nil then
			 for k,ent in pairs(ents) do
				--if i change these 20s to 40s or whatever, nothing works
				 if ents[i].x > ents[k].x-10 and ents[i].x < ents[k].x+10 then
		    if ents[i].y > ents[k].y-20 and  ents[i].y < ents[k].y+40 
				  and k ~= i and ents[i].clawed == false then
	      ents[i].lty = ents[k].ty
							table.remove(ents,k)
						end
					end
				end
		
			else
			--launch
			
			 local ct
				if ent.lty == 228 then
     ct = 50				
    else
     ct=300
				end
			 if ent.ct<32 then

		 	elseif ent.ct>32 and ent.ct<34 then
     if ent.ty == 211 then
      entmake(ent.x+8*ent.ldir,ent.y,ent.ldir,0,ent.lty,0,0,false,0,0,false)
     else
      entmake(ent.x+4,ent.y+4*ent.ldir,0,ent.ldir*2,ent.lty,0,0,false,0,0,false)
     end
			 elseif ent.ct>ct then
			  ent.ct=0
			 end
			end
		
   
		--shell
		elseif ent.ty==272 then
		 if ent.ct > 5 then 
			 ent.d = true 
			end
		 
			if ent.d ==true then
			 if p.x>ent.x-8 and p.x<ent.x+8 then
     if p.y>ent.y-5 and p.y<ent.y+2 then
			   p.vy=-6
			  end
		  end
			end
  end
  
  --ent conveyor logic
  if world == 7 then
	  if mget((ent.x+7)//8,(ent.y+8)//8+(level-1)*34) == 54 
		 or mget((ent.x)//8,(ent.y+8)//8+(level-1)*34) == 54 then
		  ent.vx = ent.vx + 0.25
		  
		  
		  
		 elseif  mget((ent.x+7)//8,(ent.y+8)//8+(level-1)*34) == 61 
		 or mget((ent.x)//8,(ent.y+8)//8+(level-1)*34) == 61 then
		  ent.vx = ent.vx - 0.25
		 
		 end
		end 
		
		if ent.clawtarget ~= nil then
   ent.x = ents[ent.clawtarget].x
   ent.y = ents[ent.clawtarget].y
  end
		
	end
end



function entcheck(x,y,k)
  --floor to 8 before passing in 
  --
  --if I floor to 8, why doesn't
  --level *34 break everything?
  --mget is in tile coords
  
  --mystery for another time i guess
	 local t,t2,t3
	
		t =mget(x,k+y-8+(level-1)*34)
	 t2=mget(x+1,k+y-8+(level-1)*34)
		t3=mget(x,k+y-10+(level-1)*34)
		
	 if t>=192 then		
		 if t ~= 211 
			and t ~= 227 then
			 if t2 < 192 
				and solids[t2] == nil then
				 mset(x,k+y-8+(level-1)*34,t2)
				elseif t2 >=192 then
				 mset(x,k+y-8+(level-1)*34,t3)
				else
		   mset(x,k+y-8+(level-1)*34,0)
				end
			end
	 	entmake(math.floor(x*8)+1,math.floor(k*8+y*8-64),0,0,t,0,0,false,0,0,false)
			
		elseif t == 64  or t == 80 then
		 local dist = 0
			if t==64 then 
			 dist = -3
		 elseif t == 80 then 
			 dist = 3 
			end
		 --mset(x,k+y-8+(level-1)*34,0)
		 plantmake(x*8+1,k*8+y*8-63,    --x1,y1
            x*8+1,k*8+y*8-63+dist,  --x2,y2
            0,  0,    --vx2,vy2
            x*8+1,k*8+y*8-63+dist*2,  --x3,y3
            0,  0,    --vx3,vy3
            1,        --rigidity
            t, 3)    --sprite,distance
  end
end

function lines()
 local pi = math.pi
  for i=0,256,64 do
   linemult(math.sin(t+i)*30-math.cos(t/5)*50,
   135,
   -math.sin(t+i)*30+math.cos(t/5)*50,
   0,8,120)
   t=t+0.01
  end
end

function linemult(x,y,x2,y2,c,d)
 for i=0,240,240 do
  line(x+i+d,y,x2+i+d,y2,c)
 end
end

function seabgmake(x,y)
 seabg={x=x,y=y}
 table.insert(seabgs,seabg)
end

function seabglogic()

 if next(seabgs) == nil  then
  for i=0,128,1 do
   seabgmake (i*64-40+math.random(20),math.random(40+20))
  end
 end

 --[[if #seabgs < 10 then
	 if p.vx >0 then
	  local c = math.random(40)
	  if c == 1 then
	   seabgmake (cam.x/2+280,math.random(70+20))
	  end
	 elseif p.vx <0 then
	  local c = math.random(40)
	  if c == 1 then
	   seabgmake (cam.x/2-40,math.random(70+20))
	  end
	 end
	end]]

 for i,seabg in ipairs(seabgs) do
  --[[
  for k,seabg in pairs(seabgs) do
   if seabgs[i] ~= nil 
   and seabgs[k] ~= nil then
		  if seabgs[i].x > seabgs[k].x -30
				and seabgs[i].x < seabgs[k].x +30 
				and k ~= i then
					table.remove(seabgs,i)
				end
			end
		end
		--[[
  if seabg.x > (cam.x/2+300)
  or seabg.x < (cam.x/2-150) then
   table.remove(seabgs,i)
  end]]

	 for j=seabg.y,136,1 do
	  line(seabg.x-cam.x/2+math.sin(time()/1000+j%10*100)*2,
		  seabg.y+j,
				seabg.x+20-cam.x/2+math.sin(time()/1000+j%10*100)*2,
		  seabg.y+j,
				5+(seabg.y+j)/50)
				--6+math.abs(math.sin(i))*2 also looks decent
	 end
	end
end

function rain()
 for i=0,13,1 do
  spawnparticle(math.random(400)+cam.x,0,-0.5,3,0,0,300,4,5,false,0,3)
 end
end

function clouds(loc,rnd,light,dark)
 local r = math.random(40)
 local y = math.random(130)
 local v = math.random(3)/10
 if rnd == true then
	 --low clouds
		if r == 1 then
		 for i=0,13,1 do
	   spawnparticle(loc+math.random(60),y+math.random(40)+80,v-.5, 0,0,0,2000,1,light,false,math.random(13)+4,2)
	   spawnparticle(loc+math.random(60),y+math.random(40)+80,v-.5, 0,0,0,2000,1,dark,false,math.random(13)+4,2)
			end
	 --high clouds
	 elseif r == 2 then
		 for i=0,13,1 do
	   spawnparticle(loc+math.random(60),y+math.random(40)-80,v-.5, 0,0,0,2000,1,light,false,math.random(13)+4,2)
				spawnparticle(loc+math.random(60),y+math.random(40)-80,v-.5, 0,0,0,2000,1,dark,false,math.random(13)+4,2)
	  end
		--even lower clouds
		elseif r == 2 then
		 for i=0,16,1 do
	   spawnparticle(loc+math.random(60),y+math.random(40)+100,v-.5, 0,0,0,2000,1,light,false,math.random(13)+4,2)
				spawnparticle(loc+math.random(60),y+math.random(40)+100,v-.5, 0,0,0,2000,1,dark,false,math.random(13)+4,2)
	  end
  end
 --startclouds
	else
	 loc = loc-100
	  for i=0,13,1 do
	   spawnparticle(loc+math.random(300),y+math.random(40)+30,v-.5, 0,0,0,2000,1,light,false,math.random(13)+4,2)
				spawnparticle(loc+math.random(300),y+math.random(40)+30,v-.5, 0,0,0,2000,1,dark,false,math.random(13)+4,2)
	  end
			for i=0,20,1 do
	   spawnparticle(loc+math.random(300),y+math.random(40)-80,v-.5, 0,0,0,2000,1,light,false,math.random(13)+4,2)
				spawnparticle(loc+math.random(300),y+math.random(40)-80,v-.5, 0,0,0,2000,1,dark,false,math.random(13)+4,2)
	  end
			for i=0,20,1 do
	   spawnparticle(loc+math.random(300),y+math.random(40),v-.5, 0,0,0,2000,1,light,false,math.random(13)+4,2)
	   spawnparticle(loc+math.random(300),y+math.random(40),v-.5, 0,0,0,2000,1,dark,false,math.random(13)+4,2)
			end
   for i=0,20,1 do
	   spawnparticle(loc+math.random(300),y+math.random(40)+130,v-.5, 0,0,0,2000,1,light,false,math.random(13)+4,2)
	   spawnparticle(loc+math.random(300),y+math.random(40)+130,v-.5, 0,0,0,2000,1,dark,false,math.random(13)+4,2)
			end
 end
end


function createwipe(x,y,r,c)
 wipe = {x=x,y=y,r=r,c=c}
 
 table.insert(wipes,wipe)

end


function wipelogic()
 if ltt>0 or lst >0 then
	 if math.random (2) == 1 then
		 createwipe(260,math.random(140),math.random(5)+10,5)
	  createwipe(260,math.random(140),math.random(5)+10,5)
	 
	 else
	  createwipe(260,math.random(140),math.random(5)+10,11)
	  createwipe(260,math.random(140),math.random(5)+10,11)
	 end
 end



 for i,wipe in ipairs(wipes) do
 
  wipe.x = wipe.x-2
  vbank(1)
  circ(wipe.x,wipe.y,wipe.r,wipe.c)
  vbank(0)
  
  if wipe.x<-20 then
   table.remove (wipes,i)
  end
 end
 
end



function plantmake(x1,y1,x2,y2,vx2,vy2,x3,y3,vx3,vy3,rig,img,ydist)
 plant={x1=x1, --base segment
		      y1=y1,
								x2=x2, --second segment
		      y2=y2,
								vx2=vx2,
								vy2=vy2,
								x3=x3, --top segment
		      y3=y3,
								vx3=vx3,
								vy3=vy3,
								intx = intx, --intensityx
								inty = inty, --intensityx
								rig = rig, --rigidity
								img = img, --sprite
								ydist=ydist} --distance between plants
 table.insert(plants,plant)
end

function plantlogic()
 for i,plant in ipairs(plants) do
 
  if plant.y1 < 0 then
   table.remove (plants, i)
  end
 
  if p.x>plant.x1-8 and p.x<plant.x1+8 then
   if p.y>plant.y1-5 and p.y<plant.y1+4 then
    plant.vx2 = p.vx/7
    plant.vy2 = p.vy/5
    plant.vx3 = p.vx/5
    plant.vy3 = p.vy/2
		 end
	 end
		
		plant.x2 = plant.x2 + plant.vx2
		plant.y2 = plant.y2 + plant.vy2
		
		plant.x3 = plant.x3 + plant.vx3
		plant.y3 = plant.y3 + plant.vy3
		
		if plant.x2 > plant.x1+2 then
		 plant.vx2 = 0
		elseif plant.x2 < plant.x1-2 then
		 plant.vx2 = 0
		elseif plant.x3 > plant.x1+4 then
		 plant.vx3 = 0
		elseif plant.x3 < plant.x1-4 then
		 plant.vx3 = 0
		end
		
  local dx2 = plant.x1	- plant.x2
		plant.vx2 = dx2*plant.rig/50
		
  local dx3 = plant.x1	- plant.x3
		plant.vx3 = dx3*plant.rig/50
			
		if plant.img == 64 then
			local dy2 = plant.y1 - plant.ydist	- plant.y2
			plant.vy2 = dy2*plant.rig/30
			
			local dy3 = plant.y1 - (2 * plant.ydist)	- plant.y3
			plant.vy3 = dy3*plant.rig/30
			
		elseif plant.img == 80 then
		 local dy2 = plant.y1 + plant.ydist	- plant.y2
			plant.vy2 = dy2*plant.rig/30
			
			local dy3 = plant.y1 + (2 * plant.ydist)	- plant.y3
			plant.vy3 = dy3*plant.rig/30
  
  else
		 local dy2 = plant.y1 - plant.ydist	- plant.y2
			plant.vy2 = dy2*plant.rig/30
			
			local dy3 = plant.y1 - (2 * plant.ydist)	- plant.y3
			plant.vy3 = dy3*plant.rig/30
  end
  
  	
  spr(plant.img,plant.x1-cam.x,plant.y1-cam.y,0)
  
  --[[grass
  if plant.img == 66 then
   spr(67,plant.x2-cam.x,plant.y2-cam.y,0)
  else
   spr(plant.img,plant.x2-cam.x,plant.y2-cam.y,0)
  end]]
  
  --flower
  if plant.img == 64 then
   spr(304,plant.x3-cam.x,plant.y3-cam.y,0)
  elseif plant.img == 80 then
   spr(305,plant.x3-cam.x,plant.y3-cam.y,0)   
  end
 end
end



-- menu: backgrounds ITEM2 ITEM3

function ITEM1()
 if bganim == true then
  bganim = false 
 else
  bganim = true
 end

end
function ITEM2()trace("2")end
function ITEM3()trace("3")end

GameMenu={ITEM1,ITEM2,ITEM3}

function MENU(i)
  GameMenu[i+1]()
end

function worldchange(w,l)
 --clear particle buffer
  allparticles = {}

 --stop music
 --music()
 
 world = w
 level = l
 
 if world == 6 then
 
 solids={[1]=true,[2]=true,[3]=true,
				        [17]=true,[18]=true,[19]=true,
												[33]=true,[34]=true,[35]=true,[36]=true,
												[37]=true,[48]=true,
												[16]=true,[32]=true,
												[211] = true,[227]=true,
												
												--girders
												[105] = true,[104] = true,[105] = true,
												[119] = true,[120] = true,[121] = true,[122] = true,
												[135] = true,[136] = true,[137] = true,[138] = true
												
												}
												
 elseif world == 7 then
  upflips={}
  downflips={}
  
  solids={[1]=true,[2]=true,[3]=true,
				        [17]=true,[18]=true,[19]=true,
												[33]=true,[34]=true,[35]=true,[36]=true,
												[37]=true,[48]=true,
												[137]=true,[138]=true,
												[153]=true,[154]=true,
  	         [32]=true,
  
            --stickys addition
            [4]=true,[5]=true,[6]=true,
												[20]=true,[21]=true,[22]=true,
												[36]=true,[37]=true,[38]=true,
												
												
												--pipe addition
											 [9]=true,[10]=true,[11]=true,
												[12]=true,[13]=true,[14]=true,[25]=true,
												[26]=true,[27]=true,[28]=true,
												[29]=true,[41]=true,[42]=true,
												[43]=true,[44]=true,[45]=true,
												[30]=true,
												--DOUBLE CHECK ME
												
												--conveyor
												[54]=true,[61]=true
												}


 stickys = {[4]=true,[5]=true,[6]=true,
												[20]=true,[21]=true,[22]=true,
												[36]=true,[37]=true,[38]=true
												}

 pipes={[41]=true,[14] = true}

 elseif world == 4 then
 
 upflips={}
 downflips={}
 
 stickys = {}
 
 solids={[1]=true,[2]=true,[3]=true,
				        [17]=true,[18]=true,[19]=true,
												[33]=true,[34]=true,[35]=true,[36]=true,
												[37]=true,[48]=true,
												[137]=true,[138]=true,
												[153]=true,[154]=true,
												[32]=true,
												
												--extra bricc addition
												[7]=true,[8]=true,
												[23]=true,[24]=true,
												[39]=true,[40]=true,
												[55]=true,[56]=true, 
												
												
												
												[176]=true}

  
  underwater = true
  
 elseif world == 5 then
  deathys={[11]=true,[12]=true,[13]=true,[14]=true,[15]=true,
           [27]=true,[28]=true,[29]=true,[30]=true,[31]=true,
           [43]=true,[44]=true,[45]=true,[46]=true,
  
           [49]=true,[50]=true,[65]=true, [66]=true
  
  
  
  }
  
 elseif world == 3 then
 
 solids={[1]=true,[2]=true,[3]=true,
         [4]=true,[5]=true,[6]=true,
         [7]=true,[16]=true,
	        [17]=true,[18]=true,[19]=true,
									[20]=true,[21]=true,[22]=true,
									[23]=true,
									[33]=true,[34]=true,[35]=true,[36]=true,
									[37]=true,[48]=true,
									[32]=true,
									
									[54]=true,[55]=true,[56]=true,
									[70]=true,[71]=true,[72]=true,
									[86]=true,[87]=true,[88]=true,
      			
									--stickys
									[61]=true,[62]=true,[63]=true,
         [77]=true,[78]=true,[79]=true,
         [93]=true,[94]=true,[95]=true,
         
							
									[153]=true
						
									}
									
		oneways = {[150]=true,[151]=true,[152]=true,
		           [134]=true,[135]=true,[136]=true}
	 unstables = {[166]=true,[167]=true,[168]=true}
	 
		
													

  stickys={[61]=true,[62]=true,[63]=true,
           [77]=true,[78]=true,[79]=true,
           [93]=true,[94]=true,[95]=true}
  

  
 --[[elseif world == 3 then
 
 solids={[1]=true,[2]=true,[3]=true,
				        [17]=true,[18]=true,[19]=true,
												[33]=true,[34]=true,[35]=true,[36]=true,
												[37]=true,[48]=true,
												[32]=true,
												[137]=true,[138]=true,
												[153]=true,[154]=true}
 
 oldcrystals={[91]=true,[92]=true,
             [93]=true,[94]=true,
             [107]=true,[108]=true,
             [109]=true,[110]=true,
             [111]=true,[124]=true,
             [125]=true,[126]=true,
             [127]=true}]]
 
 elseif world == 8 then
	 --set grav shift tiles
	 upflips={[7]=true,[8]=true,[9]=true,
	          [23]=true,[24]=true,[25]=true,
	          [39]=true,[40]=true,[41]=true,} 
	 
	 downflips={[9]=true,[10]=true,[11]=true,
	            [25]=true,[26]=true,[27]=true,
	            [41]=true,[42]=true,[43]=true,}
	 
		solids = {[1]=true,[2]=true,[3]=true,
				        [17]=true,[18]=true,[19]=true,
												[33]=true,[34]=true,[35]=true,
												[36]=true,[37]=true,[38]=true,
												[48]=true,--climby
												[52]=true,[53]=true,[54]=true,
		
		
		          --mmzx type tiles
												[91]=true,[92]=true,[93]=true,[94]=true,[95]=true,
												[107]=true,[108]=true,[109]=true,[110]=true,[111]=true,
												
		
		          [185]=true
		          }
		
		
		
		
	
  
 else
  upflips={}
  downflips={}
 end
 
 sync(0,world,false)
 --music(0,0)
end

function rotspr(s,x,y,r,w,h,fx,fy,sw,sh)
    if not w then
        w=1
    end
    if not h then
        h=1
    end
    if not sw then
        sw=8
    end
    if not sh then
        sh=8
    end
    local p={}
    local v=math.sqrt(32)
    for i=0,4 do
        p[i*2+1]=x+4+math.cos((0.375+i/4+(r/math.pi/2))*math.pi*2)*v*w
        p[i*2+2]=y+4+math.sin((0.375+i/4+(r/math.pi/2))*math.pi*2)*v*h
    end
    local x1=s%16*8
    local y1=math.floor(s/16)*8
    local x2=x1+sw
    local y2=y1+sh
    if fx then
        x1=x1+sw
        x2=x2-sw
    end
    if fy then
        y1=y1+sh
        y2=y2-sh
    end
    ttri(p[1],p[2],p[3],p[4],p[5],p[6],x1,y2,x1,y1,x2,y1,0)
    ttri(p[1],p[2],p[7],p[8],p[5],p[6],x1,y2,x2,y2,x2,y1,0)
end

function tablereset(tab)
	for i,v in ipairs(tab) do
	table.remove(tab,i)
	end
end
-- <TILES>
-- 001:7777777777799999779aaaaa79aaaaaa79aaaaaa79aaaaaa79aaaaa979aaaa97
-- 002:7777777799999999aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9999999977777777
-- 003:7777777799999777aaaaa977aaaaaa97aaaaaa97aaaaaa979aaaaa9779aaaa97
-- 005:7aaaaaa7aa3333aaa333334aa332244aa332244aa344444aaa4444aa7aaaaaa7
-- 006:5555555555999955599cc98559c22c8559c22c85598cc8855588885555555555
-- 009:77777e7777777ee77ee7eeee7eeeeeee77eeeeff7effffff7eeeefff77ffffff
-- 010:777777777ee77777eeee7ee7eeeeeeeefffffeeefffeeeeffffffeeeffffffff
-- 011:77e777777ee77777eeee7ee7eeeeeee7ffeeee77ffffffe7fffeeee7ffffff77
-- 012:7777777777777777777777777777777777767767766676566566665555555555
-- 013:77776655777655aa7765aaaa7665aa88655aa8885aaa88885aa88888aaa88888
-- 014:7777765577776555777776657777776577776665777776657777765577777765
-- 015:a5567777aaa56777aaa5667788aa5567888aaa568888aa5688888aa588888aa5
-- 017:79aaaa9779aaaaa979aaaaaa79aaaaaa79aaaaaa779aaaaa7779999977777777
-- 018:79aaaa979aaaaa97aaaaaa97aaaaaa97aaaaaa97aaaaa9779999977777777777
-- 019:79aaaa9779aaaa9779aaaa9779aaaa9779aaaa9779aaaa9779aaaa9779aaaa97
-- 021:0aaaaaa0aa3333aaa333334aa332244aa332244aa344444aaa4444aa0aaaaaa0
-- 023:99999999999aaaaa99abbbbb9abbbbbb9abbbbbb9abbbbbb9abbbbba9abbbba9
-- 024:99999999aaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbaaaaaaaa99999999
-- 025:99999999aaaaa999bbbbba99bbbbbba9bbbbbba9bbbbbba9abbbbba99abbbba9
-- 027:9999999999999999999999999999999999999999999999999999999999999999
-- 028:bbaabbbbbaa9baaaa999a9999999999999999999999999999999999999999999
-- 029:8888888888888888888888888888888888888888888888888888888888888888
-- 030:8888888888888888888888888888888888888888888888888888888888888888
-- 031:888888aa8888888a888888888888888888888888888888888888888888888888
-- 033:b999999aba9999a9b9a99a99b99aa999b99aa999b9a99a99ba9999a9b999999a
-- 034:bbbbbbbb88888888888888888888888888888888888888888888888888888888
-- 035:8888888b8888888b8888888b8888888b8888888b8888888b8888888b8888888b
-- 039:9abbbba99abbbbba9abbbbbb9abbbbbb9abbbbbb99abbbbb999aaaaa99999999
-- 040:9abbbba9abbbbba9bbbbbba9bbbbbba9bbbbbba9bbbbba99aaaaa99999999999
-- 041:9abbbba99abbbba99abbbba99abbbba99abbbba99abbbba99abbbba99abbbba9
-- 044:9999999999999999999999999999999999999999999a999aaaab9aabbbbbaabb
-- 045:888888aa88888aa68888aaa6888aa66688aa66678aaa6677aa66677766667777
-- 046:5677777755677777566777775666777756777777566777775556777755677777
-- 047:5aa888885aa8888865aa888865aaa8886655aa8876665aaa77665aaa7776655a
-- 049:b999999a8b9999a988b99a99888ba9999888b99989888b99898888b98988888b
-- 050:8888888888888888888888888888888888888888888888888888888888888888
-- 051:8888888b888888b888888b888888b888888b888988b888988b888988b8889888
-- 052:8888888888aa88888a99a88889949a88894449a8894449a88944449889444498
-- 053:888888888888888888aaaa888a9999a8a944449a944444499444444994444449
-- 054:888888888888888888888888aaaaaaaa99999999944994499449944994499449
-- 060:5555555565666656666666667777666777777777777777777777777777777777
-- 061:7777777777777777777777777777777777777777777777777777777777777777
-- 062:6667777766777777677777777777777777777777777777777777777777777777
-- 063:7777665577776665777776667777776677777777777777777777777777777777
-- 065:8888988888888988898888988898888988898889888888888888888888888888
-- 066:bbbbbbbb98888888988888888888888899989999888898888888988888889888
-- 067:8889888888988888898888989888898898889888888888888888888888888888
-- 068:8944449888944498888944988888949888888998888888888888888888888888
-- 069:9444444994444449944444499aaaaaa999999999888888888888888888888888
-- 070:9999999994499449944994499449944999999999888888888888888888888888
-- 076:5555555555666656556766675677677756777777566777775566777755677777
-- 077:5555555555666555666776657677776577776665777776657777765577777765
-- 078:7777777777777777777777777777777777777777777776657777655577777655
-- 079:7777777777777777777777777777777776777777656777775567777755577777
-- 081:a88898889a88898899a88898999a8889999aa88899a99a889a9999a8a999999a
-- 082:9999998898888888988888888888888899989999888898888888988888889888
-- 083:8889888a889888a989888a999888a999888aa99988a99a998a9999a9a999999a
-- 084:a999999a9a9999a999a99a99999aa999999aa99999a99a999a9999a9a999999a
-- 085:a9a9999aaa9999a9a9a99a99aa9aa999aa9aa999a9a99a99aa9999a9a9a9999a
-- 092:5677777755677777566777775666777756777767566776665556665555555555
-- 093:7777765577776655777776657777776577767765766676556566665555555555
-- 114:6aaaaa56aaaaaa67aaaaa9779aaa997899669998997799888997988888878888
-- 172:bbbbbbbbbbbbbbbbaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbaaaaaaaaaaaaaaaa
-- 173:bbbbaaaabbbbbaaaaaabbbbbaaaabbbbbbbaaaaabbbbaaaaaabbbbbbaaabbbbb
-- 174:aaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbb
-- 175:aaabbbbbaabbbbbbbbbbaaaabbbaaaaaaaaabbbbaaabbbbbbbbbbaaabbbbaaaa
-- 189:bbbbbbbbbbbbbbbbaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbb0000000000000000
-- 190:bbbbaaaabbbbbaaaaaabbbbbaaaabbbbbbbaaaaabbbbaaaa00bbbbbb000bbbbb
-- 191:aaaabbbbaaabbbbbbbbbbaaabbbbaaaaaaaaabbbaaaabbbbbbbbbb00bbbbb000
-- </TILES>

-- <TILES1>
-- 001:5555555555566565565566665666667655566777556666775666666756666777
-- 002:5555555556565555665566566766666777766766667777777667667777777667
-- 003:5555555555555555666565557665665576656655776766556677665567776565
-- 004:7777777777777777777777777777667777777667776677777776676677777765
-- 005:7777777766777777766777777777777777766777667766776667777756677777
-- 006:5666777766677777666777777777777776777777666777776666777756666777
-- 007:00000e0000000ee00ee0eeee0eeeeeee00eeeeff0effffff0eeeefff00ffffff
-- 008:000000000ee00000eeee0ee0eeeeeeeefffffeeefffeeeeffffffeeeffffffff
-- 009:00e000000ee00000eeee0ee0eeeeeee0ffeeee00ffffffe0fffeeee0ffffff00
-- 010:fffffffffffffffffffffffffffffffffffffffffffffff4ffffff44fffff440
-- 011:ffffffffffffffffffffffffffffffffffffffff4fffffff44ffffff044fffff
-- 012:0888888808aaaaaa08a9999908999999088888888aaaa8aa8a9998a989999899
-- 013:88888888aaaaa8aa999998a99999989988888888aa8aaaaa998a999999899999
-- 014:88888880aaaaaa80999999809999998088888880a8aaaaa898a9999898999998
-- 016:5555555556666665566776655677776556777765567777655666666555555555
-- 017:5566667656666677566666675566667755566777565677775666777755667677
-- 018:7777777777777777777777777777777777777777777777777777777777777777
-- 019:7766666577776665767765657667665577667665776776557777756566777665
-- 020:7776766577667666777677667777777777667766777667677777777777777777
-- 021:5667667766677667667777777776677766776677766777777777777777777777
-- 022:7777766577777766777777777777777777777777777777777777776677777665
-- 023:0eeeeeff00efffff0eeeeeef0eeeeeff0eeeffff00eeeeff0eeeefff0eeeeeef
-- 024:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 025:ffffeeeefeeeeee0ffffffe0fffeee00feeeee00fffeeee0fffffe00fffeee00
-- 026:fffff440ffffff44fffffff4ffffffffffffffffffffffffffffffffffffffff
-- 027:044fffff44ffffff4fffffffffffffffffffffffffffffffffffffffffffffff
-- 032:aa0aa0aaa000000a00000000a000000aa000000a00000000a000000aaa0aa0aa
-- 033:5556766756667776566666775566777755566566555655565555555555555555
-- 034:7777777767677777676676767776666666666666566556665566555555555555
-- 035:6667666576776555676776556777666556676665656665655555555555555555
-- 036:5555555556666666566666775667777756777777566777775666666655555555
-- 037:5555555566666665777766657777776577777665666666656666666555555555
-- 038:7777776777667777776667777776777777777667766776777666777777677777
-- 039:00ffffff0eeeefff0effffff00eeeeff0eeeeeee0ee0eeee00000ee000000e00
-- 040:fffffffffffffeeefffeeeeffffffeeeeeeeeeeeeeee0ee00ee0000000000000
-- 041:ffffff00fffeeee0ffffffe0ffeeee00eeeeeee0eeee0ee00ee0000000e00000
-- 042:ffff4f4cfff4d4ccff4d4cccf444d4c04d4d4cc044d444ccc44ddd4ccc444dcc
-- 043:ffffffffffffffffffffffffffffffffffffffffffffffff4ffffff444ffff44
-- 048:2222222222aaaa812a2aa8a12aa28aa12aa81aa12a8aa1a128aaaa1111111111
-- 049:84c884c844c8844c444c444c444c444c4444444c844444c88885688888856888
-- 050:8885688888856888844444c84444444c444c444c444c444c44c8844c84c884c8
-- 051:884c4c88844c44c8444c444c444c444c4444444c844444c88885688888856888
-- 052:8885688888856888844444c84444444c444c444c444c444c844c44c8884c4c88
-- 053:ff66fff6f6666666f6fff6ff66f666f666fff666f6f6f6f6666666f66fff6666
-- 054:aaaaaaaaaaa5555aaa555555a5555555a5555aa5a5555aa5a5555555a5555555
-- 055:aaaaaaaaaaaaaaaa5aaaaaaa55aaaaaa555aaaaa5555aaaa55555aaaa55a55aa
-- 056:8bb88888bbb888b8baa98bbbb998b9aa9988899a898888988888888888898888
-- 057:dddddddddccdcdddcdccdccddc44d44cdc4d4d44c4d4d4d4dddddddddddddddd
-- 058:cc4dddccc4dddd4cc44ddd4ccc4dd4c0c4dddd4c0c4ddd4c0cd4d4c00c4dd4c0
-- 059:4fffff444fff44444fffff404444ff4004ffff4004444f4404ffff44444fff40
-- 064:000000000000000000000000000000000000e000000ef000000f600000066000
-- 065:04c004c044c0044c444c444c444c444c4444444c044444c00005600000056000
-- 066:0000000000500500000000000000000000500000005500050005555000000000
-- 067:004c4c00044c44c0444c444c444c444c4444444c044444c00005600000056000
-- 068:0000000000550000050500000055000000050000000555000000550000000000
-- 069:aaaaaaaaaa5555aaa555555aa5aaaa5aa555555aaa5aa5aaaa5aa5aaaaaaaaaa
-- 070:a555555aaa555555aaa55555aaaa5555aaaaaa55aaaaaaaaaaaaaaaaaaaaaaaa
-- 071:aa55a5aaaaa555aa5aaa55aa55aaa5aa555aaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 072:888888888bbb88888baaa8888a99888889988888889888888888888888888888
-- 073:888888888888888888888888888888888899aa88898aa9b889888898888889a8
-- 074:0ccdd4c00c4ddd4cc4d4dd4cc44d44c00c4cc4c0c4d4cc4ccc4cc0c40ccc0000
-- 075:44444dd404ddddd404444d440444dd4044444440444444400404440000004000
-- 080:00066000000f6000000ef0000000e00000000000000000000000000000000000
-- 082:aaaaaa00aaa3aaa9aa333aa9a3a3a3a9aaa3aaa900aaaaa9000980a900098000
-- 083:0aaaaaa00aa3aaa000aa3aaa99aaa3aa88a3a3a300aa333a000aa3aa00099999
-- 084:aaaaaa88aa333aa9a3a3a3a9a33333a9aa3a3aa988aaaaa9888988a988898888
-- 087:00000aaa0aaa9a980a9999880999988800998888aa988888a988888898888888
-- 088:aaa90000a9980aaaa888a8998888888988888888888888888888888888888888
-- 089:aaa000009999aaa08889a9a0888889908889999088889880888888aa8888888a
-- 090:888888888888888888888888888888888888888888888888888888898888889a
-- 091:88888888888888888888888888888888888888888888888898888888a9888888
-- 093:81aaaaaa81aaaaaa81aaaaaa81aaaaaa811aaaaa811aaaaa811aaaaa811aaaaa
-- 094:00000000000000000001a00000001a0000001a0000001aa0000001aa000001aa
-- 095:000000010000001a000001aa00001aa00011aa0011aaaa00aaaa0000aaa00000
-- 096:000000e30000eef300eefff3eefffff300eefff30000eef3000000e300000003
-- 097:aaaaaa00a33aaaa9aaa3a3a9aaaa33a9aaa333a900aaaaa9000980a900098000
-- 098:aaaaaa00aa3a3aa9aaaaaaa9a3aaa3a9aa333aa900aaaaa9000980a900098000
-- 099:0aaaaaa00aa3aaa0aa3aaa003a3a3a99a333aa88aa3aaa00aaaaa00099999000
-- 100:0aaaaaa00aaa33a000a33a3a99aa333a88a33a3a00aa33aa000aaaaa00099999
-- 102:01111110112222aa1228822a1282282a1282882a1228822a1a2222aa0aaaaaa0
-- 103:aa888888a998888808888888aaa88888a9888888899888888888888809998888
-- 104:8888888888888888888888888888888888888888888888888888888888888888
-- 105:88888aaa8888889a8888999a88899aa988889900888889a0888889a0888899a0
-- 106:8888889a88888889888888888888888888888888888888888888888888888888
-- 107:a988888898888888888888888888888888888888888888888888888888888888
-- 110:000000aa00000aaa0000aaaa000aaaaaaaaaaaa0aaaaaa00aaaaa000aaaa0000
-- 111:aa000000aaa00000aaaa00000a0aa00000000000000000000000000000000000
-- 112:0000000300000003000000030000000300000003000000030000000300000003
-- 113:88888843888844c38844ccc344ccccc38844ccc3888844c38888884388888883
-- 114:aaaaaa00a3a3aaa9aa3a3aa9aaaaaaa9aaaaaaa900aaaaa9000980a900098000
-- 119:a9988888aa9888880998898809888988099889880a9a999800aa999900000aaa
-- 120:8888888888888888888888888888888888888888898a8988a98a9988aa0aa880
-- 121:888888898888889a888889aa888888808888890088999a0089a9aa00aaa00000
-- 122:bbb1a888b11aaa11baaaaaa1aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 123:a988899aa988899aa988899aa988889aa998889aa998889aa998889aa998889a
-- 128:0000002300002213002211132211111300221113000022130000002300000003
-- 129:8888888388888883888888838888888388888883888888838888888388888883
-- 139:4aaaaaa4aa4aaaaa44d4aa4a44444444cc4cc44c44c4cc4cccccaaccaccaaaaa
-- 144:0000000300000003000000030000000300000003000000030000000300000003
-- 145:0000000000000000000000000000000000000000c6c6cc6c4c4c4c4c44444444
-- 146:000000000000000000000000000000000000000000000000060606060c0c0cc0
-- 150:0066666606665566666555566665555666665566666666667666666607777777
-- 151:6666666666666666666556666655556666555566666556666666666677777777
-- 152:6666660066556660655556666555566666556666666666666666666777777770
-- 153:00cccccc0cccddcccccddddccccddddcccccddcccccccccc4ccccccc04444444
-- 154:cccccccccccccccccccddcccccddddccccddddcccccddccccccccccc44444444
-- 155:cccccc00ccddccc0cddddccccddddcccccddccccccccccccccccccc444444440
-- 156:009999990999aa99999aaaa9999aaaa99999aa99999999998999889908880088
-- 157:9999999999999999999aa99999aaaa9999aaaa99999aa9998999999808888880
-- 158:9999990099aa99909aaaa9999aaaa99999aa9999999999999998899888800880
-- 159:09abba9009abba9009abba9009abba9009abba9009abba9009abba9009abba90
-- 160:aa7777aaa775579a77577779757777797577777977777779a777779aaa9999aa
-- 168:09abba9009abbaa909aabbaa009abbbb009aabbb0009aaaa0000999900000000
-- 169:09abba909aabba90aabbba90bbbbaa90bbaaa900aaa990009990000000000000
-- 170:000000000000099900099aaa009aaabb09aabbbb09abbbaa09abbaa909abba90
-- 171:0000000099990000aaaa9000bbbaa900bbbba900aabbaa909aabba9009abba90
-- 172:00ffffff0fffeefffffeeeeffffeeeefffffeeffffffffffcfffffff0ccccccc
-- 173:fffffffffffffffffffeefffffeeeeffffeeeefffffeefffffffffffcccccccc
-- 174:ffffff00ffeefff0feeeeffffeeeefffffeefffffffffffffffffffcccccccc0
-- 175:0000000099999999aaaaaaaabbbbbbbbbbbbbbbbaaaaaaaa9999999900000000
-- 176:eeeeeeeee444444ce434434ce443344ce443344ce434434ce444444ceccccccc
-- 177:eeeeeeeee444444ce443344ce434434ce434434ce443344ce444444ceccccccc
-- 178:0dddddd0deeeeeefde3ee3efdee33eefdee33eefde3ee3efdeeeeeef0ffffff0
-- 179:0e0ee0e0e000000e00e00e00e00ee00ee00ee00e00e00e00e000000e0e0ee0e0
-- 180:0555555056666667566336675636636756366367566336675666666707777770
-- 181:0707707070000007000770007070070770700707000770007000000707077070
-- 182:eeeeeeeeffffffff66222266000880000008100000a1aa00ffffffffeeeeeeee
-- 183:eeeeeeeeffffeeffff66feff6666ffff66006f66600006000000000000000000
-- 184:033333303b3333b3333bb33333bbbb3333bbbb33333bb3333b3333b303333330
-- 185:eeeeeeeeefeeeefef6eeee6f6eeeeee6efeeeefee6eeee6eeeeeeeeeeeeeeeee
-- 186:77777777799d9997791d9d977d111d177111111779111d97799dd99777777777
-- 188:0000000000000000000300000000300000003000000300000000000000000000
-- 189:0000000000000000000030000003000000030000000030000000000000000000
-- 190:0000000000000000000000000030030000033000000000000000000000000000
-- 191:0000000000000000000000000003300000300300000000000000000000000000
-- 192:0aaaaac0aaaaaaacaa4a4aacaa4a4aacaaaaaaac0aaaaac000c00c0000c00c00
-- 193:0055500005000050000000055000000550000005500000000500005000055500
-- 194:0005e000005ffe0005ffffe05ff5effefffeeffc0fffffc000fffc00000fc000
-- 195:0ffffff0ff7777fff77ee77ff7777e7ff7777e7ff777777fff7777ff0ffffff0
-- 196:0000000000444d00044444d004d4d4d004d4d4d0044444d000444d0000000000
-- 197:4444444444444888444488884444888844448888044488880044488800044444
-- 198:0000000000000000000ee00000edde0000edde00000ee0000000000000000000
-- 199:0000000000000000000880000082280000822800000880000000000000000000
-- 200:0ffffff0ff7eeefff77e77eff77ee7effe7ee77ffe77e77fffeee7ff0ffffff0
-- 201:0005000000055000005550000322222032222222322252523222525232222222
-- 202:0999998099999998999999989995959899959598999999989999999808888880
-- 208:0eeeeef0eeeeeeefee4e4eefee4e4eefeeeeeeef0eeeeef000f00f0000f00f00
-- 209:000000000ddddd0ddceceededceceeeedeeeeefe0fffff0f0000000000000000
-- 210:00eeeee0e0000000e000000ee0eeee0ee0eeee0ee00ee00e0000000e0eeeee00
-- 211:0777777077777777677777766777777667777776677777767777777707777770
-- 212:00000000000000000eeeeee0eeefefffeeeeffffeefeffff5feffff505555550
-- 213:00eeeeee0eee55eeeee5555eeee5555eeeee55eeeeeeeeeefeeeeeee0fffffff
-- 215:00000000000000000bb88000bb822800bb8228000bb880000000000000000000
-- 216:0000000000000000000dd000000d0dd000d0dd0000ddd000000d000000000000
-- 217:000000000000000077700000757000007fffffff0ffffff000ffff000000f000
-- 218:000ff000000fff00000fff0000777f0000757f00007770000000000000000000
-- 219:0000100b00001bb000001bb000001111aaaa00000bba00000bba0000b00a0000
-- 224:0230023022300223222322232223222322222223022222300030030000300300
-- 225:0000000002300230223002232223222322222223022222300030030000300300
-- 227:0766667077777777777777777777777777777777777777777777777707666670
-- 228:0000000000000000000550000052230000522300000330000000000000000000
-- </TILES1>

-- <TILES2>
-- 001:dddddddddeeeededdeeeeeddefeeeeeedddfffffdeeff44fdeff444fff4f4444
-- 002:dddddddddedeeeedddeeeeedeeeeeefefffffdddf44ffeedf444ffed4444f4ff
-- 003:ddddddddeeeeeefdeeeeeeedeeeeeeeeffff4fff444f4444444f444444444444
-- 004:ddddedddeeedeeedeeedeeedeeeeeeeeffff4fff4444444f4444444f44444444
-- 005:ddddddddeeeeeffdeeeeeefdeeeeeeefffff4fff444f4f44444f4f4444444444
-- 006:dddddddddfeeeeeedeeeeeeeeeeeeeeefff4dddd4444deee4444deee55444eff
-- 007:fffffff4f4444444f444444444555544ddddffffeeeef444eeeef444fff44455
-- 008:5555555555555555555555555555555555555555555555555555555555555555
-- 009:4444445545555555455555555555555544454444555545555555455555554555
-- 010:4444445545555555455555554555555500004444000045550000455500004555
-- 011:5544444455555554555555545555555444440000555400005554000055540000
-- 012:5555e55555efe55555ff445554eeff4554eff44554eff44555ff445554eeff45
-- 013:8898898892222229522882255292292542222224522992255288882552222225
-- 014:8888888892222229532882255292392552225325523992255353232555553535
-- 015:8898898892222229523882255252292552233235522952555288882552222225
-- 016:dddddddddeeeededdefeeefdeffffffedddedddddeeffeeddeff44edff4f4ff4
-- 017:ff4f4444deff444fdeeff44fdddfffffefeeeeeedeeeeedddeeeededdddddddd
-- 018:4444f4fff444ffedf44ffeedfffffdddeeeeeefeddeeeeeddedeeeeddddddddd
-- 019:44444444444f4444444f4444ffff4fffeeeeeeeeeeeeeeedeeeeeefddddddddd
-- 020:444444444444444f4444444fffff4fffeeeeeeeeeeedeeedeeedeeedddddeddd
-- 021:4444444444f4f44444f4f444fff4fffffeeeeeeedfeeeeeedffeeeeedddddddd
-- 022:4fffffff4444444f4444444f44555544ffffdddd444feeee444feeee55444fff
-- 023:ddddddddeeeeeefdeeeeeeedeeeeeeeedddd4fffeeed4444eeed4444ffe44455
-- 024:5544444444555555455554455555555554444445555545555555455555554555
-- 025:4444555555555555555555555555555555554444555545555555455555555555
-- 026:d555555d5d5555d555ddde555dd5dd5555de4d445d55d5555ddd4555d5554555
-- 027:5544445545555555455555555555555554454555555545555555455555555555
-- 028:54eff44554eff44555ff445554eeff4554eff44554eff44555ff445554eeff45
-- 029:4288882442299225422222255292292542288224532222355532235555533555
-- 030:4288883442299225432332255295593542288224532222355532235555533555
-- 031:5288882453299225522222355292392553235325553555255555553555555555
-- 032:aa0aa0aaa000000a00000000a000000aa000000a00000000a000000aaa0aa0aa
-- 035:444feddd444feefd444feeed4444eeed4fffeeed444feeed444feeed444feeed
-- 036:deeef444deeef444deeef444deeefff4deee4444deeef444dfeef444dddef444
-- 037:ffff4444f4444444f4444444444444444444ffff4444f4444444f44444444444
-- 038:fffffffff4444444f444444444444444fff4ffff4444f4444444f44444444455
-- 039:4444444444444444444444444444444444444444444444444444444444444444
-- 040:fffffffff4444444f4444444444444440000ffff0000f4440000f44400004455
-- 041:4444444445555555554444555440044544000044400000044000000440000004
-- 042:444555445555440f5554000f5540000f4440000f5400000f5400000f5444444f
-- 043:4455544440445555400045554000045540000444400000454000004544444445
-- 044:44444444444444444444444444444444eeeeeeedeeeeeeedeeeeeefddddddddd
-- 045:4ffff4444feeeff5feeaeeeffea2aeef4e8228e45fe88ef555edde5555599555
-- 046:444ffff44ffeeef5feeeaaeffeea2aef4e8228e45fe88ef555edde5555599555
-- 047:04eff44004eff44000ff440004eeff4004eff44004eff44000ff440004eeff40
-- 048:dddddddddd5555e4d5d55e54d55de554d55ef554d5e55f54de5555f4d4444444
-- 049:5235523522355223222322232223222322222223522222355556755555567555
-- 050:5556755555567555522222352222222322232223222322232235522352355235
-- 051:5523235552232235222322232223222322222223522222355556755555567555
-- 052:5556755555567555522222352222222322232223222322235223223555232355
-- 054:66dddd6676eee6667eeeef677eeeff67dfefff44dffff444deee4444ee66ef44
-- 055:66ddddd666eeee677eeeeee7eeeeefffeffffffffffffff444ffff44444ff444
-- 056:6ddddd667feeef76eeee6e56eee66656fff766fd4ff776fd66f7ffee477ffeee
-- 057:400000044ffffff4444444445555555544454444555545555555455555555555
-- 058:5400000f5400000f5400000f5400000f44ffffff554444445555555544555555
-- 059:400000454000004540000045400000454fffff44444444555455555554555555
-- 060:5555455555554555455545554555444445550000455500004555000044440000
-- 061:bbbbbbbbbcccecbcbceeeecdbceeeeeebddfffffbceff44fbcff444fbc4f4444
-- 062:bbbbbbbbccccbcccceeccceceeecceeeffffcfff4444444f4444444f55555444
-- 063:bbbbbbbbcccccccbddeccecbeeeeeecbfffffccbf44ffccbf444ffcb4444f4cb
-- 064:00000000000000000000000000000000000000000000f000000ff000000ff000
-- 065:0230023022300223222322232223222322222223022222300006700000067000
-- 067:0023230002232230222322232223222322222223022222300006700000067000
-- 070:de67ff46def7ff66effff467eeffee77fef4eee7f67eeee7d474fff4d444fff4
-- 071:6eeeee46eeeeee67eeeeef77feeeff74ff66fff4ff77ff444ff7f44444474444
-- 072:4ee4eeeeeef6feefeff7fffffff7fffd66eee66d6eeee67d7feeff7d4fffff4d
-- 073:4444444444444444444444444444444444444444444444444444444444444444
-- 074:444444444444466744eee7644eeee774eeeffeeeeeeffeffefffffff4fff47f4
-- 075:4444000045550000455500004555000045554444455545555555455555554555
-- 076:0006676700667777066677700666677000666767000667670066676700667667
-- 077:bccf4444bcc44444bc444444bc444444bbc4ffffbc44f444bc44f444bc444444
-- 078:bbbbcbcbbccccccbbceeeeccbcceeeeccbcffdcbbceffecbcccfccccbbbcbbbb
-- 079:ffff44cbf4444ccbf4444ccb44444ccb4444ffcb4444f4cb4444fccb44444ccb
-- 080:000ff000000ff0000000f0000000000000000000000000000000000000000000
-- 082:aaaaaa00aaa2aaa9aa222aa9a2a2a2a9aaa2aaa900aaaaa9000890a900089000
-- 083:0aaaaaa00aa2aaa000aa2aaa88aaa2aa99a2a2a200aa222a000aa2aa00099999
-- 084:aaaaaa55aa222aa9a2a2a2a9a22222a9aa2a2aa955aaaaa9555895a955589555
-- 086:d4eeee66d4eeeee6deeeeee7de666ff7deee7ff4deeffff4dfefff44dddddddd
-- 087:44eee4466ee66f676e7f7f47eeff7fe7effffeeffffffeff4f667fffddd66ddd
-- 088:7eee666deeeff66deefff77defffff7deeffff7dfeff4eed4fff4efddddddddd
-- 089:44eee4466ee66f676e7f7f47eeff7fe7effffeeffffffeff4f667fff44464444
-- 090:4ee4eee4eef6feefeff7fffffff7fff466eee6646eeee6747feeff744fffff44
-- 092:0066660000066770006666670006767700667677066677770666777000667770
-- 093:bc4f4444bcff444fbccff44fbcdfffffbcceeeeebcececddbcccccccbbbbbbbb
-- 094:44455555f4444444f4444444fff4ffffeeeeeeeeceecdeecccccdcccbbbbbbbb
-- 095:4444fccbf444cccbf44ffecbfffffdcbeeeeeecbcceeeccbcccccccbbbbbbbbb
-- 096:0000003d0000332d0033222d3322222d0033222d0000332d0000003d0000000d
-- 097:aaaaaa00a22aaaa9aaa2a2a9aaaa22a9aaa222a900aaaaa9000890a900089000
-- 098:aaaaaa00aa2a2aa9aaaaaaa9a2aaa2a9aa222aa900aaaaa9000890a900089000
-- 099:5aaaaaa55aa2aaa5aa2aaa552a2a2a88a222aa99aa2aaa55aaaaa55599999555
-- 100:5aaaaaa55aaa22a555a22a2a88aa222a99a22a2a55aa22aa555aaaaa55599999
-- 102:555a8555555a8555555a8555555a8555555a8555855885589889988959955995
-- 103:55ffff555feeeef44fe2aef45feadef45feedef58ff88ff898899889e995599d
-- 104:55ffff555feeeef44feeaef45fe22ef45feedef58ff88ff89889988959955995
-- 105:55aaa5555aaaaa555aa895555aa8855558a9955a598888aa55999995558aa855
-- 106:555aaa5555aaaaa555598aa555588aa5a5599a85aa88889559999955558aa855
-- 107:0440000050440000504440000554440000504440005504440055504400055504
-- 108:0000550000000550004005550040005504400005440000054400500044055000
-- 109:0004444450044444550444445504455455545444555544440555555500055554
-- 110:0000000000000000000004440004444404444000444400004400000540005005
-- 111:0555550000055550050055505000555555000555500005555000055555550055
-- 112:0000000d0000000d0000000d0000000d0000000d0000000d0000000d0000000d
-- 114:aaaaaa55a2a2aaa9aa2a2aa9aaaaaaa9aaaaaaa955aaaaa9555895a955589555
-- 116:4555555555888555558aaaaa558a9999445a9eee455a9eed455a9ede555a9eee
-- 117:5555554455588855aaaaa8559999a855eee8a554eee8a555eee8a555eee8a555
-- 118:555a8555555a8555555a8555555a8555555a8555555a8555555a8555555a8555
-- 119:de5555de5de55de555ddde55555ee555555bb55555bbbc55555cc55555555555
-- 120:55a9a9555aa9aa95aaa9aaa9aaa9aaa9aaaaaaa95aaaaa955558955555589555
-- 121:558aa855589aa855598999555998888559999995aaaaaaaaa8888889a9999999
-- 122:5555555555555555555555555555555555555555055555550055505000550050
-- 123:0500555505500555005500555055500550055044555055445555554405555554
-- 124:4455050055550050555555005555555555555555405555550000500000050000
-- 125:0000444400004444400044444440554444454444445544450554454555455455
-- 126:4450055545500455450044455544440555444000544400005455000055440004
-- 127:4000000550000000505000555505055055005000055555540555550555440555
-- 128:0000009d000099ad0099aaad99aaaaad0099aaad000099ad0000009d0000000d
-- 132:555a9eee555a9eee555a9eee555a9eee558a9888458aaaaa4588855555555555
-- 133:eee8a445ede8a555dee8a555eee8a5558888a844aaaaa8555558885555555555
-- 134:eeee5eeeefff5effefff5effffff5fff54444445545555555455555554555555
-- 135:eeee5eeeffff5effffff5effffff5fff44444444455555554555555555555555
-- 136:eee5eeeeffe5fffeffe5fffefff5ffff54444445555555455555554555555545
-- 137:0000055500055550005555005555500055550000555000005550000055000000
-- 138:5000000055000000555000005555000055555500055555550005555000000000
-- 139:0055555500055555000055550000005500000055000000050000000000000000
-- 140:0000000050004000550440005504400055544405555554555555555555555555
-- 141:5044445550044555000055550005555500055554005555445555544555550555
-- 142:5440044455554444555555405555555044445555444440554445405554540005
-- 143:5440500540050000000000000000050000005000054555505455505540550005
-- 144:0000000d0000000d0000000d0000000d0000000d0000000d0000000d0000000d
-- 145:0000000000000000000000000000000000000000c6c6cc6c4c4c4c4c44444444
-- 146:000000000000000000000000000000000000000000000000060606060c0c0cc0
-- 147:ee445555eff5555504445e45eee55f54ef445f554ff554554455544504445555
-- 148:00000eee0eeefef40eff4f440f44555500444555eef54545ef455545f4455545
-- 149:55554eee555444fe555554fe5ff5554f55455e00554544e055544fe05555ffe0
-- 150:00aaaaaa0aaa99aaaaa9999aaaa9999aaaaa99aaaaaaaaaa8aaaaaaa08888888
-- 151:aaaaaaaaaaaaaaaaaaa99aaaaa9999aaaa9999aaaaa99aaaaaaaaaaa88888888
-- 152:aaaaaa00aa99aaa0a9999aaaa9999aaaaa99aaaaaaaaaaaaaaaaaaa888888880
-- 153:098aa890098aa890098aa890098aa890098aa890098aa890098aa890098aa890
-- 154:0000444455044444555444445554444055544400555540005555550055555555
-- 155:0000000000000000040000040440000400440044000440440004444400004444
-- 156:0555555544555555444455554400005540000005400000000000000000000000
-- 157:5555554455444444550444445555544555504545550044445000444450004444
-- 158:4555554555400040554404405544444054444405554444054554405544554555
-- 159:0550000005505004550055445500055455004455500444055004400004444500
-- 160:55bbbb555bbccbc5bbcbbbbcbcbbbbbcbcbbbbbcbbbbbbbc5bbbbbc555cccc55
-- 161:eeef0000eff40eeee445e4ff4455544f545555455555555555ff555555545555
-- 162:eee00000ffffeee0444fefe045444ff0555544f054455540554544ee55554f4e
-- 163:e4f45555ee445455045554450f4455550ff444540efef44400eeffff00000eee
-- 164:55ff555555f555455544444555555555454545544f4e4f54ef4eff44ee0ee440
-- 165:5455544f545554fe54545fee5554444055544f0044fffe004fefee00eee00000
-- 166:006666660666dd66666dddd6666dddd66666dd66666666667666776607770077
-- 167:6666666666666666666dd66666dddd6666dddd66666dd6667666666707777770
-- 168:6666660066dd66606dddd6666dddd66666dd6666666666666667766777700770
-- 170:4000000544000055044055550455555500555555005555550555555555555555
-- 171:0004444000444400004440000444400004440000444450004445550555555555
-- 172:0005555500555555005555550555550055555000555500005555000055550000
-- 173:0004444400444444044444544544445445544555445455554555555555555555
-- 174:4455555044455500445555004455500445554055555545555554555555555555
-- 175:4444550044455500445554004455440045554440555554445555554455555555
-- 176:222222222333333523d33d35233dd335233dd33523d33d352333333525555555
-- 177:2222222223333335233dd33523d33d3523d33d35233dd3352333333525555555
-- 178:0eeeeee0effffff5efeffef5effeeff5effeeff5efeffef5effffff505555550
-- 179:0e0ee0e0e000000e00e00e00e00ee00ee00ee00e00e00e00e000000e0e0ee0e0
-- 180:0777777076666667766dd66776d66d6776d66d67766dd6677666666707777770
-- 181:0606606060000006000660006060060660600606000660006000000606066060
-- 182:eeeeeeeeffffffff66222266000880000008100000a1aa00ffffffffeeeeeeee
-- 183:eeeeeeeeffffeeffff66feff6666ffff66006f66600006000000000000000000
-- 184:033333303b3333b3333bb33333bbbb3333bbbb33333bb3333b3333b303333330
-- 185:eeeeeeeeefeeeefef6eeee6f6eeeeee6efeeeefee6eeee6eeeeeeeeeeeeeeeee
-- 186:77777777799d9997791d9d977d111d177111111779111d97799dd99777777777
-- 188:0000000000000000000d00000000d0000000d000000d00000000000000000000
-- 189:00000000000000000000d000000d0000000d00000000d0000000000000000000
-- 190:00000000000000000000000000d00d00000dd000000000000000000000000000
-- 191:000000000000000000000000000dd00000d00d00000000000000000000000000
-- 192:0cccccd0cccccccdccdcdccdccdcdccdcccccccd0cccccd000d00d0000d00d00
-- 193:00bbb0000b0000b00000000bb000000bb000000bb00000000b0000b0000bbb00
-- 194:0005e000005ffe0005ffffe05ff5effefffeeffc0fffffc000fffc00000fc000
-- 195:0666666066777766677667766777767667777676677777766677776606666660
-- 196:0000000000444d00044444d004d4d4d004d4d4d0044444d000444d0000000000
-- 197:4444444444444888444488884444888844448888044488880044488800044444
-- 198:0000000000000000000ee00000edde0000edde00000ee0000000000000000000
-- 199:0000000000000000000dd00000deed0000deed00000dd0000000000000000000
-- 200:0ffffff0ff7eeefff77e77eff77ee7effe7ee77ffe77e77fffeee7ff0ffffff0
-- 201:000b0000000bb00000bbb00004555550455555554555b5b54555b5b545555555
-- 202:0999998099999998999999989995959899959598999999989999999808888880
-- 208:0eeeeef0eeeeeeefeebebeefeebebeefeeeeeeef0eeeeef000f00f0000f00f00
-- 209:000000000ddddd0ddceceededceceeeedeeeeefe0fffff0f0000000000000000
-- 210:00eeeee0e0000000e000000ee0eeee0ee0eeee0ee00ee00e0000000e0eeeee00
-- 211:0777777077777777677777766777777667777776677777767777777707777770
-- 212:00000000000000000eeeeee0eeefefffeeeeff00eefeffff5feffff505555550
-- 213:0aaaaaaaa8888888a8999998a8888889a8899899a8988988a899899808888888
-- 215:0000000000000000000ee00000edde0000edde00000ee0000000000000000000
-- 216:0666666066666666666666666666666666666666666666666666666606666660
-- 217:000000000000000077700000757000007fffffff0ffffff000ffff000000f000
-- 218:000ff000000fff00000fff0000777f0000757f00007770000000000000000000
-- 219:0000100b00001bb000001bb000001111aaaa00000bba00000bba0000b00a0000
-- 224:0230023022300223222322232223222322222223022222300030030000300300
-- 225:0000000002300230223002232223222322222223022222300030030000300300
-- 227:0766667077777777777777777777777777777777777777777777777707666670
-- 228:0000000000000000000550000052230000522300000330000000000000000000
-- </TILES2>

-- <TILES3>
-- 001:66cccc6676ddd6667dddde677dddee67cedeeeffceeeefffcdddffffdd66eeff
-- 002:66ccccc666dddd677dddddd7dddddeeedeeeeeeeeeeeeeefffeeeefffffeefff
-- 003:6ccccc667eddde76dddd6e56ddd66656eee766ecfee776ec66e7eeddf77eeddd
-- 004:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 005:fffffffffffff667ffddd76ffdddd77fdddeeddddddeedeedeeeeeeefeeef7ef
-- 007:888888888999999989bbbb9989baa99989baa9bb89b999ba89999999899bbbb9
-- 008:888888889999999a99bbbb9a999baa9abb9baa9aaa999b9a9999999a9bbbb99a
-- 009:0000000000000000000000000000000000000055000005675507567076576700
-- 010:0000000000000000000000000000000000000005000005575007566075576700
-- 011:0000000000000000000000000000000000000000000005550007566655576770
-- 014:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 015:aaaaaabbabbbbbbbabbbbbbbbbbbbbbbaaabaaaabbbbabbbbbbbabbbbbbbabbb
-- 016:cccccccccddddddccddeeddccdeefedccdeffedccdeeeedccddddddccccccccc
-- 017:cd67eef6cde7ee66deeeef67ddeedd77fdefddd7f67dddd7cf7feeefcfffeeef
-- 018:6dddddf6dddddd67ddddde77edddee7fee66eeefee77eefffee7effffff7ffff
-- 019:fddfdddddde6eddedee7eeeeeee7eeec66ddd66c6dddd67c7eddee7cfeeeeefc
-- 020:ffdddff66dd66e676d7e7ef7ddee7ed7deeeeddeeeeeedeefe667eeefff6ffff
-- 021:fddfdddfdde6eddedee7eeeeeee7eeef66ddd66f6dddd67f7eddee7ffeeeeeff
-- 023:899baaa98999999989b999bb89bbb9ba89baa99989baab99899999998aaaaaaa
-- 024:9baaa99a9999999abb999b9aaa9bba9a999baa9a99baaa9a9999999aaaaaaaaa
-- 025:0765705500767567550756707657670007657055007675675507567076576700
-- 026:0665700500767557500756607557670006657005007675575007566075576700
-- 027:6665700007767555000756665557677066657000077675550007566655576770
-- 030:bbaaaaaaaabbbbbbabbbbaabbbbbbbbbbaaaaaabbbbbabbbbbbbabbbbbbbabbb
-- 031:aaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbaaaabbbbabbbbbbbabbbbbbbbbbb
-- 032:aa0aa0aaa000000a00000000a000000aa000000a00000000a000000aaa0aa0aa
-- 033:cfdddd66cfddddd6cdddddd7cd666ee7cddd7eefcddeeeefcfdeeeffcccccccc
-- 034:ffdddff66dd66e676d7e7ef7ddee7ed7deeeeddeeeeeedeefe667eeeccc66ccc
-- 035:7ddd666cdddee66cddeee77cdeeeee7cddeeee7cedeefddcfeeefdeccccccccc
-- 038:fffffffffffffafffffffaafffffaffffffafffffaafffffffafffffffffffff
-- 039:888888888999999a8999999a8999999a8999999a8999999a8999999aaaaaaaaa
-- 040:8888888889999aba899aab9a89abb99a8ab9999a8ab9999a8b99999aaaaaaaaa
-- 041:888888888999999a89bbbb9a89ba999a89babb9a89ba9b9a8999999aaaaaaaaa
-- 048:cccccccccc0000dfc0c00d0fc00cd00fc00de00fc0d00e0fcd0000efcfffffff
-- 049:0230023022300223222322232223222322222223022222300005600000056000
-- 050:0005600000056000022222302222222322232223222322232230022302300230
-- 051:0023230002232230222322232223222322222223022222300005600000056000
-- 052:0005600000056000022222302222222322232223222322230223223000232300
-- 053:ffffffffffffffffffaaafffffafffffffaaafffffafafffffffffffffffffff
-- 055:888888888999999a89bbbb9a89baaa9a89baaa9a89baaa9a8999999aaaaaaaaa
-- 056:555555578666779a8977999a8999999a8999999a8999999a8999999aaaaaaaaa
-- 064:0000000000000000000000000000000000050000000650000007600000077000
-- 071:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9bbbbbba9abbbb9999abb9aaa9a9b
-- 072:bbbb8bbbbb898bbbbb99aabbba8899abba899aabba899aabbb99aabbba8899ab
-- 073:88888888899999998998a9988998a9888998a98b8998a98b8998a98889999998
-- 074:888888889999999a8a998a9a88a98a9ab8a98a9aa8a98a9a88a98a9a8a99999a
-- 082:999999009998999a9988899a9898989a9998999a0099999a000ab09a000ab000
-- 083:099999900998999000998999aa999899bb9898980099888900099899000aaaaa
-- 084:999999bb9988899a9898989a9888889a9989899abb99999abbb9ab9abbb9abbb
-- 085:8888888889999999899999998999999989999999899999998999999989999999
-- 086:8888888899999999999999999999999999999999999999999999999999999999
-- 087:888888889999999a9999999a9999999a9999999a9999999a9999999a9999999a
-- 088:ba899aabba899aabbb99aabbba8899abba899aabba899aabbb99aabbba8899ab
-- 089:8999888889998888899988a8899988a8899988a889998a98899999988aaaaaaa
-- 090:8888a99a8888a99a8a88a99a8a88a99a8a88a99a8a98a99a8a99999aaaaaaaaa
-- 091:bb888bbbb88888bbb88abbbbb88aabbbb8899bbab98888aabb99999bbb8aa8bb
-- 092:bbb888bbbb88888bbbbba88bbbbaa88babb9988baa88889bb99999bbbb8aa8bb
-- 096:00000091000099a10099aaa199aaaaa100bbaaa10000bba1000000b100000001
-- 097:999999009889999a9998989a9999889a9998889a0099999a000ab09a000ab000
-- 098:999999009989899a9999999a9899989a9988899a0099999a000ab09a000ab000
-- 099:099999900998999099899900898989bb988899aa9989990099999000aaaaa000
-- 100:099999900999889000988989bb998889aa9889890099889900099999000aaaaa
-- 101:8999999989999999899999998999999989999999899999998999999989999999
-- 102:9999999999999999999999999999999999999999999999999999999999999999
-- 103:9999999a9999999a9999999a9999999a9999999a9999999a9999999a9999999a
-- 105:88888888899999998999999989999999899999998999999989999999bbbbbbbb
-- 106:888888889999999b9999999b9999999b9999999b9999999b9999999bbbbbbbbb
-- 107:bb8aa8bbb89aa8bbb98999bbb998888bb999999baaaaaaaaa8888889a9999999
-- 112:0000000100000001000000010000000100000001000000010000000100000001
-- 114:999999009898999a9989899a9999999a9999999a0099999a000ab09a000ab000
-- 117:899999998999999989999999899999998999999989999999899999998aaaaaaa
-- 118:99999999999999999999999999999999999999999999999999999999aaaaaaaa
-- 119:9999999a9999999a9999999a9999999a9999999a9999999a9999999aaaaaaaaa
-- 123:000009990999a9ab09aababb0abbbbbb00bbbbbb99abbbbb9abbbbbbabbbbbbb
-- 124:999a00009aab09999bbb9baabbbbbbbabbbbbbbbbbbbbbbbbbaabbbbbbbbbbbb
-- 125:99900000aaaa9990bbba9a90bbbbbaa0bbbbbba0bbbbbbb0bbbbbb99bbbbbbb9
-- 126:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9bbbbbb98
-- 127:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb9bbbbbbb89bbbbbb
-- 128:0000005100005561005566615566666100776661000077610000007100000001
-- 134:8888a8888999a8998999a8999999a999baaaaaabbabbbbbbbabbbbbbbabbbbbb
-- 135:8888a8889999a8999999a8999999a999aaaaaaaaabbbbbbbabbbbbbbbbbbbbbb
-- 136:888a8888998a9998998a9998999a9999baaaaaabbbbbbbabbbbbbbabbbbbbbab
-- 139:99bbbbbb9aabbbbb0bbbb9bb999bbabb9abbbabbbaabbbbbbbbbbbbb0bbbbbbb
-- 140:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 141:bbbbb999bbbbbba9bbbbbba9baabbbbabbbbb900bbbbbb90bbbbba90bbbbaa90
-- 142:bbbbbb98bbbbbbb9bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 143:89bbbbbb9bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 144:0000000100000001000000010000000100000001000000010000000100000001
-- 145:0000000000000000000000000000000000000000c6c6cc6c4c4c4c4c44444444
-- 155:9bbbbbbb99bbbbbb0bbbbbbb0abbbbbb0aabbbbb09a9abbb0099aaaa00000999
-- 156:bbaabbbbbbabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbab9babb9ab9aabb99099bb0
-- 157:bbbbbbbabbbbbba9bbbbba99bbbbbbb0bbbbb900bbaaa900ba9a990099900000
-- 160:bb6666bbb665567b66566667656666676566666766666667b666667bbb7777bb
-- 176:888888888999999a8919919a8991199a8991199a8919919a8999999a8aaaaaaa
-- 177:888888888999999a8991199a8919919a8919919a8991199a8999999a8aaaaaaa
-- 178:0cccccc0cddddddecd1dd1decdd11ddecdd11ddecd1dd1decdddddde0eeeeee0
-- 179:0e0ee0e0e000000e00e00e00e00ee00ee00ee00e00e00e00e000000e0e0ee0e0
-- 180:0555555056666667566116675616616756166167566116675666666707777770
-- 181:0707707070000007000770007070070770700707000770007000000707077070
-- 182:eeeeeeeeffffffff66222266000880000008100000a1aa00ffffffffeeeeeeee
-- 183:eeeeeeeeffffeeffff66feff6666ffff66006f66600006000000000000000000
-- 184:033333303b3333b3333bb33333bbbb3333bbbb33333bb3333b3333b303333330
-- 185:eeeeeeeeefeeeefef6eeee6f6eeeeee6efeeeefee6eeee6eeeeeeeeeeeeeeeee
-- 186:77777777799d9997791d9d977d111d177111111779111d97799dd99777777777
-- 188:0000000000000000000100000000100000001000000100000000000000000000
-- 189:0000000000000000000010000001000000010000000010000000000000000000
-- 190:0000000000000000000000000010010000011000000000000000000000000000
-- 191:0000000000000000000000000001100000100100000000000000000000000000
-- 192:0cccccd0cccccccdccdcdccdccdcdccdcccccccd0cccccd000d00d0000d00d00
-- 193:00bbb0000b0000b00000000bb000000bb000000bb00000000b0000b0000bbb00
-- 194:0005e000005ffe0005ffffe05ff5effefffeeffc0fffffc000fffc00000fc000
-- 195:0666666066777766677667766777767667777676677777766677776606666660
-- 196:0000000000444d00044444d004d4d4d004d4d4d0044444d000444d0000000000
-- 197:4444444444444888444488884444888844448888044488880044488800044444
-- 198:0000000000000000000ee00000edde0000edde00000ee0000000000000000000
-- 199:0000000000000000000dd00000deed0000deed00000dd0000000000000000000
-- 200:0ffffff0ff7eeefff77e77eff77ee7effe7ee77ffe77e77fffeee7ff0ffffff0
-- 201:0005000000055000005550000322222032222222322252523222525232222222
-- 202:0999998099999998999999989995959899959598999999989999999808888880
-- 208:0bbbbbc0bbbbbbbcbbcbcbbcbbcbcbbcbbbbbbbc0bbbbbc000c00c0000c00c00
-- 209:000000000ddddd0ddceceededceceeeedeeeeefe0fffff0f0000000000000000
-- 210:00eeeee0e0000000e000000ee0eeee0ee0eeee0ee00ee00e0000000e0eeeee00
-- 211:0777777077777777677777766777777667777776677777767777777707777770
-- 212:00000000000000000eeeeee0eeefefffeeeeff00eefeffff5feffff505555550
-- 213:0077777707777777777777777777777777777777777777776777777706666666
-- 215:0000000000000000000ee00000edde0000edde00000ee0000000000000000000
-- 216:0000000000000000000dd000000d0dd000d0dd0000ddd000000d000000000000
-- 217:000000000000000077700000757000007fffffff0ffffff000ffff000000f000
-- 218:000ff000000fff00000fff0000777f0000757f00007770000000000000000000
-- 219:0000100b00001bb000001bb000001111aaaa00000bba00000bba0000b00a0000
-- 224:0230023022300223222322232223222322222223022222300030030000300300
-- 225:0000000002300230223002232223222322222223022222300030030000300300
-- 227:0766667077777777777777777777777777777777777777777777777707666670
-- 228:0000000000000000000550000052230000522300000330000000000000000000
-- </TILES3>

-- <TILES4>
-- 001:66cccc6676ddd6667dddde677dddee67cedeeeffceeeefffcdddffffdd66deff
-- 002:66ccccc666dddd677dddddd7dddddeeedeeeeeeeeeeeeeefffeeeefffffeefff
-- 003:6ccccc667eddde76dddd6d56ddd66656eee766ecfee776ec66e7eedcf77eeddc
-- 004:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 005:fffffffffffff667ffddd76ffdddd77fdddeeddddddeedeedeeeeeeefeeef7ef
-- 009:222222aa2aaaaaaa2aaaaaaa2aaaaaaa0000222200002aaa00002aaa00002aaa
-- 010:aa222222aaaaaaa2aaaaaaa2aaaaaaa222220000aaa20000aaa20000aaa20000
-- 011:0000000000555500056676511566765005676650056766500566765105667650
-- 012:0100100055555555666666666677667777667766666616665155555500100000
-- 013:0000100055555500666666506677665077667750666666505555550001000100
-- 014:0000100000555555055666660566667705667766156676660567666505676650
-- 015:0010000055555500666665507766665066776651666766505666765005667650
-- 016:cccccccccddddddccdeeeedccdeffedccdeffedccdeeeedccddddddccccccccc
-- 017:cd67eef6cde7ee66deeeef67ddeedd77edefddd7e67dddd7cf7feeefcfffeeef
-- 018:6dddddf6dddddd67ddddde77edddee7fee66eeefee77eefffee7effffff7ffff
-- 019:fddfdddddde6eddedee7eeeeeee7eeec66ddd66c6dddd67c7eddee7cfeeeeefc
-- 020:ffdddff66dd66e676d7e7ef7ddee7ed7deeeeddeeeeeedeefe667eeefff6ffff
-- 021:fddfdddfdde6eddedee7eeeeeee7eeef66ddd66f6dddd67f7eddee7ffeeeeeff
-- 025:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 026:222222aa2aaaaaaa2aaaaaaaaaaaaaaa222a2222aaaa2aaaaaaa2aaaaaaa2aaa
-- 027:0567665005676650056676501566715005676650056766511566761005667650
-- 028:0566765005667651056766500567665015667650056676510055550000000000
-- 029:0000100055555500666666506677665077667750666666505555550001000100
-- 030:0567665005676665056676661566776605666677055666660055555500000100
-- 031:0566765056667650666766516677665077666650666665505555550000010000
-- 032:aa0aa0aaa000000a00000000a000000aa000000a00000000a000000aaa0aa0aa
-- 033:cfdddd66cfddddd6cdddddd7cd666ee7cddd7eefcddeeeefcedeeeffcccccccc
-- 034:ffdddff66dd66e676d7e7ef7ddee7ed7deeeeddeeeeeedeefe667eeeccc66ccc
-- 035:7ddd666cdddee66cddeee77cdeeeee7cddeeee7cedeefddcfeeefdeccccccccc
-- 038:fffffffffffff1fffffff11fffff1ffffff1fffff11fffffff1fffffffffffff
-- 041:aa22222222aaaaaa2aaaa22aaaaaaaaaa222222aaaaa2aaaaaaa2aaaaaaa2aaa
-- 042:2222aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa2222aaaa2aaaaaaa2aaaaaaaaaaa
-- 043:0566765005667655056766660517677705667766156676660167665105676650
-- 044:0567665055676650666676507776715066776650666766511566761005667650
-- 045:0000010055555515666166666677667777667766666776665567665505676610
-- 046:0166765055667655666776666677667777667766666616665155555500100000
-- 048:ccccccccccffffdecfcffdfecffcdffecffdeffecfdffefecdffffeeeeeeeeee
-- 049:f89ff89f889ff889888988898889888988888889f888889ffff67ffffff67fff
-- 050:fff67ffffff67ffff888889f888888898889888988898889889ff889f89ff89f
-- 051:ff8989fff889889f888988898889888988888889f888889ffff67ffffff67fff
-- 052:fff67ffffff67ffff888889f888888898889888988898889f889889fff8989ff
-- 053:ffffffffffffffffff111fffff1fffffff111fffff1f1fffffffffffffffffff
-- 060:088888908899999901b3341001bb441001b4431001444b100143bb1001333b10
-- 061:0888889088999999013444100144bb100143bb1001b3331001bb331001bbb410
-- 064:000000000000000000000000000000000000e000000ef000000f600000066000
-- 065:0890089088900889888988898889888988888889088888900006700000067000
-- 066:000090000008900000988900098888009888c889988ccc8998cc1c8909811890
-- 067:0089890008898890888988898889888988888889088888900006700000067000
-- 068:00090000000980000098890000888890988c888998ccc88998c1cc8909811890
-- 069:ffffffffff1111fff111111ff1ffff1ff111111fff1ff1ffff1ff1ffffffffff
-- 076:01b3331001bb341001b4441001344b100144bb1001433b108888889988999999
-- 077:01bb441001b444100144bb10014bbb100133bb1001333b108888889988999999
-- 080:00066000000f6000000ef0000000e00000000000000000000000000000000000
-- 082:cccccc00ccc1cccdcc111ccdc1c1c1cdccc1cccd00cccccd000de0cd000de000
-- 083:0cccccc00cc1ccc000cc1ccceeccc1cceec1c1c100cc111c000cc1cc000ddddd
-- 084:ccccccffcc111ccdc1c1c1cdc11111cdcc1c1ccdffcccccdfffdefcdfffdefff
-- 087:00000ccc0cccdcde0cddedee0deeffff00eeefffccdfefefcdefffefdeefffef
-- 088:cccd0000cdde0cccceefdeddeefffeedfeffffefffffffffffddfffffffeffff
-- 089:ccc00000ddddccc0eeedcdc0efeeedd0ffffeed0feefffe0ffefeeccffffedec
-- 090:fffffffffffffffffffffffffffffffffffffffffffffffffffffffeffffffec
-- 091:ffffffffffffffffffffffffffffffffffffffffffffffffefffffffceffffff
-- 092:0dddddddddd00dddd0dddd00d00dd000d00de000d0ddee00ddd00eeedd0000ee
-- 093:dddddddddd0000dd0dd00dd000dddd0000eeee000ee00ee0ee0000eeeeeeeeee
-- 094:dd0000eeddd00eeed0ddee0ed00de00ed00de00ed0ddee0eddd00eeedd0000ee
-- 095:ddddddd0dd0000dd0dd00ddd00dddd0d00eedd0d0ee00dddee0000ddee0000dd
-- 096:0000004100004431004433314433333100bb33310000bb31000000b100000001
-- 097:cccccc00c11ccccdccc1c1cdcccc11cdccc111cd00cccccd000de0cd000de000
-- 098:cccccc00cc1c1ccdcccccccdc1ccc1cdcc111ccd00cccccd000de0cd000de000
-- 099:0cccccc00cc1ccc0cc1ccc001c1c1cddc111cceecc1ccc00ccccc000ddddd000
-- 100:0cccccc00ccc11c000c11c1cddcc111ceec11c1c00cc11cc000ccccc000ddddd
-- 103:cceeffffcddfffff0eeefcefcccffdfecdeefdffeddffeffeefffeef0eeeffff
-- 104:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 105:ffffecccfffeeedcfffffedcfddfffedffeffd00ffefeec0fffeedc0ffffddc0
-- 106:ffffffecfffffffeffffffffffffffffffffffffffffffffffffffffffffffff
-- 107:ceffffffefffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 111:ddddeeeeddd00eeed0ddee0ed00de00ee00ee00ee0eeee0eeee00eeeeeeeeeee
-- 112:0000000100000001000000010000000100000001000000010000000100000001
-- 114:cccccc00c1c1cccdcc1c1ccdcccccccdcccccccd00cccccd000de0cd000de000
-- 119:cedeffffcceefeff0efffeef0deeffff0ddeeefe0cdcdeee00ccdddd00000ccc
-- 120:ffddffffffdfffefffeeeeefffffffffefefeffeedecedfecdecddeecc0ccee0
-- 121:fefffeedfefffedcfefefdccfffeeee0fffeed00eedddc00edcdcc00ccc00000
-- 122:0ccdecc0cddefeddceeffeedeeffffeffeffffffffffffffffffffffffffffff
-- 128:0000005100005561005566615566666100776661000077610000007100000001
-- 134:ccccfccccdddfcddcdddfcddddddfddda222222aa2aaaaaaa2aaaaaaa2aaaaaa
-- 135:ccccfcccddddfcddddddfcddddddfddd222222222aaaaaaa2aaaaaaaaaaaaaaa
-- 136:cccfccccddcfdddcddcfdddcdddfdddda222222aaaaaaa2aaaaaaa2aaaaaaa2a
-- 144:0000000100000001000000010000000100000001000000010000000100000001
-- 145:0000000000000000000000000000000000000000c6c6cc6c4c4c4c4c44444444
-- 146:000000000000000000000000000000000000000000000000060606060c0c0cc0
-- 159:defffeeddefffeeddefffeeddeffffeddeefffeddeefffeddeefffeddeefffed
-- 160:ff6666fff665567f66566667656666676566666766666667f666667fff7777ff
-- 175:0000c000000c0000c00ddd000cd000e000c000000ccd0e0000dee00000de0000
-- 176:888888888999999f8919919f8991199f8991199f8919919f8999999f8fffffff
-- 177:888888888999999f8991199f8919919f8919919f8991199f8999999f8fffffff
-- 178:0555555056666667561661675661166756611667561661675666666707777770
-- 179:0606606060000006006006006006600660066006006006006000000606066060
-- 180:044444404333333b4331133b4313313b4313313b4331133b4333333b0bbbbbb0
-- 181:0303303030000003000330003030030330300303000330003000000303033030
-- 182:eeeeeeeeffffffff66222266000880000008100000a1aa00ffffffffeeeeeeee
-- 183:ccccccccddddccddddeedcddeeeeddddee00edeee0000e000000000000000000
-- 184:4444444433433433bb33b43bdbbbb3bedebebbeeeeeebeefffeeeefffffeefff
-- 185:eeeeeeeeefeeeefef6eeee6f6eeeeee6efeeeefee6eeee6eeeeeeeeeeeeeeeee
-- 186:77777777799d9997791d9d977d111d177111111779111d97799dd99777777777
-- 188:0000000000000000000100000000100000001000000100000000000000000000
-- 189:0000000000000000000010000001000000010000000010000000000000000000
-- 190:0000000000000000000000000010010000011000000000000000000000000000
-- 191:0000000000000000000000000001100000100100000000000000000000000000
-- 192:0aaaaac0aaaaaaacaa4a4aacaa4a4aacaaaaaaac0aaaaac000c00c0000c00c00
-- 193:0055500005000050000000055000000550000005500000000500005000055500
-- 194:0005e000005ffe0005ffffe05ff5effefffeeffc0fffffc000fffc00000fc000
-- 195:0666666066777766677667766777767667777676677777766677776606666660
-- 196:0000000000444d00044444d004d4d4d004d4d4d0044444d000444d0000000000
-- 197:4444444444444888444488884444888844448888044488880044488800044444
-- 198:0000000000000000000ee00000edde0000edde00000ee0000000000000000000
-- 199:0000000000000000000880000082280000822800000880000000000000000000
-- 200:0ffffff0ff7eeefff77e77eff77ee7effe7ee77ffe77e77fffeee7ff0ffffff0
-- 201:0005000000055000005550000322222032222222322252523222525232222222
-- 202:0999998099999998999999989995959899959598999999989999999808888880
-- 208:0eeeeef0eeeeeeefee4e4eefee4e4eefeeeeeeef0eeeeef000f00f0000f00f00
-- 209:000000000ddddd0ddceceededceceeeedeeeeefe0fffff0f0000000000000000
-- 210:00eeeee0e0000000e000000ee0eeee0ee0eeee0ee00ee00e0000000e0eeeee00
-- 211:7777777767777776677777766777777667777776677777767777777707777770
-- 212:00000000000000000eeeeee0eeefefffeeeeffffeefeffff5feffff505555550
-- 213:0ccccccccdddddddcdeeeeedcddddddecddeedeecdeddeddcdeedeed0ddddddd
-- 214:cccccccccddddeeeceeeeeeede22eeff02ffaeef02ffaeef00aa00ff00000000
-- 215:00000000000000000bb88000bb822800bb8228000bb880000000000000000000
-- 216:0000000000000000000dd000000d0dd000d0dd0000ddd000000d000000000000
-- 217:000000000000000077700000757000007fffffff0ffffff000ffff000000f000
-- 218:000ff000000fff00000fff0000777f0000757f00007770000000000000000000
-- 219:0000100b00001bb000001bb000001111aaaa00000bba00000bba0000b00a0000
-- 220:00bbbbbb0bb66666bb667776b6677666b6776666b6766666b6766667b6666677
-- 224:0230023022300223222322232223222322222223022222300030030000300300
-- 225:0000000002300230223002232223222322222223022222300030030000300300
-- 228:0000000000000000000550000052230000522300000330000000000000000000
-- 230:cccccccccddddeeeceeeeeeedeaaeef02a22aee02a02aee02002a0f00002a000
-- 255:ccccccccceddddd6ceedddd70feeeedd00fffeed00000fee000000ff00000000
-- </TILES4>

-- <TILES5>
-- 001:cccdcccdcddecddecddecddecddeeeeecddeffffdeeeffffccceffffcddeffff
-- 002:cccccccdcddddddecddddddeeeeeeeeeffffffffffffffffffffffff44444444
-- 003:ccccdccccdddeddccdddeddceeeeeddcffffeddcffffeeedffffecccffffeddc
-- 004:4444444444ffffff4fffffff4fffffff4fffeeee4fffedde4fffedde4fffedde
-- 005:44444444ffffff44fffffff4fffffff4eeeefff4eddefff4eddefff4eddefff4
-- 006:4444444444444444444444444444444444444444444444444444444444444444
-- 007:ffffff44f4444444f444444444444444fff4ffff4444f4444444f4444444f444
-- 012:00000a0000000aa00aa0aaaa0aaaaaaa00aaaabb0abbbbbb0aaaabbb00bbbbbb
-- 013:0000000000000aa00aa0aaaaaaaaaaaaaaabbbbbbaaaabbbaaabbbbbbbbbbbbb
-- 014:00a000000aa00000aaaa0aa0aaaaaaa0bbaaaa00bbbbbba0bbbaaaa0bbbbbb00
-- 016:ccdccdcccdeddedcdeeeeeedcdeffedccdef4edcdeeeeeedcdeddedcccdccdcc
-- 017:cddefff4cddefff4eeeefff4cccefff4cddefff4cddefff4cddefff4cddefff4
-- 018:4444444444444444444444444444444444444444444444444444444444444444
-- 019:4fffeddc4fffeddc4fffeeed4fffeccc4fffeddc4fffeddc4fffeddc4fffeddc
-- 020:4fffedde4fffedde4fffedde4fffeeee4fffffff4fffffff44ffffff44444444
-- 021:eddefff4eddefff4eddefff4eeeefff4fffffff4fffffff4ffffff4444444444
-- 023:ffff44444444444444444444444444444444ffff4444f4444444f44444444444
-- 024:0555555505ffffff05f4444405444444055555555ffff5ff5f4445f454444544
-- 025:55555555fffff5ff444445f44444454455555555ff5fffff445f444444544444
-- 026:55555550ffffff50444444504444445055555550f5fffff545f4444545444445
-- 032:ee0ee0eee000000e00000000e000000ee000000e00000000e000000eee0ee0ee
-- 033:cddeffffccceffffdeeeffffcddeffffcddeeeeecddecddecddecddecccdcccd
-- 034:44444444ffffffffffffffffffffffffeeeeeeeecddddddecddddddecccccccd
-- 035:ffffeddcffffecccffffeeedffffeddceeeeeddccdddeddccdddeddcccccdccc
-- 040:55555555fff5ffff4445f4444445f6665555fffffff5f4444445f6664445f666
-- 041:55555555ffff5fff444f5f44666f5444ffff5555444f5fff666f5f44666f5444
-- 048:cccccccccc0000dfc0c00d0fc00cd00fc00de00fc0d00e0fcd0000efcfffffff
-- 049:000000000c0c0c0ccdcdcdcddedededeefefefefffffffffffffffffffffffff
-- 050:ffffffffffffffffffffffffefefefefdedededecdcdcdcd0c0c0c0c00000000
-- 052:cccccccdcef444edc4ef4efdc44eef4dc4fee44dcfe4fe4dce444feddddddddd
-- 053:cccccccdc44ef44dc44ef44dcffeeeedceeeeffdc44fe44dc44fe44ddddddddd
-- 056:5555fffffff5f4444445f6664445ffff55555555fff5ffff4445f44444454444
-- 057:ffff5555444f5fff666f5f44ffff544455555555ffff5fff44445f4444445444
-- 072:55555555fff51ccc4445cddd4445cddd5555cd66fff5cd664445cddd4445cddd
-- 073:55555555cccd5fffddde5f44ddde544466de555566de5fffddde5f44ddde5444
-- 075:0777077707000707070707070007070007770700000000000777777700000000
-- 076:0777077707070700070707770700070707700707000000007777777700000000
-- 077:0777077700000700007007070070000700700777000000007777777700000000
-- 082:dddddddeddd1dddedd111dded1d1d1deddd1dddeddddddde000ef000000ef000
-- 083:00dddddd00d1dddd00dd1dddeeddd1ddffd1d1d100dd111d00ddd1dd00eeeeee
-- 084:dddddddddd111dded1d1d1ded11111dedd1d1ddeddddddde000ef000000ef000
-- 088:5555cdddfff5cfed4445cddd4445cddd5555cdddfff5cdcd4445cded4445cddd
-- 089:ddde5555ddde5fffddde5f44ddde5444ddde5555dcde5fffdede5f44ddde5444
-- 096:0000002100002231002233312233333100223331000022310000002100000001
-- 097:ddddddded11ddddeddd1d1dedddd11deddd111deddddddde000ef000000ef000
-- 098:dddddddedd1d1ddeddddddded1ddd1dedd111ddeddddddde000ef000000ef000
-- 099:dddddd00ddd1dd00dd1ddd001d1d1deed111ddffdd1ddd00dddddd00eeeeee00
-- 100:00dddddd00dd11dd00d11d1deedd111dffd11d1d00dd11dd00dddddd00eeeeee
-- 103:0888888888800888808888008008800080089000808899008880099988000099
-- 104:8888888888000088088008800088880000999900099009909900009999999999
-- 105:8888888088000089088008990088890900999909099009999900009998000099
-- 106:0444444444400444404444004004400040045000404455004440055544000055
-- 107:4444444444000044044004400044440000555500055005505500005555555555
-- 108:4400005544400555404455054004500540045005404455054440055544000055
-- 109:4444444044000044044004440044440400554404055004445500004455000044
-- 112:0000000100000001000000010000000100000001000000010000000100000001
-- 114:ddddddded1d1dddedd1d1ddedddddddedddddddeddddddde000ef000000ef000
-- 119:8800009988800999808899098008900980089009808899098880099988000099
-- 120:8888999988800999808899098008900990099009909999099990099999999999
-- 122:0888999088800999808899098008900980089009808899098880099988000099
-- 126:0000000000000000000000000000000000550000055555000555555055555555
-- 128:000000c50000ccd500ccddd5ccddddd500ccddd50000ccd5000000c500000005
-- 135:8800009988000099888009908088990080899900889009908900009909999999
-- 137:8800009988800999008899090008900900099009009999099990099999999990
-- 138:8800009988800999808899098008900980089009808899098880099908889990
-- 141:0000055500005555000055550005555500055554005555440555544555554455
-- 142:5555555555555555555444555445555545555555555555555555555555555555
-- 143:5500000055500000555000005550000055500000555000005555000055555500
-- 144:0000000500000005000000050000000500000005000000050000000500000005
-- 150:cccccccdcddddddecddddddeeeeeeeee055555555ffff5ff5f4445f454444544
-- 151:cccccccdcddddddeeeeeeeee5ff55ff555555555ff5fffff445f444444544444
-- 152:cccccccdcddddddecddddddeeeeeeeee55555550ff5ffff5445f444544544445
-- 160:55aaaa555aa11ab5aa1aaaaba1aaaaaba1aaaaabaaaaaaab5aaaaab555bbbb55
-- 176:8888888889999997891991978991199789911997891991978999999787777777
-- 177:8888888889999997899119978919919789199197899119978999999787777777
-- 178:0bbbbbb0baaaaaabba1aa1abbaa11aabbaa11aabba1aa1abbaaaaaab0bbbbbb0
-- 179:0a0aa0a0a000000a00a00a00a00aa00aa00aa00a00a00a00a000000a0a0aa0a0
-- 180:0333333032222223322112233212212332122123322112233222222303333330
-- 181:0303303030000003000330003030030330300303000330003000000303033030
-- 182:ddddddddeeeeeeeeeeeffeeeeef00feeee0000eeee0000eeeee00eeefff00fff
-- 183:ddddddddeeeeeeeeeeffffeeef0000fee000000ee000000eeeeeeeeeffffffff
-- 184:033333303b3333b3333bb33333bbbb3333bbbb33333bb3333b3333b303333330
-- 185:eeeeeeeeefeeeefef6eeee6f6eeeeee6efeeeefee6eeee6eeeeeeeeeeeeeeeee
-- 186:77777777799d9997791d9d977d111d177111111779111d97799dd99777777777
-- 188:0000000000000000000100000000100000001000000100000000000000000000
-- 189:0000000000000000000010000001000000010000000010000000000000000000
-- 190:0000000000000000000000000010010000011000000000000000000000000000
-- 191:0000000000000000000000000001100000100100000000000000000000000000
-- 192:0aaaaac0aaaaaaacaa4a4aacaa4a4aacaaaaaaac0aaaaac000c00c0000c00c00
-- 193:0055500005000050000000055000000550000005500000000500005000055500
-- 194:0005e000005ffe0005ffffe05ff5effefffeeffc0fffffc000fffc00000fc000
-- 195:0666666066777766677667766777767667777676677777766677776606666660
-- 196:0000000000444d00044444d004d4d4d004d4d4d0044444d000444d0000000000
-- 197:4444444444444888444488884444888844448888044488880044488800044444
-- 198:8800009988800999808899098008900980089009808889098888899908889990
-- 208:0eeeeef0eeeeeeefee4e4eefee4e4eefeeeeeeef0eeeeef000f00f0000f00f00
-- 209:000000000ddddd0ddceceededceceeeedeeeeefe0fffff0f0000000000000000
-- 210:00eeeee0e0000000e000000ee0eeee0ee0eeee0ee00ee00e0000000e0eeeee00
-- 211:7777777767777776677777766777777667777776677777767777777707777770
-- 212:0000000000000000000000000eeeeee0eeefefffeefeffff5feffff505555550
-- 224:0230023022300223222322232223222322222223022222300030030000300300
-- 225:0000000002300230223002232223222322222223022222300030030000300300
-- </TILES5>

-- <TILES6>
-- 001:ccccccccc3eeee3fceeeeeefceeeeeefceeeeeefceeeeeefc3eeee3fcfffffff
-- 002:ccccccccc3eeeeeeceeeeeeeceeeeeeeceeeeeeeceeeeeeec3eeeeeeffffffff
-- 003:cccccccceeeeee3feeeeeeefeeeeeeefeeeeeeefeeeeeeefeeeeee3fffffffff
-- 004:2222222223aabb3b2abbeeeb2aeeeeeb2beeeeeb2bbeeeef23eeee3f2abfffff
-- 005:22222222b3b2be3fbebbeeefdebeeeefdeeeeeefdeeeeeefd3eeee3fffffffff
-- 006:22222222d3b2aa32deebeb22deebeea2deeeeeb2deeeeba2d3eeee32dffffff2
-- 007:cccccccceeeeeeeeee222cc2e2aaaddaeaaaaddaeebbbeebeeeeeeeeffffffff
-- 008:cccccccceeeeeeee2cc222eeaddaaaaeaddaaabebeebbbeeeeeeeeeeffffffff
-- 009:0000000000eeeeee0eedd4dd0eddcc4c0edccd5d0edcd5ee0edcdeef0edcdef0
-- 010:00000000eeeeeeeeddddd4ddcccccc4cdddddd5deeeee5eeffffffff00000000
-- 011:00000000eeeeee00dddddff0ccccdef0dddcdef0ee4cd5f0fee45ef00eecdef0
-- 012:00000000eeeeeeeedd4dddddc4ccccccd6ddddddee6eeeeeffffffff00000000
-- 013:0edcdef0eddcdef0dd4cdef0c4ccdef0d5ddeef0ee5eeff0ffffff0000000000
-- 014:eddcceefeddcceef0edcdef00edcdef00edcdef00e4cd5f00ed45ef00edcdef0
-- 015:0000000000000000000440000004440000004440044440000444400000004400
-- 016:ccccccccceeeeeedcefeffedceeeeeedcefeffedce3e33edceeeeeeddddddddd
-- 017:8888888899999999cffffffcd000000d1111111111111111eeeeeeeeffffffff
-- 018:ccccccccdeeddeedddfddffdeeeeeeeeffffffff338833883883388399339933
-- 019:ccccccccddddddddeeeeeeeeeffddffeeedffdeee3deed3ee3dffd3eef3ee3fe
-- 020:2a2bdddd232bee3f2a2beeef22bbeeef2abeeeef2b2beeef2322be3f222bffff
-- 021:222222222ab22b322b22eeb222e2ee2222eee2e22be2ebb223a22a3222222222
-- 022:ddddb222d3eeee32deeeeb22deeeeba2deeee2a2deeeb2b2d3eeee32dfffb2a2
-- 023:eeeeeeeeeffffff3effffff3effffff3effffff3effffff3effffff3e3333333
-- 025:0edcdef00ed45ef00e4cd5f00edcdef00edcdef00edcdef00edcdef00edcdef0
-- 026:eddcceefeddcceef0edcdef00ed45ef00e4cd5f00edcdef00edcdef00edcdef0
-- 027:0edcdef00edcdef00edcdef00edcdef00edcdef00e4cd5f00ed45ef00edcdef0
-- 028:0000000000eeeeee0eeddddd0eddcccc0edccddd0e4cd5ee0ed45eef0edcdef0
-- 029:0edcdef00edcddef0edcd4de0edccc4c0edddd5d0efee5ee00ffffff00000000
-- 030:ee000000ddeeeeeedddd4dddccc4ccccccd5ddddeeee5eeeeeffffffff000000
-- 031:0044000000044440000444400444000000444000000440000000000000000000
-- 032:aa0aa0aaa000000a00000000a000000aa000000a00000000a000000aaa0aa0aa
-- 033:ccccccccddddddddd3feef3de33ff33eeeeffeeeedeffedeeddeeddeffffffff
-- 034:cccccccceeeeeeeeee444cc4e4555dd5e5555dd5ee666ee6eeeeeeeeffffffff
-- 035:cccccccceeeeeeee4cc444ee5dd5555e5dd5556e6ee666eeeeeeeeeeffffffff
-- 036:222ddddd2322ee3f2ab2eeef22beeeef2aeeeee22beb22e223a22b3222222222
-- 037:ddddddddd3eeee3fdeeeeeefdeeeeeefbeeeeeef2bee2eefa3b2ab3b22222222
-- 038:dddd2b22d3eeba32deeebaa2deeeeeb2deee22a2deeb2ab2d3b2aa3222222222
-- 041:0edcdef00ed45ef00e4cd5f00edcdef00edcdef00edcdef0eddcceefeddcceef
-- 042:000000eeeeeeeeddddd4ddddcccc4cccdddd5dcceee5eeeeffffffee000000ff
-- 043:0edcdef00edcdef00edcdef00e4cd5f00ed45ef00edcdef0eddcceefeddcceef
-- 044:00000000eeeeee00dd4ddee0c4ccdde0d5dccde0ee5dcde0feedcde00fedcde0
-- 045:0fecdef0fed45ef0ed4cd5f0dddcdef0ccccdef0dddddff0eeeeee0000000000
-- 048:cccccccccc0000dfc0c00d0fc00cd00fc00de00fc0d00e0fcd0000efcfffffff
-- 049:000000000c0c0c0ccdcdcdcddedededeefefefefffffffffffffffffffffffff
-- 050:fffffffffffffffffffffffffefefefeededededdcdcdcdcc0c0c0c000000000
-- 051:ff000033fff00333f0ff3303f00f3003f00f3003f0ff3303fff00333ff000033
-- 052:cccccccdcef000edc0ef0efdc00eef0dc0fee00dcfe0fe0dce000feddddddddd
-- 053:cccccccdc00ef00dc00ef00dcffeeeedceeeeffdc00fe00dc00fe00ddddddddd
-- 054:dcccccccffddeefffeeeeedffeefcedffdecfeeffdeeeeefffeeddffcccccccd
-- 055:cdccccccffeeddfffdeeeeeffdecfeeffeefcedffeeeeedfffddeeffccccccdc
-- 056:ccdcccccffddeefffeeeeedffeefcedffdecfeeffdeeeeefffeeddffcccccdcc
-- 057:cccdccccffeeddfffdeeeeeffdecfeeffeefcedffeeeeedfffddeeffccccdccc
-- 058:ccccdcccffddeefffeeeeedffeefcedffdecfeeffdeeeeefffeeddffcccdcccc
-- 059:cccccdccffeeddfffdeeeeeffdecfeeffeefcedffeeeeedfffddeeffccdccccc
-- 060:ccccccdcffddeefffeeeeedffeefcedffdecfeeffdeeeeefffeeddffcdcccccc
-- 061:cccccccdffeeddfffdeeeeeffdecfeeffeefcedffeeeeedfffddeeffdccccccc
-- 067:6666666666666666666666666666666666666666666666666666666666666666
-- 068:bbbbbbbbbbbbb2bbb2bbbbbbbbbbabb2bbba2abbbabbabbba2abbb2bbabbbbbb
-- 069:bbbbbb2bbb2bbbbb2bbbbabbbbbba2abbbabbabbba2abbb2bbabbbbbbbbbbbbb
-- 070:b2bbbbbbbbbbabb2bbba2abbbabbabbba2abbb2bbabbbbbbbbbbbbbbbbbbb2bb
-- 071:2bbbbabbbbbba2abbbabbabbba2abbb2bbabbbbbbbbbbbbbbbbbbb2bbb2bbbbb
-- 072:bbba2abbbabbabbba2abbb2bbabbbbbbbbbbbbbbbbbbb2bbb2bbbbbbbbbbabb2
-- 073:bbabbabbba2abbb2bbabbbbbbbbbbbbbbbbbbb2bbb2bbbbb2bbbbabbbbbba2ab
-- 074:a2abbb2bbabbbbbbbbbbbbbbbbbbb2bbb2bbbbbbbbbbabb2bbba2abbbabbabbb
-- 075:bbabbbbbbbbbbbbbbbbbbb2bbb2bbbbb2bbbbabbbbbba2abbbabbabbba2abbb2
-- 076:7777777777777777777777777777777777777777777777777777777777777777
-- 077:ffffffffff0000ff0ff00ff000ffff0000333300033003303300003333333333
-- 082:dddddddeddd1dddedd111dded1d1d1deddd1dddeddddddde000ef000000ef000
-- 083:00dddddd00d1dddd00dd1dddeeddd1ddffd1d1d100dd111d00ddd1dd00eeeeee
-- 084:dddddddddd111dded1d1d1ded11111dedd1d1ddeddddddde000ef000000ef000
-- 097:ddddddded11ddddeddd1d1dedddd11deddd111deddddddde000ef000000ef000
-- 098:dddddddedd1d1ddeddddddded1ddd1dedd111ddeddddddde000ef000000ef000
-- 099:dddddd00ddd1dd00dd1ddd001d1d1deed111ddffdd1ddd00dddddd00eeeeee00
-- 100:00dddddd00dd11dd00d11d1deedd111dffd11d1d00dd11dd00dddddd00eeeeee
-- 114:ddddddded1d1dddedd1d1ddedddddddedddddddeddddddde000ef000000ef000
-- 123:3333333333333333333333333333333333333333333333333333333333333333
-- 128:000000c50000ccd500ccddd5ccddddd500ccddd50000ccd5000000c500000005
-- 144:0000000500000005000000050000000500000005000000050000000500000005
-- 145:0000000000000000000000000000000000000000c6c6cc6c4c4c4c4c44444444
-- 150:cccccccccddddddecddddddeeeeeeeee033333333eeee3ee3efff3ef3ffff3ff
-- 151:cccccccccddddddeeeeeeeee3ff33ff333333333ee3eeeeeff3effffff3fffff
-- 152:cccccccccddddddecddddddeeeeeeeee33333330ee3eeee3ff3efff3ff3ffff3
-- 160:aa7777aaa775579a77577779757777797577777977777779a777779aaa9999aa
-- 176:444444444555555645c55c56455cc556455cc55645c55c564555555646666666
-- 177:4444444445555556455cc55645c55c5645c55c56455cc5564555555646666666
-- 178:022222202aaaaaab2acaacab2aaccaab2aaccaab2acaacab2aaaaaab0bbbbbb0
-- 179:0b0bb0b0b000000b00b00b00b00bb00bb00bb00b00b00b00b000000b0b0bb0b0
-- 180:0888888089999997899cc99789c99c9789c99c97899cc9978999999707777770
-- 181:0909909090000009000990009090090990900909000990009000000909099090
-- 182:eeeeeeeeffffffff66222266000880000008100000a1aa00ffffffffeeeeeeee
-- 183:eeeeeeeeffffeeffff66feff6666ffff66006f66600006000000000000000000
-- 184:444444445544445566545566ce6556efcee66eefceee6eefc3eeee3fcfffffff
-- 185:eeeeeeeeefeeeefef6eeee6f6eeeeee6efeeeefee6eeee6eeeeeeeeeeeeeeeee
-- 186:77777777799d9997791d9d977d111d177111111779111d97799dd99777777777
-- 188:0000000000000000000100000000100000001000000100000000000000000000
-- 189:0000000000000000000010000001000000010000000010000000000000000000
-- 190:0000000000000000000000000010010000011000000000000000000000000000
-- 191:0000000000000000000000000001100000100100000000000000000000000000
-- 192:0111112011111112118181121181811211111112011111200020020000200200
-- 193:0055500005000050000000055000000550000005500000000500005000055500
-- 194:0005e000005ffe0005ffffe05ff5effefffeeffc0fffffc000fffc00000fc000
-- 195:0666666066777766677667766777767667777676677777766677776606666660
-- 196:0000000000444d00044444d004d4d4d004d4d4d0044444d000444d0000000000
-- 197:4444444444444888444488884444888844448888044488880044488800044444
-- 208:0eeeeef0eeeeeeefee4e4eefee4e4eefeeeeeeef0eeeeef000f00f0000f00f00
-- </TILES6>

-- <TILES7>
-- 001:0cccccccc88dccccc888dccfce888dffcce88dffccceefffcccfffffccffffff
-- 002:ccccccccccccccccfddddddfffddddffffffffffffffffffffffffffffffffff
-- 003:ccccccc0ccccd88cfccd888cffd888ecffd88eccfffeecccfffffcccffffffcc
-- 004:fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc
-- 005:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffcfffffff
-- 007:0000000500000055000005570000557700055777005577770557777755777777
-- 008:5555555555555555777777777777777777777777777777777777777777777777
-- 009:5000000055000000755000007755000077755000777755007777755077777755
-- 010:00000009000000990000099a000099aa00099aaa0099aaaa099aaaaa99aaaaaa
-- 011:9999999999999999aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 012:9000000099000000a9900000aa990000aaa99000aaaa9900aaaaa990aaaaaa99
-- 013:0000000e000000ee00000eed0000eedd000eeddf00eeddff0eeddfffeeddffff
-- 014:eeeeeeeeeeeeeeeeddddddddddddddddffffffffffffffffffffffffffffffff
-- 015:e0000000ee000000dee00000ddee0000fddee000ffddee00fffddee0ffffddee
-- 016:ccccccccc555555dc566669dc5677a9dc567ba9dc56aaa9dc599999dcddddddd
-- 017:cc6fffffc866ffff86567fff86567fff86567fff86567fffc667ffffcc6fffff
-- 018:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 019:fffff6ccffff668cfff76568fff76568fff76568fff76568ffff766cfffff6cc
-- 020:fffffffcffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 021:cfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 023:5577777755777777557777775577777755777777557777775577777755777777
-- 024:7777777777777777777777777777777777777777777777777777777777777777
-- 025:7777776677777766777777667777776677777766777777667777776677777766
-- 026:99aaaaaa99aaaaaa99aaaaaa99aaaaaa99aaaaaa99aaaaaa99aaaaaa99aaaaaa
-- 027:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 028:aaaaaabbaaaaaabbaaaaaabbaaaaaabbaaaaaabbaaaaaabbaaaaaabbaaaaaabb
-- 029:eeddffffeeddffffeeddffffeeddffffeeddffffeeddffffeeddffffeeddffff
-- 030:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 031:ffffddffffffddffffffddffffffddffffffddffffffddffffffddffffffddff
-- 032:aa0aa0aaa000000a00000000a000000aa000000a00000000a000000aaa0aa0aa
-- 033:ccffffffcccfffffcccddfffccd88effcd888effc888eccfc88ecccc0ccccccc
-- 034:ffffffffffffffffffffffffff7777fff766666f66555566c666668ccc8888cc
-- 035:ffffffccfffffcccfffddcccffe88dccffe888dcfcce888ccccce88cccccccc0
-- 036:888888888d8e855588d885558e8d8555888885558555555585555555cccccccc
-- 037:88888888555555558858858885588588855885888858858855555555cccccccc
-- 038:888888885555555c5855855c5855855c5855555c5885855c5555555ccccccccc
-- 039:6677777706677777006677770006677700006677000006670000006600000006
-- 040:7777777777777777777777777777777777777777777777776666666666666666
-- 041:7777776677777660777766007776600077660000766000006600000060000000
-- 042:bbaaaaaa0bbaaaaa00bbaaaa000bbaaa0000bbaa00000bba000000bb0000000b
-- 043:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbb
-- 044:aaaaaabbaaaaabb0aaaabb00aaabb000aabb0000abb00000bb000000b0000000
-- 045:ffddffff0ffddfff00ffddff000ffddf0000ffdd00000ffd000000ff0000000f
-- 046:ffffffffffffffffffffffffffffffffddddddddddddddddffffffffffffffff
-- 047:ffffddfffffddff0ffddff00fddff000ddff0000dff00000ff000000f0000000
-- 048:88888888c8ffffdecf8ffdfecff8dffecffdeffecfdffefeccffffeeeeeeeeee
-- 049:000000000c0c0c0ccdcdcdcddedededeefefefefffffffffffffffffffffffff
-- 050:fffffffffffffffffffffffffefefefeededededdcdcdcdcc0c0c0c000000000
-- 051:ff0000fffff00ffff0ffff0ff00ff00ff00ff00ff0ffff0ffff00fffff0000ff
-- 052:888888888d8e855588d885588e8d8558888885588555555585555555cccccccc
-- 053:88888888555555555858588558585885888858858585588555555555cccccccc
-- 054:888888885555555c8585855c8585855c8888855c5858555c5555555ccccccccc
-- 055:7777777777777777777777777777777777777777777777777777777777777776
-- 056:7777777777777777777777777777777777777777777777777777777767777777
-- 058:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab
-- 059:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabaaaaaaa
-- 061:fffffffffffffffffffffffffffffffffffffffffffffffdffffffddfffffdde
-- 062:ffffffffffffffffffffffffffffffffffffffffdfffffffddffffffeddfffff
-- 064:000000000000000000000000000000000000c000000cd000000df000000ff000
-- 071:7777777577777777777777777777777777777777777777777777777777777777
-- 072:5777777777777777777777777777777777777777777777777777777777777777
-- 074:aaaaaaa9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 075:9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 077:fffffddeffffffddfffffffdffffffffffffffffffffffffffffffffffffffff
-- 078:eddfffffddffffffdfffffffffffffffffffffffffffffffffffffffffffffff
-- 080:000ff000000fd000000dc000000c000000000000000000000000000000000000
-- 082:dddddddeddd8dddedd888dded8d8d8deddd8dddeddddddde000ef000000ef000
-- 083:00dddddd00d8dddd00dd8dddeeddd8ddffd8d8d800dd888d00ddd8dd00eeeeee
-- 084:dddddddddd888dded8d8d8ded88888dedd8d8ddeddddddde000ef000000ef000
-- 089:cccccccccc444444fcc43333ffcc4333ffdccc43ffdddc43ffdddc43ffdddc43
-- 090:cccccccc444444cc33333ccf3333ccff33ccceff33ceeeff33ceeeff33ceeeff
-- 091:cccccccccc666666fcc65555ffcc6555fffcccccffffddddfffffdddffffffdd
-- 092:cccccccc666666cc55555cc75555cc76ccccc766d7777666dd766666dddddddd
-- 093:cccccccccccccccc7777777766666666666666666666666666666666dddddddd
-- 094:cccccccccc6666667cc6555567cc6555667ccccc6667777d666666dddddddddd
-- 095:cccccccc666666cc55555ccf5555ccffcccccfffddddffffdddfffffddffffff
-- 096:0000002800002288002288282288222800222228000022280000002800000008
-- 097:ddddddded88ddddeddd8d8dedddd88deddd888deddddddde000ef000000ef000
-- 098:dddddddedd8d8ddeddddddded8ddd8dedd888ddeddddddde000ef000000ef000
-- 099:dddddd00ddd8dd00dd8ddd008d8d8deed888ddffdd8ddd00dddddd00eeeeee00
-- 100:00dddddd00dd88dd00d88d8deedd888dffd88d8d00dd88dd00dddddd00eeeeee
-- 103:ccccddddddccddeedddcdeeefdddeeefffddeeffffffffffffffffffffffffff
-- 105:ffdddc43ffdddc43ffdddc43fffdddc4ffffdddcfffffdddffffffddfffffffd
-- 106:33ceeeff33ceeeff33ceeeff3ceeefffceeeffffeeefffffeeffffffefffffff
-- 107:ffffffddfffffdddffffddddfffcccccffcc6666fcc65555cc655555cccccccc
-- 108:dddddddddd777777d7666666ccccc7666666cc7655555cc7555555cccccccccc
-- 109:dddddddd7777777766666666666666666666666666666666cccccccccccccccc
-- 110:dddddddd777777dd6666667d666ccccc66cc66666cc65555cc655555cccccccc
-- 111:ddffffffdddfffffddddffffcccccfff6666ccff55555ccf555555cccccccccc
-- 112:0000000800000008000000080000000800000008000000080000000800000008
-- 114:ddddddded8d8dddedd8d8ddedddddddedddddddeddddddde000ef000000ef000
-- 124:ccccccccccccccccd6666666d5555555dd555555ddd555557ddd555567ddd555
-- 125:cccccccccceeeeeccccdddec6cccddec56cccdec556cccec5556cccc55556ccc
-- 126:0000000000000000000000000000000000000044000004330000433300004333
-- 127:0000000000000000000000000000000044000000334000003334000033330000
-- 128:0000005200005562005566625566666200776662000077620000007200000002
-- 140:d67ddd55dd67ddd5fdd67dddffdd67ddfffdd67dffffdd67fffffdd6ffffffdd
-- 141:555556cc555556cc555556ccd55556ccdd5556ccddd556cc7ddd56cc7dddddcc
-- 142:0000433000004330000043300000433800004388000048880000888800088888
-- 143:04330000043300000433000054330000553300005553000055550000c5555000
-- 144:0000000200000002000000020000000200000002000000020000000200000002
-- 145:0000000000000000000000000000000000000000c6c6cc6c4c4c4c4c44444444
-- 158:0006666500006666000046660000446600004346000043300000433000004330
-- 159:6777700077770000777400007743000074330000043300000433000004330000
-- 174:0000433400004333000004330000004300000000000000000000000000000000
-- 175:4333000033330000333000003300000000000000000000000000000000000000
-- 176:5555555556666667568668675668866756688667568668675666666757777777
-- 177:5555555556666667566886675686686756866867566886675666666757777777
-- 178:099999909aaaaaab9a8aa8ab9aa88aab9aa88aab9a8aa8ab9aaaaaab0bbbbbb0
-- 179:0909909090000009009009009009900990099009009009009000000909099090
-- 180:0cccccc0cddddddecdd88ddecd8dd8decd8dd8decdd88ddecdddddde0eeeeee0
-- 181:0505505050000005000550005050050550500505000550005000000505055050
-- 182:eeeeeeeeffffffff66222266000880000008100000a1aa00ffffffffeeeeeeee
-- 183:eeeeeeeeffffeeffff66feff6666ffff66006f66600006000000000000000000
-- 184:033333303b3333b3333bb33333bbbb3333bbbb33333bb3333b3333b303333330
-- 185:cccccccccc666cccddd656ddfd655ddfffddddffffffffffffffffffffffffff
-- 186:77777777799d9997791d9d977d111d177111111779111d97799dd99777777777
-- 188:0000000000000000000100000000100000001000000100000000000000000000
-- 189:0000000000000000000010000001000000010000000010000000000000000000
-- 190:0000000000000000000000000010010000011000000000000000000000000000
-- 191:0000000000000000000000000001100000100100000000000000000000000000
-- 192:0111112011111112118181121181811211111112011111200020020000200200
-- 193:0055500005000050000000055000000550000005500000000500005000055500
-- 194:000cd00000ceed000ceeeed0ceecdeedeeeddeef0eeeeef000eeef00000ef000
-- 195:0666666066777766677667766777767667777676677777766677776606666660
-- 196:0000000000ddde000ddddde00dedede00dedede00ddddde000ddde0000000000
-- 197:ccccccccddddf888cedf8888dcef8888ddcf88880eef888800eef888000fffff
-- 198:0000000000000000000ee00000edde0000edde00000ee0000000000000000000
-- 199:0000000000000000000dd00000deed0000deed00000dd0000000000000000000
-- 200:0ffffff0ff7eeefff77e77eff77ee7effe7ee77ffe77e77fffeee7ff0ffffff0
-- 201:0005000000055000005550000322222032222222322252523222525232222222
-- 202:0999998099999998999999989995959899959598999999989999999808888880
-- 208:0eeeeef0eeeeeeefee4e4eefee4e4eefeeeeeeef0eeeeef000f00f0000f00f00
-- 209:000000000ddddd0ddceceededceceeeedeeeeefe0fffff0f0000000000000000
-- 210:00eeeee0e0000000e000000ee0eeee0ee0eeee0ee00ee00e0000000e0eeeee00
-- 211:0777777077777777677777766777777667777776677777767777777707777770
-- 212:00000000000000000eeeeee0eeefefffeeeeffffeefeffff5feffff505555550
-- 213:00eeeeee0eee55eeeee5555eeee5555eeeee55eeeeeeeeeefeeeeeee0fffffff
-- 215:0000000000000000000ee00000edde0000edde00000ee0000000000000000000
-- 216:0000000000000000000dd000000d0dd000d0dd0000ddd000000d000000000000
-- 217:000000000000000077700000757000007fffffff0ffffff000ffff000000f000
-- 218:000ff000000fff00000fff0000777f0000757f00007770000000000000000000
-- 219:0000100b00001bb000001bb000001111aaaa00000bba00000bba0000b00a0000
-- 224:0230023022300223222322232223222322222223022222300030030000300300
-- 225:0000000002300230223002232223222322222223022222300030030000300300
-- 227:0766667077777777777777777777777777777777777777777777777707666670
-- 228:0000000000000000000550000052230000522300000330000000000000000000
-- </TILES7>

-- <SPRITES>
-- 000:0f777770f7777777f7757577f7757577f77777770f77777000f00f0000f00f00
-- 001:000000000f777770f7777777f7757577f7757577f77777770f77777000f00f00
-- 002:0f777770f7777777f7757577f7757577f77777770f77777000f00f000f0000f0
-- 003:0f777770f7777777f7757577f7757577f77777770f77777000f00f00000ff000
-- 004:0000000000000000000000000000000000898900008999008999999900000000
-- 005:0000000000000000000000000000000000000000008989000089990089999999
-- 006:0000000000000000000000000000000000000000008989000089990089999999
-- 007:0000000000000000000000000000000000000000008989000089990089999999
-- 016:00000000000000000f777770f7757577f77575770f777770fff00fff00000000
-- 017:00f777000f7777700f7575700f7575700f77777000f77700000f0f00000f0f00
-- 018:0000000000000000000000000f777770f7757577f77575770f777770fff00fff
-- 025:0000000000007770000777770007575700775757707777777777777666666666
-- 026:0000000000000000000077700007777700075757007757577777777766666666
-- 027:0077776067777770777777777757757777577577777777770777777606777700
-- 028:0007760007777770677577707757777777777577077757760777777000677000
-- 032:0333333035552223352222233322223303322330003333000003300000033000
-- 048:0000000000000000000000000000000000c554000c4444d0004ddd00000ef000
-- 049:000fe00000cccc000c44ddd000455d0000000000000000000000000000000000
-- 080:ffffffff0fffffff00ffffff000fffff0000ffff00000fff000000ff0000000f
-- 081:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 088:777777707555557077757770ff757ff000757000007570000075700000757000
-- 089:7770777075707570757075707570757075707570757075707577757075555570
-- 090:7770777075707570757075707570757075707570757775707577757075757570
-- 091:777777707555557077757770ff757ff000757000007570000075700000757000
-- 092:7770777075707570757075707577757075777570755755707555557075757570
-- 093:777777707555557075777570757f75707570757075777570757757f075555700
-- 094:7770000075700000757000007570000075700000757000007570000075700000
-- 095:77707770757075707570757075707570757775707555557077777570ffff7570
-- 097:ffffffff0fffffff00ffffff000fffff0000ffff00000fff000000ff0000000f
-- 104:0075700000757000007570000075700000757000007570000077700000fff000
-- 105:75777570757f75707570757075707570757075707570757077707770fff0fff0
-- 106:755555707557557075777570757f7570757075707570757077707770fff0fff0
-- 107:00757000007570000075700000757000777577707555557077777770fffffff0
-- 108:75777570757f75707570757075707570757075707570757077707770fff0fff0
-- 109:7577570075777570757f757075707570757775707555557077777770fffffff0
-- 110:75700000757000007570000075700000757777707555557077777770fffffff0
-- 111:00007570000075700000757000007570777775707555557077777770fffffff0
-- 153:0000000000000000055505550575057505550555057705570500057507000707
-- 154:0000000000000000055505550577057705550555057707750555055507770777
-- 155:0000000000000000055500550577007705550005077500570555005507770077
-- 156:0000000000000000500555055007570570005005000050055000500570007007
-- 157:0000000000000000550005557500057705000555050007755500055577000777
-- 158:0000000000000000055505550757057500500555005005750050050500700707
-- 159:0000000000000000055505550575075705550050055700500576005007070070
-- 192:000000000aaaaac0aaaaaaacaa4a4aacaa4a4aacaaaaaaac0aaaaac000c00c00
-- 193:00000000000000000000000000000000000000000a000bb00aa4baa000aaa4cc
-- 194:0005f0000005f0000005f0000005f000000ec000000ec000000ec000000ec000
-- 196:000000000004d0000004d0000004d0000004d0000004d0000004d00000000000
-- 198:00cccc000cddddc0cddeeddccdceecdccc0ee0ccc000000c0000000000000000
-- 208:0eeeeef0eeeeeeefee4e4eefee4e4eefeeeeeeef0eeeeef000f00f00000ff000
-- 210:0777777777777777777777777777777777777777777777777777777707777777
-- 215:0111000011100000111111111111111111111111111111111110000001110000
-- 217:0000f00000ffff000ffffff07fffffff75700000777000000000000000000000
-- 224:0023230002232230222322232223222322222223022222300030030000033000
-- 225:0000000000000000022322302223222322232223222222230222223000300300
-- 242:2002000202222220028888300258583022888833028888300233333020003003
-- 255:0000000000066000000660000006600000000000000660000000000000000000
-- </SPRITES>

-- <SPRITES1>
-- 000:0f777770f7777777f7757577f7757577f77777770f77777000f00f0000f00f00
-- 001:000000000f777770f7777777f7757577f7757577f77777770f77777000f00f00
-- 002:0f777770f7777777f7757577f7757577f77777770f77777000f00f000f0000f0
-- 003:0f777770f7777777f7757577f7757577f77777770f77777000f00f000f0000f0
-- 016:00000000000000000f777770f7757577f77575770f777770fff00fff00000000
-- 017:00f777000f7777700f7575700f7575700f77777000f77700000f0f00000f0f00
-- 018:0000000000000000000000000f777770f7757577f77575770f777770fff00fff
-- 048:00000000000000000000000000000000004cc400044444400044440000076000
-- 049:000670000044440004444440004cc40000000000000000000000000000000000
-- 082:00eed0000edd0000edd00000edd00000dde00000dde000000dde000000dde000
-- 192:000000000cccccd0cccccccdccdcdccdccdcdccdcccccccd0cccccd000d00d00
-- 193:00000000000000000000000000000000000000000a000bb00aa4baa000aaa4cc
-- 194:0005f0000005f0000005f0000005f000000ec000000ec000000ec000000ec000
-- 196:000000000004d0000004d0000004d0000004d0000004d0000004d00000000000
-- 198:00cccc000cddddc0cddeeddccdceecdccc0ee0ccc000000c0000000000000000
-- 208:0eeeeef0eeeeeeefee4e4eefee4e4eefeeeeeeef0eeeeef000f00f00000ff000
-- 210:0666666660000000600000006000000060000000600000006000000006666666
-- 215:0ddd0000ddee0000def00000deffffffdeffffffdef00000ddee00000ddd0000
-- 217:0000f00000ffff000ffffff07fffffff75700000777000000000000000000000
-- 224:0023230002232230222322232223222322222223022222300030030000033000
-- 225:0000000000000000022322302223222322232223222222230222223000300300
-- 242:d00d000d0dddddd00deeeef00dcecef0ddeeeeff0deeeef00dfffff0d000f00f
-- 255:0000000000066000000660000006600000000000000660000000000000000000
-- </SPRITES1>

-- <SPRITES2>
-- 000:0f777770f7777777f7757577f7757577f77777770f77777000f00f0000f00f00
-- 001:000000000f777770f7777777f7757577f7757577f77777770f77777000f00f00
-- 002:0f777770f7777777f7757577f7757577f77777770f77777000f00f000f0000f0
-- 003:0f777770f7777777f7757577f7757577f77777770f77777000f00f000f0000f0
-- 016:00000000000000000f777770f7757577f77575770f777770fff00fff00000000
-- 017:00f777000f7777700f7575700f7575700f77777000f77700000f0f00000f0f00
-- 018:0000000000000000000000000f777770f7757577f77575770f777770fff00fff
-- 032:00000000000000000aaaaaa0aabaaaaaabaaaaaaaaaaaaaa5aaaaaa505555550
-- 048:0000000000000000000000000c0000c00dc00cd0088cc88000888800000dd000
-- 049:000dd00000888800088cc8800dc00cd00c0000c0000000000000000000000000
-- 082:00eed0000edd0000edd00000edd00000dde00000dde000000dde000000dde000
-- 192:000000000aaaaac0aaaaaaacaa4a4aacaa4a4aacaaaaaaac0aaaaac000c00c00
-- 193:00000000000000000000000000000000000000000a000bb00aa4baa000aaa4cc
-- 194:0005f0000005f0000005f0000005f000000ec000000ec000000ec000000ec000
-- 196:000000000004d0000004d0000004d0000004d0000004d0000004d00000000000
-- 208:0eeeeef0eeeeeeefee4e4eefee4e4eefeeeeeeef0eeeeef000f00f00000ff000
-- 210:4444000445454544445554444556565604554665044666564555444644440004
-- 224:0023230002232230222322232223222322222223022222300030030000033000
-- 225:0000000000000000022322302223222322232223222222230222223000300300
-- 242:d00d000d0dddddd00deeeef00dcecef0ddeeeeff0deeeef00dfffff0d000f00f
-- 255:0000000000066000000660000006600000000000000660000000000000000000
-- </SPRITES2>

-- <SPRITES3>
-- 000:0677777067777777677878776778787767777777067777700060060000600600
-- 001:0000000006777770677777776778787767787877677777770677777000600600
-- 002:0677777067777777677878776778787767777777067777700060060006000060
-- 003:0677777067777777677878776778787767777777067777700060060006000060
-- 016:00000000000000000f777770f7757577f77575770f777770fff00fff00000000
-- 017:00f777000f7777700f7575700f7575700f77777000f77700000f0f00000f0f00
-- 018:0000000000000000000000000f777770f7757577f77575770f777770fff00fff
-- 048:00000000000000000000000000000000007557000777777000777700000ce000
-- 049:000ec00000777700077777700075570000000000000000000000000000000000
-- 127:0000000000000000000fff0f00fffff0000fff0f000000000000000000000000
-- 192:0000000001111120111111121181811211818112111111120111112000200200
-- 193:0000000000000000000000000000000000000000050001100558122000555855
-- 194:000ce000000ce000000ce000000ce000000df000000df000000df000000df000
-- 196:000000000004d0000004d0000004d0000004d0000004d0000004d00000000000
-- 210:4444000445454544445554444556565604554665044666564555444644440004
-- 242:d00d000d0dddddd00deeeef00dcecef0ddceceff0deeeef00dfffff0d000f00f
-- 255:0000000000066000000660000006600000000000000660000000000000000000
-- </SPRITES3>

-- <SPRITES4>
-- 000:0677777067777777677b7b77677b7b7767777777067777700060060000600600
-- 001:000000000677777067777777677b7b77677b7b77677777770677777000600600
-- 002:0677777067777777677b7b77677b7b7767777777067777700060060006000060
-- 003:0677777067777777677b7b77677b7b7767777777067777700060060006000060
-- 011:00cccc000cfeffc0cffefffccffedddccdddeffccfffeffc0cffefc000cccc00
-- 012:00cccc000cffdfc0cfffdffcceeedffccffdeeeccffdfffc0cfdffc000cccc00
-- 013:00cccc000cfffdc0ceeffdfccffedffccffdeffccfdffeec0cdfffc000cccc00
-- 014:00cccc000cefffc0cfeffddccffedffccffdeffccddffefc0cfffec000cccc00
-- 015:00cccc000cfeffc0cffefffccffedddccdddeffccfffeffc0cffefc000cccc00
-- 016:00000000000000000f777770f77b7b77f77b7b77067777706660066600000000
-- 017:00f777000f7777700f7b7b700f7b7b700f77777000f777000006060000060600
-- 018:0000000000000000000000000f777770f77b7b77f77b7b770677777066600666
-- 048:00000000000000000000000000000000007557000777777000777700000ce000
-- 049:000ec00000777700077777700075570000000000000000000000000000000000
-- 192:000000000aaaaac0aaaaaaacaa4a4aacaa4a4aacaaaaaaac0aaaaac000c00c00
-- 193:00000000000000000000000000000000000000000a000bb00aa4baa000aaa4cc
-- 194:0005f0000005f0000005f0000005f000000ec000000ec000000ec000000ec000
-- 196:000000000004d0000004d0000004d0000004d0000004d0000004d00000000000
-- 198:00cccc000cddddc0cddeeddccdceecdccc0ee0ccc000000c0000000000000000
-- 208:0eeeeef0eeeeeeefee4e4eefee4e4eefeeeeeeef0eeeeef000f00f00000ff000
-- 210:cccccccccdddddee0dccceef0ddecedd00dddefd00000eef000000ee00000000
-- 215:0111000011100000111111111111111111111111111111111110000001110000
-- 224:0023230002232230222322232223222322222223022222300030030000033000
-- 225:0000000000000000022322302223222322232223222222230222223000300300
-- 242:2002000202222220028888300258583022888833028888300233333020003003
-- 255:0000000000066000000660000006600000000000000660000000000000000000
-- </SPRITES4>

-- <SPRITES5>
-- 000:0677777067777777677878776778787767777777067777700060060000600600
-- 001:0000000006777770677777776778787767787877677777770677777000600600
-- 002:0677777067777777677878776778787767777777067777700060060006000060
-- 003:0677777067777777677878776778787767777777067777700060060006000060
-- 016:00000000000000000f777770f7757577f77575770f777770fff00fff00000000
-- 017:00f777000f7777700f7575700f7575700f77777000f77700000f0f00000f0f00
-- 018:0000000000000000000000000f777770f7757577f77575770f777770fff00fff
-- 048:00000000000000000000000000000000007557000777777000777700000ce000
-- 049:000ec00000777700077777700075570000000000000000000000000000000000
-- 198:00cccc000cddddc0cddeeddccdceecdccc0ee0ccc000000c0000000000000000
-- 255:0000000000066000000660000006600000000000000660000000000000000000
-- </SPRITES5>

-- <SPRITES6>
-- 000:0677777067777777677878776778787767777777067777700060060000600600
-- 001:0000000006777770677777776778787767787877677777770677777000600600
-- 002:0677777067777777677878776778787767777777067777700060060006000060
-- 003:0677777067777777677878776778787767777777067777700060060006000060
-- 016:00000000000000000f777770f7757577f77575770f777770fff00fff00000000
-- 017:00f777000f7777700f7575700f7575700f77777000f77700000f0f00000f0f00
-- 018:0000000000000000000000000f777770f7757577f77575770f777770fff00fff
-- 048:00000000000000000000000000000000007557000777777000777700000ce000
-- 049:000ec00000777700077777700075570000000000000000000000000000000000
-- 255:0000000000066000000660000006600000000000000660000000000000000000
-- </SPRITES6>

-- <SPRITES7>
-- 000:0677777067777777677878776778787767777777067777700060060000600600
-- 001:0000000006777770677777776778787767787877677777770677777000600600
-- 002:0677777067777777677878776778787767777777067777700060060000600600
-- 003:0000000006777770677777776778787767787877677777770677777000600600
-- 004:000000000000000000000000ffffffff00ff0ff0000000000000000000000000
-- 005:00000000000000000000000000000000ffffffff00ff0ff00000000000000000
-- 016:00000000000000000f777770f7757577f77575770f777770fff00fff00000000
-- 017:00f777000f7777700f7575700f7575700f77777000f77700000f0f00000f0f00
-- 018:00000000000000000f777770f7757577f77575770f777770fff00fff00000000
-- 019:00f777000f7777700f7575700f7575700f77777000f77700000f0f00000f0f00
-- 048:0000000000000000000000000c0000c00dc00cd0088cc88000888800000dd000
-- 049:000dd00000888800088cc8800dc00cd00c0000c0000000000000000000000000
-- 192:0000000001111120111111121181811211818112111111120111112000200200
-- 193:0000000000000000000000000000000000000000050001100558122000555855
-- 194:000ce000000ce000000ce000000ce000000df000000df000000df000000df000
-- 196:000000000004d0000004d0000004d0000004d0000004d0000004d00000000000
-- 198:00cccc000cddddc0cddeeddccdceecdccc0ee0ccc000000c0000000000000000
-- 208:0eeeeef0eeeeeeefee4e4eefee4e4eefeeeeeeef0eeeeef000f00f00000ff000
-- 242:d00d000d0dddddd00deeeef00dcecef0ddeeeeff0deeeef00dfffff0d000f00f
-- 255:0000000000066000000660000006600000000000000660000000000000000000
-- </SPRITES7>

-- <MAP>
-- 000:d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3e0554545454545454545454545454545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3e0554545454545454545454545454545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d390a0b0e0554545454545454545454545454545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:c0c0c0d3d3d3d3d3d3d3d3d3c0c0c0c0c0c0c0c0c0c0c0d5554545454545454545454545454545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:c1c1c1f0f4d3d3d3d3d3e4d0c1c1c1c1c1c1c1c1c1c1c1c1242424242424241345454545454545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:b1b1b1f1f0f490a0b0e4d0d1b1b1b1b1b1b1b1b1b1b1b1b1255325252553251412454545454545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:b1b1b1e1f1f0c0c0c0d0d1d1b1b1b1b1b1b1b1b1b1b1b1b1255425252554254313454545454545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:c2c2c2e1e1e1c1c1c1d1d1d1c2c2c2c2c2c2c2c2c2c2c2c2252525252525254414124545454545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:c3c3c3f2e1e1b1b1b1d1d1d2c3c3c3c3c3c3c3c3c3c3c3d4554545454545451543134545454545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:d3d3d3f3f2e1b1b1b1d1d2e390a0b0d3d3d3d3d3d3d3d3e0554545454545454544142424242424240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:d3d3d3d3f3f2c2c2c2d2e3d3d3d3d3d3d3d3d3d3d3d3d3e0554545454545454515432553252553250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:d3d350d3d3f3c3c3c3e3d3d3d3d3d3d3d3d3d3d350202020818181454545454545442554252554250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:d3d31130d3d3d3d3d3d3d31050202030d3d3d3d331d3d3e0554545454545454545152525252525250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:d3d3d3112020205020202021d3d3d331d3d3d3d331d3d3e0554545454545454545454545454545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:d3d3d3d3d3d3d3d3d3d3d3d3d3d3d331d3d3d3d331d3d3e0554545454545454545454545454545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3112020202021d3d3e0554545454545454545454545454545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3e0554545454545454545454545454545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <MAP1>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000102020202020202030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000102020203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010202020512121212121212141202020300000000000000000000000000000000000000000000000000010202020202020202030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003c00000000112121214120202020202020202020202020202020202020202020202020202030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011212121212121212121637321212121310000000000000000000000000000000000000010202020202051212121212121212141202020202020300000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:000000000000000000000000000000000000000000000000000000000000000000000000000000c0d0000000000000000000d0e0e0e0d0e0d0e0d0e011212121212121212121212121212121212121212121212121212121212121213100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001121212121212121212164742121212131000000000000001020202020300000000000001121212121212121212121212121212121212121212131000000000000008d000000000000008d00000000000000000000000000000000000000000000000000
-- 004:000000000000000000000000000000000000000000000000000000000000000000000000000070c1d1900000000000000070d1e1e1e1d1e1d1e1d1e11121212121212121212121212121212121212121212121212121212121212121310000000000000000008d00000000000000000000102020202030000000000000000000000000000000000000000000112121212121212121212121212121214120202020202020512121212141203000000000112121212121212121212121212121212121212121213100000000000000000000008d0000000000000000000000000000000000000000000000000000000000
-- 005:000000000000000000000000000000000000000000000000000000000000000000000000001020202020202020202020202020202020202020202020512121212121212121212121212121212121212121212121212121212121212131000000000000000000000000008d0000001020205121212121412030000000000000000000000000000000000000001222502121212121212121212121212121212121212121212121212121212131000000001121212121212121212121212121212121212121212131000000000000000000000000000000000000008d000000000000000000000000000000000000000000
-- 006:0000000000000000000000000000000000000000000000000000000000000000000010202051212121212121212121212121212121212121212121212121212121214022222222222222222222222222222222222222222222225021310000000000008d0000000000b70000000011212121212121212121310400000000000000000000000000000000000000761121212121212121214022222222222222222222222222502121212121413000000012222222222222222222502121212121212121212121310000000000008d0000000000008d000000000000000000000000000000000000000000000000000000
-- 007:000000000000000000000000000000000000000000000000000000000000000000001121212121212121212121212121212121212121212121212121212121212121310000000000000000000000000000000000000000000000112131000000000000000000000000b70000000012222222502121212121413000000000000000000000000000000000000000761121212121402222223286868686868686868686868686125021212162213100000000768686868686868686112121212121212121212121310000000000000000008d0000000000008d000000000000000000000000000000000000000000000000
-- 008:0000000000000000000000000000008d0000000000000000000000000000000000001250212121212121212121212121212121212121212121212121212121215421310000000000000000000000000000000000000000000000112131000000000000000000000000b7000000000072b2c212502121212121310000000000000000000000000000000000000077112121212131868686a587878787b586868686868686868612222222502131000000007686864c86864c868611212121212121212121212131000000000000000000000000000000000000b700000000000000000000000000000000000000000000
-- 009:000000000000000000000000000000b70000000000000000000000000000000000000011212121212121212121212121212121212121212121212121212121212121310000000000000000000000000000004c4c000000000000112131000000000000000000000000b7000000000000b3c3001222222250213100000000004c4c4c4c4c4c4c4c000000000000001121212121318787879700000000778787878787878787878787878711213100000000764c868686868686861121212121212121212121213100000000000000000000000000000000008db700000000000000000000000000000000000000000000
-- 010:000000000000000000000000000000b700000000000000000000000000000000000000125021212121212121212121212121212121212121212121212121212121213100000000004c0000000000000000004c4c000000000000112131000000000000000000000000b7000000000000b4000000000000112131000000004c00000000000000004c00000000000012222250213100000000000000000000000000000000000000000000112131000000007787878787878787b511212121212121212121212131000000000000000000060000000000000000b700000000000000000000000000000000000000000000
-- 011:000000000000000000000000000000b798a800000000000000000000000000000000007112222222225021212121212121212121212121212121212121212121214032000000000000004c000000000000004c4c00000000007512223295000000000000000000008db7000000000000000000000000001121310000000000000000000000000000000000000000000076112131000000000000000000000000000000000000000000001121310c00000000000000000000007611212121212140222222222232000000000000000000070000000000000000b700000000000000000000000000000000000000000000
-- 012:000000000000000000000010202020300000000000000000000000000000000000000072b29200000011212121212121212121212121212121212121214022222232000000004c00000000000000000000000000000000000076868686960000000000000000000000b70000000000000000004c0000001121310c00000000000000000000000000000000000000000077112131000000000000000000000000000000000000000000001222320000000000000000000000007712222222222232000000000000000000000000000000070000000000000000b700000000000000000000000000000000000000000000
-- 013:000000000000000000000012502121412030000000000000000000000000000000000000b3000000001222222222502121212121212121212121212121310000000000000000000000000000c0e0000000000000000000000076868686960000000000000000000000b7000000000000004c4c0000000012223200000000000000000000000400042704000000000000001121310c00000000000000000000000000000000000000000000000000000000000000000000004c0000000000000000000000000000000000000000000000070000000000000000b700000000000000000000000000000000000000000000
-- 014:000000000000000000000000125021212131000000000000000000000000000000000000b4004c0000768686868611212121212121212121212121212131000000000000004c0000000000708080900000102020300000000076868686960000000000000000000000b700000000004c4c000000000000000000000000000000000000001020202020203000000000003611213100000000000c102030000004000400e0f0e0f0e0f0000000000000000000000000000000000000000000000000000000000000000000000000000000070000000004000000b700000000000000000000000000000000000000000000
-- 015:000000000000000000000000001121212131000000000000000000000000000000000000000000000076868686861222222250212121212121212121213100000000000000000000000010202020202020512121314600000076868686960000000000000000000000b7000000004c000000000000000000000000000000007585858585112121212121310000000000001121310c0000000000112141202020202030e1f1e1f1e1f19000000004000000000000001020300c0000000000000000004c4c4c4c000000000000040400000700000400102020202020203000000000000000000000000000000000000000
-- 016:00000000000000000000000000122222223200000000000000000000008d0000000000004c00758585b686868686868686861121212121212121212121310000000000000000000000001121212121212121212131000000007686868696000000000000000000000010203035000000000000000000000000007585858585b6868686861121212121213185858585858511213100000000000c1121212121212121412020202020202020202020300000000000001121310000000000000000004c000000004c0000102020202020202020202020512121212121213100000000000000000000000000000000000000
-- 017:00000000000000000000000075b6868686a685950000000000000000000000000000004c00007686868686864c86868686861250212121212121212121310000000000000000000098a8112121212121212121213100000000768686869600000000000000000000001121310c0000000000001020202020202020308686868686868686112121212121318686868686861121310c00000000001121212121212121212121212121212121212121318585858585426021310000000000000400000000000000000400112121212121212121212121212121212121213100000000000000000000000000000000000000
-- 018:000000000000000000007585b6868686868686a6859500008d00000000000000000000000000768686868686868686868686861121212121212121212131000000000000000000000000112121212121212121213185858585b68686869600000000000000000000001222320000000000000011212121212121213113131313131313131121212121213186868686868611213100000000000c1121212121212121212121212121212121212121318686868686a61222320000000000102020300000000000001020512121212121212121212121212121212121213100000000000000000000000000000000000000
-- 019:000000004c0000007585b6868686868686868686869600000000008d00008d0000004c0000007686102030868686868686868611212121212121212121310000000000000000000008001121212121212121212131868686868613131396000000e0f0000000000000000000000000000000001121212121212121412020202020202020512121212121318686868686861121310c00000000001121212121212121212121212121212121212121318686868686868686960000000000112121318090000000001121212121212121212121212121212121212121213100000000000000000000000000000000000000
-- 020:000000004c007585b6868686868686868686838686960000000000b700000000000000000075b6861121318686864c868686861222222222222222222232000000000000000c00000900112121212121212121214120202020202020202020307080809000000000000000000000000000000011212121212121212121212121212121212121212121213186868686868611213100000000000c11212140222222222222502121212121212121216152868686868686869600000000001121213181a1900000426021212121212121212121212121212121212121213100000000000000000000000000000000000000
-- 021:000000004c00768686868686868686868686868686960000000000b70000000000004c00007686861121318686868686868686960000050000000000769600000000001020202020202051214022222222222222222222222222502121212141202020300004000004040000000000000000001121212121212121212121212121212121212121212121318686868686861121310c000000000011214032a30000a300001250212121212121212131b686868686868686a68585859500112121318181910000c01121212121212121212121212121212121212121213100000000000000000000000000000000000000
-- 022:000000000075b6868686a58787878787b586868686960000000000b700000000000000000076868611213186868686864c868696000000000000000076a6858585858511212121212121212131e5f500000071819100000000001121212121212121214120202020202020202030858585858511212121212121212121212121212121212121212121213186868686868611213100000000000c112131a3a40000a300000012225021212121212131868686868686868686868686a685112121318181910070801121212121212121212121212121212121212121213100000000000000000000000000000000000000
-- 023:000000060076868686a59700000000007787b58686103000000000b7000000007585858585b686861121413086868686868686a69500000000000075b686868686868611212121212121212131e6f600000072b2920000000000112121212121212121212121212121212121213186868686861121212121212121212121212121212121212121212121318686868686861121310c0000000000112131a4000000a4000000000012225021212121412020202020203086868686868686112121412020202020205121212121212121212121212121212121212121213100000000000000000000000000000000000000
-- 024:000000102030868686960000000000000000768686113100000000b70000000076860c8686868686112121318686868686868686a6950000000075b68686868686868611212140222222222232e7f700000000b30000000000001121212121212121212121212121212121212131868686868611212121212121212121212121212121212121212121213186868686868612223200000000000c1121310000000000000000000071811121212121212121212121214120202020202020512121212121212121212121212121212121212121212121212121212121213100000000000000000000000000000000000000
-- 025:0000001121318686869600002700000000007787b51141202020202020202020202020202020202051212131868686868686868686a695000075b6868686868686868611212131000000000000000000000000b4000000000000112121212121212121212121212121212121214120202020205121212121212121212121212121212121212121212121318686868686868696000000000000001121310000000000000000000072f21222222222225021212121212121212121212140222222222222222222222222222250212121212121212121212121212121213100000000000000000000000000000000000000
-- 026:000000125041202020202020202030000000000010512121212121212121212121212121212121212121214120202020202030868686a68585b68686868686860c86861121213100000000000000000000000000000000000000112121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121318686868686868696000000000000001121310000000000000000000000f300e30000e3001121212121212121212121212131007181910000000000000000b30012502121212121212121212121212121213100000000000000000000000000000000000000
-- 027:0000007112222222222250212121412020202020512121212121212121212121212121212121212121212121212121212121318686868686102020202020202020202051212131000000000000000000000000000000000000001121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121213186868686868686960000000000000011213100000000000000000000000000000000000012222222222222222222222222320072b2920000000000000000b40000122222222222222222222222222222223200000000000000000000000000000000000000
-- 028:0000007282920072a20011212121212121212121212121212121212121212121212121212121212121212121212121212121318686868686112121212121212121212121212131000000000000000000000000000000000000001121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121214120202020202020202020202020202051213100000000000000000000000000000000000000000000000000000000000000000000b3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 029:0000000000000000b40011212121212121212121212121212121212121212121212121212121212121212121212121212121412020202020512121212121212121212121212131000000000000000000000000000000000000001121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121214130000000000000000000000000000000000000000000000000000000000000000000b4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 030:000000000000000000001222225021212121212121402222222222222222222222502121212121212140222222222222222222222222222222222222222222222222222222223200000000000000000000000000000000000000122222222222222222222222222222222222222222222222222222222222222222225021212121212121212121212121212121212121212121212121212121212121214120300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 031:000000000000000000000000001222222222222222320000000000000000000000122222222222222232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001121212121212121212121212121212121212121212121212121212121212121212121310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 032:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001222222222222222222222222222222222222222222222222222222222222222222222320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 035:000000000000000000000000000000000000000000001020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 036:000000000000000000000000000000000000000010205121212121212121214022222222222222222222225021212121212121212121212121212121212121212121212121212121212121212121212121212121212121212131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000141411213100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 037:000000000000000000001020202020202020202051212121212121212121213100000000000000000000001222502121212121212121402222222222222222222250212121212121212121212121212121212121212121212131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000102051214130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 038:0000000000000000000011212121212121212121212121212121212121212131000000000000000000000000001250212121212121213100000500000000000000122250212121212121212121212121212121212121212121310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001121842121310000000000000000004c004c000000000000004c00000000000000000000000000000000000000000000004c00000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 039:0000000000000000000011212121212121212121212121212121212121402232000000000000000000000000000012502121212121213100000000000000000000000011212121212121212121212121212121212121212121310000000000000000000000000000000000000000000000000000000000000000000000000000000000001414140000000000000000000000000000141121212140320000000000000000004c004c000000000000004c00000000000000000000000000000000000000000000004c00000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 040:0000000000000000000011212121212121212121212121212121212121310000000000000000000000000000000000122250212121403200000000000000000000000012225021212121212121212121212121212121212121310000000000000000000000000000000000000000000000000000000000000000000000000000000000001020300000000000000000000000000000105121218431000000000000000000004c004c000000000000004c00000000000000000000000000000000000000000000004c00000000000000000000000000001020203000000000000000000000000000000000000000000000
-- 041:0000000000000000000012222222222222225021212121212121214022320000000000000000000000000000000000000011212121310300000000000000004c000000000011212121212121212121212121212121212121213100000000000000000000000000000000008d000000008d00000000000000000000000000000000000000112131000000000000000000000000000011212140223200000000000000000000000000000000000000000000000000000000141414000000000000000000000000000000000000000000000000000000001121212130000000000000000000000000000000000000000000
-- 042:00000000000000000000000000000000000012222222222222222232000000000000000000000000000000000000000000112121213103000000000000000000000000000011212121212121212121212121212121212121213100000000000000000000000000000000000000000000000000008d00000000000003102030000000000011213114141400000000000000000000001121213100000000000000103000006979797989000000000099a9b900000000000010203000000000000000000000000099a9b9000000000000000000000000001250212121300000000000000000000000000000000000000000
-- 043:000000000000000000000000000000000000000075868686869600000000000000000310202020300000000000000000001121212131030000000010203000004c000000001121212121212121212121212121212121212121310000000000000000000000000000008d0000008d0000b70000000000000000000003112131000000000011214120203000000000000000000000001121403200000000000000114130000000f90000000000000000f90000006979890011213100006979797979798900000000f90000000000000000000000000000b312502121412020300000000000000000000000000000000000
-- 044:0000000000000000000000000000000000000075b686868686960000000000000000031121212131000000000000000000112121213103000000001121313500000000000011212121212121212121212121212121212121213100000000000000000000000000000000000000000000b7008d000000000000000003112131000000000011212121213100000000000000000000001184310000000000000014114032000000f90000cadaea000000f900000000f914141121310000000000f900000000001414f90000000000000000000000000000b400122250212121413000000000000000000000000000000000
-- 045:000000000000000000000000000000000000007686868686869600000000000000000311212121318080808080900000001121212131030000000411213100004c0000000011212121212121212121212121212121212121213100000000000000000000000000000000000000000000b70000000000000000000003112141300000000011532121213100000000000000000000001121310000000000102020513100000000f9000000f900141414f914141414f910205121310000000000f9000000000010203014140000000000000000000000000000b30011212121213100000000000000000000000000000000
-- 046:00000000000000000000000000000000000075b68686868686960000000000000000031121212131818181818191000000112121213103000000426021310000000000000011212121212121212121212121212121212121403200000000000000000000000000000000000000000000b70000000000000000000003112121310000000012222250213100000000000000000000001121310000000000125021843114000000f9000000f90010202020202020202051212121310000001414f9001414140011214120300000cadaea000000000000000600a40011212121213100000000000000000000000000000000
-- 047:000000000000000000000000000000000075b68686868686869600000000000000000311212121318181818110202020205121212131030000000011213100004c000000001121212121212121212121212121212121402232000000000000000000000000000000004c004c004c0000b7000000000000000000000311212131000000000000001121310000000000000000141414112131140099a9b9001222504130141414f91414008afa112121212121212121212140223200000010203014102030851222502131141400f900000000000000000700000011212121213100000000000000000000000000000000
-- 048:1030000000000000000000000000000000768686868686868696000000000000000003112121213181818181122222222222502121310300000000112131000000000000001121212121212121212121212121214022320000000000000000000000000000000000004c4c4c4c4c0000b70000000000000000000003112121310c0000007585851121310000000000141414102020512141202030f900000000112141202020202030000000112121212121212121212131000000000011214120512131868686125041203000f900000000000000000700000011212121213100000000000000000000000000000000
-- 049:1141300000000000000000000000000075b686868686868686a6950000000000000003112121213181818181818181818181112121310300000000112131004c00000000001121212121212121212121212121213100000000000000000000000000000000000000004c004c004c0000b700000000000000000000031121213100007585b686861121310000141414102020512121214022222232f9000000001121212121212121311414141121212121212121214022320000000000125021214022328686868611212131fa9a75102030000000000700000011212121213100000000000000000000000000000000
-- 050:11213100000000000000000000000000768686868686868686869600000000000000031121212131818181818181818181811121213103000000001250310000000000000011212121212121212121212121402232000000000000007585858585859500000000000000000000000000b7000000000000000000000311212141202030868686861121311414102020512140222222223200000000f90000000011842121212121214120202051212121212121402232000000000000000011214032007686868686112140328585b6112141202030000700001051212121213100000000000000000000000000000000
-- 051:1121310000000000000000000000000310202020202020202020300300000000000003112121213181818181818181818181112121310390000000031131000000000000001222222222225021214022222232000000000000758585b6868686868696000000000800000000000010202020300000000000000000031121402222223287b586861121412020512121402232000000a30000000000f9000027001121212121212121212121212121212121212131000000000000000000001121310000768686868611213186868686112121212141202020205121212121213100000000000000000000000000000000
-- 052:11213100000000000000000000000003112121212121212121213103000000000000031121212141202020203081818181811121213103a19000000311314c0000000000000000000000001222223200000000000000000000768686868686868686102030000009001020202020512121213100000000000000000311213100000000007787871121212121402222320000000000a40000004c00f9001020205121212121212121212121212121212121212131950000000000000000001250412030b68686131311213186868613112121212121212121212121212121403200000000000000000000000000000000
-- 053:1121310000000000000000000000000311212121212121212121310300000000000003112121212121212121318181818181122222328181a18080031131000000000000000000000000000000000000000000000000000000768686868686861020512141202020205121212121212121213100000000000000000311213100000000000000001121212140320000000000000000000000000000f9001121212121212121212121212121212140222222222232960000000000000000000011212131868686102021213113861310512121212121212121212121212140320000000000000000000000000000000000
-- 054:1121310000000000000000000000000311212121212121212121310300000000000003112121212121212121318181818181818181818181818181031131000000000000000000000000000000000000000000000075858585b686868686868611212121212121212121212121212121212131000000000000000003112131000000000000000c1121212131000000000000000000000000000000f9001121212183402222222222222222222232232323232323960000000000000000001051402232868686112121214130131051214022225021212121212121214032000000000000000000000000000000000000
-- 055:1121310600000000000000000000000311212121212121212121310300000000000003112121212121212121318282b081818181818181818181810311310c00000000000000000000000000000000000000000000768686868686868686868611212121212121212121212121212121214032000000000000000003112131000000000000000011212121318585858585950000000000001020202020512121212131868696000000000076868686868686868696000000c9d9e90014141121318686131020512222212141205121403200001121212121212121213100000000000000000000000000000000000000
-- 056:1121413000c0d0c0e000c000000000031121212121212121212131030000000000000011212121212121212131000072b0818181818181818181810311310000000000000000000004000000000000000000000000768686868686868686868611212121212121212121212121212121213103000000000000000003112131000000000010202051402222328686868686a685858595000011842121212121212121310a869600000000007787878787878787879700000000f9000010205121412020205121310000122221212140320000001250212121214022223200000000000000000000000000000000000000
-- 057:1121214130c1d1708090270000000003112121212121212121213103000000000070801250212121212121213100000072b08181818181818181810311310000000000000000102020202020203000040075858585b68686868686868686868611212121212121212121212121212121213103000000000000000003112131000000007512222222328686868686868686868686861020205121212121832121212141202030000000000014140000000000000000000000008afafa11212121212121212140320000000012222232000000000011212121213100000000000000000000000000000000000000000000
-- 058:112121214120202020202020202020205121212121212121212131030000000070b181811121212121212121310004000071818181818181818181031131000000000000000011212121212121412020203086868686868686868686868686861121212121212121212121212121212121310300000000000000000311213100000000768686868686868684868686838686868686112121212121212121212121212183213100c9d9e900103000c9d9e9000000c9d9e9000000000012225021212121212131000000000000000000000000000011212121213100000000000000000000000000000000000000000000
-- 059:1121212121212121212121212121212121212121212121212121310300000070b18181811121212121212121412020202020202030818181818181031131c000c0d0e0f000001121212121212121212121318686868686868686868686860d86112121212121212121212121212121212131030000000000000000031121310000000076868686868686868686868686868686868611218321212121212121218321212121310000000000113100000000000000000000000000000000001121212121212131000000000000000000000000000012222222223200000000000000000000000000000000000000000000
-- 060:112121212121212121212121212121212121212121212121212131030004007181818181112121212121212121212121212121214120202020202020513180808080808080801121212121212121212121318686868686868686868686868686112121212121212121212121212121212131030000000000000000031121310c000075b6868686868686868686868686868683868611212121832121212121212121212121310000000000123200000000000000000000000000000000001222502140222232000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 061:112121212121212121212121212121212121212121212121212141202020202020202020512121212121212121212121212121212121212121212121213181818181818181811121212121212121212121412020202020202020202020202020512121212121212121212121212121212131030000000000000000031121310000007686868386868686868686868684868686868611212121212121402250212121218321310000000000000000000000000000000000000000000000000000112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 062:1121212121212121212121212121212121212121212121402222222222502121212121637321212121212121212121212121212121212121212121212131810c81818181818111212121212121212121212121212121212121212121212121212121212121212121212121212121212154310300000000000000000311214120202030868686868386868686860c8686102020202051212121212121310012502121212121310000000000000000000000000000000000000000000000000000122232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 063:112121212121212121212121212121212121212121214032718181818112222222502164742121212121212121212121212121212121212121212121214120202020202020205121212121212121212121212121212121212121212121212121212121212121212121402222222222222210203010203010203010203021212121214120202020202020202020202020512121212121212121212121310000122222222222320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 064:11212121212121212121212121212121212121212140320072b081818181818191122222222222502121212121212121212121212121212121212121212222222222222222222222222222222222222222222121212121212121212121212121402222222222222222320000000000112121213111213111213111213122225021212121212121212121212121212121218321212121214022222222320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 065:122222222222222222222222222222222222222222320500007282828282828292000500000000122222222222222222222222222222222222222222320000000000000000000000000000000000000000001222222222222222222222222222320000000000000000000000000000122222223212223212223212223200001222225021212121402222222222502121212121212183403200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 066:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001222222222320000000000122222222222222222320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 067:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c004c000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 068:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c004c000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 069:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010202020300000000000000000000000004c004c000000004c00000000000000000000000000000000000000000000000000000000000000000000000000
-- 070:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020203000000000000000000000000000000000102020205121212131000000000000000000000000000000000000004c00000000000000000000000600000000000000000000000000000000000000000000000000
-- 071:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010202020205121213185950000000000000000000000000000112121212121212131000000000000000000006979797979798900004c00000000000000000000000700000000000000000000000000000000000000000000000000
-- 072:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008d0000000000008d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001121212121212121318696000000000000000000000000007511212140222222223295000000000000000000000000f900000000000000000000000000000000000700000000000000000000000000000000000000000000000000
-- 073:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001121212121212121318696000075859500000000000000007612222232232323238696000000000000000000000000f9000000cadadadaea0000000000000000000700000000000000000000000000000000000000000000000000
-- 074:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008d00000000000000000000000000000000000000008d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000075125021212121402232879700007686960000000000007585b6232323238686868686a6950000001020300000000000f90000000000f900000000000000000000000700000000000000102030000000000000000000000000000000
-- 075:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008d00000000008d00000000008d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000076861121212121318696000000007686a695000000000076868686868686868686868686a685a7851121310000000000f90000000000f900758595000000000000000700000000758510512131000000000000000000000000000000
-- 076:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008d0000b700000000000000000000000000000000008d0000b700008d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007686122222222232869600000000768686a6950000000076868686868686868686868686868686861121310000000000f90000758585a785b68696000000000000102030a7a7a7b68611212131000000000000000000000000000000
-- 077:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b70000008d000000000000008d0000000000000000b7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000758585b686232323232323869600000000768694869600007585b6868683868686868686868686868686861121413000000000f900007613868686138696000000000000112141308686861051212131000000000000000000000000000000
-- 078:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b70000000000008d00000000000000000000000000b7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000768686868686868686868686a69500000076868686a68585b686868686868686848686868686868610202051212131fafafafa9a00001020308686102030000000751020512121412020205121214032000000000000000000000000000000
-- 079:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008d00b70000000000000000000000000000000000000000b7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000758585b6868686864c864c864c868686960000007686868686868686948686868686868686861e8686868611212121214032000000000000001121412020512131a7a785b61121212121212121212121213100000000000000000000000000000000
-- 080:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b70000000000000000000000000000000000000000b700000000000000000000000000000000000000000000000000000000000000c9d9e900000000000000000027007686868686868686868686868686868696000000768686861e86868686868686102020202020202020202051212121213100000000000000001250212121402232868686861121212121212121212121214130000000000000000000000000000000
-- 081:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b70000000000000000000000000000000000000000b70000000000080000000000000000000000000000000000000000000000000000f90000000000000000001020202020308686861020202020308686868696000010202020202020202020202020512121212121212121212121212121403200000000000000000011212121318686868686105121212121212121212121212131000000000000000000000000000000
-- 082:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099a9b9000000000000b70000000000000000000000000000000000000000b700000000000900000000000000000000000000000000c9d9d9d9e90000000000f9000000c9d9e90000001121212121413086861121212121412020202020202051212121212121212121212121212121212121212121212121212121310000000000000000000011212121311313131310512121212121212121402222222232000000000000000000000000000000
-- 083:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f900000000000000b70000000000000000000000000000000000000000b7040000102020203000000000000000006979797989000000f900000000000000f900000000f9000000001250212121214130871250212121212121212121212121212121214022222250212121212121212121212121212121214022320000000000000000000012222250412020202051212121212121212121310000000000000000000000000000000000000000
-- 084:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cadadadadadaea0000000000f900000000000000b7000000000000000000000000000000000000001020300000112121213100000000cadadadaea00f900000000aa9a0000c9d9d9d9d9d9e90000008afaba00000011212121212131000011212121212121212121212121212121213100000012502121212121212121212121212140223200000000000000000000000000000011212121212121212121212121214022320000000000000000000000000000000000000000
-- 085:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099a9b9000000000000f90000000000000000f900000000001020300000000000004c00004c00004c00000000001051214130001222504032000000000000f9000000f900000000f9000000000000f900f9000000000000f900000011212121214032000012222222225021212121402222222222223200000000122222502121212121212121212131000000000000000000000000000000000012225021212121212121212121213100000000000000000000000000000000000000000000
-- 086:0000102030000000000000000000000000000000000000000000000000000000c9d9e9000000000000001020300000000000f900000000000000f90000000000000000f900000000105121310000000000004c00004c00004c000000000011212121310000001232a6859500000000f9000000f900000000f9000000000000f900f9007585858585a785858511212121213100000000000000001222222222320000000000000000000000000000122222502121214022222232000000000000000000000000000000000000001222225021214022222250213100000000000000000000000000000000000000000000
-- 087:000011213100000000000000000000000000000000000000000000000000000000f900000000000000001121310000000000f900000000000000f90000000000000000f900000010516221318585858585858585858585858585858585851121212131858585b68686868685859500f9000000f91020202030858585858585a785a785b61313138686860e8611212121213100000000000000000000000000000000000000000000000000000000000000122222223200000000000000000000000000000000000000000000000000001222223200000012223200000000000000000000000000000000000000000000
-- 088:00105121310600000000000000000000000000000000000000000000c9d9e90000f9000000c9d9e900751250413000000000f900000000000000f90000000000000000f900000011212121413086860e86868686868686868686860e86105121212131868686868686868686869600f90010202051212121318686868686868686868686102030b58686868611212121403200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 089:0011212141300000000000000000001020300000000000c9d9e9000000f9000000f900000000f90000768611213100000000f900000000000014f91400000000aafafa9a00000012502121214120202020202020202020202020202020512121214032868686868686868686861020301311212121212121412020202020202020202020202020202020202051212140320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 090:001121212131000000000000001020512141203000000000f900000000f90000008aba000000f90000768611213100000000f900000000000010203000000000f900000000000000125021212121212121212121212121212121212121212121213186868686868686868686861121412051212121212121212121212121212121212121212121212121212121212131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 091:001121212141300000002700001121212121213100000000f900000000f900000000f9000000f97585b6861121312030fafa9a000000000000112131fafafafa9a000000000000102030212121212121212121212121212121212121216221214032868686868686a5878786861250212121212121212121212121212121212121212121212121212121212121212131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 092:001121212121412020202020205121212121213100000000f900000000f900000000f9000000f9768686861121312131000000000000000000122232000000000000000000000011213122502121212121212121212121212121212121212140328686868686a58797000077868612225021212121212121212121212121212121212121212121402222222222222232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 093:001121212121212121212121212121212121214130859500f900000000f900000000f9000000f9768686861121313030203000000000000000000000000000000000000000102030221020302250212121212121212121212121212140222232868686a58787970000000000778797001221212121212121212121212121212121212121214022320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 094:001222225021212121212121212121212121212131139600f9000010202020300000f9000000f9761313131121101020303100000000000000000000000000000000000000112131211121102010203010201020301020301020302232000077878787970000000000000000000000000012225021212121212121212121212121402222223200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 095:00000000122222502121212121212121212121214120202020202051212121413000f900001020202020205121111121312030000000000000000000000000000000000000121020301222112111213111211020301121102030310000000000000000000000000000000000000000000000001121212121402222222222222222320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 096:000000000000001222502121212121212121212121212121212121212121212141202020205121212121212121121222322131000000000000000000102030000000000010201110203010122212223212221121311222112131320000000000000000000000000000000000000000000000001222222222320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 097:000000000000000000112121212121212121212121212121212121214022222222225021212121212121212140321020301020301020301020301020112131301020301011211211213111213111213111211222320000122232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 098:000000000000000000122222222222502121212121212121212121403200000000001121212121212121212110201020301121311121311110203021122232311121311112223212223212223212223212223200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 099:000000000000000000000000000000122222225021212121212121310000000000001222225021212140222211211121311222321222321211213122321222321222321222320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 100:000000000000000000000000000000000000001222222222222222320000000000000000001222222232000012221222320000000000000012223200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 102:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 103:0000000000000000000000000000000000000000000000000000000000000000000075858585950000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007585950000000000004c00000000000000000000000000008d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 104:0000000000000000000000000000000000000000000000000000000000000000000076868686a6858585950000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000758585b686960000000000004c00000000000000000000008d00000000000000008d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 105:00000000000000000000000000000000000000000000000000000000000000758585b686868686868686960000000000000000000075858585950000000000000000000000000000000000000000000014141400000000000000000000000000000000000000000000000000000000007585858585b686868686960000000000004c0000000000000000000000000000b7008d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 106:00000000000000000000000000000000000000000000000000000000758585b686868686868686868686a685858595000000000075b6868686868585950000000000000000000000000000004c000000102030141414040000000000000000000000000000000000000000000000000076868686868686868686960000000000004c000000000000000000008d000000b70000008d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010203010203000000000000000000000
-- 107:00000000000000000000000000000000000000000000000000000000768686868686868686868686868686868686960000007585b686868686868686960000000000000004000000000000004c000000112131101020300000000000000000000000000000cadaea000000000000000076868686868686868686960000000000000000000000000000008d0000000000b70000000000000000000000000000000000000027000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011213111213100000000000000000000
-- 108:00000000000000000000000000000000000000000000000075858585b6868686868686868686868686868686868696000075b6868686868686868686868585950000001020202020300000004c00000012221011112131141400000000000000000000000000f90000000000000000007686868686868686868696000000000000080000000000000000000000000000b70000000000000000000000000000000310203010203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008585858512223212223210203000000000000000
-- 109:0000000000000000000000000000000000000000000000007686868686868686868686868686a5878787b5868686a68585b686868686868686868686868686960000001121212121310000004c00000010203012122210203000000000000000000000000000f900000000cadaea000076868686868686868686a6950000000000090000000000000000000000001414b70000000000000000000000000000000311212121213100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000768686868686868686868611213100000000000000
-- 110:00000000000000000000000000000000000000000000102030868686868686a587877686868686960000768686868686868686868686868686868686868686868585851121212121310000004c000000122232000000122232000000000000000000000000008afafaba0000f9000000768686860c868686868686a68585858510308585858585858595000075851010203085859500000000000000000000000312212121213200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000768686868686868686868612223200000000000000
-- 111:008d00000000000000000000000000000000000000001121310c868686868696000076868686869600007787b5868686868686868686868686868686868686868686861121212121310000004c00000043434300000043434300000000006979890000000000000000f90000f9000000761020202020308686a58787b586868611413086864c868686a685858686112121318686a685859500000000000000000310212121213000000000000000000000000000000000000000000000000000000069798900000000000000000000000000000000000000000076868686868686868686868610203000000000000000
-- 112:000000008d0000008d00000000000000000000000000122232868686a58787970000768686868696000000007686868686868686868787b586868686868686868686861121212121310000004c000000000000000000000000000000000000f9000000000000000000f90000f90000007611212121213187879700007786868612503186868686a58787b58686861021213086868686869600000000000000000311212121213100000000000000000000000000000000000000000000000000000000f90000000000000000000000000000000000000000000076868686868617868686868611213100000000000000
-- 113:000000000000000000000000000000000000008d00007686868686869600000000007686868686960000000077b586868686a5878700007686868686868686868686861121212121310000004c000000000000000000000000000000000000f9000000000000000000f90000f9000000102030222222320000000000000010203012328787878797000077878787112121318686868686960000000000000000031221212121320000000000c9d9e90000000000000000000000000000000000000000f90000000000000000000000000000000000000000000076868686868618868686868612223200000000000000
-- 114:00000000b7000000000000008d0000008d000000000076868686868696000000000076868686869600000000007686868686960000000076860c0c86868686868686861121212121310000004c000000000000000000000000000000000000f90000000099a9b90000f90000f90000001121312110203000000000000000112131960000000000000000000000001212223287b58686869600000000000000000310212121213000000000000000000000000000000000000000000000000000000000f90000000000000000000000000000000000000000000076868686868618868686868610203000000000000000
-- 115:00000000b700008d0000000000000000000000000000768686868686960000000000768686868696000000000076860c0c86960000000076102020300000000000000011212121213100000000000000000000000000000000000000000000f90000000000f9000000f90000f90000101222322111213100000000000000122232960000c9d9e900004c000000000005000500768686869600000000000000000311212121213100000000000000000000000000000000000000000000000000000000f90000000000000000000000000000000000000000000076868686868618868686868611213100000000000000
-- 116:00008d00b700000000008d000000000000008d00000076868686868696000000000076868686869600000000007610202030960000000077125040320000000000000011212121213100000000000000000000000000000000000000000000f90000000000f9000000f9001020301011122232211222320000000000000010203096000000f90000004c000000000000000000768686869600000000000000000312212121213200000000000000000000000000006979797989000000000000000000f90000000000000000000000697989000000000000000076868686868618868686868612223200000000000000
-- 117:00000000b70000000000000000000000b7000000000076868686868696000000000076860c0c869600000000007710203032970000000000001131000000000000000011212121213100040000000000000000001e00000000000000040000f900000010203000000010201121311112223221212110203010203010203010203096000000f90000004c000000000000000000768686869600000000000000000310212121211020302030000000102030000000000000f90000000000000000000000f9000000758585858500000000f900000085858510203010203010203010203010203010203000000000000000
-- 118:00000000b70000000000000000008d00b7000000000076868686868696000000000076102020309600000000000011213100000000000000001131000000000000001020302121212120202020202020202020202020202020202020202010203000001121310010201121121020122232212121211121311121311121311121319600aafa9a0000004c000000000000000000768686869600000000000000000311212121211121312131102030112131102030000000f90000000000000c00000000f9000000760000000085858585a785858500000011000000000000000000000000000000213100000000000000
-- 119:00000000b70000000000000000000000b7000000000076868686868696000000000077121020309700000000000010203000000000000000001131000000000000001121312121212121212121212121212121212121212121212121212111213110201222102011211222321121112131212121211222321222321222321222329600f900000000004c000000000000000000768686869600000027000000000312212121212121212121212121212121212131000000f90000000000697989000000f90075850000000000000000000000000000000012000000000000000000000000000000223200000000000000
-- 120:00000000b70000000000000000000000b700000000007686868686869600000000000000112131000000000000001121310000000000000000000000000000000000122232212121212121212121212121212121212121212121212121211222321121312111211222322121122212223221212121212121212121212121102030a685a7850000000000000000000000000000768686869600001020301020301020212121212121212121212121212121212132000000f9000000000000f900000000f90076000000000000000000000000000000000010000000000000000000000000000000211020300000000000
-- 121:00001020300000000000000000000000b70000270000768686860c869600000000000000122232000000000000001222320000000000000000000000000000000000102030212121212121212121212121212121212121212121212121212121111222322112223221212121212121212121212121212121212121212121112131868686869600c9d9d9d9e900000000000000103010201020301121212121211121212121212121212121212121212121212132858585a7858585000000f900000000f90076000000000000000000000000000000000011000000000000000000000000000000211121310000000000
-- 122:00105121413000000000000000000000b7001020202020202020308696000000000000000000000000000000000000000000000000000000000000000000000000001121312121212121212121212121212121212121212121212121212121211222322121212121212121212121212121212121212121212121212121211222328686868696000000f900000000101020303011212121212121212121212121302121212121212121212121212121212121213000000000000000858585a785858585a78576858585000000000000000000000000000012000000000000000000000000000000211222320000000000
-- 123:0011212121413000000000000000001020205121212121212121318696000000000000000000000000000000000000000000000000000000000000000000000000001222322121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121211020308686868696000000f9000000001121212121212121212121212121212121211021212121212121212121212121212121212131102030102030000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000211020300000000000
-- 124:0011212121214120203000000010205121212121212121212121318696000000000000000000000000000000000000000000000000000000000000000000000000001020302121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121211121318686868696000000f9008585851212221021212121212121212121212112221121212121212121212121212121212121212121212121212131102030102030102030000000000000000010203010203010203000000010000000000000000000000000000000211121310000000000
-- 125:0011212121212121214120202051532121212121212121212121203096000000000000000000000000000000000000000000000000000000000000000000000000001121312121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121211222328686868696000000f9008686868686861121212131112112223211122232001212223221212121212121212121212121212121212121212121212121212131112110203010201010203010203011213111213110203011000000000000000000000000000000301020300000000000
-- 126:0012502121212121212121212121212121212121212121214022213196000000000000000000000000000000000000000000000000000000000000000000000010203022322121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121211020308686868686858585a7858686868686861222212232122232000012223200001020302121212121212121212121212121212121212121212121212121212110203000000000000000000000000000000000000000000000000000000000000000000000000000311121310000000000
-- 127:000011212121212121212121212121212121212121214010203021319600000000000000000000000000000000000000000000000000000000000000000000001121312121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121112131868686868686868686868686868686868610213000000000000000000000001121312121212121212121212121212121212121212121212121212121212111213100000000000000000000000000000000000000000000000012102030102030102030102030321222320000000000
-- 128:000011212121212121214022222250212121214022102030213121312030102030102030102030102030102030102030102030102030102030102030102030101222322121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121122232000000868686868686868686868686868611213100000000000000000000001222322121212121212121212121212121212121212121212121212121212112221000000000000000000000000000000000000000000000000021112131112131112131112131000000000000000000
-- 129:000012502121212140223200000012225021213200112131223222322131112131112131112131112131112131112131112131112131112131112131112131112131212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121102030000000000000000000000000000000000012223200000000000000000000000000102030102030212121212121212121212121212110203010203010203010203021312131122232122232122232121000000000000000000020302232122232122232122232000000000000000000
-- 130:000000125021212131000000000000001222320000122210203000122232122232122232122232122232122232102030102030102030102030102010203010203010203010203020301020301020301020301020301020301020301020301020301020301020302121212121212121212121212121212121212121212121112131000000000000000000000000000000000000000000000000000000000000000000112131112131102030102030102030102030102011213111213111213111213122322232000000112131000000001100000000000000000021310000000000000000000000000000000000000000
-- 131:000000001121212131000000000000000000000000000011213100000000102030102030102030102030102030112131112131112131112131112111213111213111213110203010203010203021102030102030102030102030311121311121311121311121311020301020301020301020301020301020301020301020302232000000000000000000000000000000000000000000000000000000000000000000122232122232112131112131112131112131112112223212223212223212223200000000000000122232000000001222321222321020301222320000000000000000000000000000000000000000
-- 132:000000001250212132000000000000000000000000000012223200000000112131112131112131112131112131122232122232102030102030122212223212223212223211213111102030102030102030112131112131112131321222321222321222321222321121311121311121311121311121311121311121311121310000000000000000000000000000000000000000000000000000000000000000000000000000000000122232122232122232122232122232000000000000000000000000000000000000000000000000000000000000001121310000000000000000000000000000000000000000000000
-- 133:000000000012223200000000000000000000000000000000000000000000122232122232122232122232122232000000000000112131112131000000000000000000000012223212112131112131112131122232122232122232000000000000000000000000001222321222321222321222321222321222321222321222320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001222320000000000000000000000000000000000000000000000
-- 134:000000000000000000000000000000000000000000000000000000000000000000000000122232000000000000000000000000122232122232000000000000000000000000000000122232122232122232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP1>

-- <MAP2>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000637383000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001030405030405030405030405030405020
-- 002:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000103030502000000000000000006474840000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006272727272727272727272727272727262
-- 003:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006172726171000000008d00000065758500008d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006070727272727272726172726172726171
-- 004:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010303050303030303072725261000000000000b6c6232323808080008d0000000000000000000000000000000000000000000000000000000068788800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006272727272727272726172726172726171
-- 005:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060717072727272617072706171000000000000b7c7808080d6e6f6000000000000000000000000000000000000000000000000000000000000a080b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006070727272727272727272727272727262
-- 006:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008d0000008d000000000000000061707252727272727272725261000000000000b8c8808080d7e7f7000000000000000000000000000000000000000000000000000000000000a080b0000000000000000000000000000000000000000000000000006a7a8a00000000000000006a7a8a00000000000000000000000000000000000000000000006070727272727272727272727272727262
-- 007:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008d000000000000000000000000000000607062727272617262726261710c000000000000f6808080d8e8f80000008d0000000000000000000000000000000000000000000000000000a027b000000000000000000000000014141414140000000000000000009900000000000000000000990000000000000000000000000000000000000000000000001131415131415131415131415131415121
-- 008:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008d00b6c68080d6e680c6000000000000000011414141414141414141414121000000008d0000f7808080d9e9f9000000000000000000000000000000000000000000000000000000006373636373830000000000000000000003637373738300004c00000000000099000000006a7a8a00000099000000000000000000000000000000000000000006000000a0808080808080808080808080808080b0
-- 009:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b7c78080d7e780c78d00000000000000a08080818080809190c181b00000000000000000f7808080daeafa000000000000000000000000000000000000000000000000000000006494949594840000000000000000000003649594a484005d00000000001414991414000000990000000099000000000000000000000000000000000000000007000000a0808080d080d0808080808080808080b0
-- 010:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008d00000000008d000000b8c88080d8e880c80000000000000000a09090808080808080c190b000000000008d0000f81313138080808d0000000000000000000000000000000000009c000000000000001465949494946373830000000000000000036494949484000000000000006373737383140000990000141499141400000000000000000000000000000000000007000000a0809280d180d1809280809280809280b0
-- 011:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008d0000c98080d9e980c90000000000000000a090809280e0809280c180b00000000000000000006373838080800000000000000000000000000000000000005d00000000000000006373949494949474840000000000000000036494949484000000000000006494949463831400990014637373738300006979890000000000000000000000000007000000a0809380808080809380809380809380b0
-- 012:00000000000000000000008d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008d000000000000c8ca8080daea80ba0000000000000000a08080938080809380c190b0000000000000000000657585808080000000000000000000000000000000000000000000000000009c00649594949494a4948300000000000000000364949495840000000000000064a594949494831499146383a594948400000099000000000000000000000000000007000000a080808080d280808080808080808080b0
-- 013:000000000000008d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b680e6f68080f6d6e6f680808080808080a900000008000000a090808080d2808080c190b0000000000000000000637383a7a7a70000000000000000000000000000000000000000000000005d00006594a494949494948400000000000000000364a4949484000000000000006494a5949494a573737383949494948400000099000063738300000000000000000007000000a0808080808080808080808080808080b0
-- 014:000000000000000080808080808d0000008d0000000000000000000000000000000000008d000000008d0000008d000000000000008d00000000000000000000000000000000000000000000b780e7f78080f7d7e7f7637373737373637383000009000000a09080138080901313c190b000000000000000000065758500000000000000000000000c0000000000000000000000000000000000006394949494a59494830000000000000000036494949484000000000000006494949494949494949484949494a584000000990000647484000000000000637373837383001030303030303030303030303030303030
-- 015:00008d0000008d0080808d8080808080808000000000000000000000000000000000008d00000000000000000000000000000000000000000000000000000000006373830000000000000000b880e8f88080f8d8e8f8649494949494647484006373738310304050304050304050405060000000000c00000000637383000000000000000000005d000000000000000000000000000000000000006494949494a595948400000000000000000364949494840000000000000064949494949494949494949494949484000063738300656363630000000063647474847484003072727272727272727272727272727262
-- 016:8d008080808080808080808080808080d6e60000000000000000000000000000000000000000008da2000000000000000000008d000000000000000000000000006494848300000000000000b980e9f98080f9d9e9f964949463738365758500647474846170617170727272727271706163738363738363738364748400000000000000000000000000000000000000000000000000000000000065949494949494948500000000000000000364949495840000000000000064a59494946373839494946373837585000064748400006464646575637364757575857563006070727272727272727272727272726171
-- 017:0000b680d6e6f680b680e680f6f88080d7e70000000000000000000000000000000000000000000000008d000000008d00000000000000000000000000000000006594a48400000000000000ba80eafa8080fadaeafa64949464748400000000657575856070527272527272727272725264949494949494949465758500000000000000000000000000000000000000000000000000000000001463949494949494948300000000000000000364a49494840000000000000064949494946474849494946474840000000065758500000065756373837484636363636364001072727272727272727272727272727262
-- 018:0000b780d7e7f780b780e780f7f98080d8e8000000000000000000000000000000000000c68000000000008080800000008d000000000000000000000000000000c4659473830000000000aa8080808080808080808064637383758500000000000000627250507262727272727272626064949494949494949494748400000000000000000000000000000000000c00000000000000000000006373949494949494748400000000000000000364949494840000000000000064949494947575757575757575850000000000000000000000636474847585636363636400006070727272727272727272727272727262
-- 019:0000b880d8e8f880b880e880e8c68080d9e9a8000000000000000000000000000000008dc78098008d00808080d6e6000000000000000000002c00000000000000c563949484830000000080131380808080800c8080646474840000000000000000001060705272725272727262727252649494949494949494949484000000000000000000000000000000005d00000000000000000000141464749495a5949494758500000000000000000364949495840000000000000065757575850000000000000000000000000000000000000063646575637383636364640000006272727272727272727272727272726171
-- 020:0000b980d9e9f980b980e980b9c78080dafab9000000000000001c000000000000000000c88000000080808080d7e70000000000000000005d0000000000002c000065757585840000000063737373737373737373736365758500000000000000000052307272727272727272727261716494949494949494949494840000000000000000000000000000000000000000000000000000146373a594949495949494758500000000000000000364a49494840000000000000000000000000000000000000000000000000000000000000064637383647484646400000000001131415131415131415141415131415121
-- 021:0000ba80daeafa80ba80ea80baaa80808080a90000000000005d00000000000000000000c9800000f680c68080d6e68d00000000000000000000000000005d000000639465758500000063a59494949594949494948400000000000000000000000000607052727252626272725272725275757575756494949494948400000000000000000000000000000000000000000000000000006364749494949494949475850000000000000000000364949494840000000000000000000000000000000000000000000000000000000000000000647484657585000000000000000000000000000000000000000000000000
-- 022:00aa80808080808080808080808080808080809800000000000000000000001c000000000080a800f780c78080d7e700000000000000000000000000000000000000649483b0c400000064949474949494a47575758500000000000000000000000000527272727272727272727272723000000000006575949494748400000000000000000000000000000000000000000000000000006465759494a494949494637383000000000000000003649494a4840000000000000000000000000000000000000000000000000000000000000000656373830000000000000000000000000000000000000000000000000000
-- 023:aa808080808080808080808027808080808080a8000000a08080b00000005d0000000000aa8000008080c88080d8e8a9000000000000000000000000000000001414649484b0c500000065959494959495850000000000000000000000000000000000607052727252727272625272725200000000000000649494748400000000000000000000000000000000637383000000000000006575639494949494a49464748400000000000000000364949494840000000000000000000000000000000000000000000000000000000000000000006474840000000000000000000000000000000000000000000000000000
-- 024:63737373737383737373737373737373737383000000a080d280b0000000000000000000637383637383c98080d9e980980000000000000000000000636373837373a494a4830000000000649494949484000000000000000000000000000000000000113141513141513141513141512100000000000000656494637363738373637383637383637383647484657585847383637383637383647484649494948365758500000000000000000300000000840000000000000000000000000000000000000000000000000000000000000000006575850000000000000000000000000000000000000000000000000000
-- 025:647494949474a59474a4949474949474947484000000a0c09180b000000000000000000064959494a584808080daea8080a900000000637383919081649494949494949494840000000000657575757585000000000000000000000000000000000000000000000000000000000000000000000000000000006575647494949474949494949494747474949485949494946585949485949484657585657564748400000000000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 026:64949494949494949494949494a49494949484000600a0c180c0b0000000000000000000659494949485a78063737380808003637383647484131313657575757575757575850000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000647494949474949494949494949494949494949494949494949494949484000000000065758500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 027:64a595949494949494949494949494949494a5836373737373736373737373737373738363a594949483008080658473808003647484657585637383637383000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000649494949494949494949494949494949494949494949494949494949484000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 028:649494949494949494949494949494949495949494946494949494949494949494949494a4949494958400a7a7a78584468003657585647484647484647484000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000649494949494949494949494949494949494949494949494949494949484000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 029:64a594949494949494949494949494949494949494946495949494949494949494949494a59494a49485000000000084808003657585657585657585657585000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000657575757575757575757575659494949494949494949494949494737585000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 030:6575757575849494949494949494949494949494949563a594949494949494948575637394949494a573830000000085a7a703637383637383637383000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000649494949494949494949494949473850000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 031:00000000658575757575759494949494947575959494a594949494949494758500006494949494949494840000000000000000647484647484647484000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000657575756594949494949494949484000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 032:000000000000000000000065756575758500c56494949494957575757585000000006575856575856575850000000000000000657585657585657585000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006575757575757575757585000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 033:00000000000000000000000000000000000000657575657585000000c500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 034:003050304050405030405040505030405050304050405030505030405040503050304050405030405040505030405050304050405030304030405030405030405030405030304050304050303040503040503030405030405030304050304050303040503040503020000000000000000000000000003040503040503040503040503040503040503040503040503040304050405030405030405030405030405040503040503040500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 035:008262727262727272726272627272726272727262726272627272726272627272727262727272726272627272726272727262726272000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000032000000000000000000000000006070526272727272727272727272526272727272727272727272727272727272727272727272727272727272727272727261710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 036:006262725272527272527252727272527272725272527252727272527252725272725272527272527252727272527272725272527252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000032000000000000000000000000006070727272727272727272727272727272727272526272727272727272727272727272727272727272727272727272727272320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 037:008252727272727272527252720000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000032000000000000000000000000004272727252624151314151515131413131415172727272727272727272727272727272727272727272727272727272727272320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600000000000000
-- 038:0062627272727272725272527200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000320000000000000000000000000060707272617180808080808080808080808003427272727272727272727272727272727272727272727272727272727272617100000000000000000000000000000000000000000000000000000000000000008d8080808080808d808080808d800000008d000000000000000000000000000700000000000000
-- 039:008252727272727272527252720000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000032000000000000000000000000006070727272f48080808080808080808080800342727272727272727272727272727272727272727272727272727272727272320000000000000000000000b4b4b40000000000000000000000000000000000008080808d808080808080808080808080f698000000000000000000000000000700000000000000
-- 040:006262727272727272527252727252725272627272527252727252725272527261000000000000000000000000000000000000000000005252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000032000000000000000000000000004272727272f480808080808080808080808003427272727272727272727272727272727272727272727272720a7272727272320000000000000000000000687888b4b4b400000000000000000000000000008db6808080808080808080808080808080f7008d0000000000000000000000000700000000000000
-- 041:008252727272727272527252727272727272726272727272627272727272727260000000000000000000000000000000000000000000007252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006171000000000000000000000000000172727272f4808080808010304020808080034272727272727272727272727272727272727272727272727272727272727232000000000000000000b4b4808080808080b4b4b4b40000000000000000000000b7808080808080808080808080808080f800000000000000000000000000000700000000000000
-- 042:008262722131415131415131415141513141517072615141513141514151314121727272627272727262726272727262727272727262727252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000032000000000000000000000000006070727272f4808080808060707203808080034272727272727272727272727272727272727272727272727272727272726171000000000000000000808080808080808080808080b4b4b4b4b4b4b40000008db8808080808080808080808080808080f9a8000000000000000000000000000700000000000000
-- 043:0062627271a1808067808080908080678080804272328080808081808080808080727252725272725272527272725272727252725272527252314151314151314151314151314151314151314151314141513141510000000000000000000000000000000000000032000000000000000000000000004272727272f4808080808052727203808080034272727272727272727272727272727272727272727272727272727272726171000000000000b4b4b48080808080808080808080808080808068788800000000b98080809680808080808080a6808080fa00000000000000000000000000000700000000000000
-- 044:008252627180807666768080808076667680804272328080808080808080808080627272727262727272727262727272627272727272726171809080808080808080808080808080809080808080808080808080906070000000000000000000000000000000006171000000000000000000000000004272727272f48080808080d4727203808080034272415131415151314151314151314151314151314151c2c2c2c2c231415121b4b4b4b4b4b4687888808080808080808080c3c3c3c3c3808080808000000000ba8080809780808080808080978063738300000000000000000000000000637383000000000000
-- 045:006262722080807780778080808077807780804272328080808080808080808080113131e5e5e5e5e5e5314151314151313130727272727220808080808080808080808180808080808080808080808080808080806200000000000000000000000000000000006171000000000000000000000000006070727272f48080808080d47272038080800342328080808080808080808080808080808080808080808080808080808080808080808080808080808080c3c3c3c3c3c3c30000000000c3c3808080b4b4b4b4637383637383878787878763738364748400000000006373830000000000647484000000000000
-- 046:008252727180808080808080808080808080804272328080808080808080808080a180808080808080808080808080808080427272727261718080d0d08080a2b280d0d0808080808080d0d080a2b28080d0d08080607000000000000000000000000000000000003200000000000000000000000000114131410121c3c3c3c3c3d47272038080800342328080808080808080808080808080808080808080808080808080808080808080808080808080808080000000000000000000000000000080808080808080647484647463738363737364748465758500000000006474846373836373657563738300000000
-- 047:0062626220808080808080808080808080808042723280808080808080808080808080808080808080808080808080808080307252727261718080d1d18080a3b380d1d1808080808080d1d180a3b38080d1d180806200000000000000000000000000000000000032000000000000000000000000000000000000000000000000d4727203808080034232808080808080808080808080808080808080808080808080808080808080808080808080808080c3c30000000000000000000000000000808080c3c3c3c3657585657564748463737383758564748400000000006373836474846474840064748400000000
-- 048:008272522080808080808080908080808080801131218080808081808080808080808080808080808080808080808080808042727272727220808080808080808080808080914757808080808080808080808090806070000000000000000000000000000000000032000000000000000000000000000000000000000000000000d472720380808003112180808080808080808080808080808080808080808080808080808080808080806878888080808000000000000000000000000000000000c3c3c300000000000000637383637364747484a7a765758500000000006474846563736575850063738300000000
-- 049:0062726171808080808090a2b2909080808080808080808080a2b28180808080808080808080801030303030302080808080307272727272f480808080808080808080808080485891919080808080808080808080420000000000000000000000000000000000617100000000000000000000000000000000000000000000000060707203808080808080808080808080808080808080808080808080808080808080808080808080808080808080c3c3c30000000000000000000000000000000000000000000000008d00647484647465757585000000008d00000000006575850064748400000064748400000000
-- 050:008272522080809280d080a3b380f08092808080d080808081a3b3b1b18080d0808080808080803072727272725080808036d47272727272f4808080801313131380808180808080809080808080808080808080804200000000000000000000000000000000000032000000000000000000000000000000000000000000000000427272038080808080808080808080808080808080808080808080808080808080808080808080808080808080800000000000000000000000000000000000000000000000000000000000657585657585000000000000000000000000000000000065758500000065758500000000
-- 051:007272617180809380d180809080f19093808080d180808080818080808080d180808080808080607072727272f480808080d472727272725280808003603040304030403040e3e3e3e3e3e3e3e3e3e3f38080808060700000000000000000000000000000000000320000000000000000000000000000000000000000000000006070720380808080808080808080808080808080808080808080808080808080808080808080802780808080808000000000000000000000000000000000000000000000000000000000000000637383000000000000008d000000000000008d000000000000000000000000000000
-- 052:008262722080808080808080808080808080808080808080808080808080808080808080808080527272727272f480808080d47272727272328080800352727272727272727272727272727272727272f446808036420000000000000000000000000000000000617100000000000000000000000000000000000000000000000042727203808080808080808080808080808080808080808080808080808080808080808080803040508080808080000000000000000000000000000000000000000000000000000000000000006474840000000000000000008d00008d000000000000000000000000000000000000
-- 053:00627272628080d28080808080808080d2808080808080d280808091d2b1808080808080808080015272727272f480808080d47272727272328080800310727272727272727272727272727272727262f480808080607000000031415131415141314151413141512100000000000000000000000000000c0000000000000000004272720380808080808027808080808080808080808080808080808080808080808080808080d47032c3c3c3c3c300000000000000000000000000000000000000000000000000000000000000008d0000000000008d0000000000000000000000008d000000000000000000000000
-- 054:00827261710680808080808080278080808080808080808080b191b18080808080808080800c80607072727272f480808080607072727261718080800342727272727272727272727272727272727272f4808080804200006171808080808067808080808080ad80b0000000000000000000000000005d000000000000000000006070723230405030304050304050304050808080808080808080808080808080808080808080d400320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008d000000000000000000000000000000000000000000
-- 055:00826272203030304050303040504050304050e3e3e3e3e3e3e3e3e3e3e3e3e3e3303040304050525272727272f480808080527272727272328080800360707272727272727272727272727272727272f48080808042000000328080808076667680808080808080b0000000000000000000000000000000000000000c000000004272723200000000000000000000000061718080808080808080808080808080808080808080d4003200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 056:006262627262727272627272727272627262727272727262727272727262727272727272627272607072727272f480808080015272727272208080800352727272727272727272727272727272727262f48080808060700061718080808077777780808080808080b00000000000000000000000000000000000005d00000000004272723200000000000000000000000000617180808080808080808080808080808080808080d40032000000000000000000000000000000000000000000000000000000000000000000000000008d0000000000000000000000000000000000000000000000000000000000000000
-- 057:005272727272727272727272627252725272727262725272527262725272527262725272527262725272727272f480808080607072727261718080800310727272727272727272727272727272727272f48080808011314151218080808080808080808080808080b00000000000000000000000000000000000000000000000004272723200000000000000000000000000006171808080808080808080808080808080808080d4703200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 058:008272520000000000000000000000000000000000000000000000000000000000000000000000000000727272f480808080113141513141518080800352727272727272727272727272727272727272f48080808080808080808080808080808080808080808080b00000000000000000000000000000000000000000000000004272723200000000000000000000000000000061718080808096808780a68080808080808080d4003200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 059:007272610000000000000000000000000000000000000000000000000000000000000000000000000000727272f480808080808080808080808080800342727272727272727272727272727272727272f48080808080808080808080808080808080808080808080b00000000000000000000000000000000000000000000000004272723200000000000000000000000000000000617180808097809780978080808080808080d4703200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 060:008262720000000000000000000000000000000000000000000000000000000000000000000000000000727272f480808080808080808080808080800360707272727272727272727272727272727272f48080808080808080808080808080808080808080808080b0000000000000080000000000000000000000000000000000607072320000000000000000000000000000000000617130405030405030405030303030303062003200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 061:006272720000000000000000000000000000000000000000000000000000000000000000000000000000527262f480808080808080808080808080800360707272727272727272727272727272727272f48080808080808080808080808080808080808080808080b0000000000000090000000000006373636373830000000000427272320000000000000000000000000000000000000000000000000000000000000000000000003200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 062:008272610000000000000000000000000000000000000000000000000000000000000000000000000000727272f48080808080808080808080808080037272727272525252727252727272727272525232131313133030303030304050304050304050304050304050000063738363736373837383637383646474846373836373427272320000000000000000000000000000000000000000000000000000000000000000000000003200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 063:008262720000000000000000000000000000000000000000000000000000000000000000000000000000000000203030303050305050305030503030400000000000000000000000000000000000000072303030300000000000000000000000000000000000000000000064748464746474847484647484656575856474846474427272320000000000000000000000000000000000000000000000000000000000000000000000003200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 064:006262620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065756365756575857563657585856373836575856575427272320000000000000000000000000000000000000000000000000000000000000000000000003200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 065:005272720000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006474846575850064748400006474840000000000427272320000000000000000000000000000000000000000000000000000000000000000000000003200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 066:008262727272727262727262727272727272726272727272726272727272727272727272727272727272000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006575850000000065758500006575850000000000607072320000000000000000000000000000000000000000000000000000000000000000000000003200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 067:005131415131415131415131415141513141513141514151313141514151314151514151314151514151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000607072320000000000000000000000000000000000000000000000000000000000000000000000003200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 068:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000063738300000000000000000000000000000000000000000000000000000000
-- 069:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c00000000000000000000000000000000000000000000000000000000008363738300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000064748400000000000000000000000000000000000000000000000000000000
-- 070:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006373836373836373836373830000000000000000000000000000000000000000000000006373838400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065758500000000000000000000000000000000000000000000000000000000
-- 071:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006373836373836373830000000000000000000000000000000000000000000000000000006474846474846474846474849c00000000000000000000000000000000000000000000006474848500637383000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000063738300000000000000000000000000000000000000000000000000000000
-- 072:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006373647383846474840000000000000000000000000000000000000000000000000000006575856575856575856575850000000000000000000000000000000000000000000000006575856373837484000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000064748400000000000000000000000000000000000000000000000000000000
-- 073:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006373637383637383637383000000000000000000000000000000000000000000000000000000000000000000009c000000000000000000000000000000000000000000000000000000d464746474847383006373830000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065758500000000000000000000000000000000000000000000000000000000
-- 074:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006363736373647383846474840000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d465756575857463738374840000000000000000000000000000000000000000000000000000000000000000000000000063738300000000000063738300000000000000000000000000000000000000000000000000000000
-- 075:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006364746474657484856575850000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d46373657585756474847585830000000000000000000000000000000000000000000000000000000000d3e3f30000000064748400000000000064748400000000000000000000000000000000000000000000000000000000
-- 076:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006474657463738363738363738300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000637383000000000000000000d4647484647463657585637383000000000000000000000000000000000000000000000000000000009cd472f49c00000063738300000000000065758500000000000000000000000000000000000000000000000000000000
-- 077:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a080637363736473838464748400000000000000000000000000000000000000000000000000009c0000000000000000000000000000000000000000000064748414000000000000004cd4657585657564748483647484000000000000000000000000000000000000000000000000009c00b4b4d5e5f50000000064748400000000000063738300000000000000000000000000000000000000000000000000000000
-- 078:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b4b4b4b4b4b4b4b4b4b4808063736474657484856575850000000000000000000000000000000000009c000000000000637383637383637383637383000000000000000000006373656373831414000000000000d4637383636365758584657585000000000000000000000000000000000000000000000000d3e3f3808080b0000000000065758500000000000064748400000000000000000000000000000000000000000000000000000000
-- 079:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000068787878787878788880808064746574848565758500000000080000000000000000000000000000006373830000009c6474846474846474846474849c000000637383000014647484647463738335000000004cd4647484646474847563738300000000000000000000000000000000000000000000b4b4b4d472f480b180b0000000000063738300000000000065758500000000000000000000000000000000000000000000000000000000
-- 080:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0928080918091928080c3c36575857585f20000000000000009000000000000006a7a7a7a8a0000006474849c0000006575856575856575856575851a2a00006474841414637383636575647484000000000000d46575856565758574647484000000000000000000000000000000000000000000a0928080d5e5f5c3c3c300000000000064748400000000000063738300000000000000000000000000000000000000000000000000000000
-- 081:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a09390809680909380b000000000000000f2000000000000000900000000000000000099000000000065758500000000000000009c0000000039808080801a1a63738373836474846463736575f400000000004cd46373836463738375657585000000000000000000000000000000000000000000a09380c3009c0000000000000000000063738300000000000064748400000000000000000000000000000000000000000000000000000000
-- 082:000000000000000000000000008d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a091b1809780908080b000000000000000f20000000000000009000000637383000000990000000000009c00000000000000000000000000003a80808080806373838474636575637383746373f4000000000000d46474846563738300000000000000000000000000000000000000000000009c00a080b00000000000000000000000000064748400000000000065758500000000000000000000000000000000000000000000000000000000
-- 083:000000000000000000008d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000637383637383738363738300000000000000f2000000000063738363738363738300000099000000000000000000000000000000000000000000003a808080806474848375647484647484756474f400000000004cd4657585636474840000000000000000000000000000000000000000000000d3e3f380b00000000000000000000000000065758500000000000063738300000000000000000000000000000000000000000000000000000000
-- 084:0000000000000000000000000080008d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c9c9c00000064748464748474846474840c000000000000f20000000000d474846474846474840000009900000000000000000000000000000000000000000000003a4a4a4a6575858463738363657585846575f4000000000000d464748464657585000000000000000000000000000000000000000000009cd472f480b00000000000000000000000000063738300000000000064748400000000000000000000000000000000000000000000000000000000
-- 085:000000000000000000ca008d0080800000008d0000000000000000000000000000000000000000000000000000000000000000000000000000000000637383000000657563656373637383758500000000000000f20000000000d475856575856575850000000000000000000000000000000000000000000000000000000000000000657563738384647484637383830000000000004cd4657585657585000000000000000000000000000000000000000000000000d5e5f580b00000000000000000000000000064748400000000000065758500000000000000000000000000000000000000000000000000000000
-- 086:00000000000000000000b8c8d880808098000000a8000000000000000000000000000000000000000000000000000000000000009c00000000000000647484000000000064746463646373830000000000000000f20000000000d4000000000000000000000000000000000000000000000000000000000000000000000000000000000063647484856575856474848400000000000000d4637383637383000000000000000000000000009c00000000000000000000a080b000000000000000000000000000000065758500000000000063738300000000000000000000000000000000000000000000000000000000
-- 087:0000000000000000000000c9d98080800000000000000000000000000000000000000000000000000000000000000000000000006373830000000000657585000000000065756363636373830000000000000000f20000000000d400000000000000000000000000000000000000000000000000000000000000000000000000000000006465758500637383657585850000000000004cd4647484647484b4b4b410304050503040503030405020b400000000000000a08091b0000000000000000000000000000063738300000000000064748400000000000000000000000000000000000000000000000000000000
-- 088:000000000000000000000000008080809800000000000000000000000000000000000000000000000000001c00000000000000006474840000000000000000000000000000006463646373830000000000000068788800000000d400000000000000000000000000000000000000000000000000000000000000000000000000000000006575850000647484a18080b000000000000000d4657585657585a180806070526272527272727272617180b4000000000000a08090b0000000d3e3f3000000000000000064748400000000000065758500000000000000000000000000000000000000000000000000000000
-- 089:000000000000000000000000aa80808000000000000000000000000000000000000000009c00000000005d0000000000000000006575859c00000000000000000000000000006364636474840000000000000000000000000000d400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000657585808080b000000000000000d46474846373838080806070727272727272625272617180b00000000000a08080b00000009cd472f49c0000000000000065758500000000000000000000000000000000000000000000000000000000000000000000000000
-- 090:0000000000000000000000aa80808080a9000000000000000000000000000000000000006373830000000000000000001c0000000000000000000000000000000000000000006465646575850000000000000000000000000000d4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0808091b000000000000000636575856474848080801141513141513141513131412180b00000000000a08080b09c00b4b4d5e5f5000000000000000063738300000000000000000000000000000000000000000000000000000000000000000000000000
-- 091:0000000063738363738363738380802780a9000000b4b4b4b400000000009c0000b4b4b464748400000080b00000005d00000000000000000000000000000000000000000000637363738300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0808080b00000000000000064748484657585808080809c8080b0000000a08080808080b0000000000000a080d3e3f380928080b0000000000000000063738300000000000000000000000000000000000000000000000000000000000000000000000000
-- 092:0000000064748464748464748463736373836373838080808063738363736373838080806575850000000000000000000000000000000000000000000000000000000000000064748400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a09180b000000000000000657585850000a080808080808080b0000000a08080808080b00000009c0000a080d472f480938080b0000000000000000064748400000000000000000000000000000000000000000000000000000000000000000000000000
-- 093:000000636575856575856373836474647484647484808080806474846474647484c3c3c300009c0000000000000000000000000000000000000000000000000000000000000065758500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a08080b000000000000000a080b1b00000a080808080808080b0000000a0808080808080b490b4d3e3f380c3d5e5f58080c3c300000000000000000065758500000000000000000000000000000000000000000000000000000000000000000000000000
-- 094:00000064746364748474647484657565758565758580808080657585657565758500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000063738300000000000000a08080b00000a0808080802c8080b0000000a08080802c8080808080d472f4b000009c00c3c3000000000000000000000063738300000000000063738300000000000000000000000000000000000000000000000000000000
-- 095:000000657564657585756373836474637383637383c3c3c3c3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000064748400000000000000a09180b00000a08080805d808080b06a7a8aa080805d8080808080c3d5e5f500000000000000000000000000000000000064748400000000000064748400000000000000000000000000000000000000000000000000000000
-- 096:00000000006575637383647484637364748464748400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065758500000000000000a08080b000637383808080808080b0009900a080808080808080b000009c0000000000000000000000000000000000000065758500000000000065758500000000000000000000000000000000000000000000000000000000
-- 097:000000000000006474846373836463738373837585000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000637383637383637363738363736373647484808080808080b0009900a080808080808080b00000000000000000000000000000000000000000000063738300000000000063738300000000000000000000000000000000000000000000000000000000
-- 098:000000000000006575856474846563738374840000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000647463738384646373838464746463657585131313131313131399131313131313131313b00000000000000000000000000000000000000000000064748400000000000064748400000000000000000000000000000000000000000000000000000000
-- 099:000000000000000000006575647484748475850000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000657564746373836474846373836364748483304050304050304050304050304050304050b00000000000000000000000000000000000000000000065758500000000000065758500000000000000000000000000000000000000000000000000000000
-- 100:000000000000000000000000657585758500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065756474846575856474846465758552627262725262725262725262725262726171b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 101:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006575850000006575856575855262727252627252627252627252627252626171b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP2>

-- <MAP3>
-- 001:0000000000000000000000000000000000000000000000000000000000000000000000004c0000000000000000000000000000000000000000000000000010202020202020202020202020203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:0000000000000000000000000000000000000000000000000000000000000000000000004c0000000000000000000000000000000000000000000000000000000022222222222240404040213100000000000000000010203000000000000000000000000000000000000000000000001313131313131313131313131313131313131313131313130000000000000000000000000000001020301020300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:0000000000000000000000000000000000000000000000000000000000000000000000004c0000000000000000000000000000000000000000000000000000000000000000000010404040403000000000000010203011213100000000001020202020202020202030000000000000001020301020301020301020301020301020301020301020301020301020301020301020301020301121311121311020301020301020300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000
-- 004:0000000000000000000000000000000000000000000000000000000000000000000000004c0000000000000000000000000000000000000000000000000000000000000000000011214040213100000000000011213112223200000000001121404040404040402131000000000000001121311121311121311121311121311121311121311121311121311121311121311121311121311222321222321121102030311121310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000
-- 005:0000000000000000000000000000000000000000000000000000000000000000000000004c00000000000000000000000000000000000000000000000000000000000000ebebeb12224040403200000000000012223210203000000000001140404040404040404031c7c7c7c7c7c7c7122232102030201020302030122232102030201020302030122232122232122232122232122232c8c8c8c8c8c81222112131102030320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000
-- 006:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c4c000000000000000000ebebeb10204040203000000000000010203010203030000000001121404041414040404031c8c8c820c8c8c8102030112131211121312030000000b8c8c8c8c8c8c81dc8c8c8c8c8c81dc8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8122232112131d80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000
-- 007:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c4c0000000000000000102030ebebeb11404040403100000000000010203011213132000000001140404051404040404031c8c8c81cc8c8c8112110121020301222322131000000b8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8122232d80000000000000000000000000000001020203000000000000000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000
-- 008:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c4c00000000000000000000112131ebebdb12224040403213131313131311213112223200000000001121404040404040404031c8c8c8c8c8c8c8122211211121312131122232000000b8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8d8000000000000000000000000000000111c213100000000000000000000000010202030000000000000000000000000000000000000000007000000000000000000000000000000000000
-- 009:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c4c000000000000000000102030122232ebebdb10204040403010203010203012223200000000000000104040404040405040404031c8c8c8c8c8c8c8102012221222322232000000000000b8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8d800000000000000000000000000000012112132000000000000000000000000111c2131000000000000000000000000000000000000000007000000000000000000000000000000000000
-- 010:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c4c0000000000000000000000112131102030ebebdb112140404031112131112131fbfb0000000000000000124040404040514140404031c8c8c8c8c8c820112110203011213100000000000000b8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c9c9c9c9c8c8c8c8c8c8c8c8c8d80000000000102020300000000000000012223000000000000000000000000012222232000000102030102030000000000000000000001020300000000000000000000000000000000000
-- 011:00000000000000000000000000000000000000000000000000000000000000fb102030102030102030000000000000cb0000000000000000000000db0000122232112131ebebdb122232124032122232122232fbfbfbfb000000000000001140404040404140404031c8c8c8c8c8c820122211213112223200000000000000b8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8d9ebebebebb9c8c8c8102030c8c8d80000000000111c21310000000000000000213100001020202030000000000000002131000000112131112131000000000010203010201121311020300000000000000000000000000000
-- 012:000000000000000000000000000000000000000000000000000000000000fbfb112131112131112131000000000000cb0000000000000000000000db0000122232102030ebdbdb102030102030102030102030fbfbfbfb000000000000001140404040404040404031c8c8c8c8c8c8c8102012223212223200000000000000b8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c845c8d8ebebebebebebc8c8c8112131c8c8d800000013131222223200000000000000002030000011211c4031000000000000002232000000121020122232000010203011213111211222321121313000000000000000000000000000
-- 013:000000000000000000000000000000000000000000000000000000000000fbfb122232122232122232000000000000cb0000000000000000000000db0000102030112131ebdbdb112131112131112131112131fbfbfbfb000000000000001140405140404040404031c820c8c8c8c8c8112131101222320000000000000000102030102030102030102030102030102030102030102030ebebebebebeb1020301222321020300000001020310000000000000000000020303100001222224031000000000000000000000000001121310000000011213112223212223211211222323100000000000000000000000000
-- 014:000000000000000000000000000000000000000000000000000000000000fbfb112131102030203000000000000000000000000000000000000000db0000112131122232ebdbdb122232122232122232122232fbfbfbfb001020202020204040404150404040404031c8c8c8c820c8c8122232111121310000000000000000112131112131112131112131112131112131112131112131ebebebebebeb1121311121311121310000001140310000000000000000000011213020302030114031130000000000000000000000001222320000000012223212223212223212223212223200000000000000000000000000
-- 015:000000000000000000000000000000000000000000000000000000000000fbfb121020112131213113000010203000000000000000000000000000db0000122232112131000000cbcbcbcbcbcbcbcbcbcbcbcbfbfbfbfb102232404040404040414140404040404031c8c8c8c8c8c8c8102030121222320000000000131313122232122210203032122232122232122232122232122232ebebebebebeb1222321222321222320000001141310000000000000000000012223121112131114140300000000000000000000000000000000000000010203010203010203010203010203000000000000000000000000000
-- 016:000000000000000022000000000000000000000000000000000000000000fbfb101121122232102030000011102030000000000000000000000000db0000102030122232000000cbcbcbcbcbcbcbcbcbcbcbfbfbfbfbfb102030404040404040404040404040404031c8c8c8c8c8c8c8112131112131000000000000102030102030102030303100000000000000000000000000102030ebebebebebeb1020300000000000000000001222320000000000000000000000112120212121212141310000000000000000000000000000000000000011213111213111213110203011213100000000000000000000000000
-- 017:000000000000000000000000000000000000000000000000000000000000fbfb111222102030112131130012112131000000000000000000000000000000112131102030000000cbcbcbcbcbfbfbfbfbfbfbfbfbfbfbfb112131404040404040404040222222102030c8c8c8c8c8c8c8122232122232000000000000112131112131112131313200000000000000000000000000112131ebebebebebeb1121310000000000000000000000000000000000000000000000122221222222221131000000000000000000000000000000000000000012223210203012223211213112223200000000000000000000000000
-- 018:000000000000000000000000000000000000000000000000000000250000fbfb1210201121311210203010201222323010200000000000000000000000001222321121310c0000fbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfb122222222222222222222232000000112131c8c8c801c8c8c8c8c8d8000000000000000000122232122210122232320000000000000000000000000000122232ebebebebebeb1222320000000000000000000000000000000000000000000000001121000000001121000000000000000000000000000000000000000000000011213120301012223200000000000000000000000000000000
-- 019:000000000000000000009000000000000000000000000010203010203010203010112112223230112131112110203031112100000000000000000000000010203012223200000000000000000000000000000000000000000000000000000000000000000000122232c8c8c81cc8c8c8c8c8d8000000000000000000112131102011213100000000000000000000000000000000000000ebebebebebeb0000000000000000000000000000000000000000000000000000001222000000001121000000000000000000000000000000000000000000000012223221311121310000000000000000000000000000000000
-- 020:000000000000000000009100900000000000000010203011213111213111213111122232112131122232102011213110203020302232102030102030102011213100000000000000000000000000000000000000000000000000000000000000000000000000102030c8c8c8c8c8c8c8c8c8d8000000000000000000122232112112223200000000000000000000000000000000000000ebebebebebeb0000000000000000000000000000000000000000000000000000000000000000001222000000000000000000000000000000000000000000000000001222321222320000000000000000000000000000000000
-- 021:000000060000000000009190910000000000270011213112223212223212223212102030122232102030112112223211213121311020302131112131112112223200000000000000000000000000000000000000000000000000000000000000000000000000112131c8c8c8c8c8c8c8c8d8000000000000000000001020301222320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010203000000000000000000000000000000000000000
-- 022:0000001020202020202020202030000000102030122232102030102030112131101110201121311121311222320000122232223211213122321222321222320000000000000000000000000000000000000000000000000000000000000000000000000000001222c8c8c8c8c8c8c8c8c8d8000000000000000000001121311020300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011213100000000000000000000000000000000000000
-- 023:0000001140404040404040404031000000112131112131112131112131102030111211211210203022320000000000000000000012223200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010c8c8c8c8c8c8c8c8c8d800000000fb00fb00fb001222321121310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012223200000000000000000000000000000000000000
-- 024:000000122250404040404040221020301020303212223212223212223211213112221010201121310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111020c8c8c8c8c8c8c8c8c8d80000000000000000001020301210203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 025:00000000001210203022223210203010203010203020301020301020301222321020111121122232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012112131c8c8c8c8c8c8c8c8d8000800fb90fb90fb001121311111213100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 026:000000000000112030102030112110203031112131213111213111213110203011211212223200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001222102030c8c8c8c8c8c8d80009000091009100001222321212102030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 027:000000000000122131112131102011213100000012223212102030221020303112221222320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000112110203010203010203010203010203010203010203010112131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 028:000000000000000000112030112110203000000000000000112131201121313200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000122211213111213111213111213111213111213111213111122232310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 029:000000000000000000121020302011213100000000000000122232211222320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012223212223212223212223212223212223212223212221222320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 030:000000000000000000001121312030000000000000000000000012223200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 031:000000000000000000000000112100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 032:000000000000000000000000123200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 035:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055657555657555657565755565755565750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 036:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056667656667656667666765666765666760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 037:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000057677757677757677272727272727272770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 038:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000556575556575556575557272000000000072750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 039:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000567272726676566676567272000000000072760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 040:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000727272727272727272727272000000000072770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 041:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002b0000000000000000007272000000000072750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 042:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002b0000000000000000007272000000000072760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 043:000000000000000000000000000000000000000000008383838383727272724b4b4b4b4b4b4b000000000000000000000000000000002b000000000b0000000072724b4b4b4b4b72727200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 044:000000000000000000000000000000000000000000007272727272727272720000000000004b000000000000000000000000000000002b0000000000000000000000001d1d1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 045:000000000000000000000000000000000000000000000000e0e0e0727272720000000000004b000000000000000000000000000000002b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 046:000000000000000000000000000000000000000000000000e0e0e0727272720000000000004b000000000000000000000000000000002b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 047:0000000000000000000000000000000000000000000000e0e0e0e0e07272720000000000004b000000000000000000000000000000002b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 048:0000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e02b00000000004b0000000000000000004b4b4b4b4b4b4b4b7272727272727272727272727272727272727272727200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 049:0000000000000000000000000000000000000000000000e0e0e00be0e0e0e02b00000000004b4b4b4b0000000000004b000000000000005666765666765666765666765666760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 050:0000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e02b0000000000000000000000000000004b000000000000005767775767555767775767775767770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 051:0000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e02b0000000000000000000000000000004b000000000000000055657555657555657567770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 052:0000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e02b0000000000000000000000000000004b000000000000000056667656667656667600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 053:0000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e02b0000000000000000000000000000004b000000000000000057677757677755657500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 054:000000000000000000000000000000000000000000008383727272727272724b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b000000000000000000000057677756667600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 055:000000000000000000000000000000000000000000007282727272727372720000000000000000000000000000000000000000000000000000000000000057677700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 056:000000000000000000000000000000000000000000007272727272727272000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 057:102010201020102010201020102010201020000000007272727272720000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 058:000000000000000000000000000000000000000000000072727272720000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 059:000000000000000000000000000000000000000000000000727272720000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 060:000000000000000000000000000000000000000000000000727200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 061:000000000000000000000000000000000000000000000000727200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP3>

-- <MAP4>
-- 010:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c0000000000e50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002d0000000000e50000000000000010203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:0000000000000000000000000000000000000000000000000000000000000075858585858585858585858585858585858585858585858595000000000000000000000000000000000000000000000000000000002d0000000000e50000000000e50000000000000011213120300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:000000000000000000000000000000000000000000000000858585e6e6e4e4768686868686868686868686868686868686868686868686a6858510203010203010203000000000b0000000000000000000000000e50000000000e50000000000e50000000000000012221020301020300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:0000000000000000000000000000000000000000000000758686868585102030868686866d868686868686868686866d8686868686868686868611213111213111213100000000b100b0000000c5d5d5d5d5d5d5f6d5d5d5d5d5f6d5d5d5d5d5f6d5d5d5d5d5d5d5d5102030311121312030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:000000000000000000000000000000000000000000000076866e868686112131868686868686868686868686868686868686868686868686868612223212223212223210203000b2c0f1000000e5000000000000e50000000000000000000000e50000000000000000112131321222322131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 017:00000000000000000000000000000000000000000075858686868686861010203086868686868686868686868686868686868686868686b58686102030102030102030112131c0f10000000000e5000000000000e50000000000000000000000e50000000000000000122232301020302232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 018:00000000000000000000000000000000000000000076868686868686861111213186868686868686a58787878787878787878787878787b5861020303111213111213112223200000000000000e5000000000000e50000000000000000000000e50000000000000000001121311121312030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 019:000000000000000000000000000000000000000000768686868686868612122232868686868686869600000000000000000000000000007787112131321222321222321020301020301020301020300000000000e50000000000000000000000e50000000000000000001222321222322131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 020:000000000000000000000000000000000000000000768686868686868610203010203086868686869600000000000000000000000000000000122232301020301020301121311121311121311121310300000000e50000000000000000000000e50000000000000000000000000000122232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 021:000000000000000000000000000000000000000000768686868686868611213111213186868686869600000000000000000000000000000000001121311121102030311210203022321222321222320300000000e50000000000000000000000e50000000000000000000000000000102030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 022:000000000000000000000000000000000000000000768686868686861020102012102030868686869600000000000000000000000000000000102010201210203031321020301020301010203000000300000000e50000000000000000000000e50000000000000000000000000000112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 023:000000000000000000000000000000000000270000768686868686861020302131112131868686869600000000000000000000000000000000112111213111213120301121311121311111213100000300000000e50000000000000000000000e50000000000000000000000000000122232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 024:000000000000102030102030102030102030102030102030868686861121312232122232868610203000fa001020300000fa00000000003010203012221010203030311222321222321212223200000300000000e50000000000000000000000e50000000000000000000000000000102030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 025:000000000000112131112131112110203031112131112131868686861222102030102030102011213130102011213130102030303030303111211020301020303131320000000000000000000000000300000000e50000000000000000000000e5000000000000000000e0d0000000112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 026:000000000000122210203010203011213132121020101020301020203020112131112131112112223231112112223231112131313131313010203021101121102030100000000000000000000000000300000000e500000000000000000000101020300000000000e0c0c200b00000122232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 027:000000000000000011213111213112223220301121111121311110203010203032122210203010203010203030102030303030303030303111213110111222112131110000000000000000000000000300000000e500000000000000000010111121310000000000c100b100b10000102030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 028:000000000000000012223212223210201121311222121222321211211020301020301020301020301020303131112131313131313131312030101011122232122232120000000000000000000000000300000000e5000010203000000000111210203010203000000000b2c0f10000112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 029:000000000000000000000010203011211222323010203010203012221121311121311121311121311121313232122232321020202020203010201112223231223200000000000000000000000000001020301020301020112131301020301222112131112131301020301020301020122232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 030:000000000000000000000011213112223211213111213111213112121222321222321222321222321222323111213111211121311121310000001210203032000000000000000000000000000000001121311121311121122232311121311121122232122232311121311121311121310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 031:000000000000000000000012223200000012223212223212223200000000000000000000000012223212223212223212221222321222320000000011213100000000000000000000000000000000001222321222321222321222321222321222321222321222321222321222321222320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 032:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012223200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP4>

-- <MAP5>
-- 010:000000000000006979797979797979798900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:00000000000000819191919191919191a100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:00000000000000818292919191918292a100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:00000000000000818393919191918393a100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:00000000000000819191919191919191a100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:00000000000000818292919191918292a100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:00000000000000818393919191918393a100000000000000000000868686868686868686868686868686000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 017:00000000000000819191919191919191a100000000000000000000000000770000000000000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 018:00000000000000818292919191918292a100000000000000000000000000770000000000000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 019:00000000000000818393919191918393a1000000000000000000a6b6b6b677b6b6b6b6b6b6b677b6b6b6d60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 020:00000000000000819191919191919191a1000000000000000000c60000006c000000c60000006c000000c60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 021:00000000000000818292919191918292a1000000000000000000c600000000000000c600000000000000c60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 022:00000000000000818393919191918393a1000000000000000000c600000000000000c600000000000000c60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 023:00000000000000819191918494919191a1000000000000000000c600000000000000c600000000000000c60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 024:000000c0d0e000819191918595919191a10000270000c0d0e000c600000000000000c600000000000000c60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 025:000000102020202020202020202020202020202020202020202020300000000000102030000000000010202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 026:000000114321212121212121212121212121212121212121212143412020202020514341202020202051432121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 027:000000112121212121212121217170212170212170212121212121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 028:000000112121212121212171212121212121217121212121212121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 029:000000112121212121212121212121212121212121212121612121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 030:000000112121212121217121212170217121212121617121212121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 031:000000112121212121212121212121212121212121212121212121212121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 032:000000122222222222222222222222222222222222222222222222222222222222222222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP5>

-- <MAP6>
-- 016:000000000000000000000000000000000000000000000000000000000000000000009100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 017:0000000000000000000000000000004050600000000000000000b0000000000000009100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 018:0000000000000000000000000000004151610000000000000000b1000000000000009100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 019:0000000000000000000000000000004252620000000000000000b2000000000000009200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 020:00000000000000000000000000000000000000000000000000000000000000000000f100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 022:000000000000000000000000000000000000000000000000000000000000000000000000000000f000000000f00000000000000000000000f00000000000000000000000f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 023:000000001010101010101010111111111111111111111010101010101010101010101010101010e010101010e01010101010101010101010e01010101010101010101010e0101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 024:000000000000000000000000000000000000000000000000000000000000000000000000000000b100000000b10000000000000000000000b10000000000000000000000b2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 025:000000000000000000000000000000000000000000000000000000000000000000000000000000b200000000b10000000000000000000000b1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 026:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b10000000000000000c1c0c0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 027:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d1a0a0a20000000000b1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 028:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 029:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d1a0a0a0a0a0a0a20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 032:000000000000000000101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 033:000010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP6>

-- <MAP7>
-- 001:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010202020203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011212121213100000000000000000000000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000
-- 003:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011212121213100000000000000000000000000000000000000000000000000000000000000000000000000000000000700000000000000000000000000
-- 004:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011212121213100000000000000000000000000000000000000000000000000000000000000000000000000000000000700000000000000000000000000
-- 005:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010203000000000000000000000000000000000000011212121213100000000000000000000000000000000000000102020203000000000000000000000000000000000000700000000000000000000000000
-- 006:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011213100000000000000000000000000000000000011212121213100000000000000000000000000000000000000112121213100000000000000000000000000000000000700000000000000000000000000
-- 007:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011213100000000000000000000000000000000000011212121213100000000000000000000000000000000000000112121213100000000000000000000000000000000000700000000000000000000000000
-- 008:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000112131000000000000000000000000000000000000112121212131b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b01121212131b0b0b0b0b0b0b0b0b0b0b0b0c0000000000700000000000000000000000000
-- 009:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0b4b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1a4c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000112131000000000000000000000000000000000000112121212131b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b11121212131b1b1b1b1b1b1b1b1b1b1b1b1c1000000000700000000000000000000000000
-- 010:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0b4a3b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b3a4c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000112131000000000000000000000000000000000000112121212131b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b21121212131b2b2b2b2b2b2b2b2b2b2b2b2c2000000000700000000000000000000000000
-- 011:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0b4a3c20000000000000000000000000000000000000000000000a2b3a4c0000000000000000000000000000000a0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0c00000000000000000000000000000000000000000000000000000000000a0b0b0b0b0b0b0b0b0b0b0c000000000000000000011213100000000000000000000000000000000000012222222223200000000000000000000000000000000000000112121213100000000000000000000000000000000000700000000000000000000000000
-- 012:0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0b4a3c200000000000000000000000000000000000000000000000000a2b3a4c00000000000000000000000000000a1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1a4c000000000000000000000000000000000000000000000000000000000a1b1b1b1b1b1b1b1b1b1b1c100000000000000000011213100000000000000000000000000000000000000000000000000000000000000000000000000000000000000122222223200000000000000000000000000000000000700000000000000000000000000
-- 013:10b5c5d5e5f520b5c5d5e5f520b5c5d5e5f520b5c5d5e5f520b5c5d5e5f520b5c5d5e5f520b5c5d5e5f520b5c5d5e5f53000000000000000000000000000000000000000000000000000a2b3a4c000000000000000000000000000a2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b3a4c0000000000000000000000000000000000000000000000000000000a2b2b2b2b2b2b2b2b2b2b2c20000000000000000001121310c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000000000000000000000000
-- 014:11212121212121212121212121212121212121212121212121212121212140b6c6d6e6f6502121212121212121212121310000000000000000000000000000000000000000000000000000a2b3a4c000000000000000000000000000000000000000000000000000000000a2b3a4c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012223200000000000000001020300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000000000000000000000000
-- 015:11212121212121212121212121212121212121212121212121212121212131d1e1e1e1f1112121212121212121212121310000000000000000000000000000000000000000000000102020202020202020202020202020203000007080808080808080808080808080809000a2b3a4c00000000000000000000000000000000000000000000000000000000000004c00000000000000000000000000000000000000000000000000001121310000000000000000000000000000000000000010203010203000000000000000000000000000000000000000000000000000000000000700000000000000000000000000
-- 016:11212121214022b6c6d6e6f622b6c6d6e6f622b6c6d6e6f622b6c6d6e6f632d1e1e1e1f112b6c6d6e6f622b6c6d6e6f632000000000000000000000000000000000000000000000011212121212121212121212121212121310000718181818181818181818181818181749000a2b3a4c000000000000000000000000000000000000000000000000000000000004c00000000000000000000000000000000000000000000000000001222320000000000000000000000000000000000000011213111213100000000000000000000000000000000000000000000000000102020202020202030000000000000000000
-- 017:11212121213100000000000000000000000000007081818173920000000000d1e1e1e1f10000000000a2b3b1b1b1c0000000000000000000000000000000000000000000000000001121212121212121212121212121212132000072828282828282828282828282828283749000a2b3a4c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020308080808080808080808080808080808080808011213111213180808080808080808080808080808080808080900000000000112121212121212131000000000000000000
-- 018:11212121213100000000000000000000000000708481817392000000000000d2e3e1d3f2000000000000a2b3b1b1a4c0000000000000000000000000000000000000000000000000112121212121212121210000000000000000000000000000000000000000000000007283749000a2b3a4c0000000000000000000000000000000000000000000000000004c00000000000000001020202095a5202095a5202020300000000000001121318181818181818181818181818181818181818111213111213181818181818181818181818181818181818181910000000000122222222222222232000000000000000000
-- 019:1121212121310000000000000000000000007084818173920000000000000000d1e1f10000000000000000a2b3b1b1a4c0000000000000000000000000000000000000000000000011212121212121212121000000000000000000000000000000000000000000000000007283749000a2b3a4b0c000000000000000000000000000000000000000000000004c00000000000000001121212196a6212196a6212121310000000000001222328282828282828282828282828282828282828211213111213182828282828282828282828282828282828282920000000000000000000000000000000000000000000000
-- 020:1121212121310000000000000000000000708481817392000000000000000000d1e1f1000000000000000000a2b3b1b1a4c0000000000000000000000000000000000000000000001121212121212121212100000000000000000000000000000000000000000000000000007283749000a2b3b1c1000000000000000000000000000000000000000000000000000000000000000011212222222222222222222222320000000000000000000000000000000000000000000000000000000011213111213100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 021:1121212121310600000000000027000070848181739200000000000000000000d1e1f100000000000000000000a2b3b1b1a4c0000000000000000000000000000000000000000000112121212121212121210000000000000000000000000000000000000000000000000000007283749000a2b2c20000000000000000000000000000000000000000004c0000000000000000000011210000000000000000000000000000000000000000000000000000000000000000000000000000000012223212223200000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 022:11212121214120b5c5d5e5f520b5c5d5e5f520b5c5d5e5f53000000000000000d1e1f10000000000000010b5c5d5e5f520b5c5d5e5f53000000000000000000000000000000000001121000000000000000000000000000000000000000000000000000000000000000000000000728374900000000000000000000000000000000000000000000000004c0000000000000000000011210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 023:1121212121212121212121212121212121212121212121213100000000000000d1e1f100000000000000112121212121212121212121318080808080808080808080808080808080112100000000000000000000000000000000000000000000000000000000000000000000000000718191000000000000000000000000000000000000000000000000000000000000000000000011210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 024:1121212121212121212121212121212121212121212121213100000000000000d1e1f100000000000000112121212121212121212121318181818181818181818181818181818181112100000000000000000000000000000000000000000000000000000000000000000000000000728292000000000000000008000000000000000000000000000000000000000000000000000011210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 025:12b6c6d6e6f622b6c6d6e6f622b6c6d6e6f622b6c6d6e6f621b5c5d5e5f520b5c5d5e5f520b5c5d5e5f521b6c6d6e6f622b6c6d6e6f6318181818181818181818181818181818181112100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009000000000000000000000000000000000000000000000000000011210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 026:000000000000000000000000000000000000000000000000112121212121212121212121212121212121310000000000000000000000318181818181818181818181818181818181112100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009000000000000000000007080900000000000000000000000000011210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 027:000000000000000000000000000000000000000000000000112121212121212121212121212121212121310000000000000000000000318181818181818181818181818181818181112100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009000000000000000000007181910000000000000000000000000011210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 028:00000000000000000000000000000000000000000000000012b6c6d6e6f622b6c6d6e6f622b6c6d6e6f6320000000000000000000000318181818181818181818181818181818181112100000000000000000000000000000000000000000000000000000000000000000010b5c5d5e5f5b5c5d5e5f5b5c5d5e5f5b5c5d5e5f5b5c5d5e5f52020203013131313131313131313131311210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 029:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002020202020202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000004120202020202020202020202051000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 030:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000021212121212121212121212100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 031:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002121212121212121212121212121212121000000000000000000000000000000000000000000000000000000000000000000000012b6c6d6e6f6b6c6d6e6f6b6c6d6e6f6b6c6d6e6f6b6c6d6e6f600000000b6c6d6e6f60000b6c6d6e6f600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 032:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002222222222222222222222222222222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 037:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eb0000000000000000000000000000000000000000000000000000000000000000000000000000
-- 038:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ebebebeb00ebebebebebebebebebebebebebdbdbdbdbdbdbdbdbdb000000000000000000000000
-- 039:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ebebebebebebebebebebebebebebebebebebdbdbdbdbdbdbdbdbdb000000000000000000000000
-- 040:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1c1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cb00102030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ebebebebebebebebebebebebebebebebebebdbdbdbdbdbdbdbdbdb000000000000000000000000
-- 041:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cbcb112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ebebebebebebebebebebebebebebebebebebdbdbdbdbdbdbdbdbdb000000000000000000000000
-- 042:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cbcb112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ebebebebebebebebebebebebebebebebebebdbdbdbdbdbdbdbdbdb000000000000000000000000
-- 043:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cbcb112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ebebebebebebebebebebebebebebebebebebdbdbdbdbdbdbdbdbdb000000000000000000000000
-- 044:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000fbfbfbfb000000000000000070808080808080808080808080808080808080900000000000000000000000000000000000090000000000000000000000000000000000000000000000000000004c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c000000000000cbcb112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ebebebebebebebebebebebebebebebebebebdbdbdbdbdbdbdbdbdbdb0000000000000000000000
-- 045:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000fbfbfbfb000000000000000071818181818181818181818181818181818181910000000000000000000000000000000000090000000000000000000000000000000000004c4c4c4c4c4c4c4c4c000000000000000000000000000000004c4c4c4c4c4ccbcb112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ebebebebebebebebebebebebebebebebebebdbdbdbdbdbdbdbdbdbdb0000000000000000000000
-- 046:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000728282828282828282828282828282828282829200000000000000000000000000000000000900cbcbcbcbcbcbcbcbcbcbcbcb000000000000000000000000000000000000000000000000000000000000000000000000cbcb11213100000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0b0c0a0b0c0a0b0c0a0b0c0a0b0c0a0b0c0a0b0c0a0b0c00000000000000006000000000000000000000000000000000000
-- 047:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000900cbcbcbcbcbcbcbcbcbcbcbcb000000000000000000000000000000000000000000000000000000000000000000000000cbcb11213100000000000000000000000000000000000000000000000000000000000000000000000000000000000000a1b1c1a1b1c1a1b1c1a1b1c1a1b1c1a1b1c1a1b1c1a1b1c10000000000000007000000000000000000000000000000000000
-- 048:000000000000000000000000000000000000000000000000d0e0e0e0e0e0e0109b9b9b9b9b9b9b9b3000000000000000000000000000000000000000131313000000000000000000000000000000000000000000000000009b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b9b0000000000000000000000000000000000000000000000000000000000000000cbcb11213100000000000000000000000000000000000000000000000000000000000000000000000000000000000000a2b2c2a2b2c2a2b2c2a2b2c2a2b2c2a2b2c2a2b2c2a2b2c20000000000000007000000000000000000000000000000000000
-- 049:0000000000000000000000000000000000000000000000d0e4e1e1e1e1e1e1112121212121212121310000000000000000000000000000000000000010203000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cbcb112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000
-- 050:00000000000000000000000000000000000000000000d0e4e1d3e2e2e2e2e2122222222222222222320000fbfbfbfb000000000000000000000000001121310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001313cb112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000
-- 051:000000000000000000000000000000000000000000d0e4e1d3f20000000000000000000000000000000000fbfbfbfb000000000000000000000000001121310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001030cb112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000
-- 052:0000000000000000000000000000000000000000d0e4e1d3f2000000000000000000000000000000000000fbfbfbfb000000000000000000000000001121310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001131cb122232000000000000000000000000000000000000001313130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000
-- 053:00000000000000000000000000000000000000d0e4e1d3f20000000000000000000000000000000000000000000000000000000000000000000000001121310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001131000000000000fbfbfbfbfb0000000000000000000000001020300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000
-- 054:000000000000000000000000000000000000d0e4e1d3f20000000000000000000000000000000000000000000000000000000000000000000000000011213100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011310000000000fbfbfbfbfbfb0000000000fb0000000000001121310000000000000000000000000000000000000000000000000000000000000000000000000000000000102030102030102030102030102010203010203000000000000000000000
-- 055:0000000000000000000000000000000000d0e4e1d3f20000000000000000000000000000000000000000000000000000109b9b9b9b9b9b9b9b9b9b9b512131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000113100000000fbfbfbfbfbfbfb00000000fb000000000000001222320000000000000000000000000000000000000000000000000000000000000000000000000000000000112131112131112131112131112111213111213100000000000000000000
-- 056:00000600000000000000000027000000d0e4e1d3f20000000000000000000000000000000000000000000000000000001121212121212121212121212121310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001131000000fbfbfbfbfbfbfbfb000000fb00000000000000001020300000000000000000000000000000000000000000000000000000000000000000000000000000000000122232122232122232122232122212223212223200000000000000000000
-- 057:00001020202020202020202020202020202020202020202020209b9b9b9b9b9b9b9b9b9b9b300000000000000000000011212121212121212121212121213100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011310000fbfbfbfbfbfbfbfbfb0000fb0000000000000000001121310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 058:0000112121212121212121212121212121212121212121212121212121212121212121212131000000000000000000001222b6c6d6e6f622b6c6d6e6f62232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000113100fbfbfbfbfbfbfbfbfbfb00fb000000000000000000001222320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 059:00001222222222222222222222222222222222222222222222222222222222222222222222320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011310cfbfbfbfbfbfbfbfbfbfbfb00000000000000000000001020300000000000708090708090707080907080907080900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 060:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000113100000000000000000000000000000000000000000000001121310000000000718191718191717181917181917181910000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 061:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000123200000000000000000000000000000000000000000000001222320000000000728292728292727282927282927282920000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 062:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfb000000000000000000000000000000000000000000000000000000000000000000
-- 063:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfb000000000000000000000000000000000000000000000000000000000000000000
-- 064:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfb000000000000000000000000000000000000000000000000000000000000000000
-- 065:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfb000000000000000000000000000000000000000000000000000000000000000000
-- 066:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfbfb000000000000000000000000000000000000000000000000000000000000000000
-- 073:000000000000000000000000000000000000000000000000000000000000000000102030102030102030b0b0b0b0b0b0b0b0b0b0b0b0c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 074:000000000000000000000000000000000000000000000000000000000000000000112131112131112131b1b1b1b1b1b1b1b1b1b1b1b1a4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 075:000000000000000000000000000000000000000000000000000000000000000000122232122232122232b2b2b2b2b2b2b2b2b2b2b3b1b1a4c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 076:000000000000000000000000000000000000000000000000000000000000000000102030000000cbcbcb00000000000000000000a2b3b1b1a4c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 077:0000000000000000000000000000000000000000000000000000000000000000001121310c0000cbcbcb0000000000000000000000a2b3b1b1a4c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 078:000000000000000000000000000000000000000000000000000000000000000000122232000000cbcbcb000000000000000000000000a2b3b1b1a4c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 079:0000000000000000000000000000000000000000000000000000000000000000d01222320c0000cbcbcb00000000000000001020b5c5d5e5f520b5c5d5e5f5200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 080:00000000000000000000000000000000000000000000000000000000000000d0e4102030000000cbcbcb000000000000000011212121212121212121212121210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 081:000000000000000000000000000000000000000000000000000013131300d0e4e11121310c0000cbcbcb00000000000000001222b6c6d6d6d6d6d6d6d6e6f6220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 082:0000000000000000000000000000000000000000000000000000102030d0e4e1d312223200dbdbcbcbcb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 083:0000000000000000000000000000000000000000000000000000112131e4e1d3f210203000dbdb102030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 084:0000000000000000000000000000000000000000000000000000122232e1d3f20011213100dbdb112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 085:0000000000000000000000000000000000000000000000000000102030d3f2000012223200dbdb122232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 086:0000000000000000000000000000000000000000000000000000112131f2000000232323000000102030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 087:000000000000000000000000000000000000000000000000000012223200000000000000000000112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 088:0000000000000000000000000000000000006c0000000000000010203000000000000000000000122232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 089:000000000000000000000000000000000000000000000000000011213180808080808080808080102030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 090:000000000000000000000000000000000000000000000000000012223281818181818181818181112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 091:000000000000000000000000000000000000000000000000000010203082828282828282828282122232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 092:0000000000000000000000000000000000000000000000000000112131fbfbfbfbfbfbfbfbfbfb112131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 093:0000b5c5d5e5f520b5c5d5e5f520b5c5d5e5f520b5c5d5e5f520122232fbfbfbfbfbfbfbfbfbfb122232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 094:0000000000000000000000000000000000000000000000000000000000fbfbfbfbfbfbfbfbfbfb232323000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP7>

-- <WAVES>
-- 000:ffffffffffffffffff00000000000000
-- 001:24679acddeeffffffffffeedba875310
-- 002:fffffffffffffff00000000000000000
-- 003:01345789aaaaf9aa999908c776654310
-- 004:2df72f7ff7f1f6f740902a0904295050
-- 005:fffffaffffffffff0000098800000000
-- 015:7080090a0d0c0a0a999bcf0a08004001
-- </WAVES>

-- <WAVES2>
-- 000:ffffffffffffffffffffffffff000000
-- 001:1235679acdf00236780a0b0c0ef0f000
-- 002:9986431112479bccccbbba9887543210
-- 004:0d055a4c00399ecc0dcc0a047d0f8e40
-- 005:0123456789abcef12345567899abcdef
-- 006:fffffffffffffffff000000000000000
-- 015:7080090a0d0c0a0a999bcf0a08004001
-- </WAVES2>

-- <WAVES3>
-- 001:ffffffffffffffffffff000000000000
-- 002:ffffffffffffffffb000000000000000
-- 012:0db8880800a0cca999abbbaacdca99aa
-- 013:99080080708809b9890abcbbaabbbbaa
-- 014:000009888090a0bcba88899865688880
-- 015:7080090a0d0c0a0a999bcf0a08004001
-- </WAVES3>

-- <WAVES4>
-- 000:eeeeeeeeeeeedddee00000c0000a0777
-- 001:fffffffff00000000000000000000000
-- 015:7080090a0d0c0a0a999bcf0a08004001
-- </WAVES4>

-- <WAVES5>
-- 001:fffffffffff000000000000000000000
-- 015:7080090a0d0c0a0a999bcf0a08004001
-- </WAVES5>

-- <WAVES6>
-- 001:fffffff0000000000000000000000000
-- 015:7080090a0d0c0a0a999bcf0a08004001
-- </WAVES6>

-- <WAVES7>
-- 002:ffffffffffffffff0000000000000000
-- 003:ffffffff000000000000000000000000
-- 012:0db8880800a0cca999abbbaacdca99aa
-- 013:99080080708809b9890abcbbaabbbbaa
-- 014:000009888090a0bcba88899865688880
-- 015:7080090a0d0c0a0a999bcf0a08004001
-- </WAVES7>

-- <SFX>
-- 000:0000100020002000200030004000500060008000a000c000d000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f00057b000000500
-- 001:13001300130013001300230033003300430053006300730083009300a300b300c300d300e300e300f300f300f300f300f300f300f300f300f300f30020a000000000
-- 002:740684059403a400b40fc40cc40cd40ae409f408f408f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400f400402000000000
-- 003:30d95000709d9000a063b005c040d007e020e000f010f000f010f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000505000000000
-- 004:00001000200030004000600070008000a000c000d000e000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000575000f60000
-- 005:0000000000000000000000000000000000000000000010001000200030004000500070008000a000c000e000f000f000f000f000f000f000f000f000474000000000
-- 010:0200020002001200120012002200320042004200520062008200c200e200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200402000000000
-- 011:1000100010001000200020003000300040006000600070009000b000d000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000102000000000
-- 012:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000507000000400
-- 016:530053005300530053005301530f530053015301530053005300530053005300530053005300530053005300630073008300a300b300d300e300f300457000470053
-- 017:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000307000000000
-- 048:02e712d43291622ee209f208f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200134000000000
-- 049:02f012d032c062a0a290f260f240f220f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200100000000000
-- 050:65006500650065006500650065006500750075007500750085008500850095009500950095009500a500a500a500a500a500a500a500a500a500a500305000000000
-- 051:0fe74fb59f93ff72ff51ff1fff00ff0fff0fff0fff0fff07ff0fff07ff06ff00ff06ff01ff06ff04ff06ff06ff06ff07ff07ff07ff07ff00ff00ff00104000000000
-- 052:160026003600560066008600b600b600d600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600305000000000
-- 055:1f004f005f007f009f00bf00cf00df00ef00ff00cf00df00ff00ff00ef00ef00ef00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00209000000000
-- 060:00962052503ea01af008f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000307000000000
-- 061:7f949f50ef00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00507000000000
-- </SFX>

-- <SFX2>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000303000000000
-- 002:060016003600c600e600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600507000000000
-- 004:11e731a751869155d132f121f10ff10df10bf108f108f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100107000000000
-- 010:00040000000c000b000b000d000f00010001000f000c000d000e000f000100020003000400040001000f000e000f000000020003000400040001000f407000000019
-- 028:020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200887000000000
-- 029:051c058e05cf056005200500050005000500050005000500050005000500050005000500050005000500050005000500050005000500050005000500402000000000
-- 048:00e700d40091002ee009f008f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000a00000000000
-- 049:16f036d036c066a0a690f660f640f620f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600104000000000
-- 050:6f006f006f006f006f006f006f006f007f007f007f007f008f008f008f009f009f009f009f009f00af00af00af00af00af00af00af00af00af00af00105000000000
-- 051:7be7abb5bb93fb72fb519b1fcb00fb0ffb0ffb0ffb0ffb07fb0ffb07fb06fb00fb06fb01fb06fb04fb06fb06fb06fb07fb07fb07fb07fb00fb00fb00505000000000
-- 056:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000308000000000
-- 060:2053600cb008f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000462000000000
-- 061:7f949f50ef00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00303000000000
-- </SFX2>

-- <SFX3>
-- 000:ce009e006e004e003e002e002e001e001e001e001e001e001e002e002e004e004e006e007e009e00ae00be00ce00de00de00ee00ee00ee00fe00fe00272000000000
-- 001:6e002d000d000d000e001d005d009e00cf00de00ee00ff00fe00ff00fd00ff00fc00ff00ff00ff00ff00fe00ff00fd00fe00ff00fd00fc00fc00fd00102000000000
-- 002:1d002c00ad00ee00fe00ff00ff00fd00fd00fe00fe00fd00fd00fd00fe00ff00ff00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00ff00104000000000
-- 004:1eea3eab6e6ede40fe1efe0dfe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00405000000000
-- 008:6d002d000d000d000d004d007d009d00bd00cd00cd00dd00dd00dd00dd00dd00ed00ed00ed00ed00ed00ed00ed00fd00fd00fd00fd00fd00fd00fd00100000000000
-- 009:df00af009f008f007f007f007f007f007f008f009f00af00bf00cf00df00ef00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00070000000000
-- 016:0200220032006200a200e200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200305000000000
-- 048:11d0119031406110b100e100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100104000000000
-- 049:00002000400070009000d000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f00010b000000000
-- 052:f000e000e000e000d000d000c000c000b000b000a000a000900090009000800080007000700070006000600050005000400040003000200010001000249000000000
-- 060:11565110a10df108f108f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100500000000000
-- 061:7f949f50ef00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00507000000000
-- </SFX3>

-- <SFX4>
-- 000:0000300060008000b000d000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000503000000000
-- 060:119631836150914dd12bf108f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100500000000000
-- 061:7f949f50ef00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00507000000000
-- </SFX4>

-- <SFX5>
-- 060:01e521b2418f715cc119f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100502000000000
-- 061:7f949f50ef00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00507000000000
-- </SFX5>

-- <SFX6>
-- 060:01e621d431a1717ca138e108f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100500000000000
-- 061:7f949f50ef00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00507000000000
-- </SFX6>

-- <SFX7>
-- 000:ce009e006e004e003e002e002e001e001e001e001e001e001e002e002e004e004e006e007e009e00ae00be00ce00de00de00ee00ee00ee00fe00fe00175000000000
-- 001:6e002d000d000d000e001d005d009e00cf00de00ee00ff00fe00ff00fd00ff00fc00ff00ff00ff00ff00fe00ff00fd00fe00ff00fd00fc00fc00fd00104000000000
-- 002:7d002c00ad00ee00fe00ff00ff00fd00fd00fe00fe00fd00fd00fd00fe00ff00ff00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00ff00107000000000
-- 004:ee00de00ce00be00be00ae00ae009e009e009e009e009e009e00ae00be00ce00de00ee00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00fe00175000000000
-- 016:e304c302b3019300730f730f530e530e330f33012301230123002300230e330d230d330d330e330f430153016301830fa30fc300e301f300f303f30347a00000003b
-- 017:03002300430063008300a300b300c300d300d300e300e300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300404000000000
-- 049:12f032d032c062a0a290f260f240f220f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200f200102000000000
-- 051:7be7abb5bb93fb72fb51fb1ffb00fb0ffb0ffb0ffb0ffb07fb0ffb07fb06fb00fb06fb01fb06fb04fb06fb06fb06fb07fb07fb07fb07fb00fb00fb0060b000000000
-- 052:160026003600560066008600b600b600d600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f60050b000000000
-- 053:36c08670e600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600f600604000000000
-- 060:13f553c373a1a37fd32cf308f308f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300504000000000
-- 061:7f949f50ef00ef00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00501000000000
-- </SFX7>

-- <PATTERNS1>
-- 001:e00008000000000000000000000000000000b00008000000e0000800000000000000000040000a00000000000000000070000a00000000000000000060000a00000000000000000040000a000000000000000000e0000800000000000000000090000a00000000000000000000000000000070000a000000000000000000000000000000e0000800000040000a00000060000a00000000000000000000000000000040000a000000000000000000000000000000e00008000000000000000000
-- 002:70000a00000000000000000000000000000060000a000000000000000000000000000000e00008000000000000000000b00008000000000000000000c0000800000000000000000040000a000000000000000000000000000000000000000000b0000a00000000000000000070000a00000000000000000060000a000000000000000000e0000800000040000a00000070000a00000060000a000000000000000000c0000800000040000a00000000000000000090000a000000c0000a000000
-- 003:5000a6000000a000a60000000000a00000007000a60000000000000000000000000000000000000000000000000000005000a4000000c000a4000000000000000000a000a4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:7024a6000000a000a6000000000000000000c000a6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:5000a6000000a000a60000000000a00000007000a60000000000000000000000000000000000000000000000000000005000a4000000c000a4000000000000000000a000a4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700004000000000000100000c00004000000700004000000
-- 009:c00002000000000000000000c00002000000000000000000c00002000000000000000000c00002000000000000000000900002000000000000000000900002000000000000000000900002000000000000000000900002000000000000000000c00002000000000000000000c00002000000000000000000c00002000000000000000000c00002000000000000000000400004000000000000000000400004000000000000000000400004000000000000000000400004000000000000000000
-- 010:700002000000000000000000000000000000000000000000a00002000000000000000000700002000000000000000000000000000000000000000000a00002000000000000000000000000000000000000000000000000000000000000000000700002000000000000000000000000000000000000000000a00002000000000000000000700002000000000000000000000000000000000000000000a00002000000000000000000c00004000000000000000000e00004000000000000000000
-- 019:700002000000000000000000700002000000000000000000c00002000000000000000000c00002000000000000000000700002000000000000000000700002000000000000000000a00002000000000000000000a00002000000000000000000500002000000000000000000500002000000000000000000a00002000000000000000000a00002000000000000000000500002000000000000000000500002000000000000000000c00002000000000000000000c00002000000000000000000
-- 029:700008000000000000000000000000000000000000000000700008000000000000000000000000000000000000000000700008000000000000000000900008000000000000000000b00008000000000000000000700008000000000000000000600008000000000000000000000000000000000000000000600008000000000000000000000000000000000000000000600008000000000000000000400008000000000000000000e00006000000000000000000b00006000000000000000000
-- 030:e00006000000000000000000000000000000000000000000600008000000000000000000000000000000000000000000600008000000000000000000e00006000000000000000000400008000000000000000000000000000000000000000000700008000000000000000000600008000000000000000000400008000000000000000000e00006000000000000000000c00008000000000000000000b00008000000000000000000900008000000000000000000700008000000000000000000
-- 039:400813000000400813000000c00847000000000000000000400813000000400813000000c00847000000400813000000000000000000400813000000c00847000000400813000000000000000000400813000000c00847000000000000000000400813000000400813000000c00847000000000000000000400813000000400813000000c00847000000400813000000000000000000400813000000c00847000000400813000000000000000000400813000000c00847000000000000000000
-- 040:700813000000000000000000700849000000000000000000700813000000000000000000700849000000000000000000700813000000000000000000700849000000000000000000700813000000000000000000700849000000000000000000700813000000000000000000700849000000000000000000700813000000000000000000700849000000000000000000700813000000000000000000700849000000000000000000700813000000000000000000700849000000000000000000
-- 041:754813000000000000000000700849000000000000000000700813000000000000000000700849000000000000000000700813000000000000000000700849000000000000000000700813000000000000000000700849700813700813760813700813000000000000000000700849000000000000000000700813000000000000000000700849000000000000000000700813000000000000000000700849000000000000000000700813000000c00849000000700849000000a00849000000
-- 049:400004000000000000000000400006000000f00006000000600006000000800006000000400006000000000000000000400004000000000000000000400006000000f00006000000600006000000800006000000400006000000000000000000000000d00004000000600006800006000000d00004000000600004f00004000000000000400006000000000000000000d00004000000b00004000000000000000000600004000000400006f00004400004b00004d00004000000d00004000000
-- 050:400006000000000000000000f00004000000000000000000d00004000000000000000000400006000000000000000000f00004000000000000000000400006000000b00006000000f00004000000000000b00004000000d00004000000000000d00004000000000000800006000000000000d00004000000000000f00004000000600006400006000000000000d00004b00006000000000000b00006000000000000d00006000000000000900006000000000000800006000000000000000000
-- 054:403407000000000000000000000000000000000000b00007000000000000000000000000000000000000000000000000f00005000000000000000000000000000000d00003b00005000000000000000000000000000000000000000000000000d00005000000000000f00005000000d00005b00005000000800005000000000000000000000000000000000000000000400005000000000000000000400005000000000000000001000000000000000000000000000000000000000000000000
-- 058:d00877f00837900837900837b00877900837900837900837000000900837000000900877000000900837000000900837d00877f00837900837900837b00877900837900837900837000000900837000000900877000000900837000000900837d00877f00837900837900837b00877900837900837900837000000900837000000900877000000900837000000900837d00877f00837900837900837b00877900837900837900837000000900837000000900877000000900837000000900837
-- </PATTERNS1>

-- <PATTERNS3>
-- 000:400805000000000000000000400805000000000000000000400817000000000000000000400805000000000000000000400805000000000000000000400805000000000000000000400817000000000000000000400805000000000000000000400805000000000000000000400805000000000000000000400817000000000000000000400805000000000000000000400805000000000000000000400805000000000000000000400817000000000000000000400805000000000000000000
-- 001:400805000000000000000000000000000000000000000000400817000000000000000000000000000000000000000000400805000000000000000000000000000000000000000000400817000000000000000000000000000000000000000000400805000000000000000000000000000000000000000000400817000000000000000000000000000000000000000000400805000000000000000000000000000000000000000000400817000000000000000000000000000000000000000000
-- 002:400805000000800819000000400805000000800819000000400817000000800819000000400805000000800819800819400805000000800819000000400805000000800819000000400817000000800819000000400805000000800819000000400805000000800819800819400805000000800819800819400817800819800819800819400805800819800819800819000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 019:900002000000000000000000000000000000000000000000900012000000900012000000900012000000900012000000d06402000000000000000000400004000000000000000000e00002000000000000000000000000000000000000000000900002000000000000000000000000000000000000000000900012000000900012000000900012000000900012000000d06402000000000000000000000000000000000000000000900022900022900022900022900022900022900022900022
-- 020:900002000000000000000000000000000000000000000000000000000000000000000000900002000000000000000000000000000000000000000000c00002000000000000000000000000000000000000000000000000000000000000000000900002000000000000000000000000000000000000000000000000000000000000000000900002000000000000000000000000000000000000000000500002000000000000000000700002000000000000000000500002000000000000000000
-- 029:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400849000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100841000841000000000000000000000000000000000000000841000000000000000000000000000000000000000000
-- 039:137280000000100080000000100080000000100080000000910088000000900088000000900088000000900088000000d57298000000000000000000400098000000000000000000e37296000000000000000000000000000000000000000000937298000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d57298000000000000000000000000000000000000000000937209000000d4822a00000043720d00000090000b000000
-- 040:400009000000000000900009000000000000c00009000000700009000000500009000000500009700009900007700009400009000000000000900009000000000000c00009000000700009000000500009000000500009700009900007700009500009000000000001500009000001000000500009000000400009000000e00009000000c00009e00009e00009000000400009000000000000900009000000000000c00009000000700009000000500009000000500009700009900007700009
-- 041:400009000000000000900009000000000000c00009000000700009000000500009000000500009700009900007700009400009000000000000900009000000000000c00009000000700009000000500009000000500009700009900007700009500009000000000001500009000001000000500009000000400009000000e00009000000c00009e00009e00009000000c00009000000000000c00009000000000000c00009900009000000000000900009c00009e00009000000c00009000000
-- 043:937208000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d57208000000000000000000400008000000000000000000e37206000000000000000000000000000000000000000000937208000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d57208000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 059:900003000000b00003000000900003000000b00003000000900003000000b00003000001900003000000b00003000000900003000000b00003000000900003000000b00003000001900003000000b00003000000900003000000b00003000000900003000000b00003000001900003000000b00003000000900003000000b00003000000900003000000b00003000001900003000000b00003000000900003000000b00003000000900003000000b00003000001900003000000700003000000
-- </PATTERNS3>

-- <PATTERNS7>
-- 000:900002000000000000000000000000000000000000000000900012000000900012000000900012000000900012000000700002000000000000000000a00002000000000000000000700002000000000000000000000000000000000000000000900002000000000000000000000000000000000000000000900012000000900012000000900012000000900012000000700002000000000000000000000000000000000000900022900022900022900022900022900022900022900022000000
-- 009:700002000000000000000000700012000000000000000000000000000000700012000000700012000000700012000000700002000000000000000000700012000000000000000000000000000000700012000000700012000000700012000000a00002000000000000000000a00012000000000000000000000000000000a00012000000a00012000000a00012000000c00002000000000000000000c00012000000000000000000000000000000e00012000000c00012000000a00012000000
-- 019:937248000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d57248000000000000000000400048000000000000000000e37246000000000000000000000000000000000000000000937248000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d57248000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 029:c00009000000000000000000000000000000000000000000e00009000000000000000000000000000000000000000000700009000000000000000000000000000000000000000000700009000000000000000000000000000000000000000000700009000000000000000000000000000000000000000000c00009000000000000000000000000000000000000000000700009000000000000000000000000000000000000000000a00009000000000000000000000000000000000000000000
-- 030:c00009000000000000000000000000000000000000000000e00009000000000000000000000000000000000000000000700009000000000000000000000000000000000000000000700009000000000000000000000000000000000000000000700009000000000000000000000000000000000000000000c00009000000000000000000000000000000000000000000700009000000000000000000c00009000000000000000000a0000b000000e00009000000e0000b000000e00009000000
-- 034:737208000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000737208000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a37208000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c37208000000000000000000000000000000000000000000000000000000e10617000000c00017000000a00017000000
-- 039:400813000000000000000000000000000000000000000000400847000000000000000000000000000000000000000000400813000000000000000000000000000000000000000000400847000000000000000000000000000000000000000000400813000000000000000000000000000000000000000000400847000000000000000000000000000000000000000000400813000000000000000000000000000000000000000000400847000000000000000000000000000000000000000000
-- 040:400813000000000000000000400813000000000000000000400847000000000000000000400813000000000000000000400813000000000000000000400813000000000000000000400847000000000000000000400813000000000000000000400813000000000000000000400813000000000000000000400847000000000000000000400813000000000000000000400813000000000000000000400813000000000000000000400847000000000000000000400813000000000000000000
-- 041:400813000000800859000000400813000000800859000000400847000000800859000000400813000000800859000000400813000000800859000000400813000000800859000000400847000000800859000000400813000000800859000000400813000000800859000000400813000000800859000000400847000000800859000000400813000000800859000000400813000000800859000000400813000000800859000000400847000000800859000000400813000000000000000000
-- </PATTERNS7>

-- <TRACKS>
-- 000:282e1a382f1a000000000000000000000000000000000000000000000000000000000000000000000000000000000000bd00df
-- 001:8ac0008ac7fe8ac7fe9ec0009ec0ce9ec0ce000000000000000000000000000000000000000000000000000000000000ec0000
-- </TRACKS>

-- <TRACKS2>
-- 000:1004101004101824101824100004102005102005103c25103c25103c25103c25100004100000000000000000000000006e0000
-- </TRACKS2>

-- <TRACKS3>
-- 000:182410182410000000000000000000000000000000000000000000000000000000000000000000000000000000000000ab0000
-- </TRACKS3>

-- <TRACKS7>
-- 000:087820a87820a87920ac7a20ac8820ac8820ac8820ac8820000000000000000000000000000000000000000000000000000000
-- </TRACKS7>

-- <PALETTE>
-- 000:4d65b44d9be6fffffff9c22bf79617d5e04ba2a9476766337a30459e4539cd683de6904e000000f57d4aea4f36b33831
-- 001:0c0400e6904ee83b3bae2334f9c22bfffffffff975905ea99e4539cd863d484a77c7dcd0323353f79617bc419b6b3e75
-- </PALETTE>

-- <PALETTE1>
-- 000:4d9be64d65b4c7dcd0ffffffe83b3bd5e04ba2a94767663345293f9e4539cd683de6904eae2334f57d4aea4f36b33831
-- 001:0c0400e6904ee83b3bae2334f9c22bfffffffff975905ea99e4539cd863d484a77c7dcd0323353f79617bc419b6b3e75
-- </PALETTE1>

-- <PALETTE2>
-- 000:000824000000ae23346e27273e35462e222f547e64374e4ae6904ecd683dfbb95430e9b10eaf9b9babb27f708a694f62
-- 001:0c0400e6904ee83b3bae2334f9c22bfffffffff975905ea99e4539cd863d484a77c7dcd0323353f79617bc419b6b3e75
-- </PALETTE2>

-- <PALETTE3>
-- 000:323353ffffff73172d3b17250000001ebc73239063165a4cfbb954e6904ecd683d9e45398fd3ff4d9be64d65b4484a77
-- 001:000000000000000000000000ae2334e83b3b831c5dc324549e4539000000000000c7dcd09babb27f708a6255652e222f
-- </PALETTE3>

-- <PALETTE4>
-- 000:4d9be6ffffff625565905ea9a884f3a2a9476766334c3e24e83b3bae23343e35466b3e75e6904ecd683d9e453945293f
-- 001:000000000000000000000000000000000000831c5dc32454000000000000000000c7dcd0000000000000000000000000
-- </PALETTE4>

-- <PALETTE5>
-- 000:000824ffffffe83b3bae23343e35462e222f8fd3ffcd683dfbb954e6904e239063165a4cc7dcd09babb27f708a694f62
-- </PALETTE5>

-- <PALETTE6>
-- 000:0000004d65b491db692e222f905ea96b3e7545293ffb6b1df9c22bf796171ebc63239063c7dcd09babb27f708a694f62
-- </PALETTE6>

-- <PALETTE7>
-- 000:3233531b244730e1b90eaf9b0b5e65f04f78c32454831c5dffffff8fd3ff4d9be64d64b4c7dcd09babb27f708a694f62
-- 001:000000bc4a9b793a80000000000000000000f5a097e86a73ffffff000000000000000000000000000000000000000000
-- </PALETTE7>
