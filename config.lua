Config = {}

-- Basics
Config.Core = "new" -- old or new
Config.EnableCoolDown = true -- If cooldowns are enabled
Config.Cooldown = 10 -- Cooldown after run is done (in minutes)
Config.NotifyType = "qbcore" -- Notify type: mythic = mythic_notify // qbcore = QBNotify (Need more? Ask me!)
Config.ForceAnimation = true -- If the animation for the package is used.

-- Cops
Config.RequiredCops = 0 -- HOW MANY COPS YOU NEED ON YOUR SERVER TO START THE RUN
Config.CallCopsChance = 75 -- Chance for the cops to get a notification.
Config.CopsAlertType = "ps-dispatch" -- Notification type: qbcore = Provided by QBCore // ps-dispatch = Project Sloth Dispatch 
                                -- Need more? Add them in client/cl_main.lua line 23, A example is shown!

-- Start the run payment.
Config.StartingPayment = {
  EnableStartingPayment = true, 
  Amount = 1000,
  Type = "cash",
}

-- Handoff                                
Config.HandOff = {
  Amount = 5, -- How many handoffs the player will have to do.
  NeededItem = "suspiciouspackage",
  MinTimeBetweenCars = 5, -- Seconds
  MaxTimeBetweenCars = 15, -- Seconds
  GiveOxy = true, -- If player gets oxy when handing off.
  TargetDistance = 2.0, -- Maximum target distance between player and car for it to work.
}

-- Starting ped (Bossped)
Config.BossPed = {
    Model = "s_m_y_dealer_01", 
    Coords = vector4(481.18, -591.21, 23.75, 299.77), 
    Scenario = "WORLD_HUMAN_STAND_PATIENT",
    EmoteON = false, 
    Emote = "WORLD_HUMAN_SMOKING_POT",
    MaxTargetDistance = 2.0,

    -- Animation when "talking" with the boss.
    EnableProgressbarAndEmote = false, 
    PlayerAnimation = "misscarsteal4@actor",
    PlayerAnimationType = "actor_berating_loop",
    Duration = 10000, -- in Milliseconds
}

-- DEALER PED / "SECOND PED"
Config.DealerPed = {
    Model = "u_m_m_edtoh",
    Coords = {
        vector4(783.09, 1278.24, 359.29, 269.23),
        vector4(94.7, -2676.61, 5.2, 357.36)
    },
    MaxTargetDistance = 2.0,
    DeleteTime = 1, -- Minutes
}

-- Ped that allows player to sell oxy.
Config.OxySellPed = {
  -- Ped
  Enable = true, 
  Model = "s_f_y_factory_01",
  Coords = vector4(-1139.57, -199.87, 36.95, 202.64),
  Scenario = "WORLD_HUMAN_STAND_PATIENT",
  EmoteON = true, 
  Emote = "WORLD_HUMAN_SMOKING_POT",
  MaxTargetDistance = 2.0,
  -- Selling 
  Sell = {item = "oxy", price = "500", type = "cash"},
}

Config.Blips = { 
    -- Dealer ped.
    DealerBlipType = 1,
    DealerBlipColor = 0,
    DealerRouteON = true,
    DealerRouteColor = 11,
    DealerBlipText = "Dealer",
    -- Handoff.
    HandOffBlipType = 1,
    HandOffBlipColor = 0,
    HandOffRouteON = true,
    HandOffRouteColor = 11,
    HandOffBlipText = "Handoff Location",
    -- Oxysell
    OxySellEnableBlip = false,
    OxySellBlipType = 51, 
    OxySellBlipColor = 0, 
    OxySellBlipText = "Sell Oxy"
}

-- HANDOFF VEHICLES
Config.Vehicles = {
    `sultan`,
    `glendale`
}
-- PEDS FOR HANDOFF VEHICLES
Config.Vehiclenpc = {
    `ig_ballasog`,
    `a_m_m_bevhills_01`,
    `a_m_m_fatlatin_01`,
    `cs_guadalope`,
    `cs_denise`,
    `cs_movpremmale`,
    `cs_old_man2`,
    `cs_siemonyetarian`
}

-- Laundering
Config.EnableLaunder = true
Config.LaunderMoneyType = "cash"

-- Marked Bills
Config.MarkedBills = { 
        -- Money laundering chance
        CleanChance = 100, 
        -- Money
        MinAmount = 500,
        MaxAmount = 1000,
        -- Items removed
        MinRemoveItems = 1,
        MaxRemoveItems = 2,  
}

-- Band Of Notes
Config.BandOfNotes = { 
        -- Money laundering chance
        CleanChance = 100,
        -- Money
        MinAmount = 250,
        MaxAmount = 900,
        -- Items removed
        MinRemoveItems = 10,
        MaxRemoveItems = 30,   
}

-- Roll Of Small Notes
Config.RollOfSmallNotes = {
        -- Money laundering chance
        CleanChance = 100,
        -- Money
        MinAmount = 100, 
        MaxAmount = 500,
        -- Items removed
        MinRemoveItems = 10,
        MaxRemoveItems = 30,   
}

-- Extra money (Money that comes as a bonus from laundering).
Config.ExtraMoney = {
        AllowExtraMoney = true,
        MoneyType = "cash",
        Chance = 100,
        MinAmount = 300,
        MaxAmount = 1000
}

-- Bonus items.
Config.BonusItems = {
        AllowBonusItems = true,
        Chance = 2,
        MinAmount = 1,
        MaxAmount = 1,
}
Config.BonusItem = { -- Add items here.
        "usb_green",
        "electronickit"
}

Config.Routes = { -- HERE YOU CAN ADD AS MANY LOCATIONS AS YOU WANT TO
  [1] = {
    SpawnPoint = vector4(259.13, -125.32, 67.76, 157.05), -- Where car spawns
    Deliver = vector4(220.58, -166.64, 56.64, 70.0), -- Where car drives to
    Occupied = false, -- Do not touch
  },
  [2] = {
    SpawnPoint = vector4(259.13, -125.32, 67.76, 157.05),
    Deliver = vector4(220.58, -166.64, 56.64, 70.0), 
    Occupied = false,
  }
}

Config.AnimationForPackage = {
  animation = 'anim@heists@box_carry@',
  animationstyle = 'idle',
  prop = `hei_prop_heist_box`,
  propx = 0.0,
  propy = 0.0, 
  propz = 0.0,
  boneindex = 60309,
  attachentityxpos = 0.025, 
  attachentityypos = 0.08, 
  attachentityzpos = 0.255, 
  attachentityxrot = -145.0, 
  attachentityyrot = 290.0, 
  attachentityzrot = 0.0,
}


