local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

local Lucide = loadstring(game:HttpGet("https://cdn.jsdelivr.net/gh/melatonin-rs/lucide-luau@main/src/init.luau"))()

local UILibrary = {}

local Theme = {
    Background = Color3.fromRGB(24, 24, 27),
    Window = Color3.fromRGB(30, 30, 33),
    Sidebar = Color3.fromRGB(35, 35, 39),
    Card = Color3.fromRGB(43, 43, 47),
    CardHover = Color3.fromRGB(52, 52, 57),
    Input = Color3.fromRGB(25, 25, 28),

    Text = Color3.fromRGB(248, 248, 250),
    Secondary = Color3.fromRGB(174, 174, 181),
    Muted = Color3.fromRGB(125, 125, 133),

    Border = Color3.fromRGB(75, 75, 82),

    Blue = Color3.fromRGB(10, 132, 255),
    Green = Color3.fromRGB(48, 209, 88),
    Red = Color3.fromRGB(255, 69, 58),
    Orange = Color3.fromRGB(255, 159, 10),
    Purple = Color3.fromRGB(175, 82, 222)
}

local function tween(object, properties, duration)
    TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.18,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        properties
    ):Play()
end

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = object
    return c
end

local function stroke(object, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Border
    s.Thickness = 1
    s.Transparency = transparency or 0
    s.Parent = object
    return s
end

local function padding(object, left, right, top, bottom)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, left or 0)
    p.PaddingRight = UDim.new(0, right or 0)
    p.PaddingTop = UDim.new(0, top or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.Parent = object
    return p
end

local function text(parent, value, size, color, font)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = value or ""
    label.TextSize = size or 13
    label.TextColor3 = color or Theme.Text
    label.Font = font or Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = parent
    return label
end

local function icon(parent, name, size, color)
    local image = Instance.new("ImageLabel")
    image.BackgroundTransparency = 1
    image.Size = UDim2.fromOffset(size or 18, size or 18)
    image.Image = Lucide.get(name)
    image.ImageColor3 = color or Theme.Text
    image.ScaleType = Enum.ScaleType.Fit
    image.Parent = parent
    return image
end

local function draggable(frame, handle)
    local dragging = false
    local startMouse
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startMouse = input.Position
            startPosition = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - startMouse

            frame.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

function UILibrary:CreateWindow(title, options)
    options = options or {}

    local width = options.Size and options.Size.X or 720
    local height = options.Size and options.Size.Y or 470

    local gui = Instance.new("ScreenGui")
    gui.Name = "MacOS26"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    pcall(function()
        gui.Parent = game:GetService("CoreGui")
    end)

    if not gui.Parent then
        gui.Parent = Player:WaitForChild("PlayerGui")
    end

    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.fromOffset(width + 20, height + 20)
    shadow.Position = UDim2.new(
        0.5,
        -(width + 20) / 2,
        0.5,
        -(height + 20) / 2 + 9
    )
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.55
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    shadow.Parent = gui
    corner(shadow, 20)

    local window = Instance.new("Frame")
    window.Size = UDim2.fromOffset(width, height)
    window.Position = UDim2.new(
        0.5,
        -width / 2,
        0.5,
        -height / 2
    )
    window.BackgroundColor3 = Theme.Window
    window.BorderSizePixel = 0
    window.ClipsDescendants = true
    window.ZIndex = 1
    window.Parent = gui

    corner(window, 17)
    stroke(window, Theme.Border, 0.35)

    local titlebar = Instance.new("Frame")
    titlebar.Size = UDim2.new(1, 0, 0, 56)
    titlebar.BackgroundTransparency = 1
    titlebar.Parent = window
    titlebar.ZIndex = 5

    draggable(window, titlebar)

    local traffic = Instance.new("Frame")
    traffic.Size = UDim2.fromOffset(76, 56)
    traffic.Position = UDim2.fromOffset(13, 0)
    traffic.BackgroundTransparency = 1
    traffic.Parent = titlebar

    local function trafficButton(color, position, glyph)
        local button = Instance.new("TextButton")
        button.Size = UDim2.fromOffset(14, 14)
        button.Position = UDim2.fromOffset(position, 21)
        button.BackgroundColor3 = color
        button.BorderSizePixel = 0
        button.Text = ""
        button.AutoButtonColor = false
        button.Parent = traffic

        corner(button, 7)

        local symbol = text(
            button,
            glyph,
            9,
            Color3.fromRGB(50, 50, 50),
            Enum.Font.GothamBold
        )

        symbol.Size = UDim2.fromScale(1, 1)
        symbol.TextXAlignment = Enum.TextXAlignment.Center
        symbol.TextTransparency = 1

        button.MouseEnter:Connect(function()
            symbol.TextTransparency = 0
        end)

        button.MouseLeave:Connect(function()
            symbol.TextTransparency = 1
        end)

        return button
    end

    local closeButton = trafficButton(
        Theme.Red,
        0,
        "×"
    )

    local minimizeButton = trafficButton(
        Theme.Orange,
        22,
        "−"
    )

    local maximizeButton = trafficButton(
        Theme.Green,
        44,
        "+"
    )

    local titleLabel = text(
        titlebar,
        title or "Application",
        13,
        Theme.Text,
        Enum.Font.GothamMedium
    )

    titleLabel.Position = UDim2.fromOffset(90, 0)
    titleLabel.Size = UDim2.new(1, -180, 1, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center

    local content = Instance.new("Frame")
    content.Position = UDim2.fromOffset(0, 56)
    content.Size = UDim2.new(1, 0, 1, -56)
    content.BackgroundTransparency = 1
    content.Parent = window

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.fromOffset(195, 1)
    sidebar.Size = UDim2.new(0, 195, 1, 0)
    sidebar.BackgroundColor3 = Theme.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = content

    local sidebarTop = Instance.new("Frame")
    sidebarTop.Size = UDim2.new(1, 0, 0, 76)
    sidebarTop.BackgroundTransparency = 1
    sidebarTop.Parent = sidebar

    local avatar = Instance.new("Frame")
    avatar.Size = UDim2.fromOffset(38, 38)
    avatar.Position = UDim2.fromOffset(15, 18)
    avatar.BackgroundColor3 = Theme.Blue
    avatar.BorderSizePixel = 0
    avatar.Parent = sidebarTop
    corner(avatar, 19)

    local avatarText = text(
        avatar,
        string.upper(string.sub(Player.DisplayName or "U", 1, 1)),
        15,
        Color3.new(1, 1, 1),
        Enum.Font.GothamBold
    )

    avatarText.Size = UDim2.fromScale(1, 1)
    avatarText.TextXAlignment = Enum.TextXAlignment.Center

    local userName = text(
        sidebarTop,
        Player.DisplayName or "User",
        12,
        Theme.Text,
        Enum.Font.GothamMedium
    )

    userName.Position = UDim2.fromOffset(64, 17)
    userName.Size = UDim2.new(1, -75, 0, 20)

    local status = text(
        sidebarTop,
        "Online",
        10,
        Theme.Green,
        Enum.Font.Gotham
    )

    status.Position = UDim2.fromOffset(64, 37)
    status.Size = UDim2.new(1, -75, 0, 18)

    local tabHolder = Instance.new("ScrollingFrame")
    tabHolder.Position = UDim2.fromOffset(10, 76)
    tabHolder.Size = UDim2.new(1, -20, 1, -86)
    tabHolder.BackgroundTransparency = 1
    tabHolder.BorderSizePixel = 0
    tabHolder.ScrollBarThickness = 0
    tabHolder.CanvasSize = UDim2.new()
    tabHolder.Parent = sidebar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabHolder

    local pages = Instance.new("Frame")
    pages.Position = UDim2.fromOffset(195, 0)
    pages.Size = UDim2.new(1, -195, 1, 0)
    pages.BackgroundColor3 = Theme.Background
    pages.BorderSizePixel = 0
    pages.Parent = content

    local notificationHolder = Instance.new("Frame")
    notificationHolder.Size = UDim2.fromOffset(350, 1)
    notificationHolder.Position = UDim2.new(1, -370, 0, 18)
    notificationHolder.BackgroundTransparency = 1
    notificationHolder.ZIndex = 100
    notificationHolder.Parent = gui

    local notificationLayout = Instance.new("UIListLayout")
    notificationLayout.Padding = UDim.new(0, 9)
    notificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    notificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notificationLayout.Parent = notificationHolder

    local Window = {
        Gui = gui,
        Frame = window,
        Pages = pages,
        Tabs = {},
        CurrentTab = nil
    }

    function Window:Notify(data)
        data = data or {}

        local duration = data.Duration or 4
        local accent = data.Color or Theme.Blue

        local notification = Instance.new("Frame")
        notification.Size = UDim2.fromOffset(330, 82)
        notification.BackgroundColor3 = Theme.Card
        notification.BackgroundTransparency = 0.03
        notification.BorderSizePixel = 0
        notification.ZIndex = 101
        notification.Parent = notificationHolder

        corner(notification, 15)
        stroke(notification, Theme.Border, 0.2)

        local accentBar = Instance.new("Frame")
        accentBar.Size = UDim2.fromOffset(3, 50)
        accentBar.Position = UDim2.fromOffset(0, 16)
        accentBar.BackgroundColor3 = accent
        accentBar.BorderSizePixel = 0
        accentBar.Parent = notification
        accentBar.ZIndex = 102
        corner(accentBar, 2)

        local iconHolder = Instance.new("Frame")
        iconHolder.Size = UDim2.fromOffset(40, 40)
        iconHolder.Position = UDim2.fromOffset(13, 21)
        iconHolder.BackgroundColor3 = accent
        iconHolder.BackgroundTransparency = 0.82
        iconHolder.BorderSizePixel = 0
        iconHolder.Parent = notification
        iconHolder.ZIndex = 102
        corner(iconHolder, 12)

        local notificationIcon = icon(
            iconHolder,
            data.Icon or "bell",
            18,
            accent
        )

        notificationIcon.Position = UDim2.fromScale(0.5, 0.5)
        notificationIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        notificationIcon.ZIndex = 103

        local notificationTitle = text(
            notification,
            data.Title or "Notification",
            13,
            Theme.Text,
            Enum.Font.GothamMedium
        )

        notificationTitle.Position = UDim2.fromOffset(65, 13)
        notificationTitle.Size = UDim2.new(1, -78, 0, 20)
        notificationTitle.ZIndex = 102

        local notificationContent = text(
            notification,
            data.Content or "",
            11,
            Theme.Secondary,
            Enum.Font.Gotham
        )

        notificationContent.Position = UDim2.fromOffset(65, 35)
        notificationContent.Size = UDim2.new(1, -78, 0, 35)
        notificationContent.TextWrapped = true
        notificationContent.ZIndex = 102

        local progress = Instance.new("Frame")
        progress.Size = UDim2.new(1, -26, 0, 2)
        progress.Position = UDim2.new(0, 13, 1, -6)
        progress.BackgroundColor3 = accent
        progress.BorderSizePixel = 0
        progress.Parent = notification
        progress.ZIndex = 102
        corner(progress, 2)

        notification.Position = UDim2.new(1, 30, 0, 0)

        tween(
            notification,
            {
                Position = UDim2.new(0, 0, 0, 0)
            },
            0.35
        )

        tween(
            progress,
            {
                Size = UDim2.new(0, 0, 0, 2)
            },
            duration
        )

        task.delay(duration, function()
            if notification.Parent then
                tween(
                    notification,
                    {
                        Position = UDim2.new(1, 30, 0, 0),
                        BackgroundTransparency = 1
                    },
                    0.3
                )

                task.wait(0.32)

                if notification.Parent then
                    notification:Destroy()
                end
            end
        end)

        return notification
    end

    function Window:CreateTab(name, iconName)
        local Tab = {}

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 40)
        button.BackgroundColor3 = Theme.Blue
        button.BackgroundTransparency = 1
        button.BorderSizePixel = 0
        button.Text = ""
        button.AutoButtonColor = false
        button.Parent = tabHolder

        corner(button, 10)

        local iconBackground = Instance.new("Frame")
        iconBackground.Size = UDim2.fromOffset(32, 32)
        iconBackground.Position = UDim2.fromOffset(4, 4)
        iconBackground.BackgroundTransparency = 1
        iconBackground.Parent = button

        local tabIcon = icon(
            iconBackground,
            iconName or "circle",
            17,
            Theme.Secondary
        )

        tabIcon.Position = UDim2.fromScale(0.5, 0.5)
        tabIcon.AnchorPoint = Vector2.new(0.5, 0.5)

        local tabText = text(
            button,
            name,
            12,
            Theme.Secondary,
            Enum.Font.GothamMedium
        )

        tabText.Position = UDim2.fromOffset(43, 0)
        tabText.Size = UDim2.new(1, -50, 1, 0)

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Theme.Border
        page.CanvasSize = UDim2.new()
        page.Visible = false
        page.Parent = pages

        padding(page, 22, 22, 20, 22)

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 10)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.fromOffset(
                0,
                layout.AbsoluteContentSize.Y + 35
            )
        end)

        Tab.Page = page
        Tab.Button = button

        function Tab:Select()
            for _, other in ipairs(Window.Tabs) do
                other.Page.Visible = false

                tween(other.Button, {
                    BackgroundTransparency = 1
                })

                tween(other.Icon, {
                    ImageColor3 = Theme.Secondary
                })

                tween(other.Label, {
                    TextColor3 = Theme.Secondary
                })
            end

            page.Visible = true

            tween(button, {
                BackgroundTransparency = 0.78
            })

            tween(tabIcon, {
                ImageColor3 = Theme.Text
            })

            tween(tabText, {
                TextColor3 = Theme.Text
            })

            Window.CurrentTab = Tab
        end

        button.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                tween(button, {
                    BackgroundTransparency = 0.9
                })
            end
        end)

        button.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                tween(button, {
                    BackgroundTransparency = 1
                })
            end
        end)

        button.MouseButton1Click:Connect(function()
            Tab:Select()
        end)

        function Tab:AddSection(value)
            local section = text(
                page,
                value,
                11,
                Theme.Muted,
                Enum.Font.GothamMedium
            )

            section.Size = UDim2.new(1, 0, 0, 28)
            section.Text = string.upper(value)

            return section
        end

        function Tab:AddLabel(value)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, 0, 0, 36)
            holder.BackgroundTransparency = 1
            holder.Parent = page

            local label = text(
                holder,
                value,
                12,
                Theme.Secondary,
                Enum.Font.Gotham
            )

            label.Size = UDim2.fromScale(1, 1)

            return holder
        end

        function Tab:AddButton(data)
            data = data or {}

            local buttonHolder = Instance.new("TextButton")
            buttonHolder.Size = UDim2.new(1, 0, 0, 54)
            buttonHolder.BackgroundColor3 = Theme.Card
            buttonHolder.BorderSizePixel = 0
            buttonHolder.Text = ""
            buttonHolder.AutoButtonColor = false
            buttonHolder.Parent = page

            corner(buttonHolder, 13)
            stroke(buttonHolder, Theme.Border, 0.3)

            local buttonIconHolder = Instance.new("Frame")
            buttonIconHolder.Size = UDim2.fromOffset(36, 36)
            buttonIconHolder.Position = UDim2.fromOffset(9, 9)
            buttonIconHolder.BackgroundColor3 = Theme.Blue
            buttonIconHolder.BackgroundTransparency = 0.84
            buttonIconHolder.BorderSizePixel = 0
            buttonIconHolder.Parent = buttonHolder
            corner(buttonIconHolder, 10)

            local buttonIcon = icon(
                buttonIconHolder,
                data.Icon or "play",
                17,
                Theme.Blue
            )

            buttonIcon.Position = UDim2.fromScale(0.5, 0.5)
            buttonIcon.AnchorPoint = Vector2.new(0.5, 0.5)

            local label = text(
                buttonHolder,
                data.Text or "Button",
                13,
                Theme.Text,
                Enum.Font.GothamMedium
            )

            label.Position = UDim2.fromOffset(57, 0)
            label.Size = UDim2.new(1, -100, 1, 0)

            local arrow = icon(
                buttonHolder,
                "chevron-right",
                16,
                Theme.Muted
            )

            arrow.Position = UDim2.new(1, -31, 0.5, -8)

            buttonHolder.MouseEnter:Connect(function()
                tween(buttonHolder, {
                    BackgroundColor3 = Theme.CardHover
                })

                tween(buttonIconHolder, {
                    BackgroundTransparency = 0.72
                })

                tween(arrow, {
                    Position = UDim2.new(1, -26, 0.5, -8),
                    ImageColor3 = Theme.Text
                })
            end)

            buttonHolder.MouseLeave:Connect(function()
                tween(buttonHolder, {
                    BackgroundColor3 = Theme.Card
                })

                tween(buttonIconHolder, {
                    BackgroundTransparency = 0.84
                })

                tween(arrow, {
                    Position = UDim2.new(1, -31, 0.5, -8),
                    ImageColor3 = Theme.Muted
                })
            end)

            buttonHolder.MouseButton1Click:Connect(function()
                if data.Callback then
                    task.spawn(data.Callback)
                end
            end)

            return buttonHolder
        end

        function Tab:AddToggle(data)
            data = data or {}

            local enabled = data.Default == true

            local holder = Instance.new("TextButton")
            holder.Size = UDim2.new(1, 0, 0, 58)
            holder.BackgroundColor3 = Theme.Card
            holder.BorderSizePixel = 0
            holder.Text = ""
            holder.AutoButtonColor = false
            holder.Parent = page

            corner(holder, 13)
            stroke(holder, Theme.Border, 0.3)

            local label = text(
                holder,
                data.Text or "Toggle",
                13,
                Theme.Text,
                Enum.Font.GothamMedium
            )

            label.Position = UDim2.fromOffset(16, 0)
            label.Size = UDim2.new(1, -90, 1, 0)

            local switch = Instance.new("Frame")
            switch.Size = UDim2.fromOffset(48, 27)
            switch.Position = UDim2.new(1, -64, 0.5, -13.5)
            switch.BackgroundColor3 = enabled
                and Theme.Green
                or Color3.fromRGB(82, 82, 88)
            switch.BorderSizePixel = 0
            switch.Parent = holder

            corner(switch, 14)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(23, 23)
            knob.Position = enabled
                and UDim2.new(1, -25, 0.5, -11.5)
                or UDim2.fromOffset(2, 2)
            knob.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
            knob.BorderSizePixel = 0
            knob.Parent = switch

            corner(knob, 12)

            local function update()
                tween(switch, {
                    BackgroundColor3 = enabled
                        and Theme.Green
                        or Color3.fromRGB(82, 82, 88)
                })

                tween(knob, {
                    Position = enabled
                        and UDim2.new(1, -25, 0.5, -11.5)
                        or UDim2.fromOffset(2, 2)
                })

                if data.Callback then
                    task.spawn(data.Callback, enabled)
                end
            end

            holder.MouseButton1Click:Connect(function()
                enabled = not enabled
                update()
            end)

            function holder:Set(value)
                enabled = value == true
                update()
            end

            function holder:Get()
                return enabled
            end

            return holder
        end

        function Tab:AddSlider(data)
            data = data or {}

            local minimum = data.Min or 0
            local maximum = data.Max or 100
            local value = math.clamp(
                data.Default or minimum,
                minimum,
                maximum
            )

            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, 0, 0, 72)
            holder.BackgroundColor3 = Theme.Card
            holder.BorderSizePixel = 0
            holder.Parent = page

            corner(holder, 13)
            stroke(holder, Theme.Border, 0.3)

            local label = text(
                holder,
                data.Text or "Slider",
                13,
                Theme.Text,
                Enum.Font.GothamMedium
            )

            label.Position = UDim2.fromOffset(16, 7)
            label.Size = UDim2.new(1, -90, 0, 24)

            local valueLabel = text(
                holder,
                tostring(value),
                11,
                Theme.Secondary,
                Enum.Font.Gotham
            )

            valueLabel.Position = UDim2.new(1, -72, 0, 7)
            valueLabel.Size = UDim2.fromOffset(56, 24)
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -32, 0, 5)
            track.Position = UDim2.fromOffset(16, 51)
            track.BackgroundColor3 = Color3.fromRGB(76, 76, 82)
            track.BorderSizePixel = 0
            track.Parent = holder

            corner(track, 3)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(
                (value - minimum) / (maximum - minimum),
                0,
                1,
                0
            )
            fill.BackgroundColor3 = Theme.Blue
            fill.BorderSizePixel = 0
            fill.Parent = track

            corner(fill, 3)

            local dot = Instance.new("Frame")
            dot.Size = UDim2.fromOffset(15, 15)
            dot.Position = UDim2.new(1, -7, 0.5, -7)
            dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            dot.BorderSizePixel = 0
            dot.Parent = fill

            corner(dot, 8)

            local draggingSlider = false

            local function update(input)
                local percent = math.clamp(
                    (input.Position.X - track.AbsolutePosition.X)
                    / track.AbsoluteSize.X,
                    0,
                    1
                )

                value = minimum + (maximum - minimum) * percent

                if data.Rounding then
                    value = math.floor(
                        value / data.Rounding + 0.5
                    ) * data.Rounding
                else
                    value = math.floor(value + 0.5)
                end

                value = math.clamp(value, minimum, maximum)

                valueLabel.Text = tostring(value)

                local displayPercent =
                    (value - minimum) / (maximum - minimum)

                tween(fill, {
                    Size = UDim2.new(displayPercent, 0, 1, 0)
                }, 0.08)

                if data.Callback then
                    task.spawn(data.Callback, value)
                end
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)

            return holder
        end

        function Tab:AddDropdown(data)
            data = data or {}

            local options = data.Options or {}
            local selected = data.Default or options[1]
            local opened = false

            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, 0, 0, 54)
            holder.BackgroundColor3 = Theme.Card
            holder.BorderSizePixel = 0
            holder.ClipsDescendants = true
            holder.Parent = page

            corner(holder, 13)
            stroke(holder, Theme.Border, 0.3)

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 54)
            button.BackgroundTransparency = 1
            button.Text = ""
            button.Parent = holder

            local label = text(
                button,
                data.Text or "Dropdown",
                13,
                Theme.Text,
                Enum.Font.GothamMedium
            )

            label.Position = UDim2.fromOffset(16, 0)
            label.Size = UDim2.new(0.45, 0, 1, 0)

            local current = text(
                button,
                tostring(selected or "Select"),
                11,
                Theme.Secondary,
                Enum.Font.Gotham
            )

            current.Position = UDim2.new(0.5, 0, 0, 0)
            current.Size = UDim2.new(0.38, -5, 1, 0)
            current.TextXAlignment = Enum.TextXAlignment.Right

            local arrow = icon(
                button,
                "chevron-down",
                16,
                Theme.Muted
            )

            arrow.Position = UDim2.new(1, -30, 0.5, -8)

            local list = Instance.new("Frame")
            list.Position = UDim2.fromOffset(10, 54)
            list.Size = UDim2.new(1, -20, 0, #options * 35)
            list.BackgroundColor3 = Theme.Window
            list.BorderSizePixel = 0
            list.Parent = holder

            corner(list, 10)
            stroke(list, Theme.Border, 0.3)

            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 2)
            listLayout.Parent = list

            for _, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, 33)
                optionButton.BackgroundTransparency = 1
                optionButton.Text = tostring(option)
                optionButton.TextColor3 = Theme.Secondary
                optionButton.TextSize = 12
                optionButton.Font = Enum.Font.Gotham
                optionButton.AutoButtonColor = false
                optionButton.Parent = list

                optionButton.MouseEnter:Connect(function()
                    tween(optionButton, {
                        BackgroundColor3 = Theme.CardHover,
                        BackgroundTransparency = 0
                    })
                end)

                optionButton.MouseLeave:Connect(function()
                    tween(optionButton, {
                        BackgroundTransparency = 1
                    })
                end)

                optionButton.MouseButton1Click:Connect(function()
                    selected = option
                    current.Text = tostring(option)
                    opened = false

                    tween(holder, {
                        Size = UDim2.new(1, 0, 0, 54)
                    })

                    tween(arrow, {
                        Rotation = 0
                    })

                    if data.Callback then
                        task.spawn(data.Callback, option)
                    end
                end)
            end

            button.MouseButton1Click:Connect(function()
                opened = not opened

                if opened then
                    tween(holder, {
                        Size = UDim2.new(
                            1,
                            0,
                            0,
                            64 + (#options * 35)
                        )
                    })

                    tween(arrow, {
                        Rotation = 180
                    })
                else
                    tween(holder, {
                        Size = UDim2.new(1, 0, 0, 54)
                    })

                    tween(arrow, {
                        Rotation = 0
                    })
                end
            end)

            return holder
        end

        function Tab:AddTextbox(data)
            data = data or {}

            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, 0, 0, 54)
            holder.BackgroundColor3 = Theme.Card
            holder.BorderSizePixel = 0
            holder.Parent = page

            corner(holder, 13)
            stroke(holder, Theme.Border, 0.3)

            local label = text(
                holder,
                data.Text or "Input",
                13,
                Theme.Text,
                Enum.Font.GothamMedium
            )

            label.Position = UDim2.fromOffset(16, 0)
            label.Size = UDim2.new(0.35, 0, 1, 0)

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(0.57, 0, 0, 36)
            box.Position = UDim2.new(0.4, 0, 0.5, -18)
            box.BackgroundColor3 = Theme.Input
            box.BorderSizePixel = 0
            box.Text = data.Default or ""
            box.PlaceholderText = data.Placeholder or "Enter text..."
            box.PlaceholderColor3 = Theme.Muted
            box.TextColor3 = Theme.Text
            box.TextSize = 11
            box.Font = Enum.Font.Gotham
            box.ClearTextOnFocus = false
            box.Parent = holder

            corner(box, 9)
            stroke(box, Theme.Border, 0.25)
            padding(box, 10, 10, 0, 0)

            box.Focused:Connect(function()
                tween(box, {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 34)
                })
            end)

            box.FocusLost:Connect(function()
                tween(box, {
                    BackgroundColor3 = Theme.Input
                })

                if data.Callback then
                    task.spawn(data.Callback, box.Text)
                end
            end)

            return holder
        end

        function Tab:AddDivider()
            local divider = Instance.new("Frame")
            divider.Size = UDim2.new(1, 0, 0, 1)
            divider.BackgroundColor3 = Theme.Border
            divider.BackgroundTransparency = 0.55
            divider.BorderSizePixel = 0
            divider.Parent = page
            return divider
        end

        table.insert(Window.Tabs, {
            Page = page,
            Button = button,
            Icon = tabIcon,
            Label = tabText
        })

        if #Window.Tabs == 1 then
            Tab:Select()
        end

        return Tab
    end

    closeButton.MouseButton1Click:Connect(function()
        tween(window, {
            Size = UDim2.fromOffset(width - 25, height - 25),
            BackgroundTransparency = 1
        }, 0.2)

        tween(shadow, {
            BackgroundTransparency = 1
        }, 0.2)

        task.wait(0.22)

        if gui.Parent then
            gui:Destroy()
        end
    end)

    local minimized = false

    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized

        if minimized then
            content.Visible = false

            tween(window, {
                Size = UDim2.fromOffset(width, 56)
            })

            tween(shadow, {
                Size = UDim2.fromOffset(width + 20, 76)
            })
        else
            content.Visible = true

            tween(window, {
                Size = UDim2.fromOffset(width, height)
            })

            tween(shadow, {
                Size = UDim2.fromOffset(width + 20, height + 20)
            })
        end
    end)

    maximizeButton.MouseButton1Click:Connect(function()
        if window.Size.X.Offset < width + 100 then
            local viewport = workspace.CurrentCamera.ViewportSize

            local newWidth = math.min(
                viewport.X - 70,
                1100
            )

            local newHeight = math.min(
                viewport.Y - 100,
                700
            )

            tween(window, {
                Size = UDim2.fromOffset(
                    newWidth,
                    newHeight
                ),
                Position = UDim2.new(
                    0.5,
                    -newWidth / 2,
                    0.5,
                    -newHeight / 2
                )
            })

            tween(shadow, {
                Size = UDim2.fromOffset(
                    newWidth + 20,
                    newHeight + 20
                ),
                Position = UDim2.new(
                    0.5,
                    -(newWidth + 20) / 2,
                    0.5,
                    -(newHeight + 20) / 2 + 9
                )
            })
        else
            tween(window, {
                Size = UDim2.fromOffset(width, height),
                Position = UDim2.new(
                    0.5,
                    -width / 2,
                    0.5,
                    -height / 2
                )
            })

            tween(shadow, {
                Size = UDim2.fromOffset(
                    width + 20,
                    height + 20
                ),
                Position = UDim2.new(
                    0.5,
                    -(width + 20) / 2,
                    0.5,
                    -(height + 20) / 2 + 9
                )
            })
        end
    end)

    return Window
end

return UILibrary
