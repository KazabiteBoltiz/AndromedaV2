local RepS = game:GetService('ReplicatedStorage')
local Modules = RepS.Modules
local Spark = require(Modules.Spark)

local Packages = RepS.Packages
local Symbol = require(Packages.Symbol)

local HTTPService = game:GetService('HttpService')

local VisualEvent = Spark.Event('VisualEvent')

--[[

# OBJECTIVE

To simplify cleaning up of effects and not
having to Trove:Add() everything again.

This module makes it possible to just do
Trove:Add(Effect.Start(...))

as opposed to the uglier former variant,

VisualEvent:Fire(Character, EffectName, ...)
Trove:Add(function()
	VisualEvent:Fire(Character, EffectName, 'End')
end)

]]

return {
	Start = function(character, visualPath, ...)
		local effectID = HTTPService:GenerateGUID(false)

		VisualEvent:FireAll(
			character,
			{
				Path = visualPath,
				ID = effectID
			},
			'Start',
			...
		)

		return function()
			VisualEvent:FireAll(
				character,
				{ID = effectID},
				'Destroy'
			)
		end
	end
}
