--[[
     _      ___         ____  ______
    | | /| / (_)__  ___/ / / / /  _/
    | |/ |/ / / _ \/ _  / /_/ // /  
    |__/|__/_/_//_/\_,_/\____/___/
    
    by .ftgs#0 (Discord)
    
    This script is NOT intended to be modified.
    To view the source code, see the 'Src' folder on the official GitHub repository.
    
    Author: .ftgs#0 (Discord User)
    Github: https://github.com/Footagesus/WindUI
    Discord: https://discord.gg/84CNGY5wAV
]]


local __DARKLUA_BUNDLE_MODULES __DARKLUA_BUNDLE_MODULES={cache={}, load=function(m)if not __DARKLUA_BUNDLE_MODULES.cache[m]then __DARKLUA_BUNDLE_MODULES.cache[m]={c=__DARKLUA_BUNDLE_MODULES[m]()}end return __DARKLUA_BUNDLE_MODULES.cache[m].c end}do function __DARKLUA_BUNDLE_MODULES.a()return {
    Dark = {
        Name = "Dark",
        Accent = "#111111",
        Outline = "#FFFFFF",
        Text = "#FFFFFF",
        PlaceholderText = "#999999",
    },
    Light = {
        Name = "Light",
        Accent = "#FFFFFF",
        Outline = "#000000",
        Text = "#000000",
        PlaceholderText = "#777777",
    },
    Rose = {
        Name = "Rose",
        Accent = "#500830",
        Outline = "#FFFFFF",
        Text = "#FFFFFF",
        PlaceholderText = "#6B7280",
    },
    Plant = {
        Name = "Plant",
        Accent = "#102d04",
        Outline = "#FFFFFF",
        Text = "#e6ffe5",
        PlaceholderText = "#7d977d",
    },
    Red = {
        Name = "Red",
        Accent = "#28050a",
        Outline = "#FFFFFF",
        Text = "#ffeded",
        PlaceholderText = "#977d7d",
    },
    Brown = {
        Name = "Brown",
        Accent = "#554B44", -- Warm brown tone
        Outline = "#FFFFFF",
        Text = "#F5EDE4", -- Light brownish-beige for good contrast
        PlaceholderText = "#A6978D", -- Muted brown-gray for subtlety
    },
}
end function __DARKLUA_BUNDLE_MODULES.b()--[[

Credits: dawid 

]]


local RunService = game:GetService("RunService")
local RenderStepped = RunService.Heartbeat
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Icons = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main.lua"))()
Icons.SetIconsType("lucide")

local Creator = {
    Font = "rbxassetid://12187365364", -- Inter
    CanDraggable = true,
    Theme = nil,
    Objects = {},
    FontObjects = {},
    DefaultProperties = {
        ScreenGui = {
            ResetOnSpawn = false,
            ZIndexBehavior = "Sibling",
        },
        CanvasGroup = {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.new(1,1,1),
        },
        Frame = {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.new(1,1,1),
        },
        TextLabel = {
            BackgroundColor3 = Color3.new(1,1,1),
            BorderSizePixel = 0,
            Text = "",
            RichText = true,
            TextColor3 = Color3.new(1,1,1),
            TextSize = 14,
        }, TextButton = {
            BackgroundColor3 = Color3.new(1,1,1),
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor= false,
            TextColor3 = Color3.new(1,1,1),
            TextSize = 14,
        },
        TextBox = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            ClearTextOnFocus = false,
            Text = "",
            TextColor3 = Color3.new(0, 0, 0),
            TextSize = 14,
        },
        ImageLabel = {
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
        },
        ImageButton = {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            AutoButtonColor = false,
        },
        UIListLayout = {
            SortOrder = "LayoutOrder",
        }
    },
}
            
function Creator.SetTheme(Theme)
    Creator.Theme = Theme
    Creator.UpdateTheme(nil, true)
end

function Creator.AddFontObject(Object)
    table.insert(Creator.FontObjects, Object)
    Creator.UpdateFont(Creator.Font)
end
function Creator.UpdateFont(FontId)
    Creator.Font = FontId
    for _,Obj in next, Creator.FontObjects do
        Obj.FontFace = Font.new(FontId, Obj.FontFace.Weight, Obj.FontFace.Style)
    end
end

function Creator.GetThemeProperty(Property, Theme)
    return Theme[Property]
end

function Creator.AddThemeObject(Object, Properties)
    Creator.Objects[Object] = { Object = Object, Properties = Properties }
    Creator.UpdateTheme(Object)
    return Object
end

function Creator.UpdateTheme(TargetObject, isTween)
    local function ApplyTheme(objData)
        for Property, ColorKey in pairs(objData.Properties or {}) do
            local Color = Creator.GetThemeProperty(ColorKey, Creator.Theme)
            if Color then
                if not isTween then
                    objData.Object[Property] = Color3.fromHex(Color)
                else
                    Creator.Tween(objData.Object, 0.08, { [Property] = Color3.fromHex(Color) }):Play()
                end
            end
        end
    end

    if TargetObject then
        local objData = Creator.Objects[TargetObject]
        if objData then
            ApplyTheme(objData)
        end
    else
        for _, objData in pairs(Creator.Objects) do
            ApplyTheme(objData)
        end
    end
end

function Creator.Icon(Icon)
    return Icons.Icon(Icon)
end

function Creator.New(Name, Properties, Children)
    local Object = Instance.new(Name)
    
    for Name, Value in next, Creator.DefaultProperties[Name] or {} do
        Object[Name] = Value
    end
    
    for Name, Value in next, Properties or {} do
        if Name ~= "ThemeTag" then
            Object[Name] = Value
        end
    end
    
    for _, Child in next, Children or {} do
        Child.Parent = Object
    end
    
    if Properties and Properties.ThemeTag then
        Creator.AddThemeObject(Object, Properties.ThemeTag)
    end
    if Properties and Properties.FontFace then
        Creator.AddFontObject(Object)
    end
    return Object
end

function Creator.Tween(Object, Time, Properties, ...)
    return TweenService:Create(Object, TweenInfo.new(Time, ...), Properties)
end

local New = Creator.New
local Tween = Creator.Tween

function Creator.SetDraggable(can)
    Creator.CanDraggable = can
end

function Creator.ToolTip(ToolTipConfig)
    local ToolTipModule = {
        Title = ToolTipConfig.Title or "ToolTip",
        --Icon = ToolTipConfig.Icon or nil,
        
        Container = nil,
        ToolTipSize = 16,
    }
    
    -- local ToolTipIcon
    -- if ToolTipModule.Icon then
    --     ToolTipIcon = New("ImageLabel", {
    --         Size = UDim2.new(0,20,0,20),
    --         Image = Creator.Icon(ToolTipModule.Icon)[1],
    --         ImageRectOffset = Creator.Icon(ToolTipModule.Icon)[2].ImageRectPosition,
    --         ImageRectSize = Creator.Icon(ToolTipModule.Icon)[2].ImageRectSize,
    --         BackgroundTransparency = 1,
    --         ThemeTag = {
    --             ImageColor3 = "Text"
    --         }
    --     })
    -- end
    
    local ToolTipTitle = New("TextLabel", {
        AutomaticSize = "XY",
        --Size = UDim2.new(0,0,0,0),
        TextWrapped = true,
        BackgroundTransparency = 1,
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
        Text = ToolTipModule.Title,
        TextSize = 17,
        ThemeTag = {
            TextColor3 = "Text",
        }
    })
    
    local UIScale = New("UIScale", {
        Scale = .9 -- 1
    })
    
    local Container = New("CanvasGroup", {
        AnchorPoint = Vector2.new(0.5,0),
        AutomaticSize = "XY",
        BackgroundTransparency = 1,
        Parent = ToolTipConfig.Parent,
        GroupTransparency = 1, -- 0
        Visible = false -- true
    }, {
        New("UISizeConstraint", {
            MaxSize = Vector2.new(400, math.huge)
        }),
        New("Frame", {
            AutomaticSize = "XY",
            BackgroundTransparency = 1,
            LayoutOrder = 99,
            Visible = false
        }, {
            New("ImageLabel", {
                Size = UDim2.new(0,ToolTipModule.ToolTipSize,0,ToolTipModule.ToolTipSize/2),
                BackgroundTransparency = 1,
                Rotation = 180,
                Image = "rbxassetid://89524607682719",
                ThemeTag = {
                    ImageColor3 = "Accent",
                },
            }, {
                New("ImageLabel", {
                    Size = UDim2.new(0,ToolTipModule.ToolTipSize,0,ToolTipModule.ToolTipSize/2),
                    BackgroundTransparency = 1,
                    LayoutOrder = 99,
                    ImageTransparency = .9,
                    Image = "rbxassetid://89524607682719",
                    ThemeTag = {
                        ImageColor3 = "Text",
                    },
                }),
            }),
        }),
        New("Frame", {
            AutomaticSize = "XY",
            ThemeTag = {
                BackgroundColor3 = "Accent",
            },
            
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0,16),
            }),
            New("Frame", {
                ThemeTag = {
                    BackgroundColor3 = "Text",
                },
                AutomaticSize = "XY",
                BackgroundTransparency = .9,
            }, {
                New("UICorner", {
                    CornerRadius = UDim.new(0,16),
                }),
                New("UIListLayout", {
                    Padding = UDim.new(0,12),
                    FillDirection = "Horizontal",
                    VerticalAlignment = "Center"
                }),
                --ToolTipIcon, 
                ToolTipTitle,
                New("UIPadding", {
                    PaddingTop = UDim.new(0,12),
                    PaddingLeft = UDim.new(0,12),
                    PaddingRight = UDim.new(0,12),
                    PaddingBottom = UDim.new(0,12),
                }),
            })
        }),
        UIScale,
        New("UIListLayout", {
            Padding = UDim.new(0,0),
            FillDirection = "Vertical",
            VerticalAlignment = "Center",
            HorizontalAlignment = "Center",
        }),
    })
    ToolTipModule.Container = Container
    
    function ToolTipModule:Open() 
        Container.Visible = true
        
        Tween(Container, .25, { GroupTransparency = 0 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(UIScale, .25, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
    end
    
    function ToolTipModule:Close() 
        Tween(Container, .25, { GroupTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(UIScale, .25, { Scale = .9 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        
        task.wait(.25)
        
        Container.Visible = false
        Container:Destroy()
    end
    
    return ToolTipModule
end

function Creator.Drag(UIElement, b)
    local dragging, dragInput, dragStart, startPos
    local DragModule = {
        CanDraggable = true
    }
    
    local function update(input)
        local delta = input.Position - dragStart
        -- UIElement.Position = UDim2.new(
        --     startPos.X.Scale, startPos.X.Offset + delta.X,
        --     startPos.Y.Scale, startPos.Y.Offset + delta.Y
        -- )
        Creator.Tween(UIElement, 0.08, {Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )}):Play()
    
    end
    
    UIElement.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = UIElement.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UIElement.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            if b then
                if Creator.CanDraggable then
                    update(input)
                end
            elseif DragModule.CanDraggable then 
                update(input)
            end
        end
    end)
    
    
    function DragModule:Set(v)
        DragModule.CanDraggable = v
    end
    
    return DragModule
end


return Creator end function __DARKLUA_BUNDLE_MODULES.c()
local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New
local Tween = Creator.Tween

local DialogModule = {
    UICorner = 14,
    UIPadding = 12,
    Holder = nil,
    Window = nil,
}

function DialogModule.Init(Window)
    DialogModule.Window = Window
    return DialogModule
end

function DialogModule.Create(Key)
    local Dialog = {
        UICorner = 16,
        UIPadding = 16,
        UIElements = {}
    }
    
    if Key then Dialog.UIPadding = 0 end -- 16
    if Key then Dialog.UICorner  = 22 end
    
    if not Key then
        Dialog.UIElements.FullScreen = New("Frame", {
            ZIndex = 999,
            BackgroundTransparency = 1, -- 0.5
            BackgroundColor3 = Color3.fromHex("#2a2a2a"),
            Size = UDim2.new(1,0,1,0),
            Active = false, -- true
            Visible = false, -- true
            Parent = Key and DialogModule.Window or DialogModule.Window.UIElements.Main.Main
        })
    end
    
    Dialog.UIElements.Main = New("Frame", {
        --Size = UDim2.new(1,0,1,0),
        ThemeTag = {
            BackgroundColor3 = "Accent",
        },
        AutomaticSize = "XY",
        BackgroundTransparency = .7,
    }, {
        New("UIPadding", {
            PaddingTop = UDim.new(0, Dialog.UIPadding),
            PaddingLeft = UDim.new(0, Dialog.UIPadding),
            PaddingRight = UDim.new(0, Dialog.UIPadding),
            PaddingBottom = UDim.new(0, Dialog.UIPadding),
        })
    })
    
    Dialog.UIElements.MainContainer = New("CanvasGroup", {
        Visible = false, -- true
        GroupTransparency = 1, -- 0
        BackgroundTransparency = Key and 0.15 or 0, 
        Parent = Key and DialogModule.Window or Dialog.UIElements.FullScreen,
        Position = UDim2.new(0.5,0,0.5,0),
        AnchorPoint = Vector2.new(0.5,0.5),
        AutomaticSize = "XY",
        ThemeTag = {
            BackgroundColor3 = "Accent"
        },
    }, {
        Dialog.UIElements.Main,
        New("UIScale", {
            Scale = .9
        }),
        New("UICorner", {
            CornerRadius = UDim.new(0,Dialog.UICorner),
        }),
        New("UIStroke", {
            Thickness = 0.8,
            ThemeTag = {
                Color = "Outline",
            },
            Transparency = 1, -- .9
        }),
        
    })

    function Dialog:Open()
        if not Key then
            Dialog.UIElements.FullScreen.Visible = true
            Dialog.UIElements.FullScreen.Active = true
        end
        
        task.spawn(function()
            task.wait(.1)
            
            Dialog.UIElements.MainContainer.Visible = true
            
            if not Key then
                Tween(Dialog.UIElements.FullScreen, 0.1, {BackgroundTransparency = .5}):Play()
            end
            Tween(Dialog.UIElements.MainContainer, 0.1, {GroupTransparency = 0}):Play()
            Tween(Dialog.UIElements.MainContainer.UIScale, 0.1, {Scale = 1}):Play()
            Tween(Dialog.UIElements.MainContainer.UIStroke, 0.1, {Transparency = 1}):Play()
        end)
    end
    function Dialog:Close()
        if not Key then
            Tween(Dialog.UIElements.FullScreen, 0.1, {BackgroundTransparency = 1}):Play()
            Dialog.UIElements.FullScreen.Active = false
            task.spawn(function()
                task.wait(.1)
                Dialog.UIElements.FullScreen.Visible = false
            end)
        end
        
        Tween(Dialog.UIElements.MainContainer, 0.1, {GroupTransparency = 1}):Play()
        Tween(Dialog.UIElements.MainContainer.UIScale, 0.1, {Scale = .9}):Play()
        Tween(Dialog.UIElements.MainContainer.UIStroke, 0.1, {Transparency = 1}):Play()
        
        return function()
            task.spawn(function()
                task.wait(.1)
                if not Key then
                    Dialog.UIElements.FullScreen:Destroy()
                else
                    Dialog.UIElements.MainContainer:Destroy()
                end
            end)
        end
    end
    
    --Dialog:Open()
    return Dialog
end

return DialogModule end function __DARKLUA_BUNDLE_MODULES.d()
local KeySystem = {}


local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New
local Tween = Creator.Tween


function KeySystem.new(Config, Filename, func)
    local KeyDialogInit = __DARKLUA_BUNDLE_MODULES.load('c').Init(Config.WindUI.ScreenGui.KeySystem)
    local KeyDialog = KeyDialogInit.Create(true)
    
    local ThumbnailSize = 200
    
    local UISize = 430
    if Config.KeySystem.Thumbnail and Config.KeySystem.Thumbnail.Image then
        UISize = 430+(ThumbnailSize/2)
    end
    
    KeyDialog.UIElements.Main.AutomaticSize = "Y"
    KeyDialog.UIElements.Main.Size = UDim2.new(0,UISize,0,0)
    
    local IconFrame
    
    if Config.Icon then
        local themetag = { ImageColor3 = "Text" }
        
        if string.find(Config.Icon, "rbxassetid://") or not Creator.Icon(tostring(Config.Icon))[1] then
            themetag = nil
        end
        IconFrame = New("ImageLabel", {
            Size = UDim2.new(0,24,0,24),
            BackgroundTransparency = 1,
            LayoutOrder = -1,
            ThemeTag = themetag
        })
        if string.find(Config.Icon, "rbxassetid://") or string.find(Config.Icon, "http://www.roblox.com/asset/?id=") then
            IconFrame.Image = Config.Icon
        elseif string.find(Config.Icon,"http") then
            local success, response = pcall(function()
                if not isfile("WindUI/" .. Window.Folder .. "/Assets/Icon.png") then
                    local response = request({
                        Url = Config.Icon,
                        Method = "GET",
                    }).Body
                    writefile("WindUI/" .. Window.Folder .. "/Assets/Icon.png", response)
                end
                IconFrame.Image = getcustomasset("WindUI/" .. Window.Folder .. "/Assets/Icon.png")
            end)
            if not success then
                IconFrame:Destroy()
                
                warn("[ WindUI ]  '" .. identifyexecutor() .. "' doesnt support the URL Images. Error: " .. response)
            end
        else
            if Creator.Icon(tostring(Config.Icon))[1] then
                IconFrame.Image = Creator.Icon(Config.Icon)[1]
                IconFrame.ImageRectOffset = Creator.Icon(Config.Icon)[2].ImageRectPosition
                IconFrame.ImageRectSize = Creator.Icon(Config.Icon)[2].ImageRectSize
            end
        end
    end
    
    local Title = New("TextLabel", {
        AutomaticSize = "XY",
        BackgroundTransparency = 1,
        Text = Config.Title,
        FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
        ThemeTag = {
            TextColor3 = "Text",
        },
        TextSize = 20
    })
    local KeySystemTitle = New("TextLabel", {
        AutomaticSize = "XY",
        BackgroundTransparency = 1,
        Text = "Key System",
        AnchorPoint = Vector2.new(1,0.5),
        Position = UDim2.new(1,0,0.5,0),
        TextTransparency = 1, -- .4 -- hidden
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
        ThemeTag = {
            TextColor3 = "Text",
        },
        TextSize = 16
    })
    
    local IconAndTitleContainer = New("Frame", {
        BackgroundTransparency = 1,
        AutomaticSize = "XY",
    }, {
        New("UIListLayout", {
            Padding = UDim.new(0,14),
            FillDirection = "Horizontal",
            VerticalAlignment = "Center"
        }),
        IconFrame, Title
    })
    
    local TitleContainer = New("Frame", {
        AutomaticSize = "Y",
        Size = UDim2.new(1,0,0,0),
        BackgroundTransparency = 1,
    }, {
        -- New("UIListLayout", {
        --     Padding = UDim.new(0,9),
        --     FillDirection = "Horizontal",
        --     VerticalAlignment = "Bottom"
        -- }),
        IconAndTitleContainer, KeySystemTitle,
    })
    
    -- local CloseButton = New("TextButton", {
    --     Size = UDim2.new(0,24,0,24),
    --     BackgroundTransparency = 1,
    --     AnchorPoint = Vector2.new(1,0),
    --     Position = UDim2.new(1,0,0,0),
    -- }, {
    --     New("ImageLabel", {
    --         Image = Creator.Icon("x")[1],
    --         ImageRectOffset = Creator.Icon("x")[2].ImageRectPosition,
    --         ImageRectSize = Creator.Icon("x")[2].ImageRectSize,
    --         ThemeTag = {
    --             ImageColor3 = "Text",
    --         },
    --         BackgroundTransparency = 1,
    --         Size = UDim2.new(1,-3,1,-3),
    --     })
    -- })
    -- CloseButton.MouseButton1Up:Connect(function()
    --     KeyDialog:Close()()
    -- end)

    local TextBox = New("TextBox", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,1,0),
        Text = "",
        TextXAlignment = "Left",
        PlaceholderText = "Enter Key...",
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
        ThemeTag = {
            TextColor3 = "Text",
            PlaceholderColor3 = "PlaceholderText"
        },
        TextSize = 18
    })
    
    local TextBoxHolder = New("Frame", {
        BackgroundTransparency = .95,
        Size = UDim2.new(1,0,0,42),
        ThemeTag = {
            BackgroundColor3 = "Text",
        },
    }, {
        New("UIStroke", {
            Thickness = 1.3,
            ThemeTag = {
                Color = "Text",
            },
            Transparency = .9,
        }),
        New("UICorner", {
            CornerRadius = UDim.new(0,12)
        }),
        TextBox,
        New("UIPadding", {
            PaddingLeft = UDim.new(0,12),
            PaddingRight = UDim.new(0,12),
        })
    })
    
    local NoteText
    if Config.KeySystem.Note and Config.KeySystem.Note ~= "" then
        NoteText = New("TextLabel", {
            Size = UDim2.new(1,0,0,0),
            AutomaticSize = "Y",
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
            TextXAlignment = "Left",
            Text = Config.KeySystem.Note,
            TextSize = 18,
            TextTransparency = .4,
            ThemeTag = {
                TextColor3 = "Text",
            },
            BackgroundTransparency = 1,
            RichText = true
        })
    end

    local ButtonsContainer = New("Frame", {
        Size = UDim2.new(1,0,0,42),
        BackgroundTransparency = 1,
    }, {
        New("Frame", {
            BackgroundTransparency = 1,
            AutomaticSize = "X",
            Size = UDim2.new(0,0,1,0),
        }, {
            New("UIListLayout", {
                Padding = UDim.new(0,18/2),
                FillDirection = "Horizontal",
            })
        })
    })
    
    local function CreateButton(Title, Icon, Callback, Variant, Parent)
        local themetagbg = "Text"
        local ButtonFrame = New("TextButton", {
            -- Size = UDim2.new(
            --     (1 / #KeySystemButtons), 
            --     -(((#KeySystemButtons - 1) * 9) / #KeySystemButtons), 
            --     1, 
            --     0
            -- ),
            Size = UDim2.new(0,0,1,0),
            AutomaticSize = "XY",
            -- Parent = ButtonsContainer,
            Parent = Parent,
            ThemeTag = {
                BackgroundColor3 = themetagbg,
            },
            BackgroundTransparency = Variant == "Primary" and .1 or Variant == "Secondary" and .85 or .95
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0,12),
            }),
            
            New("Frame", {
                Size = UDim2.new(1,0,1,0),
                ThemeTag = {
                    BackgroundColor3 = Variant == "Primary" and "Accent" or themetagbg
                },
                BackgroundTransparency = 1 -- .9
            }, {
                New("UIStroke", {
                    Thickness = 1.3,
                    ThemeTag = {
                        Color = "Text",
                    },
                    Transparency = Variant == "Tertiary" and .9 or 1,
                }),
                New("UIPadding", {
                    PaddingLeft = UDim.new(0,12),
                    PaddingRight = UDim.new(0,12),
                }),
                New("UICorner", {
                    CornerRadius = UDim.new(0,12),
                }),
                New("UIListLayout", {
                    FillDirection = "Horizontal",
                    Padding = UDim.new(0,12),
                    VerticalAlignment = "Center",
                    HorizontalAlignment = "Center",
                }),
                New("ImageLabel", {
                    Image = Creator.Icon(Icon)[1],
                    ImageRectSize = Creator.Icon(Icon)[2].ImageRectSize,
                    ImageRectOffset = Creator.Icon(Icon)[2].ImageRectPosition,
                    Size = UDim2.new(0,24-3,0,24-3),
                    BackgroundTransparency = 1,
                    ThemeTag = {
                        ImageColor3 = Variant ~= "Primary" and themetagbg or "Accent",
                    }
                }),
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                    Text = Title,
                    ThemeTag = {
                        TextColor3 = Variant ~= "Primary" and themetagbg or "Accent",
                    },
                    AutomaticSize = "XY",
                    TextSize = 18,
                })
            })
        })
        
        ButtonFrame.MouseEnter:Connect(function()
            Tween(ButtonFrame.Frame, .067, {BackgroundTransparency = .9}):Play()
        end)
        ButtonFrame.MouseLeave:Connect(function()
            Tween(ButtonFrame.Frame, .067, {BackgroundTransparency = 1}):Play()
        end)
        ButtonFrame.MouseButton1Up:Connect(function()
            Callback()
        end)
        
        return ButtonFrame
    end
    
    local ThumbnailFrame
    if Config.KeySystem.Thumbnail and Config.KeySystem.Thumbnail.Image then
        local ThumbnailTitle
        if Config.KeySystem.Thumbnail.Title then
            ThumbnailTitle = New("TextLabel", {
                Text = Config.KeySystem.Thumbnail.Title,
                ThemeTag = {
                    TextColor3 = "Text",
                },
                TextSize = 18,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                BackgroundTransparency = 1,
                AutomaticSize = "XY",
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.new(0.5,0,0.5,0),
            })
        end
        ThumbnailFrame = New("ImageLabel", {
            Image = Config.KeySystem.Thumbnail.Image,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,ThumbnailSize,1,0),
            Parent = KeyDialog.UIElements.Main,
            ScaleType = "Crop"
        }, {
            ThumbnailTitle,
            New("UICorner", {
                CornerRadius = UDim.new(0,0),
            })
        })
    end
    
    local MainFrame = New("Frame", {
        --AutomaticSize = "XY",
        Size = UDim2.new(1, ThumbnailFrame and -ThumbnailSize or 0,1,0),
        Position = UDim2.new(0, ThumbnailFrame and ThumbnailSize or 0,0,0),
        BackgroundTransparency = 1,
        Parent = KeyDialog.UIElements.Main
    }, {
        New("Frame", {
            --AutomaticSize = "XY",
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
        }, {
            New("UIListLayout", {
                Padding = UDim.new(0,18),
                FillDirection = "Vertical",
            }),
            TitleContainer,
            NoteText,
            TextBoxHolder,
            ButtonsContainer,
            New("UIPadding", {
                PaddingTop = UDim.new(0,16),
                PaddingLeft = UDim.new(0,16),
                PaddingRight = UDim.new(0,16),
                PaddingBottom = UDim.new(0,16),
            })
        }),
        CloseButton
    })
    
    -- for _, values in next, KeySystemButtons do
    --     CreateButton(values.Title, values.Icon, values.Callback, values.Variant)
    -- end
    
    local ExitButton = CreateButton("Exit", "log-out", function()
        KeyDialog:Close()()
    end, "Tertiary", ButtonsContainer.Frame)
    
    if ThumbnailFrame then
        ExitButton.Parent = ThumbnailFrame
        ExitButton.Size = UDim2.new(0,0,0,42)
        ExitButton.Position = UDim2.new(0,16,1,-16)
        ExitButton.AnchorPoint = Vector2.new(0,1)
    end
    
    if Config.KeySystem.URL then
        CreateButton("Get key", "key", function()
            setclipboard(Config.KeySystem.URL)
        end, "Secondary", ButtonsContainer.Frame)
    end
    
    local SubmitButton = CreateButton("Submit", "arrow-right", function()
        local Key = TextBox.Text
        local isKey = tostring(Config.KeySystem.Key) == tostring(Key)
        if type(Config.KeySystem.Key) == "table" then
            isKey = table.find(Config.KeySystem.Key, tostring(Key))
        end
        
        if isKey then
            KeyDialog:Close()()
            
            if Config.KeySystem.SaveKey then
                local folder = Config.Folder or Config.Title
                writefile(folder .. "/" .. Filename .. ".key", tostring(Key))
            end
            
            task.wait(.4)
            func(true)
        else
            local OldColor = TextBoxHolder.UIStroke.Color
            local OldBGColor = TextBoxHolder.BackgroundColor3
            Tween(TextBoxHolder.UIStroke, 0.1, {Color = Color3.fromHex("#ff1e1e"), Transparency= .65}):Play()
            Tween(TextBoxHolder, 0.1, {BackgroundColor3= Color3.fromHex("#ff1e1e"), Transparency= .8}):Play()
            
            task.wait(.5)
            
            Tween(TextBoxHolder.UIStroke, 0.15, {Color = OldColor, Transparency = .9}):Play()
            Tween(TextBoxHolder, 0.15, {BackgroundColor3 = OldBGColor, Transparency = .95}):Play()
        end
    end, "Primary", ButtonsContainer)
    
    SubmitButton.AnchorPoint = Vector2.new(1,0.5)
    SubmitButton.Position = UDim2.new(1,0,0.5,0)
    
    -- TitleContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    --     KeyDialog.UIElements.Main.Size = UDim2.new(
    --         0,
    --         TitleContainer.AbsoluteSize.X +24+24+24+24+9,
    --         0,
    --         0
    --     )
    -- end)
    
    KeyDialog:Open()
