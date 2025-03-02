local CAS = game:GetService('ContextActionService')

local RepS = game:GetService('ReplicatedStorage')
local Modules = RepS.Modules
local Spark = require(Modules.Spark)

local AbilityEvent = Spark.Event('AbilityEvent')

local Keybinds = {
	Aug1 = Enum.KeyCode.Q,
	Aug2 = Enum.KeyCode.E
}

for action, key in Keybinds do
	CAS:BindAction(
		action,
		function(actionName, inputState)
			if actionName == action
				and inputState == Enum.UserInputState.Begin
			then
				AbilityEvent:Fire(action)
			end
		end,
		false,
		key
	)
end

local EquipEvent = Spark.Event('EquipEvent')
CAS:BindAction('Primary', function(actionName, inputState)
	if actionName == 'Primary' and inputState == Enum.UserInputState.Begin then
		EquipEvent:Fire('Primary')
	end
end, false, Enum.KeyCode.One)
