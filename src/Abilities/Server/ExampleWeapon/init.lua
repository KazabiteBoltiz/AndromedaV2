local RepS = game:GetService('ReplicatedStorage')
local Assets = RepS.Assets

return {
	Assets = Tree.Find(Assets, 'ExampleWeapon')
}