end

return KeySystem end function __DARKLUA_BUNDLE_MODULES.e()
local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New
local Tween = Creator.Tween

local NotificationModule = {
    Size = UDim2.new(0,300,1,-100-56),
    SizeLower = UDim2.new(0,300,1,-56),
    UICorner = 12,
    UIPadding = 14,
    ButtonPadding = 9,
    Holder = nil,
    NotificationIndex = 0,
    Notifications = {}
}

function NotificationModule.Init(Parent)
    local NotModule = {
        Lower = false
    }
    
    function NotModule.SetLower(val)
        NotModule.Lower = val
        NotModule.Frame.Size = val and NotificationModule.SizeLower or NotificationModule.Size
    end
    
    NotModule.Frame = New("Frame", {
        Position = UDim2.new(1,-116/4,0,56),
        AnchorPoint = Vector2.new(1,0),
        Size = NotificationModule.Size ,
        Parent = Parent,
        BackgroundTransparency = 1,
        --[[ScrollingDirection = "Y",
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = "Y",--]]
    }, {
        New("UIListLayout", {
            HorizontalAlignment = "Center",
			SortOrder = "LayoutOrder",
			VerticalAlignment = "Bottom",
			Padding = UDim.new(0, 8),
        }),
        New("UIPadding", {
            PaddingBottom = UDim.new(0,116/4)
        })
    })
    return NotModule
end

function NotificationModule.New(Config)
    local Notification = {
        Title = Config.Title or "Notification",
        Content = Config.Content or nil,
        Icon = Config.Icon or nil,
        Duration = Config.Duration or 5,
        Buttons = Config.Buttons or {},
        CanClose = true,
        UIElements = {},
        Closed = false,
    }
    if Notification.CanClose == nil then
        Notification.CanClose = true
    end
    NotificationModule.NotificationIndex = NotificationModule.NotificationIndex + 1
    NotificationModule.Notifications[NotificationModule.NotificationIndex] = Notification
    
    local UICorner = New("UICorner", {
        CornerRadius = UDim.new(0,NotificationModule.UICorner),
    })
    
    local UIStroke = New("UIStroke", {
        ThemeTag = {
            Color = "Text"
        },
        Transparency = .9,
        Thickness = .6,
    })
    
    local Icon

    if Notification.Icon then
        if Creator.Icon(Notification.Icon) and Creator.Icon(Notification.Icon)[2] then
            Icon = New("ImageLabel", {
                Size = UDim2.new(0,28,0,28),
                Position = UDim2.new(0,NotificationModule.UIPadding,0,NotificationModule.UIPadding),
                BackgroundTransparency = 1,
                Image = Creator.Icon(Notification.Icon)[1],
                ImageRectSize = Creator.Icon(Notification.Icon)[2].ImageRectSize,
                ImageRectOffset = Creator.Icon(Notification.Icon)[2].ImageRectPosition,
                ThemeTag = {
                    ImageColor3 = "Text"
                }
            })
        elseif string.find(Notification.Icon, "rbxassetid") then
            Icon = New("ImageLabel", {
                Size = UDim2.new(0,28,0,28),
                BackgroundTransparency = 1,
                Position = UDim2.new(0,NotificationModule.UIPadding,0,NotificationModule.UIPadding),
                Image = Notification.Icon
            })
        end
    end
    
    local CloseButton
    if Notification.CanClose then
        CloseButton = New("ImageButton", {
            Image = Creator.Icon("x")[1],
            ImageRectSize = Creator.Icon("x")[2].ImageRectSize,
            ImageRectOffset = Creator.Icon("x")[2].ImageRectPosition,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,20,0,20),
            Position = UDim2.new(1,-NotificationModule.UIPadding,0,NotificationModule.UIPadding),
            AnchorPoint = Vector2.new(1,0),
            ThemeTag = {
                ImageColor3 = "Text"
            }
        })
    end
    
    local Duration = New("Frame", {
        Size = UDim2.new(1,0,0,3),
        BackgroundTransparency = .9,
        ThemeTag = {
            BackgroundColor3 = "Text",
        }
    })
    
    local TextContainer = New("Frame", {
        Size = UDim2.new(1,
            Notification.Icon and -28-NotificationModule.UIPadding or 0,
            1,0),
        Position = UDim2.new(1,0,0,0),
        AnchorPoint = Vector2.new(1,0),
        BackgroundTransparency = 1,
        AutomaticSize = "Y",
    }, {
        New("UIPadding", {
            PaddingTop = UDim.new(0,NotificationModule.UIPadding),
            PaddingLeft = UDim.new(0,NotificationModule.UIPadding),
            PaddingRight = UDim.new(0,NotificationModule.UIPadding),
            PaddingBottom = UDim.new(0,NotificationModule.UIPadding),
        }),
        New("TextLabel", {
            AutomaticSize = "Y",
            Size = UDim2.new(1,-30-NotificationModule.UIPadding,0,0),
            TextWrapped = true,
            TextXAlignment = "Left",
            RichText = true,
            BackgroundTransparency = 1,
            TextSize = 16,
            ThemeTag = {
                TextColor3 = "Text"
            },
            Text = Notification.Title,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold)
        }),
        New("UIListLayout", {
            Padding = UDim.new(0,NotificationModule.UIPadding/3)
        })
    })
    
    if Notification.Content then
        New("TextLabel", {
            AutomaticSize = "Y",
            Size = UDim2.new(1,0,0,0),
            TextWrapped = true,
            TextXAlignment = "Left",
            RichText = true,
            BackgroundTransparency = 1,
            TextTransparency = .4,
            TextSize = 15,
            ThemeTag = {
                TextColor3 = "Text"
            },
            Text = Notification.Content,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
            Parent = TextContainer
        })
    end
    
    -- local ButtonsContainer
    -- if typeof(Notification.Buttons) == "table" and #Notification.Buttons > 0 then
    --     ButtonsContainer = New("Frame", {
    --         Position = UDim2.new(0.5,0,0,TextContainer.UIListLayout.AbsoluteContentSize.Y+(NotificationModule.UIPadding*2)),
    --         Size = UDim2.new(1,-NotificationModule.UIPadding*2,0,0),
    --         AnchorPoint = Vector2.new(0.5,0),
    --         AutomaticSize = "Y",
    --         BackgroundTransparency = 1,
    --     }, {
    --         New("UIListLayout", {
    --             Padding = UDim.new(0,10),
    --             FillDirection = "Horizontal"
    --         })
    --     })
    --     TextContainer.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    --         ButtonsContainer.Position = UDim2.new(0.5,0,0,TextContainer.UIListLayout.AbsoluteContentSize.Y+(NotificationModule.UIPadding*2))
    --     end)
    --     for _,Data in next, Notification.Buttons do
    --         local ButtonData = New("TextButton", {
    --             Size = UDim2.new(1 / #Notification.Buttons, -(((#Notification.Buttons - 1) * 10) / #Notification.Buttons), 0, 0),
    --             AutomaticSize = "Y",
    --             ThemeTag = {
    --                 BackgroundColor3 = "Text",
    --                 TextColor3 = "Accent"
    --             },
    --             Parent = ButtonsContainer,
    --             Text = Data.Name,
    --             TextWrapped = true,
    --             RichText = true,
    --             FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
    --             TextSize = 16,
    --         }, {
    --             New("UICorner", {
    --                 CornerRadius = UDim.new(0,NotificationModule.UICorner-6)
    --             }),
    --             New("UIPadding", {
    --                 PaddingTop = UDim.new(0,NotificationModule.ButtonPadding),
    --                 PaddingLeft = UDim.new(0,NotificationModule.ButtonPadding),
    --                 PaddingRight = UDim.new(0,NotificationModule.ButtonPadding),
    --                 PaddingBottom = UDim.new(0,NotificationModule.ButtonPadding),
    --             })
    --         })
            
    --         ButtonData.MouseButton1Click:Connect(function()
    --             if Data.Callback then
    --                 Data.Callback()
    --             end
    --             Notification:Close()
    --         end)
    --     end
    -- end
    
    local Main = New("CanvasGroup", {
        Size = UDim2.new(1,0,0,0),
        Position = UDim2.new(2,0,1,0),
        AnchorPoint = Vector2.new(0,1),
        AutomaticSize = "Y",
        BackgroundTransparency = .4,
        ThemeTag = {
            BackgroundColor3 = "Accent"
        },
    }, {
        UIStroke, UICorner,
        TextContainer,
        Icon, CloseButton,
        Duration,
        --ButtonsContainer,
    })

    local MainContainer = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,0,0),
        Parent = Config.Holder
    }, {
        Main
    })
    
    function Notification:Close()
        if not Notification.Closed then
            Notification.Closed = true
            Tween(MainContainer, 0.45, {Size = UDim2.new(1, 0, 0, -8)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            Tween(Main, 0.45, {Position = UDim2.new(2,0,1,0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            task.wait(.45)
            MainContainer:Destroy()
        end
    end
    
    task.spawn(function()
        task.wait()
        Tween(MainContainer, 0.45, {Size = UDim2.new(
            1,
            0,
            0,
            Main.AbsoluteSize.Y
        )}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(Main, 0.45, {Position = UDim2.new(0,0,1,0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        if Notification.Duration then
            Tween(Duration, Notification.Duration, {Size = UDim2.new(0,0,0,3)}, Enum.EasingStyle.Linear,Enum.EasingDirection.InOut):Play()
            task.wait(Notification.Duration)
            Notification:Close()
        end
    end)
    
    if CloseButton then
        CloseButton.MouseButton1Click:Connect(function()
            Notification:Close()
        end)
    end
    
    --Tween():Play()
    return Notification
end

return NotificationModule end function __DARKLUA_BUNDLE_MODULES.f()
local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New
local Tween = Creator.Tween

local UserInputService = game:GetService("UserInputService")

return function(Config)
    local Element = {
        Title = Config.Title,
        Desc = Config.Desc or nil,
        Hover = Config.Hover,
        Image = Config.Image,
        ImageSize = Config.ImageSize or 30,
        UIPadding = 12,
        UIElements = {}
    }
    
    local ImageSize = Element.ImageSize
    local CanHover = true
    local Hovering = false
    
    local ImageFrame
    if Element.Image then
        local ImageLabel = New("ImageLabel", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            ThemeTag = Creator.Icon(Element.Image) and {
                ImageColor3 = "Text"
            } or nil
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0,11)
            })
        })
        ImageFrame = New("Frame", {
            Size = UDim2.new(0,ImageSize,0,ImageSize),
            AutomaticSize = "XY",
            BackgroundTransparency = 1,
        }, {
            ImageLabel
        })
        if Creator.Icon(Element.Image) then
            ImageLabel.Image = Creator.Icon(Element.Image)[1]
            ImageLabel.ImageRectOffset = Creator.Icon(Element.Image)[2].ImageRectPosition
            ImageLabel.ImageRectSize = Creator.Icon(Element.Image)[2].ImageRectSize
        end
        if string.find(Element.Image,"http") then
            local success, response = pcall(function()
                if not isfile("WindUI/" .. Config.Window.Folder .. "/Assets/" .. Element.Title .. ".png") then
                    local response = request({
                        Url = Element.Image,
                        Method = "GET",
                    }).Body
                    writefile("WindUI/" .. Config.Window.Folder .. "/Assets/" .. Element.Title .. ".png", response)
                end
                ImageLabel.Image = getcustomasset("WindUI/" .. Config.Window.Folder .. "/Assets/" .. Element.Title .. ".png")
            end)
            if not success then
                ImageLabel:Destroy()
                
                warn("[ WindUI ]  '" .. identifyexecutor() .. "' doesnt support the URL Images. Error: " .. response)
            end
        elseif string.find(Element.Image,"rbxassetid") then
            ImageLabel.Image = Element.Image
        end
    end
    
    Element.UIElements.Main = New("TextButton", {
        Size = UDim2.new(1,0,0,0),
        AutomaticSize = "Y",
        BackgroundTransparency = 0.95,
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.new(0.5,0,0.5,0),
        ThemeTag = {
            BackgroundColor3 = "Text"
        }
    }, {
        New("UICorner", {
            CornerRadius = UDim.new(0,8),
        }),
        New("UIScale", {
            Scale = 1,
        }),
        ImageFrame,
        New("Frame", {
            Size = UDim2.new(1,Element.Image and -(ImageSize+Element.UIPadding),0,0),
            AutomaticSize = "Y",
            AnchorPoint = Vector2.new(0,0),
            Position = UDim2.new(0,Element.Image and ImageSize+Element.UIPadding or 0,0,0),
            BackgroundTransparency = 1,
            Name = "Title"
        }, {
            New("UIListLayout", {
                Padding = UDim.new(0,6),
                --VerticalAlignment = "Left",
            }),
            New("TextLabel", {
                Text = Element.Title,
                ThemeTag = {
                    TextColor3 = "Text"
                },
                TextSize = 15, 
                TextWrapped = true,
                RichText = true,
                LayoutOrder = 0,
                Name = "Title",
                TextXAlignment = "Left",
                Size = UDim2.new(1,-Config.TextOffset,0,0),
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                BackgroundTransparency = 1,
                AutomaticSize = "Y"
            })
        }),
        -- New("ImageLabel", {
        --     Size = UDim2.new(1,Element.UIPadding*2,1,Element.UIPadding*2+6),
        --     Image = "rbxassetid://110049886226894",
        --     SliceCenter = Rect.new(512,512,512,512),
        --     ScaleType = "Slice",
        --     BackgroundTransparency = 1,
        --     ImageTransparency = .94,
        --     Position = UDim2.new(0.5,0,0.5,0),
        --     AnchorPoint = Vector2.new(0.5,0.5),
        -- }),
        New("UIStroke", {
            Thickness = 0.6,
            ThemeTag = {
                Color = "Text",
            },
            Transparency = 0.94,
            ApplyStrokeMode = "Border",
        }),
        New("Frame", {
            Size = UDim2.new(1,Element.UIPadding*2,1,Element.UIPadding*2+6),
            ThemeTag = {
                BackgroundColor3 = "Text"
            },
            Position = UDim2.new(0.5,0,0.5,0),
            AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundTransparency = 1,
            Name = "Highlight"
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0,11),
            }),
        }),
        New("Frame", {
            Size = UDim2.new(1,Element.UIPadding*2,1,Element.UIPadding*2+6),
            BackgroundColor3 = Color3.new(0,0,0),
            Position = UDim2.new(0.5,0,0.5,0),
            AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundTransparency = 1,
            ZIndex = 999999,
            Name = "Lock"
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0,8),
            }),
            New("ImageLabel", {
                Image = "rbxassetid://120011858138977",
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.new(0.5,0,0.5,0),
                Size = UDim2.new(0,26,0,26),
                ImageTransparency = 1,
                BackgroundTransparency = 1,
            })
        }),
        New("UIPadding", {
            PaddingTop = UDim.new(0,Element.UIPadding+3),
            PaddingLeft = UDim.new(0,Element.UIPadding),
            PaddingRight = UDim.new(0,Element.UIPadding),
            PaddingBottom = UDim.new(0,Element.UIPadding+3),
        }),
    })

    -- Element.UIElements.Main.Title.Title:GetPropertyChangedSignal("TextBounds"):Connect(function()
    --     Element.UIElements.Main.Title.Title.Size = UDim2.new(1,-Config.TextOffset,0,Element.UIElements.Main.Title.Title.TextBounds.Y)
    -- end)

    Element.UIElements.MainContainer = New("Frame", {
        Size = UDim2.new(1,0,0,0),
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
        Parent = Config.Parent,
    }, {
        Element.UIElements.Main,
        New("UIPadding", {
            PaddingTop = UDim.new(0,0),
            PaddingLeft = UDim.new(0,2),
            PaddingRight = UDim.new(0,2),
            PaddingBottom = UDim.new(0,2),
        })
    })
    
    -- Element.UIElements.Main.Title.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    --     Element.UIElements.Main.Size = UDim2.new(
    --         1,
    --         0,
    --         0,
    --         Element.UIElements.Main.Title.UIListLayout.AbsoluteContentSize.Y + (Element.UIPadding+3)*2
    --     )
    --     Element.UIElements.Main.Title.Size = UDim2.new(
    --         1,
    --         0,
    --         0,
    --         Element.UIElements.Main.Title.UIListLayout.AbsoluteContentSize.Y
    --     )
    --     Element.UIElements.MainContainer.Size = UDim2.new(
    --         1,
    --         0,
    --         0,
    --         Element.UIElements.Main.AbsoluteSize.Y
    --     )
    -- end)
    
    local Desc
    
    if Element.Desc then
        Desc = New("TextLabel", {
            Text = Element.Desc,
            ThemeTag = {
                TextColor3 = "Text"
            },
            TextTransparency = 0.4,
            TextSize = 15,
            TextWrapped = true,
            RichText = true,
            LayoutOrder = 9999,
            Name = "Desc",
            TextXAlignment = "Left",
            Size = UDim2.new(1,-Config.TextOffset,0,0),
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
            BackgroundTransparency = 1,
            AutomaticSize = "Y",
            Parent = Element.UIElements.Main.Title
        })
        -- Desc:GetPropertyChangedSignal("TextBounds"):Connect(function()
        --     Desc.Size = UDim2.new(1,-Config.TextOffset,0,Desc.TextBounds.Y)
        -- end)
    else
        Element.UIElements.Main.Title.AnchorPoint = Vector2.new(0,Config.IsButtons and 0 or 0.5)
        Element.UIElements.Main.Title.Size = UDim2.new(1,Element.Image and -(ImageSize+Element.UIPadding),0,0)
        Element.UIElements.Main.Title.Position = UDim2.new(0,Element.Image and ImageSize+Element.UIPadding or 0,Config.IsButtons and 0 or 0.5,0)
    end
    
    if Element.Hover then
        Element.UIElements.Main.MouseEnter:Connect(function()
            if CanHover then
                Tween(Element.UIElements.Main.Highlight, 0.066, {BackgroundTransparency = 0.97}):Play()
            end
        end)
        -- Element.UIElements.Main.MouseLeave:Connect(function()
        --     if CanHover then
        --     end
        -- end)
        
        Element.UIElements.Main.MouseButton1Down:Connect(function()
            if CanHover then
                Hovering = true
                Tween(Element.UIElements.Main.UIScale, 0.11, {Scale = .965}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            end
        end)
        
        Element.UIElements.Main.InputEnded:Connect(function()
            if CanHover then
                Tween(Element.UIElements.Main.Highlight, 0.066, {BackgroundTransparency = 1}):Play()
                Tween(Element.UIElements.Main.UIScale, 0.175, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
                task.wait(.16)
                Hovering = false
            end
        end)
    end
    
    Element.UIElements.Main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if not Hovering then
            Element.UIElements.MainContainer.Size = UDim2.new(1,0,0,Element.UIElements.Main.AbsoluteSize.Y)
        end
    end)
    
    function Element:SetTitle(Title)
        Element.UIElements.Main.Title.Title.Text = Title
    end
    function Element:SetDesc(Title)
        if Desc then
            Desc.Text = Title
        else
            Desc = New("TextLabel", {
                Text = Title,
                ThemeTag = {
                    TextColor3 = "Text"
                },
                TextTransparency = 0.4,
                TextSize = 15,
                TextWrapped = true,
                TextXAlignment = "Left",
                Size = UDim2.new(1,-Config.TextOffset,0,0),
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                BackgroundTransparency = 1,
                AutomaticSize = "Y",
                Parent = Element.UIElements.Main.Title
            })
            -- Desc:GetPropertyChangedSignal("TextBounds"):Connect(function()
            --     Desc.Size = UDim2.new(1,-Config.TextOffset,0,Desc.TextBounds.Y)
            -- end)
        end
    end
    function Element:Lock()
        Tween(Element.UIElements.Main.Lock, .08, {BackgroundTransparency = .6}):Play()
        Tween(Element.UIElements.Main.Lock.ImageLabel, .08, {ImageTransparency = 0}):Play()
        Element.UIElements.Main.Lock.Active = true
        CanHover = false
    end
    function Element:Unlock()
        Tween(Element.UIElements.Main.Lock, .08, {BackgroundTransparency = 1}):Play()
        Tween(Element.UIElements.Main.Lock.ImageLabel, .08, {ImageTransparency = 1}):Play()
        Element.UIElements.Main.Lock.Active = false
        CanHover = true
    end
    
    return Element
end end function __DARKLUA_BUNDLE_MODULES.g()
local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New

local Element = {}

function Element:New(Config)
    local Button = {
        __type = "Button",
        Title = Config.Title or "Button",
        Desc = Config.Desc or nil,
        Locked = Config.Locked or false,
        Callback = Config.Callback or function() end,
        UIElements = {}
    }
    
    local CanCallback = true
    
    Button.ButtonFrame = __DARKLUA_BUNDLE_MODULES.load('f')({
        Title = Button.Title,
        Desc = Button.Desc,
        Parent = Config.Parent,
        TextOffset = 20,
        Hover = true,
    })
    
    Button.UIElements.ButtonIcon = New("ImageLabel",{
        Image = Creator.Icon("mouse-pointer-click")[1],
        ImageRectOffset = Creator.Icon("mouse-pointer-click")[2].ImageRectPosition,
        ImageRectSize = Creator.Icon("mouse-pointer-click")[2].ImageRectSize,
        BackgroundTransparency = 1,
        Parent = Button.ButtonFrame.UIElements.Main,
        Size = UDim2.new(0,20,0,20),
        AnchorPoint = Vector2.new(1,0.5),
        Position = UDim2.new(1,0,0.5,0),
        ThemeTag = {
            ImageColor3 = "Text"
        }
    })
    
    function Button:Lock()
        CanCallback = false
        return Button.ButtonFrame:Lock()
    end
    function Button:Unlock()
        CanCallback = true
        return Button.ButtonFrame:Unlock()
    end
    
    if Button.Locked then
        Button:Lock()
    end

    Button.ButtonFrame.UIElements.Main.MouseButton1Click:Connect(function()
        if CanCallback then
            task.spawn(function()
                Button.Callback()
            end)
        end
    end)
    return Button.__type, Button
end

return Element end function __DARKLUA_BUNDLE_MODULES.h()
local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New
local Tween = Creator.Tween

local Element = {}

function Element:New(Config)
    local Toggle = {
        __type = "Toggle",
        Title = Config.Title or "Toggle",
        Desc = Config.Desc or nil,
        Value = Config.Value,
        Icon = Config.Icon or nil,
        Callback = Config.Callback or function() end,
        UIElements = {}
    }
    Toggle.ToggleFrame = __DARKLUA_BUNDLE_MODULES.load('f')({
        Title = Toggle.Title,
        Desc = Toggle.Desc,
        Parent = Config.Parent,
        TextOffset = 44,
        Hover = true,
    })
    
    local CanCallback = true
    
    if Toggle.Value == nil then
        Toggle.Value = false
    end
    
    local ToggleIcon 
    if Toggle.Icon then
        ToggleIcon = New("ImageLabel", {
            Size = UDim2.new(1,-8,1,-8),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5,0.5),
            Position = UDim2.new(0.5,0,0.5,0),
            Image = Creator.Icon(Toggle.Icon)[1],
            ImageRectOffset = Creator.Icon(Toggle.Icon)[2].ImageRectPosition,
            ImageRectSize = Creator.Icon(Toggle.Icon)[2].ImageRectSize,
            ImageTransparency = 1,
            
            ThemeTag = {
                ImageColor3 = "Text"
            }
        })
    end
    
    Toggle.UIElements.Toggle = New("Frame",{
        BackgroundTransparency = .95,
        ThemeTag = {
            BackgroundColor3 = "Text"
        },
        Parent = Toggle.ToggleFrame.UIElements.Main,
        Size = UDim2.new(0,20*2.2,0,24),
        AnchorPoint = Vector2.new(1,0.5),
        Position = UDim2.new(1,0,0.5,0)
    }, {
        New("Frame", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            Name = "Stroke"
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(1,0)
            }),
            New("UIStroke", {
                ThemeTag = {
                    Color = "Text",
                },
                Transparency = 1, -- 0
                Thickness = 1.2,
            }),
        }),
        New("UICorner", {
            CornerRadius = UDim.new(1,0)
        }),
        New("UIStroke", {
            ThemeTag = {
                Color = "Text",
            },
            Transparency = .93,
            Thickness = 1.2,
        }),
        --bar
        New("Frame", {
            Size = UDim2.new(0,18,0,18),
            Position = UDim2.new(0,3,0.5,0),
            AnchorPoint = Vector2.new(0,0.5),
            BackgroundTransparency = 0.15,
            ThemeTag = {
                BackgroundColor3 = "Text"
            },
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(1,0)
            }),
            New("Frame", {
                Size = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                ThemeTag = {
                    BackgroundColor3 = "Accent"
                },
            }, {
                New("UICorner", {
                    CornerRadius = UDim.new(1,0)
                }),
            }),
            ToggleIcon,
        })
    })

    function Toggle:Lock()
        CanCallback = false
        return Toggle.ToggleFrame:Lock()
    end
    function Toggle:Unlock()
        CanCallback = true
        return Toggle.ToggleFrame:Unlock()
    end
    
    if Toggle.Locked then
        Toggle:Lock()
    end

    local Toggled = Toggle.Value

    function Toggle:SetValue(newValue)
        Toggled = newValue or Toggled
        
        if Toggled then
            Tween(Toggle.UIElements.Toggle.Frame, 0.1, {
                Position = UDim2.new(1, -20 - 2, 0.5, 0),
                BackgroundTransparency = 1,
                Size = UDim2.new(0,20,0,20),
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
            Tween(Toggle.UIElements.Toggle.Frame.Frame, 0.1, {
                BackgroundTransparency = 0.15,
            }):Play()
            Tween(Toggle.UIElements.Toggle, 0.1, {
                BackgroundTransparency = 0.15,
            }):Play()
            Tween(Toggle.UIElements.Toggle.Stroke.UIStroke, 0.1, {
                Transparency = 0,
            }):Play()
        
            if ToggleIcon then 
                Tween(ToggleIcon, 0.1, {
                    ImageTransparency = 0,
                }):Play()
            end
        else
            Tween(Toggle.UIElements.Toggle.Frame, 0.1, {
                Position = UDim2.new(0, 3, 0.5, 0),
                BackgroundTransparency = 0.15,
                Size = UDim2.new(0,18,0,18),
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
            Tween(Toggle.UIElements.Toggle.Frame.Frame, 0.1, {
                BackgroundTransparency = 1,
            }):Play()
            Tween(Toggle.UIElements.Toggle, 0.1, {
                BackgroundTransparency = 0.95,
            }):Play()
            Tween(Toggle.UIElements.Toggle.Stroke.UIStroke, 0.1, {
                Transparency = 1,
            }):Play()
        
            if ToggleIcon then 
                Tween(ToggleIcon, 0.1, {
                    ImageTransparency = 1,
                }):Play()
            end
        end

        task.spawn(function()
            Toggle.Callback(Toggled)
        end)
        
        Toggled = not Toggled
    end

    Toggle:SetValue(Toggled)

    Toggle.ToggleFrame.UIElements.Main.MouseButton1Click:Connect(function()
        if CanCallback then
            Toggle:SetValue(Toggled)
        end
    end)
    
    return Toggle.__type, Toggle
end

return Element end function __DARKLUA_BUNDLE_MODULES.i()
local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New

local Element = {}

local HoldingSlider = false

function Element:New(Config)
    local Slider = {
        __type = "Slider",
        Title = Config.Title or "Slider",
        Desc = Config.Desc or nil,
        Locked = Config.Locked or nil,
        Value = Config.Value or {},
        Step = Config.Step or 1,
        Callback = Config.Callback or function() end,
        UIElements = {},
        IsFocusing = false,
    }
    local isTouch
    local moveconnection
    local releaseconnection
    local Value = Slider.Value.Default or Slider.Value.Min or 0
    
    local LastValue = Value
    local delta = (Value - (Slider.Value.Min or 0)) / ((Slider.Value.Max or 100) - (Slider.Value.Min or 0))
    
    local CanCallback = true
    
    Slider.SliderFrame = __DARKLUA_BUNDLE_MODULES.load('f')({
        Title = Slider.Title,
        Desc = Slider.Desc,
        Parent = Config.Parent,
        TextOffset = 160,
        Hover = false,
    })
    
    Slider.UIElements.SliderIcon = New("ImageLabel", {
        ImageTransparency = .9,
        BackgroundTransparency= 1,
        Image = "rbxassetid://18747052224",
        ScaleType = "Crop",
        Size = UDim2.new(0, 126, 0, 3),
        Name = "Frame",
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ThemeTag = {
            ImageColor3 = "Text"
        }
    }, {
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
        }),
        New("ImageLabel", {
            Name = "Frame",
            Size = UDim2.new(delta, 0, 1, 0),
            Image = "rbxassetid://18747052224",
            ScaleType = "Crop",
            BackgroundTransparency = 1,
            ImageTransparency = .4,
            ThemeTag = {
                ImageColor3 = "Text"
            }
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(1, 0),
            }),
            New("ImageLabel", {
                Size = UDim2.new(0, 13, 0, 13),
                Position = UDim2.new(1, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Image = "rbxassetid://18747052224",
                BackgroundTransparency = 1,
                ThemeTag = {
                    ImageColor3 = "Text",
                },
            })
        })
    })
    
    Slider.UIElements.SliderContainer = New("Frame", {
        Size = UDim2.new(0, 0, 0, 0),
        AutomaticSize = "XY",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        BackgroundTransparency = 1,
        Parent = Slider.SliderFrame.UIElements.Main,
    }, {
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
        }),
        Slider.UIElements.SliderIcon,
        New("TextBox", {
            Size = UDim2.new(0,60,0,0),
            TextXAlignment = "Right",
            Text = tostring(Value),
            ThemeTag = {
                TextColor3 = "Text"
            },
            TextTransparency = .4,
            AutomaticSize = "Y",
            TextSize = 15,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
            BackgroundTransparency = 1,
            LayoutOrder = -1,
        })
    })

    function Slider:Lock()
        CanCallback = false
        return Slider.SliderFrame:Lock()
    end
    function Slider:Unlock()
        CanCallback = true
        return Slider.SliderFrame:Unlock()
    end
    
    if Slider.Locked then
        Slider:Lock()
    end
    
    function Slider:Set(Value, input)
        if CanCallback then
            if not Slider.IsFocusing and not HoldingSlider and (not input or (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)) then
                Value = math.clamp(Value, Slider.Value.Min or 0, Slider.Value.Max or 100)
                
                local delta = math.clamp((Value - (Slider.Value.Min or 0)) / ((Slider.Value.Max or 100) - (Slider.Value.Min or 0)), 0, 1)
                Value = math.floor((Slider.Value.Min + delta * (Slider.Value.Max - Slider.Value.Min)) / Slider.Step + 0.5) * Slider.Step
    
                if Value ~= LastValue then
                    Slider.UIElements.SliderIcon.Frame.Size = UDim2.new(delta, 0, 1, 0)
                    Slider.UIElements.SliderContainer.TextBox.Text = tostring(Value)
                    LastValue = Value
                    Slider.Callback(Value)
                end
    
                if input then
                    isTouch = (input.UserInputType == Enum.UserInputType.Touch)
                    Slider.SliderFrame.UIElements.Main.Parent.Parent.ScrollingEnabled = false
                    HoldingSlider = true
                    moveconnection = game:GetService("RunService").RenderStepped:Connect(function()
                        local inputPosition = isTouch and input.Position.X or game:GetService("UserInputService"):GetMouseLocation().X
                        local delta = math.clamp((inputPosition - Slider.UIElements.SliderIcon.AbsolutePosition.X) / Slider.UIElements.SliderIcon.Size.X.Offset, 0, 1)
                        Value = math.floor((Slider.Value.Min + delta * (Slider.Value.Max - Slider.Value.Min)) / Slider.Step + 0.5) * Slider.Step
    
                        if Value ~= LastValue then
                            Slider.UIElements.SliderIcon.Frame.Size = UDim2.new(delta, 0, 1, 0)
                            Slider.UIElements.SliderContainer.TextBox.Text = tostring(Value)
                            LastValue = Value
                            Slider.Callback(Value)
                        end
                    end)
                    releaseconnection = game:GetService("UserInputService").InputEnded:Connect(function(endInput)
                        if (endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch) and input == endInput then
                            moveconnection:Disconnect()
                            releaseconnection:Disconnect()
                            HoldingSlider = false
                            Slider.SliderFrame.UIElements.Main.Parent.Parent.ScrollingEnabled = true
                        end
                    end)
                end
            end
        end
    end
    
    Slider.UIElements.SliderContainer.TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newValue = tonumber(Slider.UIElements.SliderContainer.TextBox.Text)
            if newValue then
                Slider:Set(newValue)
            else
                Slider.UIElements.SliderContainer.TextBox.Text = tostring(LastValue)
            end
        end
    end)
    
    Slider.UIElements.SliderContainer.InputBegan:Connect(function(input)
        Slider:Set(Value, input)
    end)
    
    return Slider.__type, Slider
