-- ⠀⢀⣤⣶⣿⣿⣿⣿⣷⣦⡀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣷⡆⠀⢸⣿⣿⣿⣿⡄⠀⠀⠀⢰⣿⣿⣿⣿⠀⠀⠀⣿⣿⣿⠀⠀⢸⣿⣿⡇⠀⠀⠀⢸⣿⣿⡇⠀⠀⣿⣿⣿⣿⣧⠀⠀⠀⠀⣾⣿⣿⣿⡇⠀⠀⢸⣿⣿⣿⣿⣿⣿⡆⠘⢿⣿⣿⣄⠀⠀⣰⣿⣿⡿⠃
-- ⢀⣾⣿⣿⠟⠉⠉⠛⣿⣿⣿⡆⠀⢰⣿⣿⣿⠉⠉⠙⠛⠀⠀⢸⣿⣿⣿⣿⣧⠀⠀⠀⣾⣿⣿⣿⣿⠀⠀⠀⣿⣿⣿⠀⠀⢸⣿⣿⡇⠀⠀⠀⢸⣿⣿⡇⠀⠀⣿⣿⣿⣿⣿⡄⠀⠀⢰⣿⣿⣿⣿⡇⠀⠀⢸⣿⣿⡏⠉⠉⠉⠁⠀⠈⢻⣿⣿⣆⣰⣿⣿⡿⠁
-- ⢸⣿⣿⡿⠀⠀⠀⠀⢸⣿⣿⣷⠀⠈⢿⣿⣿⣷⣦⣤⡀⠀⠀⢸⣿⣿⡏⣿⣿⡆⠀⢸⣿⡿⢸⣿⣿⠀⠀⠀⣿⣿⣿⠀⠀⢸⣿⣿⡇⠀⠀⠀⢸⣿⣿⡇⠀⠀⣿⣿⣿⢹⣿⣷⠀⠀⣿⣿⠇⣿⣿⡇⠀⠀⢸⣿⣿⣧⣤⣤⣤⠀⠀⠀⠀⠻⣿⣿⣿⣿⠟
-- ⢸⣿⣿⣷⠀⠀⠀⠀⢸⣿⣿⣿⠀⠀⠀⠙⠛⠿⣿⣿⣿⣆⠀⢸⣿⣿⡇⢹⣿⣷⢀⣿⣿⠃⢸⣿⣿⠀⠀⠀⣿⣿⣿⠀⠀⢸⣿⣿⡇⠀⠀⠀⢸⣿⣿⡇⠀⠀⣿⣿⣿⠈⣿⣿⡆⣸⣿⡟⠀⣿⣿⡇⠀⠀⢸⣿⣿⡿⠿⠿⠿⠀⠀⠀⠀⣴⣿⣿⣿⣿⣆
-- ⠈⣿⣿⣿⣦⣀⣀⣤⣿⣿⣿⠇⠀⢰⣤⣄⣀⣀⣸⣿⣿⡟⠀⢸⣿⣿⡇⠀⣿⣿⣿⣿⡟⠀⢸⣿⣿⠀⠀⠀⣿⣿⣿⠀⠀⠘⣿⣿⣿⣄⣀⣠⣾⣿⣿⠇⠀⠀⣿⣿⣿⠀⢸⣿⣿⣿⣿⠃⠀⣿⣿⡇⠀⠀⢸⣿⣿⡇⠀⠀⠀⠀⠀⢀⣾⣿⣿⠏⠹⣿⣿⣧⡀
-- ⠀⠈⠻⢿⣿⣿⣿⣿⡿⠟⠃⠀⠀⠸⢿⣿⣿⣿⣿⡿⠟⠁⠀⢸⣿⣿⡇⠀⠸⣿⣿⣿⠃⠀⢸⣿⣿⠀⠀⠀⣿⣿⣿⠀⠀⠀⠙⠿⣿⣿⣿⣿⣿⠿⠋⠀⠀⠀⣿⣿⣿⠀⠀⢿⣿⣿⡟⠀⠀⣿⣿⡇⠀⠀⢸⣿⣿⡇⠀⠀⠀⠀⣠⣿⣿⣿⠃⠀⠀⠙⣿⣿⣿⣄

