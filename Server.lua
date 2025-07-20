local Api = "https://katana.it.com" -->> [ API ]
local ScriptName = "" -->> [ اسم السكربت في الموقع ]
local LicenseKey = Config.License -->> [ رخصة استخدام العميل ]
local Script_Name_Game = "" -->> [ اسم سكربتك الأساسي ]

local webhook_start = "" -->> ويب هوك تشغيل السكربت
local webhook_stop = "" -->> ويب هوك اغلاق السكربت
local webhook_unauthorized = "" -->> ويب هوك حدوث مشكلة في api
local webhook_connection_fail = "" -->> ويب هوك حدوث مشكلة في api

local Config_Katana = {
    Made_By = "NQ Dev", -->> [ حقوق في cmd ]
    contact = "NQ",  -->> [ حقوق في cmd ]
    EnableFreezeOnFail = true, -->> [ تكريش السيرفر ]< true - تفعيل > < false - تعطيل > 
    Exit_Server_CMD_CheckingName = true, -->> [ اغلاق cmd ] < true - تفعيل > < false - تعطيل > 

    Bot_Setting = {
        UserName_Bot = "🔐 Katana License Bot", -->> [ اسم البوت ]
        Logo_Bot = "https://cdn.discordapp.com/icons/1278151350781349888/a_1be0487f6af5f70964afa54ca243f6a0.gif", -->> [ لوقو البوت ]
    }
}

local resources = {}
for i = 0, GetNumResources() - 1 do
    table.insert(resources, GetResourceByFindIndex(i))
end
local active = table.concat(resources, ", ")