end

return Element end function __DARKLUA_BUNDLE_MODULES.j()
local UserInputService = game:GetService("UserInputService")

local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New
local Tween = Creator.Tween

local Element = {
    UICorner = 6,
    UIPadding = 8,
}

function Element:New(Config)
    local Keybind = {
        __type = "Keybind",
        Title = Config.Title or "Keybind",
        Desc = Config.Desc or nil,
        Locked = Config.Locked or false,
        Value = Config.Value or "F",
        Callback = Config.Callback or function() end,
        CanChange = Config.CanChange or true,
        Picking = false,
        UIElements = {},
    }
    
    local CanCallback = true
    
    Keybind.KeybindFrame = __DARKLUA_BUNDLE_MODULES.load('f')({
        Title = Keybind.Title,
        Desc = Keybind.Desc,
        Parent = Config.Parent,
        TextOffset = 85,
        Hover = Keybind.CanChange,
    })
    
    Keybind.UIElements.Keybind = New("TextLabel",{
        BackgroundTransparency = .95,
        Text = Keybind.Value,
        TextSize = 15,
        TextXAlignment = "Right",
        --AutomaticSize = "XY",
        FontFace = Font.new(Creator.Font),
        Parent = Keybind.KeybindFrame.UIElements.Main,
        Size = UDim2.new(0,0,0,0),
        AnchorPoint = Vector2.new(1,0.5),
        Position = UDim2.new(1,0,0.5,0),
        ThemeTag = {
            BackgroundColor3 = "Text",
            TextColor3 = "Text",
        },
        ZIndex = 2
    }, {
        New("UICorner", {
            CornerRadius = UDim.new(0,Element.UICorner)
        }),
        New("UIStroke", {
            ThemeTag = {
                Color = "Text",
            },
            Transparency = .93,
            ApplyStrokeMode = "Border",
            Thickness = 1,
        }),
        New("UIPadding", {
            PaddingTop = UDim.new(0,Element.UIPadding),
            PaddingLeft = UDim.new(0,Element.UIPadding),
            PaddingRight = UDim.new(0,Element.UIPadding),
            PaddingBottom = UDim.new(0,Element.UIPadding),
        })
    })
    
    Keybind.UIElements.Keybind:GetPropertyChangedSignal("TextBounds"):Connect(function()
        Keybind.UIElements.Keybind.Size = UDim2.new(0,Keybind.UIElements.Keybind.TextBounds.X+(Element.UIPadding*2),0,Keybind.UIElements.Keybind.TextBounds.Y+(Element.UIPadding*2))
    end)

    function Keybind:Lock()
        CanCallback = false
        return Keybind.KeybindFrame:Lock()
    end
    function Keybind:Unlock()
        CanCallback = true
        return Keybind.KeybindFrame:Unlock()
    end
    
    if Keybind.Locked then
        Keybind:Lock()
    end

    Keybind.KeybindFrame.UIElements.Main.MouseButton1Click:Connect(function()
        if CanCallback then
            if Keybind.CanChange then
                Keybind.Picking = true
                Keybind.UIElements.Keybind.Text = "..."
                
                task.wait(0.2)
                
                local Event
                Event = UserInputService.InputBegan:Connect(function(Input)
                    local Key
            
                    if Input.UserInputType == Enum.UserInputType.Keyboard then
	                    Key = Input.KeyCode.Name
                    elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
	                    Key = "MouseLeft"
                    elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
	                    Key = "MouseRight"
                    end
            
                    local EndedEvent
                    EndedEvent = UserInputService.InputEnded:Connect(function(Input)
	                    if Input.KeyCode.Name == Key or Key == "MouseLeft" and Input.UserInputType == Enum.UserInputType.MouseButton1 or Key == "MouseRight" and Input.UserInputType == Enum.UserInputType.MouseButton2 then
		                    Keybind.Picking = false
		    
		                    Keybind.UIElements.Keybind.Text = Key
		                    Keybind.Value = Key
		
		                    Event:Disconnect()
		                    EndedEvent:Disconnect()
	                    end
                    end)
                end)
            end
        end
    end) 
    UserInputService.InputBegan:Connect(function(input)
        if CanCallback then
            if input.KeyCode.Name == Keybind.Value then
                Keybind.Callback(input.KeyCode.Name)
            end
        end
    end)
    return Keybind.__type, Keybind
end

return Element end function __DARKLUA_BUNDLE_MODULES.k()
local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New
local Tween = Creator.Tween

local Element = {
    UICorner = 6,
    UIPadding = 8,
}

function Element:New(Config)
    local Input = {
        __type = "Input",
        Title = Config.Title or "Input",
        Desc = Config.Desc or nil,
        Locked = Config.Locked or false,
        PlaceholderText = Config.PlaceholderText or "Enter Text...",
        Value = Config.Value or "",
        Callback = Config.Callback or function() end,
        ClearTextOnFocus = Config.ClearTextOnFocus or false,
        UIElements = {},
    }
    
    local CanCallback = true
    
    Input.InputFrame = __DARKLUA_BUNDLE_MODULES.load('f')({
        Title = Input.Title,
        Desc = Input.Desc,
        Parent = Config.Parent,
        TextOffset = 160,
        Hover = false,
    })
    
    Input.UIElements.Input = New("Frame",{
        BackgroundTransparency = .95,
        Parent = Input.InputFrame.UIElements.Main,
        Size = UDim2.new(0,30*5,0,30),
        AnchorPoint = Vector2.new(1,0.5),
        Position = UDim2.new(1,0,0.5,0),
        ThemeTag = {
            BackgroundColor3 = "Text",
        },
        ZIndex = 2
    }, {
        New("TextBox", {
            MultiLine = false,
            Size = UDim2.new(1,0,0,0),
            AutomaticSize = "Y",
            BackgroundTransparency = 1,
            Position = UDim2.new(0,0,0.5,0),
            AnchorPoint = Vector2.new(0,0.5),
            ClearTextOnFocus = Input.ClearTextOnFocus,
            Text = Input.Value,
            TextSize = 15,
            ClipsDescendants = true,
            TextXAlignment = "Left",
            FontFace = Font.new(Creator.Font),
            PlaceholderText = Input.PlaceholderText,
            ThemeTag = {
                TextColor3 = "Text",
                PlaceholderColor3 = "PlaceholderText",
            }
        }),
        New("UICorner", {
            CornerRadius = UDim.new(0,Element.UICorner)
        }),
        New("UIStroke", {
            ThemeTag = {
                Color = "Text",
            },
            Transparency = .93,
            ApplyStrokeMode = "Border",
            Thickness = 1,
        }),
        New("UIPadding", {
            PaddingTop = UDim.new(0,Element.UIPadding),
            PaddingLeft = UDim.new(0,Element.UIPadding),
            PaddingRight = UDim.new(0,Element.UIPadding),
            PaddingBottom = UDim.new(0,Element.UIPadding),
        })
    })
    
    -- Input.UIElements.Input.TextBox:GetPropertyChangedSignal("TextBounds"):Connect(function()
    --     Input.UIElements.Input.TextBox.Size = UDim2.new(1,0,0,Input.UIElements.Input.TextBox.TextBounds.Y)
    -- end)

    function Input:Lock()
        CanCallback = false
        return Input.InputFrame:Lock()
    end
    function Input:Unlock()
        CanCallback = true
        return Input.InputFrame:Unlock()
    end
    
    if Input.Locked then
        Input:Lock()
    end
    
    Input.UIElements.Input.TextBox.Focused:Connect(function()
        if not CanCallback then
            Input.UIElements.Input.TextBox:ReleaseFocus()
            return
        end
        Tween(Input.UIElements.Input.UIStroke, 0.1, {Transparency = .8}):Play()
    end)
    
    Input.UIElements.Input.TextBox.FocusLost:Connect(function()
        if CanCallback then
            Input.Callback(Input.UIElements.Input.TextBox.Text)
            Tween(Input.UIElements.Input.UIStroke, 0.1, {Transparency = .93}):Play()
        end
    end)

    return Input.__type, Input
end

