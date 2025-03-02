local ServerScripts = game:GetService('ServerScriptService')
local Systems = ServerScripts.Systems
-- local Effect = require(Systems.Effect)
local Ability = require(Systems.Ability)
local Status = Ability.Status

return {
	Status = Status.Open,
	Start = function(battleInst, abilityInst, playerData)
		local myTrove = abilityInst.Trove
		local Character = battleInst.Character

		battleInst.Status:Set(Status.Locked)
		myTrove:Add(function()
			battleInst.Status:Set(Status.Open)
		end)

		battleInst.EquipTrove:Add(function()
			print('Cleaned Up Equipped Weapon')
		end)

		myTrove:Add(task.delay(2, function()
			battleInst.EquipTrove:Clean()
			battleInst.Equipped:Set(playerData.Path)
			myTrove:Clean()
		end))
	end
}
