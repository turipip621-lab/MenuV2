--// GUI TROLL TODO EN UNO (LocalScript para PlayerScripts)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

--////////////////////////////////////////////
-- GUI CREACIÓN
--////////////////////////////////////////////

local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "TrollGUI"

local frame = Instance.new("Frame", ScreenGui)
frame.Size = UDim2.new(0, 220, 0, 320)
frame.Position = UDim2.new(0, 20, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local UIList = Instance.new("UIListLayout", frame)
UIList.Padding = UDim.new(0,6)

-- Función para crear botones
local function MakeBtn(text)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -10, 0, 35)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16
	b.Text = text
	b.Parent = frame
	return b
end

-- Función para crear sliders simples
local function MakeSlider(text, defaultValue)
	local container = Instance.new("Frame", frame)
	container.Size = UDim2.new(1, -10, 0, 45)
	container.BackgroundColor3 = Color3.fromRGB(35,35,35)

	local label = Instance.new("TextLabel", container)
	label.Size = UDim2.new(1,0,0.4,0)
	label.Text = text
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1,1,1)

	local slider = Instance.new("TextBox", container)
	slider.Size = UDim2.new(1, -10, 0.4, 0)
	slider.Position = UDim2.new(0,5,0.45,0)
	slider.Text = tostring(defaultValue)
	slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
	slider.TextColor3 = Color3.new(1,1,1)

	return slider
end

-- BOTONES
local BtnCreateTP = MakeBtn("Crear TP")
local BtnGoTP = MakeBtn("Ir al TP")
local BtnNoclip = MakeBtn("Noclip ON/OFF")
local BtnToolsLocas = MakeBtn("Tools Locas")

-- SLIDERS
local SpeedSlider = MakeSlider("Velocidad:", 16)
local JumpSlider = MakeSlider("Salto:", 50)

-- Variables
local tpPos = nil
local noclipEnabled = false
local toolsLocasOn = false


--////////////////////////////////////////////
-- SISTEMA DE TP
--////////////////////////////////////////////

BtnCreateTP.MouseButton1Click:Connect(function()
	tpPos = char.HumanoidRootPart.Position
	BtnCreateTP.Text = "TP Guardado!"
end)

BtnGoTP.MouseButton1Click:Connect(function()
	if tpPos then
		char.HumanoidRootPart.CFrame = CFrame.new(tpPos)
	end
end)


--////////////////////////////////////////////
-- Noclip
--////////////////////////////////////////////
game:GetService("RunService").Stepped:Connect(function()
	if noclipEnabled and char then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)

BtnNoclip.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	BtnNoclip.Text = noclipEnabled and "Noclip: ON" or "Noclip: OFF"
end)


--////////////////////////////////////////////
-- Sliders de velocidad y salto
--////////////////////////////////////////////
SpeedSlider.FocusLost:Connect(function()
	local val = tonumber(SpeedSlider.Text)
	if val then humanoid.WalkSpeed = val end
end)

JumpSlider.FocusLost:Connect(function()
	local val = tonumber(JumpSlider.Text)
	if val then humanoid.JumpPower = val end
end)


--////////////////////////////////////////////
-- Tools Locas (equipar herramientas random)
--////////////////////////////////////////////

BtnToolsLocas.MouseButton1Click:Connect(function()
	toolsLocasOn = not toolsLocasOn
	BtnToolsLocas.Text = toolsLocasOn and "Tools Locas: ON" or "Tools Locas: OFF"

	if toolsLocasOn then
		task.spawn(function()
			while toolsLocasOn do
				local backpack = player:WaitForChild("Backpack")

				local tools = backpack:GetChildren()
				if #tools > 0 then
					local randomTool = tools[math.random(1,#tools)]
					humanoid:EquipTool(randomTool)
				end

				task.wait(0.05) -- milisegundos
			end
		end)
	end
end)
