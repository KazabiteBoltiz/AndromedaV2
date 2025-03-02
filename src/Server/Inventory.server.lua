local RepS = game.ReplicatedStorage
local Modules = RepS.Modules
local Spark = require(Modules.Spark)

local ServerScripts = game:GetService('ServerScriptService')
local Systems = ServerScripts.Systems
local Battle = require(Systems.Battle)
local Ability = require(Systems.Ability)

local EquipEvent = Spark.Event('EquipEvent')

--// DataStore Management

local ServerModules = ServerScripts.Modules
local ProfileStore = require(ServerModules.ProfileStore)

local HotbarTemplate = {
	Slots = {
		Primary = 'ExampleWeapon'
	},
}

local Players = game:GetService("Players")

local PlayerStore = ProfileStore.New("HotbarStore_test", HotbarTemplate)
local Profiles: {[Player]: typeof(PlayerStore:StartSessionAsync())} = {}

local function PlayerAdded(player)
   local profile = PlayerStore:StartSessionAsync(`{player.UserId}`, {
      Cancel = function()
         return player.Parent ~= Players
      end,
   })

   if profile ~= nil then
      profile:AddUserId(player.UserId)
      profile:Reconcile()
      profile.OnSessionEnd:Connect(function()
         Profiles[player] = nil
         player:Kick(`Profile session end - Please rejoin`)
      end)
      if player.Parent == Players then
         Profiles[player] = profile
      else
         profile:EndSession()
      end
   else
      player:Kick('Player Profile Unavailable. Please Rejoin!')
   end
end

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(player)
   local profile = Profiles[player]
   if profile ~= nil then
      profile:EndSession()
   end
end)

--//

local function EquipItem(Character, itemPath)
	local battleInst = Battle.Instances[Character]
	if not battleInst then return end

	local currentStatus = battleInst.Status:Get()
	if currentStatus ~= Ability.Status.Open then return end

	if battleInst.Equipped:Get() == itemPath then
		--> Unequip Whatever is Equipped
		battleInst:Unequip()
		return
	end

	--> Valid Equip Request!
	battleInst:Equip(itemPath)
end

EquipEvent.Fired:Connect(function(player, slot)
	local Hotbar =	Profiles[player]

	local doesItemExist = Hotbar[slot]
	if not doesItemExist or doesItemExist == '' then return end

	local Character = player.Character
	if not Character then return end

	EquipItem(Character, doesItemExist)
end)
