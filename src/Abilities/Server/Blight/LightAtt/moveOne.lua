local ServerScripts = game:GetService('ServerScriptService')
local Systems = ServerScripts.Systems
local Effect = require(Systems.Effect)
local Ability = require(Systems.Ability)
local Status = Ability.Status

return {
	Status = Status.Open,
	Start = function(battleInst, abilityInst, playerData)
		local myTrove = abilityInst.Trove
		local Character = battleInst.Character

		battleInst.Status:Set(Status.Locked)

		myTrove:Add(Effect.Start(
			Character,
			'Blight/LightAtt/Swing'
		))

		myTrove:Add(task.delay(3, function()
			battleInst.Status:Set(Status.Open)
			myTrove:Clean()
		end))
	end
}
