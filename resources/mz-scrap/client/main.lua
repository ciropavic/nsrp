QBCore = exports['qb-core']:GetCoreObject()

local PlayerData = {}
local isLoggedIn = false
local percent    = false
local searching  = false
local NeededAttempts = 0
local SucceededAttempts = 0
local FailedAttemps = 0
local craftcheck = false
local craftprocesscheck = false

cachedWreck = {}
closestScrap = {
    "prop_rub_buswreck_0",
    "prop_rub_carwreck_1",
    "prop_rub_carwreck_2",
    "prop_rub_carwreck_3",
    "prop_rub_carwreck_4",
    "prop_rub_carwreck_5",
    "prop_rub_carwreck_6",
    "prop_rub_carwreck_7",
    "prop_rub_carwreck_8",
    "prop_rub_carwreck_9",
    "prop_rub_carwreck_10",
    "prop_rub_carwreck_11",
    "prop_rub_carwreck_12",
    "prop_rub_carwreck_13",
    "prop_rub_carwreck_14",
    "prop_rub_carwreck_15",
    "prop_rub_carwreck_16",
}

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    isLoggedIn = true
end)

DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-------------
--SCRAPPING--
-------------

CreateThread(function()
    exports['qb-target']:AddTargetModel(Config.Objects, {
        options = {
            {
              type = "client",
              event = "mz-scrap:client:salvage",
              parameters = {},
              icon = "fas fa-search",
              label = "Use Hands"
            },
            {
              type = "client",
              event = "mz-scrap:client:salvage2",
              parameters = {},
              icon = "fas fa-screwdriver",
              label = "Use Screwdriver"
            },
            {
              type = "client",
              event = "mz-scrap:client:salvage3",
              parameters = {},
              icon = "fas fa-fire-extinguisher", 
              label = "Use Blowtorch"
            },
        },
    distance = 0.9
    })  
 end)

--------------
--HAND SCRAP--
--------------

RegisterNetEvent("mz-scrap:client:salvage")
AddEventHandler("mz-scrap:client:salvage", function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    for i = 1, #closestScrap do
        local x = GetClosestObjectOfType(playerCoords, 0.9, GetHashKey(closestScrap[i]), false, false, false)
        local entity = nil
        if DoesEntityExist(x) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
            entity = x
            if not cachedWreck[entity] then
                if Config.Handskillcheck then 
                    local handsearch = math.random(Config.handscraplow, Config.handscraphigh)
                    local success = exports['qb-lock']:StartLockPickCircle(handsearch, Config.handsearchtime)
                    if success then
                        ExtractScrap(entity)
                    else
                        if Config.mzskills == 'yes' then
                            local deteriorate = -Config.handXPloss
                            exports["mz-skills"]:UpdateSkill("Scraping", deteriorate)
                            if Config.NotifyType == 'qb' then
                                QBCore.Functions.Notify('Your hand slipped!', "error", 3500)
                                Wait(1000)
                                QBCore.Functions.Notify('-'..Config.handXPloss.. 'XP to Scraping', "error", 3500)
                            elseif Config.NotifyType == "okok" then
                                exports['okokNotify']:Alert("HAND SLIPPED!", "Don't hurt yourself!", 3500, "error")
                                Wait(1000)
                                exports['okokNotify']:Alert("SKILLS", '-'..Config.handXPloss.. 'XP to Scraping', 3500, "error")
                            end
                        end
                    end
                elseif not Config.Handskillcheck then 
                    ExtractScrap(entity)
                end
            else
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify('You already stripped this wreck!', "error", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("NO MORE SCRAP", "You already stripped this wreck.", 3500, "error")
                end
            end
        end    
    end
end)

ExtractScrap = function(entity)
    if Config.mzskills == 'yes' then 
        local BetterXP = math.random(Config.handXPlow, Config.handXPhigh)
        local chance2 = math.random(1, 4)
        if chance2 >= 3 then
            skillup = BetterXP
        else
            skillup = Config.handXPlow
        end
        exports["mz-skills"]:UpdateSkill("Scraping", skillup)
    end
    TriggerEvent('animations:client:EmoteCommandStart', {"kneel"})
    local handsearch = math.random(Config.handsearchlow * 1000, Config.handsearchhigh * 1000)
    QBCore.Functions.Progressbar("search_register", "Attempting to salvage scrap...", handsearch, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
        DisableControlAction(0, 170, true),
    }, {
    }, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        searching = true
        cachedWreck[entity] = true
        QBCore.Functions.TriggerCallback('mz-scrap:server:ScrapReward', function(result)
        end)
        ClearPedTasks(PlayerPedId())
        StopAnimTask(PlayerPedId(), "amb@world_human_welding@male@base", "base", 1.0)
        searching = false
    end, function() -- Cancel
        GetMoney = false
        StopAnimTask(PlayerPedId(), "amb@world_human_welding@male@base", "base", 1.0)
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You stopped scraping', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("INTERRUPTED", "You stopped scraping.", 3500, "error")
        end     
    end)
end

----------------------
--SCREWDRIVER SEARCH--
----------------------

