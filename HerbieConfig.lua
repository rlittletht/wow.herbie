
local Herbie = LibStub("AceAddon-3.0"):GetAddon("Herbie")

local acr = LibStub("AceConfigRegistry-3.0")
local acd = LibStub("AceConfigDialog-3.0")

local function getHerbieProfileProfessionsOption(item)
    return Herbie.dbAce.profile.professions[item.arg]
end

local function setHerbieProfileProfessionsOption(item, val)
    Herbie.dbAce.profile.professions[item.arg] = val
end

local herbieGeneralOptions = {
    type = "group",
    get = getHerbieProfileProfessionsOption,
    set = setHerbieProfileProfessionsOption,

    childGroups = "tab",
    args={
        description = 
        {
            order = 0,
            type = "description",
            name = "Options for Herbie component helper. Use these options to control what is displayed",
        },
        filters = 
        {
            order = 1,
            type = "description",
            name = "Filters"
        },
    	general =
    	{
    		type = "group", 
    		desc = "General options for Herbie",
    		name = "General",
    		args =
    		{
    			desc = 
				{
					order = 0,
					type = "description",
					name = "General options for Herbie"
				},
    			showLeatherworking = 
    			{
    				order = 1,
    				type = "toggle",
    				name = "Leatherworking",
    				desc = "Toggle showing Leatherworking recipes",
    				width = "full",
    				arg = "fIncludeLeatherworking"
				},
    			showAlchemy = 
    			{
					order = 2,
					type = "toggle",
					name = "Alchemy",
					desc = "Toggle showing Alchemy recipes",
					width = "full",
					arg = "fIncludeAlchemy"
				},
				showCooking = 
				{
					order = 3,
					type = "toggle",
					name = "Cooking",
					desc = "Toggle showing Cooking recipes",
					width = "full",
					arg = "fIncludeCooking"
				},
				showBlacksmithing = 
				{
					order = 4,
					type = "toggle",
					name = "Blacksmithing",
					desc = "Toggle showing Blacksmithing recipes",
					width = "full",
					arg = "fIncludeBlacksmithing"
				},
				showTailoring = 
				{
					order = 5,
					type = "toggle",
					name = "Tailoring",
					desc = "Toggle showing Tailoring recipes",
					width = "full",
					arg = "fIncludeTailoring"
				},
				showEnchanting = 
				{
					order = 6,
					type = "toggle",
					name = "Enchanting",
					desc = "Toggle showing Enchanting recipes",
					width = "full",
					arg = "fIncludeEnchanting"
				},
			}
		},
        leatherWorking = 
        {
            type = "group",
            name = "Leatherworking",
            desc = "Select the leather working components to ignore",
            args =
            {
                itemList = 
                {
                    order = 1,
                    name = "ComponentsName",
                    type = "multiselect",
                    values = {"Rugged Leather", "Heavy Leather"},
                    arg = "ComponentsArg"
                }
            }
        }
    }
}

function InitializeConfig()
    acr:RegisterOptionsTable("Herbie", herbieGeneralOptions, "/herbieopt")
    Herbie.optionsPanel = acd:AddToBlizOptions("Herbie", "Herbie")
end

function debugPrintProfile(name, profile)
	print("Profile " .. name)
	print("  professions: { ")
	print(string.format("    fIncludeCooking = %s", tostring(profile.professions.fIncludeCooking)))
	print(string.format("    fIncludeAlchemy = %s", tostring(profile.professions.fIncludeAlchemy)))
	print(string.format("    fIncludeLeatherworking = %s", tostring(profile.professions.fIncludeLeatherworking)))
	print(string.format("    fIncludeBlacksmithing = %s", tostring(profile.professions.fIncludeBlacksmithing)))
	print(string.format("    fIncludeTailoring = %s", tostring(profile.professions.fIncludeTailoring)))
	print(string.format("    fIncludeEnchanting = %s", tostring(profile.professions.fIncludeEnchanting)))
	print("  }")
end

function Herbie:OnProfileChanged(db, name)
	print("OnProfileChanged: name = " .. name)
	-- db = self.db.profile
	-- filter = db.filter
	Herbie:SendMessage("HerbieConfigChanged")
end

function Herbie:ConfigChanged()
	print("in config changed")
end
