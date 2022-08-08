RegisterServerEvent('ry_shops:checkout')
AddEventHandler('ry_shops:checkout', function(name, item, quantity, total, tipo)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  local Money = xPlayer.getAccount('money').money

  if Money >= total then 
		xPlayer.removeMoney(tonumber(total))
		if tipo == "item" then
			xPlayer.addInventoryItem(item, quantity)
		elseif tipo == "weapon" then
			xPlayer.addWeapon(item, 42)
		end	
		TriggerClientEvent("esx:showNotification", _source, Config.Options['purchase_complete']);
	else
		TriggerClientEvent("esx:showNotification", _source, Config.Options['no_money']);
	end
end)
