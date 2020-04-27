-------------------------------------
--- LOAD
-------------------------------------

local Load = {}
Load.__index = Load
MR.Load = Load

-- List of save names
local load = {
	list = {}
}

-- Networking
net.Receive("Load:SetList", function()
	if SERVER then return; end

	 Load:SetList(net.ReadTable())
end)

-- Get the laod list
function Load:GetList()
	return load.list
end

-- Receive the full load list after the first spawn
function Load:SetList(list)
	load.list = list
end

-- Get a load from the list
function Load:GetOption(saveName)
	return load.list[saveName]
end

-- Set a new load on the list
function Load:SetOption(saveName, saveFile)
	load.list[saveName] = saveFile
end
