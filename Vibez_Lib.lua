-- Vibez UI Library (shared by every game module)
local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local RunService = game:GetService('RunService')
local CoreGui = game:GetService('CoreGui')
local Players = game:GetService('Players')
local TextService = game:GetService('TextService')
local HttpService = game:GetService('HttpService')

local LocalPlayer = Players.LocalPlayer
local uiParent = (pcall(function() return CoreGui.Name end) and CoreGui) or LocalPlayer:WaitForChild('PlayerGui')

local Themes = {
    ['Vibez'] = {
        MainBG = Color3.fromRGB(13, 11, 22),
        SidebarBG = Color3.fromRGB(17, 14, 29),
        TopbarBG = Color3.fromRGB(10, 8, 18),
        ElementBG = Color3.fromRGB(24, 20, 40),
        Accent = Color3.fromRGB(167, 108, 255),
        TextMain = Color3.fromRGB(244, 240, 255),
        TextSub = Color3.fromRGB(151, 144, 178),
        Border = Color3.fromRGB(46, 38, 78),
        DropdownListBG = Color3.fromRGB(21, 17, 36),
        DropdownListStroke = Color3.fromRGB(56, 46, 94)
    },
    ['Default'] = {
        MainBG = Color3.fromRGB(15, 15, 17),
        SidebarBG = Color3.fromRGB(18, 18, 21),
        TopbarBG = Color3.fromRGB(12, 12, 14),
        ElementBG = Color3.fromRGB(24, 24, 27),
        Accent = Color3.fromRGB(59, 130, 246),
        TextMain = Color3.fromRGB(240, 240, 240),
        TextSub = Color3.fromRGB(160, 160, 165),
        Border = Color3.fromRGB(39, 39, 42),
        DropdownListBG = Color3.fromRGB(24, 24, 27),
        DropdownListStroke = Color3.fromRGB(39, 39, 42)
    },
    ['Dracula'] = {
        MainBG = Color3.fromRGB(40, 42, 54),
        SidebarBG = Color3.fromRGB(33, 34, 44),
        TopbarBG = Color3.fromRGB(24, 25, 33),
        ElementBG = Color3.fromRGB(56, 58, 89),
        Accent = Color3.fromRGB(189, 147, 249),
        TextMain = Color3.fromRGB(248, 248, 242),
        TextSub = Color3.fromRGB(160, 165, 180),
        Border = Color3.fromRGB(68, 71, 90),
        DropdownListBG = Color3.fromRGB(56, 58, 89),
        DropdownListStroke = Color3.fromRGB(68, 71, 90)
    },
    ['Tokyo Night'] = {
        MainBG = Color3.fromRGB(26, 27, 38),
        SidebarBG = Color3.fromRGB(31, 35, 53),
        TopbarBG = Color3.fromRGB(22, 22, 30),
        ElementBG = Color3.fromRGB(41, 46, 66),
        Accent = Color3.fromRGB(122, 162, 247),
        TextMain = Color3.fromRGB(192, 202, 245),
        TextSub = Color3.fromRGB(120, 124, 153),
        Border = Color3.fromRGB(56, 62, 86),
        DropdownListBG = Color3.fromRGB(41, 46, 66),
        DropdownListStroke = Color3.fromRGB(56, 62, 86)
    },
    ['Catppuccin'] = {
        MainBG = Color3.fromRGB(30, 30, 46),
        SidebarBG = Color3.fromRGB(24, 24, 37),
        TopbarBG = Color3.fromRGB(17, 17, 27),
        ElementBG = Color3.fromRGB(49, 50, 68),
        Accent = Color3.fromRGB(203, 166, 247),
        TextMain = Color3.fromRGB(205, 214, 244),
        TextSub = Color3.fromRGB(166, 173, 200),
        Border = Color3.fromRGB(69, 71, 90),
        DropdownListBG = Color3.fromRGB(49, 50, 68),
        DropdownListStroke = Color3.fromRGB(69, 71, 90)
    },
    ['Rose Pine'] = {
        MainBG = Color3.fromRGB(25, 23, 36),
        SidebarBG = Color3.fromRGB(31, 29, 46),
        TopbarBG = Color3.fromRGB(20, 18, 28),
        ElementBG = Color3.fromRGB(38, 35, 58),
        Accent = Color3.fromRGB(235, 188, 186),
        TextMain = Color3.fromRGB(224, 222, 244),
        TextSub = Color3.fromRGB(144, 140, 170),
        Border = Color3.fromRGB(49, 47, 68),
        DropdownListBG = Color3.fromRGB(38, 35, 58),
        DropdownListStroke = Color3.fromRGB(49, 47, 68)
    },
    ['Minimal White'] = {
        MainBG = Color3.fromRGB(15, 15, 15),
        SidebarBG = Color3.fromRGB(20, 20, 20),
        TopbarBG = Color3.fromRGB(10, 10, 10),
        ElementBG = Color3.fromRGB(26, 26, 26),
        Accent = Color3.fromRGB(255, 255, 255),
        TextMain = Color3.fromRGB(255, 255, 255),
        TextSub = Color3.fromRGB(170, 170, 170),
        Border = Color3.fromRGB(40, 40, 40),
        DropdownListBG = Color3.fromRGB(26, 26, 26),
        DropdownListStroke = Color3.fromRGB(40, 40, 40)
    }
}

local Theme = {}
for k, v in pairs(Themes['Vibez']) do Theme[k] = v end

local VibezLib = {}
VibezLib.Flags = {}
VibezLib.ThemeConnections = {}
VibezLib.RainbowAccent = false
VibezLib.RainbowSpeed = 5
VibezLib.ShowNotifications = true
VibezLib.ShowTooltips = true

local SetupDirectories = function()
    if makefolder and isfolder then
        if not isfolder('vibez') then
            pcall(makefolder, 'vibez')
        end
    end
end
SetupDirectories()

local createInstance = function(className, properties)
    local inst = Instance.new(className)
    for k, v in pairs(properties or {}) do
        inst[k] = v
    end
    return inst
end

local getStringValue = function(val)
    if type(val) == 'table' then
        if val.Type == 'Color3' then
            return string.format('RGB: %d, %d, %d', math.floor(val.R * 255), math.floor(val.G * 255), math.floor(val.B * 255))
        elseif val.Type == 'EnumItem' then
            return tostring(val.Name)
        end
        for _, v in pairs(val) do
            if type(v) == 'string' or type(v) == 'number' then
                return tostring(v)
            end
        end
        return 'None'
    end
    return val ~= nil and tostring(val) or 'None'
end

local regTheme = function(instance, callback)
    table.insert(VibezLib.ThemeConnections, function()
        local success, hasParent = pcall(function() return instance and instance.Parent end)
        if success and hasParent then
            callback()
            return true
        end
        return false
    end)
    callback()
end

local UpdateThemeAccent = function(newColor)
    Theme.Accent = newColor
    local alive = {}
    for i = 1, #VibezLib.ThemeConnections do
        local func = VibezLib.ThemeConnections[i]
        if type(func) == 'function' then
            local s, res = pcall(func)
            if s and res ~= false then 
                table.insert(alive, func) 
            end
        end
    end
    VibezLib.ThemeConnections = alive
end

local ApplySelectedTheme = function(themeName)
    local targetTheme = Themes[themeName]
    if not targetTheme then return end
    for k, v in pairs(targetTheme) do
        Theme[k] = v
    end
    local alive = {}
    for i = 1, #VibezLib.ThemeConnections do
        local func = VibezLib.ThemeConnections[i]
        if type(func) == 'function' then
            local s, res = pcall(func)
            if s and res ~= false then 
                table.insert(alive, func) 
            end
        end
    end
    VibezLib.ThemeConnections = alive
end

RunService.RenderStepped:Connect(function()
    if VibezLib.RainbowAccent then
        local hue = tick() * (VibezLib.RainbowSpeed / 100) % 1
        UpdateThemeAccent(Color3.fromHSV(hue, 1, 1))
    end
end)

local GetDarkerColor = function(color, factor)
    local h, s, v = Color3.toHSV(color)
    return Color3.fromHSV(h, s, math.clamp(v * factor, 0, 1))
end

local SerializeValue = function(val)
    if typeof(val) == 'Color3' then
        return {Type = 'Color3', R = val.R, G = val.G, B = val.B}
    elseif typeof(val) == 'EnumItem' then
        return {Type = 'EnumItem', EnumType = tostring(val.EnumType), Name = val.Name}
    elseif typeof(val) == 'table' then
        local tbl = {}
        for k, v in pairs(val) do
            tbl[k] = SerializeValue(v)
        end
        return tbl
    end
    return val
end

local DeserializeValue = function(val)
    if type(val) == 'table' then
        if val.Type == 'Color3' then
            return Color3.new(val.R, val.G, val.B)
        elseif val.Type == 'EnumItem' then
            local success, enum = pcall(function() return Enum[val.EnumType][val.Name] end)
            return success and enum or nil
        else
            local tbl = {}
            for k, v in pairs(val) do
                tbl[k] = DeserializeValue(v)
            end
            return tbl
        end
    end
    return val
end

VibezLib.Notify = function(self, options)
    if not VibezLib.ShowNotifications then return end
    local Title = options.Title or 'Notification'
    local Content = options.Content or 'Notification content goes here.'
    local Duration = options.Duration or 3

    local ScreenGui = uiParent:FindFirstChild('VibezUI')
    if not ScreenGui then return end
    
    local NotifContainer = ScreenGui:FindFirstChild('NotifyContainer')
    if not NotifContainer then return end

    local Wrapper = createInstance('Frame', {
        Parent = NotifContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 260, 0, 0),
        ClipsDescendants = true,
        ZIndex = 200
    })

    local NotifCard = createInstance('CanvasGroup', {
        Parent = Wrapper,
        BackgroundColor3 = Theme.MainBG,
        BackgroundTransparency = 0.05,
        Size = UDim2.new(1, 0, 0, 75),
        Position = UDim2.new(1, 300, 0, 0),
        GroupTransparency = 1,
        ZIndex = 200
    })
    createInstance('UICorner', {Parent = NotifCard, CornerRadius = UDim.new(0, 12)})
    regTheme(NotifCard, function() NotifCard.BackgroundColor3 = Theme.MainBG end)

    local TitleLbl = createInstance('TextLabel', {
        Parent = NotifCard,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 0, 16),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Theme.Accent,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 201
    })
    regTheme(TitleLbl, function() TitleLbl.TextColor3 = Theme.Accent end)

    local InfoLbl = createInstance('TextLabel', {
        Parent = NotifCard,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 30),
        Size = UDim2.new(1, -30, 0, 35),
        Font = Enum.Font.Gotham,
        Text = Content,
        TextColor3 = Theme.TextSub,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextWrapped = true,
        ZIndex = 201
    })
    regTheme(InfoLbl, function() InfoLbl.TextColor3 = Theme.TextSub end)

    local LineFrame = createInstance('Frame', {
        Parent = NotifCard,
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 2),
        ZIndex = 201
    })
    createInstance('UICorner', {Parent = LineFrame, CornerRadius = UDim.new(1, 0)})
    regTheme(LineFrame, function() LineFrame.BackgroundColor3 = Theme.Accent end)

    TweenService:Create(Wrapper, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 260, 0, 85)}):Play()
    TweenService:Create(NotifCard, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0),
        GroupTransparency = 0
    }):Play()
    TweenService:Create(LineFrame, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()

    task.delay(Duration, function()
        local outTween = TweenService:Create(NotifCard, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 300, 0, 0),
            GroupTransparency = 1
        })
        outTween:Play()
        outTween.Completed:Wait()
        TweenService:Create(Wrapper, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 260, 0, 0)}):Play()
        task.delay(0.3, function() Wrapper:Destroy() end)
    end)
