--[[

# OBJECTIVE

- To keep track of all tools that that the
player has access to. Augments, Weapons and
Non-Weapon Abilities.

- To keep track of the armor, the status
of the active ability of the player when
they are attacked.

- To run the :Trigger() method for the
requested ability.

- To keep track of the current Combo that
the player is performing and share this data
with the active ability.

- To implement a weapon-cache system that
sheathes the activeWeapon and quick-equips
it when the player finishes a magic/augment
ability.

IN THE FUTURE: To implement an input state
to keep track of holdable abilities and
maybe to trigger abilities on release of
buttons.

]]

local RepS = game:GetService('ReplicatedStorage')
local Packages = RepS.Packages
local Tree = require(Packages.Tree)
local Trove = require(Packages.Trove)

local Modules = RepS.Modules
local Value = require(Modules.Value)

local ServerScripts = game:GetService('ServerScriptService')
local Systems = ServerScripts.Systems
local Ability = require(Systems.Ability)
local Status = Ability.Status
local Priority = Ability.Priority

local Abilities = ServerScripts.Abilities

local Battle = {
	Instances = {}
}
Battle.__index = Battle

function Battle.new(Character)
	local self = setmetatable({}, Battle)

	self.Character = Character
	self.Status = Value.new(Status.Open)
	self.Priority = Value.new(Priority.None)
	self.ActiveAbility = Value.new()
	self.Trove = Trove.new()

	Battle.Instances[Character] = self

	return self
end

function Battle:Activate(abilityPath, playerData)

	--> Ability Trigger Checking
	local abilityRootScript = Tree.Find(Abilities, abilityPath)
	local abilityRoot = require(abilityRootScript)
	if not abilityRoot.Trigger(self.Character, playerData) then
		return
	end

	--> Fighter Status Checking
	local startMove = abilityRoot.GetMove(
		self,
		playerData
	)
	local abilityStatusRequirement = require(Tree.Find(Abilities, abilityPath .. '/' .. startMove)).Status
	if self.Status:Get().Value > abilityStatusRequirement.Value then
		return
	end

	--> Ability Request Is Validated.
	self.Trove:Clean()

	self.ActiveAbility:Set(
		Ability.new(
			self,
			abilityRootScript,
			playerData,
			startMove
		)
	)
end

return Battle
