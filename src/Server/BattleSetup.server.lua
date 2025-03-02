local RepS = game.ReplicatedStorage
local Modules = RepS.Modules
local Spark = require(Modules.Spark)

local ServerScripts = game:GetService('ServerScriptService')
local Systems = ServerScripts.Systems
local Battle = require(Systems.Battle)

local Players = game:GetService('Players')

local VisualEvent = Spark.Event('VisualEvent')
local AbilityEvent = Spark.Event('AbilityEvent')

local actionToAbility = {
	Aug1 = 'ExampleWeapon/ExampleAbility',
	Aug2 = '',
	LAtt = '',
	HAtt = '',
	Sp1 = '',
	Sp2 = ''
}

AbilityEvent.Fired:Connect(function(player, action, playerData)
	local ability = actionToAbility[action]
	if ability == '' then return end

	local Character = player.Character
	if not Character then return end

	local battleInst = Battle.Instances[Character]
	if not battleInst then return end

	battleInst:Activate(ability)
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(Character)
		local battleInst = Battle.new(Character)
	end)
end)
