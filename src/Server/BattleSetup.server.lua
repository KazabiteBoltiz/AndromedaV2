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
	Aug1 = 'Blight/LightAtt',
	Aug2 = '',
	LAtt = '',
	HAtt = '',
	Sp1 = '',
	Sp2 = ''
}

local playerDefaultAbilities = {
	'Default/Stun'
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

		--> Loading Default Abilities
		for _, defaultAbility in playerDefaultAbilities do
			battleInst:AddAbility(defaultAbility)
		end
	end)
end)
