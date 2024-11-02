exports.qbx_core:CreateUseableItem('gas_mask', function(source)
    local player = exports.qbx_core:GetPlayer(source)
    TriggerClientEvent('springo-gasmask:use', source)
end)

RegisterNetEvent("springo-gasmask:removeItem")
AddEventHandler("springo-gasmask:removeItem", function()
    local playerId = source
    exports.ox_inventory:RemoveItem(playerId, 'gas_mask', 1)
end)

RegisterNetEvent("springo-gasmask:addItem")
AddEventHandler("springo-gasmask:addItem", function()
    local playerId = source
    exports.ox_inventory:AddItem(playerId, 'gas_mask', 1)
end)