local Framework = nil

if Config.Framework == "qb-core" then
    Framework = exports['qb-core']:GetCoreObject()
elseif Config.Framework == "esx" then
    Framework = exports['es_extended']:getSharedObject()
end

RegisterServerEvent('ry_shops:checkout')
AddEventHandler('ry_shops:checkout', function(name, item, quantity, total, tipo, payment)
	local _source = source

	if Config.Framework == "qb-core" then
		local xPlayer = Framework.Functions.GetPlayer(_source)

		if (payment == 'cash') then
			local Money = xPlayer.PlayerData.money["cash"]

			if Money >= total then 
				xPlayer.Functions.RemoveMoney("cash", tonumber(total))
				if tipo == "item" then
					xPlayer.Functions.AddItem(item, quantity)
				elseif tipo == "weapon" then
					xPlayer.Functions.AddItem(item, 1)
				end	
				TriggerClientEvent("QBCore:Notify", _source, Config.Options['purchase_complete']);
			else
				TriggerClientEvent("QBCore:Notify", _source, Config.Options['no_money']);
			end
		elseif (payment == 'bank') then
			local Money = xPlayer.PlayerData.money["bank"]

			if Money >= total then 
				xPlayer.Functions.RemoveMoney("bank", tonumber(total))
				if tipo == "item" then
					xPlayer.Functions.AddItem(item, quantity)
				elseif tipo == "weapon" then
					xPlayer.Functions.AddItem(item, 1)
				end	
				TriggerClientEvent("QBCore:Notify", _source, Config.Options['purchase_complete']);
			else
				TriggerClientEvent("QBCore:Notify", _source, Config.Options['no_money']);
			end
		end
	elseif Config.Framework == "esx" then
		local xPlayer = Framework.GetPlayerFromId(_source)

		if (payment == "cash") then
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
		elseif (payment == 'bank') then
			local Money = xPlayer.getAccount('bank').money

			if Money >= total then 
				xPlayer.removeAccountMoney('bank', tonumber(total))
				if tipo == "item" then
					xPlayer.addInventoryItem(item, quantity)
				elseif tipo == "weapon" then
					xPlayer.addWeapon(item, 42)
				end	
				TriggerClientEvent("esx:showNotification", _source, Config.Options['purchase_complete']);
			else
				TriggerClientEvent("esx:showNotification", _source, Config.Options['no_money']);
			end
		end
	end
end)
