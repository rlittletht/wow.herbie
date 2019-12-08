
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
	args=
	{
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
	}
}

local function getHerbieCompFilterValue(item, val)
--	print("item: " .. tostring(Herbie.dbAce.profile[item.arg]))
--	print("val: " .. tostring(val))
--	print("item.option: " .. tostring(item.option))
--	print("item.option.values: " .. tostring(item.option.values))
--	print("item.option.values[val]: " .. tostring(item.option.values[val]))

	if (Herbie.dbAce.profile[item.arg][item.option.values[val]] == nil) then
    	return false
	end

	return Herbie.dbAce.profile[item.arg][item.option.values[val]]
end

local function setHerbieCompFilterValue(item, val)
    -- the val in this case will be an index into item.values[]
--    print("item: " .. tostring(Herbie.dbAce.profile[item.arg]))
--    print("val: " .. tostring(val))
--    print("item.option: " .. tostring(item.option))
--    print("item.option.values: " .. tostring(item.option.values))
--	print("item.option.values[val]: " .. tostring(item.option.values[val]))

	if (Herbie.dbAce.profile[item.arg][item.option.values[val]] == nil) then
		Herbie.dbAce.profile[item.arg][item.option.values[val]] = true
	else
		Herbie.dbAce.profile[item.arg][item.option.values[val]] = nil
	end
end

local herbieFilterOptions = {
    type = "group",
    get = getHerbieCompFilterValue,
    set = setHerbieCompFilterValue,

    childGroups = "tab",
    args=
	{
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
        leatherworking = 
        {
            type = "group",
            name = "Leatherworking",
            desc = "Select the leather working components to ignore",
            args =
            {
                itemList = 
                {
                    order = 1,
                    name = "Select items to ignore",
                    type = "multiselect",
                    values = {},
                    arg = "LeatherworkingFilter"
                }
            }
        },
		alchemy = 
		{
			type = "group",
			name = "Alchemy",
			desc = "Select the leather working components to ignore",
			args =
			{
				itemList = 
				{
					order = 1,
					name = "Select items to ignore",
					type = "multiselect",
					values = {},
					arg = "AlchemyFilter"
				}
			}
		},
		tailoring = 
		{
			type = "group",
			name = "Tailoring",
			desc = "Select the leather working components to ignore",
			args =
			{
				itemList = 
				{
					order = 1,
					name = "Select items to ignore",
					type = "multiselect",
					values = {},
					arg = "TailoringFilter"
				}
			}
		},
		blacksmithing = 
		{
			type = "group",
			name = "Blacksmithing",
			desc = "Select the leather working components to ignore",
			args =
			{
				itemList = 
				{
					order = 1,
					name = "Select items to ignore",
					type = "multiselect",
					values = {},
					arg = "BlacksmithingFilter"
				}
			}
		},
		enchanting = 
		{
			type = "group",
			name = "Enchanting",
			desc = "Select the leather working components to ignore",
			args =
			{
				itemList = 
				{
					order = 1,
					name = "Select items to ignore",
					type = "multiselect",
					values = {},
					arg = "EnchantingFilter"
				}
			}
		},
		cooking = 
		{
			type = "group",
			name = "Cooking",
			desc = "Select the leather working components to ignore",
			args =
			{
				itemList = 
				{
					order = 1,
					name = "Select items to ignore",
					type = "multiselect",
					values = {},
					arg = "CookingFilter"
				}
			}
		},
    }
}

local function getCompsListForType(type)
    local keys = {}
    local keysHash  = {}

    for item, recipe in pairs(Herbie.ComponentDB) do
    	if recipe.type == type and recipe.components ~= nil then
--     		print("components = " .. tostring(recipe.components))
			for comp in pairs(recipe.components) do
				if (keysHash[comp] == nil) then
					keys[#keys + 1] = comp
					keysHash[comp] = true
				end
			end
		end
	end

    return keys
end


function InitializeConfig()
    herbieFilterOptions.args.leatherworking.args.itemList.values = getCompsListForType("Leatherworking")
	herbieFilterOptions.args.alchemy.args.itemList.values = getCompsListForType("Alchemy")
	herbieFilterOptions.args.enchanting.args.itemList.values = getCompsListForType("Enchanting")
	herbieFilterOptions.args.tailoring.args.itemList.values = getCompsListForType("Tailoring")
	herbieFilterOptions.args.blacksmithing.args.itemList.values = getCompsListForType("Blacksmithing")
	herbieFilterOptions.args.cooking.args.itemList.values = getCompsListForType("Cooking")

    acr:RegisterOptionsTable("Herbie", herbieGeneralOptions, "/herbieopt")
    Herbie.optionsPanel = acd:AddToBlizOptions("Herbie", "Herbie")

	acr:RegisterOptionsTable("Herbie/Filters", herbieFilterOptions, "/herbieopt")
	acd:AddToBlizOptions("Herbie/Filters", "Filters", "Herbie")
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
