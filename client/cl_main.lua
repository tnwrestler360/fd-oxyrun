local QBCore = exports['qb-core']:GetCoreObject()
local Player = PlayerPedId()
local talked = false
local oxyrunpackagestaken = 0 
local pgiven = 0
local vehiclespawned = false
local allpackges = false
local DeliveriedToCars = 0
local handoffs = false

local function LoadAnimation(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
end

-- This function can be used to trigger your desired dispatch alerts! In order to add one just add a elseif statement and the export of the alert! (EXAMPLE SHOWN)
-- To use your desired AlertType head to the config.lua file and find a config named "Config.AlertType" and add your AlertType name after == inside of ""
-- Also remember to check the needed export of your policeAlert script (If you add a new one)!
local AlertCops = function()
    if Config.CopsAlertType == "ps-dispatch" then
     exports['ps-dispatch']:SuspiciousActivity() -- Project Sloth QB-Dispatch
    elseif Config.CopsAlertType == "qbcore" then
     TriggerServerEvent('police:server:policeAlert', 'Suspicious Hand-off') -- Regular qbcore
     -- EXAMPLE: 
    -- elseif Config.CopsAlertType == "CreateANameHere" then 
     -- exports['TheFileNameUsually']:WhatKindOfAlert()
    end
end

-- Spawns the starting ped (boss).
CreateThread(function()

    RequestModel(Config.BossPed.Model) 
    while not HasModelLoaded(Config.BossPed.Model) do 
    Wait(1)
   end
    Boss = CreatePed(2, Config.BossPed.Model, Config.BossPed.Coords.x, Config.BossPed.Coords.y, Config.BossPed.Coords.z, Config.BossPed.Coords.w, false, false) 
    SetPedFleeAttributes(Boss, 0, 0)
    SetPedDiesWhenInjured(Boss, false)
    TaskStartScenarioInPlace(Boss, Config.BossPed.Scenario, 0, true)
    SetPedKeepTask(Boss, true)
    SetBlockingOfNonTemporaryEvents(Boss, true)
    SetEntityInvincible(Boss, true)
    FreezeEntityPosition(Boss, true)
   if Config.BossPed.EmoteON then 
    TaskStartScenarioInPlace(Boss, Config.BossPed.Emote, 0, true) 
   end
end)

-- Spawns the second ped (dealer ped).
RegisterNetEvent('fd-oxyrun:client:SpawnDealerPed', function()

    RequestModel(Config.DealerPed.Model) 
    while not HasModelLoaded(Config.DealerPed.Model) do 
    Wait(1)
   end
    Dealer = CreatePed(1, Config.DealerPed.Model, RandomDealerLocation, false, false) 
    SetPedFleeAttributes(Dealer, 0, 0)
    SetPedDiesWhenInjured(Dealer, false)
    SetPedKeepTask(Dealer, true)
    SetBlockingOfNonTemporaryEvents(Dealer, true)
    SetEntityInvincible(Dealer, true)
    FreezeEntityPosition(Dealer, true)
    LoadAnimation(Config.AnimationForPackage.animation)
    TaskPlayAnim(Dealer, Config.AnimationForPackage.animation, Config.AnimationForPackage.animationstyle, 6.0, -6.0, -1, 49, 0, 0, 0, 0)
    npcPackage = CreateObject(Config.AnimationForPackage.prop, Config.AnimationForPackage.propx, Config.AnimationForPackage.propy, Config.AnimationForPackage.propz, true, true, true)
    AttachEntityToEntity(npcPackage, Dealer, GetPedBoneIndex(Dealer, Config.AnimationForPackage.boneindex), Config.AnimationForPackage.attachentityxpos, Config.AnimationForPackage.attachentityypos, Config.AnimationForPackage.attachentityzpos, Config.AnimationForPackage.attachentityxrot, Config.AnimationForPackage.attachentityyrot, Config.AnimationForPackage.attachentityzrot, true, true, false, true, 1, true)
    
    exports['qb-target']:AddTargetEntity(Dealer, {
        options = {
        { 
        type = "client",
        action = function()
            TriggerEvent("fd-oxyrun:client:takepackage")
        end,
        icon = Lang:t('npc2.targeticon'),
        label = Lang:t('npc2.target'),
        canInteract = function(entity, distance, data) 
        return talked and not allpackges
       end,
        },
        },
        
        -- Maximum distance between player and ped for the target to work.
        distance = Config.DealerPed.MaxTargetDistance
    
    })
end)

-- Spawns the oxysell ped (You sell your oxy here).
CreateThread(function()
  if Config.OxySellPed.Enable then 
    RequestModel(Config.OxySellPed.Model) 
    while not HasModelLoaded(Config.OxySellPed.Model) do 
    Wait(1)
   end
    OxySell = CreatePed(2, Config.OxySellPed.Model, Config.OxySellPed.Coords.x, Config.OxySellPed.Coords.y, Config.OxySellPed.Coords.z, Config.OxySellPed.Coords.w, false, false) 
    SetPedFleeAttributes(OxySell, 0, 0)
    SetPedDiesWhenInjured(OxySell, false)
    TaskStartScenarioInPlace(OxySell, Config.OxySellPed.Scenario, 0, true)
    SetPedKeepTask(OxySell, true)
    SetBlockingOfNonTemporaryEvents(OxySell, true)
    SetEntityInvincible(OxySell, true)
    FreezeEntityPosition(OxySell, true)
   if Config.OxySellPed.EmoteON then 
    TaskStartScenarioInPlace(OxySell, Config.OxySellPed.Emote, 0, true) 
   end

    -- Targets for the starting ped, second ped and for oxyselling ped.
    exports['qb-target']:AddTargetEntity(Boss, {
    options = {
    { 
    type = "client",
    event = "fd-oxyrun:client:start",
    icon = Lang:t('npc.targeticon'),
    label = Lang:t('npc.target'),
    },
    },

    -- Maximum distance between player and ped for the target to work.
    distance = Config.BossPed.MaxTargetDistance

   })

 end
end)

-- Blip for oxysell.
CreateThread(function()
   if Config.Blips.OxySellEnableBlip then
    OxySellBlip = AddBlipForCoord(Config.OxySellPed.Coords) 

    -- Natives for the blip.
    SetBlipSprite(OxySellBlip, Config.Blips.OxySellBlipType)
    SetBlipColour(OxySellBlip, Config.Blips.OxySellBlipColor)

    -- Creates a name to the blip.
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Blips.OxySellBlipText)
    EndTextCommandSetBlipName(OxySellBlip)
   end
    exports['qb-target']:AddTargetEntity(OxySell, {
    options = {
    { 
    type = "client",
    icon = Lang:t('npc3.targeticon'),
    label = Lang:t('npc3.target'),
    action = function()
     TriggerServerEvent('fd-oxyrun:server:oxySell')
    end,
    },
    },
    
    -- Maximum distance between player and ped for the target to work.
    distance = Config.OxySellPed.MaxTargetDistance

    })

end)

