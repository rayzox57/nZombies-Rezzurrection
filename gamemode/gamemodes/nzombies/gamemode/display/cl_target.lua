--

local traceents = {
	["wall_buys"] = function(ent)
		local wepclass = ent:GetWepClass()
		local price = ent:GetPrice()
		local wep = weapons.Get(wepclass)
		local pap = false
		upgrade= ""
		upgrade2=""
		if wep.NZPaPReplacement then
		upgrade = wep.NZPaPReplacement
		local wep2 =  weapons.Get( wep.NZPaPReplacement)
		if  wep2.NZPaPReplacement then
		 upgrade2 = wep2.NZPaPReplacement
		else
		 upgrade2 = ""
		end
		else
		 upgrade = ""
		end
		if !wep then return "INVALID WEAPON" end
		local name = wep.PrintName
		local ammo_price = math.Round((price - (price % 10))/2)
		local text = ""
		if  LocalPlayer():HasWeapon( upgrade ) then
		 pap = true
		end
		if  LocalPlayer():HasWeapon( upgrade2 ) then
		 pap = true
		end
		
		if !LocalPlayer():HasWeapon( wepclass ) then
		if !pap then
			text = "Press E to buy " .. name .." for " .. price .. " points."
	
		
   -- text = "Press E to buy " .. name .."  Ammo refill for " .. ammo_price .. " points."


if wepclass == "nz_grenade" then
    local nade = LocalPlayer():GetItem("grenade")
    if (LocalPlayer():HasPerk("widowswine") and (!nade or nade and nade.price < 4000)) then
        text = "Press E to refill primary grenades for 4000 points."
    elseif (nade and ammo_price < nade.price) then
	 text = "Press E to refill primary grenades" .. nade.price .. " points."
    else
	text = "Press E to refill primary grenades" .. ammo_price .. " points."
    end
end
		 else
			if pap then
			text = "Press E to buy upgraded " .. name .."  Ammo refill for " .. 4500 .. " points."
			end
			end
		else
		if LocalPlayer():HasWeapon( wepclass ) then
		text = "Press E to buy " .. name .."  Ammo refill for " .. ammo_price .. " points."
		else
			text = "You already have this weapon."
			end
		end


		return text
	end,
	["breakable_entry"] = function(ent)
		if ent:GetHasPlanks() and ent:GetNumPlanks() < GetConVar("nz_difficulty_barricade_planks_max"):GetInt() then
			local text = "Hold E to rebuild the barricade."
			return text
		end
	end,
	["ammo_box"] = function(ent)
		
			local text = "Press E to buy ammo for " ..ent:GetPrice() .. " points."
			return text
		
	end,
	["stinky_lever"] = function(ent)
		
			local text = "Press E to hasten your demise"
			return text
		
	end,
	["random_box"] = function(ent)
		if !ent:GetOpen() then
			local text = nzPowerUps:IsPowerupActive("firesale") and "Press E to buy a random weapon for 10 points." or "Press E to buy a random weapon for 950 points."
			return text
		end
	end,
	["random_box_windup"] = function(ent)
		if !ent:GetWinding() and ent:GetWepClass() != "nz_box_teddy" then
			local wepclass = ent:GetWepClass()
			local wep = weapons.Get(wepclass)
			local name = "UNKNOWN"
			if wep != nil then
				name = wep.PrintName
			end
			if name == nil then name = wepclass end
			name = "Press E to take " .. name .. " from the box."

			return name
		end
	end,
	["perk_machine"] = function(ent)
		local text = ""
		if !ent:IsOn() then
			text = "No Power."
		elseif ent:GetBeingUsed() then
			text = "Currently in use."
		else
			if ent:GetPerkID() == "pap" then
				local wep = LocalPlayer():GetActiveWeapon()
				if wep:HasNZModifier("pap") then
					if wep.NZRePaPText then
						text = "Press E to "..wep.NZRePaPText.." for 3000 points."
					elseif wep:CanRerollPaP() then
						text = "Press E to reroll attachments for 3000 points."
					else
						text = "This weapon is already upgraded."
					end
				else
					text = "Press E to buy Pack-a-Punch for 5000 points."
				end
			else
				local perkData = nzPerks:Get(ent:GetPerkID())
				-- Its on local iconType = nzRound:GetIconType(nzMapping.Settings.icontype)
				if nzPerks:GetMachineType(nzMapping.Settings.perkmachinetype) == "IW" then
						text = "Press E to buy " .. perkData.name_skin .. " for " .. ent:GetPrice() .. " points."
						elseif nzRound:GetIconType(nzMapping.Settings.icontype) == "Hololive" then
						text = "Press E to buy " .. perkData.name_holo .. " for " .. ent:GetPrice() .. " points."
						else
						text = "Press E to buy " .. perkData.name .. " for " .. ent:GetPrice() .. " points."
						end
				-- Check if they already own it
				if LocalPlayer():HasPerk(ent:GetPerkID()) and (LocalPlayer():HasUpgrade(ent:GetPerkID()) or tobool(nzMapping.Settings.perkupgrades) == false) then
				
					text = "You already own this perk."
					elseif LocalPlayer():HasPerk(ent:GetPerkID()) and !LocalPlayer():HasUpgrade(ent:GetPerkID()) then
					if nzPerks:GetMachineType(nzMapping.Settings.perkmachinetype) == "IW" then
						text = "Press E to upgrade " .. perkData.name_skin .. " for " .. ent:GetPrice()*2 .. " points."
						elseif nzRound:GetIconType(nzMapping.Settings.icontype) == "Hololive" then
						text = "Press E to upgrade " .. perkData.name_holo .. " for " .. ent:GetPrice()*2 .. " points."
						else
						text = "Press E to upgrade " .. perkData.name .. " for " .. ent:GetPrice()*2 .. " points."
						end
				end
			end
		end

		return text
	end,
	["nz_teleporter"] = function(ent)
		local text = ""
		local price = ent:GetPrice()
		local enabled = ent:GetGifType()
		if price < 0 or enabled > 5 then
		text = ""
		elseif !ent:IsOn() then
			text = "No Power."
		elseif ent:GetBeingUsed() then
			text = "Currently in use."
		elseif ent:GetCooldown() then
			text = "Teleporter on cooldown!"
		else
				-- Its on
						text = "Press E to Teleport for " .. ent:GetPrice() .. " points."
			
		end

		return text
	end,
	["buyable_ending"] = function(ent)
		local text = ""
		text = "Press E to end the game for " .. ent:GetPrice() .. " points."
		return text
	end,
	["player_spawns"] = function() if nzRound:InState( ROUND_CREATE ) then return "Player Spawn" end end,
	["nz_spawn_zombie_normal"] = function() if nzRound:InState( ROUND_CREATE ) then return "Zombie Spawn" end end,
	["nz_spawn_zombie_special"] = function() if nzRound:InState( ROUND_CREATE ) then return "Zombie Special Spawn" end end,
	["nz_spawn_zombie_boss"] = function() if nzRound:InState( ROUND_CREATE ) then return "Zombie Boss Spawn" end end,
	["pap_weapon_trigger"] = function(ent)
		local wepclass = ent:GetWepClass()
		local wep = weapons.Get(wepclass)
		local name = "UNKNOWN"
		if wep != nil then
			name = nz.Display_PaPNames[wepclass] or nz.Display_PaPNames[wep.PrintName] or "Upgraded "..wep.PrintName
		end
		name = "Press E to take " .. name .. " from the machine."

		return name
	end,
	["wunderfizz_machine"] = function(ent)
		local text = ""
		if !ent:IsOn() then
			text = "The Wunderfizz Orb is currently at another location."
		elseif ent:GetBeingUsed() then
			if ent:GetUser() == LocalPlayer() and ent:GetPerkID() != "" and !ent:GetIsTeddy() then
				
				if nzPerks:GetMachineType(nzMapping.Settings.perkmachinetype) == "IW" then
						text = "Press E to take "..nzPerks:Get(ent:GetPerkID()).name_skin.." from Der Wunderfizz."
						else
						text = "Press E to take "..nzPerks:Get(ent:GetPerkID()).name.." from Der Wunderfizz."
						end
			else
				text = "Currently in use."
			end
		else
			if #LocalPlayer():GetPerks() >= GetConVar("nz_difficulty_perks_max"):GetInt() then
				text = "You cannot have more perks."
			else
				text = "Press E to buy Der Wunderfizz for " .. ent:GetPrice() .. " points."
			end
		end

		return text
	end,
	["bank"] = function(ent)

        local isDeposit = ent:GetIsDeposit() == true

		if isDeposit == true then
            local deposit  = ent:GetDeposit()
            local fee      = ent:GetDepositFee()
            local required = deposit + fee
            return string.format("Deposit %s for %s (fee : %s)",deposit,required,fee);
        else
            local writedraw = ent:GetWritedraw()
            local fee       = ent:GetWritedrawFee()
            local required = writedraw + fee
			return string.format("Writdraw %s and get %s (fee : %s)",required,writedraw,fee);
		end

	end
}