-- ----------------------------------------------------------------------------------------------------------------------------

QBCore = exports['qb-core']:GetCoreObject()

local IsHostageCuffed = {}
local IsHostageGrabbed = {}
local HostageInTrunk = {}
local IsPlayerShielding = {}
local IsHostageSitting = {}

local copsonline = 0

local hasHostage = false
local hasRobbed = false
local UnderCD = false

local HostageGL = nil 

Citizen.CreateThread(function()
    while true do 
        QBCore.Functions.TriggerCallback('osm-npcai:getCops', function(cops)
            if cops ~= nil then 
                copsonline = tonumber(cops)
            end
        end)
        Citizen.Wait(20000)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if IsControlPressed(0, Config.KeyGun) and not hasHostage then -- E PREMO IL TASTO
            player = PlayerPedId()
			_ , NPC = GetEntityPlayerIsFreeAimingAt(PlayerId())
			if GetEntityType(NPC) == 1 and GetPedType(NPC) ~= 28 and not IsPedDeadOrDying(NPC) and IsPedArmed(player, 4) then 
				distanceToNPC = #(GetEntityCoords(player) - GetEntityCoords(NPC))
				if distanceToNPC <= Config.DistancefromNPC then
                if copsonline >= Config.RequiredCops then 
                    randomact = math.random(1,9)
                    QBCore.Functions.TriggerCallback('osm-npcai:GetGlobalCooldown', function(GlobalCD)
                    if not GlobalCD then 
						if GetEntityAlpha(NPC) == 255 then
                            if not UnderCD then 
                                if IsWeaponPowerful() then 
                                    if randomact > Config.SurrenderProbability then
                                        QBCore.Functions.Notify('No Luck on this Person!')
                                        SetEntityAlpha(NPC, 254)
                                        TaskReactAndFleePed(NPC)
                                        hasHostage = true
                                        Citizen.Wait(3000)
                                        hasHostage = false
                                    elseif randomact <= Config.SurrenderProbability then
                                        HostageGL = NPC

                                        TaskSetBlockingOfNonTemporaryEvents(NPC, true)
                                        SetPedAlertness(NPC, 0)
                                        TaskWanderStandard(NPC, 0.0, 0.0)
                                        
                                        IsHostageCuffed[NPC] = false
                                        IsHostageGrabbed[NPC] = false
                                        IsPlayerShielding[NPC] = false
                                        HostageInTrunk[NPC] = false
                                        IsHostageSitting[NPC] = false
                                        
                                        TriggerEvent("osm-npcai:hostagesurrender", NPC)
                                        
                                        hasHostage = true
                                    end
                                else
                                    QBCore.Functions.Notify('Get a Powerful Weapon First!')
                                    SetEntityAlpha(NPC, 254)
                                    TaskReactAndFleePed(NPC)
                                    Citizen.Wait(3000)
                                    hasHostage = false
                                end
                            else
                                    QBCore.Functions.Notify('You had a Hostage Recently! Try again later!')
                                    SetEntityAlpha(NPC, 254)
                                    TaskReactAndFleePed(NPC)
                                    Citizen.Wait(3000)
                                    hasHostage = false
                            end
						else
    						QBCore.Functions.Notify('Find some other Ped!')
							SetEntityAlpha(NPC, 254)
							TaskReactAndFleePed(NPC)
                            Citizen.Wait(3000)
							hasHostage = false
						end
                    else
                        if Config.CombatonFail then 
                            QBCore.Functions.Notify('A Hostage situation has recently happened! Try again later!')
                            SetPedSeeingRange(NPC, 100.0)
                            SetPedHearingRange(NPC, 80.0)
                            SetPedCombatAttributes(NPC, 46, 1)
                            SetPedFleeAttributes(NPC, 0, 0)
                            SetPedCombatRange(NPC,2)
                            TaskCombatPed(NPC, PlayerPedId(), 0, 16)
                            hasHostage = false
                        else
                            SetEntityAlpha(NPC, 254)
                            TaskReactAndFleePed(NPC)
                            Citizen.Wait(3000)
                            hasHostage = false
                        end
                    end
                    end)
                else
                    QBCore.Functions.Notify('Not Enough Cops for Hostage Situation')
                end
				end
            
			end
		end
	end
end)

