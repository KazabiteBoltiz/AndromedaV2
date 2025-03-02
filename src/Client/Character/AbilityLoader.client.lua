local RepS = game:GetService('ReplicatedStorage')
local Modules = RepS.Modules
local Spark = require(Modules.Spark)

local Character = script.Parent

local Packages = RepS.Packages
local Trove = require(Packages.Trove)
local Tree = require(Packages.Tree)

local Abilities = RepS.Abilities

local AbilityEvent = Spark.Event('AbilityEvent')

local abilityTrove = Trove.new()

AbilityEvent.Fired:Connect(function(movePath, action, ...)
	abilityTrove:Clean()

	if not Tree.Exists(Abilities, movePath) then
		return
	end

	if action == 'Start' then
		local moveModule = require(
			Tree.Find(Abilities, movePath)
		)
		moveModule(Character, abilityTrove)
	end
end)
