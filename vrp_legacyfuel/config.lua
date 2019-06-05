Config = {}

Config.EnableBlips				= true
Config.VehicleFailure			= 2 -- At what fuel-percentage should the engine stop functioning properly? (Defualt: 10)
Config.FuelPrice                = 3
Config.Usage                    = 0.75
Config.EnableJerryCans			= true
Config.EnableBuyableJerryCans	= true
Config.JerryCanPrice	        = 100*Config.FuelPrice

Config.SpecialUsage = {
    -- ["Model"] = Usage
    -- ["adder"] = 3
}