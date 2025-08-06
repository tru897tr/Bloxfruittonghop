-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local HOHOButton = Instance.new("TextButton")
local ButtonCorner = Instance.new("UICorner")
local ToggleButton = Instance.new("TextButton")
local ToggleCorner = Instance.new("UICorner")
local NotificationFrame = Instance.new("Frame")
local NotificationCorner = Instance.new("UICorner")
local NotificationText = Instance.new("TextLabel")
local TweenService = game:GetService("TweenService")

-- Thiết lập ScreenGui
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Thiết lập Frame chính (hiện giữa màn hình)
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150) -- Căn giữa màn hình
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true -- Hiện ngay khi chạy script

-- Thêm góc bo tròn cho Frame
UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 20)

-- Thiết lập tiêu đề
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 102, 204) -- Màu xanh đậm kiểu Blox Fruit
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "Tổng Hợp Script Blox Fruit"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack
Title.BackgroundTransparency = 0.2

-- Thiết lập nút HOHO Hub
HOHOButton.Parent = MainFrame
HOHOButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
HOHOButton.Size = UDim2.new(0.8, 0, 0, 80)
HOHOButton.Position = UDim2.new(0.1, 0, 0, 80)
HOHOButton.Text = "HOHO Hub"
HOHOButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HOHOButton.TextScaled = true
HOHOButton.Font = Enum.Font.GothamBold
ButtonCorner.Parent = HOHOButton
ButtonCorner.CornerRadius = UDim.new(0, 15)

-- Nút ẩn/hiện (hình tròn)
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50) -- Màu xanh vì Frame hiện ngay
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(1, -70, 1, -70)
ToggleButton.Text = "☰"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold
ToggleCorner.Parent = ToggleButton
ToggleCorner.CornerRadius = UDim.new(1, 0) -- Hình tròn

-- Thiết lập khung thông báo (giữa phía trên)
NotificationFrame.Parent = ScreenGui
NotificationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NotificationFrame.Size = UDim2.new(0, 350, 0, 100)
NotificationFrame.Position = UDim2.new(0.5, -175, 0, 20) -- Ở giữa phía trên
NotificationFrame.BackgroundTransparency = 1
NotificationFrame.Visible = false

NotificationCorner.Parent = NotificationFrame
NotificationCorner.CornerRadius = UDim.new(0, 15)

NotificationText.Parent = NotificationFrame
NotificationText.Size = UDim2.new(1, 0, 1, 0)
NotificationText.BackgroundTransparency = 1
NotificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationText.TextScaled = true
NotificationText.Font = Enum.Font.Gotham
NotificationText.Text = ""

-- Hàm hiển thị thông báo
local function showNotification(message, color)
    NotificationFrame.Visible = true
    NotificationText.Text = message
    NotificationFrame.BackgroundColor3 = color
    NotificationFrame.Position = UDim2.new(0.5, -175, 0, -100) -- Vị trí ban đầu (ngoài màn hình)
    
    local tweenIn = TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2,
        Position = UDim2.new(0.5, -175, 0, 20) -- Trượt xuống giữa phía trên
    })
    tweenIn:Play()
    
    -- Ẩn sau 5 giây
    wait(5)
    local tweenOut = TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -175, 0, -100)
    })
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        NotificationFrame.Visible = false
    end)
end

-- Hiệu ứng Tween cho Frame
local function toggleFrame()
    local targetTransparency = MainFrame.Visible and 1 or 0.1
    local targetPosition = MainFrame.Visible and UDim2.new(0.5, -200, 0.7, -150) or UDim2.new(0.5, -200, 0.5, -150)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(MainFrame, tweenInfo, {
        BackgroundTransparency = targetTransparency,
        Position = targetPosition
    })
    MainFrame.Visible = not MainFrame.Visible
    tween:Play()
    
    -- Đổi màu nút toggle
    local targetColor = MainFrame.Visible and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    local colorTween = TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = targetColor})
    colorTween:Play()
    
    -- Thông báo khi mở/đóng
    showNotification(MainFrame.Visible and "Đã mở Tổng Hợp Script Blox Fruit!" or "Đã đóng Tổng Hợp Script Blox Fruit!", Color3.fromRGB(50, 255, 50))
end

-- Hiệu ứng hover cho nút HOHO
HOHOButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(HOHOButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 255)})
    tween:Play()
end)

HOHOButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(HOHOButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)})
    tween:Play()
end)

-- Sự kiện nút HOHO Hub
HOHOButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()
    end)
    if success then
        showNotification("HOHO Hub đã chạy thành công!", Color3.fromRGB(50, 255, 50))
    else
        showNotification("Lỗi khi chạy HOHO Hub: " .. tostring(err), Color3.fromRGB(255, 50, 50))
    end
end)

-- Sự kiện nút Toggle
ToggleButton.MouseButton1Click:Connect(toggleFrame)

-- Thông báo khởi động
showNotification("Tổng Hợp Script Blox Fruit đã khởi động!", Color3.fromRGB(255, 215, 0))
