local Config = {
    apikey = "", -- https://www.weatherapi.com/signup.aspx generate an api key and place it here
    city = "Tasmania",
    refreshTime = 10 * 60000, -- (10 * 60000) 10 minutes default 
}

local weatherType, windSpeed, windDirection

if Config.apikey == "" or Config.apikey == nil then
	NotifyError()
end

function NotifyError()
	print("You need a API key entered into the server config")
	Citizen.Wait(1000)
	NotifyError() -- Loops Error
end

local apiString = "http://api.weatherapi.com/v1/current.json?key=" .. Config.apikey .. "&q=" .. Config.city

Citizen.CreateThread(function()
    while true do
    syncWeather()
    syncTime()
    Citizen.Wait(Config.refreshTime)
    end
end)

RegisterNetEvent('trp:core:syncWeather', function()
    TriggerClientEvent('trp:core:syncWeather', source, windSpeed, windDirection, weatherType)
end)

RegisterNetEvent('trp:core:syncTime', function()
    local h, m, s = tonumber(os.date("%H")), tonumber(os.date("%M")), tonumber(os.date("%S"))
    local OSDATE = os.date('%Y-%m-%d %H:%M:%S')
	TriggerClientEvent("trp:core:syncTime", source, "ChangeTime", h, m, s)
    print('-- TRP TIMEWEATHER SYNC --')
    print(OSDATE) 
end)

function syncWeather()
    PerformHttpRequest(apiString, function (errorCode, resultData, resultHeaders)
	if weatherType == nil or weatherType == "" then print("Unable to Sync Weather Something went wrong") return end
        weatherType = json.decode(resultData).current.condition.code
        windSpeed = json.decode(resultData).current.wind_mph
        windDirection = json.decode(resultData).current.wind_degree
        TriggerClientEvent('trp:core:syncWeather', -1, windSpeed, windDirection, weatherType)
    end)
end

function syncTime()
    local h, m, s = tonumber(os.date("%H")), tonumber(os.date("%M")), tonumber(os.date("%S"))
    local OSDATE = os.date('%Y-%m-%d %H:%M:%S')
	TriggerClientEvent("trp:TimeSync", -1, "ChangeTime", h, m, s)
    print('-- TRP TIMEWEATHER SYNC --')
    print(OSDATE) 
end