function sendEmbedToDiscord(title, description, color, webhook)
    local embed = {
        {
            ["title"] = title,
            ["description"] = "```" .. description .. "```",
            ["color"] = color,
            ["fields"] = {
                { name = "📜 Script", value = "`" .. ScriptName .. "`", inline = true }, -->>  اظهار اسم السكربت
                { name = "🖥️ IP Address", value = "`" .. (IP or "N/A") .. "`", inline = true }, -->>  اظهار ايبي الشخص
                { name = "📌 Server Name", value = "`" .. GetConvar("sv_hostname", "Unknown") .. "`", inline = true }, -->> اظهار اسم السيرفر
                { name = "📌 license Key Server", value = "`" .. GetConvar("sv_licenseKey", "Unknown") .. "`", inline = true }, -->>  اظهار رخصة السيرفر
                { name = "👤 Licensed ", value = "`" .. (LicenseKey or "N/A") .. "`", inline = true }, -->>  اظهار رخصة العميل
                { name = "📂 Resource Path", value = "`" .. GetResourcePath(GetCurrentResourceName()) .. "`", inline = false },
                { name = "📦 Active Resources", value = "```" .. active:sub(1, 400) .. "```", inline = false }, -->> اظهار جميع ملفات السيرفر
                { name = "🕒 Timestamp", value = "`" .. os.date("%Y-%m-%d %H:%M:%S") .. "`", inline = false }, -->> اظهار الوقت
            },
            ["footer"] = {
                text = "🔒 Katana License System | Made by " .. Config_Katana.Made_By,
                icon_url = Config_Katana.Bot_Setting.Logo_Bot
            },
            ["author"] = {
                name = Config_Katana.Bot_Setting.UserName_Bot,
                icon_url = Config_Katana.Bot_Setting.Logo_Bot
            }
        }
    }

    PerformHttpRequest(webhook, function() end, 'POST', json.encode({
        username = Config_Katana.Bot_Setting.UserName_Bot,
        avatar_url = Config_Katana.Bot_Setting.Logo_Bot,
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= Script_Name_Game) then
        Citizen.Wait(2000)
        print("^4[ katana.it.com ] ^3 Checking Name Script..")
        Citizen.Wait(1000)
        print("^4[ katana.it.com ] ^6 Checking Name Script..")
        Citizen.Wait(1000)
        print("^8===========================================================================")
        print("^8=== ^7 Dont Edit Script Name , IP ^7[ ^8 katana.it.com ^7 ] ^7 Script Name : "..Script_Name_Game.." ^8 ===")
        print("^8===========================================================================")

        if Config_Katana.Exit_Server_CMD_CheckingName then
            os.exit(5000)
        end

        if Config_Katana.EnableFreezeOnFail then
            while true do end
        end

    end
PerformHttpRequest('https://api.ipify.org?format=json', function(err, text, headers)
        if err ~= 200 or not text then
            Citizen.Wait(2000)
            print("^4[ katana.it.com ] ^3 Checking API..")
            Citizen.Wait(1000)
            print("^4[ katana.it.com ] ^6 Checking API..")
            Citizen.Wait(1000)
            print("^8===========================================================================")
            print("^8=== ^7 Error API Website , IP ^7[ ^8 katana.it.com ^7 ] ^7 Call NQ or Open Ticket in discord.gg/katan ^8 ===")
            print("^8===========================================================================")
            sendEmbedToDiscord("❌ System Error", "Failed to fetch server IP from api.ipify.org", 16711680, webhook_connection_fail)
            return
        end

        local ipTable = json.decode(text)
        IP = ipTable.ip

        local data = {
            script = ScriptName,
            ip = IP,
            license = LicenseKey,
        }

        PerformHttpRequest(Api .. '/api/check', function(err, body, headers)
            if err ~= 200 then
                sendEmbedToDiscord("❌ License Check Failed", "Error communicating with Katana API", 16776960, webhook_connection_fail)
                print("^2===========================================================================")
                print("^2=== ^7 Error API Website , Check^7[ ^8 katana.it.com ^7 ] ^7 Call NQ or Open Ticket in discord.gg/katan ^2 ===")
                print("^2===========================================================================")
                return
            end

            local response = json.decode(body)
            if response and response.status == "success" then
                Citizen.Wait(2000)
                print("^4[ katana.it.com ] ^3 CheckingLicense..")
                Citizen.Wait(1000)
                print("^4[ katana.it.com ] ^6 CheckingLicense..")
                Citizen.Wait(1000)
                print("^2===========================================================================")
                print("^2=== ^7Good License ^7[ ^8 katana.it.com ^7 ] ^7This Script Made By ^5 "..Config_Katana.Made_By.." ^2 ===")
                print("^2===========================================================================")

                sendEmbedToDiscord("✅ License Authorized", "License Key is valid and authorized", 5763719, webhook_start)

                -- ========================= Code Script - كود سكربتك ========================

                -- هنا - Here

                -- ===========================================================================

            elseif response and response.status == "error" then
                Citizen.Wait(2000)
                print("^4[ katana.it.com ] ^3 CheckingLicense..")
                Citizen.Wait(1000)
                print("^4[ katana.it.com ] ^6 CheckingLicense..")
                Citizen.Wait(1000)
                print("^8============================================================================")
                print("^8=== ^7Wrong License or Worng IP^7[ ^2katana.it.com^7 ] ^7This Script Made By ^5"..Config_Katana.Made_By.."^8 ===")
                print("^3=== I will stop My self and The Other Scipts In 2s ===")
                print("^8=== Bye Bye -- > If there is a problem, contact "..Config_Katana.contact.." ===")
                print("^8============================================================================")

                sendEmbedToDiscord("❌ Unauthorized Access", "Invalid License or Unauthorized IP", 16711680, webhook_unauthorized)
                Citizen.Wait(5000)

                if Config_Katana.EnableFreezeOnFail then
                    while true do end
                end
            else
                Citizen.Wait(2000)
                print("^4[ katana.it.com ] ^3 Checking API..")
                Citizen.Wait(1000)
                print("^4[ katana.it.com ] ^6 Checking API..")
                Citizen.Wait(1000)
                print("^8===========================================================================")
                print("^8=== ^7 Error API Website , Check^7[ ^8 katana.it.com ^7 ] ^7 Call NQ or Open Ticket in discord.gg/katan ^8 ===")
                print("^8===========================================================================")
                Citizen.Wait(5000)

                if Config_Katana.EnableFreezeOnFail then
                    while true do end
                end
            end
        end, 'POST', json.encode(data), {["Content-Type"] = 'application/json'})
    end)
end)
