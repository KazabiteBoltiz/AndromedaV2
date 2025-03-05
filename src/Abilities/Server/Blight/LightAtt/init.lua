Config = {
	DefaultMove = 'moveOne'
}


Config.Trigger = function(battleInst, playerData)
	return true --> Allow all ability triggers
end
Config.GetMove = function()
	return Config.DefaultMove --> No autocombos or variants
end

return Config
