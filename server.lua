

ESX.RegisterServerCallback('fs_namechange:checkmoney', function(source, cb)
   local xPlayer = ESX.GetPlayerFromId(source)
   local account = xPlayer.getAccount(Config.settings.account)
   
   if account.money >= Config.settings.price then 
    cb(true)
   else
    cb(false)
   end

end)

 RegisterNetEvent("fs_namechanger:savename")
 AddEventHandler('fs_namechanger:savename', function(firstname, lastname)
    local xPlayer = ESX.GetPlayerFromId(source) 

  xPlayer.setName(('%s %s'):format(firstname, lastname))
  if Config.settings.permanent then
      local affectedRows = MySQL.update.await('UPDATE users SET firstname = ? , lastname = ? WHERE identifier = ?', {
      firstname, lastname, xPlayer.getIdentifier()
      })
      if affectedRows > 0 then
        xPlayer.showNotification("Your name has been updated!")
      end 
  else
      xPlayer.showNotification("Your name has been updated!")
  end

end)
 
 
ESX.RegisterServerCallback('fsnamechange:removemoney', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local account = xPlayer.getAccount(Config.settings.account).money

   if account >= Config.settings.price then

    xPlayer.removeAccountMoney(Config.settings.account, Config.settings.price)
       cb(true)
   else
       cb(false)
   end
   
 end)

