--SocialGaming 2019
--Scriptet Írte: Csoki

local progress = 200;
local timer = true;
local handled = false;
local target = 0;

function increase( limit )
	if limit then
		target = target + 2;
		if target >= limit then
			if isTimer( timer ) then
				return limit;
			end
			timer = setTimer( function( )
				setVehicleWheelStates( getPedOccupiedVehicle( localPlayer ), -1, 1, -1, 1 );
			end, 7000, 1 );
			return limit;
		else
			return target;
		end;
	end;
	return false;
end;

function render( )
	local w = increase( progress );
	-- local _progrees = dxDrawRectangle( progrees.x, progrees.y, w, progrees.h, tocolor( progrees.r, progrees.g, progrees.b, progrees.a ), true ); --DEV
end;

addEventHandler( "onClientRender", root,
	function( )
		local vehicle = getPedOccupiedVehicle( localPlayer );
		if not vehicle or getVehicleOccupant( vehicle, 0 ) ~= localPlayer or getVehicleEngineState( vehicle ) ~= true or exports.fv_vehicle:getVehicleSpeed( vehicle ) > 2 then
			if handled then
				handled = false;
				removeEventHandler( "onClientRender", root, render );
			end
			if isTimer( timer ) then
				killTimer( timer );
				timer = true;
			end;
			target = 0;
			return;
		end;
		if getKeyState( "w" ) ~= true or getKeyState( "s" ) ~= true then
			if handled then
				handled = false;
				removeEventHandler( "onClientRender", root, render );
			end
			if isTimer( timer ) then
				killTimer( timer );
				timer = true;
			end;
			target = 0;
			return;
		end;
		if not handled then
			handled = true;
			addEventHandler( "onClientRender", root, render );
		end
	end
);