----- WhatsYourCovenant Version Changes -----
--- v1.4.1
-- Implemented support for saving's a pandaren's covenant to the personal database.
--- v1.4.0
-- Updated interface version to 90100.
--- v1.3.1
-- Fixed an issue with the version upgrade code which meant no colours existed.
--- v1.3.0
-- Added covenant colour selection in the options menu.
-- Implemented a better version check (converts the version to a single int).
--- v1.2.3
-- Fixed some Russian translations.
--- v1.2.2
-- Updated interface version from 90002 to 90005.
-- Fixed some Russian translations.
-- Changed the Night Fae colour from ff2b3ae3 to ff237dff (a lighter, dark blue).
-- Correctly aligned the options in the interface options menu.
--- v1.2.1
-- Fixed the colouring of covenants when using non-English languages.
-- Implemented localisation using Google translate.
--- v1.2.0
-- Exposed GetCovenantId(realm, name) and GetCovenantName(realm, name) to the public interface.
--- v1.1.1
-- Fixed the personal database so realm names with spaces and hyphens are correctly saved.
--- v1.1.0
-- Implemented the personal database.
-- Implemented basic version conversion when the addon is loaded.
--- v1.0.0
-- Initial release.
---------------------------------------------

local addonName, addonData = ...

local LocStr = addonData.LocStr

local CovenantDb = {}

local regions = {
	"Americas",
	"Korea",
	"Europe",
	"Taiwan",
	"China",
}

local covenantSpells = {
	-- Kyrian
	[324739] = 1,	-- (General)		Summon Steward
	[312202] = 1,	-- (Death Knight)	Shackle the Unworthy
	[306830] = 1,	-- (Demon Hunter)	Elysian Decree
	[326434] = 1,	-- (Druid)			Kindred Spirits
	[308491] = 1,	-- (Hunter)			Resonating Arrow
	[307443] = 1,	-- (Mage)			Radiant Spark
	[310454] = 1,	-- (Monk)			Weapons of Order
	[304971] = 1,	-- (Paladin)		Divine Toll
	[325013] = 1,	-- (Priest)			Boon of the Ascended
	[323547] = 1,	-- (Rogue)			Echoing Reprimand
	[324386] = 1,	-- (Shaman)			Vesper Totem
	[312321] = 1,	-- (Warlock)		Scouring Tithe
	[307865] = 1,	-- (Warrior)		Spear of Bastion
	
	-- Venthyr
	[300728] = 2,	-- (General)		Door of Shadows
	[311648] = 2,	-- (Death Knight)	Swarming Mist
	[317009] = 2,	-- (Demon Hunter)	Sinful Brand
	[323546] = 2,	-- (Druid)			Ravenous Frenzy
	[324149] = 2,	-- (Hunter)			Flayed Shot
	[314793] = 2,	-- (Mage)			Mirrors of Torment
	[326860] = 2,	-- (Monk)			Fallen Order
	[316958] = 2,	-- (Paladin)		Ashen Hollow
	[323673] = 2,	-- (Priest)			Mindgames
	[323654] = 2,	-- (Rogue)			Flagellation
	[320674] = 2,	-- (Shaman)			Chain Harvest
	[321792] = 2,	-- (Warlock)		Impending Catastrophe
	[317349] = 2,	-- (Warrior)		Condemn
	
	-- Night Fae
	[310143] = 3,	-- (General)		Soulshape
	[324701] = 3,	-- (General)		Flicker
	[324128] = 3,	-- (Death Knight)	Death's Due
	[323639] = 3,	-- (Demon Hunter)	The Hunt
	[323764] = 3,	-- (Druid)			Convoke the Spirits
	[328231] = 3,	-- (Hunter)			Wild Spirits
	[314791] = 3,	-- (Mage)			Shifting Power
	[327104] = 3,	-- (Monk)			Faeline Stomp
	[328278] = 3,	-- (Paladin)		Blessing of the Seasons
	[328282] = 3,	-- (Paladin)		Blessing of Spring
	[328620] = 3,	-- (Paladin)		Blessing of Summer
	[328622] = 3,	-- (Paladin)		Blessing of Autumn
	[328281] = 3,	-- (Paladin)		Blessing of Winter
	[327661] = 3,	-- (Priest)			Fae Guardians
	[328305] = 3,	-- (Rogue)			Sepsis
	[328923] = 3,	-- (Shaman)			Fae Transfusion
	[325640] = 3,	-- (Warlock)		Soul Rot
	[325886] = 3,	-- (Warrior)		Ancient Aftershock
	
	-- Necrolord
	[324631] = 4,	-- (General)		Fleshcraft
	[315443] = 4,	-- (Death Knight)	Abomination Limb
	[329554] = 4,	-- (Demon Hunter)	Fodder to the Flame
	[325727] = 4,	-- (Druid)			Adaptive Swarm
	[325028] = 4,	-- (Hunter)			Death Chakram
	[324220] = 4,	-- (Mage)			Deathborne
	[325216] = 4,	-- (Monk)			Bonedust Brew
	[328204] = 4,	-- (Paladin)		Vanquisher's Hammer
	[324724] = 4,	-- (Priest)			Unholy Aura
	[328547] = 4,	-- (Rogue)			Serrated Bone Spike
	[326059] = 4,	-- (Shaman)			Primordial Wave
	[325289] = 4,	-- (Warlock)		Decimating Bolt
	[324143] = 4,	-- (Warrior)		Conqueror's Banner
}

