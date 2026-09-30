local CoreGui = game:GetService("CoreGui")

return function()
    if CoreGui:FindFirstChild("OR4CLE") then
        CoreGui.OR4CLE:Destroy()
    end
    local gui = Instance.new("ScreenGui")
    gui.Name = "OR4CLE"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui
    return gui
end
