local stext
local c_a = {}
local c_a1 = {}
local tspd
local tagtimer = 0
local pchapter
local aa
local script_poemresponsesx = false

function cw(p1, stext, tag)
	if p1 == 's' then
		ct = 'Sayori'
	elseif p1 == 'n' then
		ct = 'Natsuki'
	elseif p1 == 'y' then
		ct = 'Yuri'
	elseif p1 == 'm' then
		ct = 'Monika'
	elseif p1 == 'ny' then
		ct = 'Nat & Yuri'
	elseif p1 == 'mc' then
		ct = player
	elseif p1 == 'bl' then
		ct = ''
	elseif p1 then
		ct = p1
	else
		ct = 'Error'
	end
	
	if stext == nil then stext = '' end
	
	--auto add quotation marks
	if p1 ~= 'bl' then
		stext = '"'..stext..'"'
	end
	
	--text drip for scripts
	if autoskip > 0 then
		tspd = 10000
	elseif tag == 'fast' or tag == 'nwfast' then
		tspd = 250
	elseif tag == 'slow' then
		tspd = 25
	elseif chapter == 30 then
		tspd = 50
	else
		tspd = settings.textspd
	end
	textx = dripText(stext,tspd,myTextStartTime)
	
	--word wrap
	slen = string.len(textx)
	c_a1 = {45,95,145}
	if style_edited then c_a1 = {35,65,95} end
	
	for i = 1, 3 do
		c_a[i] = string.find(stext, '%s', c_a1[i])
		if c_a[i] == nil then c_a[i] = c_a1[i] + 3 end
	end
	
	c_disp[1] = string.sub(textx, 1, c_a[1])
	for i = 2, 4 do
		if slen >= c_a[i-1] then
			c_disp[i] = string.sub(textx, c_a[i-1]+1, c_a[i])
		end
	end
	
	if tag then
		tagtimer = tagtimer + (settings.textspd / 100)
		if tagtimer >= (settings.textspd + slen) / 4 then
			if tag == 'nw' or tag == 'nwfast' then
				scriptJump(cl+1)
			end
			tagtimer = 0
			if autotimer > 0 then autotimer = 0.01 end
		end
	else
		tagtimer = 0
	end
end

function scriptCheck()
	c_disp = {'','','',''}
	
	if poemsread ~= -1 and poemresponses and script_poemresponsesx then
		poemresponses()
	elseif poemsread ~= -1 then
		require 'scripts.script-poemresponses'
		require 'scripts.poems'
		if persistent.ptr == 0 then
			require 'scripts.script-poemresponses1'
		else
			require 'scripts.script-poemresponses2'
		end
		script_poemresponsesx = true
	else
		script_poemresponsesx = false
	end
	
	if persistent.ptr == 2 then 
		pchapter = chapter - 20
	else
		pchapter = chapter
	end
	if poemwinner[pchapter] == 'Sayori' then aa = 's'
	elseif poemwinner[pchapter] == 'Natsuki' then aa = 'n'
	elseif poemwinner[pchapter] == 'Yuri' then aa = 'y'
	end
	
	if persistent.ptr == 0 and chapter ~= 4 and ((cl>=423 and cl<652) or (cl>=1359 and cl<1638)) then
		loadstring(poemwinner[pchapter]..'_exclusive_'..(loadstring('return appeal.'..aa)())..'()')()
	elseif persistent.ptr == 2 and cl>=358 and cl<665 then
		loadstring(poemwinner[pchapter]..'_exclusive2_'..(loadstring('return appeal.'..aa)())..'()')()
	elseif persistent.ptr == 2 and cl>=1235 and cl<=1445 then
		Yuri_exclusive2_2_ch22()
	elseif persistent.ptr == 0 and cl == 652 and chapter >= 2 and chapter ~= 4 then
		poeminitialize()
	elseif script_main then
		loadstring('ch'..chapter..'script()')()
	else
		changeState('game',0)
	end
end	

function bl (say) return cw('bl',say) end
function mc (say) return cw('mc',say) end
function s (say) return cw('s',say) end
function n (say) return cw('n',say) end
function y (say) return cw('y',say) end
function m (say) return cw('m',say) end

function pause(t)
	autotimer = 0
	if event_enabled then textbox_enabled = false end
	local dt = love.timer.getDelta()
	tagtimer = tagtimer + dt
	if tagtimer >= t then
		scriptJump(cl+1)
		tagtimer = 0
		textbox_enabled = true
	end
