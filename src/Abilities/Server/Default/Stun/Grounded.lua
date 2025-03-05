local ServerScripts = game:GetService('ServerScriptService')
local Systems = ServerScripts.Systems
local Abilities = ServerScripts.Abilities
local Effect = require(Systems.Effect)
local Ability = require(Systems.Ability)
local Status = Ability.Status

local RepS = game:GetService('ReplicatedStorage')
local Packages = RepS.Packages
local Tree = require(Packages.Tree)

local Modules = RepS.Modules
local GetAnim = require(Modules.GetAnim)

return {
	Status = Status.Open,
	Start = function(battleInst, abilityInst, duration)
		local myTrove = abilityInst.Trove
		local Character = battleInst.Character

		battleInst.Status:Set(Status.Locked)
		myTrove:Add(function()
			battleInst.Status:Set(Status.Open)
		end)

		myTrove:Add(Effect.Start(
			Character,
			'Basic/Stun'
		))

		myTrove:Add(task.delay(duration, function()
			myTrove:Clean()
		end))
	end
}
