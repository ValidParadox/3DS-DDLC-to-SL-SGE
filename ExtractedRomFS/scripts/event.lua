event_timer = 0
eventvar1 = 0
eventvar2 = 0
eventvar3 = 0
eventvar4 = 0
eventvar5 = 0
sectimer = 0

function loadNoise()
	for i = 1, 4 do
		loadstring('animframe'..i..' = lg.newImage("images/bg/noise'..i..'.png")')()
	end
end

function loadVignette()
	vignette = lg.newImage('images/bg/vignette.png')
end

function loadYuriGlitch()
	for i = 1, 4 do
		loadstring('animframe'..i..' = lg.newImage("images/yuri/glitch'..i..'.png")')()
	end
end

function event_start(etype, arg1)
	autotimer = 0
	autoskip = 0
	event_enabled = true
	event_type = etype
	if event_type == 's_kill_start' then
		textbox_enabled = true
		bgimg_disabled = true
	elseif string.sub(event_type,1,6) == 's_kill' then
		bgimg_disabled = true
		textbox_enabled = false
		if event_type == 's_kill' then
			audioUpdate('s_kill')
			eventvar1 = 0
			eventvar2 = 0
		end
	elseif event_type == 'wipe' then
		hideAll()
		textbox_enabled = false
		if arg1 then
			eventvar2 = arg1
		else
			eventvar2 = nil
		end
	elseif event_type == 'black' then
		textbox_enabled = true
		bgimg_disabled = true
	elseif event_type == 'endscreen' then
		hideAll()
		textbox_enabled = false
		audioUpdate('0')
	elseif event_type == 's_glitch' or event_type == 'm_glitch1' or event_type == 'n_glitch1' then
		bgimg_disabled = false
		textbox_enabled = false
	elseif event_type == 'ny_argument' then
		eventvar1 = 0
		eventvar2 = 0
		eventvar3 = {2.0,3.6,5.2,6.8,8.3,9.90,11.5,13.1,14.7,16.3,17.90,19.45,21.1,22.7,24.2,25.8}
		eventvar4 = {2.5,4.1,5.7,7.3,8.8,10.3,12.0,13.5,15.1,16.7,18.25,19.85,21.5,23.0,24.6,26.2}
		eventvar5 = 1
		bgimg_disabled = false
		textbox_enabled = true
	elseif event_type == 'yuri_eyes' then
		bgimg_disabled = false
		textbox_enabled = false
		eventvar1 = 2
		eventvar2 = -13
		eventvar3 = 0
	elseif event_type == 'faint_effect' then
		eventvar1 = 192
		bgimg_disabled = false
		textbox_enabled = true
	elseif event_type == 'yuri_glitch_head' then
		eventvar1 = arg1
		bgimg_disabled = false
		textbox_enabled = true
	elseif event_type == 'show_darkred' then
		eventvar2 = 1
		bgimg_disabled = false
		textbox_enabled = true
	elseif event_type == 'yuri_ch23_2' or event_type == 'natsuki_ch22' then
		eventvar1 = 0
		eventvar2 = 0
		eventvar3 = 0
		bgimg_disabled = false
		textbox_enabled = true
	elseif event_type == 'yuri_ch23' or event_type == 'm_ch23ex' or event_type == 'just_monika' then
		bgimg_disabled = true
		textbox_enabled = false
		if event_type == 'just_monika' then 
			alpha = 0
			if arg1 == 'ch30' then eventvar1 = 'ch30' end
		end
	elseif event_type == 'yuri_kill' then
		eventvar1 = stab1
		eventvar2 = 0
		eventvar3 = 0.025
		bgimg_disabled = true
		textbox_enabled = false
	elseif event_type == 'monika_end' then
		eventvar1 = 200
		eventvar2 = math.random(1,8)*50
		eventvar3 = math.random(1,8)*50
		eventvar5 = 0
		bgimg_disabled = false
		textbox_enabled = false
		if arg1 == 2 then
			event_timer = 0.69
			eventvar4 = 'end2'
		end
	elseif event_type == 'beforecredits' then
		eventvar1 = 0
		eventvar2 = nil
		eventvar3 = 0
		bgimg_disabled = true
		textbox_enabled = false
	else
		bgimg_disabled = false
		textbox_enabled = true
	end
	if arg1 == 'show_noise' then
		eventvar4 = 'show_noise'
	elseif arg1 == 'show_vignette' then
		eventvar4 = 'show_vignette'
	elseif arg1 == 'show_darkred' then
		eventvar4 = 'show_darkred'
	elseif arg1 == '' then
		eventvar4 = ''
	end
end

