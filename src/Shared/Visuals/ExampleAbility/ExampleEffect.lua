local function Public(Character, Trove, ...)
	print('Public Effect!')
end

local function Private(Character, Trove, ...)
	print('Private Effect')
end

return {
	Public = Public,
	Private = Private
}
