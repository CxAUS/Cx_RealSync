local windSpeed, windDirection, weatherType, rain
local lastWeather = "OVERCAST"

local weatherTypes = {
 [1000] = {
     type = "CLEAR",
     rain = -1,
 },

 [1003] = {
    type = "CLOUDS",
    rain = -1,
 },

 [1006] = {
    type = "CLOUDS",
    rain = -1,
 },

 [1009] = {
   type = "CLOUDS",
   rain = -1,
},
 [1030] = {
    type = "FOGGY",
    rain = -1,
 },

 [1063] = {
    type = "OVERCAST",
    rain = -1,
 },

 [1066] = {
    type = "OVERCAST",
    rain = -1,
 },

 [1069] = {
    type = "OVERCAST",
    rain = -1,
 },

 [1072] = {
    type = "OVERCAST",
    rain = -1,
 },

 [1087] = {
    type = "OVERCAST",
    rain = 1.0,
 },

 [1114] = {
    type = "OVERCAST",
    rain = -1,
 },

 [1117] = {
    type = "BLIZZARD",
    rain = -1,
 },

 [1135] = {
    type = "FOGGY",
    rain = -1,
 },

 [1147] = {
    type = "FOGGY",
    rain = -1,
 },

 [1150] = {
    type = "FOGGY",
    rain = -1,
 },

 [1150] = {
    type = "RAIN",
    rain = 0.2,
 },

 [1153] = {
    type = "RAIN",
    rain = 0.3,
 },

 [1168] = {
    type = "RAIN",
    rain = 0.4,
 },

 [1171] = {
    type = "RAIN",
    rain = 0.4,
 },

 [1180] = {
    type = "RAIN",
    rain = 0.5,
 },

 [1183] = {
    type = "RAIN",
    rain = 0.5,
 },

 [1186] = {
    type = "RAIN",
    rain = 0.6,
 },

 [1189] = {
    type = "RAIN",
    rain = 0.6,
 },

 [1192] = {
    type = "RAIN",
    rain = 0.8,
 },

 [1195] = {
    type = "THUNDER",
    rain = 0.8,
 },

 [1198] = {
    type = "THUNDER",
    rain = 0.9,
 },

 [1201] = {
    type = "THUNDER",
    rain = 0.9,
 },

 [1204] = {
    type = "SNOWLIGHT",
    rain = 0.2,
 },

 [1207] = {
    type = "SNOWLIGHT",
    rain = 1.0,
 },

 [1210] = {
    type = "SNOWLIGHT",
    rain = -1,
 },

 [1213] = {
    type = "SNOWLIGHT",
    rain = -1,
 },

 [1216] = {
    type = "SNOWLIGHT",
    rain = -1,
 },

 [1219] = {
    type = "XMAS",
    rain = -1,
 },

 [1222] = {
    type = "XMAS",
    rain = -1,
 },

 [1225] = {
    type = "XMAS",
    rain = -1,
 },

 [1237] = {
    type = "XMAS",
    rain = -1,
 },

 [1240] = {
    type = "RAIN",
    rain = -1,
 },

 [1243] = {
    type = "THUNDER",
    rain = 1.0,
 },

 [1246] = {
    type = "THUNDER",
    rain = 1.0,
 },

 [1249] = {
    type = "SNOWLIGHT",
    rain = 0.3,
 },

 [1252] = {
    type = "SNOWLIGHT",
    rain = 1.0,
 },

 [1255] = {
    type = "SNOWLIGHT",
    rain = -1,
 },

 [1258] = {
    type = "XMAS",
    rain = -1,
 },

 [1261] = {
    type = "XMAS",
    rain = -1,
 },

 [1264] = {
    type = "XMAS",
    rain = -1,
 },

 [1273] = {
    type = "THUNDER",
    rain = 0.7,
 },

 [1276] = {
    type = "THUNDER",
    rain = 1.0,
 },

 [1279] = {
    type = "THUNDER",
    rain = 0.5,
 },

 [1282] = {
    type = "XMAS",
    rain = -1,
 },

}



RegisterNetEvent('trp:core:syncWeather')
AddEventHandler('trp:core:syncWeather', function(windSpeedd, windDirectionn, weatherTypee)
windSpeed = windSpeedd
windDirection = windDirectionn
print(weatherTypee)
weatherType = weatherTypes[weatherTypee].type
rain = weatherTypes[weatherTypee].rain
end)


Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        if lastWeather ~= weatherType then
            lastWeather = weatherType
            SetWeatherTypeOverTime(weatherType, 15.0)
            SetRainLevel(rain)
            Citizen.Wait(15000)
        end
        Citizen.Wait(100)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)
        if windSpeed and weatherType ~= nil then
            if windSpeed > 0.0 then
                SetWindSpeed(windSpeed)
                SetWindDirection(windDirection)
            else
                SetWindDirection(0.0)
                SetWindSpeed(0.0)
            end
            if weatherType == 'XMAS' then
                SetForceVehicleTrails(true)
                SetForcePedFootstepsTracks(true)
            else
                SetForceVehicleTrails(false)
                SetForcePedFootstepsTracks(false)
            end
        end
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('trp:core:syncWeather')
    TriggerServerEvent('trp:core:syncTime') -- Force States Time to SV TIME
end)

RegisterNetEvent("trp:core:syncTime")
local clientrender = false
local tickcount = 0
local servertime = {h = 0, m = 0, s = 0}
Citizen.CreateThread(function()
	Wait(250)
	while true do
		Wait(33)
		if clientrender == true then
			local tick = GetGameTimer()
			if tickcount <= tick then
				local y, m, d, h, M, s = GetLocalTime()
				servertime = {h = h, m = M, s = s}
				tickcount = tick+1500
			end
		end
		NetworkOverrideClockTime(servertime.h, servertime.m, servertime.s)
	end
end)

AddEventHandler("trp:core:syncTime", function(thefunction, ...)
	local args = {...}
	if thefunction == "ChangeTime" then
		if clientrender == false then
			servertime = {h = args[1], m = args[2], s = args[3]}
		end
	end
	if thefunction == "ClientServer" then
		clientrender = args[1]
	end
end)