end

VibezLib.CreateWindow = function(self, options)
    local WindowTitle = options.Title or 'ez'
    local TitlePrefix = options.Prefix or 'Vib'
    local defaultTheme = options.Theme or 'Vibez'
    
    local oldGui = uiParent:FindFirstChild('VibezUI')
    while oldGui do
        oldGui:Destroy()
        oldGui = uiParent:FindFirstChild('VibezUI')
    end

    local ScreenGui = createInstance('ScreenGui', {
        Name = 'VibezUI',
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = uiParent
    })

    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    local MainGroup = createInstance('CanvasGroup', {
        Name = 'MainGroup',
        Parent = ScreenGui,
        BackgroundColor3 = Theme.MainBG,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 640, 0, 410),
        BorderSizePixel = 0
    })
    regTheme(MainGroup, function() MainGroup.BackgroundColor3 = Theme.MainBG end)
    
    local CurrentScale = 1
    local MainScale = createInstance('UIScale', {Parent = MainGroup, Scale = CurrentScale})
    local ScalesToUpdate = {MainScale}

    local WindowObj = { Tabs = {}, CurrentTab = nil, ElementsList = {} }
    
    local MenuVisible = true
    
    local UpdateScale = function(newScale)
        CurrentScale = newScale
        if MenuVisible then
            for i = 1, #ScalesToUpdate do
                local scaleObj = ScalesToUpdate[i]
                TweenService:Create(scaleObj, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Scale = CurrentScale}):Play()
            end
        end
    end
    
    WindowObj.UpdateScale = function(self, newScale)
        local scale = type(self) == 'number' and self or newScale
        UpdateScale(scale)
    end

    createInstance('UICorner', {Parent = MainGroup, CornerRadius = UDim.new(0, 12)})

    local MainStrokeFrame = createInstance('Frame', {
        Name = 'StrokeFrame',
        Parent = MainGroup,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0)
    })
    createInstance('UICorner', {Parent = MainStrokeFrame, CornerRadius = UDim.new(0, 12)})
    local MainStroke = createInstance('UIStroke', {Parent = MainStrokeFrame, Color = Theme.Border})
    regTheme(MainStroke, function() MainStroke.Color = Theme.Border end)

    local NotifyContainer = createInstance('Frame', {
        Name = 'NotifyContainer',
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -20, 1, -20),
        Size = UDim2.new(0, 300, 1, 0),
        ZIndex = 100
    })

    createInstance('UIListLayout', {
        Parent = NotifyContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 10)
    })

    local TooltipCard = createInstance('CanvasGroup', {
        Name = 'TooltipCard',
        Parent = ScreenGui,
        BackgroundColor3 = Theme.MainBG,
        BackgroundTransparency = 0.1,
        Size = UDim2.new(0, 0, 0, 24),
        Position = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        Visible = false,
        GroupTransparency = 1,
        ZIndex = 300
    })
    regTheme(TooltipCard, function() TooltipCard.BackgroundColor3 = Theme.MainBG end)
    createInstance('UICorner', {Parent = TooltipCard, CornerRadius = UDim.new(0, 6)})
    createInstance('UIPadding', {Parent = TooltipCard, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
    
    local TooltipLine = createInstance('Frame', {
        Parent = TooltipCard,
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, -10, 0, 0),
        Size = UDim2.new(0, 3, 1, 0),
        ZIndex = 301
    })
    regTheme(TooltipLine, function() TooltipLine.BackgroundColor3 = Theme.Accent end)
    
    local TooltipText = createInstance('TextLabel', {
        Parent = TooltipCard,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 0, 1, 0),
        Font = Enum.Font.GothamMedium,
        Text = '',
        TextColor3 = Theme.TextMain,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.X,
        ZIndex = 301
    })
    regTheme(TooltipText, function() TooltipText.TextColor3 = Theme.TextMain end)

    local tooltipActive = false
    local activeHoveredElement = nil
    local tooltipCurrentOffset = 20
    local targetTooltipOffset = 20

    local ShowTooltip = function(text, targetY)
        if not VibezLib.ShowTooltips then return end
        if not text or text == '' then return end
        TooltipText.Text = text
        TooltipCard.AutomaticSize = Enum.AutomaticSize.X
        TooltipCard.Visible = true
        tooltipActive = true
        targetTooltipOffset = 0
        
        TweenService:Create(TooltipCard, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            GroupTransparency = 0
        }):Play()
    end
    
    local HideTooltip = function()
        tooltipActive = false
        targetTooltipOffset = 20
        TweenService:Create(TooltipCard, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            GroupTransparency = 1
        }):Play()
        task.delay(0.2, function() 
            if not tooltipActive then
                TooltipCard.Visible = false
            end
        end)
    end

    RunService.RenderStepped:Connect(function(dt)
        if TooltipCard.Visible and activeHoveredElement then
            tooltipCurrentOffset = tooltipCurrentOffset + (targetTooltipOffset - tooltipCurrentOffset) * math.clamp(dt * 15, 0, 1)
            local targetY = activeHoveredElement.AbsolutePosition.Y + (activeHoveredElement.AbsoluteSize.Y / 2) - (TooltipCard.AbsoluteSize.Y / 2)
            local mainX = MainGroup.AbsolutePosition.X + MainGroup.AbsoluteSize.X + 15 + tooltipCurrentOffset
            TooltipCard.Position = UDim2.new(0, mainX, 0, targetY)
        end
    end)

    local SetupTooltip = function(elementFrame, tipText)
        if not tipText or tipText == '' then return end
        elementFrame.MouseEnter:Connect(function()
            activeHoveredElement = elementFrame
            ShowTooltip(tipText, elementFrame.AbsolutePosition.Y)
        end)
        elementFrame.MouseLeave:Connect(function()
            if activeHoveredElement == elementFrame then
                activeHoveredElement = nil
                HideTooltip()
            end
        end)
    end

    local MenuKeybind = Enum.KeyCode.RightControl

    local ToggleMenuVisible = function(state)
        if state ~= nil then MenuVisible = state else MenuVisible = not MenuVisible end
        MainGroup.Interactable = MenuVisible
        
        if MenuVisible then
            MainGroup.Visible = true
            TweenService:Create(MainGroup, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
            TweenService:Create(MainStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0}):Play()
            for i = 1, #ScalesToUpdate do
                local scaleObj = ScalesToUpdate[i]
                TweenService:Create(scaleObj, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = CurrentScale}):Play()
            end
        else
            TweenService:Create(MainGroup, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 1}):Play()
            TweenService:Create(MainStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 1}):Play()
            for i = 1, #ScalesToUpdate do
                local scaleObj = ScalesToUpdate[i]
                TweenService:Create(scaleObj, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = CurrentScale * 0.95}):Play()
            end
            task.delay(0.3, function() if not MenuVisible then MainGroup.Visible = false end end)
        end
    end

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == MenuKeybind then ToggleMenuVisible() end
    end)

    if isMobile then
        local ToggleBtn = createInstance('ImageButton', {
            Parent = ScreenGui,
            BackgroundColor3 = Theme.MainBG,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 20),
            Size = UDim2.new(0, 48, 0, 40),
            AutoButtonColor = false,
            Image = ''
        })
        createInstance('UICorner', {Parent = ToggleBtn, CornerRadius = UDim.new(0, 8)})
        local btnStroke = createInstance('UIStroke', {Parent = ToggleBtn, Color = Theme.Border, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
        regTheme(ToggleBtn, function() 
            ToggleBtn.BackgroundColor3 = Theme.MainBG
            btnStroke.Color = Theme.Border
        end)

        local TogTextFrame = createInstance('Frame', {
            Parent = ToggleBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0)
        })

        local TogText = createInstance('TextLabel', {
            Parent = TogTextFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            RichText = true,
            Font = Enum.Font.GothamBold,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            Text = '<i>VBZ</i>'
        })
        regTheme(TogText, function() TogText.TextColor3 = Theme.TextMain end)

        local draggingTog, dragInputTog, dragStartTog, startPosTog
        ToggleBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingTog = true
                dragStartTog = input.Position
                startPosTog = ToggleBtn.Position
            end
        end)
        ToggleBtn.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInputTog = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInputTog and draggingTog then
                local delta = input.Position - dragStartTog
                ToggleBtn.Position = UDim2.new(startPosTog.X.Scale, startPosTog.X.Offset + delta.X, startPosTog.Y.Scale, startPosTog.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingTog = false
            end
        end)
        ToggleBtn.MouseButton1Click:Connect(function() ToggleMenuVisible() end)
    end

    local Topbar = createInstance('Frame', {
        Name = 'Topbar',
        Parent = MainGroup,
        BackgroundColor3 = Theme.TopbarBG,
        Size = UDim2.new(1, 0, 0, 48),
        BorderSizePixel = 0,
        ZIndex = 2
    })
    regTheme(Topbar, function() Topbar.BackgroundColor3 = Theme.TopbarBG end)

    local TopbarBorder = createInstance('Frame', {
        Parent = Topbar,
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 1)
    })
    regTheme(TopbarBorder, function() TopbarBorder.BackgroundColor3 = Theme.Accent end)
    createInstance('UIGradient', {
        Parent = TopbarBorder,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.25, 0.2),
            NumberSequenceKeypoint.new(0.75, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        })
    })

    local dragging, dragInput, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainGroup.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(MainGroup, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)

    local cleanTitle = TitlePrefix .. WindowTitle
    local titleBounds = TextService:GetTextSize(cleanTitle, 22, Enum.Font.GothamBold, Vector2.new(1000, 48))

    local TitleLabel = createInstance('TextLabel', {
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 18, 0, 0),
        Size = UDim2.new(0, titleBounds.X + 10, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = string.format('<i>%s</i>%s', TitlePrefix, WindowTitle),
        RichText = true,
        TextColor3 = Theme.TextMain,
        TextSize = 22,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    regTheme(TitleLabel, function() TitleLabel.TextColor3 = Theme.TextMain end)

    local profileText = 'Welcome, ' .. LocalPlayer.Name
    local profileBounds = TextService:GetTextSize(profileText, 12, Enum.Font.Gotham, Vector2.new(1000, 48))

    local ProfileBox = createInstance('Frame', {
        Parent = Topbar,
        BackgroundColor3 = Theme.MainBG,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -85, 0.5, 0),
        Size = UDim2.new(0, profileBounds.X + 42, 0, 30)
    })
    createInstance('UICorner', {Parent = ProfileBox, CornerRadius = UDim.new(0, 8)})
    local ProfileStroke = createInstance('UIStroke', {Parent = ProfileBox, Color = Theme.Border})
    regTheme(ProfileBox, function() 
        ProfileBox.BackgroundColor3 = Theme.MainBG
        ProfileStroke.Color = Theme.Border
    end)

    local AvatarImg = createInstance('ImageLabel', {
        Parent = ProfileBox,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 4, 0.5, -11),
        Size = UDim2.new(0, 22, 0, 22)
    })
    createInstance('UICorner', {Parent = AvatarImg, CornerRadius = UDim.new(1, 0)})

    task.spawn(function()
        local content, isReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        if isReady then AvatarImg.Image = content end
    end)

    local ProfileName = createInstance('TextLabel', {
        Parent = ProfileBox,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 32, 0, 0),
        Size = UDim2.new(1, -36, 1, 0),
        Font = Enum.Font.Gotham,
        Text = profileText,
        TextColor3 = Theme.TextMain,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    regTheme(ProfileName, function() ProfileName.TextColor3 = Theme.TextMain end)

    local SearchOverlay = createInstance('CanvasGroup', {
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 500,
        GroupTransparency = 1,
        Visible = false
    })

    local SearchPanel = createInstance('Frame', {
        Parent = SearchOverlay,
        BackgroundColor3 = Theme.MainBG,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, -20),
        Size = UDim2.new(0, 400, 0, 300),
        ClipsDescendants = true
    })
    createInstance('UICorner', {Parent = SearchPanel, CornerRadius = UDim.new(0, 12)})
    local SearchPanelStroke = createInstance('UIStroke', {Parent = SearchPanel, Color = Theme.Border})
    regTheme(SearchPanel, function() 
        SearchPanel.BackgroundColor3 = Theme.MainBG
        SearchPanelStroke.Color = Theme.Border 
    end)

    local SearchInputBox = createInstance('TextBox', {
        Parent = SearchPanel,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 10),
        Size = UDim2.new(1, -40, 0, 40),
        Font = Enum.Font.GothamMedium,
        PlaceholderText = 'Search elements...',
        PlaceholderColor3 = Theme.TextSub,
        TextColor3 = Theme.TextMain,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Text = ''
    })
    regTheme(SearchInputBox, function() 
        SearchInputBox.TextColor3 = Theme.TextMain 
        SearchInputBox.PlaceholderColor3 = Theme.TextSub
    end)
    
    local SearchLine = createInstance('Frame', {
        Parent = SearchPanel,
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 55),
        Size = UDim2.new(1, 0, 0, 1)
    })
    regTheme(SearchLine, function() SearchLine.BackgroundColor3 = Theme.Border end)

    local SearchScroll = createInstance('ScrollingFrame', {
        Parent = SearchPanel,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 65),
        Size = UDim2.new(1, -20, 1, -75),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Border,
        BorderSizePixel = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    regTheme(SearchScroll, function() SearchScroll.ScrollBarImageColor3 = Theme.Border end)

    createInstance('UIListLayout', {
        Parent = SearchScroll,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })

    local SearchBtn = createInstance('ImageButton', {
        Parent = Topbar,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -50, 0.5, 0),
        Size = UDim2.new(0, 24, 0, 24),
        Image = 'rbxassetid://6031154871',
        ImageColor3 = Theme.TextSub
    })
    regTheme(SearchBtn, function() SearchBtn.ImageColor3 = Theme.TextSub end)

    SearchBtn.MouseButton1Click:Connect(function()
        SearchOverlay.Visible = true
        SearchInputBox.Text = ''
        TweenService:Create(SearchOverlay, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
        SearchInputBox:CaptureFocus()
    end)

    SearchOverlay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position
            local cx1, cy1 = SearchPanel.AbsolutePosition.X, SearchPanel.AbsolutePosition.Y
            local cx2, cy2 = cx1 + SearchPanel.AbsoluteSize.X, cy1 + SearchPanel.AbsoluteSize.Y
            if not (pos.X >= cx1 and pos.X <= cx2 and pos.Y >= cy1 and pos.Y <= cy2) then
                TweenService:Create(SearchOverlay, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 1}):Play()
                task.delay(0.3, function() SearchOverlay.Visible = false end)
            end
        end
    end)

    local PopulateSearch = function(query)
        local cList = SearchScroll:GetChildren()
        for i = 1, #cList do
            local v = cList[i]
            if v:IsA('TextButton') then v:Destroy() end
        end
        if query == '' then return end
        
        query = query:lower()
        for i = 1, #WindowObj.ElementsList do
            local elementData = WindowObj.ElementsList[i]
            if string.find(elementData.Name:lower(), query) then
                local sBtn = createInstance('TextButton', {
                    Parent = SearchScroll,
                    BackgroundColor3 = Theme.ElementBG,
                    Size = UDim2.new(1, 0, 0, 34),
                    Text = '',
                    AutoButtonColor = false
                })
                createInstance('UICorner', {Parent = sBtn, CornerRadius = UDim.new(0, 8)})
                
                local sText = createInstance('TextLabel', {
                    Parent = sBtn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 1, 0),
                    Font = Enum.Font.GothamMedium,
                    Text = elementData.Name .. "  <font color='rgb(120,120,120)'>[" .. elementData.Tab.Name .. "]</font>",
                    RichText = true,
                    TextColor3 = Theme.TextMain,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                regTheme(sBtn, function() sBtn.BackgroundColor3 = Theme.ElementBG end)
                regTheme(sText, function() sText.TextColor3 = Theme.TextMain end)

                sBtn.MouseEnter:Connect(function()
                    TweenService:Create(sBtn, TweenInfo.new(0.2), {BackgroundColor3 = GetDarkerColor(Theme.ElementBG, 0.8)}):Play()
                end)
                sBtn.MouseLeave:Connect(function()
                    TweenService:Create(sBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementBG}):Play()
                end)

                sBtn.MouseButton1Click:Connect(function()
                    TweenService:Create(SearchOverlay, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 1}):Play()
                    task.delay(0.3, function() SearchOverlay.Visible = false end)
                    
                    elementData.Tab.Select()
                    
                    task.wait(0.1) 
                    local targetY = elementData.Frame.AbsolutePosition.Y - elementData.Tab.Page.AbsolutePosition.Y + elementData.Tab.Page.CanvasPosition.Y - (elementData.Tab.Page.AbsoluteWindowSize.Y / 2) + (elementData.Frame.AbsoluteSize.Y / 2)
                    TweenService:Create(elementData.Tab.Page, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        CanvasPosition = Vector2.new(0, math.max(0, targetY))
                    }):Play()

                    local origColor = elementData.Frame.BackgroundColor3
                    TweenService:Create(elementData.Frame, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Accent}):Play()
                    task.delay(0.6, function()
                        if elementData.Frame then
                            TweenService:Create(elementData.Frame, TweenInfo.new(0.5), {BackgroundColor3 = origColor}):Play()
                        end
                    end)
                end)
            end
        end
    end

    SearchInputBox:GetPropertyChangedSignal('Text'):Connect(function()
        PopulateSearch(SearchInputBox.Text)
    end)

    local startX = TitleLabel.Position.X.Offset + titleBounds.X + 25
    local endX = 640 - 15 - (profileBounds.X + 42) - 50 - 30
    local subTabsWidth = endX - startX

    local SubTabs = createInstance('Frame', {
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, startX, 0, 0),
        Size = UDim2.new(0, subTabsWidth, 1, 0)
    })

    createInstance('UIListLayout', {
        Parent = SubTabs,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 15),
        VerticalAlignment = Enum.VerticalAlignment.Center
    })

    local subTabItems = {'Home', 'UI Settings', 'Configs'}
    local activeSubTab = 'Home'
    local MasterContainers = {}

    local BodyContainer = createInstance('Frame', {
        Name = 'BodyContainer',
        Parent = MainGroup,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 48),
        Size = UDim2.new(1, 0, 1, -48),
        ClipsDescendants = true
    })

    local MinBtn = createInstance('TextButton', {
        Name = 'MinimizeButton',
        Parent = Topbar,
        BackgroundColor3 = Theme.ElementBG,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.new(0, 26, 0, 26),
        AutoButtonColor = false,
        Font = Enum.Font.GothamBold,
        Text = '-',
        TextColor3 = Theme.TextSub,
        TextSize = 18,
        ZIndex = 3
    })
    createInstance('UICorner', {Parent = MinBtn, CornerRadius = UDim.new(0, 8)})
    regTheme(MinBtn, function()
        MinBtn.BackgroundColor3 = Theme.ElementBG
        MinBtn.TextColor3 = Theme.TextSub
    end)
    MinBtn.MouseEnter:Connect(function()
        TweenService:Create(MinBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Accent}):Play()
    end)
    MinBtn.MouseLeave:Connect(function()
        TweenService:Create(MinBtn, TweenInfo.new(0.2), {TextColor3 = Theme.TextSub}):Play()
    end)

    local minimized = false
    local MinimizeWindow = function(state)
        if state == nil then state = not minimized end
        minimized = state
        SearchOverlay.Visible = false
        SearchOverlay.GroupTransparency = 1
        if minimized then
            MinBtn.Text = '+'
            TweenService:Create(MainGroup, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 640, 0, 48)}):Play()
            task.delay(0.3, function() if minimized then BodyContainer.Visible = false end end)
        else
            MinBtn.Text = '-'
            BodyContainer.Visible = true
            TweenService:Create(MainGroup, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 640, 0, 410)}):Play()
        end
    end
    WindowObj.Minimize = function(self, state) MinimizeWindow(state) end
    MinBtn.MouseButton1Click:Connect(function() MinimizeWindow() end)

    local CreateTopSubTab = function(text)
        local SubContainer = createInstance('CanvasGroup', {
            Name = text .. 'Container',
            Parent = BodyContainer,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            Visible = (text == activeSubTab),
            GroupTransparency = (text == activeSubTab) and 0 or 1
        })
        MasterContainers[text] = SubContainer

        local tabBtn = createInstance('ImageButton', {
            Name = text .. 'Tab',
            Parent = SubTabs,
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Image = ''
        })

        local labelBounds = TextService:GetTextSize(text, 12, Enum.Font.GothamMedium, Vector2.new(1000, 48))
        tabBtn.Size = UDim2.new(0, labelBounds.X + 10, 1, 0)

        local tabLabel = createInstance('TextLabel', {
            Parent = tabBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = text,
            TextSize = 12,
            TextColor3 = (text == activeSubTab) and Theme.TextMain or Theme.TextSub
        })
        
        regTheme(tabLabel, function()
            if activeSubTab == text then tabLabel.TextColor3 = Theme.TextMain end
        end)

        local underline = createInstance('Frame', {
            Parent = tabBtn,
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -2),
            Size = (text == activeSubTab) and UDim2.new(1, 0, 0, 2) or UDim2.new(0, 0, 0, 2),
            BackgroundTransparency = (text == activeSubTab) and 0 or 1
        })
        
        regTheme(underline, function() underline.BackgroundColor3 = Theme.Accent end)

        tabBtn.MouseEnter:Connect(function()
            if activeSubTab ~= text then
                TweenService:Create(tabLabel, TweenInfo.new(0.2), {TextColor3 = Theme.TextMain}):Play()
                TweenService:Create(underline, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0.8, 0, 0, 2), BackgroundTransparency = 0.3}):Play()
            end
        end)

        tabBtn.MouseLeave:Connect(function()
            if activeSubTab ~= text then
                TweenService:Create(tabLabel, TweenInfo.new(0.2), {TextColor3 = Theme.TextSub}):Play()
                TweenService:Create(underline, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 2), BackgroundTransparency = 1}):Play()
            end
        end)

        tabBtn.MouseButton1Click:Connect(function()
            if activeSubTab ~= text then
                local prevActive = activeSubTab
                activeSubTab = text
                
                local prevBtn = SubTabs:FindFirstChild(prevActive .. 'Tab')
                if prevBtn then
                    TweenService:Create(prevBtn.TextLabel, TweenInfo.new(0.2), {TextColor3 = Theme.TextSub}):Play()
                    TweenService:Create(prevBtn.Frame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 2), BackgroundTransparency = 1}):Play()
                end

                TweenService:Create(tabLabel, TweenInfo.new(0.2), {TextColor3 = Theme.TextMain}):Play()
                TweenService:Create(underline, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 2), BackgroundTransparency = 0}):Play()
                
                local prevContainer = MasterContainers[prevActive]
                if prevContainer then
                    TweenService:Create(prevContainer, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0, 0, 0, -15), GroupTransparency = 1}):Play()
                    task.delay(0.25, function() if activeSubTab ~= prevActive then prevContainer.Visible = false end end)
                end

                local newContainer = MasterContainers[text]
                if newContainer then
                    newContainer.Visible = true
                    newContainer.Position = UDim2.new(0, 0, 0, 15)
                    newContainer.GroupTransparency = 1
                    TweenService:Create(newContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0), GroupTransparency = 0}):Play()
                end
            end
        end)
    end

    for i = 1, #subTabItems do CreateTopSubTab(subTabItems[i]) end

    local CreateElementBuilder = function(PageTarget, ParentTab)
        local Builder = {}

        Builder.CreateDivider = function(self)
            local DivContainer = createInstance('Frame', {
                Parent = PageTarget,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14)
            })
            local Line = createInstance('Frame', {
                Parent = DivContainer,
                BackgroundColor3 = Theme.Border,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, -20, 0, 2)
            })
            createInstance('UICorner', {Parent = Line, CornerRadius = UDim.new(0, 1)})
            regTheme(Line, function()
                if Line then Line.BackgroundColor3 = Theme.Border end
            end)
        end

        Builder.CreateButton = function(self, options)
            local BtnName = options.Name or 'Button'
            local Callback = options.Callback or function() end

            local BtnFrame = createInstance('ImageButton', {
                Parent = PageTarget,
                BackgroundColor3 = Theme.ElementBG,
                Size = UDim2.new(1, 0, 0, 40),
                AutoButtonColor = false,
                Image = ''
            })
            createInstance('UICorner', {Parent = BtnFrame, CornerRadius = UDim.new(0, 8)})
            regTheme(BtnFrame, function() BtnFrame.BackgroundColor3 = Theme.ElementBG end)

            local TextLabel = createInstance('TextLabel', {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = BtnName,
                TextColor3 = Theme.TextSub,
                TextSize = 13
            })
            regTheme(TextLabel, function() TextLabel.TextColor3 = Theme.TextSub end)

            SetupTooltip(BtnFrame, options.Tip)
            table.insert(WindowObj.ElementsList, {Name = BtnName, Frame = BtnFrame, Tab = ParentTab})

            BtnFrame.MouseEnter:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = GetDarkerColor(Theme.ElementBG, 0.8)}):Play()
                TweenService:Create(TextLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextColor3 = Theme.TextMain}):Play()
            end)
            BtnFrame.MouseLeave:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.ElementBG}):Play()
                TweenService:Create(TextLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextColor3 = Theme.TextSub}):Play()
            end)
            BtnFrame.MouseButton1Down:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.Accent}):Play()
                TweenService:Create(TextLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end)
            BtnFrame.MouseButton1Click:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = GetDarkerColor(Theme.ElementBG, 0.8)}):Play()
                Callback()
            end)
        end

        Builder.CreateTextbox = function(self, options)
            local ElementName = options.Name or 'Textbox'
            local Default = options.Default or ''
            local UseLetter = options.UseLetter
            local UseNumber = options.UseNumber
            local Callback = options.Callback or function() end

            local Element = { Value = Default }
            VibezLib.Flags[ElementName] = Element

            local Container = createInstance('Frame', {
                Parent = PageTarget,
                BackgroundColor3 = Theme.ElementBG,
                Size = UDim2.new(1, 0, 0, 40)
            })
            createInstance('UICorner', {Parent = Container, CornerRadius = UDim.new(0, 8)})
            regTheme(Container, function() Container.BackgroundColor3 = Theme.ElementBG end)
            table.insert(WindowObj.ElementsList, {Name = ElementName, Frame = Container, Tab = ParentTab})

            local labelBounds = TextService:GetTextSize(ElementName, 13, Enum.Font.GothamMedium, Vector2.new(1000, 36))

            local LabelText = createInstance('TextLabel', {
                Parent = Container,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0, labelBounds.X + 5, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = ElementName,
                TextColor3 = Theme.TextSub,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            regTheme(LabelText, function() LabelText.TextColor3 = Theme.TextSub end)

            local ValBox = createInstance('Frame', {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -6, 0.5, 0),
                Size = UDim2.new(0, 120, 0, 24)
            })
            createInstance('UICorner', {Parent = ValBox, CornerRadius = UDim.new(0, 8)})
            regTheme(ValBox, function() ValBox.BackgroundColor3 = Theme.MainBG end)
            
            local ValBoxStroke = createInstance('UIStroke', {Parent = ValBox, Color = Theme.Border})
            regTheme(ValBoxStroke, function() ValBoxStroke.Color = Theme.Border end)

            local TextBox = createInstance('TextBox', {
                Parent = ValBox,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, -6, 1, 0),
                Font = Enum.Font.Gotham,
                Text = Default,
                PlaceholderText = 'Type...',
                PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
                TextColor3 = Theme.TextMain,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
                ClearTextOnFocus = false
            })
            regTheme(TextBox, function() TextBox.TextColor3 = Theme.TextMain end)

            SetupTooltip(Container, options.Tip)

            TextBox:GetPropertyChangedSignal('Text'):Connect(function()
                local original = TextBox.Text
                local cleaned = original
                if UseLetter and not UseNumber then
                    cleaned = original:gsub('[^%a%s]', '')
                elseif UseNumber and not UseLetter then
                    cleaned = original:gsub('[^%d%.%-]', '')
                elseif UseLetter and UseNumber then
                    cleaned = original:gsub('[^%w%s%_%-]', '')
                end
                if original ~= cleaned then TextBox.Text = cleaned end
            end)

            TextBox.FocusLost:Connect(function()
                Element.Value = TextBox.Text
                VibezLib.Flags[ElementName].Value = Element.Value
                Callback(Element.Value)
            end)
            
            function Element:Set(val)
                TextBox.Text = val
                Element.Value = val
                VibezLib.Flags[ElementName].Value = val
                Callback(val)
            end

            return Element
        end

        Builder.CreateSlider = function(self, options)
            local ElementName = options.Name or 'Slider'
            local Min = options.Min or 0
            local Max = options.Max or 100
            local Default = options.Default or 35
            local Increment = options.Increment or 1
            local Suffix = options.Suffix or ''
            local Callback = options.Callback or function() end

            local Element = { Value = Default }
            VibezLib.Flags[ElementName] = Element

            local Container = createInstance('Frame', {
                Parent = PageTarget,
                BackgroundColor3 = Theme.ElementBG,
                Size = UDim2.new(1, 0, 0, 40)
            })
            createInstance('UICorner', {Parent = Container, CornerRadius = UDim.new(0, 8)})
            regTheme(Container, function() Container.BackgroundColor3 = Theme.ElementBG end)
            table.insert(WindowObj.ElementsList, {Name = ElementName, Frame = Container, Tab = ParentTab})

            local labelBounds = TextService:GetTextSize(ElementName, 13, Enum.Font.GothamMedium, Vector2.new(1000, 36))

            local LabelText = createInstance('TextLabel', {
                Parent = Container,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0, labelBounds.X + 5, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = ElementName,
                TextColor3 = Theme.TextSub,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            regTheme(LabelText, function() LabelText.TextColor3 = Theme.TextSub end)

            local ValBox = createInstance('Frame', {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -6, 0.5, 0),
                Size = UDim2.new(0, 40, 0, 22)
            })
            createInstance('UICorner', {Parent = ValBox, CornerRadius = UDim.new(0, 8)})
            regTheme(ValBox, function() ValBox.BackgroundColor3 = Theme.MainBG end)
            
            local ValBoxStroke = createInstance('UIStroke', {Parent = ValBox, Color = Theme.Border})
            regTheme(ValBoxStroke, function() ValBoxStroke.Color = Theme.Border end)

            local ValTextBox = createInstance('TextBox', {
                Parent = ValBox,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.Gotham,
                Text = tostring(Default) .. Suffix,
                TextColor3 = Theme.TextSub,
                TextSize = 11,
                ClearTextOnFocus = false
            })
            regTheme(ValTextBox, function() ValTextBox.TextColor3 = Theme.TextSub end)

            local sliderStartOffset = 12 + labelBounds.X + 15
            local sliderEndPadding = 6 + 40 + 15

            local TrackBox = createInstance('ImageButton', {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, sliderStartOffset, 0.5, 0),
                Size = UDim2.new(1, -(sliderStartOffset + sliderEndPadding), 0, 8),
                AutoButtonColor = false,
                Image = ''
            })
            createInstance('UICorner', {Parent = TrackBox, CornerRadius = UDim.new(1, 0)})
            regTheme(TrackBox, function() TrackBox.BackgroundColor3 = Theme.DropdownListStroke end)

            local FillBox = createInstance('Frame', {
                Parent = TrackBox,
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            })
            createInstance('UICorner', {Parent = FillBox, CornerRadius = UDim.new(1, 0)})
            
            regTheme(FillBox, function() FillBox.BackgroundColor3 = Theme.Accent end)

            SetupTooltip(Container, options.Tip)

            local SetValue = function(val)
                val = math.clamp(val, Min, Max)
                val = math.floor((val / Increment) + 0.5) * Increment
                local percent = (Max > Min) and (val - Min) / (Max - Min) or 0
                TweenService:Create(FillBox, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
                ValTextBox.Text = tostring(val) .. Suffix
                Element.Value = val
                VibezLib.Flags[ElementName].Value = val
                Callback(val)
            end

            local UpdateSlider = function(input)
                local percent = math.clamp((input.Position.X - TrackBox.AbsolutePosition.X) / TrackBox.AbsoluteSize.X, 0, 1)
                local value = Min + ((Max - Min) * percent)
                SetValue(value)
            end

            local dragging = false
            TrackBox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    UpdateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(input) end
            end)

            ValTextBox.FocusLost:Connect(function()
                local numStr = string.match(ValTextBox.Text, '^%-?%d+%.?%d*')
                local num = tonumber(numStr) or Default
                SetValue(num)
            end)
            
            function Element:Set(val) SetValue(val) end
            return Element
        end

        Builder.CreateToggle = function(self, options)
            local ElementName = options.Name or 'Toggle'
            local Default = options.Default or false
            local Keybind = options.Keybind
            local Callback = options.Callback or function() end
            
            local state = Default
            local currentBind = Keybind

            local Element = { Value = Default }
            VibezLib.Flags[ElementName] = Element

            local TogFrame = createInstance('ImageButton', {
                Parent = PageTarget,
                BackgroundColor3 = Theme.ElementBG,
                Size = UDim2.new(1, 0, 0, 40),
                AutoButtonColor = false,
                Image = ''
            })
            createInstance('UICorner', {Parent = TogFrame, CornerRadius = UDim.new(0, 8)})
            regTheme(TogFrame, function() TogFrame.BackgroundColor3 = Theme.ElementBG end)
            table.insert(WindowObj.ElementsList, {Name = ElementName, Frame = TogFrame, Tab = ParentTab})

            local TitleLabel = createInstance('TextLabel', {
                Parent = TogFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -120, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = ElementName,
                TextColor3 = Theme.TextSub,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            regTheme(TitleLabel, function()
                TitleLabel.TextColor3 = state and Theme.TextMain or Theme.TextSub
            end)

            local Switch = createInstance('Frame', {
                Parent = TogFrame,
                BackgroundColor3 = Theme.MainBG,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.new(0, 36, 0, 20)
            })
            createInstance('UICorner', {Parent = Switch, CornerRadius = UDim.new(1, 0)})

            local SwitchStroke = createInstance('UIStroke', {Parent = Switch, Color = Theme.Border})
            local Knob = createInstance('Frame', {
                Parent = Switch,
                BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 146, 170),
                AnchorPoint = Vector2.new(0, 0.5),
                Position = state and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                Size = UDim2.new(0, 14, 0, 14)
            })
            createInstance('UICorner', {Parent = Knob, CornerRadius = UDim.new(1, 0)})
            
            regTheme(Switch, function()
                SwitchStroke.Color = state and Theme.Accent or Theme.Border
                if state then
                    Switch.BackgroundColor3 = Theme.Accent
                    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                else
                    Switch.BackgroundColor3 = Theme.MainBG
                    Knob.BackgroundColor3 = Color3.fromRGB(150, 146, 170)
                end
            end)

            SetupTooltip(TogFrame, options.Tip)

            local FireToggle = function(skipAnim)
                local speed = skipAnim and 0 or 0.2
                TweenService:Create(Switch, TweenInfo.new(speed), {BackgroundColor3 = state and Theme.Accent or Theme.MainBG}):Play()
                TweenService:Create(SwitchStroke, TweenInfo.new(speed), {Color = state and Theme.Accent or Theme.Border}):Play()
                TweenService:Create(Knob, TweenInfo.new(speed, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = state and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 146, 170)}):Play()
                TweenService:Create(TitleLabel, TweenInfo.new(speed), {TextColor3 = state and Theme.TextMain or Theme.TextSub}):Play()
                Element.Value = state
                VibezLib.Flags[ElementName].Value = state
            end
            FireToggle(true)

            TogFrame.MouseButton1Click:Connect(function()
                state = not state
                Callback(state)
                FireToggle(false)
            end)

            if Keybind then
                local BindContainer = createInstance('Frame', {
                    Parent = TogFrame,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -55, 0.5, 0),
                    Size = UDim2.new(0, 45, 0, 22),
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                })
                createInstance('UICorner', {Parent = BindContainer, CornerRadius = UDim.new(0, 8)})
                regTheme(BindContainer, function() BindContainer.BackgroundColor3 = Theme.MainBG end)
                
                local BindContainerStroke = createInstance('UIStroke', {Parent = BindContainer, Color = Theme.Border})
                regTheme(BindContainerStroke, function() BindContainerStroke.Color = Theme.Border end)

                local BindBtn = createInstance('TextButton', {
                    Parent = BindContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = currentBind and currentBind.Name or '',
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextSub,
                    TextSize = 11
                })

                local UpdateBindSize = function()
                    local bindName = currentBind and currentBind.Name or 'None'
                    BindBtn.Text = bindName
                    local textBounds = TextService:GetTextSize(bindName, 11, Enum.Font.Gotham, Vector2.new(1000, 22))
                    BindContainer.Size = UDim2.new(0, math.max(textBounds.X + 16, 40), 0, 22)
                end
                UpdateBindSize()

                local isBinding = false
                BindBtn.MouseButton1Click:Connect(function()
                    isBinding = true
                    BindBtn.Text = '...'
                    BindContainer.Size = UDim2.new(0, 40, 0, 22)
                end)

                UserInputService.InputBegan:Connect(function(input, gpe)
                    if isBinding and (input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.Gamepad1) then
                        currentBind = input.KeyCode
                        isBinding = false
                        UpdateBindSize()
                        Callback(state)
                    elseif not gpe and currentBind and input.KeyCode == currentBind then
                        state = not state
                        Callback(state)
                        FireToggle(false)
                    end
                end)
            end
            
            function Element:Set(val)
                state = val
                Callback(state)
                FireToggle(true)
            end

            return Element
        end

        Builder.CreateDropdown = function(self, options)
            local ElementName = options.Name or 'Dropdown'
            local DropOptions = options.Options or {}
            local Default = options.Default
            local MultiSelect = options.MultiSelect or false
            local Callback = options.Callback or function() end

            local currentSelection
            if MultiSelect then
                currentSelection = {}
                if type(Default) == 'table' then
                    for i = 1, #Default do
                        table.insert(currentSelection, getStringValue(Default[i]))
                    end
                elseif type(Default) == 'string' and Default ~= '' then
                    table.insert(currentSelection, Default)
                end
            else
                if Default ~= nil then
                    currentSelection = type(Default) == 'table' and tostring(Default or '') or tostring(Default)
                else
                    currentSelection = (type(DropOptions) == 'table' and DropOptions[1] ~= nil) and tostring(DropOptions[1]) or ''
                end
                if type(currentSelection) == 'table' then currentSelection = 'None' end
            end
            
            local Element = { Value = currentSelection }
            VibezLib.Flags[ElementName] = Element

            local Container = createInstance('ImageButton', {
                Parent = PageTarget,
                BackgroundColor3 = Theme.ElementBG,
                Size = UDim2.new(1, 0, 0, 40),
                AutoButtonColor = false,
                Image = ''
            })
            createInstance('UICorner', {Parent = Container, CornerRadius = UDim.new(0, 8)})
            regTheme(Container, function() Container.BackgroundColor3 = Theme.ElementBG end)
            table.insert(WindowObj.ElementsList, {Name = ElementName, Frame = Container, Tab = ParentTab})

            local TitleLabel = createInstance('TextLabel', {
                Parent = Container,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -120, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = ElementName,
                TextColor3 = Theme.TextSub,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            regTheme(TitleLabel, function() TitleLabel.TextColor3 = Theme.TextSub end)

            local SelectedBox = createInstance('Frame', {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -6, 0.5, 0),
                Size = UDim2.new(0, 100, 0, 24)
            })
            createInstance('UICorner', {Parent = SelectedBox, CornerRadius = UDim.new(0, 8)})
            regTheme(SelectedBox, function() SelectedBox.BackgroundColor3 = Theme.MainBG end)
            
            local SelectedBoxStroke = createInstance('UIStroke', {Parent = SelectedBox, Color = Theme.Border})
            regTheme(SelectedBoxStroke, function() SelectedBoxStroke.Color = Theme.Border end)

            local SelectedLabel = createInstance('TextLabel', {
                Parent = SelectedBox,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextMain,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd
            })
            regTheme(SelectedLabel, function() SelectedLabel.TextColor3 = Theme.TextMain end)
            
            local UpdateLabel = function()
                if MultiSelect then
                    SelectedLabel.Text = #currentSelection > 0 and table.concat(currentSelection, ', ') or 'None'
                else
                    SelectedLabel.Text = (currentSelection == '' or currentSelection == nil) and 'None' or tostring(currentSelection)
                end
            end
            UpdateLabel()

            local Icon = createInstance('TextLabel', {
                Parent = SelectedBox,
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -5, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16),
                Font = Enum.Font.Gotham,
                Text = '+',
                TextColor3 = Theme.TextSub,
                TextSize = 16
            })
            regTheme(Icon, function() Icon.TextColor3 = Theme.TextSub end)

            local ListCanvas = createInstance('CanvasGroup', {
                Parent = ScreenGui,
                BackgroundTransparency = 1,
                ZIndex = 100,
                Size = UDim2.new(0, 0, 0, 0),
                GroupTransparency = 1,
                Visible = false
            })
            
            local LCScale = createInstance('UIScale', {Parent = ListCanvas, Scale = CurrentScale})
            table.insert(ScalesToUpdate, LCScale)
            createInstance('UICorner', {Parent = ListCanvas, CornerRadius = UDim.new(0, 8)})

            local ListFrame = createInstance('ScrollingFrame', {
                Parent = ListCanvas,
                BackgroundColor3 = Theme.DropdownListBG,
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 100,
                ScrollBarThickness = 2,
                BorderSizePixel = 0,
                AutomaticCanvasSize = Enum.AutomaticSize.Y
            })
            local ListFrameStroke = createInstance('UIStroke', {Parent = ListFrame, Color = Theme.DropdownListStroke})
            
            regTheme(ListFrame, function() 
                ListFrame.BackgroundColor3 = Theme.DropdownListBG
                ListFrameStroke.Color = Theme.DropdownListStroke
            end)
            
            local CanvasLayout = createInstance('Frame', {
                Parent = ListFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            })
            createInstance('UIListLayout', {Parent = CanvasLayout, SortOrder = Enum.SortOrder.LayoutOrder})

            SetupTooltip(Container, options.Tip)

            local expanded = false
            local OptionsRendered = {}

            local RefreshOptions = function()
                local cList = CanvasLayout:GetChildren()
                for i = 1, #cList do
                    local v = cList[i]
                    if v:IsA('TextButton') then v:Destroy() end
                end
                table.clear(OptionsRendered)

                for i = 1, #DropOptions do
                    local strOpt = tostring(DropOptions[i])
                    
                    local Option = createInstance('TextButton', {
                        Parent = CanvasLayout,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 26),
                        Text = '',
                        ZIndex = 101
                    })

                    local isSel = false
                    if MultiSelect then
                        isSel = table.find(currentSelection, strOpt) ~= nil
                    else
                        isSel = currentSelection == strOpt
                    end
                    
                    local OptCheck = createInstance('ImageLabel', {
                        Parent = Option,
                        BackgroundTransparency = 1,
                        Position = isSel and UDim2.new(0, 8, 0.5, -7) or UDim2.new(0, 0, 0.5, -7),
                        Size = UDim2.new(0, 14, 0, 14),
                        Image = 'rbxassetid://6031094667',
                        ImageColor3 = Theme.TextMain,
                        ImageTransparency = isSel and 0 or 1,
                        ZIndex = 101
                    })
                    regTheme(OptCheck, function() OptCheck.ImageColor3 = Theme.TextMain end)
                    
                    local OptText = createInstance('TextLabel', {
                        Parent = Option,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -30, 1, 0),
                        Position = UDim2.new(0, 28, 0, 0),
                        Font = Enum.Font.GothamMedium,
                        Text = strOpt,
                        TextColor3 = isSel and Theme.TextMain or Theme.TextSub,
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 101
                    })

                    table.insert(OptionsRendered, {
                        Value = strOpt,
                        Text = OptText,
                        Check = OptCheck,
                        Button = Option
                    })
                    
                    Option.MouseEnter:Connect(function()
                        TweenService:Create(OptText, TweenInfo.new(0.2), {TextColor3 = Theme.TextMain}):Play()
                    end)
                    Option.MouseLeave:Connect(function()
                        local active = false
                        if MultiSelect then active = table.find(currentSelection, strOpt) ~= nil else active = currentSelection == strOpt end
                        TweenService:Create(OptText, TweenInfo.new(0.2), {TextColor3 = active and Theme.TextMain or Theme.TextSub}):Play()
                    end)

                    Option.MouseButton1Click:Connect(function()
                        if MultiSelect then
                            local idx = table.find(currentSelection, strOpt)
                            if idx then 
                                table.remove(currentSelection, idx) 
                                OptText.TextColor3 = Theme.TextSub
                                TweenService:Create(OptCheck, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0.5, -7), ImageTransparency = 1}):Play()
                            else 
                                table.insert(currentSelection, strOpt) 
                                OptText.TextColor3 = Theme.TextMain
                                TweenService:Create(OptCheck, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 8, 0.5, -7), ImageTransparency = 0}):Play()
                            end
                        else
                            currentSelection = strOpt
                            expanded = false
                            TweenService:Create(Icon, TweenInfo.new(0.3), {Rotation = 0}):Play()
                            TweenService:Create(ListCanvas, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, SelectedBox.AbsoluteSize.X, 0, 0), GroupTransparency = 1}):Play()
                            task.delay(0.3, function() if not expanded then ListCanvas.Visible = false end end)
                            
                            for k = 1, #OptionsRendered do
                                local renderData = OptionsRendered[k]
                                if renderData.Value == strOpt then
                                    renderData.Text.TextColor3 = Theme.TextMain
                                    TweenService:Create(renderData.Check, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 8, 0.5, -7), ImageTransparency = 0}):Play()
                                else
                                    renderData.Text.TextColor3 = Theme.TextSub
                                    TweenService:Create(renderData.Check, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0.5, -7), ImageTransparency = 1}):Play()
                                end
                            end
                        end
                        UpdateLabel()
                        Element.Value = currentSelection
                        VibezLib.Flags[ElementName].Value = currentSelection
                        Callback(currentSelection)
                    end)
                end
                
                ListFrame.CanvasSize = UDim2.new(0, 0, 0, #DropOptions * 26)
            end

            RefreshOptions()

            Container.MouseButton1Click:Connect(function()
                expanded = not expanded
                if expanded then
                    RefreshOptions()
                    ListCanvas.Position = UDim2.new(0, SelectedBox.AbsolutePosition.X, 0, SelectedBox.AbsolutePosition.Y + (28 * CurrentScale))
                    local dropHeight = math.min(#DropOptions * 26, 150)
                    ListCanvas.Size = UDim2.new(0, SelectedBox.AbsoluteSize.X, 0, 0)
                    ListCanvas.GroupTransparency = 1
                    ListCanvas.Visible = true
                    TweenService:Create(ListCanvas, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, SelectedBox.AbsoluteSize.X, 0, dropHeight), GroupTransparency = 0}):Play()
                else
                    TweenService:Create(ListCanvas, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, SelectedBox.AbsoluteSize.X, 0, 0), GroupTransparency = 1}):Play()
                    task.delay(0.3, function() if not expanded then ListCanvas.Visible = false end end)
                end
                TweenService:Create(Icon, TweenInfo.new(0.3), {Rotation = expanded and 45 or 0}):Play()
            end)

            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local pos = input.Position
                    if expanded and ListCanvas.Visible then
                        local x1 = ListCanvas.AbsolutePosition.X
                        local y1 = ListCanvas.AbsolutePosition.Y
                        local x2 = x1 + ListCanvas.AbsoluteSize.X
                        local y2 = y1 + ListCanvas.AbsoluteSize.Y
                        local cx1 = Container.AbsolutePosition.X
                        local cy1 = Container.AbsolutePosition.Y
                        local cx2 = cx1 + Container.AbsoluteSize.X
                        local cy2 = cy1 + Container.AbsoluteSize.Y
                        
                        if not (pos.X >= x1 and pos.X <= x2 and pos.Y >= y1 and pos.Y <= y2) and not (pos.X >= cx1 and pos.X <= cx2 and pos.Y >= cy1 and pos.Y <= cy2) then
                            expanded = false
                            TweenService:Create(ListCanvas, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, SelectedBox.AbsoluteSize.X, 0, 0), GroupTransparency = 1}):Play()
                            TweenService:Create(Icon, TweenInfo.new(0.3), {Rotation = 0}):Play()
                            task.delay(0.3, function() if not expanded then ListCanvas.Visible = false end end)
                        end
                    end
                end
            end)
            
            function Element:Set(val)
                if MultiSelect then
                    currentSelection = type(val) == 'table' and val or {}
                else
                    currentSelection = getStringValue(val)
                end
                if type(currentSelection) == 'table' then currentSelection = 'None' end
                UpdateLabel()
                Element.Value = currentSelection
                VibezLib.Flags[ElementName].Value = currentSelection
                RefreshOptions()
                Callback(currentSelection)
            end

            function Element:Refresh(newOptions)
                DropOptions = type(newOptions) == 'table' and newOptions or {}
                if MultiSelect then
                    local newSel = {}
                    for i = 1, #currentSelection do
                        local v = currentSelection[i]
                        if table.find(DropOptions, v) then table.insert(newSel, v) end
                    end
                    currentSelection = newSel
                else
                    if not table.find(DropOptions, currentSelection) then
                        currentSelection = DropOptions[1] ~= nil and tostring(DropOptions[1]) or ''
                    end
                end
                if type(currentSelection) == 'table' then currentSelection = 'None' end
                UpdateLabel()
                Element.Value = currentSelection
                VibezLib.Flags[ElementName].Value = currentSelection
                RefreshOptions()
            end

            return Element
        end

        Builder.CreateColorpicker = function(self, options)
            local ElementName = options.Name or 'Colorpicker'
            local Default = options.Default or Color3.fromRGB(255, 255, 255)
            local Callback = options.Callback or function() end

            local Element = { Value = Default }
            VibezLib.Flags[ElementName] = Element
            
            local currentColor = Default
            local h, s, v = Color3.toHSV(currentColor)

            local Container = createInstance('ImageButton', {
                Parent = PageTarget,
                BackgroundColor3 = Theme.ElementBG,
                Size = UDim2.new(1, 0, 0, 40),
                AutoButtonColor = false,
                Image = ''
            })
            createInstance('UICorner', {Parent = Container, CornerRadius = UDim.new(0, 8)})
            regTheme(Container, function() Container.BackgroundColor3 = Theme.ElementBG end)
            table.insert(WindowObj.ElementsList, {Name = ElementName, Frame = Container, Tab = ParentTab})

            local TitleLabel = createInstance('TextLabel', {
                Parent = Container,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -120, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = ElementName,
                TextColor3 = Theme.TextSub,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            regTheme(TitleLabel, function() TitleLabel.TextColor3 = Theme.TextSub end)

            local ColorView = createInstance('Frame', {
                Parent = Container,
                BackgroundColor3 = currentColor,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -6, 0.5, 0),
                Size = UDim2.new(0, 40, 0, 20)
            })
            createInstance('UICorner', {Parent = ColorView, CornerRadius = UDim.new(0, 8)})
            local ColorViewStroke = createInstance('UIStroke', {Parent = ColorView, Color = Theme.Border})
            regTheme(ColorViewStroke, function() ColorViewStroke.Color = Theme.Border end)

            local FloatPicker = createInstance('Frame', {
                Parent = ScreenGui,
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                Size = UDim2.new(0, 180, 0, 190),
                ZIndex = 100,
                Visible = false
            })
            
            local FloatPickerScale = createInstance('UIScale', {Parent = FloatPicker, Scale = CurrentScale})
            table.insert(ScalesToUpdate, FloatPickerScale)

            createInstance('UICorner', {Parent = FloatPicker, CornerRadius = UDim.new(0, 12)})
            local FloatPickerStroke = createInstance('UIStroke', {Parent = FloatPicker, Color = Theme.Border})
            regTheme(FloatPickerStroke, function() FloatPickerStroke.Color = Theme.Border end)
            regTheme(FloatPicker, function() FloatPicker.BackgroundColor3 = Theme.ElementBG end)

            local SatValMap = createInstance('ImageButton', {
                Parent = FloatPicker,
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(0, 130, 0, 130),
                Image = 'rbxassetid://4155801252',
                AutoButtonColor = false
            })
            createInstance('UICorner', {Parent = SatValMap, CornerRadius = UDim.new(0, 8)})

            local SVKnob = createInstance('Frame', {
                Parent = SatValMap,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(0, 4, 0, 4),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(s, 0, 1 - v, 0)
            })
            createInstance('UICorner', {Parent = SVKnob, CornerRadius = UDim.new(1, 0)})
            createInstance('UIStroke', {Parent = SVKnob, Color = Color3.fromRGB(0, 0, 0)})

            local HueMap = createInstance('ImageButton', {
                Parent = FloatPicker,
                Position = UDim2.new(0, 150, 0, 10),
                Size = UDim2.new(0, 20, 0, 130),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                AutoButtonColor = false,
                Image = ''
            })
            createInstance('UICorner', {Parent = HueMap, CornerRadius = UDim.new(0, 8)})

            createInstance('UIGradient', {
                Parent = HueMap,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }),
                Rotation = 90
            })

            local HueKnob = createInstance('Frame', {
                Parent = HueMap,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(1, 4, 0, 4),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 1 - h, 0)
            })
            createInstance('UIStroke', {Parent = HueKnob, Color = Color3.fromRGB(0, 0, 0)})

            local HexBox = createInstance('TextBox', {
                Parent = FloatPicker,
                Position = UDim2.new(0, 10, 0, 150),
                Size = UDim2.new(0, 75, 0, 24),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.Gotham,
                TextSize = 11,
                Text = currentColor:ToHex(),
                ClearTextOnFocus = false
            })
            createInstance('UICorner', {Parent = HexBox, CornerRadius = UDim.new(0, 8)})
            regTheme(HexBox, function() HexBox.BackgroundColor3 = Theme.MainBG end)

            local RGBBox = createInstance('TextBox', {
                Parent = FloatPicker,
                Position = UDim2.new(0, 95, 0, 150),
                Size = UDim2.new(0, 75, 0, 24),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.Gotham,
                TextSize = 11,
                Text = math.floor(currentColor.R*255)..', '..math.floor(currentColor.G*255)..', '..math.floor(currentColor.B*255),
                ClearTextOnFocus = false
            })
            createInstance('UICorner', {Parent = RGBBox, CornerRadius = UDim.new(0, 8)})
            regTheme(RGBBox, function() RGBBox.BackgroundColor3 = Theme.MainBG end)

            SetupTooltip(Container, options.Tip)

            local UpdateColor = function()
                currentColor = Color3.fromHSV(h, s, v)
                ColorView.BackgroundColor3 = currentColor
                SatValMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                HexBox.Text = currentColor:ToHex()
                RGBBox.Text = math.floor(currentColor.R*255)..', '..math.floor(currentColor.G*255)..', '..math.floor(currentColor.B*255)
                Element.Value = currentColor
                VibezLib.Flags[ElementName].Value = currentColor
                Callback(currentColor)
            end

            HexBox.FocusLost:Connect(function()
                local success, color = pcall(function() return Color3.fromHex(HexBox.Text) end)
                if success then
                    currentColor = color
                    h, s, v = Color3.toHSV(currentColor)
                    SVKnob.Position = UDim2.new(s, 0, 1 - v, 0)
                    HueKnob.Position = UDim2.new(0.5, 0, 1 - h, 0)
                    UpdateColor()
                else
                    HexBox.Text = currentColor:ToHex()
                end
            end)

            RGBBox.FocusLost:Connect(function()
                local r, g, b = RGBBox.Text:match('(%d+)[%s,]+(%d+)[%s,]+(%d+)')
                if r and g and b then
                    currentColor = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
                    h, s, v = Color3.toHSV(currentColor)
                    SVKnob.Position = UDim2.new(s, 0, 1 - v, 0)
                    HueKnob.Position = UDim2.new(0.5, 0, 1 - h, 0)
                    UpdateColor()
                else
                    RGBBox.Text = math.floor(currentColor.R*255)..', '..math.floor(currentColor.G*255)..', '..math.floor(currentColor.B*255)
                end
            end)

            local draggingSV = false
            SatValMap.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSV = true end
            end)
            local draggingHue = false
            HueMap.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingHue = true end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSV = false
                    draggingHue = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    if draggingSV then
                        local pctX = math.clamp((input.Position.X - SatValMap.AbsolutePosition.X) / SatValMap.AbsoluteSize.X, 0, 1)
                        local pctY = math.clamp((input.Position.Y - SatValMap.AbsolutePosition.Y) / SatValMap.AbsoluteSize.Y, 0, 1)
                        s = pctX
                        v = 1 - pctY
                        SVKnob.Position = UDim2.new(s, 0, 1 - v, 0)
                        UpdateColor()
                    elseif draggingHue then
                        local pctY = math.clamp((input.Position.Y - HueMap.AbsolutePosition.Y) / HueMap.AbsoluteSize.Y, 0, 1)
                        h = 1 - pctY
                        HueKnob.Position = UDim2.new(0.5, 0, 1 - h, 0)
                        UpdateColor()
                    end
                end
            end)

            Container.MouseButton1Click:Connect(function()
                FloatPicker.Position = UDim2.new(0, ColorView.AbsolutePosition.X - (140 * CurrentScale), 0, ColorView.AbsolutePosition.Y + (28 * CurrentScale))
                FloatPicker.Visible = not FloatPicker.Visible
            end)

            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local pos = input.Position
                    if FloatPicker.Visible then
                        local x1, y1 = FloatPicker.AbsolutePosition.X, FloatPicker.AbsolutePosition.Y
                        local x2, y2 = x1 + FloatPicker.AbsoluteSize.X, y1 + FloatPicker.AbsoluteSize.Y
                        local cx1, cy1 = Container.AbsolutePosition.X, Container.AbsolutePosition.Y
                        local cx2, cy2 = cx1 + Container.AbsoluteSize.X, cy1 + Container.AbsoluteSize.Y
                        if not (pos.X >= x1 and pos.X <= x2 and pos.Y >= y1 and pos.Y <= y2) and not (pos.X >= cx1 and pos.X <= cx2 and pos.Y >= cy1 and pos.Y <= cy2) then
                            FloatPicker.Visible = false
                        end
                    end
                end
            end)
            
            function Element:Set(val)
                currentColor = val
                h, s, v = Color3.toHSV(currentColor)
                SVKnob.Position = UDim2.new(s, 0, 1 - v, 0)
                HueKnob.Position = UDim2.new(0.5, 0, 1 - h, 0)
                UpdateColor()
            end

            return Element
        end

        Builder.CreateKeybind = function(self, options)
            local ElementName = options.Name or 'Keybind'
            local Default = options.Default or Enum.KeyCode.E
            local Callback = options.Callback or function() end
            local currentBind = Default
            
            local Element = { Value = currentBind }
            VibezLib.Flags[ElementName] = Element

            local BindFrame = createInstance('Frame', {
                Parent = PageTarget,
                BackgroundColor3 = Theme.ElementBG,
                Size = UDim2.new(1, 0, 0, 40)
            })
            createInstance('UICorner', {Parent = BindFrame, CornerRadius = UDim.new(0, 8)})
            regTheme(BindFrame, function() BindFrame.BackgroundColor3 = Theme.ElementBG end)
            table.insert(WindowObj.ElementsList, {Name = ElementName, Frame = BindFrame, Tab = ParentTab})

            local TitleLabel = createInstance('TextLabel', {
                Parent = BindFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -120, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = ElementName,
                TextColor3 = Theme.TextSub,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            regTheme(TitleLabel, function() TitleLabel.TextColor3 = Theme.TextSub end)

            local BindContainer = createInstance('Frame', {
                Parent = BindFrame,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -6, 0.5, 0),
                Size = UDim2.new(0, 60, 0, 22),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            })
            createInstance('UICorner', {Parent = BindContainer, CornerRadius = UDim.new(0, 8)})
            regTheme(BindContainer, function() BindContainer.BackgroundColor3 = Theme.MainBG end)
            
            local BindContainerStroke = createInstance('UIStroke', {Parent = BindContainer, Color = Theme.Border})
            regTheme(BindContainerStroke, function() BindContainerStroke.Color = Theme.Border end)

            local BindBtn = createInstance('TextButton', {
                Parent = BindContainer,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = currentBind.Name,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextSub,
                TextSize = 11
            })

            SetupTooltip(BindFrame, options.Tip)

            local UpdateBindSize = function()
                local bindName = currentBind and currentBind.Name or 'None'
                BindBtn.Text = bindName
                local textBounds = TextService:GetTextSize(bindName, 11, Enum.Font.Gotham, Vector2.new(1000, 22))
                BindContainer.Size = UDim2.new(0, math.max(textBounds.X + 16, 40), 0, 22)
            end
            UpdateBindSize()

            local isBinding = false
            BindBtn.MouseButton1Click:Connect(function()
                isBinding = true
                BindBtn.Text = '...'
                BindContainer.Size = UDim2.new(0, 40, 0, 22)
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if isBinding and (input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.Gamepad1) then
                    currentBind = input.KeyCode
                    isBinding = false
                    UpdateBindSize()
                    
                    Element.Value = currentBind
                    VibezLib.Flags[ElementName].Value = currentBind
                    Callback(currentBind)
                end
            end)
            
            function Element:Set(val)
                currentBind = val
                UpdateBindSize()
                Element.Value = currentBind
                VibezLib.Flags[ElementName].Value = currentBind
                Callback(currentBind)
            end

            return Element
        end

        return setmetatable(Builder, {__index = Builder})
    end

    local HomeBody = MasterContainers['Home']
    local Sidebar = createInstance('ScrollingFrame', {
        Parent = HomeBody,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 160, 1, 0),
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })

    createInstance('UIListLayout', {
        Parent = Sidebar,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4)
    })
    
    createInstance('UIPadding', {
        Parent = Sidebar,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8)
    })

    local ContentContainer = createInstance('Frame', {
        Parent = HomeBody,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 160, 0, 0),
        Size = UDim2.new(1, -160, 1, 0)
    })

    WindowObj.CreateTab = function(self, options)
        local TabName = options.Name or 'Tab'
        local TabIconId = options.Icon or 'rbxassetid://6034502844'

        local TabBtn = createInstance('ImageButton', {
            Parent = Sidebar,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 40),
            AutoButtonColor = false,
            Image = ''
        })
        createInstance('UICorner', {Parent = TabBtn, CornerRadius = UDim.new(0, 8)})

        local TabGradient = createInstance('UIGradient', {
            Parent = TabBtn,
            Color = ColorSequence.new(Theme.Accent),
            Offset = Vector2.new(-1, 0),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.7),
                NumberSequenceKeypoint.new(0.7, 0.95),
                NumberSequenceKeypoint.new(1, 1)
            })
        })
        regTheme(TabGradient, function()
            TabGradient.Color = ColorSequence.new(Theme.Accent)
        end)

        local IconImg = createInstance('ImageLabel', {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0.5, -9),
            Size = UDim2.new(0, 18, 0, 18),
            Image = TabIconId,
            ImageColor3 = Theme.TextSub
        })

        local TextLabel = createInstance('TextLabel', {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 40, 0, 0),
            Size = UDim2.new(1, -40, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = TabName,
            TextColor3 = Theme.TextSub,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        TabBtn.MouseEnter:Connect(function()
            if not (WindowObj.CurrentTab and WindowObj.CurrentTab.Name == TabName) then
                TweenService:Create(TextLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                TweenService:Create(IconImg, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(210, 210, 210)}):Play()
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if not (WindowObj.CurrentTab and WindowObj.CurrentTab.Name == TabName) then
                TweenService:Create(TextLabel, TweenInfo.new(0.2), {TextColor3 = Theme.TextSub}):Play()
                TweenService:Create(IconImg, TweenInfo.new(0.2), {ImageColor3 = Theme.TextSub}):Play()
            end
        end)

        local PageGroup = createInstance('CanvasGroup', {
            Parent = ContentContainer,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 50, 0, 0),
            BackgroundTransparency = 1,
            GroupTransparency = 1,
            BorderSizePixel = 0,
            Visible = false
        })

        local Page = createInstance('ScrollingFrame', {
            Parent = PageGroup,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Border,
            BorderSizePixel = 0,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        regTheme(Page, function() Page.ScrollBarImageColor3 = Theme.Border end)
        
        createInstance('UIPadding', {
            Parent = Page,
            PaddingTop = UDim.new(0, 15),
            PaddingLeft = UDim.new(0, 20),
            PaddingRight = UDim.new(0, 20)
        })

        createInstance('UIListLayout', {
            Parent = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })

        local TabObj = { Name = TabName, Page = Page, Select = nil }
        local Builder = CreateElementBuilder(Page, TabObj)

        TabObj.Select = function()
            if WindowObj.CurrentTab == TabObj then return end
            if WindowObj.CurrentTab then 
                WindowObj.CurrentTab.Unselect() 
            end
            WindowObj.CurrentTab = TabObj
            
            PageGroup.Visible = true
            PageGroup.Position = UDim2.new(0, 50, 0, 0)
            PageGroup.GroupTransparency = 1
            TweenService:Create(PageGroup, TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0), GroupTransparency = 0}):Play()
            
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            TweenService:Create(TabGradient, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Offset = Vector2.new(0, 0)}):Play()
            TweenService:Create(TextLabel, TweenInfo.new(0.2), {TextColor3 = Theme.TextMain}):Play()
            TweenService:Create(IconImg, TweenInfo.new(0.2), {ImageColor3 = Theme.TextMain}):Play()
        end

        TabObj.Unselect = function()
            TweenService:Create(PageGroup, TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, -50, 0, 0), GroupTransparency = 1}):Play()
            task.delay(0.65, function() if WindowObj.CurrentTab ~= TabObj then PageGroup.Visible = false end end)

            TweenService:Create(TabGradient, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Offset = Vector2.new(-1, 0)}):Play()
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            TweenService:Create(TextLabel, TweenInfo.new(0.2), {TextColor3 = Theme.TextSub}):Play()
            TweenService:Create(IconImg, TweenInfo.new(0.2), {ImageColor3 = Theme.TextSub}):Play()
        end

        TabBtn.MouseButton1Click:Connect(TabObj.Select)

        if #WindowObj.Tabs == 0 then TabObj.Select() end
        table.insert(WindowObj.Tabs, TabObj)

        return setmetatable(TabObj, {__index = Builder})
    end

    local MakeSubTabElements = function(TabName)
        local parentGrp = MasterContainers[TabName]
        local Page = createInstance('ScrollingFrame', {
            Parent = parentGrp,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Border,
            BorderSizePixel = 0,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        createInstance('UIPadding', {
            Parent = Page,
            PaddingTop = UDim.new(0, 15),
            PaddingLeft = UDim.new(0, 20),
            PaddingRight = UDim.new(0, 20)
        })
        createInstance('UIListLayout', {
            Parent = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })
        regTheme(Page, function() Page.ScrollBarImageColor3 = Theme.Border end)
        return CreateElementBuilder(Page, {Name = TabName, Page = Page, Select = function()
            if activeSubTab ~= TabName then
                local btn = SubTabs:FindFirstChild(TabName .. 'Tab')
                if btn then
                    local subChildren = SubTabs:GetChildren()
                    for i = 1, #subChildren do
                        local child = subChildren[i]
                        if child:IsA('ImageButton') and child.Name ~= TabName .. 'Tab' then
                            TweenService:Create(child.TextLabel, TweenInfo.new(0.2), {TextColor3 = Theme.TextSub}):Play()
                            TweenService:Create(child.Frame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 2), BackgroundTransparency = 1}):Play()
                            local oc = MasterContainers[child.Name:sub(1, -4)]
                            if oc then
                                TweenService:Create(oc, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0, 0, 0, -15), GroupTransparency = 1}):Play()
                                task.delay(0.25, function() oc.Visible = false end)
                            end
                        end
                    end
                    activeSubTab = TabName
                    TweenService:Create(btn.TextLabel, TweenInfo.new(0.2), {TextColor3 = Theme.TextMain}):Play()
                    TweenService:Create(btn.Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 2), BackgroundTransparency = 0}):Play()
                    local nc = MasterContainers[TabName]
                    if nc then
                        nc.Visible = true
                        nc.Position = UDim2.new(0, 0, 0, 15)
                        nc.GroupTransparency = 1
                        TweenService:Create(nc, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0), GroupTransparency = 0}):Play()
                    end
                end
            end
        end})
    end

    WindowObj.UISettings = MakeSubTabElements('UI Settings')
    
    WindowObj.UISettings:CreateKeybind({
        Name = 'Menu Visible Keybind',
        Default = MenuKeybind,
        Callback = function(key) MenuKeybind = key end
    })
    
    local themeNamesList = {}
    for name, _ in pairs(Themes) do
        table.insert(themeNamesList, name)
    end
    table.sort(themeNamesList)

    WindowObj.UISettings:CreateDropdown({
        Name = 'Select UI Theme',
        Options = themeNamesList,
        Default = defaultTheme,
        Callback = function(selectedTheme)
            ApplySelectedTheme(selectedTheme)
        end
    })
    
    local AccentColorElement
    AccentColorElement = WindowObj.UISettings:CreateColorpicker({
        Name = 'Accent Color',
        Default = Theme.Accent,
        Callback = function(color) 
            if not VibezLib.RainbowAccent then
                UpdateThemeAccent(color) 
            end
        end
    })

    WindowObj.UISettings:CreateToggle({
        Name = 'Rainbow Accent',
        Default = false,
        Callback = function(val)
            VibezLib.RainbowAccent = val
            if not val and AccentColorElement then
                UpdateThemeAccent(AccentColorElement.Value)
            end
        end
    })

    WindowObj.UISettings:CreateSlider({
        Name = 'Rainbow Speed',
        Min = 1,
        Max = 20,
        Default = 5,
        Increment = 1,
        Suffix = '',
        Callback = function(val)
            VibezLib.RainbowSpeed = val
        end
    })

    WindowObj.UISettings:CreateButton({
        Name = 'Randomize Theme',
        Callback = function()
            local baseHue = math.random()
            local bgSaturation = math.random() * 0.2
            local bgValue = math.random() * 0.15 + 0.05
            
            Theme.MainBG = Color3.fromHSV(baseHue, bgSaturation, bgValue)
            Theme.SidebarBG = Color3.fromHSV(baseHue, bgSaturation, math.clamp(bgValue + 0.02, 0, 1))
            Theme.TopbarBG = Color3.fromHSV(baseHue, bgSaturation, math.clamp(bgValue - 0.02, 0, 1))
            Theme.ElementBG = Color3.fromHSV(baseHue, bgSaturation, math.clamp(bgValue + 0.05, 0, 1))
            Theme.Border = Color3.fromHSV(baseHue, bgSaturation, math.clamp(bgValue + 0.1, 0, 1))
            Theme.DropdownListBG = Theme.ElementBG
            Theme.DropdownListStroke = Theme.Border
            
            local acH = (baseHue + math.random() * 0.5) % 1
            Theme.Accent = Color3.fromHSV(acH, 0.8, 0.9)
            
            Theme.TextMain = Color3.fromRGB(240, 240, 240)
            Theme.TextSub = Color3.fromRGB(160, 160, 160)

            local alive = {}
            for i = 1, #VibezLib.ThemeConnections do
                local func = VibezLib.ThemeConnections[i]
                if type(func) == 'function' then
                    local s, res = pcall(func)
                    if s and res ~= false then 
                        table.insert(alive, func) 
                    end
                end
            end
            VibezLib.ThemeConnections = alive
        end
    })

    WindowObj.UISettings:CreateToggle({
        Name = 'Notifications & Tooltips',
        Default = true,
        Callback = function(val) 
            VibezLib.ShowNotifications = val 
            VibezLib.ShowTooltips = val 
        end
    })

    WindowObj.UISettings:CreateSlider({
        Name = 'Window Scale',
        Min = 50,
        Max = 150,
        Default = 100,
        Increment = 5,
        Suffix = '%',
        Callback = function(val) WindowObj:UpdateScale(val / 100) end
    })

    WindowObj.Configs = MakeSubTabElements('Configs')
    local ConfigName = 'default'
    local ConfigFolder = 'vibez/' .. tostring(game.GameId)
    local SecureFolder = function()
        if makefolder then
            if not isfolder('vibez') then makefolder('vibez') end
            if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
        end
    end
    local RefreshConfigs = function(dropdownObj)
        if not listfiles then return end
        SecureFolder()
        local list = {}
        local success, files = pcall(function() return listfiles(ConfigFolder) end)
        if success and type(files) == 'table' then
            for i = 1, #files do
                local file = files[i]
                if type(file) == 'string' then
                    local match = file:match('([^/\\\\]+)%.json$')
                    if match then table.insert(list, match) end
                elseif type(file) == 'table' then
                    local path = file.Path or file.path or file.Name or file.name or tostring(file)
                    if type(path) == 'string' then
                        local match = path:match('([^/\\\\]+)%.json$')
                        if match then table.insert(list, match) end
                    end
                end
            end
        end
        dropdownObj:Refresh(list)
    end

    local CfgTextBox = WindowObj.Configs:CreateTextbox({
        Name = 'Config Name',
        UseLetter = true,
        UseNumber = true,
        Callback = function(txt) ConfigName = txt end
    })

    local AutoloadTog
    local isAutoload = (readfile and isfile and isfile('vibez_autoload.txt') and readfile('vibez_autoload.txt') == ConfigName) or false
    
    AutoloadTog = WindowObj.Configs:CreateToggle({
        Name = 'Autoload',
        Default = isAutoload,
        Callback = function(val)
            if writefile then
                SecureFolder()
                if val then
                    writefile('vibez_autoload.txt', ConfigName)
                else
                    if isfile and delfile and isfile('vibez_autoload.txt') then
                        delfile('vibez_autoload.txt')
                    end
                end
            end
        end
    })

    local ConfigDrop
    WindowObj.Configs:CreateButton({
        Name = 'Save Config',
        Callback = function()
            if writefile and ConfigName and ConfigName ~= '' then
                SecureFolder()
                local data = {}
                for k,v in pairs(VibezLib.Flags) do 
                    data[k] = SerializeValue(v.Value) 
                end
                writefile(ConfigFolder .. '/' .. ConfigName .. '.json', HttpService:JSONEncode(data))
                if ConfigDrop then RefreshConfigs(ConfigDrop) end
            end
        end
    })

    WindowObj.Configs:CreateButton({
        Name = 'Load Config',
        Callback = function()
            if readfile and isfile and isfile(ConfigFolder .. '/' .. ConfigName .. '.json') then
                local success, data = pcall(function()
                    return HttpService:JSONDecode(readfile(ConfigFolder .. '/' .. ConfigName .. '.json'))
                end)
                if success and type(data) == 'table' then
                    for k,v in pairs(data) do
                        local flagElement = VibezLib.Flags[k]
                        if flagElement then 
                            local decodedVal = DeserializeValue(v)
                            if decodedVal ~= nil then
                                flagElement:Set(decodedVal)
                            end
                        end
                    end
                end
            end
        end
    })

    ConfigDrop = WindowObj.Configs:CreateDropdown({
        Name = 'View Configs',
        Options = {},
        Callback = function(sel) 
            ConfigName = sel 
            if AutoloadTog then
                local activeAuto = (readfile and isfile and isfile('vibez_autoload.txt') and readfile('vibez_autoload.txt') == ConfigName) or false
                AutoloadTog:Set(activeAuto)
            end
        end
    })
    RefreshConfigs(ConfigDrop)

    WindowObj.Configs:CreateButton({
        Name = 'Delete Config',
        Callback = function()
            if delfile and isfile and isfile(ConfigFolder .. '/' .. ConfigName .. '.json') then
                delfile(ConfigFolder .. '/' .. ConfigName .. '.json')
                if ConfigDrop then RefreshConfigs(ConfigDrop) end
            end
        end
    })

    ApplySelectedTheme(defaultTheme)

    task.spawn(function()
        if readfile and isfile and isfile('vibez_autoload.txt') then
            local autoCfg = readfile('vibez_autoload.txt')
            local filePath = ConfigFolder .. '/' .. autoCfg .. '.json'
            if isfile(filePath) then
                local success, data = pcall(function()
                    return HttpService:JSONDecode(readfile(filePath))
                end)
                if success and type(data) == 'table' then
                    task.wait(0.5)
                    for k,v in pairs(data) do
                        local flagElement = VibezLib.Flags[k]
                        if flagElement then 
                            local decodedVal = DeserializeValue(v)
                            if decodedVal ~= nil then
                                flagElement:Set(decodedVal)
                            end
                        end
                    end
                end
            end
        end
    end)

    local connection
    connection = RunService.RenderStepped:Connect(function()
        local success, hasParent = pcall(function() return ScreenGui and ScreenGui.Parent end)
        if not success or not hasParent then
            if connection then connection:Disconnect() end
            return
        end
    end)

    return WindowObj
end

-- expose for game modules
VibezLib.Theme = Theme
VibezLib.Version = '1.0.0'
pcall(function()
    local env = (getgenv and getgenv()) or _G
    env.VibezLib = VibezLib
end)

return VibezLib