function IsWeaponPowerful()
    if Config.EnableAllowedWeapons then 
        local ped = PlayerPedId()
        local pedWeapon = GetSelectedPedWeapon(ped)

        for k, v in pairs(Config.AllowedWeapons) do
            if pedWeapon == v then
                return true
            end
        end
        return false
    else
        return true
    end
end


RegisterNetEvent('osm-npcai:hostagesurrender')
AddEventHandler('osm-npcai:hostagesurrender', function(hostage) 
 
	Citizen.CreateThread(function()

        SetPedFleeAttributes(hostage, 0, 0)
        SetPedDropsWeaponsWhenDead(hostage,false)
        ClearPedTasks(hostage)
        ClearPedSecondaryTask(hostage)
        TaskTurnPedToFaceEntity(hostage, PlayerPedId(), 3.0)
        TaskSetBlockingOfNonTemporaryEvents(hostage, true)

        SetPedCombatAttributes(hostage, 17, 1)
        SetPedSeeingRange(hostage, 0.0)
        SetPedHearingRange(hostage, 0.0)
        SetPedAlertness(hostage, 0)
        SetEntityAsMissionEntity(hostage, 0, 0)

        if Config.DisablePlayerFire then 
            Citizen.CreateThread(function()
                while true do 
                    Citizen.Wait(0)
                    DisablePlayerFiring(PlayerPedId(), true)
                    if not hasHostage then 
                        break
                    end
                end
            end)
        end

        TriggerEvent('osm-npcai:CooldownHandle')

        local model = GetEntityModel(hostage)

        exports['qb-target']:AddTargetModel(model, {
            options = {
                {
                    type = "client",
                    event = "osm-npcai:RobHostage",
                    icon = "fas fa-hands",
                    label = "Loot the Hostage",
                },
                {
                    type = "server",
                    event = "osm-npcai:srv:releaseHostage",
                    icon = "fas fa-hands",
                    label = "Release the Hostage",
                    hostage = hostage,
                },
                {
                    type = "client",
                    event = "osm-npcai:putdown",
                    icon = "fas fa-hands",
                    label = "Put the Hostage Down",
                    hostage = hostage,
                },
                {
                    type = "client",
                    event = "osm-npcai:togglegrab",
                    icon = "fas fa-hands",
                    label = "Grab the Hostage",
                    hostage = hostage,
                },
                {
                    type = "client",
                    event = "osm-npcai:handcuff",
                    icon = "fas fa-hands",
                    label = "Cuff the Hostage",
                    hostage = hostage,
                },
            },
            distance = Config.EyeDistance
        })

        loadAnimDict("missfbi5ig_22")
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(1)
                if HostageGL ~= nil then 
                    if IsEntityDead(hostage) then
                        SetEntityAsNoLongerNeeded(hostage)
                        DetachEntity(hostage, true, true)
                        DeleteEntity(hostage)
                        HostageGL = nil 
                        hasHostage = false
                        hasRobbed = false
                    end
                    if hasHostage and not IsHostageCuffed[hostage] then 
                        if not IsEntityPlayingAnim(hostage, "missfbi5ig_22", "hands_up_anxious_scientist", 3) then
                            TaskPlayAnim(hostage, "missfbi5ig_22", "hands_up_anxious_scientist", 5.0, 1.0, -1, 1, 0, 0, 0, 0)
                            Citizen.Wait(1)
                        end
                        Citizen.Wait(500)
                    else
                        Citizen.Wait(1000)
                    end
                else
                    break
                end
            end    
        end)

	end)