-- NOTE: Pandaren's faction can't be determined by their race alone, so they will be ignored.
local factionByRace = {
	["Human"]				= "Alliance",
	["Dwarf"]				= "Alliance",
	["NightElf"]			= "Alliance",
	["Gnome"]				= "Alliance",
	["Draenei"]				= "Alliance",
	["Worgen"]				= "Alliance",
	["VoidElf"]				= "Alliance",
	["LightforgedDraenei"]	= "Alliance",
	["KulTiran"]			= "Alliance",
	["DarkIronDwarf"]		= "Alliance",
	["Mechagnome"]			= "Alliance",
	
	["Orc"]					= "Horde",
	["Scourge"]				= "Horde",
	["Tauren"]				= "Horde",
	["Troll"]				= "Horde",
	["Goblin"]				= "Horde",
	["BloodElf"]			= "Horde",
	["Nightborne"]			= "Horde",
	["HighmountainTauren"]	= "Horde",
	["ZandalariTroll"]		= "Horde",
	["Vulpera"]				= "Horde",
	["MagharOrc"]			= "Horde",
}

local playerRegion = regions[GetCurrentRegion()]
local playerFaction = select(1, UnitFactionGroup("player"))
local function GetOpposingFaction()
	if (playerFaction == "Horde") then
		return "Alliance"
	else
		return "Horde"
	end
end


local function SetCovenantColourDefaults()
	WhatsYourCovenantConfig.usability_CovenantColours[1] = "ff2bd9f0"	-- Kyrian
	WhatsYourCovenantConfig.usability_CovenantColours[2] = "ffde1b14"	-- Venthyr
	WhatsYourCovenantConfig.usability_CovenantColours[3] = "ff237dff"	-- Night Fae
	WhatsYourCovenantConfig.usability_CovenantColours[4] = "ff2bb557"	-- Necrolord
end

local function GetCovenantColour(covenantId)
	return WhatsYourCovenantConfig.usability_CovenantColours[covenantId]
end

local function GetCovenantColourRGBA(covenantId)
	local h = WhatsYourCovenantConfig.usability_CovenantColours[covenantId]
	local a, r, g, b = tonumber(h:sub(0, 2), 16), tonumber(h:sub(3, 4), 16), tonumber(h:sub(5, 6), 16), tonumber(h:sub(7, 8), 16)
	return r / 255, g / 255, b / 255, a / 255
end

local function SaveCovenantColourRGBA(covenantId, r, g, b, a)
	local hex = {
		[1] = tostring(string.format("%x", a * 255)),
		[2] = tostring(string.format("%x", r * 255)),
		[3] = tostring(string.format("%x", g * 255)),
		[4] = tostring(string.format("%x", b * 255)),
	}
	local res = ""
	for i=1, 4 do
		if (string.len(hex[i]) == 1) then
			res = res.. "0"
		end
		res = res.. hex[i]
	end
	WhatsYourCovenantConfig.usability_CovenantColours[covenantId] = res
end

local function ConvertVersionStrToInt(versionStr)
	local split = {}
	local idx = 1
	
	while versionStr ~= "" do
		local i = string.find(versionStr, ".")
		split[idx] = versionStr:sub(0, i)
		idx = idx + 1
		versionStr = versionStr:sub(i + 2)
	end
	
	if (split == nil or split[1] == nil or split[2] == nil or split[3] == nil) then
		print("Couldn't split version string.")
		return -1
	end
	
	local version = (split[1] * 1000000) + (split[2] * 1000) + split[3]
	return version
