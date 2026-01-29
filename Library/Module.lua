--// UpUi Simple UI Library (FINAL FIX)

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

--------------------------------------------------
local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
end

--------------------------------------------------
function Library:Notify(title, text)
    local gui = self.Gui

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.fromScale(0.25, 0.1)
    frame.Position = UDim2.fromScale(0.37, -0.2)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    corner(frame, 12)

    local t1 = Instance.new("TextLabel", frame)
    t1.Size = UDim2.fromScale(1, 0.45)
    t1.BackgroundTransparency = 1
    t1.Text = title
    t1.Font = Enum.Font.GothamBold
    t1.TextScaled = true
    t1.TextColor3 = Color3.new(1, 1, 1)

    local t2 = Instance.new("TextLabel", frame)
    t2.Position = UDim2.fromScale(0, 0.45)
    t2.Size = UDim2.fromScale(1, 0.55)
    t2.BackgroundTransparency = 1
    t2.TextWrapped = true
    t2.Text = text
    t2.Font = Enum.Font.Gotham
    t2.TextScaled = true
    t2.TextColor3 = Color3.fromRGB(200, 200, 200)

    frame.Parent = gui

    TweenService:Create(frame, TweenInfo.new(.4),
        { Position = UDim2.fromScale(0.37, 0.05) }
    ):Play()

    task.delay(3, function()
        TweenService:Create(frame, TweenInfo.new(.4),
            { Position = UDim2.fromScale(0.37, -0.2) }
        ):Play()
        task.wait(.4)
        frame:Destroy()
    end)
end

--------------------------------------------------
function Library:CreateWindow(cfg)
    local win = setmetatable({}, self)

    local gui = Instance.new("ScreenGui")
    gui.Name = "UpUi"
    gui.Parent = game.CoreGui

    win.Gui = gui
    win.Keybind = cfg.Keybind

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.fromScale(0.32, 0.48)
    frame.Position = UDim2.fromScale(0.34, 0.25)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    corner(frame, 16)

    win.Frame = frame

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.fromScale(1, 0.1)
    title.BackgroundTransparency = 1
    title.Text = cfg.WindowName or "UpUi"
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.TextColor3 = Color3.new(1, 1, 1)

    --------------------------------------------------
    if win.Keybind then
        UIS.InputBegan:Connect(function(i, gp)
            if not gp and i.KeyCode == win.Keybind then
                frame.Visible = not frame.Visible
            end
        end)
    end

    --------------------------------------------------
    function win:Destroy()
        if self.Gui then
            self.Gui:Destroy()
        end
    end

    --------------------------------------------------
    function win:CreateTab(name)
        local tab = {}

        local page = Instance.new("Frame", frame)
        page.Size = UDim2.fromScale(1, 0.9)
        page.Position = UDim2.fromScale(0, 0.1)
        page.BackgroundTransparency = 1

        local layout = Instance.new("UIListLayout", page)
        layout.Padding = UDim.new(0, 6)

        --------------------------------------------------
        function tab:CreateSection(titleText)
            local sec = {}

            local secFrame = Instance.new("Frame", page)
            secFrame.Size = UDim2.new(1, -12, 0, 40)
            secFrame.AutomaticSize = Enum.AutomaticSize.Y
            secFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            secFrame.BorderSizePixel = 0
            corner(secFrame, 12)

            local secLayout = Instance.new("UIListLayout", secFrame)
            secLayout.Padding = UDim.new(0, 6)

            local lbl = Instance.new("TextLabel", secFrame)
            lbl.Size = UDim2.fromScale(1, 0)
            lbl.AutomaticSize = Enum.AutomaticSize.Y
            lbl.BackgroundTransparency = 1
            lbl.Text = titleText
            lbl.Font = Enum.Font.GothamBold
            lbl.TextScaled = true
            lbl.TextColor3 = Color3.new(1, 1, 1)

            function sec:CreateLabel(text)
                local l = Instance.new("TextLabel", secFrame)
                l.Size = UDim2.new(1, -8, 0, 26)
                l.BackgroundTransparency = 1
                l.Text = text
                l.TextWrapped = true
                l.Font = Enum.Font.Gotham
                l.TextScaled = true
                l.TextColor3 = Color3.fromRGB(200, 200, 200)
                return l
            end

            function sec:CreateButton(text, callback)
                local b = Instance.new("TextButton", secFrame)
                b.Size = UDim2.new(1, -8, 0, 34)
                b.Text = text
                b.Font = Enum.Font.GothamBold
                b.TextScaled = true
                b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                b.TextColor3 = Color3.new(1, 1, 1)
                corner(b, 10)

                b.MouseButton1Click:Connect(callback)
                return b
            end

            function sec:CreateDropdown(name, list, cb)
                local mainBtn = sec:CreateButton(name .. ": none", function() end)

                for _, v in ipairs(list) do
                    sec:CreateButton(" > " .. v, function()
                        mainBtn.Text = name .. ": " .. v
                        cb(v)
                    end)
                end
            end

            return sec
        end

        return tab
    end

    return win
end

return setmetatable({}, Library)
