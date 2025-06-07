
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "QuantCheat"
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(61, 61, 61)
    MainFrame.BackgroundTransparency = 0
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
    MainFrame.Size = UDim2.new(0, 468, 0, 400)
    MainFrame.Visible = true
    MainFrame.ZIndex = 1

    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Color = Color3.fromRGB(0, 0, 0)
    UIStroke.Thickness = 1

    -- Настройки градиента
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Rotation = 0 -- Горизонтальный градиент
    UIGradient.Parent = MainFrame

    -- Цвета для анимации
    local colorLeft = Color3.fromRGB(0, 0, 0)       -- Черный цвет у самого края
    local colorRightStart = Color3.fromRGB(168, 0, 212)  -- Фиолетовый
    local colorRightEnd = Color3.fromRGB(233, 0, 197)    -- Ярко-розовый
    local duration = 3 -- Длительность перехода в секундах

    -- Функция плавной анимации
    local function animateGradient()
        while true do
            local startTime = tick()
            
            -- Переход от фиолетового к розовому
            while tick() - startTime < duration do
                local progress = (tick() - startTime) / duration
                local currentRightColor = colorRightStart:Lerp(colorRightEnd, progress)
                
                UIGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, colorLeft), -- Черный сохраняется на 5% ширины
                    ColorSequenceKeypoint.new(0.5, currentRightColor), -- Быстрый переход
                    ColorSequenceKeypoint.new(1, currentRightColor) -- Основной цвет
                })
                
                game:GetService("RunService").Heartbeat:Wait()
            end
            
            startTime = tick()
            -- Переход обратно от розового к фиолетовому
            while tick() - startTime < duration do
                local progress = (tick() - startTime) / duration
                local currentRightColor = colorRightEnd:Lerp(colorRightStart, progress)
                
                UIGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, colorLeft), -- Черный сохраняется на 5% ширины
                    ColorSequenceKeypoint.new(0.5, currentRightColor), -- Быстрый переход
                    ColorSequenceKeypoint.new(1, currentRightColor) -- Основной цвет
                })
                
                game:GetService("RunService").Heartbeat:Wait()
            end
        end
    end

    -- Запуск анимации
    coroutine.wrap(animateGradient)()


    local particleFrame = Instance.new("Frame")
    particleFrame.Name = "BlackCircleParticles"
    particleFrame.BackgroundTransparency = 1
    particleFrame.Size = UDim2.new(1, 0, 1, 0)
    particleFrame.Parent = MainFrame

    -- Настройки частиц
    local settings = {
        maxParticles = 20, -- Оптимальное количество
        spawnDelay = 0.4, -- Интервал создания
        startX = 0.02,    -- Начальная позиция (левая граница)
        endX = 1,       -- Конечная позиция (правая граница)
        minY = 0.1,       -- Минимальная позиция по Y
        maxY = 0.9,       -- Максимальная позиция по Y
        minSize = 0.015,  -- Минимальный размер
        maxSize = 0.03,   -- Максимальный размер
        minSpeed = 4,     -- Минимальное время движения
        maxSpeed = 7      -- Максимальное время движения
    }

    -- Пул для повторного использования частиц
    local particlePool = {}

    -- Функция создания частицы
    local function createParticle()
        local p = Instance.new("Frame")
        p.AnchorPoint = Vector2.new(0.5, 0.5)
        p.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        p.BorderSizePixel = 0
        p.ZIndex = 1
        return p
    end

    -- Предварительное создание частиц
    for i = 1, settings.maxParticles do
        particlePool[i] = createParticle()
    end

    local activeParticles = 0

    local function spawnBlackCircle()
        if activeParticles >= settings.maxParticles then return end
        
        local circle = table.remove(particlePool, 1)
        if not circle then
            circle = createParticle()
        end
        
        -- Настройка частицы
        local size = math.random() * (settings.maxSize - settings.minSize) + settings.minSize
        circle.Size = UDim2.new(size, 0, size, 0)
        circle.Position = UDim2.new(
            settings.startX,
            0,
            math.random() * (settings.maxY - settings.minY) + settings.minY,
            0
        )
        circle.BackgroundTransparency = math.random(20, 50)/100 -- Полупрозрачные
        circle.Parent = particleFrame
        activeParticles += 1
        
        -- Анимация движения
        local duration = math.random(settings.minSpeed, settings.maxSpeed)
        
        local tween = game:GetService("TweenService"):Create(
            circle,
            TweenInfo.new(duration, Enum.EasingStyle.Linear),
            {
                Position = UDim2.new(
                    settings.endX,
                    0,
                    circle.Position.Y.Scale,
                    0
                ),
                BackgroundTransparency = 1 -- Постепенно исчезают
            }
        )
        
        tween:Play()
        tween.Completed:Connect(function()
            circle.Parent = nil
            table.insert(particlePool, circle)
            activeParticles -= 1
        end)
    end

    -- Запуск системы частиц
    coroutine.wrap(function()
        while true do
            spawnBlackCircle()
            wait(settings.spawnDelay)
        end
    end)()



    local MoveButton = Instance.new("TextButton")
    MoveButton.Name = "MoveButton"
    MoveButton.Text = "Quant v2.3 (b0.88)  https://t.me/QuantCheats       Cl/Op - Right Shift"
    MoveButton.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json")
    MoveButton.TextSize = 14
    MoveButton.TextColor3 = Color3.new(1, 1, 1)
    MoveButton.BackgroundColor3 = Color3.new(0.188235, 0.188235, 0.188235)
    MoveButton.BorderSizePixel = 1
    MoveButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    MoveButton.Size = UDim2.new(0, 468, 0, 18)
    MoveButton.Position = UDim2.new(0, 0, 0, 0)
    MoveButton.ZIndex = 2
    MoveButton.Parent = MainFrame

    local AimingToggle = Instance.new("TextButton")
    AimingToggle.Name = "AimingToggle"
    AimingToggle.Text = "Aiming"
    AimingToggle.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json")
    AimingToggle.TextScaled = true
    AimingToggle.BackgroundColor3 = Color3.new(0.188235, 0.188235, 0.188235)
    AimingToggle.BorderSizePixel = 1
    AimingToggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    AimingToggle.Position = UDim2.new(0, 0, 0, 380)
    AimingToggle.Size = UDim2.new(0, 100, 0, 20)
    AimingToggle.ZIndex = 2
    AimingToggle.TextStrokeTransparency = 0
    AimingToggle.TextColor3 = Color3.new(1, 1, 1)
    AimingToggle.Parent = MainFrame

    local VisualsToggle = Instance.new("TextButton")
    VisualsToggle.Name = "VisualToggle"
    VisualsToggle.Text = "Visual"
    VisualsToggle.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json")
    VisualsToggle.TextScaled = true
    VisualsToggle.BackgroundColor3 = Color3.new(0.188235, 0.188235, 0.188235)
    VisualsToggle.BorderSizePixel = 1
    VisualsToggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    VisualsToggle.Position = UDim2.new(0, 100, 0, 380)
    VisualsToggle.Size = UDim2.new(0, 100, 0, 20)
    VisualsToggle.ZIndex = 2
    VisualsToggle.TextStrokeTransparency = 0
    VisualsToggle.TextColor3 = Color3.new(1, 1, 1)
    VisualsToggle.Parent = MainFrame

    local function createLabel(name, text, x, y, width, parent)
        local label = Instance.new("TextLabel")
        label.Name = name
        label.Text = text
        label.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json")
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, width or 70, 0, 30)
        label.Position = UDim2.new(0, x, 0, y)
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Parent = parent or MainFrame
        label.Visible = false
        return label
    end

    local function createToggle(name, x, y)
        local toggle = Instance.new("TextButton")
        toggle.Name = name
        toggle.Size = UDim2.new(0, 50, 0, 30)
        toggle.Position = UDim2.new(0, x, 0, y)
        toggle.Text = "OFF"
        toggle.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json")
        toggle.TextScaled = true
        toggle.BorderSizePixel = 1
        toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        toggle.TextColor3 = Color3.new(1, 1, 1)
        toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        toggle.BackgroundTransparency = 0.5
        toggle.Visible = false
        toggle.Parent = MainFrame
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.3
        stroke.Parent = toggle
        return toggle
    end

    local function createTextBox(name, x, y, text)
        local textBox = Instance.new("TextBox")
        textBox.Name = name
        textBox.Size = UDim2.new(0, 50, 0, 30)
        textBox.Position = UDim2.new(0, x, 0, y)
        textBox.BackgroundTransparency = 0.35
        textBox.BorderSizePixel = 1
        textBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
        textBox.Text = text
        textBox.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json")
        textBox.TextScaled = true
        textBox.TextStrokeTransparency = 0
        textBox.TextColor3 = Color3.new(1, 1, 1)
        textBox.Parent = MainFrame
        textBox.Visible = false
        return textBox
    end

    local function createBindButton(name, x, y, text)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(0, 30, 0, 30)
        button.Position = UDim2.new(0, x, 0, y)
        button.BackgroundTransparency = 0.35
        button.BorderSizePixel = 1
        button.BorderColor3 = Color3.fromRGB(0, 0, 0)
        button.Text = text or ""
        button.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json")
        button.TextScaled = true
        button.TextStrokeTransparency = 0
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Parent = MainFrame
        button.Visible = false
        return button
    end

    local function createDropDown(TextButton, X, Y, list, callback)
        local MainButton = Instance.new("TextButton")
        MainButton.Name = "MainButton"
        MainButton.Size = UDim2.new(0, 150, 0, 25)
        MainButton.Position = UDim2.new(0, X, 0, Y)
        MainButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        MainButton.Text = TextButton
        MainButton.BackgroundTransparency = 0.5
        MainButton.Visible = false
        MainButton.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json")
        MainButton.TextSize = 18
        MainButton.Parent = MainFrame

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.3
        stroke.Parent = MainButton

        -- Создаём фрейм для выпадающих кнопок
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Name = "DropdownFrame"
        DropdownFrame.Size = UDim2.new(1, 0, 0, 0)
        DropdownFrame.Position = UDim2.new(0, 0, 1, 5)
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        DropdownFrame.BorderSizePixel = 0
        DropdownFrame.Visible = false
        DropdownFrame.ClipsDescendants = true
        DropdownFrame.Parent = MainButton

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 5)
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.Parent = DropdownFrame

        -- Создаём кнопки для каждого элемента списка
        for name, _ in pairs(list) do
            local button = Instance.new("TextButton")
            button.Name = name
            button.Size = UDim2.new(1, -10, 0, 25)
            button.Position = UDim2.new(0, 5, 0, 0)
            button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Text = name
            button.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json")
            button.TextSize = 12
            button.Parent = DropdownFrame

            button.MouseButton1Click:Connect(function()
                MainButton.Text = name
                DropdownFrame.Visible = false
                if callback then
                    callback(name) -- Вызываем callback с выбранным значением
                end
            end)
        end

        UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            DropdownFrame.Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y)
        end)

        local isDropdownOpen = false
        MainButton.MouseButton1Click:Connect(function()
            DropdownFrame.Visible = not DropdownFrame.Visible
        end)

        return MainButton
    end
