-------------------------------------
--- MAP RETEXTURIZER BASE
-------------------------------------

local GUI = MR.GUI

local gui = {
	["save"] = {
		text = ""
	},
	["load"]  = {
		text = ""
	},
	detail = "",
	["skybox"] = {
		combo = ""
	},
	displacements = {
		text1 = "",
		text2 = "",
		combo = ""
	}
}

-- Networking
net.Receive("GUI:SetDetail", function()
	GUI:SetDetailValue(net.ReadString())
end)

net.Receive("GUI:ResetSkyboxComboValue", function()
	GUI:ResetSkyboxComboValue()
end)

net.Receive("GUI:ResetDisplacementsComboValue", function()
	GUI:ResetDisplacementsComboValue()
end)

-- Merge the above table in the shared one
table.Merge(GUI:GetTable(), gui) 

function GUI:GetSaveText()
	return gui["save"].text
end

function GUI:SetSaveText(value)
	gui["save"].text = value
end

function GUI:GetLoadText()
	return gui["load"].text
end

function GUI:SetLoadText(value)
	gui["load"].text = value
end

function GUI:GetDetail()
	return gui.detail
end

function GUI:SetDetail(value)
	gui.detail = value
end

function GUI:GetSkyboxCombo()
	return gui["skybox"].combo
end

function GUI:SetSkyboxCombo(value)
	gui["skybox"].combo = value
end

function GUI:GetDisplacementsText1()
	if SERVER then return; end

	return gui.displacements.text1
end

function GUI:SetDisplacementsText1(value)
	gui.displacements.text1 = value
end

function GUI:GetDisplacementsText2()
	return gui.displacements.text2
end

function GUI:SetDisplacementsText2(value)
	gui.displacements.text2 = value
end

function GUI:GetDisplacementsCombo()
	return gui.displacements.combo
end

function GUI:SetDisplacementsCombo(value)
	gui.displacements.combo = value
end

-- Set the detail material
function GUI:SetDetailValue(oldMaterial)
	local detail = MR.Materials:GetDetailFromMaterial(oldMaterial)

	if GUI:GetDetail() ~= "" then
		local i = 1

		for k,v in SortedPairs(MR.Materials:GetDetailList()) do
			if k == detail then
				break
			else
				i = i + 1
			end
		end

		GUI:GetDetail():ChooseOptionID(i)
	end
end

-- Reset the skybox combobox material
function GUI:ResetSkyboxComboValue()
	GUI:GetSkyboxCombo():ChooseOptionID(1)
end

-- Reset the displacements combobox material and its text fields
function GUI:ResetDisplacementsComboValue()
	-- Wait the cleanup
	timer.Create("MRWaitCleanupDispCombo", 0.3, 1, function()
		GUI:GetDisplacementsCombo():ChooseOptionID(GUI:GetDisplacementsCombo():GetSelectedID())
	end)
end
