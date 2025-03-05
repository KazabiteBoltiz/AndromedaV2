return function(soundId, volume, parent, trove)
	local inst = Instance.new('Sound')
	inst.SoundId = soundId
	if trove then trove:Add(inst) end

	if trove then
		trove:Add(inst.Ended, function()
			inst:Destroy()
		end)
	else
		inst.Ended:Connect(function()
			inst:Destroy()
		end)
	end

	return inst
end
