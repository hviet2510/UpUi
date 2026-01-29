--------------------------------------------------
-- UpUi Loader | Auto Update Hub (FINAL FIX)
--------------------------------------------------

local CURRENT_VERSION = "1.0.0"

local VERSION_URL =
    "https://raw.githubusercontent.com/hviet2510/UpUi/main/version.json"

local OWNER = "hviet2510"
local REPO = "UpUi"

local HUB_NAME = "UpUi Hub"
local SCRIPT_TIMEOUT = 6

--------------------------------------------------
-- SERVICES
--------------------------------------------------
local Http = game:GetService("HttpService")
local Players = game:GetService("Players")

local LP = Players.LocalPlayer

--------------------------------------------------
-- AUTO UPDATE
--------------------------------------------------
local function splitVersion(v)
    local t = {}
    for n in v:gmatch("%d+") do
        table.insert(t, tonumber(n))
    end
    return t
end

local function isOutdated(a, b)
    local A, B = splitVersion(a), splitVersion(b)
    for i = 1, math.max(#A, #B) do
        local x, y = A[i] or 0, B[i] or 0
        if x ~= y then
            return x < y
        end
    end
    return false
end

local function checkUpdate()
    local ok, data = pcall(function()
        return Http:JSONDecode(game:HttpGet(VERSION_URL))
    end)

    if not ok then
        warn("[UpUi] Failed to check update")
        return false
    end

    if data.force or isOutdated(CURRENT_VERSION, data.version) then
        warn("[UpUi] Updating to", data.version)

        local code = game:HttpGet(data.loader)
        local fn, err = loadstring(code, "UpUiUpdated")
        if fn then
            fn()
            return true
        end
    end

    return false
end

if checkUpdate() then
    return
end

--------------------------------------------------
-- LOAD UI LIBRARY
--------------------------------------------------
local UI_LIB =
    "https://raw.githubusercontent.com/hviet2510/UpUi/main/Library/Module.lua"

local UILib
do
    local src = game:HttpGet(UI_LIB)
    local fn, err = loadstring(src, "UpUiUILib")

    if not fn then
        return LP:Kick("Failed to compile UI library\n" .. tostring(err))
    end

    local ok, lib = pcall(fn)
    if not ok then
        return LP:Kick("Failed to run UI library\n" .. tostring(lib))
    end

    UILib = lib
end

--------------------------------------------------
-- FETCH FILE LIST
--------------------------------------------------
local function getFiles()
    local url = string.format(
        "https://api.github.com/repos/%s/%s/contents/Scripts",
        OWNER,
        REPO
    )

    local data =
        Http:JSONDecode(game:HttpGet(url))

    local names = {}
    local map = {}

    for _, f in ipairs(data) do
        if f.type == "file" and f.name:match("%.lua$") then
            local clean = f.name:gsub("%.lua", "")
            map[clean] = f
            table.insert(names, clean)
        end
    end

    return names, map
end

--------------------------------------------------
-- FETCH UPDATE INFO
--------------------------------------------------
local function getUpdate(path)
    local url = string.format(
        "https://api.github.com/repos/%s/%s/commits?path=%s&per_page=1",
        OWNER,
        REPO,
        Http:UrlEncode(path)
    )

    local json =
        Http:JSONDecode(game:HttpGet(url))

    return json[1]
end

--------------------------------------------------
-- CREATE UI
--------------------------------------------------
local Window = UILib:CreateWindow({
    WindowName = HUB_NAME .. " | Loader",
    Keybind = Enum.KeyCode.End,
})

local Main = Window:CreateTab("Loader")
local Section = Main:CreateSection("Scripts")

--------------------------------------------------
-- LOAD FILE LIST
--------------------------------------------------
local ok, files, map = pcall(function()
    local list, m = getFiles()
    return list, m
end)

if not ok then
    Section:CreateLabel("Failed to fetch scripts")
    return
end

--------------------------------------------------
-- DROPDOWN
--------------------------------------------------
local selectedFile

Section:CreateDropdown("Scripts", files, function(name)
    selectedFile = map[name]

    if selectedFile then
        local update = getUpdate(selectedFile.path)
        if update then
            Section:CreateLabel(
                "Updated by: " .. update.commit.author.name
            )
            Section:CreateLabel(
                "Updated at: " .. update.commit.author.date
            )
        end
    end
end)

--------------------------------------------------
-- LOAD BUTTON
--------------------------------------------------
Section:CreateButton("Load Script", function()
    if not selectedFile then return end

    UILib:Notify(HUB_NAME, "Downloading script...")

    local ok, data = pcall(function()
        return game:HttpGet(selectedFile.download_url)
    end)

    if not ok then
        return UILib:Notify(HUB_NAME, "Download failed")
    end

    local fn, err = loadstring(data, HUB_NAME)
    if not fn then
        return UILib:Notify(HUB_NAME, err)
    end

    local watchdog = task.delay(SCRIPT_TIMEOUT, function()
        UILib:Notify(HUB_NAME, "Script timeout")
    end)

    local ran, runErr = pcall(fn)
    task.cancel(watchdog)

    if not ran then
        return UILib:Notify(HUB_NAME, runErr)
    end

    UILib:Notify(HUB_NAME, "Loaded successfully!")
    Window:Destroy()
end)
