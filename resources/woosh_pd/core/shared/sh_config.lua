local QBCore = exports['qb-core']:GetCoreObject()
Config = {}

Config.PulloverKey = "H" -- Default H, the key you press to flag down a vehicle.
Config.PulloverPresses = 1 -- The amount of times you must press the above key to trigger a flag down.
Config.MenuKey = "G" -- Default G, the key you press to bring up the menu if you choose to close it.

Config.ValidJobs = {
    "police",
}

Config.ShowText = true -- Toggle the left side text when you have someone pulled over.
Config.HoldText = "You currently have someone held. \nUse the keybind to open the menu." -- Text that lets the officer know they currently have someone pullover.
Config.ChaseText = "Currently chasing a fleeing suspect! Stay close.." -- Text that lets the officer know they currently have someone pullover.
Config.Direction = "left" -- Side of the screen to show hold text.

-- Name Generation
Config.pedMaleF = {"George", "Isaac", "Steve", "Daniel", "Mike", "Michael", "Terry", "Jay", "Eugene", "Jorje", "Derek", "Frank", "Fernando", "Peter", "Pete", "Liam", "Lionel", "Larry", "Garry", "Paul", "Steven", "Stephen", "Saul", "Zane", "Harry", "Jake", "Dean", "Francis", "Patar", "Nuno", "Terrance"}
Config.pedFemaleF = {"Anna", "Olivia", "Emma", "Charlotte", "Amelia", "Sophia", "Mia", "Isabella", "Mia", "Evelyn", "Harper", "Luna", "Camila", "Gianna", "Eleanor", "Ella", "Abigail", "Sofia", "Avery", "Emily", "Aria", "Hazel", "Nova", "Lily", "Stella", "Willow", "Victoria", "Leah", "Addison", "Zoe" , "Natalie", "Natalia", "Valentina", "Bella", "Josephine", "Claire", "Audrey", "Autumn", "Delilah", "Piper", "Rylee", "Clara", "Liliana", "Samantha", "Eden", "Maeve", "Remi", "Melody"}
Config.pedLast = {"Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin", "Lee", "Perez", "Thompson", "White", "Harris", "Sanchez", "Clark", "King", "Allen", "Young", "Garcia", "King", "Lewis", "Hall", "Wilson", "Miller", "Moore"}

Config.MenuLabel = "Suspect Menu"
Config.Follow_Vehicle = "Follow my vehicle"
Config.LetGo = "Release Individual"
Config.RequestID = "Request License/ID"
Config.FollowMe = "Follow Me"
Config.Escort = "Grab onto wrists/Let go"
Config.FaceMe = "Face me please"
Config.Release_and_let_them_keep_vehicle = "Release Individual, Drive Away"
Config.Release_but_dont_let_them_keep_vehicle = "Release Individual, Walk Away"
Config.Cuff = "Detain (Cuff)"
Config.Uncuff = "Uncuff"
Config.Place_in_squad_car = "Place in Car"
Config.Jail = "Send to Jail"
Config.ExitMenu = "Exit Menu"
Config.StepOut = "Step out the vehicle & follow"
Config.InspectVehicle = "Look for illegals inside vehicle"
Config.InspectPerson = "Search individual"

Config.LimitJailingToValidLocations = true
Config.JailLocations = { -- Position and range to check for when trying to use the send to jail option.
    {position = vector3(393.56, -1613.72, 29.29), range = 30.0}, -- Davis PD
    {position = vector3(-1113.8, -849.63, 13.45), range = 50.0}, -- Vespucci PD (burgershot)
    {position = vector3(640.79, -0.49, 82.78), range = 25.0}, -- Vinewood PD
    {position = vector3(-441.99, 6018.58, 31.6), range = 25.0}, -- Paleto PD
    {position = vector3(453.59, -993.13, 31.65), range = 50.0}, -- Mission Row PD
}
Config.Not_Near_A_Valid_Send_Off_Location = "You are not near a valid location for the bus to pick your suspect up."
Config.Enable_Payment_Reward_For_Jailing_NPC = true
Config.MoneyType_Jailing = "cash" -- bank/cash
Config.MinMoney_Jailing = 250
Config.MaxMoney_Jailing = 450

Config.CanResistArrest = false
Config.ResistChance = 10 -- Chance to resist the cuffing from 1-100, number must be at or below this option to try and resist.

Config.EnableChaseMinigame = true -- Chase the ped, make them surrender by either sticking to their vehicle for long enough, or breaking their engine
Config.FleeMinigameChance = 10 -- Chance to resist the pullover from 1-100 and run, number must be at or below this option to try and flee.
Config.RequiredChaseDistance = 30.0 -- Distance required to maintain to make the fleeing NPC begin to sweat
Config.ChaseInterval = 300 -- The amount of milliseconds between distance checks, higher numbers = longer chases

function DoNotification(message)
    -- print(message)
    
    -- Replace this with your own notification system.
    -- Example;
    QBCore.Functions.Notify(message)
end

Config.Suspect_Dead_Or_Too_Far = "The individual you were dealing with has died, or you moved too far away from them."
Config.FollowNoti = "They are now attempting to follow you."
Config.ReleaseNoti = "The suspect has been released and is now free to go about their day."
Config.StepOutNoti = "The suspect steps out of their vehicle."
Config.FaceMeNoti = "The suspect will keep facing you."
Config.FollowFootNoti = "The suspect will now try and stay with you."
Config.Release_and_let_them_keep_vehicle_Noti = "The suspect gets in their vehicle and drives away, going about their day."
Config.Release_but_dont_let_them_keep_vehicle_Noti = "The suspect walks away from the situation."
Config.UncuffNoti = "You uncuff the suspect."
Config.JailNoti = "You send the suspect off to jail."
Config.Place_in_squad_car_Noti = "The suspect will now attempt to get into a free seat in the back of your squad car."
Config.CuffNoti = "You handcuff the suspect."
Config.ClosedMenu = "You closed the menu, use the keybind to re-open it."
Config.FoundNothingNotiVehicle = "You found nothing worth noting inside the vehicle."
Config.FoundNothingNotiPerson = "You found nothing illegal on the person."
Config.Suspect_Is_Fleeing = "The suspect is fleeing! Taze them to secure them in cuffs."
Config.CommandOnFoot = "You ask the person for a few minutes of their time."

-- THESE ARE NOT REAL ITEMS, AND PURELY BUILD A NOTIFICATION TO FURTHER RP WITH THE NPC.

-- You discover..
Config.RandomAmountMin = 0
Config.RandomAmountMax = 10
-- ...
Config.RandomItem = {
    "cocaine bags",
    "knifes",
    "bags of marijuana",
    "burner phones",
    "illegal frogs",
}
-- in..
Config.RandomLocationVehicle = {
    "the passenger seat.",
    "the glovebox.",
    "the bottom of the seat.",
    "the back seat.",
    "the dashboard.",
    "the door compartment.",
    "the bulging headrest.",
    "the cup holder.",
}
Config.RandomLocationPerson = {
    "their back pocket.",
    "their inside pocket.",
    "their shoes.",
    "the back of their pants.",
    "the front of their pants.",
    "their pockets.",
}