end

-- Attempt to convert the realm name to the realm slug.
-- This isn't fool-proof as some slugs aren't derived from their full name.
local function ConvertRealmToSlug(r)
	if (r == nil) then
		return nil
	end
	
	-- Remove spaces.
	r = r:gsub(" ", "")
	
	-- Remove hypens.
	r = r:gsub("-", "")
	
	return r
end

local function AddPlayerToPersonalDatabase(faction, realm, player, covenant)
	if (not WhatsYourCovenantConfig.database_GeneratePersonal) then
		return
	end
	
	realm = ConvertRealmToSlug(realm)
	
	for k,v in pairs(WhatsYourCovenantData.PersonalCovenantDb) do
		if (v.faction == faction) then
			if (v[realm] == nil) then
				v[realm] = {}
			end
			
			v[realm][player] = {
				covenant = covenant,
				lastUpdateAt = GetServerTime(),
			}
		end
	end
end

local function GetCovenantIdFromPersonal(realm, player)
	if (not WhatsYourCovenantConfig.database_GeneratePersonal) then
		return nil, nil
	end
	
	realm = ConvertRealmToSlug(realm)
	
	for k,v in pairs(WhatsYourCovenantData.PersonalCovenantDb) do
		if (v.faction == playerFaction or WhatsYourCovenantConfig.database_BothFactions) then
			if (v[realm] ~= nil) then
				if (v[realm][player] ~= nil) then
					return v[realm][player].covenant, v[realm][player].lastUpdateAt
				end
			end
		end
	end
	
	return nil, nil
end

local function GetCovenantId(realm, player)
	realm = ConvertRealmToSlug(realm)
	
	-- Search the personal database first.
	local idFromPersonalDb, updateTimeFromPersonalDb = GetCovenantIdFromPersonal(realm, player)
	
	-- Based on the player's region and faction, fing the relevant database entry.
	for k,v in pairs(CovenantDb) do
		if (v.region == playerRegion) then
			if (v.faction == playerFaction or WhatsYourCovenantConfig.database_BothFactions) then
				if (v[realm] ~= nil) then
					if (v[realm][player] ~= nil) then
						if (idFromPersonalDb == nil or updateTimeFromPersonalDb == nil or v.lastUpdateAt > updateTimeFromPersonalDb) then
							return v[realm][player], v.lastUpdateAt, false
						end
						break
					end
				end
			end
		end
		
		--if (v.region == playerRegion and v.faction ~= playerFaction) then
		--	if (v[realm] ~= nil) then
		--		return v[realm][player]
		--	else
		--		--print("WhatsYourCovenant contains no data for realm " ..realm)
		--	end
		--end
	end
	
	if (idFromPersonalDb ~= nil and updateTimeFromPersonalDb ~= nil) then
		return idFromPersonalDb, updateTimeFromPersonalDb, true
	end
	
	return nil, nil, nil
end

local function GetCovenantName(realm, player)
	local covenantId = GetCovenantId(realm, player)
	if (covenantId ~= nil and covenantId ~= -1) then
		local name = C_Covenants.GetCovenantData(covenantId).name
		local colour = nil
		-- As a bonus, let's try to colourise it.
		if (GetCovenantColour(covenantId) ~= nil and WhatsYourCovenantConfig.usability_Colourise) then
			colour = GetCovenantColour(covenantId)
		end
		
		return name, colour
	end
	
	return nil, nil
end

local function SetDatabase(data)
	table.insert(CovenantDb, data)
end


do

    local pristine = {
        AddDatabase = function(...)
            return SetDatabase(...)
        end,
		
		GetCovenantId = function(...)
			return GetCovenantId(...)
		end,
		
		GetCovenantName = function(...)
			return GetCovenantName(...)
		end,
    }

    local private = {
        AddDatabase = function(...)
            return pristine.AddDatabase(...)
        end,
		
		GetCovenantId = function(...)
			return pristine.GetCovenantId(...)
		end,
		
		GetCovenantName = function(...)
			return pristine.GetCovenantName(...)
		end,
	}

    _G.WhatsYourCovenant = setmetatable({}, {
        __metatable = false,
        __newindex = function()
        end,
        __index = function(self, key)
            return private[key]
        end,
        __call = function(self, key, ...)
            local func = pristine[key]
            if not func then
                return
            end
            return func(...)
        end
    })

