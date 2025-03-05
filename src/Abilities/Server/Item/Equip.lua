local ServerScripts = game:GetService('ServerScriptService')
local Systems = ServerScripts.Systems
local Abilities = ServerScripts.Abilities
local Effect = require(Systems.Effect)
local Ability = require(Systems.Ability)
local Status = Ability.Status

local RepS = game:GetService('ReplicatedStorage')
local Packages = RepS.Packages
local Tree = require(Packages.Tree)
-- local Assets = RepS.Assets

local Modules = RepS.Modules
local GetAnim = require(Modules.GetAnim)

local Item = require(script.Parent)

return {
	Status = Status.Open,
	Start = function(battleInst, abilityInst, playerData)
		local myTrove = abilityInst.Trove
		local Character = battleInst.Character

		battleInst.Status:Set(Status.Locked)
		myTrove:Add(function()
			battleInst.Status:Set(Status.Open)
		end)

		local itemData = require(Tree.Find(
			Abilities,
			playerData.Path
		))

		battleInst.EquipTrove:Clean()
		battleInst.Equipped:Set(playerData.Path)

		local Humanoid = Character.Humanoid

		local equipAnimID = itemData.EquipAnim or Item.EquipAnim
		local idleAnimID = itemData.IdleAnim or Item.IdleAnim

		local equipTrack = GetAnim(
			Humanoid,
			equipAnimID,
			battleInst.EquipTrove
		)
		local idleTrack = GetAnim(
			Humanoid,
			idleAnimID,
			battleInst.EquipTrove
		)

		equipTrack:Play()
		idleTrack:Play(.3)

		local itemModel = itemData.Model:Clone()
		local playerGrip = Character.WeaponGrip
		local itemGrip = itemModel.Grip

		local gripWeld = Instance.new('WeldConstraint')
		gripWeld.Part0 = playerGrip

		itemModel:PivotTo(playerGrip.CFrame)

		gripWeld.Part1 = itemGrip
		gripWeld.Parent = itemGrip

		itemModel.Parent = Character

		battleInst.EquipTrove:Add(itemModel)
		battleInst.EquipTrove:Add(gripWeld)

		myTrove:Add(Effect.Start(
			Character,
			'Basic/Blink',
			Color3.new(1,1,1),
			itemModel,
			1,
			.3
		))

		myTrove:Add(task.delay(.6, function()
			myTrove:Clean()
		end))
	end
}