RegisterNetEvent("mz-scrap:client:salvage2")
AddEventHandler("mz-scrap:client:salvage2", function()
    if Config.mzskills == 'yes' then 
        exports["mz-skills"]:CheckSkill("Scraping", Config.screwdriverXP, function(hasskill)
            if hasskill then
                if QBCore.Functions.HasItem("screwdriver") then
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    for i = 1, #closestScrap do
                        local x = GetClosestObjectOfType(playerCoords, 0.9, GetHashKey(closestScrap[i]), false, false, false)
                        local entity = nil
                        if DoesEntityExist(x) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                            entity = x
                            if not cachedWreck[entity] then
                                if Config.Screwdriverskillcheck then 
                                    local screwparse = math.random(Config.screwscraplow, Config.screwcraphigh)
                                    local success = exports['qb-lock']:StartLockPickCircle(screwparse, Config.screwsearchtime)
                                    if success then
                                        ExtractScrap2(entity)
                                    else
                                        local deteriorate = -Config.screwdriverXPloss
                                        exports["mz-skills"]:UpdateSkill("Scraping", deteriorate)
                                        if Config.NotifyType == 'qb' then
                                            QBCore.Functions.Notify('Your screwdriver flexes in your hand...', "error", 3500)
                                            Wait(1000)
                                            QBCore.Functions.Notify('-'..Config.screwdriverXPloss.. 'XP to Scraping', "error", 3500)
                                        elseif Config.NotifyType == "okok" then
                                            exports['okokNotify']:Alert("TOOL SHAKES", "Your screwdriver flexes in your hand...", 3500, "error")
                                            Wait(1000)
                                            exports['okokNotify']:Alert("SKILLS", '-'..Config.screwdriverXPloss.. 'XP to Scraping', 3500, "error")
                                        end
                                        Wait(1000)
                                        local failchance = math.random(1, 100)
                                        if failchance <= Config.screwdriverfail then 
                                            TriggerServerEvent('mz-scrap:server:screwdriverbreak')
                                            if Config.NotifyType == 'qb' then
                                                QBCore.Functions.Notify('Damn! Your screwdriver breaks!', "error", 3500)
                                            elseif Config.NotifyType == "okok" then
                                                exports['okokNotify']:Alert("SCREWDRIVER SNAPS", "Damn! Your screwdriver breaks!", 3500, "error")
                                            end
                                        end
                                    end
                                elseif not Config.Screwdriverskillcheck then 
                                    ExtractScrap2(entity)
                                end
                            else
                                if Config.NotifyType == 'qb' then
                                    QBCore.Functions.Notify('You already stripped this wreck!', "error", 3500)
                                elseif Config.NotifyType == "okok" then
                                    exports['okokNotify']:Alert("NO MORE SCRAP", "You already stripped this wreck.", 3500, "error")
                                end
                            end
                        end
                    end
                else
                    local requiredItems = {
                        [1] = {name = QBCore.Shared.Items["screwdriver"]["name"], image = QBCore.Shared.Items["screwdriver"]["image"]},
                    }
                    if Config.NotifyType == 'qb' then
                        QBCore.Functions.Notify('You need a screwdriver to access these parts.', "error", 3500)
                    elseif Config.NotifyType == "okok" then
                        exports['okokNotify']:Alert("WRONG TOOLS", "You need a screwdriver to access these parts.", 3500, "error")
                    end
                    TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                    Wait(3000)
                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                end 
            else
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify('You do not have enough Scraping skill, you need a minimum of '..Config.screwdriverXP..'XP.', "error", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("SKILLS", 'You do not have enough Scraping skill, you need a minimum of '..Config.screwdriverXP..'XP.', 3500, "error")
                end
            end
        end)
    elseif Config.mzskills == 'no' then
        if QBCore.Functions.HasItem("screwdriver") then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            for i = 1, #closestScrap do
                local x = GetClosestObjectOfType(playerCoords, 0.9, GetHashKey(closestScrap[i]), false, false, false)
                local entity = nil
                if DoesEntityExist(x) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    entity = x
                    if not cachedWreck[entity] then
                        if Config.Screwdriverskillcheck then 
                            local screwparse = math.random(Config.screwscraplow, Config.screwcraphigh)
                            local success = exports['qb-lock']:StartLockPickCircle(screwparse, Config.screwsearchtime)
                            if success then
                                ExtractScrap2(entity)
                            else
                                if Config.NotifyType == 'qb' then
                                    QBCore.Functions.Notify('Your screwdriver flexes in your hand...', "error", 3500)
                                elseif Config.NotifyType == "okok" then
                                    exports['okokNotify']:Alert("TOOL SHAKES", "Your screwdriver flexes in your hand...", 3500, "error")
                                end
                                local failchance = math.random(1, 100)
                                if failchance <= Config.screwdriverfail then 
                                    TriggerServerEvent('mz-scrap:server:screwdriverbreak')
                                    if Config.NotifyType == 'qb' then
                                        QBCore.Functions.Notify('Damn! Your screwdriver breaks!', "error", 3500)
                                    elseif Config.NotifyType == "okok" then
                                        exports['okokNotify']:Alert("SCREWDRIVER SNAPS", "Damn! Your screwdriver breaks!", 3500, "error")
                                    end
                                end
                            end
                        elseif not Config.Screwdriverskillcheck then 
                            ExtractScrap2(entity)
                        end
                    else
                        if Config.NotifyType == 'qb' then
                            QBCore.Functions.Notify('You already stripped this wreck!', "error", 3500)
                        elseif Config.NotifyType == "okok" then
                            exports['okokNotify']:Alert("NO MORE SCRAP", "You already stripped this wreck.", 3500, "error")
                        end
                    end
                end
            end
        else
            local requiredItems = {
                [1] = {name = QBCore.Shared.Items["screwdriver"]["name"], image = QBCore.Shared.Items["screwdriver"]["image"]},
            }
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You need a screwdriver to access these parts.', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("WRONG TOOLS", "You need a screwdriver to access these parts.", 3500, "error")
            end
            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
            Wait(3000)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
        end
    end    
end)

ExtractScrap2 = function(entity)
    if Config.mzskills == 'yes' then 
        local BetterXP2 = math.random(Config.screwdriverXPlow, Config.screwdriverXPhigh)
        local chance2 = math.random(1, 10)
        if chance2 >= 8 then
            skillup2 = BetterXP2
        elseif chance2 > 5 and chance2 < 8 then
            skillup2 = Config.screwdriverXPmid
        elseif chance2 < 6 then
            skillup2 = Config.screwdriverXPlow
        end
        exports["mz-skills"]:UpdateSkill("Scraping", skillup2)
    end
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    local screwsearchtime = math.random(Config.screwsearchlow * 1000, Config.screwsearchhigh * 1000)
    QBCore.Functions.Progressbar("search_register", "Attempting to salvage scrap...", screwsearchtime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
        DisableControlAction(0, 170, true),
    }, {
    }, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        searching = true
        cachedWreck[entity] = true
        QBCore.Functions.TriggerCallback('mz-scrap:server:ScrapReward2', function(result)
        end)
        Wait(1000)
        local successchance = math.random(1, 100)
        if successchance <= Config.screwdriversuccess then 
            TriggerServerEvent('mz-scrap:server:screwdriverbreak')
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('Damn! Your screwdriver breaks!', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("SCREWDRIVER SNAPS", "Damn! Your screwdriver breaks!", 3500, "error")
            end
        end
        ClearPedTasks(PlayerPedId())
        StopAnimTask(PlayerPedId(), "amb@world_human_welding@male@base", "base", 1.0)
        searching = false
    end, function() -- Cancel
        GetMoney = false
        StopAnimTask(PlayerPedId(), "amb@world_human_welding@male@base", "base", 1.0)
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You stopped scraping', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("INTERRUPTED", "You stopped scraping.", 3500, "error")
        end   
    end)
end

--------------------
--BLOWTORCH SEARCH--
--------------------

RegisterNetEvent("mz-scrap:client:salvage3")
AddEventHandler("mz-scrap:client:salvage3", function()
    if Config.mzskills == 'yes' then 
        exports["mz-skills"]:CheckSkill("Scraping", Config.blowtorchXP, function(hasskill)
            if hasskill then
                if QBCore.Functions.HasItem("blowtorch") then
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    for i = 1, #closestScrap do
                        local x = GetClosestObjectOfType(playerCoords, 0.9, GetHashKey(closestScrap[i]), false, false, false)
                        local entity = nil
                        if DoesEntityExist(x) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                            entity = x
                            if not cachedWreck[entity] then
                                if Config.Blowtorchskillcheck then 
                                    local blowparse = math.random(Config.blowscraplow, Config.blowscraphigh)
                                    local success = exports['qb-lock']:StartLockPickCircle(blowparse, Config.blowsearchtime)
                                    if success then
                                        ExtractScrap3(entity)
                                    else
                                        local deteriorate = -Config.blowtorchXPloss
                                        exports["mz-skills"]:UpdateSkill("Scraping", deteriorate)
                                        if Config.NotifyType == 'qb' then
                                            QBCore.Functions.Notify('Your blowtorch heats up uncomfortably...', "error", 3500)
                                            Wait(1000)
                                            QBCore.Functions.Notify('-'..Config.blowtorchXPloss.. 'XP to Scraping', "error", 3500)
                                        elseif Config.NotifyType == "okok" then
                                            exports['okokNotify']:Alert("TORCH HEATS UP", "Your blowtorch heats up uncomfortably...", 3500, "error")
                                            Wait(1000)
                                            exports['okokNotify']:Alert("SKILLS", '-'..Config.blowtorchXPloss.. 'XP to Scraping', 3500, "error")
                                        end
                                        local failchance2 = math.random(1, 100)
                                        if failchance2 <= Config.blowtorchfail then 
                                            TriggerServerEvent('mz-scrap:server:blowtorchbreak')
                                            if Config.NotifyType == 'qb' then
                                                QBCore.Functions.Notify('Damn! Your blowtorch burns out!', "error", 3500)
                                            elseif Config.NotifyType == "okok" then
                                                exports['okokNotify']:Alert("BLOWTORCH FRIED", "Damn! Your blowtorch burns out!", 3500, "error")
                                            end
                                        end
                                    end
                                elseif not Config.Blowtorchskillcheck then 
                                    ExtractScrap3(entity)
                                end
                            else
                                if Config.NotifyType == 'qb' then
                                    QBCore.Functions.Notify('You already stripped this wreck!', "error", 3500)
                                elseif Config.NotifyType == "okok" then
                                    exports['okokNotify']:Alert("NO MORE SCRAP", "You already stripped this wreck.", 3500, "error")
                                end
                            end
                        end
                    end
                else
                    local requiredItems = {
                        [1] = {name = QBCore.Shared.Items["blowtorch"]["name"], image = QBCore.Shared.Items["blowtorch"]["image"]},
                    }
                    if Config.NotifyType == 'qb' then
                        QBCore.Functions.Notify('You need a blowtorch to unweld these parts.', "error", 3500)
                    elseif Config.NotifyType == "okok" then
                        exports['okokNotify']:Alert("WRONG TOOLS", "You need a blowtorch to unweld these parts.", 3500, "error")
                    end
                    TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                    Wait(3000)
                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                end    
            else
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify('You do not have enough Scraping skill ('..Config.blowtorchXP..'XP needed)', "error", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("SKILLS", 'You do not have enough Scraping skill ('..Config.blowtorchXP..'XP needed)', 3500, "error")
                end        
            end
        end)
    elseif Config.mzskills == 'no' then 
        if QBCore.Functions.HasItem("blowtorch") then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            for i = 1, #closestScrap do
                local x = GetClosestObjectOfType(playerCoords, 0.9, GetHashKey(closestScrap[i]), false, false, false)
                local entity = nil
                if DoesEntityExist(x) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    entity = x
                    if not cachedWreck[entity] then
                        if Config.Blowtorchskillcheck then 
                            local BlowParse = math.random(Config.blowscraplow, Config.blowscraphigh)
                            local success = exports['qb-lock']:StartLockPickCircle(BlowParse, Config.blowsearchtime)
                            if success then
                                ExtractScrap3(entity)
                            else
                                if Config.NotifyType == 'qb' then
                                    QBCore.Functions.Notify('Your blowtorch heats up uncomfortably...', "error", 3500)
                                elseif Config.NotifyType == "okok" then
                                    exports['okokNotify']:Alert("TORCH HEATS UP", "Your blowtorch heats up uncomfortably...", 3500, "error")
                                end
                                Wait(1000)
                                local failchance2 = math.random(1, 100)
                                if failchance2 <= Config.blowtorchfail then 
                                    TriggerServerEvent('mz-scrap:server:blowtorchbreak')
                                    if Config.NotifyType == 'qb' then
                                        QBCore.Functions.Notify('Damn! Your blowtorch burns out!', "error", 3500)
                                    elseif Config.NotifyType == "okok" then
                                        exports['okokNotify']:Alert("BLOWTORCH FRIED", "Damn! Your blowtorch burns out!", 3500, "error")
                                    end
                                end
                            end
                        elseif not Config.Blowtorchskillcheck then 
                            ExtractScrap3(entity)
                        end
                    else
                        if Config.NotifyType == 'qb' then
                            QBCore.Functions.Notify('You already stripped this wreck!', "error", 3500)
                        elseif Config.NotifyType == "okok" then
                            exports['okokNotify']:Alert("NO MORE SCRAP", "You already stripped this wreck.", 3500, "error")
                        end
                    end
                end
            end
        else
            local requiredItems = {
                [1] = {name = QBCore.Shared.Items["blowtorch"]["name"], image = QBCore.Shared.Items["blowtorch"]["image"]},
            }
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You need a blowtorch to unweld these parts.', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("WRONG TOOLS", "You need a blowtorch to unweld these parts.", 3500, "error")
            end
            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
            Wait(3000)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
        end 
    end
end)

ExtractScrap3 = function(entity)
    if Config.mzskills == 'yes' then 
        local BetterXP2 = math.random(Config.blowtorchXPlow, Config.blowtorchXPhigh)
        local chance2 = math.random(1, 10)
        if chance2 >= 8 then
            skillup2 = BetterXP2
        elseif chance2 > 5 and chance2 < 8 then
            skillup2 = Config.blowtorchXPmid
        elseif chance2 < 6 then
            skillup2 = Config.blowtorchXPlow
        end
        exports["mz-skills"]:UpdateSkill("Scraping", skillup2)
    end
    TriggerEvent('animations:client:EmoteCommandStart', {"weld"})
    local blowtime = math.random(Config.blowsearchlow * 1000, Config.blowsearchhigh * 1000)
    QBCore.Functions.Progressbar("search_register", "Attempting to salvage scrap...", blowtime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
        DisableControlAction(0, 170, true),
    }, {
    }, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        searching = true
        cachedWreck[entity] = true
        QBCore.Functions.TriggerCallback('mz-scrap:server:ScrapReward3', function(result)
        end)
        ClearPedTasks(PlayerPedId())
        StopAnimTask(PlayerPedId(), "amb@world_human_welding@male@base", "base", 1.0)
        searching = false
        local successchance2 = math.random(1, 100)
        if successchance2 <= Config.blowtorchsuccess then 
            TriggerServerEvent('mz-scrap:server:blowtorchbreak')
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('Damn! Your blowtorch burns out!', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("BLOWTORCH FRIED", "Damn! Your blowtorch burns out!", 3500, "error")
            end
        end
    end, function() -- Cancel
        GetMoney = false
        StopAnimTask(PlayerPedId(), "amb@world_human_welding@male@base", "base", 1.0)
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You stopped scraping', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("INTERRUPTED", "You stopped scraping.", 3500, "error")
        end   
    end)
end

--------------------
--BREAK DOWN PARTS--
--------------------

---------
--TIRES--
---------

RegisterNetEvent('mz-scrap:client:BreakdownTires')
AddEventHandler('mz-scrap:client:BreakdownTires', function()
    if QBCore.Functions.HasItem("oldtire") then
        TriggerServerEvent("mz-scrap:server:BreakdownTires")
    else
        local requiredItems = {
            [1] = {name = QBCore.Shared.Items["oldtire"]["name"], image = QBCore.Shared.Items["oldtire"]["image"]}, 
        }  
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You cannot process tires without tires...', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("NEED TIRES", "You cannot process tires without tires...", 3500, "error")
        end   
        TriggerEvent('inventory:client:requiredItems', requiredItems, true)
        Wait(3000)
        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    end
end)

RegisterNetEvent('mz-scrap:client:BreakdownTiresMinigame')
AddEventHandler('mz-scrap:client:BreakdownTiresMinigame', function(source)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    BreakdownTiresMinigame(source)
end)

function BreakdownTiresMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(Config.tirelow, Config.tirehigh)
    end
    local maxwidth = 30
    local maxduration = 3000
    Skillbar.Start({
        duration = math.random(1200, 1600),
        pos = math.random(12, 30),
        width = math.random(12, 15),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            BreakTiresProcess()
            Wait(500)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You extract the good rubber from the wrecked tires', "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("RECEIVED RUBBER", "You extract the good rubber from the wrecked tires", 3500, "success")
            end   
            Wait(500)
            if Config.mzskills == 'yes' then 
                local BetterXP = math.random(Config.tireXPlow, Config.tireXPhigh)
                local multiplier = math.random(1, 4)
                if multiplier > 3 then
                    skillup = BetterXP
                else
                    skillup = Config.tireXPlow
                end
                exports["mz-skills"]:UpdateSkill("Scraping", skillup)
            end
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(1200, 1600),
                pos = math.random(10, 30),
                width = math.random(11, 12),
            })
        end
	end, function()
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You cut too far and ruin the tires...', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("TIRES RUINED", "You cut too far and ruin the tires...", 3500, "error")
            end
            Wait(500)
            if Config.mzskills == 'yes' then 
                local deteriorate = -Config.tireXPloss
                exports["mz-skills"]:UpdateSkill("Scraping", deteriorate)
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify('-'..Config.tireXPloss..'XP to Scraping', "error", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("SKILLS", '-'..Config.tireXPloss..'XP to Scraping', 3500, "error")
                end   
            end
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
            craftprocesscheck = false
            ClearPedTasks(PlayerPedId())
    end)
end

function BreakTiresProcess()
    local tiretime = math.random(Config.tiretimelow * 1000, Config.tiretimehigh * 1000)
    QBCore.Functions.Progressbar("grind_coke", "Carefully cutting good tread", tiretime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("mz-scrap:server:GetRubber")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
    end, function() -- Cancel
        openingDoor = false
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Process Cancelled', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("TASK STOPPED", "Process Cancelled", 3500, "error")
        end 
    end)
end

---------
--NAILS--
---------

RegisterNetEvent('mz-scrap:client:CleanNails')
AddEventHandler('mz-scrap:client:CleanNails', function()
    if QBCore.Functions.HasItem("rustynails") then
        if QBCore.Functions.HasItem("wd40") then
            TriggerServerEvent("mz-scrap:server:CleanNails")
        else
            local requiredItems = {
                [1] = {name = QBCore.Shared.Items["wd40"]["name"], image = QBCore.Shared.Items["wd40"]["image"]},
            }  
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You need something rusted and some rust remover...', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("NAILS + WD40", "You need something rusted and some rust remover...", 3500, "error")
            end   
            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
            Wait(3000)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
        end
    else
        local requiredItems = {
            [1] = {name = QBCore.Shared.Items["rustynails"]["name"], image = QBCore.Shared.Items["rustynails"]["image"]}, 
        }  
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You need something rusted and some rust remover...', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("NAILS + WD40", "You need something rusted and some rust remover...", 3500, "error")
        end   
        TriggerEvent('inventory:client:requiredItems', requiredItems, true)
        Wait(3000)
        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    end
end)

RegisterNetEvent('mz-scrap:client:CleanNailsMinigame')
AddEventHandler('mz-scrap:client:CleanNailsMinigame', function(source)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    CleanNailsMinigame(source)
end)

function CleanNailsMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(Config.naillow, Config.nailhigh)
    end
    local maxwidth = 30
    local maxduration = 3000
    Skillbar.Start({
        duration = math.random(1200, 1500),
        pos = math.random(12, 30),
        width = math.random(12, 15),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            CleanNailsProcess()
            Wait(500)
            if Config.mzskills == 'yes' then 
                local BetterXP = math.random(Config.nailXPlow, Config.nailXPhigh)
                local multiplier = math.random(1, 4)
                if multiplier > 3 then
                    skillup = BetterXP
                else
                    skillup = Config.nailXPlow
                end
                exports["mz-skills"]:UpdateSkill("Scraping", skillup)
            end
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You obtain some clean metal scrap', "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("METAL CLEANED", "You obtain some clean metal scrap", 3500, "success")
            end   
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(1000, 1200),
                pos = math.random(10, 30),
                width = math.random(10, 12),
            })
        end
	end, function()
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('The rusted nails disintegrate...', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("BAD NAILS", "The rusted nails disintegrate...", 3500, "error")
            end
            Wait(500)
            if Config.mzskills == 'yes' then 
                local deteriorate = -Config.nailXPloss
                exports["mz-skills"]:UpdateSkill("Scraping", deteriorate)
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify('-'..Config.nailXPloss..'XP to Scraping', "error", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("SKILLS", '-'..Config.nailXPloss..'XP to Scraping', 3500, "error")
                end   
            end   
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
            craftprocesscheck = false
            ClearPedTasks(PlayerPedId())
    end)
end

function CleanNailsProcess()
    local nailtail = math.random(Config.nailtimelow*1000, Config.nailtimehigh*1000)
    QBCore.Functions.Progressbar("grind_coke", "Cleaning off corrosion and restoring metal...", nailtail, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("mz-scrap:server:GetMetalscrap")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Process Cancelled', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("TASK STOPPED", "Process Cancelled", 3500, "error")
        end 
    end)
end

---------
--RADIO--
---------

RegisterNetEvent('mz-scrap:client:BreakdownRadio')
AddEventHandler('mz-scrap:client:BreakdownRadio', function()
    if QBCore.Functions.HasItem("carradio") then
        TriggerServerEvent("mz-scrap:server:ExtractRadio")
    else
        local requiredItems = {
            [1] = {name = QBCore.Shared.Items["carradio"]["name"], image = QBCore.Shared.Items["carradio"]["image"]}, 
        }  
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You need a car radio to extract its components', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("CAR RADIO NEEDED", "You need a car radio to extract its components", 3500, "error")
        end 
        TriggerEvent('inventory:client:requiredItems', requiredItems, true)
        Wait(3000)
        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    end
end)

RegisterNetEvent('mz-scrap:client:BreakRadioMinigame')
AddEventHandler('mz-scrap:client:BreakRadioMinigame', function(source)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    BreakRadioMinigame(source)
end)

function BreakRadioMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(Config.radiolow, Config.radiohigh)
    end
    local maxwidth = 30
    local maxduration = 3000
    Skillbar.Start({
        duration = math.random(1100, 1500),
        pos = math.random(10, 30),
        width = math.random(10, 15),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            BreakRadioProcess()
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You extract some electronic boards from the radio', "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("ELECTRONIC BOARDS", "You extract some electronic boards from the radio", 3500, "success")
            end
            Wait(500)
            if Config.mzskills == 'yes' then 
                local BetterXP = math.random(Config.radioXPlow, Config.radioXPhigh)
                local multiplier = math.random(1, 4)
                if multiplier > 3 then
                    skillup = BetterXP
                else
                    skillup = Config.radioXPlow
                end
                exports["mz-skills"]:UpdateSkill("Scraping", skillup)
            end
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(1000, 1200),
                pos = math.random(10, 30),
                width = math.random(8, 12),
            })
        end
	end, function()
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You are not going to be able to salvage these electronic boards...', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("HAND SLIPPED", "You are not going to be able to salvage these electronic boards...", 3500, "error")
        end
        Wait(500)
        if Config.mzskills == 'yes' then 
            local deteriorate = -Config.radioXPloss
            exports["mz-skills"]:UpdateSkill("Scraping", deteriorate)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('-'..Config.radioXPloss..'XP to Scraping', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("SKILLS", '-'..Config.radioXPloss..'XP to Scraping', 3500, "error")
            end   
        end
        FailedAttemps = 0
        SucceededAttempts = 0
        NeededAttempts = 0
        craftprocesscheck = false
        ClearPedTasks(PlayerPedId())
    end)
end

function BreakRadioProcess()
    local radiotime = math.random(Config.radiotimelow*1000, Config.radiotimehigh*1000)
    QBCore.Functions.Progressbar("grind_coke", "Stripping chasis and extracting components...", radiotime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("mz-scrap:server:GetElectricscrap")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Process Cancelled', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("TASK STOPPED", "Process Cancelled", 3500, "error")
        end 
    end)
end

-------------
--CAR JACKS--
-------------

RegisterNetEvent('mz-scrap:client:BreakdownCarjack')
AddEventHandler('mz-scrap:client:BreakdownCarjack', function()
    if QBCore.Functions.HasItem("carjack") then
        TriggerServerEvent("mz-scrap:server:BreakdownCarjack")
    else
        local requiredItems = {
            [1] = {name = QBCore.Shared.Items["carjack"]["name"], image = QBCore.Shared.Items["carjack"]["image"]}, 
        }  
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You need a car jack to extract materials from it...', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("CAR JACK NEEDED", "You need a car jack to extract materials from it...", 3500, "error")
        end 
        TriggerEvent('inventory:client:requiredItems', requiredItems, true)
        Wait(3000)
        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    end
end)

RegisterNetEvent('mz-scrap:client:BreakCarjackMinigame')
AddEventHandler('mz-scrap:client:BreakCarjackMinigame', function(source)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    BreakCarjackMinigame(source)
end)

function BreakCarjackMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(Config.jackslow, Config.jackshigh)
    end
    local maxwidth = 30
    local maxduration = 3000
    Skillbar.Start({
        duration = math.random(1100, 1500),
        pos = math.random(10, 30),
        width = math.random(10, 15),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            BreakCarjackProcess()
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You extract some metal from the car jacks', "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("METAL EXTRACTED", "You extract some metal from the car jacks", 3500, "success")
            end
            Wait(500)
            if Config.mzskills == 'yes' then 
                local BetterXP = math.random(Config.jacksXPlow, Config.jacksXPhigh)
                local multiplier = math.random(1, 4)
                if multiplier > 3 then
                    skillup = BetterXP
                else
                    skillup = Config.jacksXPlow
                end
                exports["mz-skills"]:UpdateSkill("Scraping", skillup)
            end   
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(1000, 1200),
                pos = math.random(10, 30),
                width = math.random(8, 12),
            })
        end
	end, function()
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('The jack breaks into useless pieces...', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("METAL RUINED", "The jack breaks into useless pieces...", 3500, "error")
        end 
        Wait(500)
        if Config.mzskills == 'yes' then 
            local deteriorate = -Config.jacksXPloss
            exports["mz-skills"]:UpdateSkill("Scraping", deteriorate)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('-'..Config.jacksXPloss..'XP to Scraping', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("SKILLS", '-'..Config.jacksXPloss..'XP to Scraping', 3500, "error")
            end   
        end  
        FailedAttemps = 0
        SucceededAttempts = 0
        NeededAttempts = 0
        craftprocesscheck = false
        ClearPedTasks(PlayerPedId())
    end)
end

function BreakCarjackProcess()
    local jackstime = math.random(Config.jackstimelow*1000, Config.jackstimehigh*1000)
    QBCore.Functions.Progressbar("grind_coke", "Disassembling car jack components...", jackstime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("mz-scrap:server:GetMetals")
        Wait(1000)
        TriggerServerEvent("mz-scrap:server:GetMetals2")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Process Cancelled', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("TASK STOPPED", "Process Cancelled", 3500, "error")
        end 
    end)
end

-------------
--CAR DOORS--
-------------

RegisterNetEvent('mz-scrap:client:BreakdownCardoor')
AddEventHandler('mz-scrap:client:BreakdownCardoor', function()
    if QBCore.Functions.HasItem("cardoor") then
        TriggerServerEvent("mz-scrap:server:BreakdownCardoor")
    else
        local requiredItems = {
            [1] = {name = QBCore.Shared.Items["cardoor"]["name"], image = QBCore.Shared.Items["cardoor"]["image"]}, 
        }  
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You need some car doors in order to extract materials from them...', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("CAR DOOR NEEDED", "You need some car doors in order to extract materials from them...", 3500, "error")
        end 
        TriggerEvent('inventory:client:requiredItems', requiredItems, true)
        Wait(3000)
        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    end
end)

RegisterNetEvent('mz-scrap:client:BreakCardoorMinigame')
AddEventHandler('mz-scrap:client:BreakCardoorMinigame', function(source)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    BreakCardoorMinigame(source)
end)

function BreakCardoorMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(Config.doorslow, Config.doorshigh)
    end
    local maxwidth = 30
    local maxduration = 3000
    Skillbar.Start({
        duration = math.random(1100, 1500),
        pos = math.random(10, 30),
        width = math.random(10, 15),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            BreakCardoorProcess()
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You extract some glass and metal from the doors', "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("MATERIAL EXTRACTED", "You extract some glass and metal from the doors", 3500, "success")
            end
            Wait(500)
            if Config.mzskills == 'yes' then 
                local BetterXP = math.random(Config.doorsXPlow, Config.doorsXPhigh)
                local multiplier = math.random(1, 4)
                if multiplier > 3 then
                    skillup = BetterXP
                else
                    skillup = Config.doorsXPlow
                end
                exports["mz-skills"]:UpdateSkill("Scraping", skillup)
            end     
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(1000, 1200),
                pos = math.random(10, 30),
                width = math.random(8, 12),
            })
        end
    end, function()
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('The car door breaks into useless pieces...', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("CAR DOORS RUINED", "The car door breaks into useless pieces...", 3500, "error")
        end
        if Config.mzskills == 'yes' then 
            local deteriorate = -Config.doorsXPloss
            exports["mz-skills"]:UpdateSkill("Scraping", deteriorate)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('-'..Config.doorsXPloss..'XP to Scraping', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("SKILLS", '-'..Config.doorsXPloss..'XP to Scraping', 3500, "error")
            end   
        end  
        FailedAttemps = 0
        SucceededAttempts = 0
        NeededAttempts = 0
        craftprocesscheck = false
        ClearPedTasks(PlayerPedId())
    end)
end

function BreakCardoorProcess()
    local doorstime = math.random(Config.doorstimelow * 1000, Config.doorstimehigh * 1000)
    QBCore.Functions.Progressbar("grind_coke", "Dismantling car door components...", doorstime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("mz-scrap:server:GetCardoormats")
        Wait(1000)
        TriggerServerEvent("mz-scrap:server:GetCardoormats2")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
    end, function() -- Cancel
        openingDoor = false
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Process Cancelled', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("TASK STOPPED", "Process Cancelled", 3500, "error")
        end 
    end)
end

------------
--CAR HOOD--
------------

RegisterNetEvent('mz-scrap:client:BreakdownCarhood')
AddEventHandler('mz-scrap:client:BreakdownCarhood', function()
    if QBCore.Functions.HasItem("carhood") then
        TriggerServerEvent("mz-scrap:server:BreakdownCarhood")
    else
        local requiredItems = {
            [1] = {name = QBCore.Shared.Items["carhood"]["name"], image = QBCore.Shared.Items["carhood"]["image"]}, 
        }  
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You need some car hoods in order to work on them...', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("CAR HOODS NEEDED", "You need some car hoods in order to work on them...", 3500, "error")
        end 
        TriggerEvent('inventory:client:requiredItems', requiredItems, true)
        Wait(3000)
        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    end
end)

RegisterNetEvent('mz-scrap:client:BreakCarhoodMinigame')
AddEventHandler('mz-scrap:client:BreakCarhoodMinigame', function(source)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    BreakCarhoodMinigame(source)
end)

function BreakCarhoodMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(Config.hoodslow, Config.hoodshigh)
    end
    local maxwidth = 30
    local maxduration = 3000
    Skillbar.Start({
        duration = math.random(1100, 1500),
        pos = math.random(10, 30),
        width = math.random(10, 15),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            BreakCarhoodProcess()
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You extract some iron and metal scrap from the hoods!', "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("MATERIAL EXTRACTED", "You extract some iron and metal scrap from the hoods!", 3500, "success")
            end
            Wait(500)
            if Config.mzskills == 'yes' then 
                local BetterXP = math.random(Config.hoodsXPlow, Config.hoodsXPhigh)
                local multiplier = math.random(1, 4)
                if multiplier > 3 then
                    skillup = BetterXP
                else
                    skillup = Config.hoodsXPlow
                end
                exports["mz-skills"]:UpdateSkill("Scraping", skillup)
            end        
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(1000, 1200),
                pos = math.random(10, 30),
                width = math.random(8, 12),
            })
        end
    end, function()
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('The car hoods snap across the mid panel. Ruined...', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("CAR HOODS RUINED", "The car hoods snap across the mid panel. Ruined...", 3500, "error")
        end
        if Config.mzskills == 'yes' then 
            local deteriorate = -Config.hoodsXPloss
            exports["mz-skills"]:UpdateSkill("Scraping", deteriorate)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('-'..Config.hoodsXPloss..'XP to Scraping', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("SKILLS", '-'..Config.hoodsXPloss..'XP to Scraping', 3500, "error")
            end   
        end
        FailedAttemps = 0
        SucceededAttempts = 0
        NeededAttempts = 0
        craftprocesscheck = false
        ClearPedTasks(PlayerPedId())
    end)
end

function BreakCarhoodProcess()
    local hoodstime = math.random(Config.hoodstimelow*1000, Config.hoodstimehigh*1000)
    QBCore.Functions.Progressbar("grind_coke", "Cutting apart hood components...", hoodstime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("mz-scrap:server:GetCarhoodmats")
        Wait(1000)
        TriggerServerEvent("mz-scrap:server:GetCarhoodmats2")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
    end, function() -- Cancel
        openingDoor = false
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Process Cancelled', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("TASK STOPPED", "Process Cancelled", 3500, "error")
        end 
    end)
end

--------------
--CAR ENGINE--
--------------

RegisterNetEvent('mz-scrap:client:BreakdownCarengine')
AddEventHandler('mz-scrap:client:BreakdownCarengine', function()
    if QBCore.Functions.HasItem("carengine") then
        if QBCore.Functions.HasItem("blowtorch") then
            TriggerServerEvent("mz-scrap:server:BreakdownCarengine")
        else
            local requiredItems = {
                [1] = {name = QBCore.Shared.Items["blowtorch"]["name"], image = QBCore.Shared.Items["blowtorch"]["image"]},  
            }  
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You need an engine block and a blowtorch to get to work', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("ENGINE + BLOWTORCH", "You need an engine block and a blowtorch to get to work", 3500, "error")
            end 
            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
            Wait(3000)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
        end
    else
        local requiredItems = {
            [1] = {name = QBCore.Shared.Items["carengine"]["name"], image = QBCore.Shared.Items["carengine"]["image"]},
        }  
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You need an engine block and a blowtorch to get to work', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("ENGINE + BLOWTORCH", "You need an engine block and a blowtorch to get to work", 3500, "error")
        end 
        TriggerEvent('inventory:client:requiredItems', requiredItems, true)
        Wait(3000)
        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    end
end)

RegisterNetEvent('mz-scrap:client:BreakCarengineMinigame')
AddEventHandler('mz-scrap:client:BreakCarengineMinigame', function(source)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    BreakCarengineMinigame(source)
end)

function BreakCarengineMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(Config.enginelow, Config.enginehigh)
    end
    local maxwidth = 30
    local maxduration = 3000
    Skillbar.Start({
        duration = math.random(1100, 1500),
        pos = math.random(10, 30),
        width = math.random(10, 15),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            BreakCarengineProcess()
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You extract some useful metal from the old engine!', "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("MATERIAL EXTRACTED", "You extract some useful metal from the old engine!", 3500, "success")
            end
            if Config.mzskills == 'yes' then 
                local BetterXP = math.random(Config.engineXPlow, Config.engineXPhigh)
                local multiplier = math.random(1, 4)
                if multiplier > 3 then
                    skillup = BetterXP
                else
                    skillup = Config.engineXPlow
                end
                exports["mz-skills"]:UpdateSkill("Scraping", skillup)
            end   
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(1000, 1200),
                pos = math.random(10, 30),
                width = math.random(8, 12),
            })
        end
    end, function()
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('The car engine leaks black fluid... Ruined...', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("CAR ENGINE RUINED", "The car engine leaks black fluid... Ruined...", 3500, "error")
        end
        if Config.mzskills == 'yes' then 
            local deteriorate = -Config.engineXPloss
            exports["mz-skills"]:UpdateSkill("Scraping", deteriorate)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('-'..Config.engineXPloss..'XP to Scraping', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("SKILLS", '-'..Config.engineXPloss..'XP to Scraping', 3500, "error")
            end   
        end
        FailedAttemps = 0
        SucceededAttempts = 0
        NeededAttempts = 0
        craftprocesscheck = false
        ClearPedTasks(PlayerPedId())
    end)
end

function BreakCarengineProcess()
    local enginetime = math.random(Config.enginetimelow*1000,Config.enginetimehigh*1000)
    QBCore.Functions.Progressbar("grind_coke", "Separating engine components...", enginetime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("mz-scrap:server:GetCarenginemats")
        Wait(1000)
        TriggerServerEvent("mz-scrap:server:GetCarenginemats2")
        Wait(1000)
        TriggerServerEvent("mz-scrap:server:GetCarenginemats3")
        Wait(1000)
        TriggerServerEvent("mz-scrap:server:GetCarenginemats4")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
    end, function() -- Cancel
        openingDoor = false
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Process Cancelled', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("TASK STOPPED", "Process Cancelled", 3500, "error")
        end 
    end)
end

-------------------
--SELL COMPONENTS--
-------------------

CreateThread(function()
    exports['qb-target']:AddBoxZone("SellCarParts", vector3(-54.9, 6392.3, 31.62), 1.4, 0.5, {
        name = "SellCarParts",
        heading = 315,
        debugPoly = false,
        minZ = 29.02,
        maxZ = 33.02,
        }, {
            options = { 
            {
                type = "client",
                event = "mz-scrap:client:openMenu",
                icon = 'fas fa-car',
                label = 'Sell Car Parts'
            },
        },
        distance = 1.5,
     })
end)

RegisterNetEvent('mz-scrap:client:openMenu', function()
    local pawnShop = {
        {
            header = "Zain's Second Hand Parts",
            isMenuHeader = true,
        },
        {
            header = "We buy your car parts!",
            txt = "The more the merrier!",
            params = {
                event = "mz-scrap:client:openPawn",
                args = {
                    items = Config.CarItems
                }
            }
        }
    }
    exports['qb-menu']:openMenu(pawnShop)
end)

RegisterNetEvent('mz-scrap:client:openPawn', function(data)
    QBCore.Functions.TriggerCallback('mz-scrap:server:getInv', function(inventory)
        local PlyInv = inventory
        local pawnMenu = {
            {
                header = "Zain's Second Hand Parts",
                isMenuHeader = true,
            }
        }
        for _, v in pairs(PlyInv) do
            for i = 1, #data.items do
                if v.name == data.items[i].item then
                    pawnMenu[#pawnMenu + 1] = {
                        header = QBCore.Shared.Items[v.name].label,
                        txt = Lang:t('info.sell_items', { value = data.items[i].price }),
                        params = {
                            event = 'mz-scrap:client:pawnitems',
                            args = {
                                label = QBCore.Shared.Items[v.name].label,
                                price = data.items[i].price,
                                name = v.name,
                                amount = v.amount
                            }
                        }
                    }
                end
            end
        end
        pawnMenu[#pawnMenu + 1] = {
            header = Lang:t('info.back'),
            params = {
                event = 'mz-scrap:client:openMenu'
            }
        }
        exports['qb-menu']:openMenu(pawnMenu)
    end)
end)

RegisterNetEvent('mz-scrap:client:pawnitems', function(item)
    local sellingItem = exports['qb-input']:ShowInput({
        header = Lang:t('info.title'),
        submitText = Lang:t('info.sell'),
        inputs = {
            {
                type = 'number',
                isRequired = false,
                name = 'amount',
                text = Lang:t('info.max', { value = item.amount })
            }
        }
    })
    if sellingItem then
        if not sellingItem.amount then
            return
        end

        if tonumber(sellingItem.amount) > 0 then
            TriggerServerEvent('mz-scrap:server:sellPawnItems', item.name, sellingItem.amount, item.price)
        else
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('error.negative'), 'error')
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("NEGATIVE?", "You cannot sell a negative amount...", 3500, "error")
            end 
        end
    end
end)

-------------
--FUNCTIONS--
-------------

CreateThread(function()
    exports['qb-target']:AddBoxZone("Markparts", vector3(1176.08, 2635.15, 37.75), 3.6, 1, {
        name = "Makeparts",
        heading = 90,
        debugPoly = false,
        minZ = 34.35,
        maxZ = 38.35,
        }, {
            options = { 
            {
                type = "client",
                event = "mz-scrap:client:BreakdownTires",
                icon = 'fas fa-tire-flat',
                label = 'Process old tires'
            },
            {
                type = "client",
                event = "mz-scrap:client:CleanNails",
                icon = 'fas fa-screwdriver',
                label = 'Remove rust from nails'
            },
            {
                type = "client",
                event = "mz-scrap:client:BreakdownRadio",
                icon = 'fas fa-radio',
                label = 'Disassemble car radio'
            },
            {
                type = "client",
                event = "mz-scrap:client:BreakdownCarjack",
                icon = 'fas fa-times',
                label = 'Break down car jack' 
            },
            {
                type = "client",
                event = "mz-scrap:client:BreakdownCardoor",
                icon = 'fas fa-door-closed',
                label = 'Break apart car door' 
            },
            {
                type = "client",
                event = "mz-scrap:client:BreakdownCarhood",
                icon = 'fas fa-car',
                label = 'Strip car hood' 
            },
            {
                type = "client",
                event = "mz-scrap:client:BreakdownCarengine",
                icon = 'fas fa-car-mechanic',
                label = 'Strip engine block' 
            },
        },
        distance = 1.5,
    })
end)

CreateThread(function()
    for _, value in pairs(Config.SellLocation) do
        local blip = AddBlipForCoord(value.coords.x, value.coords.y, value.coords.z)
        SetBlipSprite(blip, 375)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 5)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Lang:t('info.title'))
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do
        local sleep = 1000
        if percent then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            for i = 1, #closestScrap do
                local x = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(closestScrap[i]), false, false, false)
                local entity = nil
                if DoesEntityExist(x) then
                    sleep  = 5
                    entity = x
                    bin    = GetEntityCoords(entity)
                    DrawText3Ds(bin.x, bin.y, bin.z + 1.5, TimeLeft .. '~g~%~s~')
                    break
                end
            end
        end
        Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if searching then
            DisableControlAction(0, 73)
        end
    end
end)