local function GetTarget()
	local tr =  {
		start = EyePos(),
		endpos = EyePos() + LocalPlayer():GetAimVector()*150,
		filter = LocalPlayer(),
	}
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end

	--print(trace.Entity:GetClass())
	return trace.Entity
end

local function GetDoorText( ent )
	local door_data = ent:GetDoorData()
	local text = ""

	if door_data and tonumber(door_data.price) == 0 and nzRound:InState(ROUND_CREATE) then
		if tobool(door_data.elec) then
			text = "This door will open when electricity is turned on."
		else
			text = "This door will open on game start."
		end
	elseif door_data and tonumber(door_data.buyable) == 1 then
		local price = tonumber(door_data.price)
		local req_elec = tobool(door_data.elec)
		local link = door_data.link

		if ent:IsLocked() then
			if req_elec and !IsElec() then
				text = "You must turn on the electricity first!"
			elseif door_data.text then
				text = door_data.text
			elseif price != 0 then
				--print("Still here", nz.nzDoors.Data.OpenedLinks[tonumber(link)])
				text = "Press E to open for " .. price .. " points."
			end
		end
		elseif door_data and tonumber(door_data.buyable) != 1 and nzRound:InState( ROUND_CREATE ) then
		text = "This door is locked and cannot be bought in-game."
		--PrintTable(door_data)
	end

	return text
