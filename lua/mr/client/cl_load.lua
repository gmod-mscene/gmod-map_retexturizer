-------------------------------------
--- LOAD
-------------------------------------

local Load = {}
Load.__index = Load
MR.CL.Load = Load

net.Receive("CL.Load:Delete_Finish", function()
	Load:Delete_Finish(net.ReadString())
end)

-- Delete a saved file: client
function Load:Delete()
	-- Get the load name and check if it's no empty
	local loadName = MR.CL.GUI:GetLoadText():GetSelected()

	if not loadName or loadName == "" then
		return
	end

	-- Ask if the player really wants to delete the file
	-- Note: this window code is used more than once but I can't put it inside
	-- a function because the buttons never return true or false on time.
	local qPanel = vgui.Create("DFrame")
		qPanel:SetTitle("Deletion Confirmation")
		qPanel:SetSize(284, 95)
		qPanel:SetPos(10, 10)
		qPanel:SetDeleteOnClose(true)
		qPanel:SetVisible(true)
		qPanel:SetDraggable(true)
		qPanel:ShowCloseButton(true)
		qPanel:MakePopup(true)
		qPanel:Center()

	local text = vgui.Create("DLabel", qPanel)
		text:SetPos(10, 25)
		text:SetSize(300, 25)
		text:SetText("Are you sure you want to delete "..MR.CL.GUI:GetLoadText():GetSelected().."?")

	local buttonYes = vgui.Create("DButton", qPanel)
		buttonYes:SetPos(24, 50)
		buttonYes:SetText("Yes")
		buttonYes:SetSize(120, 30)
		buttonYes.DoClick = function()
			-- Remove the load on every client
			qPanel:Close()
			net.Start("SV.Load:Delete")
				net.WriteString(loadName)
			net.SendToServer()
		end

	local buttonNo = vgui.Create("DButton", qPanel)
		buttonNo:SetPos(144, 50)
		buttonNo:SetText("No")
		buttonNo:SetSize(120, 30)
		buttonNo.DoClick = function()
			qPanel:Close()
		end
end

-- Delete a saved file: client part 2
function Load:Delete_Finish(loadName)
	MR.Load:SetOption(loadName, nil)
	MR.CL.GUI:GetLoadText():Clear()

	for k,v in pairs(MR.Load:GetList()) do
		MR.CL.GUI:GetLoadText():AddChoice(k)
	end
end