return Element end function __DARKLUA_BUNDLE_MODULES.l()
local UserInputService = game:GetService("UserInputService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local Camera = game:GetService("Workspace").CurrentCamera

local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New
local Tween = Creator.Tween

local Element = {
    UICorner = 6,
    UIPadding = 8,
    MenuCorner = 14,
    MenuPadding = 7,
    TabPadding = 10,
}

function Element:New(Config)
    local Dropdown = {
        __type = "Dropdown",
        Title = Config.Title or "Dropdown",
        Desc = Config.Desc or nil,
        Locked = Config.Locked or false,
        Values = Config.Values or {},
        Value = Config.Value,
        AllowNone = Config.AllowNone,
        Multi = Config.Multi,
        Callback = Config.Callback or function() end,
        
        UIElements = {},
        
        Opened = false,
        Tabs = {}
    }
    
    local CanCallback = true
    
    Dropdown.DropdownFrame = __DARKLUA_BUNDLE_MODULES.load('f')({
        Title = Dropdown.Title,
        Desc = Dropdown.Desc,
        Parent = Config.Parent,
        TextOffset = 160,
        Hover = false,
    })
    
    Dropdown.UIElements.Dropdown = New("TextButton",{
        BackgroundTransparency = .95,
        Text = "",
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
        TextSize = 15,
        TextTransparency = .4,
        TextXAlignment = "Left",
        Parent = Dropdown.DropdownFrame.UIElements.Main,
        Size = UDim2.new(0,30*5,0,30),
        AnchorPoint = Vector2.new(1,0.5),
        TextTruncate = "AtEnd",
        Position = UDim2.new(1,0,0.5,0),
        ThemeTag = {
            BackgroundColor3 = "Text",
            TextColor3 = "Text"
        },
        ZIndex = 2
    }, {
        New("UICorner", {
            CornerRadius = UDim.new(0,Element.UICorner)
        }),
        New("UIStroke", {
            ThemeTag = {
                Color = "Text",
            },
            Transparency = .93,
            ApplyStrokeMode = "Border",
            Thickness = 1,
        }),
        New("UIPadding", {
            PaddingTop = UDim.new(0,Element.UIPadding),
            PaddingLeft = UDim.new(0,Element.UIPadding),
            PaddingRight = UDim.new(0,Element.UIPadding*2 + 18),
            PaddingBottom = UDim.new(0,Element.UIPadding),
        }),
        New("ImageLabel", {
            Image = Creator.Icon("chevron-down")[1],
            ImageRectOffset = Creator.Icon("chevron-down")[2].ImageRectPosition,
            ImageRectSize = Creator.Icon("chevron-down")[2].ImageRectSize,
            Size = UDim2.new(0,18,0,18),
            Position = UDim2.new(1,Element.UIPadding + 18,0.5,0),
            ThemeTag = {
                ImageColor3 = "Text"
            },
            AnchorPoint = Vector2.new(1,0.5),
        })
    })

    Dropdown.UIElements.UIListLayout = New("UIListLayout", {
        Padding = UDim.new(0,Element.MenuPadding/1.5),
        FillDirection = "Vertical"
    })

    Dropdown.UIElements.Menu = New("Frame", {
        ThemeTag = {
            BackgroundColor3 = "Accent",
        },
        BackgroundTransparency = 0.15,
        Size = UDim2.new(1,0,1,0)
    }, {
--         New("UISizeConstraint", {
--			MinSize = Vector2.new(190, 0),
--		}),
        New("UICorner", {
            CornerRadius = UDim.new(0,Element.MenuCorner)
        }),
        New("UIStroke", {
            Thickness = 1,
            Transparency = .93,
            ThemeTag = {
                Color = "Text"
            }
        }),
		New("Frame", {
		    BackgroundTransparency = 1,
		    Size = UDim2.new(1,0,1,0),
		    Name = "CanvasGroup",
		    ClipsDescendants = true
		}, {
            New("UIPadding", {
                PaddingTop = UDim.new(0, Element.MenuPadding),
                PaddingLeft = UDim.new(0, Element.MenuPadding),
                PaddingRight = UDim.new(0, Element.MenuPadding),
                PaddingBottom = UDim.new(0, Element.MenuPadding),
            }),
            New("ScrollingFrame", {
                Size = UDim2.new(1,0,1,0),
                ScrollBarThickness = 0,
                ScrollingDirection = "Y",
                AutomaticCanvasSize = "Y",
                CanvasSize = UDim2.new(0,0,0,0),
                BackgroundTransparency = 1,
            }, {
                Dropdown.UIElements.UIListLayout,
            })
		})
    })

    Dropdown.UIElements.MenuCanvas = New("CanvasGroup", {
        Size = UDim2.new(0,190,0,300),
        BackgroundTransparency = 1,
        Position = UDim2.new(-10,0,-10,0),
        Visible = false,
        Active = false,
        GroupTransparency = 1, -- 0
        Parent = Config.Window.SuperParent.Parent.Dropdowns,

    }, {
        Dropdown.UIElements.Menu,
        New("UIPadding", {
            PaddingTop = UDim.new(0,1),
            PaddingLeft = UDim.new(0,1),
            PaddingRight = UDim.new(0,1),
            PaddingBottom = UDim.new(0,1),
        }),
        New("UISizeConstraint", {
            MinSize = Vector2.new(190,0)
        })
    })
    
    function Dropdown:Lock()
        CanCallback = false
        return Dropdown.DropdownFrame:Lock()
    end
    function Dropdown:Unlock()
        CanCallback = true
        return Dropdown.DropdownFrame:Unlock()
    end
    
    if Dropdown.Locked then
        Dropdown:Lock()
    end
    
    local function RecalculateCanvasSize()
		Dropdown.UIElements.Menu.CanvasGroup.ScrollingFrame.CanvasSize = UDim2.fromOffset(0, Dropdown.UIElements.UIListLayout.AbsoluteContentSize.Y)
    end

    local function RecalculateListSize()
		if #Dropdown.Values > 10 then
			Dropdown.UIElements.MenuCanvas.Size = UDim2.fromOffset(Dropdown.UIElements.UIListLayout.AbsoluteContentSize.X, 392)
		else
			Dropdown.UIElements.MenuCanvas.Size = UDim2.fromOffset(Dropdown.UIElements.UIListLayout.AbsoluteContentSize.X, Dropdown.UIElements.UIListLayout.AbsoluteContentSize.Y + Element.MenuPadding*2 +1)
		end
	end
    
    function UpdatePosition()
        local Add = -35
        if Camera.ViewportSize.Y - Dropdown.UIElements.Dropdown.AbsolutePosition.Y + Add < Dropdown.UIElements.MenuCanvas.AbsoluteSize.Y + 10 then
            Add = Dropdown.UIElements.MenuCanvas.AbsoluteSize.Y
                - (Camera.ViewportSize.Y - Dropdown.UIElements.Dropdown.AbsolutePosition.Y)
                + 10
        end
        Dropdown.UIElements.MenuCanvas.Position = UDim2.fromOffset(Dropdown.UIElements.Dropdown.AbsolutePosition.X - 1, Dropdown.UIElements.Dropdown.AbsolutePosition.Y - Add)
    end
    
    function Dropdown:Display()
		local Values = Dropdown.Values
		local Str = ""

		if Dropdown.Multi then
			for Idx, Value in next, Values do
				if table.find(Dropdown.Value, Value) then
					Str = Str .. Value .. ", "
				end
			end
			Str = Str:sub(1, #Str - 2)
		else
			Str = Dropdown.Value or ""
		end

		Dropdown.UIElements.Dropdown.Text = (Str == "" and "--" or Str)
	end
    
    function Dropdown:Refresh(Values)
        for _, Elementt in next, Dropdown.UIElements.Menu.CanvasGroup.ScrollingFrame:GetChildren() do
            if not Elementt:IsA("UIListLayout") then
                Elementt:Destroy()
            end
        end
        
        Dropdown.Tabs = {}
        
        for Index,Tab in next, Values do
            --task.wait(0.012)
            local TabMain = {
                Name = Tab,
                Selected = false,
                UIElements = {},
            }
            TabMain.UIElements.TabItem = New("TextButton", {
                Size = UDim2.new(1,0,0,34),
                --AutomaticSize = "Y",
                BackgroundTransparency = 1,
                Parent = Dropdown.UIElements.Menu.CanvasGroup.ScrollingFrame,
                Text = "",
                
            }, {
                New("UIPadding", {
                    PaddingTop = UDim.new(0,Element.TabPadding),
                    PaddingLeft = UDim.new(0,Element.TabPadding),
                    PaddingRight = UDim.new(0,Element.TabPadding),
                    PaddingBottom = UDim.new(0,Element.TabPadding),
                }),
                New("UICorner", {
                    CornerRadius = UDim.new(0,Element.MenuCorner - Element.MenuPadding)
                }),
                New("ImageLabel", {
                    Image = Creator.Icon("check")[1],
                    ImageRectSize = Creator.Icon("check")[2].ImageRectSize,
                    ImageRectOffset = Creator.Icon("check")[2].ImageRectPosition,
                    ThemeTag = {
                        ImageColor3 = "Text",
                    },
                    ImageTransparency = 1, -- .1
                    Size = UDim2.new(0,18,0,18),
                    AnchorPoint = Vector2.new(0,0.5),
                    Position = UDim2.new(0,0,0.5,0),
                    BackgroundTransparency = 1,
                }),
                New("TextLabel", {
                    Text = Tab,
                    TextXAlignment = "Left",
                    FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                    ThemeTag = {
                        TextColor3 = "Text",
                        BackgroundColor3 = "Text"
                    },
                    TextSize = 15,
                    BackgroundTransparency = 1,
                    TextTransparency = .4,
                    AutomaticSize = "Y",
                    TextTruncate = "AtEnd",
                    Size = UDim2.new(1,-18-Element.TabPadding*3,0,0),
                    AnchorPoint = Vector2.new(0,0.5),
                    Position = UDim2.new(0,0,0.5,0), -- 0,18+Element.TabPadding,0.5,0
                })
            })
        
        
            if Dropdown.Multi then
                TabMain.Selected = table.find(Dropdown.Value or {}, TabMain.Name)
            else
                TabMain.Selected = Dropdown.Value == TabMain.Name
            end
            
            if TabMain.Selected then
                TabMain.UIElements.TabItem.BackgroundTransparency = .93
                TabMain.UIElements.TabItem.ImageLabel.ImageTransparency = .1
                TabMain.UIElements.TabItem.TextLabel.Position = UDim2.new(0,18+Element.TabPadding,0.5,0)
                TabMain.UIElements.TabItem.TextLabel.TextTransparency = 0
            end
            
            Dropdown.Tabs[Index] = TabMain
            
            local function Callback()
                Dropdown:Display()
                task.spawn(function()
                    Dropdown.Callback(Dropdown.Value)
                end)
            end
            
            TabMain.UIElements.TabItem.MouseButton1Click:Connect(function()
                if Dropdown.Multi then
                    if not TabMain.Selected then
                        TabMain.Selected = true
                        Tween(TabMain.UIElements.TabItem, 0.1, {BackgroundTransparency = .93}):Play()
                        Tween(TabMain.UIElements.TabItem.ImageLabel, 0.1, {ImageTransparency = .1}):Play()
                        Tween(TabMain.UIElements.TabItem.TextLabel, 0.1, {Position = UDim2.new(0,18+Element.TabPadding,0.5,0), TextTransparency = 0}):Play()
                        table.insert(Dropdown.Value, TabMain.Name)
                    else
                        if not Dropdown.AllowNone and #Dropdown.Value == 1 then
                            return
                        end
                        TabMain.Selected = false
                        Tween(TabMain.UIElements.TabItem, 0.1, {BackgroundTransparency = 1}):Play()
                        Tween(TabMain.UIElements.TabItem.ImageLabel, 0.1, {ImageTransparency = 1}):Play()
                        Tween(TabMain.UIElements.TabItem.TextLabel, 0.1, {Position = UDim2.new(0,0,0.5,0), TextTransparency = .4}):Play()
                        for i, v in ipairs(Dropdown.Value) do
                            if v == TabMain.Name then
                                table.remove(Dropdown.Value, i)
                                break
                            end
                        end
                    end
                else
                    for Index, TabPisun in next, Dropdown.Tabs do
                        -- pisun
                        Tween(TabPisun.UIElements.TabItem, 0.1, {BackgroundTransparency = 1}):Play()
                        Tween(TabPisun.UIElements.TabItem.ImageLabel, 0.1, {ImageTransparency = 1}):Play()
                        Tween(TabPisun.UIElements.TabItem.TextLabel, 0.1, {Position = UDim2.new(0,0,0.5,0), TextTransparency = .4}):Play()
                        TabPisun.Selected = false
                    end
                    TabMain.Selected = true
                    Tween(TabMain.UIElements.TabItem, 0.1, {BackgroundTransparency = .93}):Play()
                    Tween(TabMain.UIElements.TabItem.ImageLabel, 0.1, {ImageTransparency = .1}):Play()
                    Tween(TabMain.UIElements.TabItem.TextLabel, 0.1, {Position = UDim2.new(0,18+Element.TabPadding,0.5,0), TextTransparency = 0}):Play()
                    Dropdown.Value = TabMain.Name
                end
                Callback()
            end)
            
            RecalculateCanvasSize()
            RecalculateListSize()
        end
    end
    
    Dropdown:Refresh(Dropdown.Values)
    
    function Dropdown:Select(Items)
        if Items then
            Dropdown.Value = Items
        end
        Dropdown:Refresh(Dropdown.Values)
    end
    
    Dropdown:Display()
    RecalculateListSize()
    
    function Dropdown:Open()
        Dropdown.Opened = true
        Dropdown.UIElements.MenuCanvas.Visible = true
        Dropdown.UIElements.MenuCanvas.Active = true
        Dropdown.UIElements.Menu.Size = UDim2.new(
            1, 0,
            0, 0
        )
        Tween(Dropdown.UIElements.Menu, 0.1, {
            Size = UDim2.new(
                1, 0,
                1, 0
            )
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
        
        Tween(Dropdown.UIElements.Dropdown.ImageLabel, .15, {Rotation = 180}):Play()
        Tween(Dropdown.UIElements.MenuCanvas, .15, {GroupTransparency = 0}):Play()
        
        UpdatePosition()
    end
    function Dropdown:Close()
        Dropdown.Opened = false
        
        Tween(Dropdown.UIElements.Menu, 0.1, {
            Size = UDim2.new(
                1, 0,
                0.8, 0
            )
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
        Tween(Dropdown.UIElements.Dropdown.ImageLabel, .15, {Rotation = 0}):Play()
        Tween(Dropdown.UIElements.MenuCanvas, .15, {GroupTransparency = 1}):Play()
        task.wait(.1)
        Dropdown.UIElements.MenuCanvas.Visible = false
        Dropdown.UIElements.MenuCanvas.Active = false
    end
    
    Dropdown.UIElements.Dropdown.MouseButton1Click:Connect(function()
        if CanCallback then
            Dropdown:Open()
        end
    end)
    
    UserInputService.InputBegan:Connect(function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			local AbsPos, AbsSize = Dropdown.UIElements.MenuCanvas.AbsolutePosition, Dropdown.UIElements.MenuCanvas.AbsoluteSize
			if
				Config.Window.CanDropdown
				and (Mouse.X < AbsPos.X
				or Mouse.X > AbsPos.X + AbsSize.X
				or Mouse.Y < (AbsPos.Y - 20 - 1)
				or Mouse.Y > AbsPos.Y + AbsSize.Y)
			then
				Dropdown:Close()
			end
		end
	end)
    
    Dropdown.UIElements.Dropdown:GetPropertyChangedSignal("AbsolutePosition"):Connect(UpdatePosition)
    
    return Dropdown.__type, Dropdown
end

return Element end function __DARKLUA_BUNDLE_MODULES.m()
-- Credits: https://devforum.roblox.com/t/realtime-richtext-lua-syntax-highlighting/2500399
-- Modified by me (Footagesus)




local highlighter = {}
local keywords = {
	lua = {
		"and", "break", "or", "else", "elseif", "if", "then", "until", "repeat", "while", "do", "for", "in", "end",
		"local", "return", "function", "export"
	},
	rbx = {
		"game", "workspace", "script", "math", "string", "table", "task", "wait", "select", "next", "Enum",
		"error", "warn", "tick", "assert", "shared", "loadstring", "tonumber", "tostring", "type",
		"typeof", "unpack", "print", "Instance", "CFrame", "Vector3", "Vector2", "Color3", "UDim", "UDim2", "Ray", "BrickColor",
		"OverlapParams", "RaycastParams", "Axes", "Random", "Region3", "Rect", "TweenInfo",
		"collectgarbage", "not", "utf8", "pcall", "xpcall", "_G", "setmetatable", "getmetatable", "os", "pairs", "ipairs"
	},
	operators = {
		"#", "+", "-", "*", "%", "/", "^", "=", "~", "=", "<", ">",
	}
}

local colors = {
    numbers = Color3.fromHex("#79c0ff"),
    boolean = Color3.fromHex("#79c0ff"),
    operator = Color3.fromHex("#ff7b72"),
    lua = Color3.fromHex("#ff7b72"),
    rbx = Color3.fromHex("#c9d1d9"), -- def
    str = Color3.fromHex("#a5d6ff"),
    comment = Color3.fromHex("#8b949e"),
    null = Color3.fromHex("#79c0ff"),
    call = Color3.fromHex("#d2a8ff"),    
    self_call = Color3.fromHex("#d2a8ff"),
    local_property = Color3.fromHex("#ff7b72"),
}

local function createKeywordSet(keywords)
	local keywordSet = {}
	for _, keyword in ipairs(keywords) do
		keywordSet[keyword] = true
	end
	return keywordSet
end

local luaSet = createKeywordSet(keywords.lua)
local rbxSet = createKeywordSet(keywords.rbx)
local operatorsSet = createKeywordSet(keywords.operators)

local function getHighlight(tokens, index)
	local token = tokens[index]

	if colors[token .. "_color"] then
		return colors[token .. "_color"]
	end

	if tonumber(token) then
		return colors.numbers
	elseif token == "nil" then
		return colors.null
	elseif token:sub(1, 2) == "--" then
		return colors.comment
	elseif operatorsSet[token] then
		return colors.operator
	elseif luaSet[token] then
		return colors.lua
	elseif rbxSet[token] then
		return colors.rbx
	elseif token:sub(1, 1) == "\"" or token:sub(1, 1) == "\'" then
		return colors.str
	elseif token == "true" or token == "false" then
		return colors.boolean
	end

	if tokens[index + 1] == "(" then
		if tokens[index - 1] == ":" then
			return colors.self_call
		end

		return colors.call
	end

	if tokens[index - 1] == "." then
		if tokens[index - 2] == "Enum" then
			return colors.rbx
		end

		return colors.local_property
	end
end

function highlighter.run(source)
	local tokens = {}
	local currentToken = ""
	
	local inString = false
	local inComment = false
	local commentPersist = false
	
	for i = 1, #source do
		local character = source:sub(i, i)
		
		if inComment then
			if character == "\n" and not commentPersist then
				table.insert(tokens, currentToken)
				table.insert(tokens, character)
				currentToken = ""
				
				inComment = false
			elseif source:sub(i - 1, i) == "]]" and commentPersist then
				currentToken ..= "]"
				
				table.insert(tokens, currentToken)
				currentToken = ""
				
				inComment = false
				commentPersist = false
			else
				currentToken = currentToken .. character
			end
		elseif inString then
			if character == inString and source:sub(i-1, i-1) ~= "\\" or character == "\n" then
				currentToken = currentToken .. character
				inString = false
			else
				currentToken = currentToken .. character
			end
		else
			if source:sub(i, i + 1) == "--" then
				table.insert(tokens, currentToken)
				currentToken = "-"
				inComment = true
				commentPersist = source:sub(i + 2, i + 3) == "[["
			elseif character == "\"" or character == "\'" then
				table.insert(tokens, currentToken)
				currentToken = character
				inString = character
			elseif operatorsSet[character] then
				table.insert(tokens, currentToken)
				table.insert(tokens, character)
				currentToken = ""
			elseif character:match("[%w_]") then
				currentToken = currentToken .. character
			else
				table.insert(tokens, currentToken)
				table.insert(tokens, character)
				currentToken = ""
			end
		end
	end
	
	table.insert(tokens, currentToken)

	local highlighted = {}
	
	for i, token in ipairs(tokens) do
		local highlight = getHighlight(tokens, i)

		if highlight then
			local syntax = string.format("<font color = \"#%s\">%s</font>", highlight:ToHex(), token:gsub("<", "&lt;"):gsub(">", "&gt;"))
			
			table.insert(highlighted, syntax)
		else
			table.insert(highlighted, token)
		end
	end

	return table.concat(highlighted)
end

return highlighter end function __DARKLUA_BUNDLE_MODULES.n()
local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New

local Highlighter = __DARKLUA_BUNDLE_MODULES.load('m')

local Element = {}

function Element:New(Config)
    local Code = {
        __type = "Code",
        Title = Config.Title,
        Code = Config.Code or nil,
        Locked = Config.Locked or false,
        UIElements = {}
    }
    
    local CanCallback = true
    
    Code.CodeFrame = __DARKLUA_BUNDLE_MODULES.load('f')({
        Title = Code.Title,
        Desc = Code.Code,
        Parent = Config.Parent,
        TextOffset = 40,
        Hover = false,
    })
    
    Code.CodeFrame.UIElements.Main.Title.Desc:Destroy()
    
    local Divider = New("Frame", {
        Size = UDim2.new(1,Code.CodeFrame.UIPadding*2,0,1),
        -- Position = UDim2.new(0.5,0,0,0),
        -- AnchorPoint = Vector2.new(0.5,0),
        BackgroundTransparency = .94, 
        ThemeTag = {
            BackgroundColor3 = "Text"
        },
        Parent = Code.CodeFrame.UIElements.Main.Title,
        LayoutOrder = 1,
    })
    
    local CopyButton = New("ImageButton", {
        Image = Creator.Icon("clipboard")[1],
        ImageRectSize = Creator.Icon("clipboard")[2].ImageRectSize,
        ImageRectOffset = Creator.Icon("clipboard")[2].ImageRectPosition,
        BackgroundTransparency = 1,
        Size = UDim2.new(0,14,0,14),
        Position = UDim2.new(1,40,0,0),
        AnchorPoint = Vector2.new(1,0),
        Parent = Code.CodeFrame.UIElements.Main.Title.Title
    })
    
    local TextLabel = New("TextLabel", {
        Text = "",
        TextColor3 = Color3.fromHex("#c9d1d9"),
        TextTransparency = 0,
        TextSize = 15,
        TextWrapped = false,
        LineHeight = 1.15,
        RichText = true,
        TextXAlignment = "Left",
        Size = UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        AutomaticSize = "XY",
    })
    
    TextLabel.FontFace = Font.new("rbxassetid://16658246179", Enum.FontWeight.Medium)
    
    local ScrollingFrame = New("ScrollingFrame", {
        Size = UDim2.new(1,0,0,0),
        BackgroundTransparency = 1,
        AutomaticCanvasSize = "X",
        ScrollingDirection = "X",
        ElasticBehavior = "Never",
        CanvasSize = UDim2.new(0,0,0,0),
        ScrollBarThickness = 0,
    }, {
        TextLabel
    })
    
    local ScrollingFrameContainer = New("Frame", {
        Size = UDim2.new(1,0,0,0),
        AutomaticSize = "Y",
        BackgroundColor3 = Color3.fromRGB(13, 17, 23),
        BackgroundTransparency = .2,
        Parent = Code.CodeFrame.UIElements.Main.Title,
        LayoutOrder = 9999,
    }, {
        ScrollingFrame,
        New("UICorner", {
            CornerRadius = UDim.new(0,8),
        }),
        New("UIPadding", {
            PaddingTop = UDim.new(0,12),
            PaddingLeft = UDim.new(0,12),
            PaddingRight = UDim.new(0,12),
            PaddingBottom = UDim.new(0,12),
        })
    })
    
    TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
        ScrollingFrame.Size = UDim2.new(1,0,0,TextLabel.TextBounds.Y)
    end)
    
    
    TextLabel.Text = Highlighter.run(Code.Code)

    function Code:Lock()
        CanCallback = false
        return Code.CodeFrame:Lock()
    end
    function Code:Unlock()
        CanCallback = true
        return Code.CodeFrame:Unlock()
    end
    function Code:SetCode(code)
        TextLabel.Text = Highlighter.run(code)
    end
    
    if Code.Locked then
        Code:Lock()
    end

    CopyButton.MouseButton1Click:Connect(function()
        if CanCallback then
            toclipboard(Code.Code)
            Config.WindUI:Notify({
                Title = "Copied!",
                Content = "The '" .. Code.Title .. "' copied to your clipboard.",
                Icon = "clipboard-copy",
                Duration = 5,
            })
        end
    end)
    return Code.__type, Code
end

return Element end function __DARKLUA_BUNDLE_MODULES.o()
local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New
local Tween = Creator.Tween

local UserInputService = game:GetService("UserInputService")
local TouchInputService = game:GetService("TouchInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local RenderStepped = RunService.RenderStepped
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()


local Element = {
    UICorner = 6,
    UIPadding = 8
}

function Element:Colorpicker(Config, OnApply)
    local Colorpicker = {
        __type = "Colorpicker",
        Title = Config.Title,
        Desc = Config.Desc,
        Default = Config.Default,
        Callback = Config.Callback,
        Transparency = Config.Transparency,
        UIElements = Config.UIElements,
    }
    
    function Colorpicker:SetHSVFromRGB(Color)
		local H, S, V = Color3.toHSV(Color)
		Colorpicker.Hue = H
		Colorpicker.Sat = S
		Colorpicker.Vib = V
	end

	Colorpicker:SetHSVFromRGB(Colorpicker.Default)
    
    local ColorpickerModule = __DARKLUA_BUNDLE_MODULES.load('c').Init(Config.Window)
    local ColorpickerFrame = ColorpickerModule.Create()
    
    Colorpicker.ColorpickerFrame = ColorpickerFrame
    
    ColorpickerFrame:Close()
    
    local Hue, Sat, Vib = Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib

    Colorpicker.UIElements.Title = New("TextLabel", {
        Text = "Colorpicker",
        TextSize = 20,
        FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
        TextXAlignment = "Left",
        Size = UDim2.new(1,0,0,0),
        AutomaticSize = "Y",
        ThemeTag = {
            TextColor3 = "Text"
        },
        BackgroundTransparency = 1,
        Parent = ColorpickerFrame.UIElements.Main
    })
    
    -- Colorpicker.UIElements.Title:GetPropertyChangedSignal("TextBounds"):Connect(function()
    --     Colorpicker.UIElements.Title.Size = UDim2.new(1,0,0,Colorpicker.UIElements.Title.TextBounds.Y)
    -- end)

    local SatCursor = New("ImageLabel", {
		Size = UDim2.new(0, 18, 0, 18),
		ScaleType = Enum.ScaleType.Fit,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = "http://www.roblox.com/asset/?id=4805639000",
	})

    Colorpicker.UIElements.SatVibMap = New("ImageLabel", {
  		Size = UDim2.fromOffset(160, 182-24),
  		Position = UDim2.fromOffset(0, 40),
  		Image = "rbxassetid://4155801252",
  		BackgroundColor3 = Color3.fromHSV(Hue, 1, 1),
  		BackgroundTransparency = 0,
  		Parent = ColorpickerFrame.UIElements.Main,
  	}, {
  		New("UICorner", {
  			CornerRadius = UDim.new(0, 6),
  		}),
  		New("UIStroke", {
  			Thickness = .6,
  			ThemeTag = {
  			    Color = "Text"
  			},
  			Transparency = .8,
  		}),
  		SatCursor,
  	})
  	
  	Colorpicker.UIElements.Inputs = New("Frame", {
  	    AutomaticSize = "XY",
  	    Position = UDim2.fromOffset(Colorpicker.Transparency and 160+10+10+20+20+10 or 160+10+10+20, 40),
  	    BackgroundTransparency = 1,
  	    Parent = ColorpickerFrame.UIElements.Main
  	}, {
  	    New("UIListLayout", {
  		    Padding = UDim.new(0, 8),
  		    FillDirection = "Vertical",
  	    })
  	})
  	
--	Colorpicker.UIElements.Inputs.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
--         Colorpicker.UIElements.Inputs.Size = UDim2.new(0,Colorpicker.UIElements.Inputs.UIListLayout.AbsoluteContentSize.X,0,Colorpicker.UIElements.Inputs.UIListLayout.AbsoluteContentSize.Y)
--     end)
	
	local OldColorFrame = New("Frame", {
		BackgroundColor3 = Colorpicker.Default,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = Colorpicker.Transparency,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 6),
		}),
	})

	local OldColorFrameChecker = New("ImageLabel", {
		Image = "http://www.roblox.com/asset/?id=14204231522",
		ImageTransparency = 0.45,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = UDim2.fromOffset(40, 40),
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(75+10, 40+182-24+10),
		Size = UDim2.fromOffset(75, 24),
		Parent = ColorpickerFrame.UIElements.Main,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 6),
		}),
		New("UIStroke", {
			Thickness = .6,
			Transparency = 0.8,
			ThemeTag = {
			    Color = "Text"
			}
		}),
		OldColorFrame,
	})

	local NewDisplayFrame = New("Frame", {
		BackgroundColor3 = Colorpicker.Default,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 0,
		ZIndex = 9,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
	})

	local NewDisplayFrameChecker = New("ImageLabel", {
		Image = "http://www.roblox.com/asset/?id=14204231522",
		ImageTransparency = 0.45,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = UDim2.fromOffset(40, 40),
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 40+182-24+10),
		Size = UDim2.fromOffset(75, 24),
		Parent = ColorpickerFrame.UIElements.Main,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
		New("UIStroke", {
			Thickness = .6,
			Transparency = 0.8,
			ThemeTag = {
			    Color = "Text"
			}
		}),
		NewDisplayFrame,
	})
	
	local SequenceTable = {}

	for Color = 0, 1, 0.1 do
		table.insert(SequenceTable, ColorSequenceKeypoint.new(Color, Color3.fromHSV(Color, 1, 1)))
	end

	local HueSliderGradient = New("UIGradient", {
		Color = ColorSequence.new(SequenceTable),
		Rotation = 90,
	})
	
	local HueDragHolder = New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0,0,0,0),
		BackgroundTransparency = 1,
	})

	local HueDrag = New("ImageLabel", {
		Size = UDim2.new(1,0,0,3),
		Image = "rbxassetid://18747052224",
		AnchorPoint = Vector2.new(0,0.5),
		Parent = HueDragHolder,
		ScaleType = "Crop",
		ThemeTag = {
			ImageColor3 = "Text",
		},
	})

	local HueSlider = New("Frame", {
		Size = UDim2.fromOffset(20, 182+10),
		Position = UDim2.fromOffset(160+10, 40),
		Parent = ColorpickerFrame.UIElements.Main,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 6),
		}),
		HueSliderGradient,
		HueDragHolder,
	})
	
	
	function CreateInput(Title, Value)
	    local Container = New("Frame", {
	        Size = UDim2.new(0,120,0,28),
	        AutomaticSize = "Y",
	        BackgroundTransparency = 1,
	        Parent = Colorpicker.UIElements.Inputs
	    }, {
	        New("UIListLayout", {
		        Padding = UDim.new(0,10),
		        FillDirection = "Vertical",
	        }),
	        New("Frame",{
                BackgroundTransparency = .95,
                Size = UDim2.new(1,0,0,30),
                AnchorPoint = Vector2.new(1,0.5),
                Position = UDim2.new(1,0,0.5,0),
                ThemeTag = {
                    BackgroundColor3 = "Text",
                },
                ZIndex = 2
            }, {
                New("TextBox", {
                    MultiLine = false,
                    Size = UDim2.new(1,-40,0,0),
                    AutomaticSize = "Y",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0,0,0.5,0),
                    AnchorPoint = Vector2.new(0,0.5),
                    ClearTextOnFocus = false,
                    Text = Value,
                    TextSize = 15,
                    ClipsDescendants = true,
                    TextXAlignment = "Left",
                    FontFace = Font.new(Creator.Font),
                    PlaceholderText = "",
                    ThemeTag = {
                        TextColor3 = "Text",
                    }
                }),
                New("TextLabel", {
	                Text = Title,
	                TextSize = 16,
	                FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
	                ThemeTag = {
	                    TextColor3 = "Text"
	                },
	                BackgroundTransparency = 1,
	                TextXAlignment = "Right",
	                Position = UDim2.new(1,0,0.5,0),
	                AnchorPoint = Vector2.new(1,0.5),
	                Size = UDim2.new(0,0,0,0),
	                TextTransparency = .4,
	                AutomaticSize = "XY",
	            }),
                New("UICorner", {
                    CornerRadius = UDim.new(0,Element.UICorner)
                }),
                New("UIStroke", {
                    ThemeTag = {
                        Color = "Text",
                    },
                    Transparency = .93,
                    ApplyStrokeMode = "Border",
                    Thickness = 1,
                }),
                New("UIPadding", {
                    PaddingTop = UDim.new(0,Element.UIPadding),
                    PaddingLeft = UDim.new(0,Element.UIPadding),
                    PaddingRight = UDim.new(0,Element.UIPadding),
                    PaddingBottom = UDim.new(0,Element.UIPadding),
                })
            })
	    })
	
	   -- Container.Frame.TextBox:GetPropertyChangedSignal("TextBounds"):Connect(function()
    --         Container.Frame.TextBox.Size = UDim2.new(1,-40,0,Container.Frame.TextBox.TextBounds.Y)
    --     end)
	   -- Container.Frame.TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
    --         Container.Frame.TextLabel.Size = UDim2.new(0,Container.Frame.TextLabel.TextBounds.X,0,Container.Frame.TextLabel.TextBounds.Y)
    --     end)
	    
	    return Container
	end
	
	local function ToRGB(color)
        return {
            R = math.floor(color.R * 255),
            G = math.floor(color.G * 255),
            B = math.floor(color.B * 255)
        }
    end
	
	local HexInput = CreateInput("Hex", "#" .. Colorpicker.Default:ToHex())
	
	local RedInput = CreateInput("Red", ToRGB(Colorpicker.Default)["R"])
	local GreenInput = CreateInput("Green", ToRGB(Colorpicker.Default)["G"])
	local BlueInput = CreateInput("Blue", ToRGB(Colorpicker.Default)["B"])
	local AlphaInput
	if Colorpicker.Transparency then
	    AlphaInput = CreateInput("Alpha", ((1 - Colorpicker.Transparency) * 100) .. "%")
	end
	
	local ButtonsContent = New("Frame", {
        Size = UDim2.new(1,0,0,32),
        AutomaticSize = "Y",
        Position = UDim2.new(0,0,0,40+8+182+24),
        BackgroundTransparency = 1,
        Parent = ColorpickerFrame.UIElements.Main,
        LayoutOrder = 4,
    }, {
        New("UIListLayout", {
		    Padding = UDim.new(0, 8),
		    FillDirection = "Horizontal",
		    HorizontalAlignment = "Center",
	    }),
    })
	
	local Buttons = {
	    {
	        Title = "Cancel",
	        Callback = function() end
	    },
	    {
	        Title = "Apply",
	        Variant = "Primary",
	        Callback = function() OnApply(Color3.fromHSV(Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib), Colorpicker.Transparency) end
	    }
	}
	
	for _,Button in next, Buttons do
        if Button.Variant == nil or Button.Variant == "" then
            Button.Variant = "Secondary"
        end
        local ButtonFrame = New("TextButton", {
            Text = Button.Title or "Button",
            TextSize = 16,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
            ThemeTag = {
                TextColor3 = Button.Variant == "Secondary" and "Text" or "Accent",
                BackgroundColor3 = "Text",
            },
            BackgroundTransparency = Button.Variant == "Secondary" and .93 or .1 ,
            Parent = ButtonsContent,
            Size = UDim2.new(1 / #Buttons, -(((#Buttons - 1) * 10) / #Buttons), 1, 0),
            --AutomaticSize = "X",
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0, ColorpickerFrame.UICorner-5),
            }),
            New("UIPadding", {
                PaddingTop = UDim.new(0, 0),
                PaddingLeft = UDim.new(0, ColorpickerFrame.UIPadding/1.85),
                PaddingRight = UDim.new(0, ColorpickerFrame.UIPadding/1.85),
                PaddingBottom = UDim.new(0, 0),
            }),
            New("Frame", {
                Size = UDim2.new(1,(ColorpickerFrame.UIPadding/1.85)*2,1,0),
                Position = UDim2.new(0.5,0,0.5,0),
                AnchorPoint = Vector2.new(0.5,0.5),
                ThemeTag = {
                    BackgroundColor3 = Button.Variant == "Secondary" and "Text" or "Accent"
                },
                BackgroundTransparency = 1, -- .9
            }, {
                New("UICorner", {
                    CornerRadius = UDim.new(0, ColorpickerFrame.UICorner-5),
                }),
            }),
            New("UIStroke", {
                ThemeTag = {
                    Color = "Text",
                },
                Thickness = 1.2,
                Transparency = Button.Variant == "Secondary" and .9 or .1,
                ApplyStrokeMode = "Border",
            })
        })
        
        ButtonFrame.MouseEnter:Connect(function()
            Tween(ButtonFrame.Frame, 0.1, {BackgroundTransparency = .9}):Play()
        end)
        ButtonFrame.MouseLeave:Connect(function()
            Tween(ButtonFrame.Frame, 0.1, {BackgroundTransparency = 1}):Play()
        end)
        ButtonFrame.MouseButton1Click:Connect(function()
            ColorpickerFrame:Close()
            task.spawn(function()
                Button.Callback()
            end)
        end)
    end
        
  	
