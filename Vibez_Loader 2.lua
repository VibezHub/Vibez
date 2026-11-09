--[[
    Vibez Loader
    ------------------------------------------------------------
    Run this one script. It loads the shared UI library, detects
    which game you are in, and loads the matching game module.

    SETUP
      1. Upload this repo layout to GitHub (or any raw-file host):
            Vibez_Loader.lua
            Vibez_Lib.lua
            FF3.lua
      2. Set BaseUrl below to your raw folder URL (must end in "/").
      3. Execute:
            loadstring(game:HttpGet('<BaseUrl>Vibez_Loader.lua'))()

    LOCAL TESTING (no hosting)
      Put the three files in your executor workspace under
      vibez/dev/ (keeping the games/ folder), then run:
            getgenv().VibezDev = true
            loadstring(readfile('vibez/dev/Vibez_Loader.lua'))()

    ADDING A GAME
      1. Make <NAME>.lua (it receives the UI library as "...").
      2. Add an entry to the Games table below with its PlaceId /
         UniverseId (game.GameId).
]]

local CONFIG = {
    Version = '1.0.0',
    BaseUrl = 'https://raw.githubusercontent.com/VibezHub/Vibez/main/',
    LibPath = 'Vibez_Lib.lua',
    DevFolder = 'vibez/dev/',
}

local Games = {
    {
        Id = 'ff3',
        Name = 'Football Fusion 3',
        Path = 'FF3.lua',
        PlaceIds = { 82866880824588, 81310542478972 },   -- main + practice place
        UniverseIds = { 9908641400 },
    },
    -- {
    --     Id = 'example',
    --     Name = 'Another Game',
    --     Path = 'Example.lua',
    --     PlaceIds = { 123456789 },
    --     UniverseIds = {},
    -- },
}

----------------------------------------------------------------
local env = (getgenv and getgenv()) or _G

if env.VibezLoading and (os.clock() - (env.VibezLoadingAt or 0)) < 20 then
    warn('[Vibez] Loader is already running.')
    return
end
env.VibezLoading = true
env.VibezLoadingAt = os.clock()
print('[Vibez] Loader started')

local contains = function(list, value)
    for i = 1, #(list or {}) do
        if list[i] == value then return true end
    end
    return false
end

local fetch = function(path)
    if env.VibezDev and readfile and isfile and isfile(CONFIG.DevFolder .. path) then
        return readfile(CONFIG.DevFolder .. path)
    end
    local ok, src = pcall(function()
        return game:HttpGet(CONFIG.BaseUrl .. path)
    end)
    if not ok or type(src) ~= 'string' or #src == 0 then
        error('could not download ' .. path .. ' (check BaseUrl): ' .. tostring(src), 0)
    end
    return src
end

local run = function(path, ...)
    local src = fetch(path)
    local fn, err = loadstring(src, '=' .. path)
    if not fn then
        error('syntax error in ' .. path .. ': ' .. tostring(err), 0)
    end
    return fn(...)
end

local detect = function()
    for i = 1, #Games do
        local g = Games[i]
        if contains(g.PlaceIds, game.PlaceId) or contains(g.UniverseIds, game.GameId) then
            return g
        end
    end
    return nil
end

local Loader = { Version = CONFIG.Version, Games = Games }
env.VibezLoader = Loader

local VibezLib

local notify = function(title, content)
    if not VibezLib then return end
    pcall(function()
        VibezLib:Notify({ Title = title, Content = content, Duration = 5 })
    end)
end

local loadGame
local showSelector

loadGame = function(g)
    local ok, err = xpcall(function()
        run(g.Path, VibezLib)
    end, function(e)
        return tostring(e) .. '\n' .. debug.traceback()
    end)
    if ok then
        notify('Vibez', g.Name .. ' loaded.')
    else
        warn('[Vibez] Failed to load ' .. g.Name .. ':\n' .. tostring(err))
        notify('Vibez', 'Failed to load ' .. g.Name .. '. Check the console (F9).')
    end
    return ok
end

showSelector = function(reason)
    local Window = VibezLib:CreateWindow({
        Title = 'ez',
        Prefix = 'Vib',
        Theme = 'Vibez',
    })
    local Tab = Window:CreateTab({ Name = 'Games', Icon = 'rbxassetid://6034684949' })
    for i = 1, #Games do
        local g = Games[i]
        Tab:CreateButton({
            Name = 'Load ' .. g.Name,
            Callback = function()
                loadGame(g)
            end,
        })
    end
    notify('Vibez', reason)
end

Loader.Load = function(id)
    for i = 1, #Games do
        if Games[i].Id == id then return loadGame(Games[i]) end
    end
    warn('[Vibez] Unknown game id: ' .. tostring(id))
    return false
end

local ok, err = xpcall(function()
    print('[Vibez] Loading UI library...')
    VibezLib = run(CONFIG.LibPath)
    assert(type(VibezLib) == 'table', 'library did not return a table')

    local g = detect()
    print('[Vibez] PlaceId ' .. tostring(game.PlaceId) .. ' / GameId ' .. tostring(game.GameId))
    if g then
        print('[Vibez] Detected ' .. g.Name .. ', loading module...')
        loadGame(g)
    else
        showSelector('This game is not supported yet. Pick one manually.')
    end
end, function(e)
    return tostring(e) .. '\n' .. debug.traceback()
end)

env.VibezLoading = nil
print('[Vibez] Loader finished')

if not ok then
    warn('[Vibez] Loader error:\n' .. tostring(err))
end
