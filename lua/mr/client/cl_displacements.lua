--------------------------------
--- DISPLACEMENTS
--------------------------------

local Displacements = {}
Displacements.__index = Displacements
MR.CL.Displacements = Displacements

-- A dirty hack to make all the displacements darker, since the tool does it with these materials
local displacements = {
	initHhack = false
}

function Displacements:InitHack()
	if displacements.initHack then
		return
	end

	for k,v in pairs(MR.Displacements:GetDetected()) do
		local data = MR.Data:CreateFromMaterial(k)

		data.newMaterial = nil
		data.newMaterial2 = nil

		MR.CL.Map:Set(data)
	end

	displacements.initHack = true
end

-- Change the displacements: client
function Displacements:Set(applyProperties)
	local displacement, _ = MR.CL.GUI:GetDisplacementsCombo():GetSelected()
	local newMaterial = MR.CL.GUI:GetDisplacementsText1():GetValue()
	local newMaterial2 = MR.CL.GUI:GetDisplacementsText2():GetValue()
	local list = MR.Displacements:GetList()
	local data = applyProperties and MR.Data:Create(LocalPlayer()) or MR.Data.list:GetElement(list, displacement) or {}

	-- No displacement selected
	if not list or not displacement or displacement == "" then
		return false
	end

	-- Validate empty fields
	if newMaterial == "" then
		newMaterial = list[displacement][1]

		timer.Create("MRText1Update", 0.5, 1, function()
			MR.CL.GUI:GetDisplacementsText1():SetValue(newMaterial)
		end)
	end

	if newMaterial2 == "" then
		newMaterial2 = list[displacement][2]

		timer.Create("MRText2Update", 0.5, 1, function()
			MR.CL.GUI:GetDisplacementsText2():SetValue(newMaterial2)
		end)
	end

	-- Adjustments to the data table
	if table.Count(data) > 0 then
		data.oldMaterial = displacement
	end

	-- Start the change
	net.Start("SV.Displacements:Set")
		net.WriteString(displacement)
		net.WriteString(newMaterial or "")
		net.WriteString(newMaterial2 or "")
		net.WriteTable(data)
	net.SendToServer()
end