function DisableControls()
    CreateThread(function ()
        while holdingBox do
            DisableControlAction(0, 21, true) -- Sprinting
            DisableControlAction(0, 22, true) -- Jumping
            DisableControlAction(0, 23, true) -- Vehicle Entering
            DisableControlAction(0, 36, true) -- Ctrl
			DisableControlAction(0, 24, true) -- disable attack
			DisableControlAction(0, 25, true) -- disable aim
			DisableControlAction(0, 47, true) -- disable weapon
			DisableControlAction(0, 58, true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 142, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
            Wait(1)
        end
    end)
end

-- Start event for the run.
RegisterNetEvent("fd-oxyrun:client:start", function()

    -- Checks if player has cooldown, if played has already started the run or if the server has enough cops.
    QBCore.Functions.TriggerCallback('fd-oxyrun:server:getCops', function(cops)
    QBCore.Functions.TriggerCallback("fd-oxyrun:server:coolc",function(isCooldown)
   if not routesFull then 
   if cops >= Config.RequiredCops then
   if not talked then
   if not isCooldown then

   -- If animations are enabled.
   if Config.BossPed.EnableProgressbarAndEmote then 
    LoadAnimation(Config.BossPed.PlayerAnimation)
    TaskPlayAnim(Player, Config.BossPed.PlayerAnimation, Config.BossPed.PlayerAnimationType, 6.0, -6.0, -1, 49, 0, 0, 0, 0) 
    -- Progressbar
    QBCore.Functions.Progressbar('ArgueWithboss', Lang:t('npc.progressbartext'), Config.BossPed.Duration, false, true, {
    disableMovement = true,
    disableCarMovement = true,
    disableMouse = false,
    disableCombat = true,
    }, {}, {}, {}, function() -- Play when done
    TriggerEvent('fd-oxyrun:client:earlystart')
   end, function() -- Play When Cancel
    
   end)

   -- If they're not enabled.
   else 
    TriggerEvent('fd-oxyrun:client:earlystart')
   end
    
   -- If no routes left.
   else 
    if Config.NotifyType == "mythic" then 
     exports['mythic_notify']:DoHudText('inform', Lang:t('npc.cooldown'), { ['background-color'] = '#ffffff', ['color'] = '#000000' })
    elseif Config.NotifyType == "qbcore" then 
     QBCore.Functions.Notify(Lang:t('npc.cooldown'), 'error', 7500)
    end
   end
   -- If player has already started the run and tries to start again.
   else
   if Config.NotifyType == "mythic" then 
    exports['mythic_notify']:DoHudText('inform', Lang:t('npc.alreadystarted'), { ['background-color'] = '#ffffff', ['color'] = '#000000' })
   elseif Config.NotifyType == "qbcore" then 
    QBCore.Functions.Notify(Lang:t('npc.alreadystarted'), 'error', 7500)
   end
   end

   -- If isn't enough cops.
   else
   if Config.NotifyType == "mythic" then 
    exports['mythic_notify']:DoHudText('inform', Lang:t('npc.nocops'), { ['background-color'] = '#ffffff', ['color'] = '#000000' })
   elseif Config.NotifyType == "qbcore" then 
    QBCore.Functions.Notify(Lang:t('npc.nocops'), 'error', 7500)
   end
   end

   -- If the player has a cooldown.
   else 
   if Config.NotifyType == "mythic" then 
    exports['mythic_notify']:DoHudText('inform', 'Wait for a while, there are no routes left', { ['background-color'] = '#ffffff', ['color'] = '#000000' })
   elseif Config.NotifyType == "qbcore" then 
    QBCore.Functions.Notify('Wait for a while, there are no routes left', 'error', 7500)
   end
   end

  end)
 end)
end)

RegisterNetEvent('fd-oxyrun:client:earlystart', function()

    -- Sets the variable talked = true, so basically a way to detect if the player is in the run.
    talked = true

    -- Finds a route
    carsRoute = math.random(#Config.Routes)
    carRoute = Config.Routes[carsRoute]
    Deliver = carRoute.Deliver
    SpawnPoint = carRoute.SpawnPoint

    local totalCount = #Config.Routes + 1

	local trueCount = 1
	for _,v1 in pairs(Config.Routes) do
		if Config.Routes[_].Occupied == true then
			trueCount = trueCount + 1
		end
	end


	if trueCount == totalCount then
        if Config.NotifyType == "mythic" then 
            exports['mythic_notify']:DoHudText('inform', 'Wait for a while, there are no routes left', { ['background-color'] = '#ffffff', ['color'] = '#000000' })
        elseif Config.NotifyType == "qbcore" then 
            QBCore.Functions.Notify('Wait for a while, there are no routes left', 'error', 7500)
        end
		routesFull = true
	else
		if Config.Routes[carsRoute].Occupied == true then
			repeat
				carsRoute = math.random(#Config.Routes)
			until(Config.Routes[carsRoute].Occupied == false)
		end

		 TriggerServerEvent('fd-oxyrun:server:SetOccupied', carsRoute)
		 Config.Routes[carsRoute].Occupied = true

        -- Checks if there is a starting payment.
        if Config.StartingPayment.EnableStartingPayment then 
         TriggerServerEvent("fd-oxyrun:server:startingPayment") 
        elseif not Config.StartingPayment.EnableStartingPayment then 
        end
         TriggerEvent('fd-oxyrun:client:carCheck')
        end
end)

RegisterNetEvent('fd-oxyrun:client:SetOccupied', function(route)
	Config.Routes[route].Occupied = true
end)

RegisterNetEvent('fd-oxyrun:client:SetOccupied', function(route)
	Config.Routes[route].Occupied = false
end)

RegisterNetEvent('fd-oxyrun:client:carCheck', function()

    -- If there was enough cops and no cooldown then.   
    --[[
    TriggerServerEvent('qb-phone:server:sendNewMail', {
    sender = Lang:t('npc.sendername'), 
    subject = Lang:t('npc.sendersubject'), 
    message = Lang:t('npc.sendermessage'),
    button = {}
    })   
    ]]--
    TriggerServerEvent('jpr-phonesystem:server:sendEmail', {
        Assunto = Lang:t('npc.sendersubject'), -- Subject
        Conteudo = Lang:t('npc.sendermessage'), -- Content
        Enviado = Lang:t('npc.sendername'), -- Submitted by
        Destinatario = QBCore.Functions.GetPlayerData().citizenid, -- Target
        Event = {}, -- Optional 
    })
        -- Waits that the player sits on a vehicle.
    repeat Wait(1000) until IsPedInAnyVehicle(Player, false)
    TriggerEvent("fd-oxyrun:startrun") 
        
end)

-- Event that spawns the dealerped and a blip to that location.
RegisterNetEvent("fd-oxyrun:startrun", function()

    -- Creates a random location for the dealer to spawn.
    RandomDealerLocation = Config.DealerPed.Coords[math.random(#Config.DealerPed.Coords)]

    -- Spawns the dealerped.
    TriggerEvent('fd-oxyrun:client:SpawnDealerPed')

    -- Creates a blip.
    DealerBlip = AddBlipForCoord(RandomDealerLocation) 

    -- Natives for the blip.
    SetBlipSprite(DealerBlip, Config.Blips.DealerBlipType)
    SetBlipColour(DealerBlip, Config.Blips.DealerBlipColor)

   -- Checks if routes are enabled.
   if Config.Blips.DealerRouteON then
    SetBlipRoute(DealerBlip, true)
    SetBlipRouteColour(DealerBlip, Config.Blips.DealerRouteColor)
   end

    -- Creates a name to the blip.
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Blips.DealerBlipText)
    EndTextCommandSetBlipName(DealerBlip)

    -- Phone mail.
    --[[
    TriggerServerEvent('qb-phone:server:sendNewMail', {
    sender = Lang:t('npc.sendername'),
    subject = Lang:t('npc.sendersubject'),
    message = Lang:t('npc.sendermessage2'),
    button = {}
    })   
    ]]--
    TriggerServerEvent('jpr-phonesystem:server:sendEmail', {
        Assunto = Lang:t('npc.sendersubject'), -- Subject
        Conteudo = Lang:t('npc.sendermessage2'), -- Content
        Enviado = Lang:t('npc.sendername'), -- Submitted by
        Destinatario = QBCore.Functions.GetPlayerData().citizenid, -- Target
        Event = {}, -- Optional 
    })
end)

-- Package taking event.
RegisterNetEvent("fd-oxyrun:client:takepackage", function()
 if Config.Core == "old" then
  QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
 if not result then 
  TriggerEvent('fd-oxyrun:client:takePackageEvent')
  else 
  if Config.NotifyType == "mythic" then 
   exports['mythic_notify']:DoHudText('inform', Lang:t('npc2.putintrunk'), { ['background-color'] = '#ffffff', ['color'] = '#000000' })
  elseif Config.NotifyType == "qbcore" then
   QBCore.Functions.Notify(Lang:t('npc2.putintrunk'), 'error', 7500)
  end
  end
end, Config.HandOff.NeededItem) 

  elseif Config.Core == "new" then
   HasItem = QBCore.Functions.HasItem(Config.HandOff.NeededItem)
  if not HasItem then
   TriggerEvent('fd-oxyrun:client:takePackageEvent') 
  else 
  if Config.NotifyType == "mythic" then 
   exports['mythic_notify']:DoHudText('inform', Lang:t('npc2.putintrunk'), { ['background-color'] = '#ffffff', ['color'] = '#000000' })
  elseif Config.NotifyType == "qbcore" then
    QBCore.Functions.Notify(Lang:t('npc2.putintrunk'), 'error', 7500)
   end
   end
 end 
end)

RegisterNetEvent('fd-oxyrun:client:takePackageEvent', function()
    -- If player hasn't taken all packages.
   if oxyrunpackagestaken < 5 then

    -- Registers that player has taken 1 package.
    oxyrunpackagestaken = oxyrunpackagestaken + 1  

    -- Notification.
   if Config.NotifyType == "mythic" then 
    exports['mythic_notify']:DoHudText('inform', "".. oxyrunpackagestaken .."/".. Config.HandOff.Amount .."", { ['background-color'] = '#ffffff', ['color'] = '#000000' })
   elseif Config.NotifyType == "qbcore" then
    QBCore.Functions.Notify("".. oxyrunpackagestaken .."/".. Config.HandOff.Amount .."", 'success', 7500)
   end

    -- Adds a "Suspicious Package" to the player inventory.
    TriggerServerEvent('fd-oxyrun:server:getPackage')

   if oxyrunpackagestaken >= 0  then 
    -- Emote
    --TriggerEvent("fd-oxyrun:client:hasPackage")
   end

   -- If player has taken all needed packages.
   else 
   if Config.NotifyType == "mythic" then 
    exports['mythic_notify']:DoHudText('inform', Lang:t('npc2.toomanypackages'), { ['background-color'] = '#ffffff', ['color'] = '#000000' })
   elseif Config.NotifyType == "qbcore" then
    QBCore.Functions.Notify(Lang:t('npc2.toomanypackages'), 'error', 7500)
   end
   end

   -- When player takes the last needed package.
   if oxyrunpackagestaken == Config.HandOff.Amount then 

    -- Removes the DealerBlip.
    RemoveBlip(DealerBlip)

    TriggerEvent("fd-oxyrun:client:handofflocation")
    allpackges = true
    TriggerEvent('DeleteDealer')
   end
end)

-- Dealer ped delete event.
RegisterNetEvent('DeleteDealer', function()
    ClearPedTasks(Dealer)
    DeleteObject(npcPackage)
    FreezeEntityPosition(Dealer, false)
    SetPedAsNoLongerNeeded(Dealer)
    Wait(Config.DealerPed.DeleteTime * 60000)
    DeletePed(Dealer)
end)

RegisterNetEvent("fd-oxyrun:client:handofflocation", function()

    -- Notification.
   if Config.NotifyType == "mythic" then 
    exports['mythic_notify']:DoHudText('inform', Lang:t('npc2.drivetohandoff'), { ['background-color'] = '#ffffff', ['color'] = '#000000' })  
   elseif Config.NotifyType == "qbcore" then
    QBCore.Functions.Notify(Lang:t('npc2.drivetohandoff'), 'success', 7500)
   end

    -- Blip to the handoff location.
    HandOffBlip = AddBlipForCoord(Deliver)
    SetBlipSprite(HandOffBlip, Config.Blips.HandOffBlipType)
    SetBlipColour(HandOffBlip, Config.Blips.HandOffBlipColor)
   if Config.Blips.HandOffRouteON then 
    SetBlipRoute(HandOffBlip, true)
    SetBlipRouteColour(HandOffBlip, Config.Blips.HandOffRouteColor)
   end
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Blips.HandOffBlipText)
    EndTextCommandSetBlipName(HandOffBlip)

    -- Handoff polyzone.
    HandOffPolyZone = BoxZone:Create(Deliver, 10.0, 12.0, {
    name = "Handoffplaces",
    heading = 70.0,
    minZ = Deliver - 5,
    maxZ = Deliver + 5,
    debugPoly = false,
    })

    -- Detects if player is inside of polyzone.
    HandOffPolyZone:onPlayerInOut(function(inside)
    
   -- If player is inside the polyzone then.
   if inside then 
   if Config.NotifyType == "mythic" then 
    exports['mythic_notify']:DoHudText('inform', Lang:t('npc2.inlocation'), { ['background-color'] = '#ffffff', ['color'] = '#000000' })
   elseif Config.NotifyType == "qbcore" then 
    QBCore.Functions.Notify(Lang:t('npc2.inlocation'), 'success', 7500)
   end
   else 
   if Config.NotifyType == "mythic" then
    exports['mythic_notify']:DoHudText('inform', Lang:t('npc2.getbackinlocation'), { ['background-color'] = '#ffffff', ['color'] = '#000000' })
   elseif Config.NotifyType == "qbcore" then 
    QBCore.Functions.Notify(Lang:t('npc2.getbackinlocation'), 'error', 7500)
   end
   end 
   if not vehiclespawned  then
    TriggerEvent("fd-oxyrun:client:StartOxy") 
    vehiclespawned = true
   end
  end)
 end)

-- Basically the event to start the oxyrun and make it continue.
RegisterNetEvent('fd-oxyrun:client:StartOxy', function()
    handoffs = true

   -- Checks if player has not done all deliveries.
   if DeliveriedToCars < Config.HandOff.Amount then 
 
    -- Waiting time.
    Wait(math.random(Config.HandOff.MinTimeBetweenCars, Config.HandOff.MaxTimeBetweenCars) * 1000)

    -- Finds a random npc model.
    RandomNpc = Config.Vehiclenpc[math.random(1, #Config.Vehiclenpc)]

    -- Makes that the npc can spawn.
    npc = GetHashKey(RandomNpc) 
    RequestModel(RandomNpc)
    while not HasModelLoaded(RandomNpc) do
    Wait(1)
   end

    -- Finds a random vehicle.
    RandomVehicle = Config.Vehicles[math.random(1, #Config.Vehicles)]

   -- Makes that the vehicle can spawn.
   if not IsModelInCdimage(RandomVehicle) then return end
    RequestModel(RandomVehicle) 
    while not HasModelLoaded(RandomVehicle) do 
    Wait(10)
   end
    
    -- Creates a vehicle and npc inside of it.
    car = CreateVehicle(RandomVehicle, SpawnPoint, 100, false, false) 
    ped = CreatePedInsideVehicle(car, 1, RandomNpc, -1, true, false) 
    PedInCar = GetVehiclePedIsIn(RandomNpc, false) 
    SetVehicleEngineOn(car, true, true, false)
    
    -- Makes the vehicle drive to the location.
    TaskVehicleDriveToCoordLongrange(ped, car, Deliver.x, Deliver.y, Deliver.z, 8.0, 2883621, 1.0)

    while true do 
     Wait(1000)
    vehicleCoords = GetEntityCoords(car)
    if #(vehicleCoords - vector3(Deliver)) < 3.0 then
    exports['qb-target']:AddTargetEntity(car, {
    options = {
    { 
    type = "client",
    action = function()
     TriggerEvent("fd-oxyrun:client:HandoffPackage")
    end,
    icon = "fa-solid fa-user-secret",
    label = Lang:t('handoff.target'),
    },
    },

    -- Max distance between handoff vehicle and player for the target to work.
    distance = Config.HandOff.TargetDistance
    })
      break
     end
    end 
   end
  end)

-- Even for when a player uses the "Hand Off" target.
RegisterNetEvent('fd-oxyrun:client:HandoffPackage', function()
   -- Checks if player has not completed all handoffs.
   if DeliveriedToCars < Config.HandOff.Amount then 

    -- If player has a needed item.
   if Config.Core == "old" then 
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
   if result then 
     
    -- Payment
    TriggerServerEvent('fd-oxyrun:server:givepackage')

    -- Police alert.
    AlertChanceMathRandom = math.random(0, 100)
   if Config.CallCopsChance >= AlertChanceMathRandom then
    AlertCops()
   end
    
    -- Emote
    TriggerEvent("fd-oxyrun:client:hasPackage")

    -- Forgets the vehicle.
    TaskVehicleDriveWander(ped, car, 20.0, 537657916) 

    -- Removes the target. (Basically makes it so that you can't bugabuse).
    exports['qb-target']:RemoveTargetEntity(car, Lang:t('handoff.target'))

    -- Registers that player has handed off a package.
    DeliveriedToCars = DeliveriedToCars + 1

    -- Notification.
   if Config.NotifyType == "mythic" then
    exports['mythic_notify']:DoHudText('inform', "".. DeliveriedToCars .."/".. Config.HandOff.Amount .."", { ['background-color'] = '#ffffff', ['color'] = '#000000' })
   elseif Config.NotifyType == "qbcore" then
    QBCore.Functions.Notify("".. DeliveriedToCars .."/".. Config.HandOff.Amount .."", 'success', 7500)
   end

    -- Spawns the next vehicle to handoff to.
    TriggerEvent('fd-oxyrun:client:StartOxy')

    else 
    if Config.NotifyType == "mythic" then
     exports['mythic_notify']:DoHudText('inform', Lang:t('handoff.noitem'), { ['background-color'] = '#ffffff', ['color'] = '#000000' })
    elseif Config.NotifyType == "qbcore" then 
     QBCore.Functions.Notify(Lang:t('handoff.noitem'), 'error', 7500)
    end
    end
    end, Config.HandOff.NeededItem) 
    
    elseif Config.Core == "new" then 
     HasItem = QBCore.Functions.HasItem(Config.HandOff.NeededItem)
    if HasItem then 
             
    -- Payment
    TriggerServerEvent('fd-oxyrun:server:givepackage')

    -- Police alert.
    AlertChanceMathRandom = math.random(0, 100)
   if Config.CallCopsChance >= AlertChanceMathRandom then
    AlertCops()
   end
    
    -- Emote
    TriggerEvent("fd-oxyrun:client:hasPackage")

    -- Forgets the vehicle.
    TaskVehicleDriveWander(ped, car, 20.0, 537657916) 

    -- Removes the target. (Basically makes it so that you can't bugabuse).
    exports['qb-target']:RemoveTargetEntity(car, Lang:t('handoff.target'))

    -- Registers that player has handed off a package.
    DeliveriedToCars = DeliveriedToCars + 1

    -- Notification.
   if Config.NotifyType == "mythic" then
    exports['mythic_notify']:DoHudText('inform', "".. DeliveriedToCars .."/".. Config.HandOff.Amount .."", { ['background-color'] = '#ffffff', ['color'] = '#000000' })
   elseif Config.NotifyType == "qbcore" then
    QBCore.Functions.Notify("".. DeliveriedToCars .."/".. Config.HandOff.Amount .."", 'success', 7500)
   end

    -- Spawns the next vehicle to handoff to.
    TriggerEvent('fd-oxyrun:client:StartOxy')
    else 
    if Config.NotifyType == "mythic" then
     exports['mythic_notify']:DoHudText('inform', Lang:t('handoff.noitem'), { ['background-color'] = '#ffffff', ['color'] = '#000000' })
    elseif Config.NotifyType == "qbcore" then 
     QBCore.Functions.Notify(Lang:t('handoff.noitem'), 'error', 7500)
    end
    end
    end
    end

   -- If player has completed all handoffs.
   if DeliveriedToCars == Config.HandOff.Amount then 

    -- Adds back the route.
    TriggerEvent('fd-oxyrun:client:insertToTable')

    -- Removes blip.
    RemoveBlip(HandOffBlip)

    -- Notification.
   if Config.NotifyType == "mythic" then
    exports['mythic_notify']:DoHudText('inform', Lang:t('handoff.done'), { ['background-color'] = '#ffffff', ['color'] = '#000000' })
   elseif Config.NotifyType == "qbcore" then 
    QBCore.Functions.Notify(Lang:t('handoff.done'), 'success', 7500)
   end

    -- Deletes boxzone.
    HandOffPolyZone:destroy()

    -- Removes the target. (Basically makes it so that you can't bugabuse).
    exports['qb-target']:RemoveTargetEntity(car, Lang:t('handoff.target'))

    -- Cooldown.
   if Config.EnableCoolDown then
    TriggerServerEvent('fd-oxyrun:server:coolout')
   end

    -- Forgets the vehicle.
    TaskVehicleDriveWander(ped, car, 20.0, 537657916) 
    TriggerServerEvent('fd-oxyrun:server:SetOccupiedFalse', carsRoute)

    talked = false
    oxyrunpackagestaken = 0 
    pgiven = 0
    vehiclespawned = false
    allpackges = false
    handoffs = false
    DeliveriedToCars = 0
    Deliver = nil 
    SpawnPoint = nil
    carRoute = nil 
    carsRoute = nil


 end
end)

RegisterNetEvent("fd-oxyrun:client:hasPackage", function()

    -- Checks if you have the item.
  if Config.ForceAnimation then 
   if Config.Core == "old" then 
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
   if result then 
   
    -- The animation.
    holdingBox = true 
    DeleteEntity(SusPackage)
    ClearPedTasks(Player)
    LoadAnimation(Config.AnimationForPackage.animation)
    TaskPlayAnim(Player, Config.AnimationForPackage.animation, Config.AnimationForPackage.animationstyle, 6.0, -6.0, -1, 49, 0, 0, 0, 0)
    SusPackage = CreateObject(Config.AnimationForPackage.prop, Config.AnimationForPackage.propx, Config.AnimationForPackage.propy, Config.AnimationForPackage.propz, true, true, true)
    AttachEntityToEntity(SusPackage, Player, GetPedBoneIndex(Player,  Config.AnimationForPackage.boneindex), Config.AnimationForPackage.attachentityxpos, Config.AnimationForPackage.attachentityypos, Config.AnimationForPackage.attachentityzpos, Config.AnimationForPackage.attachentityxrot, Config.AnimationForPackage.attachentityyrot, Config.AnimationForPackage.attachentityzrot, true, true, false, true, 1, true)       
    DisableControls()

    -- If the player hasn't the needed item.
   else 
    holdingBox = false
    DeleteEntity(SusPackage)
    ClearPedTasks(Player)
   end

   -- The needed item.
   end, Config.HandOff.NeededItem)
   elseif Config.Core == "new" then
    HasItem = QBCore.Functions.HasItem(Config.HandOff.NeededItem)
   if HasItem then 

    -- The animation.
    holdingBox = true
    DeleteEntity(SusPackage)
    ClearPedTasks(Player)
    LoadAnimation(Config.AnimationForPackage.animation)
    TaskPlayAnim(Player, Config.AnimationForPackage.animation, Config.AnimationForPackage.animationstyle, 6.0, -6.0, -1, 49, 0, 0, 0, 0)
    SusPackage = CreateObject(Config.AnimationForPackage.prop, Config.AnimationForPackage.propx, Config.AnimationForPackage.propy, Config.AnimationForPackage.propz, true, true, true)
    AttachEntityToEntity(SusPackage, Player, GetPedBoneIndex(Player,  Config.AnimationForPackage.boneindex), Config.AnimationForPackage.attachentityxpos, Config.AnimationForPackage.attachentityypos, Config.AnimationForPackage.attachentityzpos, Config.AnimationForPackage.attachentityxrot, Config.AnimationForPackage.attachentityyrot, Config.AnimationForPackage.attachentityzrot, true, true, false, true, 1, true)
    DisableControls()
    
    -- If the player hasn't the needed item.
   else 
    holdingBox = false
    DeleteEntity(SusPackage)
    ClearPedTasks(Player)
   end
  end
 end
end)