-- Dịch vụ
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BloxFruitHub"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 10000
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Danh sách lưu trữ thông báo
local notifications = {}

-- Hàm cập nhật vị trí các thông báo
local function updateNotificationPositions()
    for i, notif in ipairs(notifications) do
        local targetPosition = UDim2.new(0.5, -notif.Size.X.Offset / 2, 0, 10 + (i - 1) * 60)
        local tweenUpdate = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = targetPosition
        })
        tweenUpdate:Play()
    end
end

-- Hàm tạo thông báo
local function createNotification(message, isError)
    -- In thông báo vào debug
    if isError then
        print("[BloxFruitHub Error] " .. message)
    else
        print("[BloxFruitHub Success] " .. message)
    end

    -- Xóa thông báo cũ nếu vượt quá 3
    if #notifications >= 3 then
        local oldestNotification = table.remove(notifications, 1)
        if oldestNotification and oldestNotification.Parent then
            local tweenOut = TweenService:Create(oldestNotification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, -oldestNotification.Size.X.Offset / 2, 0, oldestNotification.Position.Y.Offset + 20)
            })
            local tweenTextOut = TweenService:Create(oldestNotification:FindFirstChildOfClass("TextLabel"), TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1
            })
            tweenOut:Play()
            tweenTextOut:Play()
            tweenOut.Completed:Connect(function()
                oldestNotification:Destroy()
                updateNotificationPositions()
            end)
        end
    end

    -- Tạo khung thông báo
    local notificationFrame = Instance.new("Frame")
    local notificationText = Instance.new("TextLabel")
    
    -- Cấu hình TextLabel
    notificationText.BackgroundTransparency = 1
    notificationText.Text = message
    notificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notificationText.TextSize = 16
    notificationText.Font = Enum.Font.SourceSans
    notificationText.ZIndex = 16
    notificationText.TextWrapped = true
    notificationText.TextXAlignment = Enum.TextXAlignment.Center
    notificationText.TextYAlignment = Enum.TextYAlignment.Center
    notificationText.Parent = notificationFrame

    -- Thêm UIPadding
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingLeft = UDim.new(0, 10)
    uiPadding.PaddingRight = UDim.new(0, 10)
    uiPadding.PaddingTop = UDim.new(0, 5)
    uiPadding.PaddingBottom = UDim.new(0, 5)
    uiPadding.Parent = notificationText

    -- Đo kích thước văn bản
    local maxWidth = 400
    local textSize = TextService:GetTextSize(
        message,
        16,
        Enum.Font.SourceSans,
        Vector2.new(maxWidth - 20, 1000)
    )
    local frameWidth = math.max(200, textSize.X + 20)
    local frameHeight = math.max(50, textSize.Y + 10)

    -- Cấu hình Frame
    notificationFrame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
    notificationFrame.Position = UDim2.new(0.5, -frameWidth / 2, 0, -frameHeight)
    notificationFrame.BackgroundColor3 = isError and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(20, 20, 20)
    notificationFrame.BorderSizePixel = 0
    notificationFrame.ZIndex = 15
    notificationFrame.Parent = screenGui

    notificationText.Size = UDim2.new(1, 0, 1, 0)

    -- Thêm sự kiện nhấn để tắt thông báo
    notificationFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, -notificationFrame.Size.X.Offset / 2, 0, notificationFrame.Position.Y.Offset + 20)
            })
            local tweenTextOut = TweenService:Create(notificationText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1
            })
            tweenOut:Play()
            tweenTextOut:Play()
            tweenOut.Completed:Connect(function()
                for i, notif in ipairs(notifications) do
                    if notif == notificationFrame then
                        table.remove(notifications, i)
                        break
                    end
                end
                notificationFrame:Destroy()
                updateNotificationPositions()
            end)
        end
    end)

    -- Thêm vào danh sách thông báo
    table.insert(notifications, notificationFrame)

    -- Hiệu ứng di chuyển
    local tweenIn = TweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -frameWidth / 2, 0, 10 + (#notifications - 1) * 60)
    })
    tweenIn:Play()

    -- Tự động xóa sau 5 giây
    spawn(function()
        wait(5)
        if notificationFrame.Parent then
            local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, -notificationFrame.Size.X.Offset / 2, 0, notificationFrame.Position.Y.Offset + 20)
            })
            local tweenTextOut = TweenService:Create(notificationText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1
            })
            tweenOut:Play()
            tweenTextOut:Play()
            tweenOut.Completed:Connect(function()
                for i, notif in ipairs(notifications) do
                    if notif == notificationFrame then
                        table.remove(notifications, i)
                        break
                    end
                end
                notificationFrame:Destroy()
                updateNotificationPositions()
            end)
        end
    end)