end

local function GetText( ent )

	if !IsValid(ent) then return "" end
	
	if ent.GetNZTargetText then return ent:GetNZTargetText() end

	local class = ent:GetClass()
	local text = ""

	local neededcategory, deftext, hastext = ent:GetNWString("NZRequiredItem"), ent:GetNWString("NZText"), ent:GetNWString("NZHasText")
	local itemcategory = ent:GetNWString("NZItemCategory")

	if neededcategory != "" then
		local hasitem = LocalPlayer():HasCarryItem(neededcategory)
		text = hasitem and hastext != "" and hastext or deftext
	elseif deftext != "" then
		text = deftext
	elseif itemcategory != "" then
		local item = nzItemCarry.Items[itemcategory]
		local hasitem = LocalPlayer():HasCarryItem(itemcategory)
		if hasitem then
			text = item and item.hastext or "You already have this."
		else
			text = item and item.text or "Press E to pick up."
		end
	elseif ent:IsPlayer() then
		if ent:GetNotDowned() then
			text = ent:Nick() .. " - " .. ent:Health() .. " HP"
		else
			text = "Hold E to revive "..ent:Nick()
		end
	elseif ent:IsDoor() or ent:IsButton() or ent:GetClass() == "class C_BaseEntity" or ent:IsBuyableProp() then
		text = GetDoorText(ent)
	else
		text = traceents[class] and traceents[class](ent)
	end

	return text
end

local function GetMapScriptEntityText()
	local text = ""

	for k,v in pairs(ents.FindByClass("nz_script_triggerzone")) do
		local dist = v:NearestPoint(EyePos()):Distance(EyePos())
		if dist <= 1 then
			text = GetDoorText(v)
			break
		end
	end

	return text
end

function GetFontType(id)
	if id == "Classic NZ" then
	return "classic"
	end
	if id == "Old Treyarch" then
	return "waw"
	end
	if id == "BO2/3" then
	return "blackops2"
	end
	if id == "BO4" then
	return "blackops4"
	end
		if id == "Comic Sans" then
	return "xd"
	end
		if id == "Warprint" then
	return "grit"
	end
		if id == "Road Rage" then
	return "rage"
	end
		if id == "Black Rose" then
	return "rose"
	end
		if id == "Reborn" then
	return "reborn"
	end
		if id == "Rio Grande" then
	return "rio"
	end
		if id == "Bad Signal" then
	return "signal"
	end
		if id == "Infection" then
	return "infected"
	end
		if id == "Brutal World" then
	return "brutal"
	end
		if id == "Generic Scifi" then
	return "ugly"
	end
		if id == "Tech" then
	return "tech"
	end
		if id == "Krabby" then
	return "krabs"
	end
		if id == "Default NZR" then
	return "default"
	end
	if id == nil then
	return "default"
	end
end

local function DrawTargetID( text )

	if !text then return end

	local font = ("nz.small."..GetFontType(nzMapping.Settings.smallfont))
	local font2 = ("nz.ammo."..GetFontType(nzMapping.Settings.smallfont))
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	local MouseX, MouseY = gui.MousePos()

	if ( MouseX == 0 && MouseY == 0 ) then

		MouseX = ScrW() / 2
		MouseY = ScrH() / 2

	end

	local x = MouseX
	local y = MouseY

	x = x - w / 2
	y = y + 30
	local ply = LocalPlayer()
	local ent = ply:GetEyeTrace().Entity
	
	if IsValid(ent) and ent:GetClass() == "perk_machine"  then
	local dist = ent:GetPos():Distance(ply:GetPos())
	if dist<165 then
	local perkData = nzPerks:Get(ent:GetPerkID())
	if perkData.desc then
	draw.SimpleText( perkData.desc, font2, x-(string.len( perkData.desc )*3), y+60, perkData.color )
	end
	end
	end
	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText( text, font, x+1, y+1, Color(255,255,255,255) )
end


function GM:HUDDrawTargetID()

	local ent = GetTarget()

	if ent != nil then
		DrawTargetID(GetText(ent))
	else
		DrawTargetID(GetMapScriptEntityText())
	end

end
