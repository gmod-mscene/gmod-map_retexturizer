--------------------------------
--- MATERIALS (SKYBOX)
--------------------------------

local Skybox = MR.Skybox

local skybox = {
	-- Skybox material backup files
	backupName = "mr/backup",
	-- True if the map has a env_skypainted entity
	painted = GetConVar("sv_skyname"):GetString() == "painted" and true or false,
}

-- Networking
net.Receive("Skybox:Set_CL", function()
	Skybox:Set_CL(net.ReadString(), net.ReadBool())
end)

-- Skybox rendering hook
hook.Add("PostDraw2DSkyBox", "Skybox:Render", function()
	Skybox:Render()
end)

-- Handle the skybox materials backup
-- Render simple textures on maps withou env_skypainted
function Skybox:Set_CL(newMaterial, isBroadcasted)
	local suffixes = { "", "", "", "", "", "" }
	local i

	-- General first steps
	local check = {
		material = newMaterial
	}

	if not MR.Materials:SetFirstSteps(LocalPlayer(), isBroadcasted, check) then
		return false
	end

	-- It's the default map sky
	if newMaterial == Skybox:GetName() then
		return false
	-- It's empty or it's a HL2 sky
	elseif newMaterial == "" or Skybox:GetList()[newMaterial] then
		newMaterial = skybox.backupName
		suffixes = Skybox:GetSuffixes()
	-- It's a full 6-sided skybox
	elseif Skybox:IsValidFullSky(newMaterial:sub(1, -3)) then
		newMaterial = newMaterial:sub(1, -3) -- Clean the name suffix
		suffixes = Skybox:GetSuffixes()
	-- It's an invalid material
	elseif MR.Materials:IsValid(newMaterial) then
		return
	end
	-- if nothing above is true, it's a valid single material
	
	-- Set the original skybox backup
	-- Note: it's done once and here because it's a safe place (the game textures will be loaded for sure)
	if not Material(skybox.backupName..Skybox:GetSuffixes()[1]):GetTexture("$basetexture") then
		for i = 1,6 do
			Material(skybox.backupName..Skybox:GetSuffixes()[i]):SetTexture("$basetexture", Material(Skybox:GetName()..Skybox:GetSuffixes()[i]):GetTexture("$basetexture"))
		end
	end

	-- Change the sky material
	for i = 1,6 do 
		Material(Skybox:GetName()..Skybox:GetSuffixes()[i]):SetTexture("$basetexture", Material(newMaterial..suffixes[i]):GetTexture("$basetexture"))
	end
end

-- Render 6 side skybox materials on every map or simple materials on the skybox on maps with env_skypainted entity
function Skybox:Render()
	local distance = 200
	local width = distance * 2.01
	local height = distance * 2.01
	local newMaterial = GetConVar("internal_mr_skybox"):GetString()
	local suffixes = { "", "", "", "", "", "" }

	-- Stop renderind if there is no material
	if newMaterial == "" then
		return
	-- It's a full HL2 skybox
	elseif Skybox:GetList()[newMaterial] then
		suffixes = Skybox:GetSuffixes()
	-- It's a full 6-sided skybox
	elseif Skybox:IsValidFullSky(newMaterial:sub(1, -3)) then
		newMaterial = newMaterial:sub(1, -3)
		suffixes = Skybox:GetSuffixes()
	-- It's an invalid material
	elseif not MR.Materials:IsValid(newMaterial) then
		return
	-- It's a single material
	-- we don't need to render it here if there isn't an env_skypainted in the map
	elseif not skybox.painted then
		return
	end

	-- Render our sky box around the player
	render.OverrideDepthEnable(true, false)
	render.SetLightingMode(suffixes[1] == "" and 1 or 2)

	cam.Start3D(Vector(0, 0, 0), EyeAngles())
		render.SetMaterial(Material(newMaterial..suffixes[1])) -- ft
		render.DrawQuadEasy(Vector(0,-distance,0), Vector(0,1,0), width, height, Color(255,255,255,255), 180)
		render.SetMaterial(Material(newMaterial..suffixes[2])) -- bk
		render.DrawQuadEasy(Vector(0,distance,0), Vector(0,-1,0), width, height, Color(255,255,255,255), 180)
		render.SetMaterial(Material(newMaterial..suffixes[3])) -- lf
		render.DrawQuadEasy(Vector(-distance,0,0), Vector(1,0,0), width, height, Color(255,255,255,255), 180)
		render.SetMaterial(Material(newMaterial..suffixes[4])) -- rt
		render.DrawQuadEasy(Vector(distance,0,0), Vector(-1,0,0), width, height, Color(255,255,255,255), 180)
		render.SetMaterial(Material(newMaterial..suffixes[5])) -- up
		render.DrawQuadEasy(Vector(0,0,distance), Vector(0,0,-1), width, height, Color(255,255,255,255), 0)
		render.SetMaterial(Material(newMaterial..suffixes[6])) -- dn
		render.DrawQuadEasy(Vector(0,0,-distance), Vector(0,0,1), width, height, Color(255,255,255,255), 0)
	cam.End3D()

	render.OverrideDepthEnable(false, false)
	render.SetLightingMode(0)
end
