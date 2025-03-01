--[[

# OBJECTIVE

- To chain Moves from the same or different
Abilities together while keeping count of
total hits landed.

- To shut down combos if gone too long

PROBLEM 1: How to decide if the combo has
gone too long?

PROBLEM 2: How to decide the valid time
difference between lastHit and currentHit?

]]

local RepS = game:GetService('ReplicatedStorage')
local Modules = RepS.Modules
local Value = require(Modules.Value)

local Packages = RepS.Packages
local Trove = require(Packages.Trove)

local RunS = game:GetService('RunService')
local Heartbeat = RunS.Heartbeat

local Combo = {}
Combo.__index = Combo

function Combo.new()
	local self = setmetatable({}, Combo)

	self.Trove = Trove.new()
	self.HeatTarget = Value.new()
	self.Heat = 100
	self.Decay = 20

	self.Trove:Connect(self.HeatTarget.Changed, function(_, new)
		self.Heat = new
	end)

	self.Trove:Connect(Heartbeat, function(dt)
		self.Heat -= dt * self.Decay

		if self.Heat <= 0 then
			self:TimeUp()
		end
	end)

	return self
end

function Combo:TimeUp()
	print('Combo Hit Zero!')

	--// Announce Combo End!

	self:Destroy()
end

function Combo:Destroy()
	self.Trove:Clean()
end

return Combo