end

-- Tạo màn hình Loading
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.Position = UDim2.new(0, 0, 0, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingFrame.BackgroundTransparency = 0
loadingFrame.ZIndex = 10000
loadingFrame.Parent = screenGui

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(0, 200, 0, 50)
loadingText.Position = UDim2.new(0.5, -100, 0.5, -50)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading"
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.TextSize = 32
loadingText.Font = Enum.Font.SourceSansBold
loadingText.ZIndex = 10001
loadingText.Parent = loadingFrame

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 200, 0, 20)
progressBar.Position = UDim2.new(0.5, -100, 0.5, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
progressBar.BorderSizePixel = 0
progressBar.ZIndex = 10001
progressBar.Parent = loadingFrame

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 10002
progressFill.Parent = progressBar

-- Animate progress bar
local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
local tween = TweenService:Create(progressFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
tween:Play()

-- Animate loading text
spawn(function()
    local dots = {".", "..", "..."}
    local index = 1
    while loadingFrame.Parent do
        loadingText.Text = "Loading" .. dots[index]
        index = (index % #dots) + 1
        wait(0.5)
    end
end)

-- Tạo Frame chính
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 5
mainFrame.Parent = screenGui

-- Tạo tiêu đề
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 102, 204) -- Màu xanh Blox Fruit
titleLabel.Text = "Tổng Hợp Script Blox Fruit"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.ZIndex = 6
titleLabel.Parent = mainFrame

-- Tạo nút đóng (X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.SourceSansBold
closeButton.ZIndex = 7
closeButton.Parent = mainFrame

-- Tạo nút Discord
local discordButton = Instance.new("TextButton")
discordButton.Size = UDim2.new(0, 30, 0, 30)
discordButton.Position = UDim2.new(0, 5, 0, 5)
discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordButton.Text = "🟦"
discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
discordButton.TextSize = 16
discordButton.Font = Enum.Font.SourceSansBold
discordButton.ZIndex = 7
discordButton.Parent = mainFrame

-- Tạo khung xác nhận khi đóng
local confirmFrame = Instance.new("Frame")
confirmFrame.Size = UDim2.new(0, 280, 0, 180)
confirmFrame.Position = UDim2.new(0.5, -140, 0.5, -90)
confirmFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
confirmFrame.BorderSizePixel = 0
confirmFrame.ZIndex = 20
confirmFrame.Visible = false
confirmFrame.Parent = screenGui

local confirmText = Instance.new("TextLabel")
confirmText.Size = UDim2.new(1, -20, 0, 60)
confirmText.Position = UDim2.new(0, 10, 0, 20)
confirmText.BackgroundTransparency = 1
confirmText.Text = "Bạn có chắc chắn muốn đóng script?"
confirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmText.TextSize = 18
confirmText.Font = Enum.Font.SourceSans
confirmText.TextWrapped = true
confirmText.ZIndex = 21
confirmText.Parent = confirmFrame

local confirmOkButton = Instance.new("TextButton")
confirmOkButton.Size = UDim2.new(0, 120, 0, 40)
confirmOkButton.Position = UDim2.new(0.1, 0, 0.65, 0)
confirmOkButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
confirmOkButton.Text = "OK"
confirmOkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmOkButton.TextSize = 16
confirmOkButton.Font = Enum.Font.SourceSansBold
confirmOkButton.ZIndex = 21
confirmOkButton.Parent = confirmFrame

local confirmCancelButton = Instance.new("TextButton")
confirmCancelButton.Size = UDim2.new(0, 120, 0, 40)
confirmCancelButton.Position = UDim2.new(0.54, 0, 0.65, 0)
confirmCancelButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
confirmCancelButton.Text = "Hủy"
confirmCancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmCancelButton.TextSize = 16
confirmCancelButton.Font = Enum.Font.SourceSansBold
confirmCancelButton.ZIndex = 21
confirmCancelButton.Parent = confirmFrame

-- Tạo nút HOHO Hub
local hohoButton = Instance.new("TextButton")
hohoButton.Size = UDim2.new(0.8, 0, 0, 50)
hohoButton.Position = UDim2.new(0.1, 0, 0.2, 0)
hohoButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hohoButton.Text = "HOHO Hub"
hohoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hohoButton.TextSize = 20
hohoButton.Font = Enum.Font.SourceSansBold
hohoButton.ZIndex = 6
hohoButton.Parent = mainFrame

-- Tạo nút toggle
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(1, -60, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.Text = ">"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 20
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.ZIndex = 7
toggleButton.Parent = screenGui
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0.5, 0)
uiCorner.Parent = toggleButton

-- Biến trạng thái
local isVisible = true
local savedPosition = mainFrame.Position
local savedTogglePosition = toggleButton.Position

-- Hàm chuyển đổi ẩn/hiện
local function toggleUI()
    isVisible = not isVisible
    local targetPosition
    if isVisible then
        targetPosition = savedPosition
    else
        targetPosition = UDim2.new(savedPosition.X.Scale, savedPosition.X.Offset, -1, -200)
    end
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(mainFrame, tweenInfo, {Position = targetPosition})
    tween:Play()
    toggleButton.Text = isVisible and ">" or "<"
    createNotification(isVisible and "Đã mở Tổng Hợp Script Blox Fruit!" or "Đã đóng Tổng Hợp Script Blox Fruit!", false)
end

-- Xử lý nút toggle
toggleButton.MouseButton1Click:Connect(toggleUI)

-- Xử lý nút đóng
closeButton.MouseButton1Click:Connect(function()
    confirmFrame.Visible = true
    createNotification("Đã mở xác nhận đóng!", false)
end)

-- Xử lý nút OK trong xác nhận
confirmOkButton.MouseButton1Click:Connect(function()
    createNotification("Đã đóng script thành công!", false)
    screenGui:Destroy()
end)

-- Xử lý nút Cancel trong xác nhận
confirmCancelButton.MouseButton1Click:Connect(function()
    confirmFrame.Visible = false
    createNotification("Đã hủy đóng script!", false)
end)

-- Xử lý nút Discord
discordButton.MouseButton1Click:Connect(function()
    createNotification("Chưa thiết lập liên kết Discord!", false)
end)

-- Xử lý nút HOHO Hub
hohoButton.MouseButton1Click:Connect(function()
    createNotification("Đang chạy HOHO Hub...", false)
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()
    end)
    if success then
        createNotification("HOHO Hub đã chạy thành công!", false)
    else
        createNotification("Lỗi khi chạy HOHO Hub: " .. tostring(err), true)
    end
end)

-- Kéo Frame chính
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    mainFrame.Position = newPosition
    savedPosition = newPosition
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if dragging and dragInput then
        updateInput(dragInput)
    end
end)

-- Kéo nút toggle
local toggleDragging
local toggleDragInput
local toggleDragStart
local toggleStartPos

local function updateToggleInput(input)
    local delta = input.Position - toggleDragStart
    local newPosition = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
    toggleButton.Position = newPosition
    savedTogglePosition = newPosition
end

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = toggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                toggleDragging = false
            end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragInput = input
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if toggleDragging and toggleDragInput then
        updateToggleInput(toggleDragInput)
    end
end)

-- Tắt màn hình loading và thông báo
spawn(function()
    wait(5)
    loadingFrame:Destroy()
    createNotification("Script đã tải thành công!", false)
    createNotification("🚀 Chào mừng đến với Tổng Hợp Script Blox Fruit! 🎮", false)
end)
