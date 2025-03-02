Config = {
	DefaultMove = 'Equip'
}

Config.Trigger = function(_, _)
	return true --> Allow all ability triggers
end
Config.GetMove = function(_, playerData)
	return playerData.Action or Config.DefaultMove
end

return Config
