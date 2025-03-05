local RepS = game:GetService('ReplicatedStorage')
local Assets = RepS.Assets
local Packages = RepS.Packages
local Tree = require(Packages.Tree)

return {
	Assets = Tree.Find(Assets, 'Blight'),

	EquipAnim = 'rbxassetid://18115807418',
	IdleAnim = 'rbxassetid://18115069270',
	Model = Tree.Find(Assets, 'Blight/Model', 'Model')
}