end


-- Useful debugging command.
--/run for i=1,GameTooltip:NumLines()do local mytext=_G["GameTooltipTextLeft"..i] local text=mytext:GetText()print("GameTooltipTextLeft"..i)print(text)end

local function OnGameTooltipSetUnit(tooltip)
	if (not WhatsYourCovenantConfig.unitTooltip_Display) then
		return
	end
	
	local unit = select(2, tooltip:GetUnit())
	if not unit then
		return
	end
	
	-- Get the unit's name and realm.
	local name, realm = UnitName(unit)
	if (name == nil) then
		return
	end
	
	-- If the realm is nil then it should match the player's.
	if (realm == nil) then
		realm = GetRealmName()
	end
	
	-- Do we have the unit's covenant in our database?
	local covenantId = GetCovenantId(realm, name)
	if (covenantId == nil or covenantId == -1) then
		return
	end
	
	-- Convert the covenant ID to the name.
	local covenant = C_Covenants.GetCovenantData(covenantId).name
	
	-- As a bonus, let's try to colourise it.
	if (GetCovenantColour(covenantId) ~= nil and WhatsYourCovenantConfig.usability_Colourise) then
		covenant = "|c" ..GetCovenantColour(covenantId)..covenant.. "|r"
	end
	
	GameTooltip:AddDoubleLine(LocStr(nil, "Covenant: %s", covenant))
	GameTooltip:Show()
end
GameTooltip:HookScript("OnTooltipSetUnit", OnGameTooltipSetUnit)

local function OnShowGameTooltip(tooltip)
	if (not WhatsYourCovenantConfig.contextualTooltip_Display) then
		return
	end
	
	local unit = select(2, tooltip:GetUnit())
	if unit then
		-- If it has a unit then our OnGameTooltipSetUnit(...) event will handle it.
		return
	end
	
	--print(GameTooltip:NumLines())
	if (GameTooltip:NumLines() == 1) then
		local text = _G["GameTooltipTextLeft1"]
		if (text ~= nil) then
			local name = text:GetText()
			if (not string.match(name, " ")) then
				local idx = string.find(name, '-')
				local realm = GetRealmName()
				if (idx ~= nil) then
					realm = name:sub(idx+1)
					name = name:sub(0, idx-1)
				end
				
				--print("Found : " ..name.. " - " ..realm)
				local covenantId = GetCovenantId(realm, name)
				if (covenantId ~= nil and covenantId ~= -1) then
					local covenant = C_Covenants.GetCovenantData(covenantId).name
					
					-- As a bonus, let's try to colourise it.
					if (GetCovenantColour(covenantId) ~= nil and WhatsYourCovenantConfig.usability_Colourise) then
						covenant = "|c" ..GetCovenantColour(covenantId)..covenant.. "|r"
					end
					
					GameTooltip:AddDoubleLine(LocStr(nil, "Covenant: %s", covenant))
					GameTooltip:Show()
				end
			end
			
			-- THIS DOESN'T WORK!
			-- Apparently the level, class, and ilvl are added after the tooltip is shown.
			--local name =_G["GameTooltipTextLeft1"]:GetText()
			--local level =_G["GameTooltipTextLeft2"]:GetText()
			--local ilvl =_G["GameTooltipTextLeft3"]:GetText()
			--print(level:sub(0, 6))
			--print(ilvl:sub(0, 12))
			--if (level:sub(0, 6) == "Level " and
			--	ilvl:sub(0, 12) == "Item Level: ") then
			--	print(name)
			--end
		end
	end
	--print("OnShow")
end
GameTooltip:HookScript("OnShow", OnShowGameTooltip)


