local RepS = game:GetService('ReplicatedStorage')
local Assets = RepS.Assets
local OutlineModel = Assets.Basic.Outline

local BaseBodyParts = {
	'Head', 'Torso',
	'Left Arm', 'Left Leg',
	'Right Arm', 'Right Leg'
}

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local outline = OutlineModel:Clone()
		--outline:SetPrimaryPartCFrame(character.Torso.CFrame)

		for _, outlinePart in pairs(outline:GetChildren()) do
			if not table.find(BaseBodyParts, outlinePart.Name) then
				continue
			end
			local realPart = character[outlinePart.Name]

			outlinePart.CFrame = realPart.CFrame
			outlinePart.WeldConstraint.Part1 = realPart
		end

		for _, realFinger in character['Left Hand']:GetChildren() do
			local outlineFinger = outline['Finger']:Clone()

			if string.find(realFinger.Name, 'Thumb') then
				outlineFinger.Mesh.Scale =
					(outlineFinger.Mesh.Scale * Vector3.new(1,0,1))
					- (Vector3.yAxis * .23)
			end

			outlineFinger.CFrame = realFinger.CFrame
			outlineFinger.WeldConstraint.Part1 = realFinger
			outlineFinger.Parent = outline
		end

		for _, realFinger in character['Right Hand']:GetChildren() do
			local outlineFinger = outline['Finger']:Clone()

			if string.find(realFinger.Name, 'Thumb') then
				outlineFinger.Mesh.Scale =
					(outlineFinger.Mesh.Scale * Vector3.new(1,0,1))
				- (Vector3.yAxis * .23)
			end

			outlineFinger.CFrame = realFinger.CFrame
			outlineFinger.WeldConstraint.Part1 = realFinger
			outlineFinger.Parent = outline
		end

		outline.Parent = character
	end)
end)
