local ox_inventory = exports.ox_inventory

ox_inventory:registerHook('swapItems', function(data)
	if data.source == data.fromInventory and data.fromSlot ~= nil and data.toSlot ~= nil and type(data.toSlot) == 'table' then
		if data.toSlot.name then
			if not Config.item_blacklist[data.toSlot.name.lower(data.toSlot.name)] and (Config.tag_item == data.fromSlot.name.lower(data.fromSlot.name) or Config.tag_removal_item == data.fromSlot.name.lower(data.fromSlot.name)) then
                if Config.tag_item == data.fromSlot.name.lower(data.fromSlot.name) then
				    TriggerClientEvent('nbs_item_tags:client:wrightTag', data.source, data.toSlot.slot, data.toSlot)
                end

                if Config.tag_removal_item == data.fromSlot.name.lower(data.fromSlot.name) then
				    TriggerClientEvent('nbs_item_tags:client:removeTag', data.source, data.toSlot.slot, data.toSlot)
                end
				return false
			end
		end
	end
end, {})

lib.callback.register('nbs_item_tags:server:addTag', function(source, slot, data, text)
	local source = source
	local metadata = data.metadata

    local success = exports.ox_inventory:RemoveItem(source, Config.tag_item, 1)

    if not success then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'You dont have a tag',
            type = 'error'
        })
        return false
    end

    metadata.original_label = data.label

    if metadata.label and not metadata.original_label then
        metadata.original_label = metadata.label
    end

	metadata.label = text

    ox_inventory:SetMetadata(source, slot, metadata)

    return source
end)

lib.callback.register('nbs_item_tags:server:removeTag', function(source, slot, data)
	local source = source
	local metadata = data.metadata

    local success = exports.ox_inventory:RemoveItem(source, Config.tag_removal_item , 1)

    if not success then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'You dont have a tag removal kit',
            type = 'error'
        })
        return false
    end

    metadata.label = metadata.original_label
	metadata.original_label = nil

	ox_inventory:SetMetadata(source, slot, metadata)

    return source
end)
