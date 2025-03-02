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
local Path = require(Modules.Path)

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
	self.Equipped = Value.new()
	self.EquipTrove = Trove.new()
	self.CachedItem = nil

	self.Abilities = {
		'Item'
	}

	self.Trove = Trove.new()
	self.Combo = nil

	self.Equipped.Changed:Connect(function(oldItem, newItem)
		print(oldItem, '->', newItem)

		if oldItem then
			local oldAbilities = Tree.Find(Abilities, oldItem)
			for _, oldAbility in oldAbilities:GetChildren() do
				self:RemoveAbility(Path(Abilities, oldAbility, true))
			end
		end

		if newItem then
			local newAbilities = Tree.Find(Abilities, newItem)
			for _, newAbility in newAbilities:GetChildren() do
				self:AddAbility(Path(Abilities, newAbility, true))
			end
		end

		print(self.Abilities)
	end)

	Battle.Instances[Character] = self

	return self
end

function Battle:RemoveAbility(ability)
	local abilityIndex = table.find(self.Abilities, ability)
	if abilityIndex then
		table.remove(self.Abilities, abilityIndex)
	end
end

function Battle:AddAbility(ability : string)
	local alreadyExists = table.find(self.Abilities, ability)
	if alreadyExists then return end
	table.insert(self.Abilities, ability)
end

function Battle:Activate(abilityPath, playerData)
	if not table.find(self.Abilities, abilityPath) then return end

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

	return true
end

function Battle:Equip(weaponPath)
	local equipAbilityPath = weaponPath .. '/Equip'
	local doesEquipAbilityExist = Tree.Exists(Abilities, equipAbilityPath)

	if doesEquipAbilityExist then
		--> If the weapon has a unique Equip
		local equipAbility = Tree.Find(Abilities, equipAbilityPath)
		self:Activate(equipAbility)
	else
		--> Common Item Equip Pipeline
		self:Activate('Item', {Path = weaponPath, Action = 'Equip'})
	end
end

function Battle:Unequip()
	print('Unequipped!')
	self.EquipTrove:Clean()
	self.Equipped:Set()
end

return Battle
