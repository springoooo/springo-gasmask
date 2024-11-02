local isWearingGasMask = false 
local gasMaskHash = Springo.GasMaskClothing
local maskSlot = 1
local rebreatherSound = "player_scuba_mask_loop"
local soundId = nil

local function applyGasMaskProofs(playerPed) 
    SetEntityProofs(playerPed, false, false, false, false, false, false, true, true, false)
end 

local function removeGasMaskProofs(playerPed)
    SetEntityProofs(playerPed, false, false, false, false, false, false, false, false, false)
end

local function applyGasMaskEffects()
    StartScreenEffect("ChopVision", 0, true) 
    if not soundId then
        soundId = GetSoundId()
        PlaySoundFrontend(soundId, rebreatherSound, "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", true)
    end
end

local function removeGasMaskEffects()
    StopScreenEffect("ChopVision")
    if soundId then
        StopSound(soundId)
        ReleaseSoundId(soundId) 
        soundId = nil
    end
end

local function equipGasMask()
    local playerPed = PlayerPedId()
    RequestAnimDict("mp_masks@on_foot")
    while not HasAnimDictLoaded("mp_masks@on_foot") do
        Wait(0)
    end

    TaskPlayAnim(playerPed, "mp_masks@on_foot", "put_on_mask", 8.0, 8.0, -1, 49, 0, false, false, false)

    lib.progressBar({
        duration = 3000, 
        label = "Putting on gas mask...",
        useWhileDead = false,
        canCancel = false,
        disable = { car = true, move = true, combat = true }
    })

    Wait(3000)

    SetPedComponentVariation(playerPed, maskSlot, 0, 0, 2)

    SetPedComponentVariation(playerPed, maskSlot, gasMaskHash, 0, 2)
    applyGasMaskProofs(playerPed)
    applyGasMaskEffects()

    TriggerServerEvent('springo-gasmask:removeItem')

    isWearingGasMask = true
end

local function removeGasMask()
    local playerPed = PlayerPedId()

    RequestAnimDict("missfbi4")
    while not HasAnimDictLoaded("missfbi4") do
        Wait(0)
    end

    TaskPlayAnim(playerPed, "missfbi4", "takeoff_mask", 8.0, 8.0, -1, 49, 0, false, false, false)

    lib.progressBar({
        duration = 3000, 
        label = "Removing gas mask...",
        useWhileDead = false,
        canCancel = false,
        disable = { car = true, move = true, combat = true }
    })

    Wait(3000)

    SetPedComponentVariation(playerPed, maskSlot, 0, 0, 2)
    removeGasMaskProofs(playerPed)
    removeGasMaskEffects()

    TriggerServerEvent('springo-gasmask:addItem')

    isWearingGasMask = false
end

CreateThread(function()
    while true do 
        Wait(1000)
        local playerPed = PlayerPedId()
        local currentMask = GetPedDrawableVariation(playerPed, maskSlot)
        if isWearingGasMask and currentMask ~= gasMaskHash then 
            removeGasMask() 
        end 
    end
end)

RegisterCommand('removegasmask', function()
    if isWearingGasMask then 
        removeGasMask()
    else 
        lib.notify({
            title = 'Gas Mask',
            description = 'You are not wearing a gas mask',
            type = 'error',
            duration = 5000,
        })
    end
end)

RegisterKeyMapping("removegasmask", 'Remove Gas Mask', 'keyboard', Springo.GasMaskKeybinding)

RegisterNetEvent('springo-gasmask:use')
AddEventHandler('springo-gasmask:use', function()
    if not isWearingGasMask then
        equipGasMask()
    else 
        lib.notify({
            title = 'Gas Mask',
            description = 'You are already wearing a gas mask',
            type = 'error',
            duration = 5000,
        })
    end
end)