function event_draw()
	drawTopScreen()
	lg.setColor(255,255,255)
	
	if persistent.ptr <= 1 then
		if event_draw_1 then event_draw_1() end
	elseif persistent.ptr == 2 then
		if event_draw_2 then event_draw_2() end
	else
		if event_draw_3 then event_draw_3() end
	end
	
	if event_type == 'wipe' then
		lg.draw(bgch)
		lg.setColor(0,0,0,eventvar1)
		lg.rectangle('fill',0,0,400,240)
	end
	
	if event_type == 'endscreen' then
		lg.setColor(255,255,255,eventvar1)
		lg.draw(bgch)
	end
	
	if event_type == 'show_dark' then
		if bg1 ~= 'cg/monika_bg_glitch' then lg.draw(bgch) end
		drawYuri()
		if chapter == 40 then
			lg.setColor(0,0,0,128)
		else
			lg.setColor(0,0,0,192)
		end
		lg.rectangle('fill',0,0,400,240)
		lg.setColor(255,255,255,255)
		if bg1 == 'cg/monika_bg_glitch' then lg.draw(bgch) end
		if cl < 271 then drawSayori() end
		if menu_enabled then
			lg.setColor(255,255,255,128)
			lg.rectangle('fill',0,0,400,240)
		end
	end
	
	if event_type == 'just_monika' then
		lg.setBackgroundColor(255,255,255)
		if event_timer < 3.75 then
			lg.setColor(255,255,255,alpha)
			lg.draw(splash)
		else
			lg.setColor(0,0,0,alpha)
			lg.print('Just Monika.', 170, 100)
		end
	end
	
	if event_type == 'ch23-30' then
		lg.draw(bgch)
		if cg1 ~= '' then lg.draw(cgch) end
		if xaload > 0 then
			drawSayori()
			drawYuri()
			drawNatsuki()
			drawMonika()
		end
		
		drawConsole()
		
		if poem_enabled then drawPoem()	end
		
		if menu_enabled and menu_type ~= 'choice' then
			lg.setColor(255,255,255,128)
			lg.rectangle('fill',0,0,400,240)
		end
		
		lg.setColor(255,255,255,255)
	end
	
	drawBottomScreen()
	lg.setColor(255,255,255,255)
	
	if event_type == 'm_ch23ex' and event_timer > 1 then
		lg.draw(ex3bottom)
	end
	
	if bgimg_disabled ~= true then
		lg.draw(background_Image, posX, posY)
		lg.setColor(0,0,0)
	end
	
	lg.setFont(font)
	if textbox_enabled then
		drawNumbers()
		drawTextBox()	
	end
	
	if event_type == 'm_onlayer_front' or event_type == 'ny_argument2' then
		lg.setColor(255,255,255)
		drawMonika()
		textbox_enabled = true
	elseif event_type == 'yuri_ch23_2' then
		drawTopScreen()
		lg.setColor(255,255,255,eventvar2)
		drawMonika()
		drawBottomScreen()
	elseif event_type == 'show_dark' and cl >= 271 and chapter == 40 then
		drawTopScreen()
		lg.setColor(255,255,255,255)
		drawSayori()
		drawBottomScreen()
	end
	
	if menu_enabled then menu_draw() end
end

function drawanimframe(x,y)
	if x == nil then x = 0 end
	if y == nil then y = 0 end
	if animframe then
		lg.draw(animframe,x,y)
	end
	local dt = love.timer.getDelta()
	if sectimer > 0.75 and animframe4 then
		animframe = animframe4
	elseif sectimer > 0.5 and animframe3 then
		animframe = animframe3
	elseif sectimer > 0.25 and animframe2 then
		animframe = animframe2
	elseif animframe1 then
		animframe = animframe1
	end
end

function unloadanimframe()
	animframe1 = nil
	animframe2 = nil
	animframe3 = nil
	animframe4 = nil
end

function event_update(dt)
	event_timer = event_timer + dt
	
	if persistent.ptr <= 1 then
		if event_update_1 then event_update_1(dt) end
	elseif persistent.ptr == 2 then
		if event_update_2 then event_update_2(dt) end
	else
		if event_update_3 then event_update_3(dt) end
	end
	
	--wipe timers
	if event_type == 'wipe' and event_timer > 1.5 then event_end('next')
	elseif event_type == 'wipe' and event_timer >= 1 then
		eventvar1 = math.max(eventvar1 - 15, 0)
	elseif event_type == 'wipe' and event_timer > 0.5 then
		if eventvar2 and bg1 ~= eventvar2 then
			xaload = 0
			bgUpdate(eventvar2)
		end
	elseif event_type == 'wipe' and event_timer < 0.5 then
		eventvar1 = math.min(eventvar1 + 15, 255)
	end
	
	--end screen
	if event_type == 'endscreen' and event_timer > 3 then event_end('next')
	elseif event_type == 'endscreen' and event_timer >= 2.5 then
		eventvar1 = math.max(eventvar1 - 7, 0)
	elseif event_type == 'endscreen' and event_timer <= 0.5 then
		eventvar1 = math.min(eventvar1 + 7, 255)
	end
	
	if event_type == 'just_monika' then
		if event_timer <= 3 then
			alpha = math.min(alpha+7.75,255)
		elseif event_timer > 3 and event_timer < 3.75 then
			alpha = math.max(alpha-7.75,0)
		elseif event_timer <= 6 then
			if eventvar1 == 'ch30' then event_timer = 7 end
			alpha = math.min(alpha+7.75,255)
		elseif event_timer > 6 then
			alpha = 255
			event_end('next')
		end
	end
	
	if event_type == 'ch23-30' then
		if persistent.chr.m == 0 and cl < 1001 then
			scriptJump(1050)
		end
	end
end

function event_next()
	newgame_keypressed('a')
	event_timer = 0
end

function event_keypressed(key)
	if ((textbox_enabled and event_type ~= 'show_vignette') or (event_type == 'yuri_eyes' and cl < 700)) and (key == 'a' or key == 'lbutton') then
		newgame_keypressed('a')
	elseif key == 'y' and event_type == 'ch23-30' then
		menu_enable('pause2')
	end
end