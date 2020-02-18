-------------------------------------
--- UTILITIES
-------------------------------------

Utils = {}
Utils.__index = Utils

-- Detect admin privileges 
function Utils:PlyIsAdmin(ply)
	-- fakeHostPly
	if SERVER and ply == Ply:GetFakeHostPly() then
		return true
	end

	-- Trash
	if not IsValid(ply) or IsValid(ply) and not ply:IsPlayer() then
		return false
	end

	-- General admin check
	if not ply:IsAdmin() and GetConVar("mapret_admin"):GetString() == "1" then
		if CLIENT then
			ply:PrintMessage(HUD_PRINTTALK, "[Map Retexturizer] Sorry, this tool is configured for administrators only!")
		end

		return false
	end

	return true
end
