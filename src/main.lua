local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

local Player = Players.LocalPlayer

local Lucide = loadstring(game:HttpGet("https://cdn.jsdelivr.net/gh/melatonin-rs/lucide-luau@main/src/init.luau"))()

local Guintosh = {}

local Theme = {
    Background = Color3.fromRGB(18, 18, 21),
    Surface = Color3.fromRGB(25, 25, 29),
    Surface2 = Color3.fromRGB(31, 31, 36),
    Surface3 = Color3.fromRGB(38, 38, 44),
    Border = Color3.fromRGB(58, 58, 66),
    Text = Color3.fromRGB(245, 245, 248),
    SubText = Color3.fromRGB(155, 155, 165),
    Muted = Color3.fromRGB(105, 105, 115),
    Accent = Color3.fromRGB(112, 92, 255),
    Accent2 = Color3.fromRGB(142, 125, 255),
    Success = Color3.fromRGB(75, 205, 125),
    Warning = Color3.fromRGB(245, 180, 75),
    Error = Color3.fromRGB(245, 85, 95),
    White = Color3.fromRGB(255, 255, 255)
}

local function Tween(instance, properties, duration, style, direction)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(
            duration or 0.2,
            style or Enum.EasingStyle.Quint,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )
    tween:Play()
    return tween
end

local function Corner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = instance
    return corner
end

local function Stroke(instance, color, transparency, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Transparency = transparency or 0
    stroke.Thickness = thickness or 1
    stroke.Parent = instance
    return stroke
end

local function Padding(instance, top, right, bottom, left)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingRight = UDim.new(0, right or 0)
    padding.PaddingBottom = UDim.new(0, bottom or 0)
    padding.PaddingLeft = UDim.new(0, left or 0)
    padding.Parent = instance
    return padding
end

local function Icon(parent, name, size)
    local image = Instance.new("ImageLabel")
    image.BackgroundTransparency = 1
    image.Size = UDim2.fromOffset(size or 20, size or 20)
    image.Image = Lucide.get(name)
    image.ImageColor3 = Theme.Text
    image.Parent = parent
    return image
end

local function MakeDraggable(handle, object, callback)
    local dragging = false
    local dragStart
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart

            local position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )

            object.Position = position

            if callback then
                callback(position)
            end
        end
    end)
end

local function GetGuiParent()
    local success, result = pcall(function()
        return game:GetService("CoreGui")
    end)

    if success and result then
        return result
    end

    return Player:WaitForChild("PlayerGui")
end