--	for _,Button in next, Buttons do
--         local ButtonFrame = New("TextButton", {
--             Text = Button.Title or "Button",
--             TextSize = 14,
--             FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
--             ThemeTag = {
--                 TextColor3 = "Text",
--                 BackgroundColor3 = "Text",
--             },
--             BackgroundTransparency = .9,
--             ZIndex = 999999,
--             Parent = ButtonsContent,
--             Size = UDim2.new(1 / #Buttons, -(((#Buttons - 1) * 8) / #Buttons), 0, 0),
--             AutomaticSize = "Y",
--         }, {
--             New("UICorner", {
--                 CornerRadius = UDim.new(0, ColorpickerFrame.UICorner-7),
--             }),
--             New("UIPadding", {
--                 PaddingTop = UDim.new(0, ColorpickerFrame.UIPadding/1.6),
--                 PaddingLeft = UDim.new(0, ColorpickerFrame.UIPadding/1.6),
--                 PaddingRight = UDim.new(0, ColorpickerFrame.UIPadding/1.6),
--                 PaddingBottom = UDim.new(0, ColorpickerFrame.UIPadding/1.6),
--             }),
--             New("Frame", {
--                 Size = UDim2.new(1,(ColorpickerFrame.UIPadding/1.6)*2,1,(ColorpickerFrame.UIPadding/1.6)*2),
--                 Position = UDim2.new(0.5,0,0.5,0),
--                 AnchorPoint = Vector2.new(0.5,0.5),
--                 ThemeTag = {
--                     BackgroundColor3 = "Text"
--                 },
--                 BackgroundTransparency = 1, -- .9
--             }, {
--                 New("UICorner", {
--                     CornerRadius = UDim.new(0, ColorpickerFrame.UICorner-7),
--                 }),
--             })
--         })
    
        
        
--         ButtonFrame.MouseEnter:Connect(function()
--             Tween(ButtonFrame.Frame, 0.1, {BackgroundTransparency = .9}):Play()
--         end)
--         ButtonFrame.MouseLeave:Connect(function()
--             Tween(ButtonFrame.Frame, 0.1, {BackgroundTransparency = 1}):Play()
--         end)
--         ButtonFrame.MouseButton1Click:Connect(function()
--             ColorpickerFrame:Close()
--             task.spawn(function()
--                 Button.Callback()
--             end)
--         end)
--	end
  	
  	
  	local TransparencySlider, TransparencyDrag, TransparencyColor
  	if Colorpicker.Transparency then
  		local TransparencyDragHolder = New("Frame", {
  			Size = UDim2.new(1, 0, 1, 0),
  			Position = UDim2.fromOffset(0, 0),
  			BackgroundTransparency = 1,
  		})

		TransparencyDrag = New("ImageLabel", {
			Size = UDim2.new(1,0,0,3),
			AnchorPoint = Vector2.new(0,0.5),
			Image = "rbxassetid://18747052224",
			ScaleType = "Crop",
			Parent = TransparencyDragHolder,
			ThemeTag = {
				ImageColor3 = "Text",
			},
		})

		TransparencyColor = New("Frame", {
			Size = UDim2.fromScale(1, 1),
		}, {
			New("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1),
				}),
				Rotation = 270,
			}),
			New("UICorner", {
				CornerRadius = UDim.new(0, 6),
			}),
		})

		TransparencySlider = New("Frame", {
			Size = UDim2.fromOffset(20, 182+10),
			Position = UDim2.fromOffset(160+10+20+10, 40),
			Parent = ColorpickerFrame.UIElements.Main,
			BackgroundTransparency = 1,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
			New("ImageLabel", {
				Image = "rbxassetid://14204231522",
				ImageTransparency = 0.45,
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.fromOffset(40, 40),
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
			}),
			TransparencyColor,
			TransparencyDragHolder,
		})
	end
	
    function Colorpicker:Round(Number, Factor)
	    if Factor == 0 then
		    return math.floor(Number)
	    end
	    Number = tostring(Number)
	    return Number:find("%.") and tonumber(Number:sub(1, Number:find("%.") + Factor)) or Number
    end
	
	
    function Colorpicker:Update(color, transparency)
        if color then Hue, Sat, Vib = Color3.toHSV(color) else Hue, Sat, Vib = Colorpicker.Hue,Colorpicker.Sat,Colorpicker.Vib end
            
        Colorpicker.UIElements.SatVibMap.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
        SatCursor.Position = UDim2.new(Sat, 0, 1 - Vib, 0)
        NewDisplayFrame.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)
        HueDrag.Position = UDim2.new(0, 0, Hue, 0)
        
        HexInput.Frame.TextBox.Text = "#" .. Color3.fromHSV(Hue, Sat, Vib):ToHex()
        RedInput.Frame.TextBox.Text = ToRGB(Color3.fromHSV(Hue, Sat, Vib))["R"]
		GreenInput.Frame.TextBox.Text = ToRGB(Color3.fromHSV(Hue, Sat, Vib))["G"]
		BlueInput.Frame.TextBox.Text = ToRGB(Color3.fromHSV(Hue, Sat, Vib))["B"]
        
        if transparency or Colorpicker.Transparency then
            TransparencyColor.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)
			NewDisplayFrame.BackgroundTransparency =  Colorpicker.Transparency or transparency
			TransparencyDrag.Position = UDim2.new(0, 0, 1 -  Colorpicker.Transparency or transparency, 0)
			AlphaInput.Frame.TextBox.Text = Colorpicker:Round((1 - Colorpicker.Transparency or transparency) * 100, 0) .. "%"
        end
    end

    Colorpicker:Update(Colorpicker.Default, Colorpicker.Transparency)
    
    
    
    
    local function GetRGB()
		local Value = Color3.fromHSV(Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib)
		return { R = math.floor(Value.r * 255), G = math.floor(Value.g * 255), B = math.floor(Value.b * 255) }
	end
    
    -- oh no!
    
    HexInput.Frame.TextBox.FocusLost:Connect(function(Enter)
        if Enter then
            local hex = HexInput.Frame.TextBox.Text:gsub("#", "")
            local Success, Result = pcall(Color3.fromHex, hex)
            if Success and typeof(Result) == "Color3" then
                Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib = Color3.toHSV(Result)
                Colorpicker:Update()
                Colorpicker.Default = Result
            end
        end
    end)

    RedInput.Frame.TextBox.FocusLost:Connect(function(Enter)
        if Enter then
            local CurrentColor = GetRGB()
            local Success, Result = pcall(Color3.fromRGB, tonumber(RedInput.Frame.TextBox.Text), CurrentColor["G"], CurrentColor["B"])
            if Success and typeof(Result) == "Color3" then
                if tonumber(RedInput.Frame.TextBox.Text) <= 255 then
                    Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib = Color3.toHSV(Result)
                    Colorpicker:Update()
                end
            end
        end
    end)
    
    GreenInput.Frame.TextBox.FocusLost:Connect(function(Enter)
        if Enter then
            local CurrentColor = GetRGB()
            local Success, Result = pcall(Color3.fromRGB, CurrentColor["R"], tonumber(GreenInput.Frame.TextBox.Text), CurrentColor["B"])
            if Success and typeof(Result) == "Color3" then
                if tonumber(GreenInput.Frame.TextBox.Text) <= 255 then
                    Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib = Color3.toHSV(Result)
                    Colorpicker:Update()
                end
            end
        end
    end)
    
    BlueInput.Frame.TextBox.FocusLost:Connect(function(Enter)
        if Enter then
            local CurrentColor = GetRGB()
            local Success, Result = pcall(Color3.fromRGB, CurrentColor["R"], CurrentColor["G"], tonumber(BlueInput.Frame.TextBox.Text))
            if Success and typeof(Result) == "Color3" then
                if tonumber(BlueInput.Frame.TextBox.Text) <= 255 then
                    Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib = Color3.toHSV(Result)
                    Colorpicker:Update()
                end
            end
        end
    end)
    
    if Colorpicker.Transparency then
		AlphaInput.Frame.TextBox.FocusLost:Connect(function(Enter)
			if Enter then
				pcall(function()
					local Value = tonumber(AlphaInput.Frame.TextBox.Text)
					if Value >= 0 and Value <= 100 then
						Colorpicker.Transparency = 1 - Value * 0.01
			            Colorpicker:Update(nil, Colorpicker.Transparency)
					end
				end)
			end
		end)
    end

    -- fu
    
    local SatVibMap = Colorpicker.UIElements.SatVibMap
    SatVibMap.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
				local MinX = SatVibMap.AbsolutePosition.X
				local MaxX = MinX + SatVibMap.AbsoluteSize.X
				local MouseX = math.clamp(Mouse.X, MinX, MaxX)

				local MinY = SatVibMap.AbsolutePosition.Y
				local MaxY = MinY + SatVibMap.AbsoluteSize.Y
				local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

				Colorpicker.Sat = (MouseX - MinX) / (MaxX - MinX)
				Colorpicker.Vib = 1 - ((MouseY - MinY) / (MaxY - MinY))
				Colorpicker:Update()

				RenderStepped:Wait()
			end
		end
    end)

    HueSlider.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
				local MinY = HueSlider.AbsolutePosition.Y
				local MaxY = MinY + HueSlider.AbsoluteSize.Y
				local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

				Colorpicker.Hue = ((MouseY - MinY) / (MaxY - MinY))
				Colorpicker:Update()

				RenderStepped:Wait()
			end
		end
    end)
    
    if Colorpicker.Transparency then
		TransparencySlider.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					local MinY = TransparencySlider.AbsolutePosition.Y
					local MaxY = MinY + TransparencySlider.AbsoluteSize.Y
					local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

					Colorpicker.Transparency = 1 - ((MouseY - MinY) / (MaxY - MinY))
					Colorpicker:Update()

					RenderStepped:Wait()
				end
			end
		end)
    end
	
    return Colorpicker
end

function Element:New(Config) 
    local Colorpicker = {
        __type = "Colorpicker",
        Title = Config.Title or "Colorpicker",
        Desc = Config.Desc or nil,
        Locked = Config.Locked or false,
        Default = Config.Default or Color3.new(1,1,1),
        Callback = Config.Callback or function() end,
        Window = Config.Window,
        Transparency = Config.Transparency,
        UIElements = {}
    }
    
    local CanCallback = true
    
    
    Colorpicker.ColorpickerFrame = __DARKLUA_BUNDLE_MODULES.load('f')({
        Title = Colorpicker.Title,
        Desc = Colorpicker.Desc,
        Parent = Config.Parent,
        TextOffset = 40,
        Hover = false,
    })
    
    Colorpicker.UIElements.Colorpicker = New("TextButton",{
        BackgroundTransparency = 0,
        Text = "",
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
        TextSize = 15,
        TextTransparency = .4,
        Active = false,
        TextXAlignment = "Left",
        BackgroundColor3 = Colorpicker.Default,
        Parent = Colorpicker.ColorpickerFrame.UIElements.Main,
        Size = UDim2.new(0,30,0,30),
        AnchorPoint = Vector2.new(1,0.5),
        TextTruncate = "AtEnd",
        Position = UDim2.new(1,0,0.5,0),
        ThemeTag = {
            TextColor3 = "Text"
        },
        ZIndex = 2
    }, {
        New("UICorner", {
            CornerRadius = UDim.new(0,Element.UICorner)
        }),
        New("UIStroke", {
            ThemeTag = {
                Color = "Text",
            },
            Transparency = .93,
            ApplyStrokeMode = "Border",
            Thickness = 1,
        }),
    })
    
    
    function Colorpicker:Lock()
        CanCallback = false
        return Colorpicker.ColorpickerFrame:Lock()
    end
    function Colorpicker:Unlock()
        CanCallback = true
        return Colorpicker.ColorpickerFrame:Unlock()
    end
    
    if Colorpicker.Locked then
        Colorpicker:Lock()
    end

    
    function Colorpicker:Update(Color,Transparency)
        Colorpicker.UIElements.Colorpicker.BackgroundTransparency = Transparency or 0
        Colorpicker.UIElements.Colorpicker.BackgroundColor3 = Color
        Colorpicker.Default = Color
        if Transparency then
            Colorpicker.Transparency = Transparency
        end
    end
    
    local clrpckr = Element:Colorpicker(Colorpicker, function(color, transparency)
        if CanCallback then
            Colorpicker:Update(color, transparency)
            Colorpicker.Default = color
            Colorpicker.Transparency = transparency
            Colorpicker.Callback(color, transparency)
        end
    end)
    
    Colorpicker:Update(Colorpicker.Default, Colorpicker.Transparency)

    
    Colorpicker.UIElements.Colorpicker.MouseButton1Click:Connect(function()
        if CanCallback then
            clrpckr.ColorpickerFrame:Open()
        end
    end)
    
    return Colorpicker.__type, Colorpicker
end

return Element end function __DARKLUA_BUNDLE_MODULES.p()
local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New
local Tween = Creator.Tween

local Element = {}

function Element:New(Config)
    local Section = {
        __type = "Section",
        Title = Config.Title or "Section",
        TextXAlignment = Config.TextXAlignment or "Left",
        TextSize = Config.TextSize or 17,
        UIElements = {},
    }
    
    Section.UIElements.Main = New("TextLabel", {
        BackgroundTransparency = 1,
        TextXAlignment = Section.TextXAlignment,
        AutomaticSize = "Y",
        TextSize = Section.TextSize,
        ThemeTag = {
            TextColor3 = "Text",
        },
        FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
        Parent = Config.Parent,
        Size = UDim2.new(1,0,0,0),
        Text = Section.Title,
    }, {
        New("UIPadding", {
            PaddingTop = UDim.new(0,4),
            PaddingBottom = UDim.new(0,2),
        })
    })

    -- Section.UIElements.Main:GetPropertyChangedSignal("TextBounds"):Connect(function()
    --     Section.UIElements.Main.Size = UDim2.new(1,0,0,Section.UIElements.Main.TextBounds.Y)
    -- end)

    function Section:SetTitle(Title)
        Section.UIElements.Main.Text = Title
    end
    
    return Section.__type, Section
end

return Element end function __DARKLUA_BUNDLE_MODULES.q()
local UserInputService = game:GetService("UserInputService")
local Mouse = game.Players.LocalPlayer:GetMouse()

local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New
local Tween = Creator.Tween

local TabModule = {
    Window = nil,
    WindUI = nil,
    Tabs = {}, 
    Containers = {},
    SelectedTab = nil,
    TabCount = 0,
    ToolTipParent = nil,
    TabHighlight = nil,
    
    OnChangeFunc = function(v) end
}

function TabModule.Init(Window, WindUI, ToolTipParent, TabHighlight)
    TabModule.Window = Window
    TabModule.WindUI = WindUI
    TabModule.ToolTipParent = ToolTipParent
    TabModule.TabHighlight = TabHighlight
    return TabModule
end

