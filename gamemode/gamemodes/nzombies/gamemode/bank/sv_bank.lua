nzBank.sqlTable = "nz_bank"
nzBank.sqlOk = false

nzBank.players = {}
nzBank.cooldown = {}

nzBank.NZBANK_COOLDOWN_WRITEDRAW = "nbcw"
nzBank.NZBANK_COOLDOWN_DEPOSIT   = "nbcd"

nzBank.clearCooldown = function(sid64,typeC)
    nzBank.cooldown[sid64] = nzBank.cooldown[sid64] or {}
    nzBank.cooldown[sid64][typeC] = nil
end

nzBank.clearAllCooldown = function(sid64)
    nzBank.clearCooldown(sid64,nzBank.NZBANK_COOLDOWN_WRITEDRAW )
    nzBank.clearCooldown(sid64,nzBank.NZBANK_COOLDOWN_DEPOSIT)
end

nzBank.newCooldown = function(sid64,typeC,cooldown)
    nzBank.cooldown[sid64] = nzBank.cooldown[sid64] or {}
    nzBank.cooldown[sid64][typeC] = os.time() + cooldown
end

nzBank.hasCooldown = function(sid64,typeC)
    nzBank.cooldown[sid64] = nzBank.cooldown[sid64] or {}
    nzBank.cooldown[sid64][typeC] = nzBank.cooldown[sid64][typeC] or -1
    local value = nzBank.cooldown[sid64][typeC]
    return value ~= -1 and value > os.time()
end

nzBank.getAmount = function(sid64)
    nzBank.players[sid64] = nzBank.players[sid64] or 0
    return nzBank.players[sid64]
end

nzBank.hasAmount = function(amt,sid64)
    return nzBank.getAmount(sid64) >= amt
end

nzBank.addAmount = function(amt,sid64)
    nzBank.players[sid64] = nzBank.getAmount(sid64) + amt
end

nzBank.takeAmount = function(amt, sid64)
    nzBank.players[sid64] = math.max(0,nzBank.getAmount(sid64) - amt)
end


nzBank.savePlayer = function(ply,sid64)
    if nzBank.ok == false then return end
    sid64 = sid64 or ply:SteamID64()
    local data = nzBank.players[sid64]
    local query = sql.Query(string.format([[INSERT OR IGNORE INTO %s (sid64, bank) VALUES (%s, 0); UPDATE %s SET bank = %d WHERE sid64 = "%s"]],nzBank.sqlTable,sid64,nzBank.sqlTable,tonumber(data),sid64))
end

nzBank.saveAllPlayers = function()
    if nzBank.ok == false then return end
    for k,v in ipairs(player.GetHumans()) do
        nzBank.savePlayer(v)
    end
end

nzBank.fetchPlayer = function(ply)
    if nzBank.sqlOk == false then return end 
    local sid64 = ply:SteamID64()
    local data = sql.Query(string.format([[SELECT * FROM "%s" WHERE sid64 = "%s"]],nzBank.sqlTable,sid64))

    if data and data ~= false then
        data = data[1]
        if data and data.sid64 == sid64 and data.bank ~= nil then
            local value = tonumber(data.bank)
            nzBank.players[sid64] = value >= 0 and value or 0
        end
    end
end

nzBank.fetchAllPlayers = function()
    nzBank.players = {}
    if nzBank.ok == false then return end
    for k,v in ipairs(player.GetHumans()) do
        nzBank.fetchPlayer(v)
    end
end

nzBank.tableExists = function()
    if ( sql.TableExists(nzBank.sqlTable) ) then
        print("Succes ! table " .. nzBank.sqlTable .. " already created \n")
        nzBank.sqlOk = true
    else
        if (!sql.TableExists(nzBank.sqlTable)) then
            query = "CREATE TABLE " .. nzBank.sqlTable .. " ( sid64 varchar(255) PRIMARY KEY, bank BIGINT )"
            result = sql.Query(query)

            if (sql.TableExists(nzBank.sqlTable)) then
                print("Succes ! table " .. nzBank.sqlTable .. " created \n")
                nzBank.sqlOk = true
            else
                print("Error ! table " .. nzBank.sqlTable .. " can't be created \n")
                nzBank.sqlOk = false
            end
        end
    end
    nzBank.fetchAllPlayers()
end

nzBank.tableExists()



hook.Add("PlayerInitialSpawn","nzBank.PIS.Fetch", function(ply)
    nzBank.fetchPlayer(ply)
    nzBank.clearAllCooldown(ply:SteamID64())
end)

nzBank.endPlayer = function(ply)
    nzBank.savePlayer(ply)
    nzBank.clearAllCooldown(ply:SteamID64())
end

hook.Add("PlayerDisconnected","nzBank.PD.Save", function(ply) nzBank.endPlayer(ply) end)
hook.Add("OnRoundEnd","nzBank.ORE.SaveAll", function() 
    for k,v in ipairs(player.GetAll()) do
        nzBank.endPlayer(v)
    end
end)