local function OnCombatLogEventUnfiltered(...)
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
	-- Is this a spell cast event?
	if (subevent == "SPELL_CAST_SUCCESS") then
		-- Is sourceGUID a player?
		if (#sourceGUID >= 6 and sourceGUID:sub(0, 6) == "Player") then
			-- Is spell cast one of the spells of interest?
			local spellId = select(12, ...)
			if (covenantSpells[spellId] ~= nil) then
				-- Get basic information about the player.
				local _, _, _, race, _, name, realm = GetPlayerInfoByGUID(sourceGUID)
				if (realm == "" or realm == nil) then
					realm = GetRealmName()
				end
				
				-- Attempt to get the player's faction. There are no API functions that will give
				-- us the faction based on a GUID so we need to reason based on their race. There
				-- is potential that this could be tricked by toys/effects that change your race
				-- (though I don't know if it affects this).
				local covenantSpell = covenantSpells[spellId]
				local faction = factionByRace[race]
				if (faction ~= nil) then
					AddPlayerToPersonalDatabase(faction, realm, name, covenantSpell)
				elseif (race == "Pandaren") then
					-- If they're pandaren then we can't determine their faction purely by knowing
					-- their race because pandaren start off as neutral and choose later.
					-- We can make a reasonable estimate as to what faction they are based on a few
					-- flags however THIS CAN STILL BE TRICKED so isn't fool-proof.
					if (bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0) then
						if (bit.band(sourceFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) > 0) then
							-- If they're in our group then they must be our faction.
							if (bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 or
								bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) > 0 or
								bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) > 0) then
								--print(sourceName.. " is a FRIENDLY pandaren (in our group): " ..playerFaction)
								AddPlayerToPersonalDatabase(playerFaction, realm, name, covenantSpell)
							elseif (bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) > 0) then
								--print(sourceName.. " is a FRIENDLY pandaren: " ..playerFaction)
								AddPlayerToPersonalDatabase(playerFaction, realm, name, covenantSpell)
							elseif (bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0) then
								--print(sourceName.. " is a HOSTILE pandaren: " ..GetOpposingFaction())
								AddPlayerToPersonalDatabase(GetOpposingFaction(), realm, name, covenantSpell)
							end
						end
					end
				end
			end
		end
	end
end



local function WhatsYourCovenant_SlashCommand(msg, editbox)
	--for k,v in pairs(CovenantDb) do
	--	print(v.lastUpdateAt)
	--end
	--print("|c" ..covenantColour["Kyrian"].. "Kyrian|r")
	--print("|c" ..covenantColour["Necrolord"].. "Necrolord|r")
	--print("|c" ..covenantColour["NightFae"].. "NightFae|r")
	--print("|c" ..covenantColour["Venthyr"].. "Venthyr|r")
	--if (msg:sub(0,8) == "covenant") then
	--end
end

local function WhatsYourCovenant_OnPlayerLogin()
	local prevVersionStr = nil
	if (WhatsYourCovenantConfig ~= nil) then
		prevVersionStr = WhatsYourCovenantConfig.version
	end
	if (prevVersionStr == nil) then
		-- Reset to defaults if we have no saved config.
		WhatsYourCovenant_ResetConfig()
		return
	end
	
	-- Convert the previous version to an integer so it's easier to compare.
	local prevVersion = ConvertVersionStrToInt(prevVersionStr)
	if (prevVersion == -1) then
		-- Early-out if we couldn't convert the version.
		-- It's better to exit now than to screw the user's config settings.
		print("Can't determine WhatsYourCovenant version: ".. tostring(prevVersionStr))
		return
	end
	
	-- Update the version number.
	local versionStr = GetAddOnMetadata("WhatsYourCovenant", "Version")
	WhatsYourCovenantConfig.version = versionStr
	
	-- If the stored version is not current then update it step-by-step.
	if (prevVersion < ConvertVersionStrToInt("1.1.0")) then
		WhatsYourCovenantConfig.database_GeneratePersonal = true
	end
	if (prevVersion < ConvertVersionStrToInt("1.3.1")) then
		WhatsYourCovenantConfig.usability_CovenantColours = {}
		SetCovenantColourDefaults()
	end
end

local function WhatsYourCovenant_ResetConfig()
	WhatsYourCovenantConfig = {
		version = GetAddOnMetadata("WhatsYourCovenant", "Version"),
		
		unitTooltip_Display = true,
		
		contextualTooltip_Display = true,
		
		database_BothFactions = true,
		database_GeneratePersonal = true,
		
		usability_Colourise = true,
		usability_CovenantColours = {},
	}
	SetCovenantColourDefaults()
end
-- Ensure we create a default config on first load.
if (WhatsYourCovenantConfig == nil) then
	WhatsYourCovenantConfig = {}
	WhatsYourCovenant_ResetConfig()
end
if (WhatsYourCovenantData == nil) then
	WhatsYourCovenantData = {
		PersonalCovenantDb = {
			{ faction = "Horde" },
			{ faction = "Alliance" },
		},
	}
end

