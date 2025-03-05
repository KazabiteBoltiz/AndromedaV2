return function(hum, animId, trove)
	local inst = Instance.new('Animation')
	inst.AnimationId = animId
	if trove then trove:Add(inst) end

	local track = hum:LoadAnimation(inst)
	if trove then trove:Add(track, 'Stop') end

	return track, inst
end
