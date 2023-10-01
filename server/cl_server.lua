local QBCore = exports['qb-core']:GetCoreObject()
local Cooldown = false

RegisterServerEvent('fd-oxyrun:server:SetOccupied', function(route)
	Config.Routes[route].Occupied = true
	TriggerClientEvent('fd-oxyrun:client:SetOccupied', -1, route)
end)

RegisterServerEvent('fd-oxyrun:server:SetOccupiedFalse', function(route)
	Config.Routes[route].Occupied = true
	TriggerClientEvent('fd-oxyrun:client:SetOccupiedFalse', -1, route)
end)

QBCore.Functions.CreateCallback('fd-oxyrun:server:getCops', function(source, cb)
    local amount = 0
    for k, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cb(amount)
end)

RegisterServerEvent('fd-oxyrun:server:coolout', function()
    Cooldown = true
    local timer = Config.Cooldown * 60000
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            Cooldown = false
        end
    end
end)

QBCore.Functions.CreateCallback("fd-oxyrun:server:coolc",function(source, cb)
    if Cooldown then
        cb(true)
    else
        cb(false) 
    end
end)

RegisterNetEvent('fd-oxyrun:server:startingPayment', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney(Config.StartingPayment.Type, Config.StartingPayment.Amount)
end)

RegisterNetEvent('fd-oxyrun:server:oxySell', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
   if Player.Functions.GetItemByName('oxy') ~= nil then
    HowMuchOxy = Player.Functions.GetItemByName(Config.OxySellPed.Sell.item).amount
    Player.Functions.AddMoney(Config.OxySellPed.Sell.type, Config.OxySellPed.Sell.price * HowMuchOxy)
    Player.Functions.RemoveItem(Config.OxySellPed.Sell.item, HowMuchOxy)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.OxySellPed.Sell.item], "remove", HowMuchOxy)
   else 
   if Config.NotifyType == "mythic" then 
    TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = Lang:t('npc3.nooxy'), style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
   elseif Config.NotifyType == "qbcore" then 
    TriggerClientEvent('QBCore:Notify', src, Lang:t('npc3.nooxy'), "error")
   end 
   end
end)

RegisterNetEvent('fd-oxyrun:server:getPackage', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(Config.HandOff.NeededItem, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.HandOff.NeededItem], "add", 1)
    TriggerClientEvent("fd-oxyrun:client:hasPackage", src)
end)


RegisterServerEvent("fd-oxyrun:server:givepackage", function()

        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
    
        -- Chances.
        local BonusItemChance = math.random(0,100)
        local MoneyChance = math.random(0,100)
        local LaunderChance = math.random(0,100)
    
        -- Extra money.
    
        -- Checks chances and if extramoney is allowed.
        if Config.ExtraMoney.AllowExtraMoney == true then
         if MoneyChance < Config.ExtraMoney.Chance then
    
          -- Creates the money.
          MoneyGiven = math.random(Config.ExtraMoney.MinAmount, Config.ExtraMoney.MaxAmount)
          Player.Functions.AddMoney(Config.ExtraMoney.MoneyType, MoneyGiven)
    
         end
        end 
    
        -- Bonus item.
    
        -- Checks chances and if bonusitems are allowed.
        if Config.BonusItems.AllowBonusItems == true then 
            if BonusItemChance < Config.BonusItems.Chance then 
    
                -- Creates the item/items.
                randomItem = Config.BonusItem[math.random(1, #Config.BonusItem)]
                randomItemAmount = math.random(Config.BonusItems.MinAmount, Config.BonusItems.MaxAmount)
                Player.Functions.AddItem(randomItem, randomItemAmount)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randomItem], "add", randomItemAmount)
            end 
        end 
    
        -- Checks the launder chances and if it is allowed.
        if Config.EnableLaunder == true then 
            if LaunderChance < Config.MarkedBills.CleanChance then
    
                -- Marked bills laundering.
                if Player.Functions.GetItemByName('markedbills') ~= nil then
                    bills = Player.Functions.GetItemByName('markedbills').amount
                    randomBills = math.random(Config.MarkedBills.MinRemoveItems, Config.MarkedBills.MaxRemoveItems)
                    maths1 = math.random(randomBills, bills)
                    pay1 = (maths1 * math.random(Config.MarkedBills.MinAmount, Config.MarkedBills.MaxAmount))
                    Player.Functions.RemoveItem("markedbills", maths1)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["markedbills"], "remove", maths1)
                    Player.Functions.AddMoney(Config.LaunderMoneyType, pay1)
                end
            end 
        end 
    
         -- Checks the launder chances and if it is allowed.
    if Config.EnableLaunder == true then 
         if LaunderChance < Config.BandOfNotes.CleanChance then
    
         -- Band Of Notes laundering.
            if Player.Functions.GetItemByName('bandofnotes') ~= nil then
                notes = Player.Functions.GetItemByName('bandofnotes').amount
                randomNotes = math.random(Config.BandOfNotes.MinRemoveItems, Config.BandOfNotes.MaxRemoveItems)
                maths2 = math.random(randomNotes, notes)
                pay2 = (maths2 * math.random(Config.BandOfNotes.MinAmount, Config.BandOfNotes.MaxAmount))
                Player.Functions.RemoveItem("bandofnotes", maths2)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["bandofnotes"], "remove", maths2)
                Player.Functions.AddMoney(Config.LaunderMoneyType, pay2)
    
            end
        end 
    end
    
         -- Checks the launder chances and if it is allowed.
            if Config.EnableLaunder == true then 
                if LaunderChance < Config.RollOfSmallNotes.CleanChance then
        
                    -- Roll Of Small Notes laundering. 
                    if Player.Functions.GetItemByName('rollofsmallnotes') ~= nil then
                        smallnotes = Player.Functions.GetItemByName('rollofsmallnotes').amount
                        randomNotes = math.random(Config.RollOfSmallNotes.MinRemoveItems, Config.RollOfSmallNotes.MaxRemoveItems)
                        maths3 = math.random(randomNotes, smallnotes)
                        pay3 = (maths3 * math.random(Config.RollOfSmallNotes.MinAmount, Config.RollOfSmallNotes.MaxAmount))
                        Player.Functions.RemoveItem("rollofsmallnotes", maths3)
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["rollofsmallnotes"], "remove", maths3)
                        Player.Functions.AddMoney(Config.LaunderMoneyType, pay3)
                    end
                end 
            end   
    
         -- Removes the needed item for deliveries.
            Player.Functions.RemoveItem(Config.HandOff.NeededItem, 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.HandOff.NeededItem], "remove")
            print("tried to remove")
            -- Gives oxy 
            if Config.HandOff.GiveOxy then 
                Player.Functions.AddItem("oxy", 1)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["oxy"], "add")
            end
end)



