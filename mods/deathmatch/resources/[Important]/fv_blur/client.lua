local sx, sy = guiGetScreenSize()

local myScreenSource = dxCreateScreenSource(sx/2, sy/2)
local blurHShader,tecName = dxCreateShader("blurH.fx")
local blurVShader,tecName = dxCreateShader("blurV.fx")

function createBlur()
	local col = tocolor (255,255,255,255)
	local colForBackground = tocolor (255,255,255,255*0.85)
			
	RTPool.frameStart()
	dxUpdateScreenSource(myScreenSource)
	local current = myScreenSource
			
	current = applyDownsample( current )
	current = applyGBlurH(current, Settings.var.bloom)
	current = applyGBlurV(current, Settings.var.bloom)
	dxSetRenderTarget()
	dxDrawImage(0, 0, sx, sy, current, 0,0,0, col)
	-- sötétítés
	dxDrawRectangle ( 0,0, sx, sy, tocolor ( 0,0,0,50 ) )
end

 
------------------
-------blur-------
------------------

Settings = {}
Settings.var = {}
Settings.var.cutoff = 0
Settings.var.power = 10
Settings.var.bloom = 1.2

function applyDownsample( Src, amount )
	amount = amount or 2.5
	local mx,my = dxGetMaterialSize( Src )
	mx = mx / amount
	my = my / amount
	local newRT = RTPool.GetUnused(mx,my)
	dxSetRenderTarget( newRT )
	dxDrawImage( 0, 0, mx, my, Src )
	return newRT
end

function applyGBlurH( Src, bloom )
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurHShader, "tex0", Src )
	dxSetShaderValue( blurHShader, "tex0size", mx,my )
	dxSetShaderValue( blurHShader, "bloom", bloom )
	dxDrawImage( 0, 0, mx, my, blurHShader )
	return newRT
end

function applyGBlurV( Src, bloom )
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurVShader, "tex0", Src )
	dxSetShaderValue( blurVShader, "tex0size", mx,my )
	dxSetShaderValue( blurVShader, "bloom", bloom )
	dxDrawImage( 0, 0, mx,my, blurVShader )
	return newRT
end

RTPool = {}
RTPool.list = {}

function RTPool.frameStart()
	for rt,info in pairs(RTPool.list) do
		info.bInUse = false
	end
end

function RTPool.GetUnused( mx, my )
	-- Find unused existing
	for rt,info in pairs(RTPool.list) do
		if not info.bInUse and info.mx == mx and info.my == my then
			info.bInUse = true
			return rt
		end
	end
	-- Add new
	local rt = dxCreateRenderTarget(mx, my)
	if rt then
		RTPool.list[rt] = {bInUse = true, mx = mx, my = my}
	end
	return rt
end