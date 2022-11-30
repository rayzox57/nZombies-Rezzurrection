-- Setup round module
nzRound = nzRound or AddNZModule("Round")


function nzRound:GetZombieType(id)
	if id == "Skeleton" then
	return "nz_zombie_walker_skeleton"
	end
		if id == "Deathtrooper" then
	return "nz_zombie_walker_deathtrooper"
	end
		if id == "Zombies in Spaceland" then
	return "nz_zombie_walker_clown"
	end
		if id == "Tranzit" then
	return "nz_zombie_walker_greenrun" 
	end
		if id == "Mob of the Dead" then
	return "nz_zombie_walker_motd" 
	end
		if id == "Nuketown" then
	return "nz_zombie_walker_nuketown"
	end
	if id == "Ascension" then
	return "nz_zombie_walker_ascension"
	end
	if id == "Call of the Dead" then
	return "nz_zombie_walker_cotd"
	end
	if id == "FIVE" then
	return "nz_zombie_walker_five"
	end
	if id == "Gorod Krovi" then
	return "nz_zombie_walker_gorodkrovi"
	end
	if id == "Shadows of Evil" then
	return "nz_zombie_walker_soemale"
	end
	if id == "Zetsubou no Shima" then
	return "nz_zombie_walker_zetsubou"
	end
	if id == "Xenomorph" then
	return "nz_zombie_walker_xeno"
	end
	if id == "Necromorph" then
	return "nz_zombie_walker_necromorph"
	end
	if id == "Kino der Toten" then
	return "nz_zombie_walker"
	end
	if id == "Origins" then
	return "nz_zombie_walker_origins"
	end
	if id == "World War 1 Soldiers" then
	return "nz_zombie_walker_origins_soldier"
	end
	if id == "Origins" then
	return "nz_zombie_walker_origins"
	end
	if id == "Crusader Zombies" then
	return "nz_zombie_walker_origins_templar"
	end
	if id == "Moon" then
	return "nz_zombie_walker_moon"
	end
	if id == "Moon Tech" then
	return "nz_zombie_walker_moon_guard"
	end
	if id == "Area 51 Guard" then
	return "nz_zombie_walker_moon_guard"
	end
	if id == "Buried" then
	return "nz_zombie_walker_buried"
	end
	if id == "Der Eisendrache" then
	return "nz_zombie_walker_eisendrache"
	end
	if id == "Shangri-La" then
	return "nz_zombie_walker_shangrila"
	end
	if id == "Shi no Numa" then
	return "nz_zombie_walker_sumpf"
	end
	if id == nil then
	return "nz_zombie_walker"
	end
end


if SERVER then

	nzConfig.RoundData = {}
	nzConfig.RoundData[1] = {
		normalTypes = {
			[nzRound:GetZombieType(nzMapping.Settings.zombietype)] = {
				chance = 100,
			},
		},
	}
	nzConfig.RoundData[2] = {
		normalTypes = {
			[nzRound:GetZombieType(nzMapping.Settings.zombietype)] = {
				chance = 100,
			},
		},
	}
	nzConfig.RoundData[13] = {
		normalTypes = {
			[nzRound:GetZombieType(nzMapping.Settings.zombietype)] = {
				chance = 100,
			},
		},
	}
	nzConfig.RoundData[14] = {
		normalTypes = {
			[nzRound:GetZombieType(nzMapping.Settings.zombietype)] = {
				chance = 100,
			},
		},
	}
	nzConfig.RoundData[23] = {
		normalTypes = {
			[nzRound:GetZombieType(nzMapping.Settings.zombietype)] = {
				chance = 100,
			},
		},
	}

	-- Player Class
	nzConfig.BaseStartingWeapons = {"fas2_glock20"} -- "fas2_p226", "fas2_ots33", "fas2_glock20" "weapon_pistol"
	-- nzConfig.CustomConfigStartingWeps = true -- If this is set to false, the gamemode will avoid using custom weapons in configs

end
