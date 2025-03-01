local Players = game:GetService('Players')
local Player = Players.LocalPlayer

local RepS = game:GetService('ReplicatedStorage')
local Modules = RepS.Modules
local Spark = require(Modules.Spark)

local Packages = RepS.Packages
local Tree = require(Packages.Tree)
local Trove = require(Packages.Trove)

local Visuals = RepS.Visuals
local VisualEvent = Spark.Event('VisualEvent')

local visualInstances = {}

VisualEvent.Fired:Connect(function(character, effectData, action, ...)
	local visualInstance = visualInstances[character]
	if not visualInstance then
		visualInstances[character] = {}
	end

	-- print(
	-- 	'[FX] Character:', character,
	-- 	'EffectPath:', effectData.Path,
	-- 	'EffectID:', effectData.ID
	-- )

	if action == 'Start' then
		local thisTrove = Trove.new()

		local visualModule = require(
			Tree.Find(Visuals, effectData.Path, 'ModuleScript')
		)
		visualInstances[character][effectData.ID] = thisTrove

		local targetPlayer = Players:GetPlayerFromCharacter(character)
		if targetPlayer == Player then
			visualModule.Private(character, thisTrove, ...)
		end
		visualModule.Public(character, thisTrove, ...)
	elseif action == 'Destroy' then
		local effectID = effectData.ID
		local effectTrove = visualInstance[effectID]

		if effectTrove then
			effectTrove:Clean()
			visualInstances[character][effectID] = nil
		end
	end
end)