end)

RegisterNetEvent('osm-npcai:RobHostage')
AddEventHandler('osm-npcai:RobHostage', function()
    local hostage = HostageGL
    if not hasRobbed then 
        QBCore.Functions.Progressbar("robbing_player", "Stealing Cash..", math.random(5000, 7000), false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "random@shop_robbery",
            anim = "robbery_action_b",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
            TriggerServerEvent('osm-npcai:srv:RobHostage')
            hasRobbed = true
        end, function() -- Cancel
            StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
            QBCore.Functions.Notify("Canceled!", "error")
        end)
    else
        QBCore.Functions.Notify('You have already robbed once!')
    end
end)

RegisterNetEvent('osm-npcai:releaseHostage')
AddEventHandler('osm-npcai:releaseHostage', function(data)
    local hostage = data.hostage

    FreezeEntityPosition(hostage, false)
    ClearPedTasksImmediately(hostage)
    SetPedCanRagdoll(hostage, true) 
    SetBlockingOfNonTemporaryEvents(hostage, false) 
    SetPedKeepTask(hostage, false)
    SetEntityAsNoLongerNeeded(hostage)
    SetEntityInvincible(hostage , false)

    IsHostageCuffed[hostage] = false
    IsHostageGrabbed[hostage] = false
    IsPlayerShielding[hostage] = false
    HostageInTrunk[hostage] = false
    IsHostageSitting[hostage] = false

    Citizen.Wait(200)
    TaskWanderStandard(hostage, 10.0, 10)
end)

RegisterNetEvent('osm-npcai:SetReleaseSource')
AddEventHandler('osm-npcai:SetReleaseSource', function()
    HostageGL = nil 
    hasHostage = false
    hasRobbed = false
end)

RegisterNetEvent('osm-npcai:togglegrab')
AddEventHandler('osm-npcai:togglegrab', function(data)
    local hostage = HostageGL
	local player = PlayerPedId()
	if IsHostageGrabbed[hostage] then
		TriggerServerEvent('osm-npcai:deattach', player, hostage)
		IsHostageGrabbed[hostage] = false
	else
		TriggerServerEvent('osm-npcai:attach', player, hostage)
		IsHostageGrabbed[hostage] = true
	end	
end)

RegisterCommand('ungrab', function()
    if HostageGL ~= nil then 
        TriggerEvent('osm-npcai:togglegrab')
    end
end)

