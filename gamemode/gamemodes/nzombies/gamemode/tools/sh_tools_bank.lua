nzTools:CreateTool("bank", {
    displayname = "Bank Creator",
    desc = "LMB: Place Bank, RMB: Remove Bank",
    condition = function(wep,ply)
        return true
    end,
    PrimaryAttack = function(wep, ply, tr, data)

        local deposit = tonumber(data.deposit)
        deposit = deposit < 1 and 1 or (deposit > 999999 and 999999 or deposit)
        local depositFee = tonumber(data.depositFee)
        depositFee = depositFee < 0 and 0 or (depositFee > 999999 and 999999 or depositFee)
        local writedraw = tonumber(data.writedraw)
        writedraw = writedraw < 1 and 1 or (writedraw > 999999 and 999999 or writedraw)
        local writedrawFee = tonumber(data.writedrawFee)
        writedrawFee = writedrawFee < 0 and 0 or (writedrawFee > 999999 and 999999 or writedrawFee)
        local minRound = tonumber(data.minRound)
        minRound = minRound < 1 and 1 or (minRound > 9999 and 9999 or minRound)
        local cooldown = tonumber(data.cooldown)
        cooldown = cooldown < 0.1 and 0.1 or (cooldown > 9999 and 9999 or cooldown)

        local ent = tr.Entity
        if IsValid(ent) and ent:GetClass() == "bank" then
            nzMapping:CreateBank(ply,ent:GetPos(),ent:GetAngles(),data.isDeposit,deposit,depositFee,writedraw,writedrawFee,data.mdl,minRound,cooldown)
            ent:Remove()
        else
            local ang = tr.HitNormal:Angle()
			ang:RotateAroundAxis(tr.HitNormal:Angle():Up()*-1, 90)
            nzMapping:CreateBank(ply,tr.HitPos + tr.HitNormal*0.5,ang,data.isDeposit,deposit,depositFee,writedraw,writedrawFee,data.mdl,minRound,cooldown)
        end
    end,
    SecondaryAttack = function(wep, ply, tr, data)
        if IsValid(tr.Entity) and tr.Entity:GetClass() == "bank" then
			tr.Entity:Remove()
		end
    end,
    Reload = function(wep, ply, tr, data)

    end,
    OnEquip = function(wep, ply, data)

    end,
    OnHolster = function(wep, ply, data)

    end
},{
    displayname = "Bank Creator",
    desc = "LMB: Place Bank, RMB: Remove Bank",
    icon = "icon16/door.png",
    weight = 7,
    condition = function(wep, ply)
        return true
    end,
    interface = function(frame, data)
        local valz = {}
        valz["Row1"] = data.isDeposit
        valz["Row2"] = data.deposit
        valz["Row3"] = data.depositFee
        valz["Row4"] = data.writedraw
        valz["Row5"] = data.writedrawFee
        valz["Row6"] = data.mdl
        valz["Row7"] = data.minRound
        valz["Row8"] = data.cooldown

        local DProperties = vgui.Create( "DProperties", frame )
        DProperties:SetSize( 480, 450 )
        DProperties:SetPos( 10, 10 )

        function DProperties.CompileData()
            PrintTable(valz)
            data.isDeposit = valz["Row1"]
            data.deposit = valz["Row2"]
            data.depositFee = valz["Row3"]
            data.writedraw = valz["Row4"]
            data.writedrawFee = valz["Row5"]
            data.mdl = valz["Row6"]
            data.minRound = valz["Row7"]
            data.cooldown = valz["Row8"]
            return data
        end

        function DProperties.UpdateData(data)
            PrintTable(data)
            nzTools:SendData(data, "bank")
        end

        local Row1 = DProperties:CreateRow( "Bank", "Is Deposit ? (true)Deposit / (false)WriteDraw" )
        Row1:Setup( "Boolean" )
        Row1:SetValue( valz["Row1"] )
        Row1.DataChanged = function( _, val )
            valz["Row1"] = val
            DProperties.UpdateData(DProperties.CompileData())
        end
        local Row2 = DProperties:CreateRow( "Bank", "Deposit Value" )
        Row2:Setup( "Integer", {min = 1, max = 999999} )
        Row2:SetValue( valz["Row2"] )
        Row2.DataChanged = function( _, val )
            valz["Row2"] = val
            DProperties.UpdateData(DProperties.CompileData())
        end
        local Row3 = DProperties:CreateRow( "Bank", "Deposit Fee" )
        Row3:Setup( "Integer", {min = 0, max = 999999} )
        Row3:SetValue( valz["Row3"] )
        Row3.DataChanged = function( _, val )
            valz["Row3"] = val
            DProperties.UpdateData(DProperties.CompileData())
        end
        local Row4 = DProperties:CreateRow( "Bank", "WriteDraw Value" )
        Row4:Setup( "Integer", {min = 1, max = 999999} )
        Row4:SetValue( valz["Row4"] )
        Row4.DataChanged = function( _, val )
            valz["Row4"] = val
            DProperties.UpdateData(DProperties.CompileData())
        end
        local Row5 = DProperties:CreateRow( "Bank", "WriteDraw Fee" )
        Row5:Setup( "Integer", {min = 0, max = 999999} )
        Row5:SetValue( valz["Row5"] )
        Row5.DataChanged = function( _, val )
            valz["Row5"] = val
            DProperties.UpdateData(DProperties.CompileData())
        end
        local Row6 = DProperties:CreateRow( "Bank", "Bank Model" )
        Row6:Setup( "String" )
        Row6:SetValue( valz["Row6"] )
        Row6.DataChanged = function( _, val )
            valz["Row6"] = val
            DProperties.UpdateData(DProperties.CompileData())
        end
        local Row7 = DProperties:CreateRow( "Bank", "Min Round Needed" )
        Row7:Setup( "Integer", {min = 1, max = 9999} )
        Row7:SetValue( valz["Row7"] )
        Row7.DataChanged = function( _, val )
            valz["Row7"] = val
            DProperties.UpdateData(DProperties.CompileData())
        end

        local Row8 = DProperties:CreateRow( "Bank", "Cooldown (in seconds)" )
        Row8:Setup( "Float", {min = 0.1, max = 9999} )
        Row8:SetValue( valz["Row8"] )
        Row8.DataChanged = function( _, val )
            valz["Row8"] = val
            DProperties.UpdateData(DProperties.CompileData())
        end


        return DProperties
    end,
    defaultdata = {
        isDeposit = true,
        deposit = 500,
        depositFee = 50,
        writedraw = 500,
        writedrawFee = 50,
        mdl = "models/props_wasteland/controlroom_storagecloset001b.mdl",
        minRound = 1,
        cooldown = 0.1
    }
})