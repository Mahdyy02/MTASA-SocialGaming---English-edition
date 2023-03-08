

function applyanim(p, a, b, c, d, e, f, g)

setPedAnimation(p, a, b, c, d, e, f, g)

end
addEvent("applyanim", true)
addEventHandler("applyanim", getRootElement(), applyanim)

function stopanim(p)
setPedAnimation(p)
end
addEvent("stopanim", true)
addEventHandler("stopanim", getRootElement(), stopanim)

function removeanim(p)
setPedAnimation(p)

end
addEvent("removeanim", true)
addEventHandler("removeanim", getRootElement(), removeanim)

function applyfastanim(p, g, h, i, j, k, l)
	setPedAnimation(p, g, h, i, j, k, l)
end
addEvent("applyfastanim", true)
addEventHandler("applyfastanim", getRootElement(), applyfastanim)