quitTypes = {
  ["Unknown"] = "Unknown",
  ["Quit"] = "Quit",
  ["Kicked"] = "Kicked",
  ["Timed out"] = "Timed out",
}
 
function playerLeaveServer(quitType)
    local x,y,z = getElementPosition(source)
    local px, py, pz = getElementPosition(localPlayer)
    if getDistanceBetweenPoints3D(x, y, z, px, py, pz)<30 then
    outputChatBox(exports.fv_engine:getServerSyntax("Egress","red")..getPlayerName(source):gsub("_"," ").."#ffffff has left near you (Reason: "..exports.fv_engine:getServerColor("red",true)..quitTypes[quitType].."#ffffff ).", 255, 255, 255, true)
    end
end
addEventHandler("onClientPlayerQuit", root, playerLeaveServer)	