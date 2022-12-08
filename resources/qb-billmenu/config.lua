QBCore = exports['qb-core']:GetCoreObject() -- shared core , support only qbcore newversion , contact admin for support
FileName = GetCurrentResourceName() -- allowed u change file name ! 

Config = {}

Config.oxmysql = 187 -- your version oxmysql , 1.9.3 = 193 , 1.8.7 = 187

Config.Webhooks = { -- webhook log send bild
    ['logbill'] = 'https://discord.com/api/webhooks/1048881889391423508/ZzuZpaCc4lJ9RpDgODGYBMkc8mLh0Y7yYq-38-xWkT78acf1x0MzX9wyNFqUbVTUCXqG',
}

Lang = { -- config language
    newinvoice = 'New invoice',
    sendsuccess = 'Sent',
    invaildamount = 'Amt Must be Greater than 0',
    selfbillerror = 'Cannot Bill Yourself',
    playernotonline = 'ID not online',
    noaccess = 'Not authorized to do this',
    billform = 'Invoice Form',
    billing = 'Bill',
    createbill = 'Create Invoice',
    amount = 'Amount: ',
    reason = 'Reason: ',
    pleasepayit = 'Please Pay Bill',

    cid = 'Player ID(#)',
    camount = 'Amount of Money ($)',
    creason = 'Reason',
}

Config.job = { -- rename job label
    ['police'] = {
        label = 'Police'
    },
    ['mechanic'] = {
        label = 'Mechanic'
    },
    ['cardealer'] = {
        label = 'CarDealer'
    },
    ['ambulance'] = {
        label = 'Medical Services'
    },
}

--- dev by candoit#3550

----------------------------------------------------------------------------------------------------
-----------------------------------------TEMPLATES DOCUMENT-----------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--   command open bill--if filename is qb-billmenu then event : qb-billmenu:bill   -----------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--                                                                                 -----------------
--      RegisterCommand('billmenu', function(source, args)                         -----------------
--          -- do stuff                                                            -----------------
--          TriggerEvent('qb-billmenu:bill')                                       -----------------
--           -- do stuff                                                           -----------------
--      end)                                                                       -----------------
--                                                                                 -----------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
------------------------------   exports function      ---------------------------------------------
----------------------------------------------------------------------------------------------------
--                                                                                  ----------------
--  exports['qb-billmenu']AddBill(cid, amount, reason)                              ----------------
--                                                                                  ----------------
--  exports['qb-billmenu']AddBill('1', '100000', 'trả tiền')                        ----------------
--                                                                                  ----------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
