--------------------------------------------------
-- MODERN HUB UI v2
--------------------------------------------------

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

--------------------------------------------------
-- BLUR
--------------------------------------------------

local blur = Instance.new("BlurEffect")
blur.Name = "HubBlur"
blur.Size = 0
blur.Parent = Lighting

--------------------------------------------------
-- SCREEN GUI
--------------------------------------------------

local Gui = Instance.new("ScreenGui")
Gui.Name = "ModernHub"
Gui.Parent = CoreGui
Gui.ResetOnSpawn = false
Gui.DisplayOrder = 100

--------------------------------------------------
-- SHADOW HOLDER
--------------------------------------------------

local ShadowHolder = Instance.new("Frame", Gui)
ShadowHolder.AnchorPoint = Vector2.new(.5,.5)
ShadowHolder.Position = UDim2.fromScale(.5,.5)
ShadowHolder.Size = UDim2.fromOffset(640,420)
ShadowHolder.BackgroundTransparency = 1

local Shadow = Instance.new("ImageLabel", ShadowHolder)
Shadow.Size = UDim2.fromScale(1.08,1.1)
Shadow.Position = UDim2.fromScale(-.04,-.05)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6015897843"
Shadow.ImageTransparency = .35
Shadow.ImageColor3 = Color3.new(0,0,0)

--------------------------------------------------
-- MAIN PANEL
--------------------------------------------------

local Main = Instance.new("Frame", ShadowHolder)
Main.AnchorPoint = Vector2.new(.5,.5)
Main.Position = UDim2.fromScale(.5,.5)
Main.Size = UDim2.fromScale(1,1)
Main.BackgroundColor3 = Color3.fromRGB(10,10,10)
Main.BackgroundTransparency = .25

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,12)

local Stroke = Instance.new("UIStroke",Main)
Stroke.Thickness = 2.5
Stroke.Color = Color3.fromRGB(255,80,80)

--------------------------------------------------
-- HEADER
--------------------------------------------------

local Header = Instance.new("TextLabel",Main)
Header.Size = UDim2.new(1,0,0,46)
Header.BackgroundTransparency = 1
Header.Text = "Modern Hub UI"
Header.Font = Enum.Font.GothamBold
Header.TextScaled = true
Header.TextColor3 = Color3.new(1,1,1)

local HeaderGrad = Instance.new("UIGradient",Header)
HeaderGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,Color3.fromRGB(255,80,80)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(120,160,255))
}

--------------------------------------------------
-- STATUS BAR
--------------------------------------------------

local StatusGui = Instance.new("ScreenGui",CoreGui)
StatusGui.Name = "StatusBar"
StatusGui.DisplayOrder = 90

local StatusHolder = Instance.new("Frame",StatusGui)
StatusHolder.AnchorPoint = Vector2.new(.5,0)
StatusHolder.Position = UDim2.fromScale(.5,.02)
StatusHolder.Size = UDim2.fromOffset(340,70)
StatusHolder.BackgroundTransparency = 1

local StatusShadow = Shadow:Clone()
StatusShadow.Parent = StatusHolder
StatusShadow.Size = UDim2.fromScale(1.1,1.2)

local StatusMain = Instance.new("Frame",StatusHolder)
StatusMain.AnchorPoint = Vector2.new(.5,.5)
StatusMain.Position = UDim2.fromScale(.5,.5)
StatusMain.Size = UDim2.fromScale(.9,.8)
StatusMain.BackgroundColor3 = Color3.fromRGB(10,10,10)
StatusMain.BackgroundTransparency = .25
Instance.new("UICorner",StatusMain).CornerRadius = UDim.new(0,10)

local StatusText = Instance.new("TextLabel",StatusMain)
StatusText.Size = UDim2.fromScale(1,1)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Status: Waiting..."
StatusText.Font = Enum.Font.GothamBold
StatusText.TextScaled = true
StatusText.TextColor3 = Color3.fromRGB(255,80,80)

--------------------------------------------------
-- FLOATING TOGGLE
--------------------------------------------------

local ToggleGui = Instance.new("ScreenGui",CoreGui)
ToggleGui.Name = "ToggleBtn"

local ToggleFrame = Instance.new("Frame",ToggleGui)
ToggleFrame.Size = UDim2.fromOffset(56,56)
ToggleFrame.Position = UDim2.fromScale(.05,.25)
ToggleFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
ToggleFrame.Active = true
ToggleFrame.Draggable = true
Instance.new("UICorner",ToggleFrame).CornerRadius = UDim.new(1,0)

local ToggleStroke = Instance.new("UIStroke",ToggleFrame)
ToggleStroke.Color = Color3.fromRGB(255,80,80)
ToggleStroke.Thickness = 2

local ToggleIcon = Instance.new("ImageLabel",ToggleFrame)
ToggleIcon.AnchorPoint = Vector2.new(.5,.5)
ToggleIcon.Position = UDim2.fromScale(.5,.5)
ToggleIcon.Size = UDim2.fromScale(.7,.7)
ToggleIcon.BackgroundTransparency = 1
ToggleIcon.Image = "rbxassetid://112485471724320"

local ToggleBtn = Instance.new("TextButton",ToggleFrame)
ToggleBtn.Size = UDim2.fromScale(1,1)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Text = ""

--------------------------------------------------
-- TWEEN HELPERS
--------------------------------------------------

local function tween(obj,props,t)
    TweenService:Create(
        obj,
        TweenInfo.new(t or .35,Enum.EasingStyle.Quint),
        props
    ):Play()
end

--------------------------------------------------
-- TOGGLE LOGIC
--------------------------------------------------

local opened = true

ToggleBtn.MouseButton1Click:Connect(function()

    tween(ToggleIcon,{
        Size = opened and UDim2.fromScale(.5,.5)
            or UDim2.fromScale(.7,.7)
    },.2)

    tween(Main,{
        Size = opened and UDim2.fromScale(0,0)
            or UDim2.fromScale(1,1)
    },.35)

    tween(blur,{
        Size = opened and 0 or 20
    },.35)

    Gui.Enabled = not opened

    opened = not opened
end)

ToggleBtn.MouseEnter:Connect(function()
    tween(ToggleFrame,{
        BackgroundColor3 = Color3.fromRGB(40,40,40)
    },.15)
end)

ToggleBtn.MouseLeave:Connect(function()
    tween(ToggleFrame,{
        BackgroundColor3 = Color3.fromRGB(20,20,20)
    },.15)
end)