function Guintosh:CreateWindow(title, options)
    options = options or {}

    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Notifications = {},
        NotificationCount = 0,
        Minimized = false,
        Maximized = false,
        Visible = true
    }

    local size = options.Size or {
        X = 720,
        Y = 480
    }

    local gui = Instance.new("ScreenGui")
    gui.Name = "Guintosh"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = GetGuiParent()

    Window.Gui = gui

    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.fromScale(0.5, 0.5)
    shadow.Size = UDim2.fromOffset(size.X + 18, size.Y + 18)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.45
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 1
    shadow.Parent = gui
    Corner(shadow, 18)

    local window = Instance.new("Frame")
    window.Name = "Window"
    window.AnchorPoint = Vector2.new(0.5, 0.5)
    window.Position = UDim2.fromScale(0.5, 0.5)
    window.Size = UDim2.fromOffset(size.X, size.Y)
    window.BackgroundColor3 = Theme.Background
    window.BorderSizePixel = 0
    window.ClipsDescendants = true
    window.ZIndex = 2
    window.Parent = gui
    Corner(window, 15)

    local windowStroke = Stroke(window, Theme.Border, 0.15, 1)

    Window.Window = window
    Window.Outline = windowStroke
    Window.Shadow = shadow

    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Size = UDim2.new(1, 0, 0, 52)
    topbar.BackgroundTransparency = 1
    topbar.ZIndex = 5
    topbar.Parent = window

    local traffic = Instance.new("Frame")
    traffic.Size = UDim2.fromOffset(76, 52)
    traffic.BackgroundTransparency = 1
    traffic.Parent = topbar

    local trafficLayout = Instance.new("UIListLayout")
    trafficLayout.FillDirection = Enum.FillDirection.Horizontal
    trafficLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    trafficLayout.Padding = UDim.new(0, 7)
    trafficLayout.Parent = traffic

    Padding(traffic, 0, 0, 0, 17)

    local function TrafficButton(color, symbol, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.fromOffset(13, 13)
        button.BackgroundColor3 = color
        button.Text = ""
        button.AutoButtonColor = false
        button.Parent = traffic
        Corner(button, 20)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.fromScale(1, 1)
        label.BackgroundTransparency = 1
        label.Text = symbol
        label.TextColor3 = Color3.fromRGB(45, 45, 45)
        label.TextTransparency = 1
        label.TextSize = 9
        label.Font = Enum.Font.GothamBold
        label.Parent = button

        button.MouseEnter:Connect(function()
            Tween(button, {
                Size = UDim2.fromOffset(15, 15)
            }, 0.12)

            Tween(label, {
                TextTransparency = 0
            }, 0.12)
        end)

        button.MouseLeave:Connect(function()
            Tween(button, {
                Size = UDim2.fromOffset(13, 13)
            }, 0.12)

            Tween(label, {
                TextTransparency = 1
            }, 0.12)
        end)

        button.MouseButton1Click:Connect(callback)

        return button
    end

    local closeButton = TrafficButton(
        Color3.fromRGB(255, 95, 87),
        "×",
        function()
            Window:Destroy()
        end
    )

    local minimizeButton = TrafficButton(
        Color3.fromRGB(255, 189, 46),
        "−",
        function()
            Window:SetMinimized(not Window.Minimized)
        end
    )

    local maximizeButton = TrafficButton(
        Color3.fromRGB(39, 201, 63),
        "+",
        function()
            Window:SetMaximized(not Window.Maximized)
        end
    )

    local titleLabel = Instance.new("TextLabel")
    titleLabel.AnchorPoint = Vector2.new(0.5, 0)
    titleLabel.Position = UDim2.new(0.5, 0, 0, 15)
    titleLabel.Size = UDim2.fromOffset(280, 24)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Guintosh"
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Parent = topbar

    local version = Instance.new("TextLabel")
    version.Position = UDim2.new(1, -105, 0, 18)
    version.Size = UDim2.fromOffset(80, 18)
    version.BackgroundTransparency = 1
    version.Text = "Guintosh"
    version.TextColor3 = Theme.Muted
    version.TextSize = 11
    version.Font = Enum.Font.Gotham
    version.TextXAlignment = Enum.TextXAlignment.Right
    version.Parent = topbar

    MakeDraggable(topbar, window, function(position)
        shadow.Position = position
    end)

    local body = Instance.new("Frame")
    body.Position = UDim2.fromOffset(0, 52)
    body.Size = UDim2.new(1, 0, 1, -52)
    body.BackgroundTransparency = 1
    body.Parent = window

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.fromOffset(190, 1)
    sidebar.BackgroundColor3 = Theme.Surface
    sidebar.BorderSizePixel = 0
    sidebar.Parent = body

    local sidebarLine = Instance.new("Frame")
    sidebarLine.Position = UDim2.new(1, -1, 0, 0)
    sidebarLine.Size = UDim2.new(0, 1, 1, 0)
    sidebarLine.BackgroundColor3 = Theme.Border
    sidebarLine.BackgroundTransparency = 0.35
    sidebarLine.BorderSizePixel = 0
    sidebarLine.Parent = sidebar

    local brand = Instance.new("Frame")
    brand.Size = UDim2.new(1, 0, 0, 68)
    brand.BackgroundTransparency = 1
    brand.Parent = sidebar

    local brandIconHolder = Instance.new("Frame")
    brandIconHolder.Position = UDim2.fromOffset(15, 17)
    brandIconHolder.Size = UDim2.fromOffset(34, 34)
    brandIconHolder.BackgroundColor3 = Theme.Accent
    brandIconHolder.Parent = brand
    Corner(brandIconHolder, 10)

    local brandIcon = Icon(brandIconHolder, "command", 18)
    brandIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    brandIcon.Position = UDim2.fromScale(0.5, 0.5)

    local brandText = Instance.new("TextLabel")
    brandText.Position = UDim2.fromOffset(58, 14)
    brandText.Size = UDim2.fromOffset(115, 22)
    brandText.BackgroundTransparency = 1
    brandText.Text = "Guintosh"
    brandText.TextColor3 = Theme.Text
    brandText.TextSize = 15
    brandText.Font = Enum.Font.GothamBold
    brandText.TextXAlignment = Enum.TextXAlignment.Left
    brandText.Parent = brand

    local brandSub = Instance.new("TextLabel")
    brandSub.Position = UDim2.fromOffset(58, 34)
    brandSub.Size = UDim2.fromOffset(115, 18)
    brandSub.BackgroundTransparency = 1
    brandSub.Text = "macOS inspired"
    brandSub.TextColor3 = Theme.Muted
    brandSub.TextSize = 10
    brandSub.Font = Enum.Font.Gotham
    brandSub.TextXAlignment = Enum.TextXAlignment.Left
    brandSub.Parent = brand

    local tabHolder = Instance.new("ScrollingFrame")
    tabHolder.Position = UDim2.fromOffset(8, 68)
    tabHolder.Size = UDim2.new(1, -16, 1, -78)
    tabHolder.BackgroundTransparency = 1
    tabHolder.BorderSizePixel = 0
    tabHolder.ScrollBarThickness = 2
    tabHolder.ScrollBarImageColor3 = Theme.Border
    tabHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabHolder.CanvasSize = UDim2.new()
    tabHolder.Parent = sidebar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabHolder

    local pageHolder = Instance.new("Frame")
    pageHolder.Position = UDim2.fromOffset(190, 0)
    pageHolder.Size = UDim2.new(1, -190, 1, 0)
    pageHolder.BackgroundTransparency = 1
    pageHolder.ClipsDescendants = true
    pageHolder.Parent = body

    local search = Instance.new("TextBox")
    search.Position = UDim2.new(1, -190, 0, 11)
    search.Size = UDim2.fromOffset(172, 32)
    search.BackgroundColor3 = Theme.Surface
    search.BorderSizePixel = 0
    search.Text = ""
    search.PlaceholderText = "Search..."
    search.PlaceholderColor3 = Theme.Muted
    search.TextColor3 = Theme.Text
    search.TextSize = 12
    search.Font = Enum.Font.Gotham
    search.ClearTextOnFocus = false
    search.Parent = pageHolder
    Corner(search, 9)
    Stroke(search, Theme.Border, 0.3)

    local searchIcon = Icon(search, "search", 15)
    searchIcon.Position = UDim2.fromOffset(10, 8)

    search:GetPropertyChangedSignal("Text"):Connect(function()
        local query = search.Text:lower()

        if Window.CurrentTab and Window.CurrentTab.Components then
            for _, component in ipairs(Window.CurrentTab.Components) do
                if component.SearchObject then
                    local visible = query == "" or component.SearchObject:lower():find(query, 1, true) ~= nil
                    component.Container.Visible = visible
                end
            end
        end
    end)

    function Window:SelectTab(tab)
        for _, other in ipairs(self.Tabs) do
            other.Page.Visible = false
            Tween(other.Button, {
                BackgroundColor3 = Theme.Surface
            }, 0.15)
            Tween(other.Icon, {
                ImageColor3 = Theme.SubText
            }, 0.15)
            Tween(other.Label, {
                TextColor3 = Theme.SubText
            }, 0.15)
        end

        tab.Page.Visible = true

        Tween(tab.Button, {
            BackgroundColor3 = Theme.Surface3
        }, 0.15)

        Tween(tab.Icon, {
            ImageColor3 = Theme.Text
        }, 0.15)

        Tween(tab.Label, {
            TextColor3 = Theme.Text
        }, 0.15)

        self.CurrentTab = tab
        search.Text = ""
    end

    function Window:CreateTab(name, iconName)
        local Tab = {
            Name = name,
            Components = {}
        }

        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, 0, 0, 39)
        tabButton.BackgroundColor3 = Theme.Surface
        tabButton.BorderSizePixel = 0
        tabButton.Text = ""
        tabButton.AutoButtonColor = false
        tabButton.Parent = tabHolder
        Corner(tabButton, 9)

        local tabIcon = Icon(tabButton, iconName or "circle", 17)
        tabIcon.Position = UDim2.fromOffset(12, 11)
        tabIcon.ImageColor3 = Theme.SubText

        local tabLabel = Instance.new("TextLabel")
        tabLabel.Position = UDim2.fromOffset(39, 0)
        tabLabel.Size = UDim2.new(1, -45, 1, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = name
        tabLabel.TextColor3 = Theme.SubText
        tabLabel.TextSize = 12
        tabLabel.Font = Enum.Font.GothamMedium
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Parent = tabButton

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Theme.Border
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.CanvasSize = UDim2.new()
        page.Visible = false
        page.Parent = pageHolder

        Padding(page, 58, 18, 20, 18)

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 10)
        pageLayout.Parent = page

        Tab.Page = page
        Tab.Button = tabButton
        Tab.Icon = tabIcon
        Tab.Label = tabLabel

        tabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(tabButton, {
                    BackgroundColor3 = Theme.Surface2
                }, 0.15)
            end
        end)

        tabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(tabButton, {
                    BackgroundColor3 = Theme.Surface
                }, 0.15)
            end
        end)

        tabButton.MouseButton1Click:Connect(function()
            Window:SelectTab(Tab)
        end)

        function Tab:Select()
            Window:SelectTab(self)
        end

        function Tab:AddSection(text)
            local section = Instance.new("TextLabel")
            section.Size = UDim2.new(1, 0, 0, 24)
            section.BackgroundTransparency = 1
            section.Text = text:upper()
            section.TextColor3 = Theme.Muted
            section.TextSize = 10
            section.Font = Enum.Font.GothamBold
            section.TextXAlignment = Enum.TextXAlignment.Left
            section.Parent = page
            Padding(section, 7, 0, 0, 3)
            return section
        end

        function Tab:AddLabel(text)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 30)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Theme.SubText
            label.TextSize = 12
            label.Font = Enum.Font.Gotham
            label.TextWrapped = true
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = page
            return label
        end

        function Tab:AddParagraph(data)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 72)
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Parent = page
            Corner(container, 11)
            Stroke(container, Theme.Border, 0.45)

            local titleText = data.Title or "Information"

            local heading = Instance.new("TextLabel")
            heading.Position = UDim2.fromOffset(14, 10)
            heading.Size = UDim2.new(1, -28, 0, 20)
            heading.BackgroundTransparency = 1
            heading.Text = titleText
            heading.TextColor3 = Theme.Text
            heading.TextSize = 12
            heading.Font = Enum.Font.GothamSemibold
            heading.TextXAlignment = Enum.TextXAlignment.Left
            heading.Parent = container

            local content = Instance.new("TextLabel")
            content.Position = UDim2.fromOffset(14, 31)
            content.Size = UDim2.new(1, -28, 0, 32)
            content.BackgroundTransparency = 1
            content.Text = data.Content or ""
            content.TextColor3 = Theme.SubText
            content.TextSize = 11
            content.Font = Enum.Font.Gotham
            content.TextWrapped = true
            content.TextXAlignment = Enum.TextXAlignment.Left
            content.Parent = container

            return container
        end

        function Tab:AddButton(data)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 52)
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Parent = page
            Corner(container, 11)
            Stroke(container, Theme.Border, 0.5)

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundTransparency = 1
            button.Text = ""
            button.AutoButtonColor = false
            button.Parent = container

            local icon = Icon(button, data.Icon or "chevron-right", 17)
            icon.AnchorPoint = Vector2.new(1, 0.5)
            icon.Position = UDim2.new(1, -14, 0.5, 0)
            icon.ImageColor3 = Theme.Muted

            local text = Instance.new("TextLabel")
            text.Position = UDim2.fromOffset(14, 0)
            text.Size = UDim2.new(1, -55, 1, 0)
            text.BackgroundTransparency = 1
            text.Text = data.Text or "Button"
            text.TextColor3 = Theme.Text
            text.TextSize = 12
            text.Font = Enum.Font.GothamMedium
            text.TextXAlignment = Enum.TextXAlignment.Left
            text.Parent = button

            button.MouseEnter:Connect(function()
                Tween(container, {
                    BackgroundColor3 = Theme.Surface2
                }, 0.15)

                Tween(icon, {
                    ImageColor3 = Theme.Text,
                    Position = UDim2.new(1, -11, 0.5, 0)
                }, 0.15)
            end)

            button.MouseLeave:Connect(function()
                Tween(container, {
                    BackgroundColor3 = Theme.Surface
                }, 0.15)

                Tween(icon, {
                    ImageColor3 = Theme.Muted,
                    Position = UDim2.new(1, -14, 0.5, 0)
                }, 0.15)
            end)

            button.MouseButton1Click:Connect(function()
                Tween(container, {
                    BackgroundColor3 = Theme.Surface3
                }, 0.08)

                task.delay(0.08, function()
                    if container.Parent then
                        Tween(container, {
                            BackgroundColor3 = Theme.Surface
                        }, 0.15)
                    end
                end)

                if data.Callback then
                    task.spawn(data.Callback)
                end
            end)

            table.insert(Tab.Components, {
                Container = container,
                SearchObject = data.Text or ""
            })

            return container
        end

        function Tab:AddToggle(data)
            local state = data.Default == true

            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 56)
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Parent = page
            Corner(container, 11)
            Stroke(container, Theme.Border, 0.5)

            local button = Instance.new("TextButton")
            button.Size = UDim2.fromOffset(48, 27)
            button.AnchorPoint = Vector2.new(1, 0.5)
            button.Position = UDim2.new(1, -14, 0.5, 0)
            button.BackgroundColor3 = state and Theme.Accent or Theme.Surface3
            button.Text = ""
            button.AutoButtonColor = false
            button.Parent = container
            Corner(button, 20)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(21, 21)
            knob.Position = state and UDim2.new(1, -24, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            knob.AnchorPoint = Vector2.new(0, 0.5)
            knob.BackgroundColor3 = Theme.White
            knob.BorderSizePixel = 0
            knob.Parent = button
            Corner(knob, 20)

            local text = Instance.new("TextLabel")
            text.Position = UDim2.fromOffset(14, 0)
            text.Size = UDim2.new(1, -75, 1, 0)
            text.BackgroundTransparency = 1
            text.Text = data.Text or "Toggle"
            text.TextColor3 = Theme.Text
            text.TextSize = 12
            text.Font = Enum.Font.GothamMedium
            text.TextXAlignment = Enum.TextXAlignment.Left
            text.Parent = container

            local function setState(value)
                state = value

                Tween(button, {
                    BackgroundColor3 = state and Theme.Accent or Theme.Surface3
                }, 0.18)

                Tween(knob, {
                    Position = state and UDim2.new(1, -24, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
                }, 0.18)

                if data.Callback then
                    task.spawn(data.Callback, state)
                end
            end

            button.MouseButton1Click:Connect(function()
                setState(not state)
            end)

            function Tab:AddToggleSetState(value)
                setState(value)
            end

            table.insert(Tab.Components, {
                Container = container,
                SearchObject = data.Text or ""
            })

            return container
        end

        function Tab:AddSlider(data)
            local min = data.Min or 0
            local max = data.Max or 100
            local value = math.clamp(data.Default or min, min, max)

            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 70)
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Parent = page
            Corner(container, 11)
            Stroke(container, Theme.Border, 0.5)

            local title = Instance.new("TextLabel")
            title.Position = UDim2.fromOffset(14, 10)
            title.Size = UDim2.new(1, -80, 0, 20)
            title.BackgroundTransparency = 1
            title.Text = data.Text or "Slider"
            title.TextColor3 = Theme.Text
            title.TextSize = 12
            title.Font = Enum.Font.GothamMedium
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = container

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Position = UDim2.new(1, -64, 0, 10)
            valueLabel.Size = UDim2.fromOffset(50, 20)
            valueLabel.BackgroundTransparency = 1
            valueLabel.TextColor3 = Theme.SubText
            valueLabel.TextSize = 11
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = container

            local track = Instance.new("Frame")
            track.Position = UDim2.fromOffset(14, 43)
            track.Size = UDim2.new(1, -28, 0, 5)
            track.BackgroundColor3 = Theme.Surface3
            track.BorderSizePixel = 0
            track.Parent = container
            Corner(track, 10)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.fromScale((value - min) / (max - min), 1)
            fill.BackgroundColor3 = Theme.Accent
            fill.BorderSizePixel = 0
            fill.Parent = track
            Corner(fill, 10)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(15, 15)
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
            knob.BackgroundColor3 = Theme.White
            knob.BorderSizePixel = 0
            knob.Parent = track
            Corner(knob, 20)

            local dragging = false

            local function update(input)
                local percent = math.clamp(
                    (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X,
                    0,
                    1
                )

                value = min + ((max - min) * percent)

                if data.Rounding then
                    local mult = 10 ^ data.Rounding
                    value = math.floor(value * mult + 0.5) / mult
                else
                    value = math.floor(value + 0.5)
                end

                local normalized = (value - min) / (max - min)

                fill.Size = UDim2.fromScale(normalized, 1)
                knob.Position = UDim2.new(normalized, 0, 0.5, 0)
                valueLabel.Text = tostring(value)

                if data.Callback then
                    task.spawn(data.Callback, value)
                end
            end

            valueLabel.Text = tostring(value)

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            table.insert(Tab.Components, {
                Container = container,
                SearchObject = data.Text or ""
            })

            return container
        end

        function Tab:AddDropdown(data)
            local opened = false
            local current = data.Default or data.Options and data.Options[1] or "None"

            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 58)
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.ClipsDescendants = false
            container.ZIndex = 20
            container.Parent = page
            Corner(container, 11)
            Stroke(container, Theme.Border, 0.5)

            local label = Instance.new("TextLabel")
            label.Position = UDim2.fromOffset(14, 0)
            label.Size = UDim2.new(0.5, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = data.Text or "Dropdown"
            label.TextColor3 = Theme.Text
            label.TextSize = 12
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container

            local selector = Instance.new("TextButton")
            selector.AnchorPoint = Vector2.new(1, 0.5)
            selector.Position = UDim2.new(1, -12, 0.5, 0)
            selector.Size = UDim2.fromOffset(145, 34)
            selector.BackgroundColor3 = Theme.Surface2
            selector.Text = ""
            selector.AutoButtonColor = false
            selector.ZIndex = 22
            selector.Parent = container
            Corner(selector, 8)

            local selected = Instance.new("TextLabel")
            selected.Position = UDim2.fromOffset(10, 0)
            selected.Size = UDim2.new(1, -30, 1, 0)
            selected.BackgroundTransparency = 1
            selected.Text = tostring(current)
            selected.TextColor3 = Theme.SubText
            selected.TextSize = 11
            selected.Font = Enum.Font.Gotham
            selected.TextXAlignment = Enum.TextXAlignment.Left
            selected.Parent = selector

            local arrow = Icon(selector, "chevron-down", 14)
            arrow.AnchorPoint = Vector2.new(1, 0.5)
            arrow.Position = UDim2.new(1, -8, 0.5, 0)
            arrow.ImageColor3 = Theme.Muted

            local list = Instance.new("Frame")
            list.Position = UDim2.new(0, 0, 1, 6)
            list.Size = UDim2.new(1, 0, 0, 0)
            list.BackgroundColor3 = Theme.Surface2
            list.BorderSizePixel = 0
            list.Visible = false
            list.ZIndex = 30
            list.Parent = selector
            Corner(list, 8)
            Stroke(list, Theme.Border, 0.2)

            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 2)
            listLayout.Parent = list

            local function close()
                opened = false
                Tween(list, {
                    Size = UDim2.new(1, 0, 0, 0)
                }, 0.15)

                task.delay(0.15, function()
                    if not opened then
                        list.Visible = false
                    end
                end)

                Tween(arrow, {
                    Rotation = 0
                }, 0.15)
            end

            local function open()
                opened = true
                list.Visible = true
                list.Size = UDim2.new(1, 0, 0, 0)

                local amount = math.min(#(data.Options or {}) * 32 + 6, 170)

                Tween(list, {
                    Size = UDim2.new(1, 0, 0, amount)
                }, 0.2)

                Tween(arrow, {
                    Rotation = 180
                }, 0.15)
            end

            for _, option in ipairs(data.Options or {}) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, -8, 0, 29)
                optionButton.BackgroundColor3 = Theme.Surface2
                optionButton.Text = tostring(option)
                optionButton.TextColor3 = Theme.SubText
                optionButton.TextSize = 11
                optionButton.Font = Enum.Font.Gotham
                optionButton.AutoButtonColor = false
                optionButton.ZIndex = 31
                optionButton.Parent = list
                Corner(optionButton, 6)

                optionButton.MouseEnter:Connect(function()
                    Tween(optionButton, {
                        BackgroundColor3 = Theme.Surface3,
                        TextColor3 = Theme.Text
                    }, 0.12)
                end)

                optionButton.MouseLeave:Connect(function()
                    Tween(optionButton, {
                        BackgroundColor3 = Theme.Surface2,
                        TextColor3 = Theme.SubText
                    }, 0.12)
                end)

                optionButton.MouseButton1Click:Connect(function()
                    current = option
                    selected.Text = tostring(option)
                    close()

                    if data.Callback then
                        task.spawn(data.Callback, option)
                    end
                end)
            end

            selector.MouseButton1Click:Connect(function()
                if opened then
                    close()
                else
                    open()
                end
            end)

            table.insert(Tab.Components, {
                Container = container,
                SearchObject = data.Text or ""
            })

            return container
        end

        function Tab:AddTextbox(data)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 58)
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Parent = page
            Corner(container, 11)
            Stroke(container, Theme.Border, 0.5)

            local label = Instance.new("TextLabel")
            label.Position = UDim2.fromOffset(14, 0)
            label.Size = UDim2.fromOffset(120, 58)
            label.BackgroundTransparency = 1
            label.Text = data.Text or "Textbox"
            label.TextColor3 = Theme.Text
            label.TextSize = 12
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container

            local box = Instance.new("TextBox")
            box.AnchorPoint = Vector2.new(1, 0.5)
            box.Position = UDim2.new(1, -12, 0.5, 0)
            box.Size = UDim2.fromOffset(190, 34)
            box.BackgroundColor3 = Theme.Surface2
            box.BorderSizePixel = 0
            box.Text = data.Default or ""
            box.PlaceholderText = data.Placeholder or "Enter text..."
            box.PlaceholderColor3 = Theme.Muted
            box.TextColor3 = Theme.Text
            box.TextSize = 11
            box.Font = Enum.Font.Gotham
            box.ClearTextOnFocus = false
            box.Parent = container
            Corner(box, 8)
            Padding(box, 0, 10, 0, 10)
            Stroke(box, Theme.Border, 0.35)

            box.FocusLost:Connect(function()
                if data.Callback then
                    task.spawn(data.Callback, box.Text)
                end
            end)

            table.insert(Tab.Components, {
                Container = container,
                SearchObject = data.Text or ""
            })

            return container
        end

        function Tab:AddKeybind(data)
            local key = data.Default or Enum.KeyCode.RightShift

            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 56)
            container.BackgroundColor3 = Theme.Surface
            container.BorderSizePixel = 0
            container.Parent = page
            Corner(container, 11)
            Stroke(container, Theme.Border, 0.5)

            local label = Instance.new("TextLabel")
            label.Position = UDim2.fromOffset(14, 0)
            label.Size = UDim2.new(1, -130, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = data.Text or "Keybind"
            label.TextColor3 = Theme.Text
            label.TextSize = 12
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container

            local bind = Instance.new("TextButton")
            bind.AnchorPoint = Vector2.new(1, 0.5)
            bind.Position = UDim2.new(1, -13, 0.5, 0)
            bind.Size = UDim2.fromOffset(95, 32)
            bind.BackgroundColor3 = Theme.Surface2
            bind.Text = key.Name
            bind.TextColor3 = Theme.SubText
            bind.TextSize = 10
            bind.Font = Enum.Font.GothamMedium
            bind.AutoButtonColor = false
            bind.Parent = container
            Corner(bind, 8)

            local listening = false

            bind.MouseButton1Click:Connect(function()
                listening = true
                bind.Text = "Press key..."
                Tween(bind, {
                    BackgroundColor3 = Theme.Accent,
                    TextColor3 = Theme.White
                }, 0.15)
            end)

            UserInputService.InputBegan:Connect(function(input, processed)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    key = input.KeyCode
                    listening = false
                    bind.Text = key.Name

                    Tween(bind, {
                        BackgroundColor3 = Theme.Surface2,
                        TextColor3 = Theme.SubText
                    }, 0.15)

                    if data.Changed then
                        task.spawn(data.Changed, key)
                    end

                    return
                end

                if not processed and input.KeyCode == key then
                    if data.Callback then
                        task.spawn(data.Callback)
                    end
                end
            end)

            table.insert(Tab.Components, {
                Container = container,
                SearchObject = data.Text or ""
            })

            return container
        end

        function Tab:AddDivider()
            local divider = Instance.new("Frame")
            divider.Size = UDim2.new(1, 0, 0, 1)
            divider.BackgroundColor3 = Theme.Border
            divider.BackgroundTransparency = 0.35
            divider.BorderSizePixel = 0
            divider.Parent = page
            return divider
        end

        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            Window:SelectTab(Tab)
        end

        return Tab
    end

    function Window:Notify(data)
        data = data or {}

        local notification = {
            Title = data.Title or "Guintosh",
            Content = data.Content or data.Text or "",
            Duration = data.Duration or 4,
            Type = data.Type or "Info",
            Icon = data.Icon
        }

        local holder = Instance.new("Frame")
        holder.Name = "Notification"
        holder.AnchorPoint = Vector2.new(1, 1)
        holder.Position = UDim2.new(1, 370, 1, -24)
        holder.Size = UDim2.fromOffset(340, 82)
        holder.BackgroundColor3 = Theme.Surface
        holder.BorderSizePixel = 0
        holder.ZIndex = 100
        holder.Parent = gui
        Corner(holder, 13)
        Stroke(holder, Theme.Border, 0.15)

        local accentColor = Theme.Accent
        local iconName = "info"

        if notification.Type == "Success" then
            accentColor = Theme.Success
            iconName = "check"
        elseif notification.Type == "Warning" then
            accentColor = Theme.Warning
            iconName = "triangle-alert"
        elseif notification.Type == "Error" then
            accentColor = Theme.Error
            iconName = "x"
        elseif notification.Type == "Loading" then
            accentColor = Theme.Accent
            iconName = "loader-circle"
        end

        if notification.Icon then
            iconName = notification.Icon
        end

        local accent = Instance.new("Frame")
        accent.Position = UDim2.fromOffset(0, 10)
        accent.Size = UDim2.fromOffset(3, 62)
        accent.BackgroundColor3 = accentColor
        accent.BorderSizePixel = 0
        accent.ZIndex = 102
        accent.Parent = holder
        Corner(accent, 5)

        local iconHolder = Instance.new("Frame")
        iconHolder.Position = UDim2.fromOffset(14, 17)
        iconHolder.Size = UDim2.fromOffset(34, 34)
        iconHolder.BackgroundColor3 = Theme.Surface3
        iconHolder.ZIndex = 101
        iconHolder.Parent = holder
        Corner(iconHolder, 9)

        local notificationIcon = Icon(iconHolder, iconName, 17)
        notificationIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        notificationIcon.Position = UDim2.fromScale(0.5, 0.5)
        notificationIcon.ImageColor3 = accentColor
        notificationIcon.ZIndex = 102

        local notificationTitle = Instance.new("TextLabel")
        notificationTitle.Position = UDim2.fromOffset(59, 13)
        notificationTitle.Size = UDim2.new(1, -105, 0, 20)
        notificationTitle.BackgroundTransparency = 1
        notificationTitle.Text = notification.Title
        notificationTitle.TextColor3 = Theme.Text
        notificationTitle.TextSize = 12
        notificationTitle.Font = Enum.Font.GothamSemibold
        notificationTitle.TextXAlignment = Enum.TextXAlignment.Left
        notificationTitle.ZIndex = 102
        notificationTitle.Parent = holder

        local notificationContent = Instance.new("TextLabel")
        notificationContent.Position = UDim2.fromOffset(59, 34)
        notificationContent.Size = UDim2.new(1, -75, 0, 32)
        notificationContent.BackgroundTransparency = 1
        notificationContent.Text = notification.Content
        notificationContent.TextColor3 = Theme.SubText
        notificationContent.TextSize = 10
        notificationContent.Font = Enum.Font.Gotham
        notificationContent.TextWrapped = true
        notificationContent.TextXAlignment = Enum.TextXAlignment.Left
        notificationContent.TextYAlignment = Enum.TextYAlignment.Top
        notificationContent.ZIndex = 102
        notificationContent.Parent = holder

        local close = Instance.new("TextButton")
        close.AnchorPoint = Vector2.new(1, 0)
        close.Position = UDim2.new(1, -10, 0, 10)
        close.Size = UDim2.fromOffset(20, 20)
        close.BackgroundTransparency = 1
        close.Text = "×"
        close.TextColor3 = Theme.Muted
        close.TextSize = 16
        close.Font = Enum.Font.Gotham
        close.AutoButtonColor = false
        close.ZIndex = 103
        close.Parent = holder

        local progress = Instance.new("Frame")
        progress.Position = UDim2.new(0, 0, 1, -2)
        progress.Size = UDim2.fromScale(1, 0)
        progress.BackgroundColor3 = accentColor
        progress.BorderSizePixel = 0
        progress.ZIndex = 102
        progress.Parent = holder

        local alive = true

        local function remove()
            if not alive then
                return
            end

            alive = false

            Tween(holder, {
                Position = UDim2.new(1, 370, 1, -24)
            }, 0.3)

            task.delay(0.3, function()
                if holder then
                    holder:Destroy()
                end
            end)
        end

        close.MouseButton1Click:Connect(remove)

        close.MouseEnter:Connect(function()
            Tween(close, {
                TextColor3 = Theme.Text
            }, 0.12)
        end)

        close.MouseLeave:Connect(function()
            Tween(close, {
                TextColor3 = Theme.Muted
            }, 0.12)
        end)

        table.insert(self.Notifications, holder)

        for index, existing in ipairs(self.Notifications) do
            if existing and existing.Parent then
                Tween(existing, {
                    Position = UDim2.new(
                        1,
                        -24,
                        1,
                        -24 - ((index - 1) * 92)
                    )
                }, 0.25)
            end
        end

        Tween(holder, {
            Position = UDim2.new(
                1,
                -24,
                1,
                -24 - ((#self.Notifications - 1) * 92)
            )
        }, 0.35, Enum.EasingStyle.Quint)

        Tween(progress, {
            Size = UDim2.new(0, 0, 0, 2)
        }, notification.Duration, Enum.EasingStyle.Linear)

        task.delay(notification.Duration, function()
            if alive then
                remove()
            end
        end)

        return {
            Close = remove
        }
    end

    function Window:SetMinimized(value)
        self.Minimized = value

        if value then
            Tween(window, {
                Size = UDim2.fromOffset(720, 52)
            }, 0.28)

            Tween(shadow, {
                Size = UDim2.fromOffset(738, 70)
            }, 0.28)

            Tween(body, {
                Size = UDim2.new(1, 0, 0, 0)
            }, 0.2)

            task.delay(0.15, function()
                if self.Minimized then
                    body.Visible = false
                end
            end)
        else
            body.Visible = true

            local targetX = self.Maximized and workspace.CurrentCamera.ViewportSize.X - 40 or size.X
            local targetY = self.Maximized and workspace.CurrentCamera.ViewportSize.Y - 80 or size.Y

            Tween(window, {
                Size = UDim2.fromOffset(targetX, targetY)
            }, 0.3)

            Tween(shadow, {
                Size = UDim2.fromOffset(targetX + 18, targetY + 18)
            }, 0.3)
        end
    end

    function Window:SetMaximized(value)
        self.Maximized = value

        if value then
            if self.Minimized then
                self.Minimized = false
                body.Visible = true
            end

            local viewport = workspace.CurrentCamera.ViewportSize
            local targetX = viewport.X - 50
            local targetY = viewport.Y - 90

            Tween(window, {
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(targetX, targetY)
            }, 0.3)

            Tween(shadow, {
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(targetX + 18, targetY + 18)
            }, 0.3)
        else
            Tween(window, {
                Size = UDim2.fromOffset(size.X, size.Y)
            }, 0.3)

            Tween(shadow, {
                Size = UDim2.fromOffset(size.X + 18, size.Y + 18)
            }, 0.3)
        end
    end

    function Window:SetVisible(value)
        self.Visible = value
        gui.Enabled = value
    end

    function Window:Toggle()
        self:SetVisible(not self.Visible)
    end

    function Window:Destroy()
        if gui then
            gui:Destroy()
        end
    end

    function Window:SetTitle(text)
        titleLabel.Text = text
    end

    function Window:SetAccent(color)
        Theme.Accent = color

        brandIconHolder.BackgroundColor3 = color

        for _, notification in ipairs(self.Notifications) do
            if notification and notification.Parent then
                local accent = notification:FindFirstChildOfClass("UIStroke")
                if accent then
                    accent.Color = color
                end
            end
        end
    end

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then
            return
        end

        if input.KeyCode == Enum.KeyCode.RightShift then
            Window:Toggle()
        end
    end)

    return Window
end

return Guintosh
