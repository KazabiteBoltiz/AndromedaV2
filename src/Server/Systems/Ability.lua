--[[

# OBJECTIVE

- To contain a set of Moves that can either
serve as variants or next in-line if the
previous Move is successful (Autocombos).

- Moves within an Ability are not meant to be
the only combos that are legal. Abilities
may be chained with Moves from other Abilities
to create mix-ups.

PROBLEM 1 (SOLVED): How do we decide the next move
given the previous move that landed?

- To set up the triggers for the visuals and
client side abilities that are called in the
main runtime of the server-sided Ability code.

- To use paths to generate and give a unique
address to every Move and Ability. (Use Trees
for this)

]]

local RepS = game:GetService('ReplicatedStorage')
local Modules = RepS.Modules
local Path = require(Modules.Path)
local Spark = require(Modules.Spark)
-- local Value = require(Modules.Value)

local AbilityEvent = Spark.Event('AbilityEvent')

local Packages = RepS.Packages
local EnumList = require(Packages.EnumList)
local Trove = require(Packages.Trove)

local ServerScripts = game:GetService('ServerScriptService')
local Abilities = ServerScripts.Abilities

local Ability = {
	Priority = EnumList.new('AbilityPriority', {
		'Ultimate',
		'Guardbreak',
		'Heavy',
		'Light',
		'Passive',
		'None'
	}),

	Status = EnumList.new('AbilityStatus', {
		'Open',
		'Low',
		'Standard',
		'High',
		'Locked'
	})
}
Ability.__index = Ability

function Ability.new(battleInst, abilityRoot, playerData, startMove)
	local self = setmetatable({}, Ability)

	self.Battle = battleInst
	self.Path = Path(Abilities, abilityRoot, true)
	self.Trove = battleInst.Trove:Extend()

	self.Moves = {}
	for _, moveModule in abilityRoot:GetChildren() do
		self.Moves[moveModule.Name] = require(moveModule)
	end

	--[[
		If no startMove exists, it means that
		the choice of move depends on some logic.

		abilityRoot.GetMove() returns the move
		to be used, returning the next move if the
		ability has an autocombo feature, or the
		move if it has a variant move feature.
	]]

	if not startMove then
		startMove = require(abilityRoot).GetMove(
			battleInst,
			playerData
		)
	end

	self:Switch(startMove, playerData)

	return self
end

function Ability:Switch(newMoveName, playerData)
	local newMove = self.Moves[newMoveName]
	if not newMove then return end

	self.Trove:Clean()

	--> Basic Start/End Replication
	AbilityEvent:Fire(
		self.Battle.Character,
		self.Path .. '/' .. newMoveName,
		'Start'
	)

	self.Trove:Add(function()
		self.Battle.ActiveAbility:Set()
		AbilityEvent:Fire(
			self.Battle.Character,
			self.Path .. '/' .. newMoveName,
			'End'
		)
	end)

	--> Actually starting the Move
	newMove.Start(
		self.Battle,
		self,
		playerData
	)
end

return Ability
