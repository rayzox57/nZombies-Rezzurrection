AddCSLuaFile( )

ENT.Type = "anim"

ENT.PrintName    = "bank"
ENT.Author       = "Rayzox"
ENT.Contact      = ""
ENT.Purpose      = ""
ENT.Instructions = ""


function ENT:SetupDataTables()
    self:NetworkVar("Bool",0, "IsDeposit")
    self:NetworkVar("Int", 0, "Deposit")
    self:NetworkVar("Int", 1, "DepositFee")
    self:NetworkVar("Int", 2, "Writedraw")
    self:NetworkVar("Int", 3, "WritedrawFee")
    self:NetworkVar("Int", 4, "MinRound")
    self:NetworkVar("Float", 0, "Cooldown")
end

function ENT:Initialize()
    if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
        self:SetUseType(SIMPLE_USE)
    end
end

if SERVER then

    function ENT:Use( activator, caller )

        local minRound = self:GetMinRound()
        local cooldown = self:GetCooldown()

        local sid64 = activator:SteamID64()
        local isDeposit = self:GetIsDeposit() == true

        if nzRound:GetNumber() < minRound then
            activator:PrintMessage( HUD_PRINTTALK, string.format("[nZ] Please wait the Round %s to begin %s ",tostring(minRound),isDeposit == true and "Deposit" or "WriteDraw"))
            return false
        end

        if isDeposit == true then
            if nzBank.hasCooldown(sid64,nzBank.NZBANK_COOLDOWN_DEPOSIT) == true then return end
            local deposit  = self:GetDeposit()
            local fee      = self:GetDepositFee()
            local required = deposit + fee
            activator:Buy(required, self, function()
                local old = nzBank.getAmount(sid64)
                nzBank.addAmount(deposit,sid64)
                activator:PrintMessage( HUD_PRINTTALK, string.format("[nZ] New Bank Amount : %s >> %s ",tostring(old),tostring(nzBank.getAmount(sid64))))
                return true
            end)
            nzBank.newCooldown(sid64,nzBank.NZBANK_COOLDOWN_DEPOSIT,cooldown)
            return true
        else
            if nzBank.hasCooldown(sid64,nzBank.NZBANK_COOLDOWN_WRITEDRAW) == true then return end
            local writedraw = self:GetWritedraw()
            local fee       = self:GetWritedrawFee()
            local required = writedraw + fee
            local res = false

            if nzBank.hasAmount(required,sid64) == true then
                local old = nzBank.getAmount(sid64)
                nzBank.takeAmount(required,sid64)
                activator:GivePoints(writedraw)
                activator:PrintMessage( HUD_PRINTTALK, string.format("[nZ] New Bank Amount : %s >> %s ",tostring(old),tostring(nzBank.getAmount(sid64))))
                res = true
            else
                activator:PrintMessage( HUD_PRINTTALK, string.format("[nZ] You can't writedraw %s because you don't have enough money in bank : %s + %s fee !.",tostring(writedraw),tostring(writedraw),tostring(fee)))
            end
            nzBank.newCooldown(sid64,nzBank.NZBANK_COOLDOWN_WRITEDRAW,cooldown)
            return res
        end
        return
    end

end


function ENT:Draw()
	self:DrawModel()
end