function TabModule.New(Config)
    local Tab = {
        Title = Config.Title or "Tab",
        Desc = Config.Desc,
        Icon = Config.Icon,
        Selected = false,
        Index = nil,
        Parent = Config.Parent,
        UIElements = {},
        Elements = {},
        ContainerFrame = nil,
    }
    
    local Window = TabModule.Window
    local WindUI = TabModule.WindUI
    
    TabModule.TabCount = TabModule.TabCount + 1
  	local TabIndex = TabModule.TabCount
  	Tab.Index = TabIndex
  	
  	Tab.UIElements.Main = New("TextButton", {
  	    BackgroundTransparency = 1,
  	    Size = UDim2.new(1,0,0,0),
  	    AutomaticSize = "Y",
  	    Parent = Config.Parent
  	}, {
  	    New("UIListLayout", {
  	        SortOrder = "LayoutOrder",
  	        Padding = UDim.new(0,10),
  	        FillDirection = "Horizontal",
  	        VerticalAlignment = "Center",
  	    }),
  	    New("TextLabel", {
  	        Text = Tab.Title,
  	        ThemeTag = {
  	            TextColor3 = "Text"
  	        },
  	        TextTransparency = 0.4,
  	        TextSize = 15,
  	        Size = UDim2.new(1,0,0,0),
  	        FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
  	        TextWrapped = true,
  	        RichText = true,
  	        --AutomaticSize = "Y",
  	        LayoutOrder = 2,
  	        TextXAlignment = "Left",
  	        BackgroundTransparency = 1,
  	    }),
  	    New("UIPadding", {
  	        PaddingTop = UDim.new(0,6),
  	        PaddingBottom = UDim.new(0,6),
  	    })
  	})
  	
  	local TextOffset = 0

--	Tab.UIElements.Main.TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
--	    Tab.UIElements.Main.TextLabel.Size = UDim2.new(1,0,0,Tab.UIElements.Main.TextLabel.TextBounds.Y)
--	    Tab.UIElements.Main.Size = UDim2.new(1,TextOffset,0,Tab.UIElements.Main.TextLabel.TextBounds.Y+6+6)
--	end)
  	
  	if Tab.Icon and Creator.Icon(Tab.Icon) then
        local Icon = New("ImageLabel", {
            ImageTransparency = 0.4,
            Image = Creator.Icon(Tab.Icon)[1],
            ImageRectOffset = Creator.Icon(Tab.Icon)[2].ImageRectPosition,
            ImageRectSize = Creator.Icon(Tab.Icon)[2].ImageRectSize,
            Size = UDim2.new(0,18,0,18),
            LayoutOrder = 1,
            ThemeTag = {
                ImageColor3 = "Text"
            },
            BackgroundTransparency = 1,
            Parent = Tab.UIElements.Main,
        })
        Tab.UIElements.Main.TextLabel.Size = UDim2.new(1,-30,0,0)
        TextOffset = -30
    elseif Tab.Icon and string.find(Tab.Icon, "rbxassetid://") then
        local Icon = New("ImageLabel", {
            ImageTransparency = 0.4,
            Image = Tab.Icon,
            Size = UDim2.new(0,18,0,18),
            LayoutOrder = 1,
            ThemeTag = {
                ImageColor3 = "Text"
            },
            BackgroundTransparency = 1,
            Parent = Tab.UIElements.Main,
        })
        Tab.UIElements.Main.TextLabel.Size = UDim2.new(1,-30,0,0)
        TextOffset = -30
	end
	
	Tab.UIElements.ContainerFrame = New("ScrollingFrame", {
        Size = UDim2.new(1,-Window.UIPadding,1,0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        ElasticBehavior = "Never",
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = "Y",
        --Visible = false,
        ScrollingDirection = "Y",
    }, {
        New("UIPadding", {
            PaddingTop = UDim.new(0,Window.UIPadding),
            PaddingLeft = UDim.new(0,Window.UIPadding),
            PaddingRight = UDim.new(0,0),
            PaddingBottom = UDim.new(0,Window.UIPadding),
        }),
        New("UIListLayout", {
            SortOrder = "LayoutOrder",
            Padding = UDim.new(0,6)
        })
    })

    -- Tab.UIElements.ContainerFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    --     Tab.UIElements.ContainerFrame.CanvasSize = UDim2.new(0,0,0,Tab.UIElements.ContainerFrame.UIListLayout.AbsoluteContentSize.Y+Window.UIPadding*2)
    -- end)

    local Slider = New("Frame", {
        Size = UDim2.new(0,2,1,-Window.UIPadding*2),
        BackgroundTransparency = 1,
        Position = UDim2.new(1,-Window.UIPadding/3,0,Window.UIPadding),
        AnchorPoint = Vector2.new(1,0),
    })
    
    local Hitbox = New("Frame", {
        Size = UDim2.new(1,12,1,12),
        Position = UDim2.new(0.5,0,0.5,0),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundTransparency = 1,
        Active = true,
    })

    local Thumb = New("ImageLabel", {
        Size = UDim2.new(1,0,0,0),
        --Image = "rbxassetid://18747052224",
        --ScaleType = "Crop",
        BackgroundTransparency = .85,
        --ImageTransparency = .65,
        ThemeTag = {
            BackgroundColor3 = "Text"
        },
        Parent = Slider
    }, {
        New("UICorner", {
            CornerRadius = UDim.new(1,0)
        }),
        Hitbox
    })

    Tab.UIElements.ContainerFrameCanvas = New("Frame", {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = Window.UIElements.MainBar
    }, {
        Tab.UIElements.ContainerFrame,
        Slider 
    })

    TabModule.Containers[TabIndex] = Tab.UIElements.ContainerFrameCanvas
	TabModule.Tabs[TabIndex] = Tab
	
	Tab.ContainerFrame = ContainerFrameCanvas
	
	Tab.UIElements.Main.MouseButton1Click:Connect(function()
	    TabModule:SelectTab(TabIndex)
	end)
    
    local function updateSliderSize()
        local container = Tab.UIElements.ContainerFrame
        local visibleRatio = math.clamp(container.AbsoluteWindowSize.Y / container.AbsoluteCanvasSize.Y, 0, 1)
    
        Thumb.Size = UDim2.new(1, 0, visibleRatio, 0)
        Thumb.Visible = visibleRatio < 1
    end
        
    local function updateScrollingFramePosition()
        local thumbPosition = Thumb.Position.Y.Scale
        local canvasSize = math.max(Tab.UIElements.ContainerFrame.AbsoluteCanvasSize.Y - Tab.UIElements.ContainerFrame.AbsoluteWindowSize.Y, 1)
    
        Tab.UIElements.ContainerFrame.CanvasPosition = Vector2.new(
            0,
            thumbPosition * canvasSize
        )
    end
    
    local offset = 0

    local function onInputChanged(input)
        local sliderSize = Slider.AbsoluteSize.Y
        local sliderPosition = Slider.AbsolutePosition.Y
    
        local newThumbPosition = (input.Position.Y - sliderPosition - offset) / sliderSize
        newThumbPosition = math.clamp(newThumbPosition, 0, 1) 
    
        Thumb.Position = UDim2.new(0, 0, newThumbPosition, 0)
        updateScrollingFramePosition()
    end
    
    Hitbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local offset = input.Position.Y - Thumb.AbsolutePosition.Y
            local connection
    
            connection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    local sliderSize = Slider.AbsoluteSize.Y
                    local sliderPosition = Slider.AbsolutePosition.Y
    
                    local newThumbPosition = (input.Position.Y - sliderPosition - offset) / sliderSize
                    newThumbPosition = math.clamp(newThumbPosition, 0, 1)
    
                    Thumb.Position = UDim2.new(0, 0, newThumbPosition, 0)
                    updateScrollingFramePosition()
                end
            end)
    
            local releaseConnection
            releaseConnection = UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                    connection:Disconnect()
                    releaseConnection:Disconnect()
                end
            end)
        end
    end)
    
    
    Tab.UIElements.ContainerFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        local canvasPosition = Tab.UIElements.ContainerFrame.CanvasPosition.Y
        local canvasSize = Tab.UIElements.ContainerFrame.AbsoluteCanvasSize.Y - Tab.UIElements.ContainerFrame.AbsoluteWindowSize.Y
        local newThumbPosition = canvasPosition / canvasSize
    
        Thumb.Position = UDim2.new(0, 0, newThumbPosition, 0)
    end)
    
    Thumb:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        Slider.Size = UDim2.new(0, Slider.Size.X.Offset, 1, -Thumb.AbsoluteSize.Y - Window.UIPadding*2)
    end)
    Tab.UIElements.ContainerFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateSliderSize)
    Tab.UIElements.ContainerFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateSliderSize)
    
    updateSliderSize()
	
	
	-- ToolTip
	
    local ToolTip
    local hoverTimer
    local MouseConn
    local IsHovering = false
    
    local function removeToolTip()
        IsHovering = false
        if hoverTimer then
            task.cancel(hoverTimer)
            hoverTimer = nil
        end
        if MouseConn then
            MouseConn:Disconnect()
            MouseConn = nil
        end
        if ToolTip then
            ToolTip:Close()
            ToolTip = nil
        end
    end
    
    Tab.UIElements.Main.InputBegan:Connect(function()
        IsHovering = true
        hoverTimer = task.spawn(function()
            task.wait(0.35)
            if IsHovering and not ToolTip then
                ToolTip = Creator.ToolTip({
                    Title = Tab.Desc,
                    Parent = TabModule.ToolTipParent
                })
    
                local function updatePosition()
                    if ToolTip then
                        ToolTip.Container.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y - 20)
                    end
                end
    
                updatePosition()
                MouseConn = Mouse.Move:Connect(updatePosition)
                ToolTip:Open()
            end
        end)
    end)
    
    Tab.UIElements.Main.InputEnded:Connect(removeToolTip)

	-- WTF
	
    function Tab:Paragraph(ElementConfig)
        ElementConfig.Parent = Tab.UIElements.ContainerFrame
        ElementConfig.Window = Window
        ElementConfig.Hover = false
        ElementConfig.TextOffset = 0
        ElementConfig.IsButtons = ElementConfig.Buttons and #ElementConfig.Buttons > 0 and true or false
        
        local ParagraphModule = {
            __type = "Paragraph",
            Title = ElementConfig.Title or "Input",
            Desc = ElementConfig.Desc or nil,
            Locked = ElementConfig.Locked or false,
        }
        local Paragraph = __DARKLUA_BUNDLE_MODULES.load('f')(ElementConfig)
        
        ParagraphModule.ParagraphFrame = Paragraph
        if ElementConfig.Buttons and #ElementConfig.Buttons > 0 then
            local ButtonsContainer = New("Frame", {
                Size = UDim2.new(1,0,0,0),
                BackgroundTransparency = 1,
                Position = UDim2.new(0,0,0,ElementConfig.Image and Paragraph.ImageSize > Paragraph.UIElements.Main.Title.AbsoluteSize.Y and Paragraph.ImageSize+Paragraph.UIPadding or Paragraph.UIElements.Main.Title.AbsoluteSize.Y+Paragraph.UIPadding),
                AutomaticSize = "Y",
                Parent = Paragraph.UIElements.Main
            }, {
                New("UIListLayout", {
                    Padding = UDim.new(0,10),
                    FillDirection = "Horizontal",
                })
            })
            
            for _,ButtonData in next, ElementConfig.Buttons do
                local Button = New("TextButton", {
                    Text = ButtonData.Title,
                    TextSize = 16,
                    AutomaticSize = "Y",
                    ThemeTag = {
                        TextColor3 = "Accent",
                        BackgroundColor3 = "Text"
                    },
                    FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                    BackgroundTransparency = 0.1,
                    Size = UDim2.new(1 / #ElementConfig.Buttons, -(((#ElementConfig.Buttons - 1) * 10) / #ElementConfig.Buttons), 0, 32),
                    Parent = ButtonsContainer,
                }, {
                    New("UICorner", {
                        CornerRadius = UDim.new(0,8)
                    })
                })
                Button.MouseEnter:Connect(function()
                    Tween(Button, 0.1, {BackgroundTransparency = .3}):Play()
                end)
                Button.MouseLeave:Connect(function()
                    Tween(Button, 0.1, {BackgroundTransparency = .1}):Play()
                end)
                Button.MouseButton1Click:Connect(function()
                    ButtonData.Callback()
                end)
            end
        end
        
        function ParagraphModule:SetTitle(Title)
            ParagraphModule.ParagraphFrame:SetTitle(Title)
        end
        function ParagraphModule:SetDesc(Title)
            ParagraphModule.ParagraphFrame:SetDesc(Title)
        end
        
        table.insert(Tab.Elements, ParagraphModule)
        return ParagraphModule
    end
    function Tab:Button(ElementConfig)
        ElementConfig.Parent = Tab.UIElements.ContainerFrame
        local Button, Content = __DARKLUA_BUNDLE_MODULES.load('g'):New(ElementConfig)
        table.insert(Tab.Elements, Content)
        
        function Content:SetTitle(Title)
            Content.ButtonFrame:SetTitle(Title)
        end
        function Content:SetDesc(Title)
            Content.ButtonFrame:SetDesc(Title)
        end
        
        return Content
    end
    function Tab:Toggle(ElementConfig)
        ElementConfig.Parent = Tab.UIElements.ContainerFrame
        local Toggle, Content = __DARKLUA_BUNDLE_MODULES.load('h'):New(ElementConfig)
        table.insert(Tab.Elements, Content)
        
        function Content:SetTitle(Title)
            Content.ToggleFrame:SetTitle(Title)
        end
        function Content:SetDesc(Title)
            Content.ToggleFrame:SetDesc(Title)
        end
        
        return Content
    end
    function Tab:Slider(ElementConfig)
        ElementConfig.Parent = Tab.UIElements.ContainerFrame
        local Slider, Content = __DARKLUA_BUNDLE_MODULES.load('i'):New(ElementConfig)
        table.insert(Tab.Elements, Content)
        
        function Content:SetTitle(Title)
            Content.SliderFrame:SetTitle(Title)
        end
        function Content:SetDesc(Title)
            Content.SliderFrame:SetDesc(Title)
        end
        
        return Content
    end
    function Tab:Keybind(ElementConfig)
        ElementConfig.Parent = Tab.UIElements.ContainerFrame
        local Keybind, Content = __DARKLUA_BUNDLE_MODULES.load('j'):New(ElementConfig)
        table.insert(Tab.Elements, Content)
        
        function Content:SetTitle(Title)
            Content.KeybindFrame:SetTitle(Title)
        end
        function Content:SetDesc(Title)
            Content.KeybindFrame:SetDesc(Title)
        end
        
        return Content
    end
    function Tab:Input(ElementConfig)
        ElementConfig.Parent = Tab.UIElements.ContainerFrame
        local Input, Content = __DARKLUA_BUNDLE_MODULES.load('k'):New(ElementConfig)
        table.insert(Tab.Elements, Content)
        
        function Content:SetTitle(Title)
            Content.InputFrame:SetTitle(Title)
        end
        function Content:SetDesc(Title)
            Content.InputFrame:SetDesc(Title)
        end
        
        return Content
    end
    function Tab:Dropdown(ElementConfig)
        ElementConfig.Parent = Tab.UIElements.ContainerFrame
        ElementConfig.Window = Window
        local Dropdown, Content = __DARKLUA_BUNDLE_MODULES.load('l'):New(ElementConfig)
        table.insert(Tab.Elements, Content)
        
        function Content:SetTitle(Title)
            Content.DropdownFrame:SetTitle(Title)
        end
        function Content:SetDesc(Title)
            Content.DropdownFrame:SetDesc(Title)
        end
        
        return Content
    end
    function Tab:Code(ElementConfig)
        ElementConfig.Parent = Tab.UIElements.ContainerFrame
        ElementConfig.Window = Window
        ElementConfig.WindUI = WindUI
        local Code, Content = __DARKLUA_BUNDLE_MODULES.load('n'):New(ElementConfig)
        table.insert(Tab.Elements, Content)
        
        function Content:SetTitle(Title)
            Content.CodeFrame:SetTitle(Title)
        end
        function Content:SetDesc(Title)
            Content.CodeFrame:SetDesc(Title)
        end
        
        return Content
    end
    function Tab:Colorpicker(ElementConfig)
        ElementConfig.Parent = Tab.UIElements.ContainerFrame
        ElementConfig.Window = Window
        local Colorpicker, Content = __DARKLUA_BUNDLE_MODULES.load('o'):New(ElementConfig)
        table.insert(Tab.Elements, Content)
        
        function Content:SetTitle(Title)
            Content.ColorpickerFrame:SetTitle(Title)
        end
        function Content:SetDesc(Title)
            Content.ColorpickerFrame:SetDesc(Title)
        end
        
        return Content
    end
    function Tab:Section(ElementConfig)
        ElementConfig.Parent = Tab.UIElements.ContainerFrame
        local Section, Content = __DARKLUA_BUNDLE_MODULES.load('p'):New(ElementConfig)
        table.insert(Tab.Elements, Content)
        return Content
    end

	
	task.spawn(function()
        local Empty = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,-Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
            Parent = Tab.UIElements.ContainerFrame
        }, {
            New("UIListLayout", {
                Padding = UDim.new(0,8),
                SortOrder = "LayoutOrder",
                VerticalAlignment = "Center",
                HorizontalAlignment = "Center",
                FillDirection = "Vertical",
            }), 
            New("ImageLabel", {
                Size = UDim2.new(0,48,0,48),
                Image = Creator.Icon("frown")[1],
                ImageRectOffset = Creator.Icon("frown")[2].ImageRectPosition,
                ImageRectSize = Creator.Icon("frown")[2].ImageRectSize,
                ThemeTag = {
                    ImageColor3 = "Text"
                },
                BackgroundTransparency = 1,
                ImageTransparency = .4,
            }),
            New("TextLabel", {
                AutomaticSize = "XY",
                Text = "This tab is empty",
                ThemeTag = {
                    TextColor3 = "Text"
                },
                TextSize = 18,
                TextTransparency = .4,
                BackgroundTransparency = 1,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
            })
        })
        
        -- Empty.TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
        --     Empty.TextLabel.Size = UDim2.new(0,Empty.TextLabel.TextBounds.X,0,Empty.TextLabel.TextBounds.Y)
        -- end)
        
        Tab.UIElements.ContainerFrame.ChildAdded:Connect(function()
            Empty.Visible = false
        end)
	end)
	
	return Tab
end

function TabModule:OnChange(func)
    TabModule.OnChangeFunc = func
end

