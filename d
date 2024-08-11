_G.HSz = 3.5
_G.Dsbl = true

local u = game:GetService("UserInputService")
local r = game:GetService("RunService")
local p = game:GetService("Players")
local l = p.LocalPlayer

local g = Instance.new("ScreenGui")
g.Parent = game.CoreGui

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 200, 0, 150)
f.Position = UDim2.new(0, 10, 0, 10)
f.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
f.Visible = false
f.Parent = g

local t = Instance.new("TextButton")
t.Size = UDim2.new(0, 180, 0, 50)
t.Position = UDim2.new(0, 10, 0, 10)
t.Text = "Toggle head"
t.Parent = f

local hl = Instance.new("TextLabel")
hl.Size = UDim2.new(0, 180, 0, 30)
hl.Position = UDim2.new(0, 10, 0, 70)
hl.Text = "Head Size: " .. _G.HSz
hl.Parent = f

local hs = Instance.new("TextButton")
hs.Size = UDim2.new(0, 180, 0, 30)
hs.Position = UDim2.new(0, 10, 0, 110)
hs.Text = "Adjust Head Size"
hs.Parent = f

u.InputBegan:Connect(function(i, gP)
    if not gP and i.KeyCode == Enum.KeyCode.K then
        f.Visible = not f.Visible
    end
end)

t.MouseButton1Click:Connect(function()
    _G.Dsbl = not _G.Dsbl
end)

hs.MouseButton1Click:Connect(function()
    if _G.HSz < 25 then
        _G.HSz = _G.HSz + 0.5
    else
        _G.HSz = 0.5
    end
    hl.Text = "Head Size: " .. _G.HSz
end)

r.RenderStepped:Connect(function()
    if not _G.Dsbl then
        for _, v in next, p:GetPlayers() do
            if v ~= l then
                pcall(function()
                    if v.Character and v.Character:FindFirstChild("Head") then
                        v.Character.Head.Size = Vector3.new(_G.HSz, _G.HSz, _G.HSz)
                        v.Character.Head.Transparency = 0.4
                        v.Character.Head.BrickColor = BrickColor.new("Red")
                        v.Character.Head.Material = "Neon"
                        v.Character.Head.CanCollide = false
                        v.Character.Head.Massless = true
                    end
                end)
            end
        end
    end
end)

local b = {}

function b.c(p)
    if p == l then return end
    if b[p] then return end

    local ch = p.Character
    if ch and ch:IsDescendantOf(workspace) and ch:FindFirstChild("Humanoid") and ch.Humanoid.Health > 0 then
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = Color3.fromRGB(255, 255, 255)
        box.Filled = false
        box.Thickness = 1

        local con
        con = r.RenderStepped:Connect(function()
            if ch and ch:IsDescendantOf(workspace) and ch:FindFirstChild("Humanoid") and ch.Humanoid.Health > 0 then
                local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(ch.HumanoidRootPart.Position)
                local sf = 1 / (pos.Z * math.tan(math.rad(workspace.CurrentCamera.FieldOfView * 0.5)) * 2) * 100
                local w, h = math.floor(40 * sf), math.floor(62 * sf)

                if vis then
                    box.Size = Vector2.new(w, h)
                    box.Position = Vector2.new(pos.X - box.Size.X / 2, pos.Y - box.Size.Y / 2)
                    box.Visible = true
                else
                    box.Visible = false
                end
            else
                box:Destroy()
                con:Disconnect()
                b[p] = nil
            end
        end)

        b[p] = {
            Box = box,
            Connection = con
        }
    end
end

local function uE()
    for _, p in pairs(p:GetPlayers()) do
        if p.Character then
            b.c(p)
        end
    end
end

r.RenderStepped:Connect(uE)

p.PlayerRemoving:Connect(function(p)
    if b[p] then
        b[p].Box:Destroy()
        b[p].Connection:Disconnect()
        b[p] = nil
    end
end)

l.CharacterAdded:Connect(function()
    if b[l] then
        b[l].Box:Destroy()
        b[l].Connection:Disconnect()
        b[l] = nil
    end
end)
