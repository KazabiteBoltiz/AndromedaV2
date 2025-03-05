local Tween = game:GetService('TweenService')

local function Public(_, Trove, Color, Model, Duration, DelayTime)
	local twinfo = TweenInfo.new(
		Duration,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out
	)

	for _, weaponPart in Model:GetChildren() do
		if not (weaponPart:IsA('BasePart'))
			or weaponPart:GetAttribute('BlinkIgnore')
		then
			continue
		end

		local blinkPart = weaponPart:Clone()

		if blinkPart:IsA('MeshPart') then
			blinkPart.TextureID = ''
		end

		blinkPart.Size += Vector3.one * .1

		blinkPart.Material = Enum.Material.Neon
		blinkPart.Transparency = 0
		blinkPart.Color = Color or Color3.new(1,1,1)
		blinkPart.CFrame = weaponPart.CFrame

		local blinkWeld = Instance.new('WeldConstraint')
		blinkWeld.Part0 = weaponPart
		blinkWeld.Part1 = blinkPart
		blinkWeld.Parent = blinkPart

		blinkPart.Parent = Model

		local outTween = Tween:Create(
			blinkPart,
			twinfo,
			{Transparency = 1}
		)

		Trove:Add(
			task.delay(DelayTime, function()
				outTween:Play()
			end)
		)

		Trove:Add(blinkPart)
		Trove:Add(blinkWeld)
	end
end

local function Private(Character, Trove, ...)
	return
end

return {
	Public = Public,
	Private = Private
}
