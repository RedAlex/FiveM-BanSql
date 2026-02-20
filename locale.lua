-- Locale system compatible with all frameworks
-- Compatible with ESX, QB-Core and QBox
-- Based on character-manager locale system

Locale = {}
Locale.__index = Locale

function Locale:new(opts)
    local self = setmetatable({}, Locale)
    self.phrases = opts.phrases or {}
    self.warnOnMissing = opts.warnOnMissing or false
    self.fallbackLang = opts.fallbackLang
    return self
end

function Locale:t(key, vars)
    local phrase = self:getPhrase(key)
    
    if phrase == nil then
        if self.warnOnMissing then
            print(string.format("^3[BanSql Warning] Missing translation for key: %s^7", key))
        end
        return key
    end
    
    if vars then
        for k, v in pairs(vars) do
            phrase = phrase:gsub('%%{' .. k .. '}', tostring(v))
            phrase = phrase:gsub('%%(' .. k .. '%)s', tostring(v))
        end
    end
    
    return phrase
end

function Locale:getPhrase(key)
    local keys = {}
    for k in string.gmatch(key, "([^%.]+)") do
        table.insert(keys, k)
    end
    
    local phrase = self.phrases
    for _, k in ipairs(keys) do
        phrase = phrase[k]
        if phrase == nil then
            return self.fallbackLang and self.fallbackLang:getPhrase(key) or nil
        end
    end
    
    return phrase
end

Locales = Locales or {}
Lang = Locale:new({phrases = {}, warnOnMissing = false})
