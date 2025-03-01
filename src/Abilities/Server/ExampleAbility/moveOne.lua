local ServerScripts = game:GetService('ServerScriptService')
local Systems = ServerScripts.Systems
local Effect = require(Systems.Effect)
local Ability = require(Systems.Ability)
local Status = Ability.Status

return {
	Status = Status.Open,
	Start = function(battleInst, abilityInst, playerData)
		local myTrove = abilityInst.Trove:Extend()
		local Character = battleInst.Character

		battleInst.Status = Status.Locked

		myTrove:Add(Effect.Start(
			Character,
			'ExampleAbility/ExampleEffect',
			Vector3.new(1,0,0)
		))

		myTrove:Add(task.delay(3, function()
			battleInst.Status = Status.Open
			myTrove:Clean()
		end))
	end
}