RegisterNetEvent('osm-npcai:putdown')
AddEventHandler('osm-npcai:putdown', function()
    
    local hostage = HostageGL
	local player = PlayerPedId()
    
    loadAnimDict( "random@arrests" )
    loadAnimDict( "random@arrests@busted" )

    if IsHostageSitting[hostage] then
        TaskPlayAnim(hostage, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
        ClearPedTasksImmediately(hostage)
		IsHostageSitting[hostage] = false
	else
		IsHostageSitting[hostage] = true

        while true do
            if IsHostageSitting[hostage] then
                Citizen.Wait(1)
                TaskPlayAnim(hostage, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
            else
                TaskPlayAnim(hostage, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
                break
            end
        end
	end	
end)


RegisterNetEvent('osm-npcai:CooldownHandle')
AddEventHandler('osm-npcai:CooldownHandle', function()
    if Config.EnableGlobalCooldown then 
        TriggerServerEvent('osm-npcai:ServerCooldown')
    end
    if Config.EnablePlayerCooldown then 
        local CooldownTime = math.ceil(Config.PlayerCooldown * 60)
        UnderCD = true
        Citizen.CreateThread(function()
            while UnderCD and CooldownTime > 0 do 
                Citizen.Wait(5000)
                CooldownTime = CooldownTime - 5
            
                if CooldownTime <= 0 then 
                    UnderCD = false
                    CooldownTime = Config.PlayerCooldown * 60
                    break
                end
            end
        end)
    end
end)

RegisterNetEvent('osm-npcai:attach')
AddEventHandler('osm-npcai:attach', function(source, target)
	AttachEntityToEntity(target, source, 11816, -0.3, 0.4, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
	SetEntityCollision(target, false, false)
	SetBlockingOfNonTemporaryEvents(target, true)
	SetPedCanPlayGestureAnims(target, false)
end)

RegisterNetEvent('osm-npcai:deattach')
AddEventHandler('osm-npcai:deattach', function(source, target)
	SetEntityCollision(target, true, true)
	DetachEntity(target, true, false)
	SetBlockingOfNonTemporaryEvents(target, true)
	SetPedCanPlayGestureAnims(target, true)
end)

RegisterNetEvent('osm-npcai:handcuff')
AddEventHandler('osm-npcai:handcuff', function()	
QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
    if result then
        local hostage = HostageGL
        Citizen.CreateThread(function()
            Citizen.Wait(100)	
            if DoesEntityExist(hostage) then
                if not IsHostageCuffed[hostage] then
                    local player = PlayerPedId()
                    local playerGroupId = GetPedGroupIndex(player)
                    SetEnableHandcuffs(hostage, true)
                    SetPedAsGroupMember(hostage, playerGroupId)
                    TaskGoToEntity(hostage, PlayerPedId(), -1, 1.0, 10.0, 1073741824.0, 0)

                    TriggerServerEvent('osm-npcai:srv:HandcuffAnimations', player, hostage)

                    IsHostageCuffed[hostage] = true
                    HostageTaken = true
                else
                    TriggerServerEvent('osm-npcai:srv:Uncuff', hostage)
                    IsHostageCuffed[hostage] = false
                    ClearPedTasksImmediately(hostage)
                end
            end	
        end)
    else
    QBCore.Functions.Notify('You must have Handcuffs to Cuff the Hostage!', error)
    end
end, 'handcuffs')

end)

RegisterNetEvent('osm-npcai:SyncUncuff')
AddEventHandler('Uncuff', function(hostage)
    IsHostageCuffed[hostage] = false
    ClearPedTasksImmediately(hostage)
end)

RegisterNetEvent('osm-npcai:HandcuffAnimations')
AddEventHandler('osm-npcai:HandcuffAnimations', function(playerped1, hostage)

    IsHostageCuffed[hostage] = true

    local cuffer = playerped1
    local heading = GetEntityHeading(cuffer)
    loadAnimDict("mp_arrest_paired")
    loadAnimDict("mp_arresting")

    TaskPlayAnim(hostage, "mp_arrest_paired", "crook_p2_back_right", 3.0, 3.0, -1, 0, 0, 0, 0, 0)         

    SetEntityCoords(hostage, GetOffsetFromEntityInWorldCoords(cuffer, 0.0, 0.45, 0.0))

    Citizen.Wait(100)
    
    SetEntityHeading(hostage, heading)
    
	Citizen.Wait(100)
    
    TaskPlayAnim(cuffer, "mp_arrest_paired", "cop_p2_back_right", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
	
    Citizen.Wait(3500)

    TaskPlayAnim(cuffer, "mp_arrest_paired", "exit", 3.0, 3.0, -1, 48, 0, 0, 0, 0)

    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)
            if IsHostageCuffed[hostage] then 
                if (not IsEntityPlayingAnim(hostage, "mp_arresting", "idle", 3) and not IsEntityPlayingAnim(hostage, "mp_arrest_paired", "crook_p2_back_right", 3)) then
                    TaskPlayAnim(hostage, "mp_arresting", "idle", 5.0, 1.0, -1, 48, 0, 0, 0, 0)
                end
            end
        end
    end)
end)

----------------------------------------------------------

function loadAnimDict( dict )  
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 
