
local function printHerbieDB()
    print('here')
    for item,recipe in pairs(HerbieDB)
    do
	print(item .. ": ")
		for herb,count in pairs(HerbieDB[item])
		do
			print(herb .. ':' .. count)
		end
    end
end

-- print('Herbie ready for duty...')
-- printHerbieDB()
-- print('done...')

local function lookupHerbItems(herbLookup)
    rgItems = {}

    for item,recipe in pairs(HerbieDB) do
    	local fMatched = false
		for herb,count in pairs(HerbieDB[item]) do
    		if herb == herbLookup then
				if not(fMatched) then
					table.insert(rgItems, item)
					fMatched = true
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
    	local recipe = HerbieDB[item]

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