function TabModule:SelectTab(TabIndex)
    TabModule.SelectedTab = TabIndex
    
    for _, TabObject in next, TabModule.Tabs do
        Tween(TabObject.UIElements.Main.TextLabel, 0.15, {TextTransparency = 0.4}):Play()
        if TabObject.Icon and Creator.Icon(TabObject.Icon) then
            Tween(TabObject.UIElements.Main.ImageLabel, 0.15, {ImageTransparency = 0.4}):Play()
        end
		TabObject.Selected = false
	end
    Tween(TabModule.Tabs[TabIndex].UIElements.Main.TextLabel, 0.15, {TextTransparency = 0}):Play()
    if TabModule.Tabs[TabIndex].Icon and Creator.Icon(TabModule.Tabs[TabIndex].Icon) then
        Tween(TabModule.Tabs[TabIndex].UIElements.Main.ImageLabel, 0.15, {ImageTransparency = 0}):Play()
    end
	TabModule.Tabs[TabIndex].Selected = true
	
	Tween(TabModule.TabHighlight, .25, {Position = UDim2.new(
	    0,
	    0,
	    0,
	    TabModule.Tabs[TabIndex].UIElements.Main.AbsolutePosition.Y - TabModule.Tabs[TabIndex].Parent.AbsolutePosition.Y
	), 
	Size = UDim2.new(1,-13,0,TabModule.Tabs[TabIndex].UIElements.Main.AbsoluteSize.Y)
	}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
	
	task.spawn(function()
	    for _, ContainerObject in next, TabModule.Containers do
	        ContainerObject.AnchorPoint = Vector2.new(0,0.05)
	        ContainerObject.Visible = false
	    end
	    TabModule.Containers[TabIndex].Visible = true
	    Tween(TabModule.Containers[TabIndex], 0.15, {AnchorPoint = Vector2.new(0,0)}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()
	end)
	
	TabModule.OnChangeFunc(TabIndex)
end

return TabModule end function __DARKLUA_BUNDLE_MODULES.r()
local UserInputService = game:GetService("UserInputService")

local SearchBar = {
    Margin = 6,
    Padding = 9,
}


local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New
local Tween = Creator.Tween


function SearchBar.new(Elements, Parent, TabName, OnClose, ClipFrame)
    local SearchBarModule = {
        IconSize = 18
    }
    
    local UIScale = New("UIScale", {
        Scale = .9 -- 1
    })

    local UIStroke = New("UIStroke", {
        Thickness = 1.3,
        ThemeTag = {
            Color = "Text",
        },
        Transparency = 1, -- .95
    })
    
    local SearchFrame = New("CanvasGroup", {
        Size = UDim2.new(0.3,0,0,52 -(SearchBar.Margin*2)),
        Position = UDim2.new(1,-SearchBar.Margin,0,(((52 -(SearchBar.Margin*2))/2) + SearchBar.Margin)+52),
        AnchorPoint = Vector2.new(1,0.5),
        AutomaticSize = "X",
        BackgroundTransparency = 0.95,
        ThemeTag = {
            BackgroundColor3 = "Text",
        },
        Parent = Parent,
        ZIndex = 99999,
        Active = true,
        GroupTransparency = 1, -- 0
        Visible = false -- true
    }, {
        New("UICorner", {
            CornerRadius = UDim.new(0,12),
        }),
        New("ImageLabel", {
            Size = UDim2.new(0,SearchBarModule.IconSize,0,SearchBarModule.IconSize),
            Position = UDim2.new(0,SearchBar.Padding,0.5,0),
            AnchorPoint = Vector2.new(0,0.5),
            BackgroundTransparency = 1,
            Image = Creator.Icon("search")[1],
            ImageRectOffset = Creator.Icon("search")[2].ImageRectPosition,
            ImageRectSize = Creator.Icon("search")[2].ImageRectSize,
            ThemeTag = {
                ImageColor3 = "PlaceholderText"
            },
        }),
        New("TextBox", {
            Size = UDim2.new(1,-((SearchBar.Padding*2)+SearchBarModule.IconSize+SearchBar.Padding),1,0),
            Position = UDim2.new(1,-SearchBar.Padding,0,0),
            AnchorPoint = Vector2.new(1,0),
            BackgroundTransparency = 1,
            TextXAlignment = "Left",
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
            TextSize = 17,
            BackgroundTransparency = 1,
            MultiLine = false,
            PlaceholderText = "Search in " .. TabName,
            ThemeTag = {
                TextColor3 = "Text",
                PlaceholderColor3 = "PlaceholderText",
            }
        }),
        --UIStroke,
        UIScale,
        New("UISizeConstraint", {
            MaxSize = Vector2.new(Parent.AbsoluteSize.X, math.huge)
        })
    })
    
    function SearchBarModule:Open()
        SearchFrame.Visible = true
        Tween(SearchFrame, 0.35, {
            GroupTransparency = 0,
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(UIScale, 0.35, {
            Scale = 1,
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(UIStroke, 0.35, {
            Transparency = 0.95,
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
    end
    function SearchBarModule:Close()
        Tween(SearchFrame, 0.35, {
            GroupTransparency = 1,
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(UIScale, 0.35, {
            Scale = .9,
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(UIStroke, 0.35, {
            Transparency = 1,
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        task.wait(.35)
        SearchFrame.Visible = false
        SearchFrame:Destroy()
    end
    
    function SearchBarModule:Search(Text)
        for _, Element in next, Elements do
            local TitleMatch = string.find(string.lower(Element.Title or ""), string.lower(Text))
            local DescMatch = Element.Desc and string.find(string.lower(Element.Desc or ""), string.lower(Text))
    
            local ElementFrame = Element[Element.__type .. "Frame"]
            if ElementFrame then
                ElementFrame.UIElements.MainContainer.Visible = TitleMatch or DescMatch or false
            else
                Element.UIElements.Main.Visible = TitleMatch or DescMatch or false
            end
        end
    end
    
    SearchFrame.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        SearchBarModule:Search(SearchFrame.TextBox.Text)
    end)
    
    local inputConnection

    inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
    
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local mousePos = UserInputService:GetMouseLocation()
    
            local inSearchFrame = mousePos.X >= SearchFrame.AbsolutePosition.X 
                and mousePos.X <= (SearchFrame.AbsolutePosition.X + SearchFrame.AbsoluteSize.X)
                and mousePos.Y >= SearchFrame.AbsolutePosition.Y 
                and mousePos.Y <= (SearchFrame.AbsolutePosition.Y + SearchFrame.AbsoluteSize.Y)
            
            local inClipFrame = ClipFrame 
                and mousePos.X >= ClipFrame.AbsolutePosition.X 
                and mousePos.X <= (ClipFrame.AbsolutePosition.X + ClipFrame.AbsoluteSize.X)
                and mousePos.Y >= ClipFrame.AbsolutePosition.Y 
                and mousePos.Y <= (ClipFrame.AbsolutePosition.Y + ClipFrame.AbsoluteSize.Y)
            
            if not inSearchFrame and not inClipFrame then
                for _, Element in pairs(Elements) do
                    local ElementFrame = Element[Element.__type .. "Frame"]
                    if ElementFrame then
                        ElementFrame.UIElements.MainContainer.Visible = true
                    else
                        Element.UIElements.Main.Visible = true
                    end
                end
    
                OnClose()
                SearchBarModule:Close()
    
                if inputConnection then
                    inputConnection:Disconnect()
                    inputConnection = nil
                end
            end
        end
    end)
    SearchBarModule:Open()
    
    
    return SearchBarModule
    -- Debug
    
    --print(game:GetService("HttpService"):JSONEncode(Elements, true))
end

return SearchBar end function __DARKLUA_BUNDLE_MODULES.s()

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Creator = __DARKLUA_BUNDLE_MODULES.load('b')
local New = Creator.New
local Tween = Creator.Tween

local Notified = false

return function(Config)
    local Window = {
        Title = Config.Title or "UI Library",
        Author = Config.Author,
        Icon = Config.Icon,
        Folder = Config.Folder,
        Background = Config.Background,
        Size = Config.Size and UDim2.new(
                    0, math.clamp(Config.Size.X.Offset, 480, 700),
                    0, math.clamp(Config.Size.Y.Offset, 350, 520)) or UDim2.new(0,580,0,460),
        ToggleKey = Config.ToggleKey or Enum.KeyCode.G,
        Transparent = Config.Transparent or false,
        Position = UDim2.new(
			0.5, 0,
			0.5, 0
		),
		UICorner = 16,
		UIPadding = 14,
		SideBarWidth = Config.SideBarWidth or 200,
		UIElements = {},
		CanDropdown = true,
		Closed = false,
		HasOutline = Config.HasOutline or false,
		SuperParent = Config.Parent,
		Destroyed = false,
		IsFullscreen = false,
		IsOpenButtonEnabled = true,
		
		CurrentTab = nil,
    } -- wtf 
    
    if Window.Folder then
        makefolder("WindUI/" .. Window.Folder)
    end
    
    local UICorner = New("UICorner", {
        CornerRadius = UDim.new(0,Window.UICorner)
    })
    local UIStroke
    -- local UIStroke = New("UIStroke", {
    --     Thickness = 0.6,
    --     ThemeTag = {
    --         Color = "Outline",
    --     },
    --     Transparency = 1, -- 0.8
    -- })

    local ResizeHandle = New("Frame", {
        Size = UDim2.new(0,32,0,32),
        Position = UDim2.new(1,0,1,0),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundTransparency = 1,
        ZIndex = 99,
        Active = true
    }, {
        -- New("Frame", {
        --     Size = UDim2.new(1,0,1,0),
        --     Position = UDim2.new(0,3,0,3),
        --     AnchorPoint = Vector2.new(0.5,0.5),
        --     BackgroundTransparency = 1,
        -- }, {
        --     New("UIStroke", {
        --         Thickness = 1.2,
        --         ThemeTag = {
        --             Color = "Text",
        --         },
        --         Transparency = .6,
        --     }),
        --     New("UICorner", {
        --         CornerRadius = UDim.new(0,Window.UICorner+6)
        --     })
        -- })
    })
    local FullScreenIcon = New("Frame", {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1, -- .85
        BackgroundColor3 = Color3.new(0,0,0),
        ZIndex = 98,
        Active = false,
    }, {
        New("ImageLabel", {
            Size = UDim2.new(0,70,0,70),
            Image = Creator.Icon("expand")[1],
            ImageRectOffset = Creator.Icon("expand")[2].ImageRectPosition,
            ImageRectSize = Creator.Icon("expand")[2].ImageRectSize,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5,0,0.5,0),
            AnchorPoint = Vector2.new(0.5,0.5),
            ImageTransparency = 1,
        }),
        New("UICorner", {
            CornerRadius = UDim.new(0,Window.UICorner)
        })
    })

    
    local Slider = New("Frame", {
        Size = UDim2.new(0,2,1,-Window.UIPadding*2),
        BackgroundTransparency = 1,
        Position = UDim2.new(1,-Window.UIPadding/3,0,Window.UIPadding),
        AnchorPoint = Vector2.new(1,0),
    })
    
    local Hitbox = New("Frame", {
        Size = UDim2.new(1,12,1,12),
        Position = UDim2.new(0.5,0,0.5,0),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundTransparency = 1,
        Active = true,
    })

    local Thumb = New("ImageLabel", {
        Size = UDim2.new(1,0,0,0),
        --Image = "rbxassetid://18747052224",
        --ScaleType = "Crop",
        BackgroundTransparency = .85,
        --ImageTransparency = .65,
        ThemeTag = {
            BackgroundColor3 = "Text"
        },
        Parent = Slider
    }, {
        New("UICorner", {
            CornerRadius = UDim.new(1,0)
        }),
        Hitbox
    })

    local TabHighlight = New("Frame", {
        Size = UDim2.new(1,0,0,0),
        BackgroundTransparency = .95,
        ThemeTag = {
            BackgroundColor3 = "Text",
        }
    }, {
        New("UICorner", {
            CornerRadius = UDim.new(0,9)
        })
    })

    Window.UIElements.SideBar = New("ScrollingFrame", {
        Size = UDim2.new(1,-Window.UIPadding+2,1,0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        ElasticBehavior = "Never",
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = "Y",
        ScrollingDirection = "Y",
    }, {
        New("Frame", {
            BackgroundTransparency = 1,
            AutomaticSize = "Y",
            Size = UDim2.new(1,0,0,0)
        }, {
            New("UIPadding", {
                PaddingTop = UDim.new(0,4),
                PaddingLeft = UDim.new(0,4+3),
                --PaddingRight = UDim.new(0,Window.UIPadding+4),
                PaddingBottom = UDim.new(0,Window.UIPadding),
            }),
            New("UIListLayout", {
                SortOrder = "LayoutOrder",
                Padding = UDim.new(0,8)
            })
        }),
        New("UIPadding", {
            --PaddingTop = UDim.new(0,4),
            PaddingLeft = UDim.new(0,Window.UIPadding-3),
            PaddingRight = UDim.new(0,Window.UIPadding-3),
            --PaddingBottom = UDim.new(0,Window.UIPadding),
        }),
        TabHighlight
    })
    
    Window.UIElements.SideBarContainer = New("CanvasGroup", {
        Size = UDim2.new(0,Window.SideBarWidth-Window.UIPadding+4,1,-52),
        Position = UDim2.new(0,0,0,52),
        BackgroundTransparency = 1,
        GroupTransparency = 0,
    }, {
        Window.UIElements.SideBar,
        Slider,
    })

    
    local function updateSliderSize()
        local container = Window.UIElements.SideBar
        local visibleRatio = math.clamp(container.AbsoluteWindowSize.Y / container.AbsoluteCanvasSize.Y, 0, 1)
    
        Thumb.Size = UDim2.new(1, 0, visibleRatio, 0)
        Thumb.Visible = visibleRatio < 1
    end
        
    local function updateScrollingFramePosition()
        local thumbPosition = Thumb.Position.Y.Scale
        local canvasSize = math.max(Window.UIElements.SideBar.AbsoluteCanvasSize.Y - Window.UIElements.SideBar.AbsoluteWindowSize.Y, 1)
    
        Window.UIElements.SideBar.CanvasPosition = Vector2.new(
            0,
            thumbPosition * canvasSize
        )
    end
    
    local offset = 0

    local function onInputChanged(input)
        local sliderSize = Slider.AbsoluteSize.Y
        local sliderPosition = Slider.AbsolutePosition.Y
    
        local newThumbPosition = (input.Position.Y - sliderPosition - offset) / sliderSize
        newThumbPosition = math.clamp(newThumbPosition, 0, 1) 
    
        Thumb.Position = UDim2.new(0, 0, newThumbPosition, 0)
        updateScrollingFramePosition()
    end
    
    Hitbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local offset = input.Position.Y - Thumb.AbsolutePosition.Y
            local connection
    
            connection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    local sliderSize = Slider.AbsoluteSize.Y
                    local sliderPosition = Slider.AbsolutePosition.Y
    
                    local newThumbPosition = (input.Position.Y - sliderPosition - offset) / sliderSize
                    newThumbPosition = math.clamp(newThumbPosition, 0, 1)
    
                    Thumb.Position = UDim2.new(0, 0, newThumbPosition, 0)
                    updateScrollingFramePosition()
                end
            end)
    
            local releaseConnection
            releaseConnection = UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                    connection:Disconnect()
                    releaseConnection:Disconnect()
                end
            end)
        end
    end)
    
    Window.UIElements.SideBar:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        local canvasPosition = Window.UIElements.SideBar.CanvasPosition.Y
        local canvasSize = Window.UIElements.SideBar.AbsoluteCanvasSize.Y - Window.UIElements.SideBar.AbsoluteWindowSize.Y
        local newThumbPosition = canvasPosition / canvasSize
    
        Thumb.Position = UDim2.new(0, 0, newThumbPosition, 0)
    end)
    
    Thumb:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        Slider.Size = UDim2.new(0, Slider.Size.X.Offset, 1, -Thumb.AbsoluteSize.Y - Window.UIPadding*2)
    end)
    Window.UIElements.SideBar:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateSliderSize)
    Window.UIElements.SideBar:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateSliderSize)
    
    updateSliderSize()

    Window.UIElements.MainBar = New("Frame", {
        Size = UDim2.new(1,-Window.UIElements.SideBarContainer.AbsoluteSize.X,1,-52),
        Position = UDim2.new(1,0,1,0),
        AnchorPoint = Vector2.new(1,1),
        BackgroundTransparency = 1,
    })
    
    local Gradient = New("Frame", {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1, -- Window.Transparent and 0.25 or 0
        ZIndex = 3,
        Name = "Gradient",
        Visible = false
    }, {
        New("UIGradient", {
            Color = ColorSequence.new(Color3.new(0,0,0),Color3.new(0,0,0)),
            Rotation = 90,
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 1), 
                NumberSequenceKeypoint.new(1, Window.Transparent and 0.85 or 0.7),
            }
        }),
        New("UICorner", {
            CornerRadius = UDim.new(0,Window.UICorner)
        })
    })
    
    local Blur = New("ImageLabel", {
        Image = "rbxassetid://8992230677",
        ImageColor3 = Color3.new(0,0,0),
        ImageTransparency = 1, -- 0.7
        Size = UDim2.new(1,120,1,116),
        Position = UDim2.new(0,-120/2,0,-116/2),
        ScaleType = "Slice",
        SliceCenter = Rect.new(99,99,99,99),
        BackgroundTransparency = 1,
    })

    local IsPC

    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        IsPC = false
    elseif UserInputService.KeyboardEnabled then
        IsPC = true
    else
        IsPC = nil
    end
    
    local OpenButtonContainer = nil
    local OpenButton = nil
    local OpenButtonIcon = nil
    local Glow = nil
    
    if not IsPC then
        OpenButtonIcon = New("ImageLabel", {
            Image = "",
            Size = UDim2.new(0,22,0,22),
            Position = UDim2.new(0.5,0,0.5,0),
            LayoutOrder = -1,
            AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundTransparency = 1,
            Name = "Icon"
        })
    
        OpenButtonTitle = New("TextLabel", {
            Text = Window.Title,
            TextSize = 17,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
            BackgroundTransparency = 1,
            AutomaticSize = "XY",
        })
    
        OpenButtonDrag = New("ImageLabel", {
            Image = Creator.Icon("grab")[1],
            ImageRectOffset = Creator.Icon("grab")[2].ImageRectPosition,
            ImageRectSize = Creator.Icon("grab")[2].ImageRectSize,
            Size = UDim2.new(0,20,0,20),
            BackgroundTransparency = 1,
            Position = UDim2.new(0,0,0.5,0),
            AnchorPoint = Vector2.new(0,0.5),
        })
        OpenButtonDivider = New("Frame", {
            Size = UDim2.new(0,1,1,-16),
            Position = UDim2.new(0,20+16,0.5,0),
            AnchorPoint = Vector2.new(0,0.5),
            BackgroundColor3 = Color3.new(1,1,1),
            BackgroundTransparency = .86,
        })
    
        OpenButtonContainer = New("Frame", {
            Size = UDim2.new(0,0,0,0),
            Position = UDim2.new(0.5,0,0,6+44/2),
            AnchorPoint = Vector2.new(0.5,0.5),
            Parent = Config.Parent,
            BackgroundTransparency = 1,
            Active = true,
            Visible = false,
        })
        OpenButton = New("TextButton", {
            Size = UDim2.new(0,0,0,44),
            AutomaticSize = "X",
            Parent = OpenButtonContainer,
            Active = false,
            BackgroundColor3 = Color3.new(0,0,0),
            BackgroundTransparency = .3,
            ZIndex = 99,
        }, {
            New("UIScale", {
                Scale = 1.05,
            }),
		    New("UICorner", {
                CornerRadius = UDim.new(1,0)
            }),
            New("UIStroke", {
                Thickness = 1,
                ApplyStrokeMode = "Border",
                Color = Color3.new(1,1,1),
                Transparency = 0,
            }, {
                New("UIGradient", {
                    Color = ColorSequence.new(Color3.fromHex("40c9ff"), Color3.fromHex("e81cff"))
                })
            }),
            OpenButtonDrag,
            OpenButtonDivider,
            
            New("UIListLayout", {
                Padding = UDim.new(0, Window.UIPadding),
                FillDirection = "Horizontal",
                VerticalAlignment = "Center",
            }),
            
            New("TextButton",{
                AutomaticSize = "XY",
                Active = true,
                BackgroundTransparency = 1,
                Size = UDim2.new(0,0,1,0),
                Position = UDim2.new(0,20+16+16+1,0,0)
            }, {
                OpenButtonIcon,
                New("UIListLayout", {
                    Padding = UDim.new(0, Window.UIPadding),
                    FillDirection = "Horizontal",
                    VerticalAlignment = "Center",
                }),
                OpenButtonTitle,
            }),
            New("UIPadding", {
                PaddingTop = UDim.new(0,0),
                PaddingLeft = UDim.new(0,16),
                PaddingRight = UDim.new(0,16),
                PaddingBottom = UDim.new(0,0),
            })
        })
        
        local uiGradient = OpenButton and OpenButton.UIStroke.UIGradient or nil
    
        -- Glow = New("ImageLabel", {
        --     Image = "rbxassetid://93831937596979", -- UICircle Glow
        --     ScaleType = "Slice",
        --     SliceCenter = Rect.new(375,375,375,375),
        --     BackgroundTransparency = 1,
        --     Size = UDim2.new(1,21,1,21),
        --     Position = UDim2.new(0.5,0,0.5,0),
        --     AnchorPoint = Vector2.new(0.5,0.5),
        --     ImageTransparency = .5,
        --     Parent = OpenButtonContainer,
        -- }, {
        --     New("UIGradient", {
        --         Color = ColorSequence.new(Color3.fromHex("40c9ff"), Color3.fromHex("e81cff"))
        --     })
        -- })
        
        RunService.RenderStepped:Connect(function(deltaTime)
            if Window.UIElements.Main and OpenButtonContainer and OpenButtonContainer.Parent ~= nil then
                if uiGradient then
                    uiGradient.Rotation = (uiGradient.Rotation + 1) % 360
                end
                if Glow and Glow.Parent ~= nil and Glow.UIGradient then
                    Glow.UIGradient.Rotation = (Glow.UIGradient.Rotation + 1) % 360
                end
            end
        end)
        
        OpenButton:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            OpenButtonContainer.Size = UDim2.new(
                0, OpenButton.AbsoluteSize.X,
                0, OpenButton.AbsoluteSize.Y
            )
        end)
        
        OpenButton.TextButton.MouseEnter:Connect(function()
            Tween(OpenButton.UIScale, .1, {Scale = .99}):Play()
        end)
        OpenButton.TextButton.MouseLeave:Connect(function()
            Tween(OpenButton.UIScale, .1, {Scale = 1.05}):Play()
        end)
    end
    
    local Outline1
    local Outline2
    if Window.HasOutline then
        Outline1 = New("Frame", {
            Name = "Outline",
            Size = UDim2.new(1,Window.UIPadding*2,0,1),
            Position = UDim2.new(0.5,0,1,Window.UIPadding),
            BackgroundTransparency= .9,
            AnchorPoint = Vector2.new(0.5,0.5),
            ThemeTag = {
                BackgroundColor3 = "Outline"
            },
        })
        Outline2 = New("Frame", {
            Name = "Outline",
            Size = UDim2.new(0,1,1,-52),
            Position = UDim2.new(0,Window.SideBarWidth -Window.UIPadding/2,0,52),
            BackgroundTransparency= .9,
            AnchorPoint = Vector2.new(0.5,0),
            ThemeTag = {
                BackgroundColor3 = "Outline"
            },
        })
    end
    
    local WindowTitle = New("TextLabel", {
        Text = Window.Title,
        FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
        BackgroundTransparency = 1,
        AutomaticSize = "XY",
        Name = "Title",
        TextXAlignment = "Left",
        TextSize = 16,
        ThemeTag = {
            TextColor3 = "Text"
        }
    })
    
    Window.UIElements.Main = New("Frame", {
        Size = Window.Size,
        Position = Window.Position,
        BackgroundTransparency = 1,
        Parent = Config.Parent,
        AnchorPoint = Vector2.new(0.5,0.5),
        Active = true,
    }, {
        Blur,
        Gradient,
        New("Frame", {
            BackgroundTransparency = 1, -- Window.Transparent and 0.25 or 0
            Size = UDim2.new(1,0,1,0),
            AnchorPoint = Vector2.new(0.5,0.5),
            Position = UDim2.new(0.5,0,0.5,0),
            Name = "Background",
            ThemeTag = {
                BackgroundColor3 = "Accent"
            },
            ZIndex = 2,
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0,Window.UICorner)
            }),
            New("ImageLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,1,0),
                Image = Window.Background,
                -- ImageTransparency = 0,
            }, {
                New("UICorner", {
                    CornerRadius = UDim.new(0,Window.UICorner)
                }),
            }),
            New("UIScale", {
                Scale = 0.95,
            }),
        }),
        UIStroke,
        UICorner,
        ResizeHandle,
        FullScreenIcon,
        New("Frame", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            Name = "Main",
            --GroupTransparency = 1,
            Visible = false,
            ZIndex = 97,
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0,Window.UICorner)
            }),
            Window.UIElements.SideBarContainer,
            Window.UIElements.MainBar,
            Outline2,
            New("Frame", { -- Topbar
                Size = UDim2.new(1,0,0,52),
                BackgroundTransparency = 1,
                BackgroundColor3 = Color3.fromRGB(50,50,50),
                Name = "Topbar"
            }, {
                Outline1,
                --[[New("Frame", { -- Outline
                    Size = UDim2.new(1,Window.UIPadding*2, 0, 1),
                    Position = UDim2.new(0,-Window.UIPadding, 1,Window.UIPadding-2),
                    BackgroundTransparency = 0.9,
                    BackgroundColor3 = Color3.fromHex(Config.Theme.Outline),
                }),]]
                New("Frame", { -- Topbar Left Side
                    AutomaticSize = "X",
                    Size = UDim2.new(0,0,1,0),
                    BackgroundTransparency = 1,
                    Name = "Left"
                }, {
                    New("UIListLayout", {
                        Padding = UDim.new(0,10),
                        SortOrder = "LayoutOrder",
                        FillDirection = "Horizontal",
                        VerticalAlignment = "Center",
                    }),
                    New("Frame", {
                        AutomaticSize = "XY",
                        BackgroundTransparency = 1,
                        Name = "Title",
                        Size = UDim2.new(0,0,1,0),
                        LayoutOrder= 2,
                    }, {
                        New("UIListLayout", {
                            Padding = UDim.new(0,0),
                            SortOrder = "LayoutOrder",
                            FillDirection = "Vertical",
                            VerticalAlignment = "Top",
                        }),
                        WindowTitle,
                    }),
                    New("UIPadding", {
                        PaddingLeft = UDim.new(0,4)
                    })
                }),
                New("Frame", { -- Topbar Right Side -- Window.UIElements.Main.Main.Topbar.Right
                    AutomaticSize = "XY",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1,0,0.5,0),
                    AnchorPoint = Vector2.new(1,0.5),
                    Name = "Right",
                }, {
                    New("UIListLayout", {
                        Padding = UDim.new(0,20),
                        FillDirection = "Horizontal",
                        SortOrder = "LayoutOrder",
                    }),
                    
                    
                }),
                New("UIPadding", {
                    PaddingTop = UDim.new(0,Window.UIPadding),
                    PaddingLeft = UDim.new(0,Window.UIPadding),
                    PaddingRight = UDim.new(0,Window.UIPadding),
                    PaddingBottom = UDim.new(0,Window.UIPadding),
                })
            })
        })
    })

    
    function Window:CreateTopbarButton(Icon, Callback, LayoutOrder)
        local Button = New("TextButton", {
            Size = UDim2.new(0,24,0,24),
            BackgroundTransparency = 1,
            LayoutOrder = LayoutOrder or 999,
            Parent = Window.UIElements.Main.Main.Topbar.Right,
            --Active = true,
            ZIndex = 9999,
        }, {
            New("ImageLabel", {
                Image = Creator.Icon(Icon)[1],
                ImageRectOffset = Creator.Icon(Icon)[2].ImageRectPosition,
                ImageRectSize = Creator.Icon(Icon)[2].ImageRectSize,
                BackgroundTransparency = 1,
                Size = UDim2.new(1,-6,1,-6),
                ThemeTag = {
                    ImageColor3 = "Text"
                },
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.new(0.5,0,0.5,0),
                Active = false
            }),
        })
        
        Button.MouseButton1Click:Connect(function()
            Callback()
        end)
        
        return Button
    end

    -- local Dragged = false

    Creator.Drag(Window.UIElements.Main, true)
    
    --Creator.Blur(Window.UIElements.Main.Background)
    local OpenButtonDragModule
    
    if not IsPC then
        OpenButtonDragModule = Creator.Drag(OpenButtonContainer)
    end
    
    if Window.Author then
        local Author = New("TextLabel", {
            Text = Window.Author,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
            BackgroundTransparency = 1,
            TextTransparency = 0.4,
            AutomaticSize = "XY",
            Parent = Window.UIElements.Main.Main.Topbar.Left.Title,
            TextXAlignment = "Left",
            TextSize = 14,
            LayoutOrder = 2,
            ThemeTag = {
                TextColor3 = "Text"
            }
        })
        -- Author:GetPropertyChangedSignal("TextBounds"):Connect(function()
        --     Author.Size = UDim2.new(0,Author.TextBounds.X,0,Author.TextBounds.Y)
        -- end)
    end
    -- WindowTitle:GetPropertyChangedSignal("TextBounds"):Connect(function()
    --     WindowTitle.Size = UDim2.new(0,WindowTitle.TextBounds.X,0,WindowTitle.TextBounds.Y)
    -- end)
    -- Window.UIElements.Main.Main.Topbar.Frame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    --     Window.UIElements.Main.Main.Topbar.Frame.Size = UDim2.new(0,Window.UIElements.Main.Main.Topbar.Frame.UIListLayout.AbsoluteContentSize.X,0,Window.UIElements.Main.Main.Topbar.Frame.UIListLayout.AbsoluteContentSize.Y)
    -- end)
    -- Window.UIElements.Main.Main.Topbar.Left.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    --     Window.UIElements.Main.Main.Topbar.Left.Size = UDim2.new(0,Window.UIElements.Main.Main.Topbar.Left.UIListLayout.AbsoluteContentSize.X,1,0)
    -- end)
    
    task.spawn(function()
        if Window.Icon then
            local themetag = { ImageColor3 = "Text" }
            
            if string.find(Window.Icon, "rbxassetid://") or not Creator.Icon(tostring(Window.Icon))[1] then
                themetag = nil
            end
            local ImageLabel = New("ImageLabel", {
                Parent = Window.UIElements.Main.Main.Topbar.Left,
                Size = UDim2.new(0,24,0,24),
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                ThemeTag = themetag
            })
            if string.find(Window.Icon, "rbxassetid://") or string.find(Window.Icon, "http://www.roblox.com/asset/?id=") then
                ImageLabel.Image = Window.Icon
                OpenButtonIcon.Image = Window.Icon
            elseif string.find(Window.Icon,"http") then
                local success, response = pcall(function()
                    if not isfile("WindUI/" .. Window.Folder .. "/Assets/Icon.png") then
                        local response = request({
                            Url = Window.Icon,
                            Method = "GET",
                        }).Body
                        writefile("WindUI/" .. Window.Folder .. "/Assets/Icon.png", response)
                    end
                    ImageLabel.Image = getcustomasset("WindUI/" .. Window.Folder .. "/Assets/Icon.png")
                    OpenButtonIcon.Image = getcustomasset("WindUI/" .. Window.Folder .. "/Assets/Icon.png")
                end)
                if not success then
                    ImageLabel:Destroy()
                    
                    warn("[ WindUI ]  '" .. identifyexecutor() .. "' doesnt support the URL Images. Error: " .. response)
                end
            else
                if Creator.Icon(tostring(Window.Icon))[1] then
                    ImageLabel.Image = Creator.Icon(Window.Icon)[1]
                    ImageLabel.ImageRectOffset = Creator.Icon(Window.Icon)[2].ImageRectPosition
                    ImageLabel.ImageRectSize = Creator.Icon(Window.Icon)[2].ImageRectSize
                    OpenButtonIcon.Image = Creator.Icon(Window.Icon)[1]
                    OpenButtonIcon.ImageRectOffset = Creator.Icon(Window.Icon)[2].ImageRectPosition
                    OpenButtonIcon.ImageRectSize = Creator.Icon(Window.Icon)[2].ImageRectSize
                end
            end
        elseif OpenButtonIcon then
            OpenButtonIcon.Visible = false
        end
    end)
    
    function Window:Open()
        Window.Closed = false
        
        Tween(Window.UIElements.Main.Background, 0.25, {BackgroundTransparency = Config.Transparent and Config.WindUI.TransparencyValue or 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        --Tween(Window.UIElements.Main.Main, 0.25, {BackgroundTransparency = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(Window.UIElements.Main.Background.UIScale, 0.2, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(Gradient, 0.25, {BackgroundTransparency = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(Blur, 0.25, {ImageTransparency = .7}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        if UIStroke then
            Tween(UIStroke, 0.25, {Transparency = .8}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        end
        
        Window.CanDropdown = true
        
        Window.UIElements.Main.Visible = true
        task.wait(.08)
        Window.UIElements.Main.Main.Visible = true
    end
    function Window:Close()
        local Close = {}
        
        Window.UIElements.Main.Main.Visible = false
        Window.CanDropdown = false
        Window.Closed = true
        
        Tween(Window.UIElements.Main.Background, 0.25, {BackgroundTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        --Tween(Window.UIElements.Main.Main, 0.25, {BackgroundTransparency= 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(Window.UIElements.Main.Background.UIScale, 0.19, {Scale = .95}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(Gradient, 0.25, {BackgroundTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Tween(Blur, 0.25, {ImageTransparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        if UIStroke then
            Tween(UIStroke, 0.25, {Transparency = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        end
        
        task.spawn(function()
            task.wait(0.25)
            Window.UIElements.Main.Visible = false
        end)
        
        function Close:Destroy()
            Window.Destroyed = true
            task.wait(0.25)
            Config.Parent.Parent:Destroy()
        end
        
        return Close
    end
    
    local CurrentPos
    local CurrentSize
    local iconCopy = Creator.Icon("minimize")
    local iconSquare = Creator.Icon("maximize")
    
    
    local FullscreenButton
    
    FullscreenButton = Window:CreateTopbarButton("maximize", function() 
        local isFullscreen = Window.IsFullscreen
        Creator.SetDraggable(isFullscreen)
    
        if not isFullscreen then
            CurrentPos = Window.UIElements.Main.Position
            CurrentSize = Window.UIElements.Main.Size
            FullscreenButton.ImageLabel.Image = iconCopy[1]
            FullscreenButton.ImageLabel.ImageRectOffset = iconCopy[2].ImageRectPosition
            FullscreenButton.ImageLabel.ImageRectSize = iconCopy[2].ImageRectSize
        else
            FullscreenButton.ImageLabel.Image = iconSquare[1]
            FullscreenButton.ImageLabel.ImageRectOffset = iconSquare[2].ImageRectPosition
            FullscreenButton.ImageLabel.ImageRectSize = iconSquare[2].ImageRectSize
        end
        
        Tween(Window.UIElements.Main, 0.45, {Size = isFullscreen and CurrentSize or UDim2.new(1,-20,1,-20-52)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
    
        delay(0, function()
            Tween(Window.UIElements.Main, 0.45, {Position = isFullscreen and CurrentPos or UDim2.new(0.5,0,0.5,52/2)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        end)
        
        Window.IsFullscreen = not isFullscreen
    end, 998)
    Window:CreateTopbarButton("minus", function() 
        Window:Close()
        task.spawn(function()
            task.wait(.3)
            if not IsPC and Window.IsOpenButtonEnabled then
                OpenButtonContainer.Visible = true
            end
        end)
        
        local NotifiedText = IsPC and "Press " .. Window.ToggleKey.Name .. " to open the Window" or "Click the Button to open the Window"
        
        if not Window.IsOpenButtonEnabled then
            Notified = true
        end
        if not Notified then
            Notified = not Notified
            Config.WindUI:Notify({
                Title = "Minimize",
                Content = "You've closed the Window. " .. NotifiedText,
                Icon = "eye-off",
                Duration = 5,
            })
        end
    end, 997)

    if not IsPC and Window.IsOpenButtonEnabled then
        OpenButton.TextButton.MouseButton1Click:Connect(function()
            Window:Open()
            OpenButtonContainer.Visible = false
        end)
    end
    
    UserInputService.InputBegan:Connect(function(input, isProcessed)
        if isProcessed then return end
        
        if input.KeyCode == Window.ToggleKey then
            if Window.Closed then
                Window:Open()
            else
                Window:Close()
            end
        end
    end)
    
    task.spawn(function()
        --task.wait(1.38583)
        Window:Open()
    end)
    
    function Window:EditOpenButton(OpenButtonConfig)
        task.wait()
        if OpenButton and OpenButton.Parent ~= nil then
            local OpenButtonModule = {
                Title = OpenButtonConfig.Title,
                Icon = OpenButtonConfig.Icon or Window.Icon,
                Enabled = OpenButtonConfig.Enabled,
                Position = OpenButtonConfig.Position,
                Draggable = OpenButtonConfig.Draggable,
                OnlyMobile = OpenButtonConfig.OnlyMobile,
                CornerRadius = OpenButtonConfig.CornerRadius or UDim.new(1, 0),
                StrokeThickness = OpenButtonConfig.StrokeThickness or 2,
                Color = OpenButtonConfig.Color 
                    or ColorSequence.new(Color3.fromHex("40c9ff"), Color3.fromHex("e81cff")),
            }
            
            -- wtf lol
            
            if OpenButtonModule.Enabled == false then
                Window.IsOpenButtonEnabled = false
            end
            if OpenButtonModule.Draggable == false and OpenButtonDrag and OpenButtonDivider then
                OpenButtonDrag.Visible = OpenButtonModule.Draggable
                OpenButtonDivider.Visible = OpenButtonModule.Draggable
                
                if OpenButtonDragModule then
                    OpenButtonDragModule:Set(OpenButtonModule.Draggable)
                end
            end
            if OpenButtonModule.Position and OpenButtonContainer then
                OpenButtonContainer.Position = OpenButtonModule.Position
                --OpenButtonContainer.AnchorPoint = Vector2.new(0,0)
            end
            
            local IsPC = UserInputService.KeyboardEnabled or not UserInputService.TouchEnabled
            OpenButton.Visible = not OpenButtonModule.OnlyMobile or not IsPC
            
            if not OpenButton.Visible then return end
            
            if OpenButtonTitle then
                if OpenButtonModule.Title then
                    OpenButtonTitle.Text = OpenButtonModule.Title
                elseif OpenButtonModule.Title == nil then
                    --OpenButtonTitle.Visible = false
                end
            end
            
            if Creator.Icon(OpenButtonModule.Icon) and OpenButtonIcon then
                OpenButtonIcon.Image = Creator.Icon(OpenButtonModule.Icon)[1]
                OpenButtonIcon.ImageRectOffset = Creator.Icon(OpenButtonModule.Icon)[2].ImageRectPosition
                OpenButtonIcon.ImageRectSize = Creator.Icon(OpenButtonModule.Icon)[2].ImageRectSize
            end
    
            OpenButton.UIStroke.UIGradient.Color = OpenButtonModule.Color
            if Glow then
                Glow.UIGradient.Color = OpenButtonModule.Color
            end
    
            OpenButton.UICorner.CornerRadius = OpenButtonModule.CornerRadius
            OpenButton.UIStroke.Thickness = OpenButtonModule.StrokeThickness
        end
    end
    
    
    local TabModule = __DARKLUA_BUNDLE_MODULES.load('q').Init(Window, Config.WindUI, Config.Parent.Parent.ToolTips, TabHighlight)
    
    TabModule:OnChange(function(t) Window.CurrentTab = t end)
    function Window:Tab(TabConfig)
        return TabModule.New({ Title = TabConfig.Title, Icon = TabConfig.Icon, Parent = Window.UIElements.SideBar.Frame, Desc = TabConfig.Desc })
    end
    
    function Window:SelectTab(Tab)
        TabModule:SelectTab(Tab)
    end
    
    
    function Window:Divider()
        local Divider = New("Frame", {
            Size = UDim2.new(1,0,0,1),
            Position = UDim2.new(0.5,0,0,0),
            AnchorPoint = Vector2.new(0.5,0),
            BackgroundTransparency = .8,
            ThemeTag = {
                BackgroundColor3 = "Text"
            }
        })
        New("Frame", {
            Parent = Window.UIElements.SideBar.Frame,
            --AutomaticSize = "Y",
            Size = UDim2.new(1,0,0,1),
            BackgroundTransparency = 1,
        }, {
            Divider
        })
    end
    
    local DialogModule = __DARKLUA_BUNDLE_MODULES.load('c').Init(Window)
    function Window:Dialog(DialogConfig)
        local DialogTable = {
            Title = DialogConfig.Title or "Dialog",
            Content = DialogConfig.Content,
            Buttons = DialogConfig.Buttons or {},
        }
        local Dialog = DialogModule.Create()
        
        local DialogTopFrame = New("Frame", {
            Size = UDim2.new(1,0,0,0),
            AutomaticSize = "Y",
            BackgroundTransparency = 1,
            Parent = Dialog.UIElements.Main
        }, {
            New("UIListLayout", {
                FillDirection = "Horizontal",
                Padding = UDim.new(0,Dialog.UIPadding),
                VerticalAlignment = "Center"
            })
        })
        
        local p
        if DialogConfig.Icon and Creator.Icon(DialogConfig.Icon)[2] then
            p = New("ImageLabel", {
                Image = Creator.Icon(DialogConfig.Icon)[1],
                ImageRectSize = Creator.Icon(DialogConfig.Icon)[2].ImageRectSize,
                ImageRectOffset = Creator.Icon(DialogConfig.Icon)[2].ImageRectPosition,
                ThemeTag = {
                    ImageColor3 = "Text",
                },
                Size = UDim2.new(0,26,0,26),
                BackgroundTransparency = 1,
                Parent = DialogTopFrame
            })
        end
        
        Dialog.UIElements.UIListLayout = New("UIListLayout", {
            Padding = UDim.new(0,8*2.3),
            FillDirection = "Vertical",
            HorizontalAlignment = "Left",
            Parent = Dialog.UIElements.Main
        })
    
        New("UISizeConstraint", {
			MinSize = Vector2.new(180, 20),
			MaxSize = Vector2.new(620, math.huge),
			Parent = Dialog.UIElements.Main,
		})
        
        Dialog.UIElements.Title = New("TextLabel", {
            Text = DialogTable.Title,
            TextSize = 19,
            FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
            TextXAlignment = "Left",
            TextWrapped = true,
            RichText = true,
            Size = UDim2.new(1,p and -26-Dialog.UIPadding or 0,0,0),
            AutomaticSize = "Y",
            ThemeTag = {
                TextColor3 = "Text"
            },
            BackgroundTransparency = 1,
            Parent = DialogTopFrame
        })
        if DialogTable.Content then
            local Content = New("TextLabel", {
                Text = DialogTable.Content,
                TextSize = 17,
                TextTransparency = .4,
                TextWrapped = true,
                RichText = true,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                TextXAlignment = "Left",
                Size = UDim2.new(1,0,0,0),
                AutomaticSize = "Y",
                LayoutOrder = 2,
                ThemeTag = {
                    TextColor3 = "Text"
                },
                BackgroundTransparency = 1,
                Parent = Dialog.UIElements.Main
            })
        end
        
        -- Dialog.UIElements.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        --     Dialog.UIElements.Main.Size = UDim2.new(0,Dialog.UIElements.UIListLayout.AbsoluteContentSize.X,0,Dialog.UIElements.UIListLayout.AbsoluteContentSize.Y+Dialog.UIPadding*2)
        -- end)
        -- Dialog.UIElements.Title:GetPropertyChangedSignal("TextBounds"):Connect(function()
        --     Dialog.UIElements.Title.Size = UDim2.new(1,0,0,Dialog.UIElements.Title.TextBounds.Y)
        -- end)
        
        -- New("Frame", {
        --     Name = "Line",
        --     Size = UDim2.new(1, Dialog.UIPadding*2, 0, 1),
        --     Parent = Dialog.UIElements.Main,
        --     LayoutOrder = 3,
        --     BackgroundTransparency = 1,
        --     ThemeTag = {
        --         BackgroundColor3 = "Text",
        --     }
        -- })
        
        local ButtonsContent = New("Frame", {
            Size = UDim2.new(1,0,0,32),
            AutomaticSize = "None",
            BackgroundTransparency = 1,
            Parent = Dialog.UIElements.Main,
            LayoutOrder = 4,
        }, {
            New("UIListLayout", {
			    Padding = UDim.new(0, 10),
			    FillDirection = "Horizontal",
			    HorizontalAlignment = "Center",
		    }),
        })
        
        for _,Button in next, DialogTable.Buttons do
            if Button.Variant == nil or Button.Variant == "" then
                Button.Variant = "Secondary"
            end
            local ButtonFrame = New("TextButton", {
                Text = Button.Title or "Button",
                TextSize = 16,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
                ThemeTag = {
                    TextColor3 = Button.Variant == "Secondary" and "Text" or "Accent",
                    BackgroundColor3 = "Text",
                },
                BackgroundTransparency = Button.Variant == "Secondary" and .93 or .1 ,
                Parent = ButtonsContent,
                Size = UDim2.new(1 / #DialogTable.Buttons, -(((#DialogTable.Buttons - 1) * 10) / #DialogTable.Buttons), 1, 0),
                --AutomaticSize = "X",
            }, {
                New("UICorner", {
                    CornerRadius = UDim.new(0, Dialog.UICorner-5),
                }),
                New("UIPadding", {
                    PaddingTop = UDim.new(0, 0),
                    PaddingLeft = UDim.new(0, Dialog.UIPadding/1.85),
                    PaddingRight = UDim.new(0, Dialog.UIPadding/1.85),
                    PaddingBottom = UDim.new(0, 0),
                }),
                New("Frame", {
                    Size = UDim2.new(1,(Dialog.UIPadding/1.85)*2,1,0),
                    Position = UDim2.new(0.5,0,0.5,0),
                    AnchorPoint = Vector2.new(0.5,0.5),
                    ThemeTag = {
                        BackgroundColor3 = Button.Variant == "Secondary" and "Text" or "Accent"
                    },
                    BackgroundTransparency = 1, -- .9
                }, {
                    New("UICorner", {
                        CornerRadius = UDim.new(0, Dialog.UICorner-5),
                    }),
                }),
                New("UIStroke", {
                    ThemeTag = {
                        Color = "Text",
                    },
                    Thickness = 1.2,
                    Transparency = Button.Variant == "Secondary" and .9 or .1,
                    ApplyStrokeMode = "Border",
                })
            })
            
            ButtonFrame.MouseEnter:Connect(function()
                Tween(ButtonFrame.Frame, 0.1, {BackgroundTransparency = .9}):Play()
            end)
            ButtonFrame.MouseLeave:Connect(function()
                Tween(ButtonFrame.Frame, 0.1, {BackgroundTransparency = 1}):Play()
            end)
            ButtonFrame.MouseButton1Click:Connect(function()
                Dialog:Close()
                task.spawn(function()
                    Button.Callback()
                end)
            end)
        end
        
        --Dialog:Open()
        
        return Dialog
    end
    
    
    local CloseDialog = Window:Dialog({
        Icon = "trash-2",
        Title = "Close Window",
        Content = "Do you want to close this window? You will not be able to open it again.",
        Buttons = {
            {
                Title = "Cancel",
                Callback = function() end,
                Variant = "Secondary",
            },
            {
                Title = "Close Window",
                Callback = function() Window:Close():Destroy() end,
                Variant = "Primary",
            }
        }
    })
    
    Window:CreateTopbarButton("x", function()
        Tween(Window.UIElements.Main, 0.35, {Position = UDim2.new(0.5,0,0.5,0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        CloseDialog:Open()
    end, 999)
    

    local function startResizing(input)
        if not isFullscreen then
            isResizing = true
            FullScreenIcon.Active = true
            initialSize = Window.UIElements.Main.Size
            initialInputPosition = input.Position
            Tween(FullScreenIcon, 0.2, {BackgroundTransparency = .65}):Play()
            Tween(FullScreenIcon.ImageLabel, 0.2, {ImageTransparency = 0}):Play()
        
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isResizing = false
                    FullScreenIcon.Active = false
                    Tween(FullScreenIcon, 0.2, {BackgroundTransparency = 1}):Play()
                    Tween(FullScreenIcon.ImageLabel, 0.2, {ImageTransparency = 1}):Play()
                end
            end)
        end
    end
    
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            startResizing(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isResizing and not isFullscreen then
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - initialInputPosition
                local newSize = UDim2.new(0, initialSize.X.Offset + delta.X*2, 0, initialSize.Y.Offset + delta.Y*2)
                
                Tween(Window.UIElements.Main, 0.06, {
                    Size = UDim2.new(
                    0, math.clamp(newSize.X.Offset, 480, 700),
                    0, math.clamp(newSize.Y.Offset, 350, 520)
                )}):Play()
            end
        end
    end)
    
    
    -- / Search Bar /
    
    local SearchBar = __DARKLUA_BUNDLE_MODULES.load('r')
    local CanOpen = true
    local IsOpen = false
    local CurrentSearchBar
    
    local SearchButton
    SearchButton = Window:CreateTopbarButton("search", function() 
        if not CanOpen and not IsOpen then return end
        if not Window.CurrentTab then return end
        
        local function closeSearchbar()
            CanOpen = true
            IsOpen = false
            
            Window.UIElements.SideBarContainer.Visible = true
            Tween(Window.UIElements.MainBar, .25, {
                Size = UDim2.new(
                    1,
                    -Window.UIElements.SideBarContainer.AbsoluteSize.X,
                    Window.UIElements.SideBarContainer.Size.Y.Scale,
                    Window.UIElements.SideBarContainer.Size.Y.Offset
                )
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
            Tween(Window.UIElements.SideBarContainer, .1, {
                GroupTransparency = 0
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
            
            Tween(SearchButton.ImageLabel, .15, {ImageTransparency = 0}):Play()
        end
        
        if not IsOpen then
            CanOpen = false
            IsOpen = true
            
            Tween(Window.UIElements.MainBar, .25, {
                Size = UDim2.new(
                    1,
                    0,
                    Window.UIElements.SideBarContainer.Size.Y.Scale,
                    Window.UIElements.SideBarContainer.Size.Y.Offset-52
                )
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
            Tween(Window.UIElements.SideBarContainer, .1, {
                GroupTransparency = 1
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
            
            Tween(SearchButton.ImageLabel, .15, {ImageTransparency = .4}):Play()
            
            CurrentSearchBar = SearchBar.new(
                TabModule.Tabs[Window.CurrentTab].Elements, 
                Window.UIElements.Main, 
                TabModule.Tabs[Window.CurrentTab].Title, 
                closeSearchbar,
                TabModule.Tabs[Window.CurrentTab].ContainerFrame 
            )
        else
            closeSearchbar()
            
            if CurrentSearchBar then
                CurrentSearchBar:Close()
                CurrentSearchBar:Search("")
                CurrentSearchBar = nil
            end
        end
        
        task.wait(.25)
        Window.UIElements.SideBarContainer.Visible = not IsOpen
    end, 996)

    return Window
end end end
local WindUI = {
    Window = nil,
    Theme = nil,
    Themes = nil,
    Transparent = false,
    
    TransparencyValue = .25,
}
local RunService = game:GetService("RunService")

local Themes = __DARKLUA_BUNDLE_MODULES.load('a')
local KeySystem = __DARKLUA_BUNDLE_MODULES.load('d')
local Creator = __DARKLUA_BUNDLE_MODULES.load('b')

local New = Creator.New
local Tween = Creator.Tween

local LocalPlayer = game:GetService("Players") and game:GetService("Players").LocalPlayer or nil

WindUI.Themes = Themes

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end


WindUI.ScreenGui = New("ScreenGui", {
    Name = "WindUI",
    Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or gethui and gethui() or game.CoreGui,
    IgnoreGuiInset = true,
}, {
    New("Folder", {
        Name = "Window"
    }),
    New("Folder", {
        Name = "Notifications"
    }),
    New("Folder", {
        Name = "Dropdowns"
    }),
    New("Folder", {
        Name = "KeySystem"
    }),
    New("Folder", {
        Name = "ToolTips"
    })
})
ProtectGui(WindUI.ScreenGui)


local Notify = __DARKLUA_BUNDLE_MODULES.load('e')
local Holder = Notify.Init(WindUI.ScreenGui.Notifications)

function WindUI:Notify(Config)
    Config.Holder = Holder.Frame
    Config.Window = WindUI.Window
    Config.WindUI = WindUI
    return Notify.New(Config)
end

function WindUI:SetNotificationLower(Val)
    Holder.SetLower(Val)
end

function WindUI:SetFont(FontId)
    Creator.UpdateFont(FontId)
end

function WindUI:AddTheme(LTheme)
    Themes[LTheme.Name] = LTheme
    return LTheme
end

function WindUI:SetTheme(Value)
if Themes[Value] then
    WindUI.Theme = Themes[Value]
    Creator.SetTheme(Themes[Value])
    Creator.UpdateTheme()
    
    return Themes[Value]
end
return nil
end

function WindUI:GetThemes()
    return Themes
end
function WindUI:GetCurrentTheme()
    return WindUI.Theme.Name
end
function WindUI:GetTransparency()
    return WindUI.Transparent or false
end
function WindUI:GetWindowSize()
    return Window.UIElements.Main.Size
end



function WindUI:CreateWindow(Config)
    local CreateWindow = __DARKLUA_BUNDLE_MODULES.load('s')
    
    if not isfolder("WindUI") then
        makefolder("WindUI")
    end
    if Config.Folder then
        makefolder(Config.Folder)
    else
        makefolder(Config.Title)
    end
    
    Config.WindUI = WindUI
    Config.Parent = WindUI.ScreenGui.Window
    
    if WindUI.Window then
        warn("You cannot create more than one window")
        return
    end
    
    local CanLoadWindow = true
    
    local Theme = Themes[Config.Theme or "Dark"]
    
    WindUI.Theme = Theme
    
    Creator.SetTheme(Theme)
    
    local Filename = LocalPlayer.Name or "Unknown"
    
    if Config.KeySystem then
        CanLoadWindow = false
        if Config.KeySystem.SaveKey and Config.Folder then
            if isfile(Config.Folder .. "/" .. Filename .. ".key") then
                local isKey = tostring(Config.KeySystem.Key) == tostring(readfile(Config.Folder .. "/" .. Filename .. ".key" ))
                if type(Config.KeySystem.Key) == "table" then
                    isKey = table.find(Config.KeySystem.Key, readfile(Config.Folder .. "/" .. Filename .. ".key" ))
                end
                if isKey then
                    CanLoadWindow = true
                end
            else
                KeySystem.new(Config, Filename, function(c) CanLoadWindow=c end)
            end
        else
            KeySystem.new(Config, Filename, function(c) CanLoadWindow=c end)
        end
		repeat task.wait() until CanLoadWindow
    end
    
    local Window = CreateWindow(Config)

    WindUI.Transparent = Config.Transparent
    WindUI.Window = Window
    
    
    function Window:ToggleTransparency(Value)
        WindUI.Transparent = Value
        WindUI.Window.Transparent = Value
        
        Window.UIElements.Main.Background.BackgroundTransparency = Value and WindUI.TransparencyValue or 0
        Window.UIElements.Main.Background.ImageLabel.ImageTransparency = Value and WindUI.TransparencyValue or 0
        Window.UIElements.Main.Gradient.UIGradient.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 1), 
            NumberSequenceKeypoint.new(1, Value and 0.85 or 0.7),
        }
    end
    
    return Window
end

return WindUI