local function WhatsYourCovenant_SetCheckButtonState()
	WhatsYourCovenant_UnitTooltipDisplay:SetChecked(WhatsYourCovenantConfig.unitTooltip_Display)
	WhatsYourCovenant_ContextualTooltipDisplay:SetChecked(WhatsYourCovenantConfig.contextualTooltip_Display)
	WhatsYourCovenant_DatabaseBothFactions:SetChecked(WhatsYourCovenantConfig.database_BothFactions)
	WhatsYourCovenant_DatabaseGeneratePersonal:SetChecked(WhatsYourCovenantConfig.database_GeneratePersonal)
	WhatsYourCovenant_UsabilityColourise:SetChecked(WhatsYourCovenantConfig.usability_Colourise)
end

local function InitInterfaceOptions()
	-- Create main frame for information text
	local options = CreateFrame("FRAME", "WhatsYourCovenantOptions")
	options.name = GetAddOnMetadata("WhatsYourCovenant", "Title")
	options.default = function (self) WhatsYourCovenant_ResetConfig() end
	options.refresh = function (self) WhatsYourCovenant_SetCheckButtonState() end
	InterfaceOptions_AddCategory(options)
	
	local optionsTitle = options:CreateFontString(nil, "ARTWORK")
	optionsTitle:SetFontObject(GameFontNormalLarge)
	optionsTitle:SetJustifyH("LEFT") 
	optionsTitle:SetJustifyV("TOP")
	optionsTitle:ClearAllPoints()
	optionsTitle:SetPoint("TOPLEFT", 16, -16)
	optionsTitle:SetText("WhatsYourCovenant v"..GetAddOnMetadata("WhatsYourCovenant", "Version"))
	
	local currentOffsetX = 0
	local offsetX = 2
	local subtitleOffsetY = -6
	local optionOffsetY = -4
	
	------------------------------
	-- Unit Tooltip
	currentOffsetX = -offsetX
	local optionsUnitTooltipTitle = options:CreateFontString(nil, "ARTWORK")
	optionsUnitTooltipTitle:SetFontObject(GameFontWhite)
	optionsUnitTooltipTitle:SetJustifyH("LEFT") 
	optionsUnitTooltipTitle:SetJustifyV("TOP")
	optionsUnitTooltipTitle:ClearAllPoints()
	optionsUnitTooltipTitle:SetPoint("TOPLEFT", optionsTitle, "BOTTOMLEFT", currentOffsetX, subtitleOffsetY)
	optionsUnitTooltipTitle:SetText(LocStr(nil, "Unit Tooltip"))
	currentOffsetX = offsetX
	
	local optionsUnitTooltipDisplay = CreateFrame("CheckButton", "WhatsYourCovenant_UnitTooltipDisplay", options, "OptionsCheckButtonTemplate")
	optionsUnitTooltipDisplay:SetPoint("TOPLEFT", optionsUnitTooltipTitle, "BOTTOMLEFT", currentOffsetX, optionOffsetY)
	optionsUnitTooltipDisplay:SetScript("OnClick", function(self) WhatsYourCovenantConfig.unitTooltip_Display = not WhatsYourCovenantConfig.unitTooltip_Display end)
	WhatsYourCovenant_UnitTooltipDisplayText:SetText(LocStr(nil, "Show Covenant in unit's mouseover tooltip"))
	currentOffsetX = 0
	
	------------------------------
	-- Contextual Tooltip
	currentOffsetX = -offsetX
	local optionsContextualTooltipTitle = options:CreateFontString(nil, "ARTWORK")
	optionsContextualTooltipTitle:SetFontObject(GameFontWhite)
	optionsContextualTooltipTitle:SetJustifyH("LEFT") 
	optionsContextualTooltipTitle:SetJustifyV("TOP")
	optionsContextualTooltipTitle:ClearAllPoints()
	optionsContextualTooltipTitle:SetPoint("TOPLEFT", optionsUnitTooltipDisplay, "BOTTOMLEFT", currentOffsetX, subtitleOffsetY)
	optionsContextualTooltipTitle:SetText(LocStr(nil, "Contextual Tooltip (world map, groupfinder, etc.)"))
	currentOffsetX = offsetX
	
	local optionsContextualTooltipDisplay = CreateFrame("CheckButton", "WhatsYourCovenant_ContextualTooltipDisplay", options, "OptionsCheckButtonTemplate")
	optionsContextualTooltipDisplay:SetPoint("TOPLEFT", optionsContextualTooltipTitle, "BOTTOMLEFT", currentOffsetX, optionOffsetY)
	optionsContextualTooltipDisplay:SetScript("OnClick", function(self) WhatsYourCovenantConfig.contextualTooltip_Display = not WhatsYourCovenantConfig.contextualTooltip_Display end)
	WhatsYourCovenant_ContextualTooltipDisplayText:SetText(LocStr(nil, "Show Covenant in contextual tooltip"))
	currentOffsetX = 0
	
	------------------------------
	-- Database
	currentOffsetX = -offsetX
	local optionsDatabaseTitle = options:CreateFontString(nil, "ARTWORK")
	optionsDatabaseTitle:SetFontObject(GameFontWhite)
	optionsDatabaseTitle:SetJustifyH("LEFT") 
	optionsDatabaseTitle:SetJustifyV("TOP")
	optionsDatabaseTitle:ClearAllPoints()
	optionsDatabaseTitle:SetPoint("TOPLEFT", optionsContextualTooltipDisplay, "BOTTOMLEFT", currentOffsetX, subtitleOffsetY)
	optionsDatabaseTitle:SetText(LocStr(nil, "Database"))
	currentOffsetX = offsetX
	
	local optionsDatabaseBothFactions = CreateFrame("CheckButton", "WhatsYourCovenant_DatabaseBothFactions", options, "OptionsCheckButtonTemplate")
	optionsDatabaseBothFactions:SetPoint("TOPLEFT", optionsDatabaseTitle, "BOTTOMLEFT", currentOffsetX, optionOffsetY)
	optionsDatabaseBothFactions:SetScript("OnClick", function(self) WhatsYourCovenantConfig.database_BothFactions = not WhatsYourCovenantConfig.database_BothFactions end)
	WhatsYourCovenant_DatabaseBothFactionsText:SetText(LocStr(nil, "View opposing faction's Covenant"))
	currentOffsetX = 0
	
	local optionsDatabaseGeneratePersonal = CreateFrame("CheckButton", "WhatsYourCovenant_DatabaseGeneratePersonal", options, "OptionsCheckButtonTemplate")
	optionsDatabaseGeneratePersonal:SetPoint("TOPLEFT", optionsDatabaseBothFactions, "BOTTOMLEFT", currentOffsetX, optionOffsetY)
	optionsDatabaseGeneratePersonal:SetScript("OnClick", function(self) WhatsYourCovenantConfig.database_BothFactions = not WhatsYourCovenantConfig.database_GeneratePersonal end)
	WhatsYourCovenant_DatabaseGeneratePersonalText:SetText(LocStr(nil, "Generate a personal database (based on seeing players use abilities)"))
	
	------------------------------
	-- Database
	currentOffsetX = -offsetX
	local optionsUsabilityTitle = options:CreateFontString(nil, "ARTWORK")
	optionsUsabilityTitle:SetFontObject(GameFontWhite)
	optionsUsabilityTitle:SetJustifyH("LEFT") 
	optionsUsabilityTitle:SetJustifyV("TOP")
	optionsUsabilityTitle:ClearAllPoints()
	optionsUsabilityTitle:SetPoint("TOPLEFT", optionsDatabaseGeneratePersonal, "BOTTOMLEFT", currentOffsetX, subtitleOffsetY)
	optionsUsabilityTitle:SetText(LocStr(nil, "Usability"))
	currentOffsetX = offsetX
	
	local optionsUsabilityColourise = CreateFrame("CheckButton", "WhatsYourCovenant_UsabilityColourise", options, "OptionsCheckButtonTemplate")
	optionsUsabilityColourise:SetPoint("TOPLEFT", optionsUsabilityTitle, "BOTTOMLEFT", currentOffsetX, optionOffsetY)
	optionsUsabilityColourise:SetScript("OnClick", function(self) WhatsYourCovenantConfig.usability_Colourise = not WhatsYourCovenantConfig.usability_Colourise end)
	WhatsYourCovenant_UsabilityColouriseText:SetText(LocStr(nil, "Colourise the covenant names"))
	currentOffsetX = 0
	
	local optionsUsabilityCovenantColourSwab = {}
	local optionsUsabilityCovenantColourPicker = {}
	local covenantId = { 1, 4, 3, 2 }	-- order the list of covenants
	for i=1, 4 do
		local covId = covenantId[i]
		optionsUsabilityCovenantColourSwab[i] = options:CreateFontString(nil, "ARTWORK")
		optionsUsabilityCovenantColourSwab[i]:SetFontObject(GameFontWhite)
		local tr, tg, tb = GetCovenantColourRGBA(covId)
		optionsUsabilityCovenantColourSwab[i]:SetTextColor(tr, tg, tb)
		optionsUsabilityCovenantColourSwab[i]:SetPoint("TOPLEFT", optionsUsabilityColourise, "BOTTOMLEFT", currentOffsetX + (130 * (i - 1)), optionOffsetY)
		optionsUsabilityCovenantColourSwab[i]:SetSize(120, 22)
		optionsUsabilityCovenantColourSwab[i]:SetText(C_Covenants.GetCovenantData(covId).name)
		
		optionsUsabilityCovenantColourPicker[i] = CreateFrame("Button", "WhatsYourCovenant_UsabilityColourPicker" ..i, options, "UIPanelButtonTemplate")
		optionsUsabilityCovenantColourPicker[i]:SetPoint("TOPLEFT", optionsUsabilityCovenantColourSwab[i], "BOTTOMLEFT", currentOffsetX, optionOffsetY)
		optionsUsabilityCovenantColourPicker[i]:SetSize(120, 22)
		optionsUsabilityCovenantColourPicker[i]:SetText(LocStr(nil, "Select Colour"))
		--optionsUsabilityCovenantColourPicker[i]:SetEnabled(WhatsYourCovenantConfig.usability_Colourise)
		optionsUsabilityCovenantColourPicker[i].swab = optionsUsabilityCovenantColourSwab[i]
		optionsUsabilityCovenantColourPicker[i]:SetScript("OnClick", function(self)
			local pr, pg, pb, pa = self.swab:GetTextColor()
			ShowColorPicker(pr, pg, pb, pa, function(restore)
				local r, g, b, a;
				if (restore) then
					r, g, b, a = unpack(restore)
				else
					a, r, g, b = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
				end
				
				if (a == nil) then
					a = 1
				end
				if (r == nil or g == nil or b == nil) then
					-- Don't attempt to change colour if one of them is nil.
					-- This seems to happen if you try to get the RGB before the alpha.
					return
				end
				SaveCovenantColourRGBA(covId, r, g, b, a)
				self.swab:SetTextColor(r, g, b, a)
			end)
		end)
	end
	
	local optionsUsabilityCovenantColourReset = CreateFrame("Button", "WhatsYourCovenant_UsabilityCovenantColourReset", options, "UIPanelButtonTemplate")
	optionsUsabilityCovenantColourReset:SetPoint("TOPLEFT", optionsUsabilityCovenantColourPicker[1], "BOTTOMLEFT", currentOffsetX + 105, optionOffsetY - 10)
	optionsUsabilityCovenantColourReset:SetSize(300, 22)
	optionsUsabilityCovenantColourReset:SetText(LocStr(nil, "Reset Covenant Colours to Default"))
	optionsUsabilityCovenantColourReset:SetScript("OnClick", function(self)
			SetCovenantColourDefaults()
			for i=1, 4 do
				local r, g, b = GetCovenantColourRGBA(covenantId[i])
				optionsUsabilityCovenantColourSwab[i]:SetTextColor(r, g, b)
			end
		end)
	
end

function ShowColorPicker(r, g, b, a, changedCallback)
	ColorPickerFrame:SetColorRGB(r,g,b)
	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a
	ColorPickerFrame.previousValues = { r, g, b, a }
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 
		changedCallback, changedCallback, changedCallback
	ColorPickerFrame:Hide()		-- need to run the OnShow handler
	ColorPickerFrame:Show()
end

function WhatsYourCovenant_OnLoad()
	SlashCmdList["WHATSYOURCOVENANT"] = WhatsYourCovenant_SlashCommand
	SLASH_WHATSYOURCOVENANT1 = "/WhatsYourCovenant"
	SLASH_WHATSYOURCOVENANT2 = "/wyc"
	
	InitInterfaceOptions()
	
	WhatsYourCovenantFrame:RegisterEvent("PLAYER_LOGIN")
	WhatsYourCovenantFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	WhatsYourCovenantFrame:SetScript("OnEvent", function(self, event)
			if (event == "PLAYER_LOGIN") then
				WhatsYourCovenant_OnPlayerLogin()
			elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
				OnCombatLogEventUnfiltered(CombatLogGetCurrentEventInfo())
			end
		end)
end