end

function scriptJump(nu, fu, au)
	xaload = -1
	unitimer = 0
	if nu then cl = nu end
	if au then
		autotimer = au
		autoskip = au
	end
	if fu and fu ~= '' then
		loadstring(fu..'()')()
	end		
end

function choice_enable(x)
	if menu_enabled ~= true then
		if x == 'dialog' then
			menu_enable('dialog')
		else
			menu_enable('choice')
		end
		autotimer = 0
		autoskip = 0
	end
end

function poeminitialize(y)
	poemsread = 0
	readpoem = {s=0,n=0,y=0,m=0}
	if persistent.ptr == 0 then
		choices = {'Sayori','Natsuki','Yuri','Monika'}
	elseif y == 'y_ranaway' then
		choices = {'Natsuki','Monika'}
	else
		choices = {'Natsuki','Yuri','Monika'}
	end
	scriptJump(666,'',0)
end

function glitchtext(range)
	local aaa
	local gtextstring = ''
	local chars = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
				   'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
				   '0','1','2','3','4','5','6','7','8','9'}
	
	for i = 1, range do
		aaa = math.random(1, #chars)
		gtextstring = gtextstring..chars[aaa]
	end
	
	return gtextstring
end

function space(range)
	local spaces = ' '
	for i = 1, range do
		spaces = spaces..' '
	end
	
	return spaces
end

function event_init(etype,arg1,arg2)
	if xaload == 1 then
		require 'scripts.event'
		if persistent.ptr <= 1 then
			require 'scripts.event-1'
		elseif persistent.ptr == 2 then
			require 'scripts.event-2'
		else
			require 'scripts.event-3'
		end
		if etype == 's_kill' then --Sayo-nara.... load sprites
			s_kill = lg.newImage('images/cg/s_kill/s_kill.png')
			s_kill2 = lg.newImage('images/cg/s_kill/s_kill2.png')
			s_killzoom = lg.newImage('images/cg/s_kill/s_killzoom.png')
			s_kill_bg = lg.newImage('images/cg/s_kill/s_kill_bg.png')
			s_kill_bg2 = lg.newImage('images/cg/s_kill/s_kill_bg2.png')
			s_kill_bgzoom = lg.newImage('images/cg/s_kill/s_kill_bgzoom.png')
			splash_glitch = lg.newImage('images/bg/splash-glitch.png')
			exception = lg.newImage('images/cg/s_kill/ex2.png')
		elseif etype == 'endscreen' then
			if arg1 == 'flipped' then
				bgch = lg.newImage('images/gui/endflipped.png')
			else
				bgch = lg.newImage('images/gui/end.png')
			end
		elseif etype == 's_glitch' then
			s_glitch1 = lg.newImage('images/sayori/glitch1.png')
			s_glitch2 = lg.newImage('images/sayori/glitch2.png')
		elseif etype == 'm_glitch1' then
			ml = lg.newImage('images/monika/g2.png')
		elseif etype == 'n_glitch1' then
			nl = lg.newImage('images/natsuki/glitch1.png')
		elseif etype == 'n_blackeyes' then
			n_blackeyes = lg.newImage('images/natsuki/blackeyes.png')
		elseif etype == 'ny_argument' then
			vignette = lg.newImage('images/bg/vignette.png')
			loadNoise()
		elseif etype == 'ny_argument2' then
			ml = lg.newImage('images/monika/ac.png')
		elseif etype == 'yuri_glitch' then
			loadYuriGlitch()
		elseif etype == 'show_vignette' then
			loadVignette()
		elseif etype == 'yuri_eyes' then
			eyes1 = lg.newImage('images/yuri/eyes1.png')
			eyes2 = lg.newImage('images/yuri/eyes2.png')
		elseif etype == 'yuri_glitch_head' then
			animframe1 = lg.newImage('images/yuri/za.png')
			animframe2 = lg.newImage('images/yuri/zb.png')
			animframe3 = lg.newImage('images/yuri/zc.png')
			animframe4 = lg.newImage('images/yuri/zd.png')
		elseif etype == 'yuri_ch23' then
			bg_glitch = lg.newImage('images/bg/glitch.png')
			eyes1 = lg.newImage('images/yuri/eyes1.png')
			loadYuriGlitch()
		elseif etype == 'm_ch23ex' then
			ex3top = lg.newImage('images/gui/ex3top.png')
			ex3bottom = lg.newImage('images/gui/ex3bottom.png')
		elseif etype == 'just_monika' then
			if arg1 == 'ch30' then
				splash = lg.newImage('images/bg/splash-glitch2.png')
			else
				splash = lg.newImage('images/bg/splash.png')
			end
		elseif etype == 'natsuki_ch22' then --oh snap
			ghost_blood = lg.newImage('images/natsuki/ghost_blood.png')
			ghost3 = lg.newImage('images/natsuki/ghost3.png')
			ghost3_1 = lg.newImage('images/natsuki/ghost3-1.png')
			ghost3_2 = lg.newImage('images/natsuki/ghost3-2.png')
			ghost3_3 = lg.newImage('images/natsuki/ghost3-3.png')
		elseif etype == 'yuri_kill' then --that looks painful
			stab1 = lg.newImage('images/yuri/stab/1.png')
			stab2 = lg.newImage('images/yuri/stab/2.png')
			stab3 = lg.newImage('images/yuri/stab/3.png')
			stab4 = lg.newImage('images/yuri/stab/4.png')
			stab5 = lg.newImage('images/yuri/stab/5.png')
			stab6 = lg.newImage('images/yuri/stab/6.png')
			stab6f = lg.newImage('images/yuri/stab/6-full.png')
		elseif etype == 'beforecredits' then
			end_glitch1 = lg.newImage('images/bg/end-glitch1.png')
			end_glitch2 = lg.newImage('images/bg/end-glitch2.png')
			end_glitch3 = lg.newImage('images/bg/end-glitch3.png')
			loadNoise()
			loadVignette()
		end
		if arg1 == 'show_noise' then
			loadNoise()
		elseif arg1 == 'show_vignette' then
			loadVignette()
		end
	end
end

function event_initstart(etype,arg1,arg2)
	event_init(etype,arg1,arg2)
	if xaload == 2 then event_start(etype,arg1,arg2) end
end

function event_endnext()
	cl = cl + 1
	xaload = 0
	unitimer = 0
	collectgarbage()
	collectgarbage()
end

function event_end(arg1)
	event_enabled = false
	event_timer = 0
	textbox_enabled = true
	bgimg_disabled = false
	
	if arg1 == 's_kill' then
		s_kill = nil
		s_kill2 = nil
		s_kill_bg = nil
		s_kill_bg2 = nil
		s_kill_bgzoom = nil
		splash_glitch = nil
		exception = nil
		posX = -40
		posY = 0
	elseif arg1 == 'next' then
		event_endnext()
	elseif arg1 == 's_glitch' then
		s_glitch1 = nil
		s_glitch2 = nil
	elseif arg1 == 'n_blackeyes' then
		n_blackeyes = nil
		event_endnext()
	elseif arg1 == 'ny_argument2' then
		vignette = nil
		unloadanimframe()
		event_endnext()
	elseif arg1 == 'yuri_glitch' then
		unloadanimframe()
		event_endnext()
	elseif arg1 == 'show_vignette' then
		vignette = nil
	elseif arg1 == 'yuri_eyes' then
		eyes1 = nil
		eyes2 = nil
		event_endnext()
	elseif arg1 == 'yuri_ch23' then
		eyes1 = nil
		bg_glitch = nil
		unloadanimframe()
	elseif arg1 == 'm_ch23ex' then
		ex3top = nil
		ex3bottom = nil
	elseif arg1 == 'natsuki_ch22' then
		ghost3 = nil
		ghost3_1 = nil
		ghost3_2 = nil
		ghost3_3 = nil
		ghost_blood = nil
		event_endnext()
	elseif arg1 == 'yuri_kill' then
		stab1 = nil
		stab2 = nil
		stab3 = nil
		stab4 = nil
		stab5 = nil
		stab6 = nil
		stab6f = nil
		event_endnext()
	elseif arg1 == 'monika_end' then
		unloadanimframe()
		event_endnext()
	elseif arg1 == 'beforecredits' then
		end_glitch1 = nil
		end_glitch2 = nil
		end_glitch3 = nil
		unloadanimframe()
		event_endnext()
	end
end

function updateConsole(text,text2,text3)
	if console_font == nil then console_font = lg.newFont('fonts/F25_Bank_Printer') end
	if console_enabled ~= true then console_enabled = true end
	console_text1 = dripText(text,30,myTextStartTime)
	if text2 then console_text2 = text2 else console_text2 = '' end
	if text3 then console_text3 = text3 else console_text3 = '' end
end