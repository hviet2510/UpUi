--------------------------------------------------
-- UpUi Demo Script
--------------------------------------------------

print("[UpUi] Demo script loaded!")

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "UpUi Hub",
        Text = "Demo script loaded successfully!",
        Duration = 5
    })
end)

-- simple effect so you know it ran
local lp = Players.LocalPlayer

if lp and lp.Character then
    for _, p in ipairs(lp.Character:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Material = Enum.Material.Neon
        end
    end
end
