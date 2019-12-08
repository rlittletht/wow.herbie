
local Herbie = LibStub("AceAddon-3.0"):GetAddon("Herbie")
-- local GatherMate = LibStub("AceAddon-3.0"):NewAddon("GatherMate2","AceConsole-3.0","AceEvent-3.0")

_G["Herbie"] = Herbie;

-- print("db: " .. Herbie.ComponentDB)

local dbDefaults = 
{
	profile = 
	{
    	professions = 
    	{
			fIncludeCooking = true,
			fIncludeAlchemy = true,
			fIncludeLeatherworking = true,
			fIncludeBlacksmithing = true,
			fIncludeTailoring = true,
			fIncludeEnchanting = true
		},
    	LeatherworkingFilter = { },
		EnchantingFilter = { },
		CookingFilter = { },
		AlchemyFilter = { },
		TailoringFilter = { },
		BlacksmithingFilter = { },

    	excludeRecipes = {},
	},
}

SLASH_HERBIE1 = "/herbie"
SLASH_HERBIE2 = "/herbie1"
SlashCmdList["HERBIE"] = function (msg, editbox)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

    if cmd == "dump" then
    	debugPrintProfile("test", Herbie.dbAce.profile)
		print("about to call sendmessage")
		Herbie:SendMessage("HerbieConfigChanged")
	elseif cmd == "change" then
		print("changing profile...")
		Herbie.dbAce.profile.professions.fIncludeCooking = false
	elseif cmd == "options" and Herbie.optionsPanel then
		InterfaceOptionsFrame_OpenToCategory(Herbie.optionsPanel)
	end
end

function Herbie:OnInitialize()
	-- the name of the acedb in the new statement has to match the saved variable
	-- listed in Herbie.toc
	self.dbAce = LibStub("AceDB-3.0"):New("HerbieOptionsDB", dbDefaults, "Default")
	self.dbAce.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.dbAce.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.dbAce.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

	--note the use of ":" below. this is the same as self.RegisterMessage(self, ...)
	self:RegisterMessage("HerbieConfigChanged", "ConfigChanged")

    InitializeConfig()
end

local function printHerbieDB()
    print('here')
    for item,recipe in pairs(Herbie.ComponentDB)
    do
	print(item .. ": ")
		for herb,count in pairs(Herbie.ComponentDB[item])
		do
			print(herb .. ':' .. count)
		end
    end
end

-- print('Herbie ready for duty...')
-- printHerbieDB()
-- print('done...')

local function filterRecipe(recipe, component)
    local typeMatch = "fInclude" .. recipe.type

    if (Herbie.dbAce.profile.professions[typeMatch] == false) then
    	return true
    end

    -- now check to see if the professions wants this component filtered...
    -- (we do this check here because you might only want to filter a
    -- component for a certain profession, but you want to see it for
    -- another profession)

    -- the filter collection is in "*Filter" table value, where *
    -- is the profession
    local filterCollection = recipe.type .. "Filter"

	if Herbie.dbAce.profile[filterCollection] ~= nil then
    	if Herbie.dbAce.profile[filterCollection][component] ~= nil then
			return Herbie.dbAce.profile[filterCollection][component]
		end
	end

    return false
end

local function lookupHerbItems(herbLookup)
    rgItems = {}

    for item,recipe in pairs(Herbie.ComponentDB) do
    	local fMatched = false

    	if filterRecipe(recipe, herbLookup) ~= true then
			for herb,count in pairs(Herbie.ComponentDB[item].components) do
				if herb == herbLookup then
					if not(fMatched) then
						table.insert(rgItems, item)
						fMatched = true
					end
				end
			end
		end
	end

	return rgItems
end

function lookupHerbUses(herbLookup, fLong)
	local items = lookupHerbItems(herbLookup)
    local rgs = {}
    local sShort = ""
    local fShortFirst = true
    local cchAdjusted = 0

	for i, item in ipairs(items) do
		local first = true
    	local s = '|cff80ff80' .. item .. '|r: '
    	local recipe = Herbie.ComponentDB[item].components

    	if fShortFirst == false then
    		sShort = sShort .. ", "
    	else
    		fShortFirst = false
    	end

    	if (string.len(sShort) - cchAdjusted) > 20 then
    		sShort = sShort .. "\n"
    		cchAdjusted = string.len(sShort)
    	end

    	sShort = sShort .. '|cff80ff80' .. item .. '|r'
    	if fLong then
			for herb,count in pairs(recipe) do
				local prefix = ''
				if (first == false) then
					prefix = ', '
				else
					first = false
				end   
				s = s .. prefix .. herb .. '(' .. count .. ')'
			end
			table.insert(rgs, s)
   		end
	end

    if fLong == false then
		rgs = {}
		table.insert(rgs, sShort)
	end

	return rgs
end

-- local items = lookupHerbItems('Kingsblood')
-- print('matched: ' .. #items)

--local rgs = lookupHerbUses('Goldthorn')
--print('matched: ' .. #rgs)
--print(rgs[1])
--print(rgs[2])

local function EnumerateTooltipLines_helper(...)
    local rgs = {}
    for i = 1, select("#", ...) do
        local region = select(i, ...)
        if region and region:GetObjectType() == "FontString" then
            local text = region:GetText() -- string or nil
    		if text ~= nil then
    			local textClean = string.gsub(text, "|.........", "")
				textClean = string.gsub(textClean, "|.", "")
    			table.insert(rgs, textClean)
   			end
        end
    end
    return rgs
end

function EnumerateTooltipLines(tooltip) -- good for script handlers that pass the tooltip as the first argument.
	return EnumerateTooltipLines_helper(tooltip:GetRegions())
end

--meTooltip:HookScript("OnSizeChanged", function(self, w, h)
--  print('OnSizeChanged: ')
--end
--)

GameTooltip:HookScript("OnShow", function(self)
	local rgs = EnumerateTooltipLines(self)

--    if (#rgs > 0) then
--    	print('tooltip[0]=' .. rgs[1])
--		print('tooltip[0]=' .. string.byte(strsub(rgs[1], 1, 1)))
--		print('tooltip[0]=' .. strsub(rgs[1], 2))
--    	print('len(tooltip[0])=' .. strlen(rgs[1]))
--		print('tooltip[0]=' .. string.byte(strsub(rgs[1], strlen(rgs[1]) - 1)))
--		print('tooltip[0]=' .. string.byte(strsub(rgs[1], strlen(rgs[1]))))
--    end

    if #rgs == 1 or #rgs == 2 then
		local uses = lookupHerbUses(rgs[1], false)
		if #uses > 0 then
			for k,s in ipairs(uses) do
				self:AddLine(s)
			end
		end
    end
end
)

GameTooltip:HookScript("OnTooltipSetItem", function(tt)
    local itemLink = select(2, tt:GetItem())
    local itemName = select(1, tt:GetItem())

    if itemLink then
    	local rgs = lookupHerbUses(itemName, true)
    	if #rgs > 0 then
			for k,s in ipairs(rgs) do
				tt:AddLine(s)
			end
   		end
    end
end
)

