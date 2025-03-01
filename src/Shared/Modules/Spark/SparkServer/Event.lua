local RepS = game:GetService('ReplicatedStorage')
local SparkFolder = RepS:WaitForChild('SparkFolder')
local SparkEvents = SparkFolder:WaitForChild('Events')

local Players = game:GetService('Players')

local Packages = RepS.Packages
local Signal = require(Packages.Signal)

local Event = {}
Event.__index = Event

function Event.new(name)
	local self = setmetatable({}, Event)

	self.Name = name

	local myInst = Instance.new('RemoteEvent')
	myInst.Name = name
	myInst.Parent = SparkEvents
	self.Inst = myInst
    self.Fired = Signal.new()

    self.Inst.OnServerEvent:Connect(function(...)
        self.Fired:Fire(...)
    end)

	return self
end

function Event:Fire(playerOrCharacter, ...)
	local player = nil
	if playerOrCharacter:IsA('Model') then
		player = Players:GetPlayerFromCharacter(
			playerOrCharacter
		)
	end

	if playerOrCharacter:IsA('Player') or player then
		if not self.Inst then return end
		self.Inst:FireClient(player, ...)
	else
		self.Fired:Fire(playerOrCharacter, ...)
	end
end

function Event:FireAll(...)
    if not self.Inst then return end
    self.Inst:FireAllClients(...)
end

function Event:Destroy()
	self.Inst:Destroy()
end

return Event
