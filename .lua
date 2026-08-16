--v0.14

if getgenv().PulseLib and getgenv().PulseLib.Unload then
    getgenv().PulseLib:Unload()
end

local Library = { } do
    local cloneref = cloneref or function(Object)
        return Object
    end

    local Players = cloneref(game:GetService("Players"))
    local UserInputService = cloneref(game:GetService("UserInputService"))
    local RunService = cloneref(game:GetService("RunService"))
    local TweenService = cloneref(game:GetService("TweenService"))
    local HttpService = cloneref(game:GetService("HttpService"))
    local GuiService = cloneref(game:GetService("GuiService"))
    local TextService = cloneref(game:GetService("TextService"))
    local StatsService = cloneref(game:GetService("Stats"))
    local MarketplaceService = cloneref(game:GetService("MarketplaceService"))
    local ContentProvider = cloneref(game:GetService("ContentProvider"))
    local AssetService = cloneref(game:GetService("AssetService"))

    local LocalPlayer = Players.LocalPlayer
    local GuiInset = GuiService:GetGuiInset().Y
    local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

    local GetHui = gethui or function()
        return cloneref(game:GetService("CoreGui"))
    end

    Library.Directory = "PulseLib"
    Library.ConfigFolder = "PulseLib/Configs"
    Library.AssetsFolder = "PulseLib/Assets"
    Library.LegacyDirectory = "Zolar"

    if isfolder then
        for _, Folder in { Library.Directory, Library.ConfigFolder, Library.AssetsFolder } do
            if not isfolder(Folder) then
                makefolder(Folder)
            end
        end
    end

    pcall(function()
        if not (isfolder and listfiles and isfile and readfile and writefile) then return end

        local LegacyConfigs = Library.LegacyDirectory .. "/Configs"
        if not isfolder(LegacyConfigs) then return end

        for _, File in listfiles(LegacyConfigs) do
            if string.sub(File, -5) == ".json" then
                local Name = string.match(File, "([^/\\\\]+)%.json$")

                if Name then
                    local Target = Library.ConfigFolder .. "/" .. Name .. ".json"

                    if not isfile(Target) then
                        writefile(Target, readfile(File))
                    end
                end
            end
        end
    end)

    Library.LogoData = "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"

    do
        local Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        local Values = { }

        for Index = 1, 64 do
            Values[string.byte(Alphabet, Index)] = Index - 1
        end

        local function PureDecode(Data)
            Data = string.gsub(Data, "[^A-Za-z0-9+/=]", "")

            local Out, Count = { }, 0

            for Index = 1, #Data, 4 do
                local c1, c2, c3, c4 = string.byte(Data, Index, Index + 3)

                local Pad3 = c3 == 61 or c3 == nil
                local Pad4 = c4 == 61 or c4 == nil

                local Packed = (Values[c1] or 0) * 262144
                    + (Values[c2] or 0) * 4096
                    + ((not Pad3 and Values[c3]) or 0) * 64
                    + ((not Pad4 and Values[c4]) or 0)

                local b1 = math.floor(Packed / 65536) % 256
                local b2 = math.floor(Packed / 256) % 256
                local b3 = Packed % 256

                Count += 1

                if Pad3 then
                    Out[Count] = string.char(b1)
                elseif Pad4 then
                    Out[Count] = string.char(b1, b2)
                else
                    Out[Count] = string.char(b1, b2, b3)
                end
            end

            return table.concat(Out)
        end

        local Decode = PureDecode

        if type(crypt) == "table" then
            local Native = crypt.base64decode
                or (type(crypt.base64) == "table" and crypt.base64.decode)

            if type(Native) == "function" then
                Decode = function(Data)
                    local Ok, Result = pcall(Native, Data)
                    return (Ok and type(Result) == "string" and #Result > 0 and Result) or PureDecode(Data)
                end
            end
        end

        local function Fingerprint(Data)
            local Hash = 5381

            for Index = 1, #Data, 17 do
                Hash = (Hash * 33 + string.byte(Data, Index)) % 4294967296
            end

            return string.format("%x", Hash) .. tostring(#Data)
        end

        local function BuildLogo()
            if type(writefile) ~= "function" or type(getcustomasset) ~= "function" then
                return nil
            end

            local Path = Library.AssetsFolder .. "/Logo" .. Fingerprint(Library.LogoData) .. ".png"

            if type(isfile) == "function" and isfile(Path) then
                local Ok, Body = pcall(readfile, Path)

                if not (Ok and string.sub(Body, 2, 4) == "PNG") then
                    pcall(delfile, Path)
                end
            end

            if not (type(isfile) == "function" and isfile(Path)) then
                local Ok = pcall(writefile, Path, Decode(Library.LogoData))
                if not Ok then return nil end
            end

            local Ok, Asset = pcall(getcustomasset, Path)
            return (Ok and Asset) or nil
        end

        local Ok, Result = pcall(BuildLogo)
        Library.Logo = (Ok and Result) or nil
    end

    local UiFont
    local UiFontBold

    local CustomFont = { } do
        local FontMagics = {
            "\0\1\0\0",
            "OTTO",
            "true",
            "ttcf",
            "wOFF"
        }

        local function LooksLikeFont(Body)
            if type(Body) ~= "string" or #Body < 4096 then
                return false
            end

            local Head = string.sub(Body, 1, 4)

            for _, Magic in FontMagics do
                if Head == Magic then
                    return true
                end
            end

            return false
        end

        function CustomFont:New(Name, Weight, Style, Data)
            local JsonPath = Library.AssetsFolder .. "/" .. Name .. ".json"
            local FontPath = Library.AssetsFolder .. "/" .. Name .. ".ttf"

            if isfile(FontPath) and not LooksLikeFont(readfile(FontPath)) then
                pcall(delfile, FontPath)
            end

            if not isfile(FontPath) then
                local Body = game:HttpGet(Data.Url)

                if not LooksLikeFont(Body) then
                    return nil
                end

                writefile(FontPath, Body)
            end

            local FontData = {
                name = Name,
                faces = {
                    {
                        name = "Regular",
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(FontPath)
                    }
                }
            }

            writefile(JsonPath, HttpService:JSONEncode(FontData))

            local Asset = getcustomasset(JsonPath)
            return Font.new(Asset, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        end

        local MainOk, MainFont = pcall(function()
            return CustomFont:New("Inter", 400, "normal", {
                Url = "https://github.com/Da7mu/font/raw/refs/heads/main/Inter%20Medium%20500.ttf"
            })
        end)

        if not MainOk then warn(MainFont) end

        UiFont = (MainOk and MainFont) or Font.fromEnum(Enum.Font.GothamMedium)
        UiFontBold = UiFont
    end

    Library.Font = UiFont
    Library.TitleFont = UiFontBold

    local PackRoot = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/"

    Library.IconPacks = {
        lucide    = PackRoot .. "lucide/dist/Icons.lua",
        gravity   = PackRoot .. "gravity/dist/Icons.lua",
        solar     = PackRoot .. "solar/dist/Icons.lua",
        sfsymbols = PackRoot .. "sfsymbols/dist/Icons.lua",
        craft     = PackRoot .. "craft/dist/Icons.lua",
        geist     = PackRoot .. "geist/dist/Icons.lua",
        hero      = PackRoot .. "hero/dist/Icons.lua",
        gmi       = PackRoot .. "GoogleMaterialIcons/dist/Icons.lua"
    }

    Library.IconPack = "lucide"

    local LoadedPacks = { }
    local LegacyPack

    local function GetPack(Name)
        local Cached = LoadedPacks[Name]

        if Cached ~= nil then
            return Cached or nil
        end

        local Url = Library.IconPacks[Name]

        if not Url then
            LoadedPacks[Name] = false
            return nil
        end

        local Ok, Result = pcall(function()
            return loadstring(game:HttpGet(Url))()
        end)

        LoadedPacks[Name] = (Ok and type(Result) == "table" and Result) or false
        return LoadedPacks[Name] or nil
    end

    Library.GetIconPack = function(Self, Name)
        return GetPack(Name or Library.IconPack)
    end

    pcall(GetPack, "lucide")

    local function ResolveIcon(Icon)
        if type(Icon) == "number" then
            return "rbxassetid://" .. Icon
        end

        if type(Icon) ~= "string" then
            return "rbxassetid://0"
        end

        if string.find(Icon, "://", 1, true) then
            return Icon
        end

        if string.match(Icon, "^%d+$") then
            return "rbxassetid://" .. Icon
        end

        local PackName, Key = string.match(Icon, "^(%w+):(.+)$")

        if PackName and Library.IconPacks[PackName] then
            local Pack = GetPack(PackName)
            local Found = Pack and Pack[Key]

            if Found then
                return Found
            end

            Icon = Key
        end

        local Base = GetPack(Library.IconPack)

        if Base and Base[Icon] then
            return Base[Icon]
        end

        if LegacyPack == nil then
            local Ok, Result = pcall(function()
                local Loaded = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
                Loaded.SetIconsType("lucide")
                return Loaded
            end)

            LegacyPack = (Ok and Result) or false
        end

        if LegacyPack then
            local Ok, Result = pcall(function()
                return LegacyPack.GetIcon(Icon)
            end)

            if Ok and Result and Result ~= "rbxassetid://0" then
                return Result
            end
        end

        return "rbxassetid://0"
    end

    local function ToVector2(Value)
        if typeof(Value) == "Vector2" then
            return Value
        end

        if type(Value) == "table" then
            return Vector2.new(Value[1] or Value.X or 0, Value[2] or Value.Y or 0)
        end

        return Vector2.new(0, 0)
    end

    local function ApplyIcon(Object, Icon)
        if not Icon then return end

        local Image, Offset, Size = ResolveIcon(Icon)

        Object.Image = Image
        Object.ImageRectOffset = ToVector2(Offset)
        Object.ImageRectSize = ToVector2(Size)
    end

    local MeasureParams

    local function MeasureText(Text, Size, Width, FontFace)
        Text = tostring(Text or "")
        Size = tonumber(Size) or 15
        Width = tonumber(Width) or 0

        if not MeasureParams then
            local Ok, Made = pcall(function()
                return Instance.new("GetTextBoundsParams")
            end)

            MeasureParams = (Ok and Made) or false
        end

        if MeasureParams then
            local Ok, Bounds = pcall(function()
                MeasureParams.Text = Text
                MeasureParams.Font = FontFace or UiFont
                MeasureParams.Size = Size
                MeasureParams.Width = Width

                return TextService:GetTextBoundsAsync(MeasureParams)
            end)

            if Ok and typeof(Bounds) == "Vector2" then
                return Bounds
            end
        end

        local Estimate = Width > 0 and math.min(#Text * Size * 0.52, Width) or (#Text * Size * 0.52)
        return Vector2.new(Estimate, Size * 1.25)
    end

    Library.__index = Library
    Library.Version = "1.1"
    Library.WindowWidth = 716
    Library.WindowHeight = 540

    Library.Theme = {
        Background = Color3.fromRGB(20, 22, 26),
        Section = Color3.fromRGB(23, 26, 30),
        Element = Color3.fromRGB(27, 31, 35),
        Light = Color3.fromRGB(34, 39, 44),
        Hover = Color3.fromRGB(38, 43, 49),
        Line = Color3.fromRGB(27, 31, 35),
        Text = Color3.fromRGB(255, 255, 255),
        DimText = Color3.fromRGB(120, 120, 120),
        DimIcon = Color3.fromRGB(120, 120, 120),
        Accent = Color3.fromRGB(179, 165, 255)
    }

    Library.AccentPresets = {
        Color3.fromRGB(179, 165, 255),
        Color3.fromRGB(120, 132, 255),
        Color3.fromRGB(96, 170, 255),
        Color3.fromRGB(72, 214, 168),
        Color3.fromRGB(245, 130, 120)
    }

    local function MakePreset(Name, Colors)
        local Preset = {
            Name = Name,
            Swatch = Colors.Accent
        }

        for Key, Value in Colors do
            Preset[Key] = Value
        end

        return Preset
    end

    Library.ThemePresets = {
        MakePreset("Default", Library.Theme),
        MakePreset("Azure", {
            Background = Color3.fromRGB(16, 20, 30),
            Section = Color3.fromRGB(20, 25, 37),
            Element = Color3.fromRGB(25, 31, 46),
            Light = Color3.fromRGB(33, 41, 60),
            Hover = Color3.fromRGB(39, 48, 70),
            Line = Color3.fromRGB(25, 31, 46),
            Text = Color3.fromRGB(233, 239, 250),
            DimText = Color3.fromRGB(110, 120, 142),
            DimIcon = Color3.fromRGB(110, 120, 142),
            Accent = Color3.fromRGB(96, 150, 255)
        }),
        MakePreset("Emerald", {
            Background = Color3.fromRGB(14, 24, 20),
            Section = Color3.fromRGB(18, 30, 25),
            Element = Color3.fromRGB(23, 37, 31),
            Light = Color3.fromRGB(30, 48, 40),
            Hover = Color3.fromRGB(36, 56, 47),
            Line = Color3.fromRGB(23, 37, 31),
            Text = Color3.fromRGB(232, 244, 238),
            DimText = Color3.fromRGB(106, 128, 118),
            DimIcon = Color3.fromRGB(106, 128, 118),
            Accent = Color3.fromRGB(76, 214, 148)
        }),
        MakePreset("Ocean", {
            Background = Color3.fromRGB(14, 23, 28),
            Section = Color3.fromRGB(18, 28, 34),
            Element = Color3.fromRGB(23, 35, 42),
            Light = Color3.fromRGB(30, 45, 54),
            Hover = Color3.fromRGB(36, 53, 63),
            Line = Color3.fromRGB(23, 35, 42),
            Text = Color3.fromRGB(230, 240, 244),
            DimText = Color3.fromRGB(104, 122, 132),
            DimIcon = Color3.fromRGB(104, 122, 132),
            Accent = Color3.fromRGB(72, 200, 214)
        }),
        MakePreset("Rose", {
            Background = Color3.fromRGB(26, 17, 21),
            Section = Color3.fromRGB(32, 21, 26),
            Element = Color3.fromRGB(39, 26, 32),
            Light = Color3.fromRGB(50, 33, 41),
            Hover = Color3.fromRGB(58, 39, 48),
            Line = Color3.fromRGB(39, 26, 32),
            Text = Color3.fromRGB(245, 234, 238),
            DimText = Color3.fromRGB(132, 110, 118),
            DimIcon = Color3.fromRGB(132, 110, 118),
            Accent = Color3.fromRGB(240, 118, 150)
        })
    }

    Library.ThemeKeys = {
        "Background",
        "Section",
        "Element",
        "Light",
        "Line",
        "Text",
        "DimText"
    }

    local function DeriveTheme()
        local T = Library.Theme

        T.AccentDark = T.Accent:Lerp(Color3.new(0, 0, 0), 0.44)
        T.AccentDeep = T.Accent:Lerp(Color3.new(0, 0, 0), 0.24)
        T.Ripple = T.Accent:Lerp(Color3.new(1, 1, 1), 0.12)
        T.AccentSoft = T.Accent:Lerp(T.Background, 0.72)
    end

    DeriveTheme()

    Library.Flags = { }
    Library.SetFlags = { }
    Library.Connections = { }
    Library.Threads = { }
    Library.ThemingStuff = { }
    Library.ThemeMap = { }
    Library.AccentGradients = { }
    Library.AccentShadows = { }
    Library.OpenFrames = { }
    Library.Windows = { }
    Library.Notifs = { }
    Library.TouchButtons = { }
    Library.TouchShields = { }
    Library.Searchables = { }
    Library.MenuKeybind = Enum.KeyCode.G
    Library.Binding = false
    Library.UserScale = 1
    Library.Silent = false
    Library.ThemeDirty = false
    Library.PreloadDirty = false
    Library.PreloadClock = 0
    Library.Preloaded = setmetatable({ }, { __mode = "k" })
    Library.Animation = {
        Time = 0.25,
        Style = Enum.EasingStyle.Quart,
        Direction = Enum.EasingDirection.Out
    }

    Library.Create = function(Self, Class, Properties)
        local Data = {
            Class = Class,
            Instance = Instance.new(Class)
        }

        for Property, Value in Properties do
            if Property == "Name" then
                Data.Instance.Name = "\0"
                continue
            end

            Data.Instance[Property] = Value
        end

        if Class == "ImageLabel" or Class == "ImageButton" then
            Library.PreloadDirty = true
        end

        if Library.SeedBaseline then
            Library:SeedBaseline(Data.Instance)
        end

        return setmetatable(Data, Library)
    end

    Library.PreloadAll = function(Self)
        local Roots = {
            Library.Holder,
            Library.PopupHolder,
            Library.UnusedHolder
        }

        local Assets = { }

        for _, Root in Roots do
            if not Root or not Root.Instance then continue end

            for _, Child in Root.Instance:GetDescendants() do
                if Library.Preloaded[Child] then continue end
                if not Child:IsA("ImageLabel") and not Child:IsA("ImageButton") then continue end
                if Child.Image == "" then continue end

                Library.Preloaded[Child] = true
                table.insert(Assets, Child)
            end
        end

        if #Assets == 0 then return end

        Library:Thread(function()
            pcall(function()
                ContentProvider:PreloadAsync(Assets)
            end)
        end)
    end

    Library.Connect = function(Self, Signal, Callback)
        local Connection

        if type(Signal) == "string" and Self.Instance then
            local IsClick = Signal == "MouseButton1Down" or Signal == "MouseButton1Click"

            if IsMobile and IsClick and Self.Instance:IsA("GuiButton") then
                local LastFire = 0

                local function Fire(Input)
                    local Now = os.clock()
                    if Now - LastFire < 0.25 then return end
                    LastFire = Now
                    Callback(Input)
                end

                table.insert(Library.TouchButtons, {
                    Instance = Self.Instance,
                    Fire = Fire
                })

                Connection = Self.Instance.Activated:Connect(function(Input)
                    Fire(Input)
                end)
            else
                Connection = Self.Instance[Signal]:Connect(Callback)
            end
        else
            Connection = Signal:Connect(Callback)
        end

        table.insert(Library.Connections, Connection)
        return Connection
    end

    Library.Thread = function(Self, Function)
        local NewThread = coroutine.create(Function)
        coroutine.resume(NewThread)
        table.insert(Library.Threads, NewThread)
        return NewThread
    end

    Library.SafeCall = function(Self, Function, ...)
        if type(Function) ~= "function" then return end

        local Success, Result = pcall(Function, ...)
        if not Success then warn(Result) end

        return Success, Result
    end

    Library.Round = function(Self, Number, Float)
        if type(Number) ~= "number" or Number ~= Number then
            Number = 0
        end

        if type(Float) ~= "number" or Float ~= Float or Float <= 0 or Float == math.huge then
            Float = 1
        end

        local Result = math.floor(Number / Float + 0.5) * Float
        local Places = 0

        if Float < 1 then
            Places = math.clamp(math.ceil(-math.log(Float, 10)), 0, 10)
        end

        return tonumber(string.format("%." .. Places .. "f", Result)) or Result
    end

    Library.Tween = function(Self, Properties, Info, RawItem)
        local Object = RawItem or Self.Instance

        Info = Info or TweenInfo.new(
            Library.Animation.Time,
            Library.Animation.Style,
            Library.Animation.Direction
        )

        local NewTween = TweenService:Create(Object, Info, Properties)
        NewTween:Play()

        return NewTween
    end

    Library.GetTweenProperty = function(Self, RawItem)
        local Object = RawItem or Self.Instance

        if Object:IsA("TextLabel") or Object:IsA("TextButton") or Object:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Object:IsA("ViewportFrame") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Object:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Object:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Object:IsA("UIStroke") then
            return { "Transparency" }
        elseif Object.ClassName == "UIShadow" then
            return { "Transparency" }
        end
    end

    Library.RestingValues = setmetatable({ }, { __mode = "k" })
    Library.Baselines = setmetatable({ }, { __mode = "k" })
    Library.FadeTokens = setmetatable({ }, { __mode = "k" })

    local function BumpFadeToken(Root)
        local Next = (Library.FadeTokens[Root] or 0) + 1
        Library.FadeTokens[Root] = Next
        return Next
    end

    local function CollectFadeable(Root)
        local Children = { Root }
        local Count = 1
        local Queue = { Root }
        local Head = 1
        local Tail = 1

        while Head <= Tail do
            local Node = Queue[Head]
            Head += 1

            for _, Child in Node:GetChildren() do
                Count += 1
                Children[Count] = Child

                if not Child:IsA("ViewportFrame") then
                    Tail += 1
                    Queue[Tail] = Child
                end
            end
        end

        return Children
    end

    local function ForEachFadeable(Children, Handler)
        for _, Child in Children do
            local Properties = Library:GetTweenProperty(Child)
            if not Properties then continue end

            for _, Property in Properties do
                Handler(Child, Property)
            end
        end
    end

    local function RestoreResting(Children)
        ForEachFadeable(Children, function(Child, Property)
            local Resting = Library:ReleaseResting(Child, Property)

            if Resting ~= nil then
                Child[Property] = Resting
            end
        end)
    end

    Library.SetBaseline = function(Self, Object, Property, Value)
        local Store = Library.Baselines[Object]

        if not Store then
            Store = { }
            Library.Baselines[Object] = Store
        end

        Store[Property] = Value
    end

    Library.SeedBaseline = function(Self, Object)
        local Properties = Library:GetTweenProperty(Object)
        if not Properties then return end

        for _, Property in Properties do
            local Store = Library.Baselines[Object]

            if not Store or Store[Property] == nil then
                Library:SetBaseline(Object, Property, Object[Property])
            end
        end
    end

    Library.CaptureResting = function(Self, Object, Property)
        local Store = Library.RestingValues[Object]

        if not Store then
            Store = { }
            Library.RestingValues[Object] = Store
        end

        if Store[Property] == nil then
            local Base = Library.Baselines[Object]
            local Known = Base and Base[Property]

            Store[Property] = Known ~= nil and Known or Object[Property]

            if Known == nil then
                Library:SetBaseline(Object, Property, Store[Property])
            end
        end

        return Store[Property]
    end

    Library.ReleaseResting = function(Self, Object, Property)
        local Store = Library.RestingValues[Object]
        if not Store then return nil end

        local Value = Store[Property]
        Store[Property] = nil

        return Value
    end

    Library.StampResting = function(Self, Object, Property, Value)
        local Store = Library.RestingValues[Object]

        if not Store then
            Store = { }
            Library.RestingValues[Object] = Store
        end

        Store[Property] = Value
        Library:SetBaseline(Object, Property, Value)
    end

    Library.HardRestore = function(Self)
        local Root = Self.Instance
        BumpFadeToken(Root)

        ForEachFadeable(CollectFadeable(Root), function(Child, Property)
            local Base = Library.Baselines[Child]
            if not Base then return end

            Library:ReleaseResting(Child, Property)

            if Base[Property] ~= nil then
                pcall(function()
                    Child[Property] = Base[Property]
                end)
            end
        end)
    end

    Library.Fade = function(Self, Property, Visibility, RawItem)
        local Object = RawItem or Self.Instance
        local Resting = Library:CaptureResting(Object, Property)
        local Target = Visibility and Resting or 1

        if Visibility then
            Object[Property] = 1
        end

        local Ok = pcall(function()
            Library:Tween({ [Property] = Target }, nil, Object)
        end)

        if not Ok then
            pcall(function()
                Object[Property] = Target
            end)
        end
    end

    Library.FadeDescendants = function(Self, Visibility, Callback)
        local Root = Self.Instance
        local Token = BumpFadeToken(Root)

        if Visibility then
            Root.Visible = true
        end

        local Children = CollectFadeable(Root)

        ForEachFadeable(Children, function(Child, Property)
            Library:Fade(Property, Visibility, Child)
        end)

        task.delay(Library.Animation.Time + 0.03, function()
            if Library.FadeTokens[Root] == Token then
                Root.Visible = Visibility
                RestoreResting(Children)
            end

            if Callback then Callback() end
        end)
    end

    Library.CancelFade = function(Self)
        BumpFadeToken(Self.Instance)
    end

    Library.ResetFade = function(Self)
        local Root = Self.Instance
        BumpFadeToken(Root)
        RestoreResting(CollectFadeable(Root))
    end

    Library.AddToTheme = function(Self, Properties)
        local Object = Self.Instance

        local ThemeData = {
            Item = Object,
            Properties = Properties
        }

        for Property, Value in Properties do
            if type(Value) == "string" then
                Object[Property] = Library.Theme[Value]
            else
                Object[Property] = Value()
            end
        end

        table.insert(Library.ThemingStuff, ThemeData)
        Library.ThemeMap[Object] = ThemeData

        return Self
    end

    Library.ChangeItemTheme = function(Self, Properties)
        local Object = Self.Instance
        if not Library.ThemeMap[Object] then return end
        Library.ThemeMap[Object].Properties = Properties
    end

    local function AccentSequence()
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.Theme.Accent),
            ColorSequenceKeypoint.new(1, Library.Theme.AccentDark)
        })
    end

    Library.RegisterGradient = function(Self, Gradient)
        Gradient.Color = AccentSequence()
        table.insert(Library.AccentGradients, Gradient)
    end

    Library.ApplyThemeInstant = function(Self)
        for _, Item in Library.ThemingStuff do
            for Property, Value in Item.Properties do
                if type(Value) == "string" then
                    Item.Item[Property] = Library.Theme[Value]
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end

        for _, Gradient in Library.AccentGradients do
            Gradient.Color = AccentSequence()
        end

        for _, Shadow in Library.AccentShadows do
            pcall(function()
                Shadow.Color = Library.Theme.Accent
            end)
        end
    end

    Library.SetAccent = function(Self, Color)
        Library.Theme.Accent = Color
        DeriveTheme()
        Library.ThemeDirty = true
    end

    Library.SetThemeColor = function(Self, Key, Color)
        Library.Theme[Key] = Color
        DeriveTheme()
        Library.ThemeDirty = true
    end

    Library.SetTheme = function(Self, Preset)
        if type(Preset) == "string" then
            for _, Entry in Library.ThemePresets do
                if Entry.Name == Preset then
                    Preset = Entry
                    break
                end
            end
        end

        if type(Preset) ~= "table" then return end

        for Key, Value in Preset do
            if Key ~= "Name" and Key ~= "Swatch" and typeof(Value) == "Color3" then
                Library.Theme[Key] = Value
            end
        end

        DeriveTheme()
        Library.ThemeDirty = true
    end

    Library.OnHover = function(Self, OnEnter, OnLeave)
        Library:Connect(Self.Instance.MouseEnter, OnEnter)
        Library:Connect(Self.Instance.MouseLeave, OnLeave)
    end

    Library.GetScreenScale = function(Self)
        if Library.UIScale and Library.UIScale.Instance then
            return Library.UIScale.Instance.Scale
        end

        return 1
    end

    local function IsOverObject(Object)
        local Position = UserInputService:GetMouseLocation() - Vector2.new(0, GuiInset)
        local Corner = Object.AbsolutePosition
        local Size = Object.AbsoluteSize

        return Position.X >= Corner.X
        and Position.X <= Corner.X + Size.X
        and Position.Y >= Corner.Y
        and Position.Y <= Corner.Y + Size.Y
    end

    Library.IsMouseOverFrame = function(Self)
        return IsOverObject(Self.Instance)
    end

    local function IsOverAnyPopup()
        for Panel in Library.TouchShields do
            if not Panel.Parent then continue end
            if not Panel.Visible then continue end
            if IsOverObject(Panel) then return true end
        end

        return false
    end

    Library.MakeDraggable = function(Self, Handle)
        local Gui = Self.Instance
        Handle = Handle or Gui
        Handle.Active = true

        local Dragging = false
        local DragStart
        local StartPosition
        local InputChanged

        local function Set(Input)
            local Scale = Library:GetScreenScale()
            local DragDelta = (Input.Position - DragStart) / Scale
            local NewX = StartPosition.X + DragDelta.X
            local NewY = StartPosition.Y + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize / Scale
            local GuiSize = Gui.AbsoluteSize / Scale
            local Anchor = Gui.AnchorPoint

            NewX = math.clamp(NewX, GuiSize.X * Anchor.X, ScreenSize.X - GuiSize.X * (1 - Anchor.X))
            NewY = math.clamp(NewY, GuiSize.Y * Anchor.Y, ScreenSize.Y - GuiSize.Y * (1 - Anchor.Y))

            local Info = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            Self:Tween({ Position = UDim2.fromOffset(NewX, NewY) }, Info)
        end

        Library:Connect(Handle.InputBegan, function(Input)
            local IsClick = Input.UserInputType == Enum.UserInputType.MouseButton1
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if not IsClick and not IsTouch then return end
            if IsOverAnyPopup() then return end

            Dragging = true
            DragStart = Input.Position

            local Scale = Library:GetScreenScale()
            local ParentSize = Gui.Parent.AbsoluteSize / Scale

            StartPosition = Vector2.new(
                Gui.Position.X.Scale * ParentSize.X + Gui.Position.X.Offset,
                Gui.Position.Y.Scale * ParentSize.Y + Gui.Position.Y.Offset
            )

            if InputChanged then return end

            InputChanged = Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                    InputChanged:Disconnect()
                    InputChanged = nil
                end
            end)
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            local IsMove = Input.UserInputType == Enum.UserInputType.MouseMovement
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if (IsMove or IsTouch) and Dragging then
                Set(Input)
            end
        end)
    end

    Library.Unload = function(Self)
        for _, Connection in Library.Connections do
            pcall(function()
                Connection:Disconnect()
            end)
        end

        for _, Thread in Library.Threads do
            pcall(coroutine.close, Thread)
        end

        for _, Root in { Library.Holder, Library.PopupHolder, Library.UnusedHolder } do
            if Root then Root.Instance:Destroy() end
        end

        getgenv().PulseLib = nil
    end

    Library.Holder = Library:Create("ScreenGui", {
        Parent = GetHui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 1000
    })

    Library.PopupHolder = Library:Create("ScreenGui", {
        Parent = GetHui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 1001
    })

    Library.UnusedHolder = Library:Create("ScreenGui", {
        Parent = GetHui(),
        Name = "\0",
        Enabled = false,
        ResetOnSpawn = false
    })

    do
        local Probe = Library:Create("Frame", {
            Parent = Library.Holder.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.fromOffset(1, 1),
            BorderSizePixel = 0
        })

        task.defer(function()
            GuiInset = -Probe.Instance.AbsolutePosition.Y
            Probe.Instance:Destroy()
        end)
    end

    Library.UIScale = Library:Create("UIScale", {
        Parent = Library.Holder.Instance,
        Scale = 1
    })

    Library.PopupScale = Library:Create("UIScale", {
        Parent = Library.PopupHolder.Instance,
        Scale = 1
    })

    local function Corner(Object, Radius)
        Library:Create("UICorner", {
            Parent = Object,
            CornerRadius = UDim.new(0, Radius)
        })
    end

    local function SetRest(Object, Property, Value)
        Object[Property] = Value
        Library:StampResting(Object, Property, Value)
    end

    local function MakeFrame(Params)
        local Frame = Library:Create("Frame", {
            Parent = Params.Parent,
            Name = "\0",
            Position = Params.Pos or UDim2.fromOffset(0, 0),
            Size = Params.Size or UDim2.fromOffset(0, 0),
            AnchorPoint = Params.Anchor or Vector2.new(0, 0),
            BackgroundTransparency = Params.Color and 0 or 1,
            ZIndex = Params.Z or 1,
            ClipsDescendants = Params.Clip or false,
            BorderSizePixel = 0,
            BackgroundColor3 = Params.Color and Library.Theme[Params.Color] or Color3.new(1, 1, 1)
        })

        if Params.Color then
            Frame:AddToTheme({ BackgroundColor3 = Params.Color })
        end

        if Params.Raw then
            Frame.Instance.BackgroundColor3 = Params.Raw
            Frame.Instance.BackgroundTransparency = Params.Alpha or 0
            Library:SetBaseline(Frame.Instance, "BackgroundTransparency", Params.Alpha or 0)
        end

        if Params.Round then
            Corner(Frame.Instance, Params.Round)
        end

        return Frame
    end

    local function MakeText(Params)
        return Library:Create("TextLabel", {
            Parent = Params.Parent,
            Name = "\0",
            FontFace = Params.Bold and UiFontBold or UiFont,
            Text = Params.Text or "",
            TextSize = Params.TextSize or 15,
            TextColor3 = Library.Theme[Params.Color or "Text"],
            BackgroundTransparency = 1,
            Position = Params.Pos or UDim2.fromOffset(0, 0),
            Size = Params.Size or UDim2.fromOffset(0, 0),
            AnchorPoint = Params.Anchor or Vector2.new(0, 0),
            TextXAlignment = Params.Align or Enum.TextXAlignment.Left,
            TextTruncate = Params.Truncate and Enum.TextTruncate.AtEnd or Enum.TextTruncate.None,
            TextWrapped = Params.Wrap or false,
            ZIndex = Params.Z or 1,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = Params.Color or "Text" })
    end

    local function MakeImage(Params)
        local Raw = Params.Raw

        local Image = Library:Create("ImageLabel", {
            Parent = Params.Parent,
            Name = "\0",
            BackgroundTransparency = 1,
            ImageColor3 = Raw or Library.Theme[Params.Color or "DimIcon"],
            Position = Params.Pos or UDim2.fromOffset(0, 0),
            Size = Params.Size or UDim2.fromOffset(16, 16),
            AnchorPoint = Params.Anchor or Vector2.new(0, 0),
            ScaleType = Params.Fit and Enum.ScaleType.Fit or Enum.ScaleType.Stretch,
            ZIndex = Params.Z or 1,
            BorderSizePixel = 0
        })

        if not Raw then
            Image:AddToTheme({ ImageColor3 = Params.Color or "DimIcon" })
        end

        ApplyIcon(Image.Instance, Params.Icon)
        return Image
    end

    local function MakeButton(Params)
        return Library:Create("TextButton", {
            Parent = Params.Parent,
            Name = "\0",
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Position = Params.Pos or UDim2.fromOffset(0, 0),
            Size = Params.Size or UDim2.new(1, 0, 1, 0),
            AnchorPoint = Params.Anchor or Vector2.new(0, 0),
            ZIndex = Params.Z or 5,
            BorderSizePixel = 0
        })
    end

    local function MakeInput(Params)
        local Input = Library:Create("TextBox", {
            Parent = Params.Parent,
            Name = "\0",
            FontFace = UiFont,
            TextColor3 = Library.Theme.Text,
            PlaceholderColor3 = Library.Theme.DimText,
            PlaceholderText = Params.Placeholder or "",
            Text = Params.Text or "",
            TextSize = Params.TextSize or 15,
            ClearTextOnFocus = false,
            CursorPosition = -1,
            BackgroundTransparency = 1,
            Position = Params.Pos or UDim2.fromOffset(0, 0),
            Size = Params.Size or UDim2.new(1, 0, 1, 0),
            TextXAlignment = Params.Align or Enum.TextXAlignment.Left,
            ZIndex = Params.Z or 6,
            BorderSizePixel = 0
        }):AddToTheme({
            TextColor3 = "Text",
            PlaceholderColor3 = "DimText"
        })

        if IsMobile then
            local Focus = MakeButton({
                Parent = Params.Parent,
                Pos = Params.Pos,
                Size = Params.Size or UDim2.new(1, 0, 1, 0),
                Z = (Params.Z or 6) + 2
            })

            Focus:Connect("MouseButton1Down", function()
                Input.Instance:CaptureFocus()
            end)
        end

        return Input
    end

    local function MakeShadow(Parent, Color, Spread, Blur, Transparency)
        local Ok, Shadow = pcall(function()
            local S = Instance.new("UIShadow")
            S.Name = "\0"
            S.Color = Color
            S.Spread = Spread
            S.BlurRadius = Blur
            S.Transparency = Transparency
            S.Parent = Parent
            return S
        end)

        if Ok and Shadow then
            Library:SetBaseline(Shadow, "Transparency", Transparency)
            return Shadow
        end

        return nil
    end

    local function MakeAccentShadow(Parent, Spread, Blur, Transparency)
        local Shadow = MakeShadow(Parent, Library.Theme.Accent, Spread, Blur, Transparency)

        if Shadow then
            table.insert(Library.AccentShadows, Shadow)
        end

        return Shadow
    end

    Library.DimCount = 0
    Library.Dims = { }

    for Index = 1, 3 do
        local Dim = Library:Create("Frame", {
            Parent = Library.UnusedHolder.Instance,
            Name = "\0",
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = Index == 3 and 28 or 15,
            BorderSizePixel = 0
        })

        Corner(Dim.Instance, 10)
        Library.Dims[Index] = Dim
    end

    Library.Dim = Library.Dims[1]

    Library.SetDim = function(Self, Bool)
        Library.DimCount = math.max(0, Library.DimCount + (Bool and 1 or -1))

        local Window = Library.Windows[1]
        if not Window then return end

        local Info = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local Shown = Library.DimCount > 0
        local Target = Shown and 0.55 or 1

        local Hosts = {
            Window.Items.Main.Instance,
            Window.Items.Rail.Instance,
            Window.Items.SubBar.Instance
        }

        for Index, Dim in Library.Dims do
            Library:StampResting(Dim.Instance, "BackgroundTransparency", Target)

            if Shown then
                Dim.Instance.Parent = Hosts[Index]
                Dim.Instance.Visible = true
            end

            Library:Tween({ BackgroundTransparency = Target }, Info, Dim.Instance)
        end

        if Shown then return end

        task.delay(0.28, function()
            if Library.DimCount > 0 then return end

            for _, Dim in Library.Dims do
                Dim.Instance.Visible = false
                Dim.Instance.Parent = Library.UnusedHolder.Instance
            end
        end)
    end

    Library.CloseAllPopups = function(Self)
        for _, Value in Library.OpenFrames do
            if Value.SetOpen then Value:SetOpen(false) end
        end
    end

    local function UpdateScale()
        local Scale = Library.UserScale

        if IsMobile and workspace.CurrentCamera then
            local Viewport = workspace.CurrentCamera.ViewportSize
            local FitX = (Viewport.X * 0.94) / Library.WindowWidth
            local FitY = (Viewport.Y * 0.9) / Library.WindowHeight
            Scale = Scale * math.clamp(math.min(FitX, FitY), 0.3, 1)
        end

        local Old = Library.UIScale.Instance.Scale
        local Centers = { }

        for Index, Window in Library.Windows do
            local Root = Window.Items and Window.Items.Root
            if not Root then continue end

            local Pos = Root.Instance.Position
            local Size = Root.Instance.Size

            Centers[Index] = Vector2.new(
                (Pos.X.Offset + Size.X.Offset / 2) * Old,
                (Pos.Y.Offset + Size.Y.Offset / 2) * Old
            )
        end

        Library.UIScale.Instance.Scale = Scale
        Library.PopupScale.Instance.Scale = Scale

        if IsMobile then
            for _, Window in Library.Windows do
                if Window.Center then Window:Center() end
            end

            return
        end

        local Viewport = workspace.CurrentCamera.ViewportSize

        for Index, Window in Library.Windows do
            local Root = Window.Items and Window.Items.Root
            local Center = Centers[Index]

            if not Root or not Center then continue end

            local Size = Root.Instance.Size
            local HalfX = Size.X.Offset / 2
            local HalfY = Size.Y.Offset / 2
            local LimitX = Viewport.X / Scale
            local LimitY = Viewport.Y / Scale

            local NewX = math.clamp(Center.X / Scale - HalfX, 0, math.max(LimitX - HalfX * 2, 0))
            local NewY = math.clamp(Center.Y / Scale - HalfY, 0, math.max(LimitY - HalfY * 2, 0))

            Root.Instance.Position = UDim2.fromOffset(NewX, NewY)
        end
    end

    Library.SetUIScale = function(Self, Multiplier)
        Library.UserScale = Multiplier
        Library:CloseAllPopups()
        UpdateScale()
    end

    UpdateScale()

    Library:Connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), function()
        task.wait()
        UpdateScale()
    end)

    local function PointInside(Position, Object)
        local Corner = Object.AbsolutePosition
        local Size = Object.AbsoluteSize

        return Position.X >= Corner.X
        and Position.X <= Corner.X + Size.X
        and Position.Y >= Corner.Y
        and Position.Y <= Corner.Y + Size.Y
    end

    do
        local TouchStart

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.Touch then
                TouchStart = Input.Position
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if not IsMobile then return end
            if Input.UserInputType ~= Enum.UserInputType.Touch then return end
            if not TouchStart then return end

            local Delta = Input.Position - TouchStart
            if math.abs(Delta.X) > 12 or math.abs(Delta.Y) > 12 then return end

            local Position = Input.Position
            local ShieldLevel = 0

            for Panel, Level in Library.TouchShields do
                local Live = Panel:IsDescendantOf(Library.Holder.Instance)
                or Panel:IsDescendantOf(Library.PopupHolder.Instance)

                if Live and PointInside(Position, Panel) then
                    ShieldLevel = math.max(ShieldLevel, Level)
                end
            end

            local Best

            for _, Data in Library.TouchButtons do
                local Object = Data.Instance
                if not Object or not Object.Visible then continue end
                if not PointInside(Position, Object) then continue end
                if Object.ZIndex < ShieldLevel then continue end

                if not Best or Object.ZIndex >= Best.Instance.ZIndex then
                    Best = Data
                end
            end

            if Best then Best.Fire(Input) end
        end)
    end

    local function AxisFraction(Input, Object, Axis)
        local Base = Object.AbsolutePosition[Axis]
        local Span = Object.AbsoluteSize[Axis]

        if Span == 0 then return 0 end

        return math.clamp((Input.Position[Axis] - Base) / Span, 0, 1)
    end

    local function AttachDrag(Hit, Handlers)
        local Watcher
        local Active = false

        Hit:Connect("InputBegan", function(Input)
            local IsClick = Input.UserInputType == Enum.UserInputType.MouseButton1
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if not IsClick and not IsTouch then return end

            Active = true
            Handlers.OnGrab(Input)

            if Watcher then return end

            Watcher = Input.Changed:Connect(function()
                if Input.UserInputState ~= Enum.UserInputState.End then return end

                Active = false

                if Handlers.OnRelease then Handlers.OnRelease() end

                Watcher:Disconnect()
                Watcher = nil
            end)
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            local IsMove = Input.UserInputType == Enum.UserInputType.MouseMovement
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if (IsMove or IsTouch) and Active then
                Handlers.OnMove(Input)
            end
        end)
    end

    local function PlaceBelow(GetAnchor)
        return function(Extra)
            local Anchor = GetAnchor()
            local Scale = Library:GetScreenScale()
            local X = Anchor.AbsolutePosition.X / Scale
            local Y = Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + GuiInset

            return UDim2.fromOffset(X, Y / Scale + (Extra or 0))
        end
    end

    local function PlaceBeside(GetAnchor)
        return function(Extra)
            local Anchor = GetAnchor()
            local Scale = Library:GetScreenScale()
            local Right = Anchor.AbsolutePosition.X + Anchor.AbsoluteSize.X
            local X = Right / Scale + 8
            local Y = (Anchor.AbsolutePosition.Y + GuiInset) / Scale

            return UDim2.fromOffset(X, Y + (Extra or 0))
        end
    end

    local function RetreatUp(Current)
        return UDim2.fromOffset(Current.X.Offset, Current.Y.Offset - 8)
    end

    local function RetreatLeft(Current)
        return UDim2.fromOffset(Current.X.Offset - 8, Current.Y.Offset)
    end

    local function AttachPopup(Config)
        local Popup = Config.Popup
        local Frame = Config.Frame
        local Level = Config.Level
        local Place = Config.Place
        local GetAnchor = Config.GetAnchor
        local From = Config.From or -6
        local To = Config.To or 6
        local Retreat = Config.Retreat or RetreatUp

        local KeepOpen = Config.KeepOpen or function(Value)
            return Value == Popup or Value == Popup.Host
        end

        function Popup:SetOpen(Bool)
            if Popup.Debounce then return end
            if Popup.IsOpen == Bool then return end

            Popup.IsOpen = Bool
            Popup.Debounce = true

            if Popup.OnState then Popup.OnState(Bool) end

            if Popup.Host and Popup.Host.SetChildDim then
                Popup.Host.SetChildDim(Bool)
            end

            if Bool then
                if Config.OnOpen then Config.OnOpen() end

                Frame.Instance.Parent = Library.PopupHolder.Instance
                Frame.Instance.Position = Place(From)
                Frame.Instance.Visible = true
                Library.TouchShields[Frame.Instance] = Level
                Library:SetDim(true)
                Frame:Tween({ Position = Place(To) })

                for _, Value in Library.OpenFrames do
                    if not KeepOpen(Value) then
                        Value:SetOpen(false)
                    end
                end

                Library.OpenFrames[Popup] = Popup

                Frame:FadeDescendants(true, function()
                    Popup.Debounce = false
                end)
            else
                if Config.OnClose then Config.OnClose() end

                Library.OpenFrames[Popup] = nil
                Library:SetDim(false)
                Frame:Tween({ Position = Retreat(Frame.Instance.Position) })

                Frame:FadeDescendants(false, function()
                    Popup.Debounce = false
                    if Popup.IsOpen then return end
                    Library.TouchShields[Frame.Instance] = nil
                    Frame.Instance.Parent = Library.UnusedHolder.Instance
                end)
            end
        end

        Library:Connect(UserInputService.InputBegan, function(Input)
            local IsClick = Input.UserInputType == Enum.UserInputType.MouseButton1
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if not IsClick and not IsTouch then return end
            if not Popup.IsOpen then return end
            if Config.HoldOpen and Config.HoldOpen() then return end
            if Frame:IsMouseOverFrame() then return end
            if IsOverObject(GetAnchor()) then return end

            Popup:SetOpen(false)
        end)

        return Popup
    end

    local function MakeAccentRow(Params)
        local Z = Params.Z

        local Row = MakeFrame({
            Parent = Params.Parent,
            Pos = Params.Pos,
            Size = Params.Size,
            Color = Params.Color or "Section",
            Round = 5,
            Z = Z
        })

        SetRest(Row.Instance, "BackgroundTransparency", 1)

        local Line = MakeFrame({
            Parent = Row.Instance,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, Params.LineX, 0.5, 0),
            Size = UDim2.fromOffset(3, 0),
            Color = "Accent",
            Round = 4,
            Z = Z + 1
        })

        local Shadow = MakeAccentShadow(
            Line.Instance,
            UDim2.fromOffset(3, 15),
            UDim.new(0, 10),
            0
        )

        if Shadow then
            SetRest(Shadow, "Transparency", 1)
        end

        local Label = MakeText({
            Parent = Row.Instance,
            Text = Params.Text,
            TextSize = Params.TextSize,
            Pos = UDim2.fromOffset(Params.TextX, 0),
            Size = Params.LabelSize,
            Color = "DimText",
            Truncate = true,
            Z = Z + 1
        })

        local Hit = MakeButton({
            Parent = Row.Instance,
            Z = Z + 2
        })

        local function SetActive(Active, Instant)
            Library:StampResting(Row.Instance, "BackgroundTransparency", Active and 0 or 1)
            Label:ChangeItemTheme({ TextColor3 = Active and "Text" or "DimText" })

            local Info = Instant and TweenInfo.new(0) or nil
            local Color = Active and Library.Theme.Text or Library.Theme.DimText
            local TextX = Active and Params.TextActiveX or Params.TextX

            Library:Tween({ BackgroundTransparency = Active and 0 or 1 }, Info, Row.Instance)
            Library:Tween({ Size = UDim2.fromOffset(3, Active and Params.LineH or 0) }, Info, Line.Instance)
            Library:Tween({
                TextColor3 = Color,
                Position = UDim2.fromOffset(TextX, 0)
            }, Info, Label.Instance)

            if not Shadow then return end

            Library:StampResting(Shadow, "Transparency", Active and 0 or 1)

            if Params.SnapShadow or Instant then
                Shadow.Transparency = Active and 0 or 1
            else
                Library:Tween({ Transparency = Active and 0 or 1 }, Info, Shadow)
            end
        end

        return {
            Row = Row,
            Line = Line,
            Label = Label,
            Hit = Hit,
            Shadow = Shadow,
            SetActive = SetActive
        }
    end

    local function MakeOptionPopup(GetAnchor, Level, WidthOverride)
        Level = Level or 40

        local Popup = {
            IsOpen = false,
            Debounce = false,
            Order = { },
            Host = nil,
            OnPick = function() end
        }

        local Items = { }
        local RowHeight = 30
        local SearchHeight = 30

        Items.Frame = MakeFrame({
            Parent = Library.UnusedHolder.Instance,
            Size = UDim2.fromOffset(150, 0),
            Color = "Element",
            Round = 6,
            Clip = true,
            Z = Level
        })

        Items.Frame.Instance.Visible = false

        Items.SearchHolder = MakeFrame({
            Parent = Items.Frame.Instance,
            Size = UDim2.new(1, 0, 0, SearchHeight),
            Color = "Element",
            Z = Level + 5
        })

        Items.SearchHolder.Instance.Visible = false

        MakeImage({
            Parent = Items.SearchHolder.Instance,
            Icon = "search",
            Pos = UDim2.fromOffset(9, (SearchHeight - 13) / 2),
            Size = UDim2.fromOffset(13, 13),
            Color = "DimText",
            Z = Level + 7
        })

        Items.Search = MakeInput({
            Parent = Items.SearchHolder.Instance,
            Placeholder = "Search...",
            Pos = UDim2.fromOffset(27, 0),
            Size = UDim2.new(1, -32, 1, 0),
            TextSize = 14,
            Z = Level + 6
        })

        MakeFrame({
            Parent = Items.SearchHolder.Instance,
            Pos = UDim2.new(0, 6, 1, -1),
            Size = UDim2.new(1, -12, 0, 1),
            Color = "Line",
            Z = Level + 6
        })

        Items.Scroll = Library:Create("ScrollingFrame", {
            Parent = Items.Frame.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            ScrollBarImageTransparency = 1,
            Selectable = false,
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.fromOffset(0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = Level + 4,
            BorderSizePixel = 0
        })

        Library:Create("UIListLayout", {
            Parent = Items.Scroll.Instance,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 3)
        })

        Library:Create("UIPadding", {
            Parent = Items.Scroll.Instance,
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4)
        })

        Popup.Items = Items

        local function ApplySearch(Query)
            Query = string.lower(Query)

            for _, Data in Popup.Order do
                local Match = Query == ""
                or string.find(string.lower(Data.Name), Query, 1, true) ~= nil

                Data.Row.Instance.Visible = Match
            end
        end

        Library:Connect(Items.Search.Instance:GetPropertyChangedSignal("Text"), function()
            ApplySearch(Items.Search.Instance.Text)
        end)

        function Popup:AddRow(Text)
            local Built = MakeAccentRow({
                Parent = Items.Scroll.Instance,
                Size = UDim2.new(1, -4, 0, RowHeight - 4),
                Text = Text,
                TextSize = 14,
                LabelSize = UDim2.new(1, -20, 1, 0),
                LineX = 8,
                LineH = 16,
                TextX = 11,
                TextActiveX = 20,
                Z = Level + 1
            })

            local Data = {
                Name = Text,
                Selected = false,
                Row = Built.Row
            }

            function Data:Set(Active, Instant)
                Data.Selected = Active
                Built.SetActive(Active, Instant)
            end

            Built.Row:OnHover(function()
                if Data.Selected then return end
                Library:Tween({ BackgroundTransparency = 0.7 }, nil, Built.Row.Instance)
            end, function()
                if Data.Selected then return end
                Library:Tween({ BackgroundTransparency = 1 }, nil, Built.Row.Instance)
            end)

            Built.Hit:Connect("MouseButton1Down", function()
                Popup.OnPick(Data)
            end)

            table.insert(Popup.Order, Data)
            return Data
        end

        function Popup:Clear()
            for _, Data in Popup.Order do
                Data.Row.Instance:Destroy()
            end

            Popup.Order = { }
        end

        return AttachPopup({
            Popup = Popup,
            Frame = Items.Frame,
            Level = Level,
            GetAnchor = GetAnchor,
            Place = PlaceBelow(GetAnchor),
            OnOpen = function()
                local Anchor = GetAnchor()
                local Scale = Library:GetScreenScale()
                local ShowSearch = #Popup.Order > 8
                local Width = WidthOverride or (Anchor.AbsoluteSize.X / Scale)
                local ListHeight = math.min(#Popup.Order * RowHeight + 8, 168)

                Items.Search.Instance.Text = ""
                ApplySearch("")

                Items.SearchHolder.Instance.Visible = ShowSearch

                if ShowSearch then
                    Items.Scroll.Instance.Position = UDim2.fromOffset(0, SearchHeight)
                    Items.Scroll.Instance.Size = UDim2.new(1, 0, 1, -SearchHeight)
                    Items.Frame.Instance.Size = UDim2.fromOffset(Width, ListHeight + SearchHeight)
                else
                    Items.Scroll.Instance.Position = UDim2.fromOffset(0, 0)
                    Items.Scroll.Instance.Size = UDim2.new(1, 0, 1, 0)
                    Items.Frame.Instance.Size = UDim2.fromOffset(Width, ListHeight)
                end
            end,
            OnClose = function()
                Items.Search.Instance.Text = ""
            end
        })
    end

    local function MakeSwatch(Parent, RightOffset, Default, Z)
        local Swatch = { }
        local Base = Z or 3

        Swatch.Halo = MakeFrame({
            Parent = Parent,
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, RightOffset, 0.5, 0),
            Size = UDim2.fromOffset(22, 22),
            Round = 20,
            Z = Base
        })

        Swatch.Halo.Instance.BackgroundColor3 = Default
        SetRest(Swatch.Halo.Instance, "BackgroundTransparency", 0.72)

        Swatch.Core = MakeFrame({
            Parent = Swatch.Halo.Instance,
            Anchor = Vector2.new(0.5, 0.5),
            Pos = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.fromOffset(12, 12),
            Raw = Default,
            Round = 20,
            Z = Base + 1
        })

        Swatch.Shadow = MakeShadow(
            Swatch.Core.Instance,
            Default,
            UDim2.fromOffset(0, 0),
            UDim.new(0, 6),
            0.35
        )

        Swatch.Hit = MakeButton({
            Parent = Swatch.Halo.Instance,
            Z = Base + 2
        })

        function Swatch:SetColor(Color, Alpha)
            Alpha = Alpha or 0

            Library:StampResting(Swatch.Core.Instance, "BackgroundTransparency", Alpha)
            Library:StampResting(Swatch.Halo.Instance, "BackgroundTransparency", 0.72)

            Swatch.Halo:Tween({ BackgroundColor3 = Color })
            Swatch.Core:Tween({
                BackgroundColor3 = Color,
                BackgroundTransparency = Alpha
            })

            if Swatch.Shadow then
                pcall(function()
                    Swatch.Shadow.Color = Color
                end)
            end
        end

        return Swatch
    end

    local function MakeColorPopup(GetAnchor, Title, Default, DefaultAlpha, OnChanged)
        local Picker = {
            Hue = 0,
            Saturation = 0,
            Value = 1,
            Transparency = DefaultAlpha or 0,
            Color = Color3.new(1, 1, 1),
            IsOpen = false,
            Debounce = false
        }

        local Items = { }
        local Level = 120
        local Field = 150
        local PanelW = Field + 32
        local CursorSize = 14
        local CursorThickness = 2

        Items.Window = MakeFrame({
            Parent = Library.UnusedHolder.Instance,
            Size = UDim2.fromOffset(PanelW, Field + 110),
            Color = "Section",
            Round = 8,
            Z = Level
        })

        Items.Window.Instance.Visible = false

        Items.Field = Library:Create("ImageButton", {
            Parent = Items.Window.Instance,
            Name = "\0",
            AutoButtonColor = false,
            BackgroundColor3 = Color3.fromRGB(255, 0, 0),
            Position = UDim2.fromOffset(16, 16),
            Size = UDim2.fromOffset(Field, Field),
            ZIndex = Level + 1,
            BorderSizePixel = 0
        })

        Corner(Items.Field.Instance, 8)

        Items.Tint = MakeFrame({
            Parent = Items.Field.Instance,
            Size = UDim2.new(1, 0, 1, 0),
            Raw = Color3.new(1, 1, 1),
            Round = 8,
            Z = Level + 2
        })

        Library:Create("UIGradient", {
            Parent = Items.Tint.Instance,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
        })

        Items.Shade = MakeFrame({
            Parent = Items.Field.Instance,
            Size = UDim2.new(1, 0, 1, 0),
            Raw = Color3.new(0, 0, 0),
            Round = 8,
            Z = Level + 3
        })

        Library:Create("UIGradient", {
            Parent = Items.Shade.Instance,
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0)
            })
        })

        local function MakeCursor(Parent, Pos, Z)
            local Cursor = MakeFrame({
                Parent = Parent,
                Anchor = Vector2.new(0.5, 0.5),
                Pos = Pos,
                Size = UDim2.fromOffset(CursorSize, CursorSize),
                Raw = Color3.new(1, 1, 1),
                Alpha = 1,
                Round = 20,
                Z = Z
            })

            Library:Create("UIStroke", {
                Parent = Cursor.Instance,
                Color = Color3.new(1, 1, 1),
                Thickness = CursorThickness
            })

            return Cursor
        end

        Items.FieldCursor = MakeCursor(
            Items.Field.Instance,
            UDim2.new(0.5, 0, 0.5, 0),
            Level + 4
        )

        local function MakeBar(Y)
            local Bar = Library:Create("ImageButton", {
                Parent = Items.Window.Instance,
                Name = "\0",
                AutoButtonColor = false,
                Position = UDim2.fromOffset(16, Y),
                Size = UDim2.fromOffset(Field, 10),
                ZIndex = Level + 1,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.new(1, 1, 1)
            })

            Corner(Bar.Instance, 5)

            local Cursor = MakeCursor(
                Bar.Instance,
                UDim2.new(1, 0, 0.5, 0),
                Level + 3
            )

            return Bar, Cursor
        end

        Items.HueBar, Items.HueCursor = MakeBar(Field + 30)

        Library:Create("UIGradient", {
            Parent = Items.HueBar.Instance,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })
        })

        Items.AlphaBar, Items.AlphaCursor = MakeBar(Field + 50)

        local AlphaGradient = Library:Create("UIGradient", {
            Parent = Items.AlphaBar.Instance,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
        })

        Items.Hex = MakeFrame({
            Parent = Items.Window.Instance,
            Pos = UDim2.fromOffset(16, Field + 72),
            Size = UDim2.fromOffset(Field, 26),
            Color = "Element",
            Round = 5,
            Clip = true,
            Z = Level + 1
        })

        Items.HexInput = MakeInput({
            Parent = Items.Hex.Instance,
            Text = "#FFFFFF",
            Placeholder = "#FFFFFF",
            Pos = UDim2.fromOffset(9, 0),
            Size = UDim2.new(1, -18, 1, 0),
            TextSize = 14,
            Z = Level + 2
        })

        local Grabbing = nil
        local SlideInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        local function Refresh(Instant)
            Picker.Color = Color3.fromHSV(Picker.Hue, Picker.Saturation, Picker.Value)

            local Pure = Color3.fromHSV(Picker.Hue, 1, 1)
            local Info = Instant and TweenInfo.new(0) or SlideInfo

            AlphaGradient.Instance.Color = ColorSequence.new(Picker.Color)
            Library:Tween({ BackgroundColor3 = Pure }, Info, Items.Field.Instance)

            Library:Tween({
                Position = UDim2.new(Picker.Saturation, 0, 1 - Picker.Value, 0)
            }, Info, Items.FieldCursor.Instance)

            Library:Tween({ Position = UDim2.new(Picker.Hue, 0, 0.5, 0) }, Info, Items.HueCursor.Instance)
            Library:Tween({ Position = UDim2.new(Picker.Transparency, 0, 0.5, 0) }, Info, Items.AlphaCursor.Instance)

            if not Items.HexInput.Instance:IsFocused() then
                Items.HexInput.Instance.Text = "#" .. string.upper(Picker.Color:ToHex())
            end

            Library:SafeCall(OnChanged, Picker.Color, Picker.Transparency)
        end

        function Picker:Set(Color, Alpha, Silent)
            if type(Color) == "table" then
                Color = Color3.fromRGB(Color[1], Color[2], Color[3])
            end

            if type(Color) == "string" then
                Color = Color3.fromHex(Color)
            end

            Picker.Hue, Picker.Saturation, Picker.Value = Color:ToHSV()
            Picker.Transparency = Alpha or Picker.Transparency or 0

            if Silent then
                Picker.Color = Color3.fromHSV(Picker.Hue, Picker.Saturation, Picker.Value)
                return
            end

            Refresh(true)
        end

        local function Slide(Input)
            if Grabbing == "Field" then
                Picker.Saturation = AxisFraction(Input, Items.Field.Instance, "X")
                Picker.Value = 1 - AxisFraction(Input, Items.Field.Instance, "Y")
            elseif Grabbing == "Hue" then
                Picker.Hue = AxisFraction(Input, Items.HueBar.Instance, "X")
            elseif Grabbing == "Alpha" then
                Picker.Transparency = AxisFraction(Input, Items.AlphaBar.Instance, "X")
            else
                return
            end

            Refresh()
        end

        local function Grabber(Object, Mode)
            local Watcher

            Library:Connect(Object.InputBegan, function(Input)
                local IsClick = Input.UserInputType == Enum.UserInputType.MouseButton1
                local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

                if not IsClick and not IsTouch then return end

                Grabbing = Mode
                Slide(Input)

                if Watcher then return end

                Watcher = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        if Grabbing == Mode then Grabbing = nil end
                        Watcher:Disconnect()
                        Watcher = nil
                    end
                end)
            end)
        end

        Grabber(Items.Field.Instance, "Field")
        Grabber(Items.HueBar.Instance, "Hue")
        Grabber(Items.AlphaBar.Instance, "Alpha")

        Library:Connect(UserInputService.InputChanged, function(Input)
            local IsMove = Input.UserInputType == Enum.UserInputType.MouseMovement
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if (IsMove or IsTouch) and Grabbing then
                Slide(Input)
            end
        end)

        Items.HexInput:Connect("FocusLost", function()
            local Text = string.gsub(Items.HexInput.Instance.Text, "#", "")

            local Ok, Color = pcall(function()
                return Color3.fromHex(Text)
            end)

            if Ok and Color then
                Picker:Set(Color, Picker.Transparency)
            else
                Refresh(true)
            end
        end)

        AttachPopup({
            Popup = Picker,
            Frame = Items.Window,
            Level = Level,
            GetAnchor = GetAnchor,
            Place = PlaceBeside(GetAnchor)
        })

        Picker:Set(Default or Library.Theme.Accent, Picker.Transparency)
        return Picker
    end

    local function PulseNotifyReopen(Window)
        if Library.Silent or Library.ReopenHintShown then return end

        Library.ReopenHintShown = true

        local Key = Library.MenuKeybind
        local KeyText = (typeof(Key) == "EnumItem" and Key.Name) or tostring(Key)
        local Where = Library.WatermarkBar and "Click the watermark or press " or "Press "

        Library:Notification({
            Name = "Menu hidden",
            Description = Where .. KeyText .. " to bring it back.",
            Icon = "eye-off",
            Duration = 6
        })
    end

    local function KeyName(Key)
        if not Key then return "None" end

        local Text = tostring(Key)
        Text = string.gsub(Text, "Enum.KeyCode.", "")
        Text = string.gsub(Text, "Enum.UserInputType.", "")

        return Text
    end

    local function ParseKey(Value)
        if type(Value) ~= "string" or Value == "None" then
            return nil
        end

        local Name = string.gsub(Value, "Enum.KeyCode.", "")
        Name = string.gsub(Name, "Enum.UserInputType.", "")

        local Ok, Key = pcall(function()
            return Enum.KeyCode[Name]
        end)

        if Ok and Key then return Key end

        return nil
    end

    local function CaptureKey(State, Display, OnPicked)
        if State.Picking then return end

        State.Picking = true
        Library.Binding = true
        Display.Text = ". . ."

        task.wait()

        local Connection

        Connection = UserInputService.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then return end

            Connection:Disconnect()

            local IsBack = Input.KeyCode == Enum.KeyCode.Backspace
            local IsEsc = Input.KeyCode == Enum.KeyCode.Escape

            if IsBack or IsEsc then
                OnPicked(nil)
            elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                OnPicked(Input.KeyCode)
            else
                OnPicked(Input.UserInputType)
            end

            task.defer(function()
                Library.Binding = false
            end)
        end)
    end

    local function KeyMatches(Input, Key)
        return Input.KeyCode == Key or Input.UserInputType == Key
    end

    Library.Notification = function(Self, Params)
        if Library.Silent then return end

        Params = Params or { }

        local Title = Params.Name or Params.Title or "Notification"
        local Content = Params.Description or Params.Content or ""
        local Icon = Params.Icon or "bell"
        local Accent = Params.Color or Library.Theme.Accent
        local Duration = Params.Duration or 5

        local CardW = 300
        local Bounds = Vector2.new(0, 0)

        if Content ~= "" then
            Bounds = MeasureText(Content, 14, CardW - 26, UiFont)
        end

        local CardH = 38 + (Content ~= "" and Bounds.Y + 6 or 0) + 18
        local Items = { }

        Items.Frame = MakeFrame({
            Parent = Library.Holder.Instance,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, 340, 0, 15),
            Size = UDim2.fromOffset(CardW, CardH),
            Color = "Section",
            Round = 10,
            Z = 80
        })

        Items.Icon = MakeImage({
            Parent = Items.Frame.Instance,
            Icon = Icon,
            Pos = UDim2.fromOffset(13, 11),
            Size = UDim2.fromOffset(18, 18),
            Raw = Accent,
            Z = 81
        })

        Items.Title = MakeText({
            Parent = Items.Frame.Instance,
            Text = Title,
            TextSize = 15,
            Pos = UDim2.fromOffset(40, 10),
            Size = UDim2.new(1, -70, 0, 20),
            Color = "Text",
            Truncate = true,
            Z = 81
        })

        Items.Close = MakeImage({
            Parent = Items.Frame.Instance,
            Icon = "x",
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, -13, 0, 13),
            Size = UDim2.fromOffset(14, 14),
            Color = "DimText",
            Z = 82
        })

        Items.CloseHit = MakeButton({
            Parent = Items.Frame.Instance,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, -8, 0, 8),
            Size = UDim2.fromOffset(24, 24),
            Z = 83
        })

        if Content ~= "" then
            Items.Body = MakeText({
                Parent = Items.Frame.Instance,
                Text = Content,
                TextSize = 14,
                Pos = UDim2.fromOffset(13, 35),
                Size = UDim2.new(1, -26, 0, Bounds.Y),
                Color = "DimText",
                Wrap = true,
                Z = 81
            })

            Items.Body.Instance.TextYAlignment = Enum.TextYAlignment.Top
        end

        Items.BarBack = MakeFrame({
            Parent = Items.Frame.Instance,
            Pos = UDim2.new(0, 13, 1, -12),
            Size = UDim2.new(1, -26, 0, 5),
            Color = "Element",
            Round = 4,
            Z = 81
        })

        Items.BarFill = MakeFrame({
            Parent = Items.BarBack.Instance,
            Size = UDim2.new(1, 0, 1, 0),
            Raw = Color3.new(1, 1, 1),
            Round = 4,
            Z = 82
        })

        Library:RegisterGradient(Library:Create("UIGradient", {
            Parent = Items.BarFill.Instance
        }).Instance)

        local Notif = {
            Items = Items,
            Dead = false,
            Height = CardH
        }

        table.insert(Library.Notifs, Notif)

        local function StackHeight(Stop)
            local Y = 15

            for _, Value in Library.Notifs do
                if Value == Stop then break end
                if Value.Dead then continue end

                Y += Value.Height + 10
            end

            return Y
        end

        local function Reflow()
            local Info = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local Y = 15

            for _, Value in Library.Notifs do
                if Value.Dead then continue end

                Library:Tween({ Position = UDim2.new(1, -15, 0, Y) }, Info, Value.Items.Frame.Instance)
                Y += Value.Height + 10
            end
        end

        local StartY = StackHeight(Notif)
        local SlideIn = TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

        Items.Frame.Instance.Position = UDim2.new(1, 340, 0, StartY)
        Items.Frame:Tween({ Position = UDim2.new(1, -15, 0, StartY) }, SlideIn)

        local function Dismiss()
            if Notif.Dead then return end
            Notif.Dead = true

            local Fade = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local Current = Items.Frame.Instance.Position
            local Lift = UDim2.new(1, -15, 0, Current.Y.Offset - 14)

            Library:Tween({ Position = Lift }, Fade, Items.Frame.Instance)
            Items.Frame:FadeDescendants(false)

            task.delay(0.3, function()
                local Index = table.find(Library.Notifs, Notif)
                if Index then table.remove(Library.Notifs, Index) end

                Items.Frame.Instance:Destroy()
                Reflow()
            end)
        end

        Items.CloseHit:Connect("MouseButton1Down", Dismiss)

        local Countdown = TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        Library:Tween({ Size = UDim2.new(0, 0, 1, 0) }, Countdown, Items.BarFill.Instance)

        task.delay(Duration, Dismiss)
    end

    Library.Window = function(Self, Params)
        Params = Params or { }

        local W = Library.WindowWidth
        local H = Library.WindowHeight
        local TopH = 51
        local Gap = 10
        local RailW = 60
        local RailH = 340
        local SubW = 260
        local SubH = 50
        local MainX = RailW + Gap
        local RailY = math.floor((H - RailH) / 2)
        local SubX = MainX + math.floor((W - SubW) / 2)
        local SubY = H - math.floor(SubH / 2)
        local RootW = MainX + W
        local RootH = SubY + SubH
        local ColW = math.floor((W - 46) / 2)
        local Col2X = ColW + 16
        local SubCenterX = MainX + math.floor(W / 2)
        local MaxSubW = W - 120

        local function Recompute()
            SubY = H - math.floor(SubH / 2)
            RootW = MainX + W
            RootH = SubY + SubH
            ColW = math.floor((W - 46) / 2)
            Col2X = ColW + 16
            SubCenterX = MainX + math.floor(W / 2)
            MaxSubW = W - 120
        end

        local Window = {
            Name = Params.Name or "PULSE",
            Icon = Params.Icon or Library.Logo or "layers",
            IsOpen = true,
            Tabs = { },
            Current = nil,
            ContentW = W - 30,
            ContentH = H - 96,
            ColW = ColW,
            Col2X = Col2X,
            Items = { }
        }

        if Params.Accent then
            Library:SetAccent(Params.Accent)
        end

        local Items = { }
        local Viewport = workspace.CurrentCamera.ViewportSize
        local Scale = Library:GetScreenScale()

        Items.Root = MakeFrame({
            Parent = Library.Holder.Instance,
            Pos = UDim2.fromOffset(
                Viewport.X / (2 * Scale) - RootW / 2,
                Viewport.Y / (2 * Scale) - RootH / 2
            ),
            Size = UDim2.fromOffset(RootW, RootH),
            Z = 1
        })

        Items.Main = MakeFrame({
            Parent = Items.Root.Instance,
            Pos = UDim2.fromOffset(MainX, 0),
            Size = UDim2.fromOffset(W, H),
            Color = "Background",
            Round = 10,
            Clip = true,
            Z = 1
        })

        Items.Rail = MakeFrame({
            Parent = Items.Root.Instance,
            Pos = UDim2.fromOffset(0, RailY),
            Size = UDim2.fromOffset(RailW, RailH),
            Color = "Section",
            Round = 10,
            Z = 1
        })

        Items.SubBar = MakeFrame({
            Parent = Items.Root.Instance,
            Pos = UDim2.fromOffset(SubX, SubY),
            Size = UDim2.fromOffset(SubW, SubH),
            Color = "Section",
            Round = 10,
            Clip = true,
            Z = 20
        })

        Items.TopBar = MakeFrame({
            Parent = Items.Main.Instance,
            Size = UDim2.new(1, 0, 0, TopH),
            Color = "Section",
            Round = 10,
            Z = 2
        })

        MakeFrame({
            Parent = Items.TopBar.Instance,
            Pos = UDim2.fromOffset(0, TopH - 12),
            Size = UDim2.new(1, 0, 0, 12),
            Color = "Section",
            Z = 2
        })

        Items.TopLine = MakeFrame({
            Parent = Items.Main.Instance,
            Pos = UDim2.fromOffset(0, 50),
            Size = UDim2.new(1, 0, 0, 1),
            Color = "Element",
            Z = 3
        })

        Items.HubIcon = MakeImage({
            Parent = Items.TopBar.Instance,
            Icon = Window.Icon,
            Pos = UDim2.fromOffset(10, 10),
            Size = UDim2.fromOffset(30, 30),
            Raw = Color3.new(1, 1, 1),
            Fit = true,
            Z = 3
        })

        local SearchW = 280
        local SearchClosedW = 30

        Items.Search = MakeFrame({
            Parent = Items.TopBar.Instance,
            Pos = UDim2.fromOffset(50, 10),
            Size = UDim2.fromOffset(SearchClosedW, 30),
            Color = "Element",
            Round = 5,
            Clip = true,
            Z = 3
        })

        Items.SearchIcon = MakeImage({
            Parent = Items.Search.Instance,
            Icon = "search",
            Pos = UDim2.fromOffset(7, 7),
            Size = UDim2.fromOffset(16, 16),
            Color = "DimText",
            Z = 4
        })

        Items.SearchBox = MakeInput({
            Parent = Items.Search.Instance,
            Placeholder = "search",
            Pos = UDim2.fromOffset(30, -1),
            Size = UDim2.new(1, -38, 1, 0),
            TextSize = 15,
            Z = 4
        })

        SetRest(Items.SearchBox.Instance, "TextTransparency", 1)

        Items.SearchHit = MakeButton({
            Parent = Items.Search.Instance,
            Size = UDim2.fromOffset(SearchClosedW, 30),
            Z = 7
        })

        Items.Username = MakeText({
            Parent = Items.TopBar.Instance,
            Text = LocalPlayer.DisplayName,
            TextSize = 15,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, -90, 0, 8),
            Size = UDim2.fromOffset(240, 18),
            Color = "Text",
            Align = Enum.TextXAlignment.Right,
            Truncate = true,
            Z = 3
        })

        Items.Version = MakeFrame({
            Parent = Items.TopBar.Instance,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, -90, 0, 29),
            Size = UDim2.fromOffset(36, 14),
            Color = "Background",
            Round = 3,
            Z = 3
        })

        Library:Create("UIStroke", {
            Parent = Items.Version.Instance,
            Color = Library.Theme.Element,
            Thickness = 1
        }):AddToTheme({ Color = "Element" })

        MakeText({
            Parent = Items.Version.Instance,
            Text = "v" .. Library.Version,
            TextSize = 12,
            Size = UDim2.new(1, 0, 1, 0),
            Color = "DimText",
            Align = Enum.TextXAlignment.Center,
            Z = 4
        })

        local function MakeAvatar(Parent, Props)
            local Avatar = Library:Create("ImageLabel", {
                Parent = Parent,
                Name = "\0",
                AnchorPoint = Props.Anchor or Vector2.new(0, 0),
                Position = Props.Pos,
                Size = UDim2.fromOffset(Props.Size, Props.Size),
                BackgroundColor3 = Library.Theme.Element,
                ZIndex = Props.Z,
                BorderSizePixel = 0,
                Image = "rbxthumb://type=AvatarHeadShot&id="
                .. LocalPlayer.UserId
                .. "&w=" .. Props.Res .. "&h=" .. Props.Res
            }):AddToTheme({ BackgroundColor3 = "Element" })

            Corner(Avatar.Instance, Props.Round)
            return Avatar
        end

        Items.Avatar = MakeAvatar(Items.TopBar.Instance, {
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -44, 0.5, 0),
            Size = 30,
            Res = 60,
            Round = 20,
            Z = 3
        })

        Items.ProfileHit = MakeButton({
            Parent = Items.TopBar.Instance,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, -38, 0, 8),
            Size = UDim2.fromOffset(42, 36),
            Z = 5
        })

        Items.WindowClose = MakeImage({
            Parent = Items.TopBar.Instance,
            Icon = "x",
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(16, 16),
            Color = "DimText",
            Z = 3
        })

        Items.WindowCloseHit = MakeButton({
            Parent = Items.TopBar.Instance,
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -8, 0.5, 0),
            Size = UDim2.fromOffset(28, 28),
            Z = 5
        })

        Items.WindowCloseHit:OnHover(function()
            Items.WindowClose:Tween({ ImageColor3 = Library.Theme.Text })
        end, function()
            Items.WindowClose:Tween({ ImageColor3 = Library.Theme.DimText })
        end)

        Items.WindowCloseHit:Connect("MouseButton1Down", function()
            Window:SetOpen(false)

            PulseNotifyReopen(Window)
        end)

        local Profile = {
            IsOpen = false,
            Debounce = false
        }

        local ProfileW = 240

        local ProfilePanel = MakeFrame({
            Parent = Library.UnusedHolder.Instance,
            Size = UDim2.fromOffset(ProfileW, 272),
            Color = "Section",
            Round = 10,
            Z = 45
        })

        ProfilePanel.Instance.Visible = false

        MakeAvatar(ProfilePanel.Instance, {
            Pos = UDim2.fromOffset(14, 14),
            Size = 42,
            Res = 100,
            Round = 21,
            Z = 46
        })

        MakeText({
            Parent = ProfilePanel.Instance,
            Text = LocalPlayer.DisplayName,
            TextSize = 15,
            Pos = UDim2.fromOffset(68, 16),
            Size = UDim2.fromOffset(ProfileW - 82, 20),
            Color = "Text",
            Truncate = true,
            Z = 46
        })

        MakeText({
            Parent = ProfilePanel.Instance,
            Text = "@" .. LocalPlayer.Name,
            TextSize = 13,
            Pos = UDim2.fromOffset(68, 37),
            Size = UDim2.fromOffset(ProfileW - 82, 16),
            Color = "DimText",
            Truncate = true,
            Z = 46
        })

        local function ProfileDivider(Y)
            MakeFrame({
                Parent = ProfilePanel.Instance,
                Pos = UDim2.fromOffset(14, Y),
                Size = UDim2.fromOffset(ProfileW - 28, 1),
                Color = "Element",
                Z = 46
            })
        end

        local function ProfileStat(Y, Label, Value)
            MakeText({
                Parent = ProfilePanel.Instance,
                Text = Label,
                TextSize = 14,
                Pos = UDim2.fromOffset(14, Y),
                Size = UDim2.fromOffset(100, 18),
                Color = "DimText",
                Z = 46
            })

            MakeText({
                Parent = ProfilePanel.Instance,
                Text = Value,
                TextSize = 14,
                Anchor = Vector2.new(1, 0),
                Pos = UDim2.new(1, -14, 0, Y),
                Size = UDim2.fromOffset(120, 18),
                Color = "Text",
                Align = Enum.TextXAlignment.Right,
                Truncate = true,
                Z = 46
            })
        end

        ProfileDivider(68)
        ProfileStat(79, "User ID", tostring(LocalPlayer.UserId))
        ProfileStat(105, "Account age", tostring(LocalPlayer.AccountAge) .. " days")

        local IdHit = MakeButton({
            Parent = ProfilePanel.Instance,
            Pos = UDim2.fromOffset(10, 76),
            Size = UDim2.fromOffset(ProfileW - 20, 24),
            Z = 47
        })

        IdHit:Connect("MouseButton1Down", function()
            if setclipboard then
                pcall(setclipboard, tostring(LocalPlayer.UserId))
            end

            Library:Notification({
                Name = "User ID copied",
                Description = "Your user id is now in the clipboard.",
                Icon = "copy",
                Duration = 3
            })
        end)

        local RefreshProfilePos

        ProfileDivider(134)

        MakeText({
            Parent = ProfilePanel.Instance,
            Text = "Interface scale",
            TextSize = 14,
            Pos = UDim2.fromOffset(14, 146),
            Size = UDim2.fromOffset(140, 18),
            Color = "DimText",
            Z = 46
        })

        local ScaleValue = MakeText({
            Parent = ProfilePanel.Instance,
            Text = "100%",
            TextSize = 14,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, -14, 0, 146),
            Size = UDim2.fromOffset(60, 18),
            Color = "Text",
            Align = Enum.TextXAlignment.Right,
            Z = 46
        })

        local ScaleTrack = MakeFrame({
            Parent = ProfilePanel.Instance,
            Pos = UDim2.fromOffset(14, 172),
            Size = UDim2.fromOffset(ProfileW - 28, 8),
            Color = "Light",
            Round = 20,
            Z = 46
        })

        local ScaleFill = MakeFrame({
            Parent = ScaleTrack.Instance,
            Size = UDim2.new(0.5, 0, 1, 0),
            Raw = Color3.new(1, 1, 1),
            Round = 20,
            Z = 47
        })

        Library:RegisterGradient(Library:Create("UIGradient", {
            Parent = ScaleFill.Instance
        }).Instance)

        local ScaleKnob = MakeFrame({
            Parent = ScaleTrack.Instance,
            Anchor = Vector2.new(0.5, 0.5),
            Pos = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.fromOffset(12, 12),
            Raw = Color3.fromRGB(197, 197, 197),
            Round = 20,
            Z = 48
        })

        local ScaleHit = MakeButton({
            Parent = ProfilePanel.Instance,
            Pos = UDim2.fromOffset(8, 166),
            Size = UDim2.fromOffset(ProfileW - 16, 22),
            Z = 49
        })

        local ScaleGrab = false
        local ScalePercent = 100

        local function ApplyScale(Input)
            local Base = ScaleTrack.Instance
            local Span = (Input.Position.X - Base.AbsolutePosition.X) / Base.AbsoluteSize.X

            ScalePercent = Library:Round(50 + math.clamp(Span, 0, 1) * 100, 5)

            local Normal = (ScalePercent - 50) / 100

            ScaleValue.Instance.Text = tostring(ScalePercent) .. "%"
            ScaleFill.Instance.Size = UDim2.new(Normal, 0, 1, 0)
            ScaleKnob.Instance.Position = UDim2.new(Normal, 0, 0.5, 0)
        end

        ScaleHit:Connect("InputBegan", function(Input)
            local IsClick = Input.UserInputType == Enum.UserInputType.MouseButton1
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if not IsClick and not IsTouch then return end

            ScaleGrab = true
            ApplyScale(Input)
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            local IsClick = Input.UserInputType == Enum.UserInputType.MouseButton1
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if (IsClick or IsTouch) and ScaleGrab then
                ScaleGrab = false
                Library.UserScale = ScalePercent / 100
                UpdateScale()

                if RefreshProfilePos then RefreshProfilePos() end
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            local IsMove = Input.UserInputType == Enum.UserInputType.MouseMovement
            local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

            if (IsMove or IsTouch) and ScaleGrab then
                ApplyScale(Input)
            end
        end)

        MakeText({
            Parent = ProfilePanel.Instance,
            Text = "Menu toggle",
            TextSize = 14,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 14, 0, 205),
            Size = UDim2.fromOffset(110, 20),
            Color = "DimText",
            Z = 46
        })

        local KeyIcon = MakeImage({
            Parent = ProfilePanel.Instance,
            Icon = "command",
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -14, 0, 205),
            Size = UDim2.fromOffset(16, 16),
            Color = "DimText",
            Z = 46
        })

        local KeyIconHit = MakeButton({
            Parent = ProfilePanel.Instance,
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -8, 0, 205),
            Size = UDim2.fromOffset(26, 26),
            Z = 48
        })

        KeyIconHit:OnHover(function()
            KeyIcon:Tween({ ImageColor3 = Library.Theme.Text })
        end, function()
            KeyIcon:Tween({ ImageColor3 = Library.Theme.DimText })
        end)

        local KeyPanelW = 170

        local KeyPanel = MakeFrame({
            Parent = Library.UnusedHolder.Instance,
            Size = UDim2.fromOffset(KeyPanelW, 72),
            Color = "Section",
            Round = 8,
            Z = 46
        })

        KeyPanel.Instance.Visible = false

        MakeText({
            Parent = KeyPanel.Instance,
            Text = "Menu keybind",
            TextSize = 12,
            Pos = UDim2.fromOffset(11, 8),
            Size = UDim2.fromOffset(KeyPanelW - 22, 14),
            Color = "DimText",
            Truncate = true,
            Z = 47
        })

        local KeyBox = MakeFrame({
            Parent = KeyPanel.Instance,
            Pos = UDim2.fromOffset(9, 32),
            Size = UDim2.fromOffset(KeyPanelW - 18, 30),
            Color = "Light",
            Round = 5,
            Clip = true,
            Z = 47
        })

        local KeyText = MakeText({
            Parent = KeyBox.Instance,
            Text = KeyName(Library.MenuKeybind),
            TextSize = 13,
            Size = UDim2.new(1, 0, 1, 0),
            Color = "Text",
            Align = Enum.TextXAlignment.Center,
            Truncate = true,
            Z = 48
        })

        local KeyBoxHit = MakeButton({
            Parent = KeyBox.Instance,
            Z = 49
        })

        local KeyState = {
            IsOpen = false,
            Debounce = false,
            Picking = false,
            Host = Profile
        }

        local function KeyPlace(Off)
            local Anchor = KeyIcon.Instance
            local PScale = Library:GetScreenScale()
            local Right = Anchor.AbsolutePosition.X + Anchor.AbsoluteSize.X
            local PX = Right / PScale + 8 + (Off or 0)
            local PY = (Anchor.AbsolutePosition.Y + GuiInset) / PScale - 4

            return UDim2.fromOffset(PX, PY)
        end

        AttachPopup({
            Popup = KeyState,
            Frame = KeyPanel,
            Level = 46,
            GetAnchor = function()
                return KeyIconHit.Instance
            end,
            Place = KeyPlace,
            From = -6,
            To = 2,
            Retreat = RetreatLeft
        })

        KeyIconHit:Connect("MouseButton1Down", function()
            KeyState:SetOpen(not KeyState.IsOpen)
        end)

        KeyBoxHit:Connect("MouseButton1Click", function()
            if KeyState.Picking then return end

            KeyState.Picking = true
            Library.Binding = true
            KeyText.Instance.Text = ". . ."

            task.wait()

            local Connection

            Connection = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType ~= Enum.UserInputType.Keyboard then return end

                Connection:Disconnect()

                if Input.KeyCode ~= Enum.KeyCode.Escape then
                    Library.MenuKeybind = Input.KeyCode
                end

                KeyText.Instance.Text = KeyName(Library.MenuKeybind)
                KeyState.Picking = false

                task.defer(function()
                    Library.Binding = false
                end)
            end)
        end)

        local UnloadButton = MakeFrame({
            Parent = ProfilePanel.Instance,
            Pos = UDim2.fromOffset(14, 236),
            Size = UDim2.fromOffset(ProfileW - 28, 28),
            Color = "Light",
            Round = 6,
            Clip = true,
            Z = 46
        })

        MakeText({
            Parent = UnloadButton.Instance,
            Text = "Unload",
            TextSize = 14,
            Size = UDim2.new(1, 0, 1, 0),
            Color = "Text",
            Align = Enum.TextXAlignment.Center,
            Z = 47
        })

        local UnloadHit = MakeButton({
            Parent = UnloadButton.Instance,
            Z = 48
        })

        UnloadButton:OnHover(function()
            UnloadButton:Tween({ BackgroundColor3 = Library.Theme.Hover })
        end, function()
            UnloadButton:Tween({ BackgroundColor3 = Library.Theme.Light })
        end)

        UnloadHit:Connect("MouseButton1Down", function()
            Window:SetOpen(false)

            task.delay(Library.Animation.Time + 0.12, function()
                Library:Unload()
            end)
        end)

        local function ProfilePlace(Extra)
            local Anchor = Items.Avatar.Instance
            local PScale = Library:GetScreenScale()
            local Right = Anchor.AbsolutePosition.X + Anchor.AbsoluteSize.X
            local X = Right / PScale - ProfileW
            local Y = Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + GuiInset

            return UDim2.fromOffset(X, Y / PScale + (Extra or 0))
        end

        RefreshProfilePos = function()
            if Profile.IsOpen then
                ProfilePanel.Instance.Position = ProfilePlace(10)
            end
        end

        AttachPopup({
            Popup = Profile,
            Frame = ProfilePanel,
            Level = 45,
            GetAnchor = function()
                return Items.ProfileHit.Instance
            end,
            Place = ProfilePlace,
            From = -2,
            To = 10,
            HoldOpen = function()
                return KeyState.IsOpen
            end
        })

        Window.Profile = Profile

        Items.ProfileHit:Connect("MouseButton1Down", function()
            Profile:SetOpen(not Profile.IsOpen)
        end)

        Items.Content = MakeFrame({
            Parent = Items.Main.Instance,
            Pos = UDim2.fromOffset(15, 65),
            Size = UDim2.new(1, -30, 1, -96),
            Clip = true,
            Z = 2
        })

        Window.Items = Items

        Items.Root:MakeDraggable(Items.Main.Instance)
        Items.Root:MakeDraggable(Items.Rail.Instance)

        table.insert(Library.Windows, Window)

        function Window:Center()
            local CScale = Library:GetScreenScale()
            local Vp = workspace.CurrentCamera.ViewportSize

            Items.Root.Instance.Position = UDim2.fromOffset(
                Vp.X / (2 * CScale) - RootW / 2,
                Vp.Y / (2 * CScale) - RootH / 2
            )
        end

        function Window:LayoutRail()
            local Count = #Window.Tabs
            local NewH = Count > 0 and (50 * Count + 10) or RailH
            local NewY = math.max(0, math.floor((H - NewH) / 2))

            Items.Rail.Instance.Size = UDim2.fromOffset(RailW, NewH)
            Items.Rail.Instance.Position = UDim2.fromOffset(0, NewY)
        end

        function Window:FitSubBar(Instant)
            local Tab = Window.Current
            if not Tab or not Tab.SubLayout then return end
            if #Tab.Subs == 0 then return end

            local ContentScale = Library:GetScreenScale()
            local Content = Tab.SubLayout.AbsoluteContentSize.X / ContentScale + 16

            if Content <= 16 then return end

            local Overflow = Content > MaxSubW
            local Target = math.min(Content, MaxSubW)
            local NewX = SubCenterX - math.floor(Target / 2)

            local Info = Instant and TweenInfo.new(0)
            or TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

            Library:Tween({
                Position = UDim2.fromOffset(NewX, SubY),
                Size = UDim2.fromOffset(Target, SubH)
            }, Info, Items.SubBar.Instance)

            local Row = Tab.Items.SubRow.Instance
            Row.ScrollingEnabled = Overflow
            Row.ScrollBarThickness = 0
        end

        function Window:LayoutSubBar(Instant)
            Window:FitSubBar(Instant)
        end

        function Window:GetSizeLimits()
            local LScale = Library:GetScreenScale()
            local Vp = Items.Root.Instance.Parent.AbsoluteSize / LScale

            local MinW = 560
            local MinH = math.max(400, #Window.Tabs > 0 and (50 * #Window.Tabs + 10) or RailH)

            local MaxW = math.min(1400, math.floor(Vp.X * 0.9) - MainX)
            local MaxH = math.min(900, math.floor(Vp.Y * 0.9) - math.floor(SubH / 2))

            return MinW, MinH, math.max(MinW, MaxW), math.max(MinH, MaxH)
        end

        function Window:SetSize(NewW, NewH, Remeasure)
            if Window.Resizing then return end

            local MinW, MinH, MaxW, MaxH = Window:GetSizeLimits()

            NewW = math.clamp(math.floor(NewW or W), MinW, MaxW)
            NewH = math.clamp(math.floor(NewH or H), MinH, MaxH)

            if NewW == W and NewH == H and not Remeasure then return end

            Window.Resizing = true

            W = NewW
            H = NewH
            Recompute()

            Window.ContentW = W - 30
            Window.ContentH = H - 96
            Window.ColW = ColW
            Window.Col2X = Col2X

            Items.Root.Instance.Size = UDim2.fromOffset(RootW, RootH)
            Items.Main.Instance.Size = UDim2.fromOffset(W, H)

            Window:LayoutRail()

            local BarW = math.min(Items.SubBar.Instance.Size.X.Offset, MaxSubW)

            Items.SubBar.Instance.Size = UDim2.fromOffset(BarW, SubH)
            Items.SubBar.Instance.Position = UDim2.fromOffset(
                SubCenterX - math.floor(BarW / 2),
                SubY
            )

            Window:FitSubBar(true)

            for _, Tab in Window.Tabs do
                for _, Sub in Tab.Subs do
                    local Page = Sub.Items and Sub.Items.Page

                    if Page then
                        Page.Instance.Size = UDim2.fromOffset(Window.ContentW, Window.ContentH)
                    end

                    for _, Column in Sub.Columns do
                        Column:SetWidth(ColW, Remeasure)
                    end

                    if Sub.OnResize then
                        Library:SafeCall(Sub.OnResize, Window.ContentW, Window.ContentH)
                    end
                end
            end

            local PScale = Library:GetScreenScale()
            local Vp = Items.Root.Instance.Parent.AbsoluteSize / PScale
            local Pos = Items.Root.Instance.Position

            Items.Root.Instance.Position = UDim2.fromOffset(
                math.clamp(Pos.X.Offset, 0, math.max(Vp.X - RootW, 0)),
                math.clamp(Pos.Y.Offset, 0, math.max(Vp.Y - RootH, 0))
            )

            Window.Resizing = false
        end

        local Grip = { }

        Items.Grip = MakeFrame({
            Parent = Items.Main.Instance,
            Anchor = Vector2.new(1, 1),
            Pos = UDim2.new(1, -6, 1, -6),
            Size = UDim2.fromOffset(14, 14),
            Color = "Element",
            Round = 7,
            Z = 15
        })

        Items.GripDot = MakeFrame({
            Parent = Items.Grip.Instance,
            Anchor = Vector2.new(0.5, 0.5),
            Pos = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.fromOffset(6, 6),
            Color = "DimText",
            Round = 3,
            Z = 16
        })

        Items.GripHit = MakeButton({
            Parent = Items.Main.Instance,
            Anchor = Vector2.new(1, 1),
            Pos = UDim2.new(1, -2, 1, -2),
            Size = UDim2.fromOffset(26, 26),
            Z = 17
        })

        Items.GripHit:OnHover(function()
            Items.GripDot:Tween({ BackgroundColor3 = Library.Theme.Accent })
        end, function()
            if Grip.Origin then return end
            Items.GripDot:Tween({ BackgroundColor3 = Library.Theme.DimText })
        end)

        AttachDrag(Items.GripHit, {
            OnGrab = function(Input)
                Library:CloseAllPopups()

                Grip.Scale = Library:GetScreenScale()
                Grip.Origin = Input.Position
                Grip.StartW = W
                Grip.StartH = H

                Items.GripDot:Tween({ BackgroundColor3 = Library.Theme.Accent })
            end,

            OnMove = function(Input)
                if not Grip.Origin then return end

                local GScale = (Grip.Scale > 0 and Grip.Scale) or 1

                Window:SetSize(
                    Grip.StartW + (Input.Position.X - Grip.Origin.X) / GScale,
                    Grip.StartH + (Input.Position.Y - Grip.Origin.Y) / GScale
                )
            end,

            OnRelease = function()
                Grip.Origin = nil

                Window:SetSize(W, H, true)
                Items.GripDot:Tween({ BackgroundColor3 = Library.Theme.DimText })
            end
        })

        function Window:SetOpen(Bool)
            Window.IsOpen = Bool

            if not Bool then
                Library:CloseAllPopups()
            end

            local Sub = Window.Current and Window.Current.Current
            if Sub and Sub.SnapVisible then
                Sub:SnapVisible()
            end

            if Bool and Window.PlayIntro then
                Window:PlayIntro()
            else
                Items.Root:FadeDescendants(Bool)
            end
        end

        Library:Connect(UserInputService.InputBegan, function(Input, Processed)
            if Processed or Library.Binding then return end

            if Input.KeyCode == Library.MenuKeybind then
                Window:SetOpen(not Window.IsOpen)
            end
        end)

        Items.SearchResults = Library:Create("ScrollingFrame", {
            Parent = Items.Content.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            ScrollBarImageTransparency = 1,
            Selectable = false,
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.fromOffset(0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ZIndex = 3,
            BorderSizePixel = 0
        })

        Library:Create("UIListLayout", {
            Parent = Items.SearchResults.Instance,
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })

        Items.SearchEmpty = MakeText({
            Parent = Items.Content.Instance,
            Text = "",
            TextSize = 15,
            Pos = UDim2.fromOffset(0, 24),
            Size = UDim2.new(1, 0, 0, 20),
            Color = "DimText",
            Align = Enum.TextXAlignment.Center,
            Z = 9
        })

        Items.SearchEmpty.Instance.Visible = false

        local Borrowed = { }
        local ResultCards = { }

        local function ReturnBorrowed()
            for _, Data in Borrowed do
                if Data.Frame and Data.Frame.Instance and Data.Section then
                    Data.Frame.Instance.Parent = Data.Section.Items.Frame.Instance
                end

                Data.Borrowed = nil
            end

            table.clear(Borrowed)

            for _, Card in ResultCards do
                pcall(function() Card:Destroy() end)
            end

            table.clear(ResultCards)
        end

        local function BreadCrumb(Section)
            local Sub = Section and Section.SubTab
            local Tab = Sub and Sub.Tab

            local Parts = { }

            if Tab then table.insert(Parts, Tab.Name) end
            if Sub then table.insert(Parts, Sub.Name) end
            if Section then table.insert(Parts, Section.Name) end

            return table.concat(Parts, "  >  ")
        end

        local function BuildResults(Matches, Total)
            local Order = 0

            for _, Data in Matches do
                Order += 1

                local Holder = MakeFrame({
                    Parent = Items.SearchResults.Instance,
                    Size = UDim2.new(1, 0, 0, Data.Height + 20),
                    Z = 3
                })

                Holder.Instance.LayoutOrder = Order
                table.insert(ResultCards, Holder.Instance)

                MakeText({
                    Parent = Holder.Instance,
                    Text = BreadCrumb(Data.Section),
                    TextSize = 12,
                    Pos = UDim2.fromOffset(14, 0),
                    Size = UDim2.new(1, -28, 0, 14),
                    Color = "DimText",
                    Truncate = true,
                    Z = 5
                })

                local Card = MakeFrame({
                    Parent = Holder.Instance,
                    Pos = UDim2.fromOffset(0, 18),
                    Size = UDim2.new(1, 0, 0, Data.Height),
                    Color = "Section",
                    Round = 8,
                    Z = 3
                })

                Data.Borrowed = true
                Data.Frame.Instance.Parent = Card.Instance
                Data.Frame.Instance.Position = UDim2.fromOffset(0, 0)
                Data.Frame.Instance.Visible = true

                table.insert(Borrowed, Data)
            end

            if Total > #Matches then
                Order += 1

                local More = MakeText({
                    Parent = Items.SearchResults.Instance,
                    Text = ("and %d more - narrow the search"):format(Total - #Matches),
                    TextSize = 13,
                    Size = UDim2.new(1, 0, 0, 20),
                    Color = "DimText",
                    Align = Enum.TextXAlignment.Center,
                    Z = 10
                })

                More.Instance.LayoutOrder = Order
                table.insert(ResultCards, More.Instance)
            end
        end

        local function RunSearch(Query)
            Query = string.lower(Query)

            ReturnBorrowed()

            if Query == "" then
                Window.Searching = false
                Items.SearchResults.Instance.Visible = false
                Items.SearchEmpty.Instance.Visible = false

                for _, Data in Library.Searchables do
                    if Data.Window == Window then
                        Data.Visible = true

                        if Data.Section then
                            Data.Section.Dirty = true
                        end
                    end
                end

                for _, Tab in Window.Tabs do
                    for _, Sub in Tab.Subs do
                        for _, Section in Sub.Sections do
                            if Section.Dirty then
                                Section.Dirty = false
                                Section:Reflow()
                            end
                        end

                        if Sub.Items and Sub.Items.Page then
                            Sub.Items.Page.Instance.Visible = Sub.Active == true
                        end
                    end
                end

                Window.SearchSig = nil

                local Tab = Window.Current
                local Sub = Tab and Tab.Current

                if Sub and Sub.Show then
                    Sub:Show()
                end

                return
            end

            Window.Searching = true

            local Matches, Total = { }, 0

            for _, Tab in Window.Tabs do
                for _, Sub in Tab.Subs do
                    for _, Section in Sub.Sections do
                        for _, Data in Section.Rows do
                            local Name = string.lower(Data.Name or "")
                            local Hit = string.find(Name, Query, 1, true) ~= nil

                            if not Hit then
                                Hit = string.find(string.lower(Section.Name or ""), Query, 1, true) ~= nil
                            end

                            Data.Visible = not Hit

                            if Hit then
                                Total += 1

                                if #Matches < 60 then
                                    table.insert(Matches, Data)
                                end
                            end
                        end

                        Section.Dirty = true
                    end
                end
            end

            for _, Tab in Window.Tabs do
                for _, Sub in Tab.Subs do
                    for _, Section in Sub.Sections do
                        if Section.Dirty then
                            Section.Dirty = false
                            Section:Reflow()
                        end
                    end

                    if Sub.Items and Sub.Items.Page then
                        Sub.Items.Page.Instance.Visible = false
                    end
                end
            end

            BuildResults(Matches, Total)

            Items.SearchResults.Instance.Visible = #Matches > 0
            Items.SearchResults.Instance.CanvasPosition = Vector2.new(0, 0)

            Items.SearchEmpty.Instance.Visible = #Matches == 0
            Items.SearchEmpty.Instance.Text = ("nothing matches \"%s\""):format(Items.SearchBox.Instance.Text)
        end

        local SearchToken = 0

        Library:Connect(Items.SearchBox.Instance:GetPropertyChangedSignal("Text"), function()
            SearchToken += 1

            local Token = SearchToken

            task.delay(0.1, function()
                if Token ~= SearchToken then return end
                RunSearch(Items.SearchBox.Instance.Text)
            end)
        end)

        local SearchOpen = false
        local SearchGuard = 0
        local SearchInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        local function ResetSearch()
            local Box = Items.SearchBox.Instance
            if Box.Text == "" then return end

            Box.Text = ""
            SearchToken += 1
            RunSearch("")
        end

        local function SetSearchOpen(Bool)
            if SearchOpen == Bool then return end
            SearchOpen = Bool

            local Box = Items.SearchBox.Instance
            local Width = Bool and SearchW or SearchClosedW

            Library:StampResting(Box, "TextTransparency", Bool and 0 or 1)
            Library:Tween({ Size = UDim2.fromOffset(Width, 30) }, SearchInfo, Items.Search.Instance)
            Library:Tween({ TextTransparency = Bool and 0 or 1 }, SearchInfo, Box)

            Items.SearchIcon:ChangeItemTheme({ ImageColor3 = Bool and "Text" or "DimText" })
            Items.SearchIcon:Tween({
                ImageColor3 = Bool and Library.Theme.Text or Library.Theme.DimText
            }, SearchInfo)

            if Bool then
                Box:CaptureFocus()
                return
            end

            SearchGuard = os.clock()

            if Box:IsFocused() then
                Box:ReleaseFocus()
            end

            ResetSearch()
        end

        Items.SearchHit:Connect("MouseButton1Click", function()
            if not SearchOpen and os.clock() - SearchGuard < 0.2 then return end
            SetSearchOpen(not SearchOpen)
        end)

        Items.SearchBox:Connect("FocusLost", function(Enter, Input)
            local Escaped = Input ~= nil and Input.KeyCode == Enum.KeyCode.Escape

            if Escaped or Items.SearchBox.Instance.Text == "" then
                SetSearchOpen(false)
            end
        end)

        Items.Search:OnHover(function()
            if SearchOpen then return end
            Items.SearchIcon:Tween({ ImageColor3 = Library.Theme.Text })
        end, function()
            if SearchOpen then return end
            Items.SearchIcon:Tween({ ImageColor3 = Library.Theme.DimText })
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if not SearchOpen or Library.Binding then return end
            if Input.KeyCode ~= Enum.KeyCode.Escape then return end

            SetSearchOpen(false)
        end)

        function Window:PlayIntro()
            local Base = Items.Root.Instance.Position
            local Rise = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

            Items.Root.Instance.Position = UDim2.fromOffset(
                Base.X.Offset,
                Base.Y.Offset + 24
            )

            Items.Root:FadeDescendants(true)
            Library:Tween({ Position = Base }, Rise, Items.Root.Instance)
        end

        task.defer(function()
            Window:PlayIntro()
        end)

        return setmetatable(Window, Library)
    end

    Library.Tab = function(Self, Params)
        Params = Params or { }

        local Window = Self

        local Tab = {
            Name = Params.Name or "Tab",
            Icon = Params.Icon or "circle",
            Window = Window,
            Subs = { },
            Current = nil,
            Active = false,
            Items = { }
        }

        local Items = { }
        local Index = #Window.Tabs
        local RowY = 10 + Index * 50

        Items.Row = MakeFrame({
            Parent = Window.Items.Rail.Instance,
            Pos = UDim2.fromOffset(10, RowY),
            Size = UDim2.fromOffset(40, 40),
            Color = "Element",
            Round = 8,
            Clip = true,
            Z = 3
        })

        SetRest(Items.Row.Instance, "BackgroundTransparency", 1)

        Items.Bar = MakeFrame({
            Parent = Window.Items.Rail.Instance,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 0, 0, RowY + 20),
            Size = UDim2.fromOffset(3, 0),
            Color = "Accent",
            Round = 4,
            Z = 4
        })

        Items.BarShadow = MakeAccentShadow(
            Items.Bar.Instance,
            UDim2.fromOffset(3, 15),
            UDim.new(0, 10),
            0
        )

        if Items.BarShadow then
            SetRest(Items.BarShadow, "Transparency", 1)
        end

        Items.Icon = MakeImage({
            Parent = Items.Row.Instance,
            Icon = Tab.Icon,
            Pos = UDim2.fromOffset(10, 10),
            Size = UDim2.fromOffset(20, 20),
            Color = "DimIcon",
            Z = 4
        })

        Items.Hit = MakeButton({
            Parent = Items.Row.Instance,
            Z = 6
        })

        Items.SubRow = Library:Create("ScrollingFrame", {
            Parent = Window.Items.SubBar.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            ScrollBarImageTransparency = 1,
            ScrollBarImageColor3 = Library.Theme.Accent,
            ScrollingDirection = Enum.ScrollingDirection.X,
            ScrollingEnabled = false,
            Selectable = false,
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.X,
            CanvasSize = UDim2.fromOffset(0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 21,
            BorderSizePixel = 0
        }):AddToTheme({ ScrollBarImageColor3 = "Accent" })

        Items.SubRow.Instance.Visible = false

        Items.SubLayout = Library:Create("UIListLayout", {
            Parent = Items.SubRow.Instance,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
        })

        Library:Create("UIPadding", {
            Parent = Items.SubRow.Instance,
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8)
        })

        Window.Items.Root:MakeDraggable(Items.SubRow.Instance)

        Tab.SubLayout = Items.SubLayout.Instance

        Library:Connect(Tab.SubLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            if Window.Current == Tab then
                Window:FitSubBar(true)
            end
        end)

        Tab.Items = Items

        function Tab:SetVisual(Active)
            Tab.Active = Active

            Library:StampResting(Items.Row.Instance, "BackgroundTransparency", Active and 0 or 1)

            if Items.BarShadow then
                Library:StampResting(Items.BarShadow, "Transparency", Active and 0 or 1)
                Items.BarShadow.Transparency = Active and 0 or 1
            end

            Items.Icon:ChangeItemTheme({ ImageColor3 = Active and "Accent" or "DimIcon" })
            Items.Icon:Tween({
                ImageColor3 = Active and Library.Theme.Accent or Library.Theme.DimIcon
            })

            Items.Row:Tween({ BackgroundTransparency = Active and 0 or 1 })
            Items.Bar:Tween({ Size = UDim2.fromOffset(3, Active and 16 or 0) })
        end

        Items.Row:OnHover(function()
            if Tab.Active then return end
            Items.Icon:Tween({ ImageColor3 = Library.Theme.Text })
        end, function()
            if Tab.Active then return end
            Items.Icon:Tween({ ImageColor3 = Library.Theme.DimIcon })
        end)

        local function EnterFirstSub()
            local Sub = Tab.Current or Tab.Subs[1]
            if not Sub then return end

            Tab.Current = Sub

            for _, Other in Tab.Subs do
                Other:SetVisual(Other == Sub)
            end

            Sub:Show()
        end

        function Tab:Select()
            if Window.Current == Tab then return end

            Library:CloseAllPopups()

            if Window.Current then
                Window.Current:SetVisual(false)
                Window.Current.Items.SubRow.Instance.Visible = false

                if Window.Current.Current then
                    Window.Current.Current:Hide()
                end
            end

            Window.Current = Tab
            Tab:SetVisual(true)
            Items.SubRow.Instance.Visible = true

            EnterFirstSub()
            Window:LayoutSubBar()
        end

        Items.Hit:Connect("MouseButton1Down", function()
            Tab:Select()
        end)

        table.insert(Window.Tabs, Tab)
        Window:LayoutRail()

        if #Window.Tabs == 1 then
            Window.Current = Tab
            Tab:SetVisual(true)
            Items.SubRow.Instance.Visible = true

            task.defer(function()
                EnterFirstSub()
                Window:LayoutSubBar()
            end)
        end

        return setmetatable(Tab, Library)
    end

    Library.SubTab = function(Self, Params)
        Params = Params or { }

        local Tab = Self
        local Window = Tab.Window

        local SubTab = {
            Name = Params.Name or "SubTab",
            Icon = Params.Icon or "circle",
            Tab = Tab,
            Window = Window,
            Sections = { },
            Columns = { },
            Active = false,
            ShowToken = 0,
            Items = { }
        }

        local Items = { }
        local ContentW = Window.ContentW
        local ContentH = Window.ContentH
        local ColW = Window.ColW
        local Col2X = Window.Col2X

        local TextW = math.ceil(MeasureText(SubTab.Name, 15, 300, UiFont).X)
        local CollapsedW = 40
        local ExpandedW = 37 + TextW + 12

        SubTab.CollapsedW = CollapsedW
        SubTab.ExpandedW = ExpandedW

        Items.Pill = MakeFrame({
            Parent = Tab.Items.SubRow.Instance,
            Size = UDim2.fromOffset(CollapsedW, 30),
            Color = "Element",
            Round = 5,
            Clip = true,
            Z = 22
        })

        SetRest(Items.Pill.Instance, "BackgroundTransparency", 1)
        Items.Pill.Instance.LayoutOrder = #Tab.Subs

        Items.Icon = MakeImage({
            Parent = Items.Pill.Instance,
            Icon = SubTab.Icon,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 11, 0.5, 0),
            Size = UDim2.fromOffset(18, 18),
            Color = "DimIcon",
            Z = 23
        })

        Items.Label = MakeText({
            Parent = Items.Pill.Instance,
            Text = SubTab.Name,
            TextSize = 15,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 37, 0.5, 0),
            Size = UDim2.fromOffset(TextW + 8, 20),
            Color = "Text",
            Z = 23
        })

        SetRest(Items.Label.Instance, "TextTransparency", 1)

        local function SyncWidth()
            local Bounds = math.ceil(Items.Label.Instance.TextBounds.X)
            if Bounds <= 0 then return end

            ExpandedW = 37 + Bounds + 12
            SubTab.ExpandedW = ExpandedW
            Items.Label.Instance.Size = UDim2.fromOffset(Bounds + 8, 20)

            if Tab.Current == SubTab then
                Items.Pill.Instance.Size = UDim2.fromOffset(ExpandedW, 30)
                Window:FitSubBar(true)
            end
        end

        Library:Connect(Items.Label.Instance:GetPropertyChangedSignal("TextBounds"), SyncWidth)
        task.defer(SyncWidth)

        Items.Hit = MakeButton({
            Parent = Items.Pill.Instance,
            Z = 25
        })

        Items.Page = MakeFrame({
            Parent = Library.UnusedHolder.Instance,
            Size = UDim2.fromOffset(ContentW, ContentH),
            Z = 3
        })

        Items.Page.Instance.Visible = false

        local function MakeColumn(Index)
            local Scroll = Library:Create("ScrollingFrame", {
                Parent = Items.Page.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                ScrollBarThickness = 0,
                ScrollBarImageTransparency = 1,
                Selectable = false,
                Active = true,
                Position = UDim2.new(0.5 * (Index - 1), (Index - 1) * 8, 0, 0),
                Size = UDim2.new(0.5, -8, 1, 0),
                CanvasSize = UDim2.fromOffset(0, 0),
                ZIndex = 3,
                BorderSizePixel = 0
            })

            local Column = {
                Scroll = Scroll,
                Width = ColW,
                Sections = { }
            }

            function Column:Reflow()
                if Column.Suppress then return end

                local Y = 0

                for _, Section in Column.Sections do
                    Section.Y = Y
                    Section.Items.Holder.Instance.Position = UDim2.fromOffset(0, Y)
                    Y += Section.Height + 16
                end

                Scroll.Instance.CanvasSize = UDim2.fromOffset(0, math.max(Y - 16, 0))
            end

            function Column:SetWidth(NewWidth, Remeasure)
                Column.Width = NewWidth
                Column.Suppress = true

                for _, Section in Column.Sections do
                    Section:SetWidth(NewWidth, Remeasure)
                end

                Column.Suppress = false
                Column:Reflow()
            end

            return Column
        end

        SubTab.Columns[1] = MakeColumn(1)
        SubTab.Columns[2] = MakeColumn(2)
        SubTab.Items = Items

        function SubTab:SetVisual(Active, Instant)
            Library:StampResting(Items.Pill.Instance, "BackgroundTransparency", Active and 0 or 1)
            Library:StampResting(Items.Label.Instance, "TextTransparency", Active and 0 or 1)

            local Info = Instant and TweenInfo.new(0)
            or TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

            local Width = Active and ExpandedW or CollapsedW

            Library:Tween({ Size = UDim2.fromOffset(Width, 30) }, Info, Items.Pill.Instance)
            Library:Tween({ TextTransparency = Active and 0 or 1 }, Info, Items.Label.Instance)

            Items.Icon:ChangeItemTheme({ ImageColor3 = Active and "Accent" or "DimIcon" })
            Items.Icon:Tween({
                ImageColor3 = Active and Library.Theme.Accent or Library.Theme.DimIcon
            }, Info)

            Items.Pill:Tween({ BackgroundTransparency = Active and 0 or 1 }, Info)
        end

        Items.Pill:OnHover(function()
            if Tab.Current == SubTab then return end
            Items.Icon:Tween({ ImageColor3 = Library.Theme.Text })
        end, function()
            if Tab.Current == SubTab then return end
            Items.Icon:Tween({ ImageColor3 = Library.Theme.DimIcon })
        end)

        local RowIn = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local Sink = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        local PageSlide = 22
        local RowSlide = 18
        local SectionStep = 0.07
        local RowStep = 0.045

        local function ForEachSectionPart(Section, Handler)
            local Parts = Section.Items

            local Objects = {
                Parts.Header.Instance,
                Parts.HeaderFill.Instance,
                Parts.Label.Instance,
                Parts.Frame.Instance,
                Parts.BodyFill.Instance
            }

            for _, Object in Objects do
                local Properties = Library:GetTweenProperty(Object)
                if not Properties then continue end

                for _, Property in Properties do
                    Handler(Object, Property)
                end
            end
        end

        local function PrimeParts(Section)
            ForEachSectionPart(Section, function(Object, Property)
                Library:CaptureResting(Object, Property)
                Object[Property] = 1
            end)
        end

        local function RevealParts(Section)
            ForEachSectionPart(Section, function(Object, Property)
                local Resting = Library:CaptureResting(Object, Property)
                Library:Tween({ [Property] = Resting }, nil, Object)
            end)
        end

        local function ForEachRow(Handler)
            for _, Column in SubTab.Columns do
                for _, Section in Column.Sections do
                    for _, Data in Section.Rows do
                        if not Data.Borrowed then
                            Handler(Data, Section)
                        end
                    end
                end
            end
        end

        local PageTween

        local function StopTween(Handle)
            if not Handle then return end

            pcall(function()
                Handle:Cancel()
            end)
        end

        local function StopPageTween()
            StopTween(PageTween)
            PageTween = nil
        end

        local function StopRowTweens()
            ForEachRow(function(Data)
                StopTween(Data.Move)
                Data.Move = nil
            end)
        end

        local function LayoutPage()
            for _, Column in SubTab.Columns do
                for _, Section in Column.Sections do
                    Section.Items.Holder.Instance.Position = UDim2.fromOffset(0, Section.Y)
                    Section.Items.Frame.Instance.Position = UDim2.fromOffset(0, 26)

                    for _, Data in Section.Rows do
                        Data.Frame:CancelFade()
                        Data.Frame.Instance.Visible = Data.Visible ~= false
                    end
                end
            end
        end

        local function CleanPage()
            Items.Page.Instance.Position = UDim2.fromOffset(0, 0)
            Items.Page:HardRestore()

            LayoutPage()

            ForEachRow(function(Data)
                Data.Frame.Instance.Position = UDim2.fromOffset(0, Data.Y)
            end)
        end

        function SubTab:Show()
            SubTab.ShowToken += 1

            local Token = SubTab.ShowToken
            SubTab.Active = true

            StopPageTween()
            StopRowTweens()

            Items.Page:CancelFade()
            Items.Page:HardRestore()
            Items.Page.Instance.Parent = Window.Items.Content.Instance
            Items.Page.Instance.Position = UDim2.fromOffset(0, 0)
            Items.Page.Instance.Visible = true

            Library:SafeCall(SubTab.PageIntro)

            if #SubTab.Sections == 0 then return end

            LayoutPage()

            local Order = 0

            for _, Column in SubTab.Columns do
                for _, Section in Column.Sections do
                    Order += 1
                    PrimeParts(Section)

                    for _, Data in Section.Rows do
                        if not Data.Borrowed then
                            Data.Frame:CancelFade()
                            Data.Frame.Instance.Visible = false
                        end
                    end

                    local Slot = Order

                    task.delay((Slot - 1) * SectionStep, function()
                        if SubTab.ShowToken ~= Token or not SubTab.Active then return end

                        RevealParts(Section)

                        for RowIndex, Data in Section.Rows do
                            if Data.Visible == false or Data.Borrowed then continue end

                            task.delay(RowIndex * RowStep, function()
                                local Home = UDim2.fromOffset(0, Data.Y)

                                Data.Frame.Instance.Visible = true

                                if SubTab.ShowToken ~= Token or not SubTab.Active then
                                    Data.Frame.Instance.Position = Home
                                    return
                                end

                                Data.Frame.Instance.Position = UDim2.fromOffset(RowSlide, Data.Y)
                                Data.Move = Library:Tween({ Position = Home }, RowIn, Data.Frame.Instance)
                                Data.Frame:FadeDescendants(true)
                            end)
                        end
                    end)
                end
            end
        end

        function SubTab:Hide(OnDone)
            SubTab.Active = false
            SubTab.ShowToken += 1

            Library:SafeCall(SubTab.PageOutro)

            StopRowTweens()

            ForEachRow(function(Data)
                Data.Frame:CancelFade()
            end)

            StopPageTween()

            PageTween = Library:Tween({
                Position = UDim2.fromOffset(-PageSlide, 0)
            }, Sink, Items.Page.Instance)

            Items.Page:FadeDescendants(false, function()
                if not SubTab.Active then
                    StopPageTween()
                    Items.Page:ResetFade()
                    CleanPage()

                    Items.Page.Instance.Visible = false
                    Items.Page.Instance.Parent = Library.UnusedHolder.Instance
                end

                if OnDone then Library:SafeCall(OnDone) end
            end)
        end

        function SubTab:SnapVisible()
            SubTab.ShowToken += 1
            SubTab.Active = true

            StopPageTween()
            StopRowTweens()

            Items.Page:CancelFade()
            CleanPage()

            Items.Page.Instance.Visible = true
        end

        Items.Hit:Connect("MouseButton1Down", function()
            if Tab.Current == SubTab then return end

            Library:CloseAllPopups()

            if Tab.Current then
                Tab.Current:SetVisual(false)
                Tab.Current:Hide()
            end

            Tab.Current = SubTab
            SubTab:SetVisual(true)
            SubTab:Show()

            Window:LayoutSubBar()
        end)

        table.insert(Tab.Subs, SubTab)

        if #Tab.Subs == 1 then
            Tab.Current = SubTab
            SubTab:SetVisual(true, true)
        end

        if Window.Current == Tab then
            Window:LayoutSubBar()
        end

        return setmetatable(SubTab, Library)
    end

    Library.Section = function(Self, Params)
        Params = Params or { }

        local SubTab = Self
        local Side = Params.Side or 1

        if Side == "Right" then Side = 2 end
        if Side == "Left" then Side = 1 end

        local Column = SubTab.Columns[Side] or SubTab.Columns[1]

        local Section = {
            Name = Params.Name or "Section",
            SubTab = SubTab,
            Column = Column,
            Width = Column.Width,
            Y = 0,
            Height = 0,
            Rows = { },
            Dirty = false,
            Items = { }
        }

        local Items = { }

        Items.Holder = MakeFrame({
            Parent = Column.Scroll.Instance,
            Size = UDim2.new(1, 0, 0, 40),
            Z = 3
        })

        local HeaderTextW = math.ceil(MeasureText(Section.Name, 15, 240, UiFont).X)
        local HeaderW = HeaderTextW + 26

        Items.Header = MakeFrame({
            Parent = Items.Holder.Instance,
            Pos = UDim2.fromOffset(0, 1),
            Size = UDim2.fromOffset(HeaderW, 25),
            Color = "Section",
            Round = 10,
            Z = 3
        })

        Items.HeaderFill = MakeFrame({
            Parent = Items.Header.Instance,
            Pos = UDim2.fromOffset(0, 15),
            Size = UDim2.fromOffset(HeaderW, 10),
            Color = "Section",
            Z = 3
        })

        Items.Label = MakeText({
            Parent = Items.Header.Instance,
            Text = Section.Name,
            TextSize = 15,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 13, 0.5, 1),
            Size = UDim2.fromOffset(HeaderTextW + 6, 20),
            Color = "Text",
            Z = 4
        })

        local function SyncHeader()
            local Bounds = math.ceil(Items.Label.Instance.TextBounds.X)
            if Bounds <= 0 then return end

            HeaderTextW = Bounds
            HeaderW = Bounds + 26

            Items.Label.Instance.Size = UDim2.fromOffset(Bounds + 6, 20)
            Items.Header.Instance.Size = UDim2.fromOffset(HeaderW, 25)
            Items.HeaderFill.Instance.Size = UDim2.fromOffset(HeaderW, 10)
        end

        Library:Connect(Items.Label.Instance:GetPropertyChangedSignal("TextBounds"), SyncHeader)
        task.defer(SyncHeader)

        Items.Frame = MakeFrame({
            Parent = Items.Holder.Instance,
            Pos = UDim2.fromOffset(0, 26),
            Size = UDim2.new(1, 0, 0, 14),
            Color = "Section",
            Round = 10,
            Z = 3
        })

        Items.BodyFill = MakeFrame({
            Parent = Items.Frame.Instance,
            Pos = UDim2.fromOffset(0, 0),
            Size = UDim2.fromOffset(10, 10),
            Color = "Section",
            Z = 3
        })

        Section.Items = Items

        function Section:Reflow()
            local Y = 8
            local Visible = 0

            for _, Data in Section.Rows do
                if Data.Borrowed then continue end

                local Shown = Data.Visible ~= false

                Data.Frame.Instance.Visible = Shown

                if not Shown then continue end

                Data.Y = Y
                Data.Frame.Instance.Position = UDim2.fromOffset(0, Y)
                Y += Data.Height
                Visible += 1
            end

            local FrameHeight = Visible > 0 and (Y + 8) or 0

            Items.Frame.Instance.Size = UDim2.new(1, 0, 0, FrameHeight)
            Items.Holder.Instance.Visible = Visible > 0
            Section.Height = Visible > 0 and (26 + FrameHeight) or 0
            Items.Holder.Instance.Size = UDim2.new(1, 0, 0, math.max(Section.Height, 1))

            Column:Reflow()
        end

        function Section:AddRow(Height, SearchName)
            local Frame = MakeFrame({
                Parent = Items.Frame.Instance,
                Size = UDim2.new(1, 0, 0, Height),
                Z = 4
            })

            local Data = {
                Frame = Frame,
                Height = Height,
                Y = 0,
                Visible = true,
                Name = SearchName or Section.Name,
                Section = Section,
                Window = SubTab.Window
            }

            table.insert(Section.Rows, Data)
            table.insert(Library.Searchables, Data)

            Section:Reflow()
            return Frame, Data
        end

        function Section:SetWidth(NewWidth, Remeasure)
            Section.Width = NewWidth

            if Remeasure then
                for _, Data in Section.Rows do
                    if Data.OnWidth then
                        Library:SafeCall(Data.OnWidth, NewWidth)
                    end
                end
            end

            Section:Reflow()
        end

        table.insert(SubTab.Sections, Section)
        table.insert(Column.Sections, Section)
        Section:Reflow()

        return setmetatable(Section, Library)
    end

    Library.Toggle = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Toggle = {
            Name = Params.Name or "Toggle",
            Default = Params.Default or false,
            Flag = Params.Flag,
            Callback = Params.Callback or function() end,
            Value = false,
            Visual = nil,
            Token = 0,
            Items = { }
        }

        local Row = Section:AddRow(32, Toggle.Name)
        local Items = { Row = Row }

        Items.Label = MakeText({
            Parent = Row.Instance,
            Text = Toggle.Name,
            TextSize = 15,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 15, 0.5, 0),
            Size = UDim2.new(1, -80, 0, 20),
            Color = "DimText",
            Truncate = true,
            Z = 5
        })

        Items.Box = MakeFrame({
            Parent = Row.Instance,
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -15, 0.5, 0),
            Size = UDim2.fromOffset(38, 22),
            Color = "Element",
            Round = 6,
            Clip = true,
            Z = 5
        })

        Items.Circle = MakeFrame({
            Parent = Items.Box.Instance,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 3, 0.5, 0),
            Size = UDim2.fromOffset(16, 16),
            Color = "DimText",
            Round = 5,
            Z = 6
        })

        Items.Hit = MakeButton({
            Parent = Row.Instance,
            Size = UDim2.new(1, 0, 1, 0),
            Z = 8
        })

        Toggle.Items = Items

        local Pad = 3
        local InnerW = 38 - Pad * 2
        local LeftPos = UDim2.new(0, Pad, 0.5, 0)
        local RightPos = UDim2.new(1, -Pad, 0.5, 0)
        local Small = UDim2.fromOffset(16, 16)

        function Toggle.SetVisual(State, Instant)
            State = State and true or false
            if Toggle.Visual == State then return end
            Toggle.Visual = State

            Toggle.Token += 1
            local Token = Toggle.Token

            if Toggle.GrowTween then
                pcall(function()
                    Toggle.GrowTween:Cancel()
                end)
            end

            if Toggle.SnapTween then
                pcall(function()
                    Toggle.SnapTween:Cancel()
                end)
            end

            Toggle.GrowTween = nil
            Toggle.SnapTween = nil

            local BoxColor = State and "Accent" or "Element"
            local CircleKey = State and "Text" or "DimText"
            local CircleColor = Library.Theme[CircleKey]
            local LabelColor = State and "Text" or "DimText"

            local StartAnchor = State and Vector2.new(0, 0.5) or Vector2.new(1, 0.5)
            local StartPos = State and LeftPos or RightPos
            local EndAnchor = State and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
            local EndPos = State and RightPos or LeftPos

            Items.Box:ChangeItemTheme({ BackgroundColor3 = BoxColor })
            Items.Label:ChangeItemTheme({ TextColor3 = LabelColor })
            Items.Circle:ChangeItemTheme({ BackgroundColor3 = CircleKey })

            if Instant then
                Items.Box.Instance.BackgroundColor3 = Library.Theme[BoxColor]
                Items.Label.Instance.TextColor3 = Library.Theme[LabelColor]
                Items.Circle.Instance.BackgroundColor3 = CircleColor
                Items.Circle.Instance.Size = Small
                Items.Circle.Instance.AnchorPoint = EndAnchor
                Items.Circle.Instance.Position = EndPos
                return
            end

            local Grow = TweenInfo.new(0.14, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local Snap = TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local Fade = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

            Library:Tween({ BackgroundColor3 = Library.Theme[BoxColor] }, Fade, Items.Box.Instance)
            Library:Tween({ TextColor3 = Library.Theme[LabelColor] }, Fade, Items.Label.Instance)
            Library:Tween({ BackgroundColor3 = CircleColor }, Fade, Items.Circle.Instance)

            Items.Circle.Instance.AnchorPoint = StartAnchor
            Items.Circle.Instance.Position = StartPos
            Toggle.GrowTween = Library:Tween({ Size = UDim2.fromOffset(InnerW, 16) }, Grow, Items.Circle.Instance)

            task.delay(0.08, function()
                if Toggle.Token ~= Token then return end

                Items.Circle.Instance.AnchorPoint = EndAnchor
                Items.Circle.Instance.Position = EndPos
                Toggle.SnapTween = Library:Tween({ Size = Small }, Snap, Items.Circle.Instance)
            end)

            task.delay(0.3, function()
                if Toggle.Token ~= Token then return end
                if Items.Circle.Instance.Size == Small then return end

                Items.Circle.Instance.AnchorPoint = EndAnchor
                Items.Circle.Instance.Position = EndPos
                Items.Circle.Instance.Size = Small
            end)
        end

        function Toggle:Set(Bool)
            Toggle.Value = Bool and true or false

            if Toggle.Flag then
                Library.Flags[Toggle.Flag] = Toggle.Value
            end

            Toggle.SetVisual(Toggle.Value, false)
            Library:SafeCall(Toggle.Callback, Toggle.Value)
        end

        function Toggle:Get()
            return Toggle.Value
        end

        Items.Hit:Connect("MouseButton1Down", function()
            Toggle:Set(not Toggle.Value)
        end)

        Toggle.SlotX = -61

        local function TakeSlot(Width)
            local X = Toggle.SlotX
            Toggle.SlotX -= Width + 8
            Items.Label.Instance.Size = UDim2.new(1, Toggle.SlotX - 15, 0, 20)
            return X
        end

        local function SlotIcon(X, Icon)
            local Glyph = MakeImage({
                Parent = Row.Instance,
                Icon = Icon,
                Anchor = Vector2.new(1, 0.5),
                Pos = UDim2.new(1, X, 0.5, 0),
                Size = UDim2.fromOffset(16, 16),
                Color = "DimText",
                Z = 6
            })

            local Hit = MakeButton({
                Parent = Row.Instance,
                Anchor = Vector2.new(1, 0.5),
                Pos = UDim2.new(1, X + 2, 0.5, 0),
                Size = UDim2.fromOffset(22, 22),
                Z = 9
            })

            Hit:OnHover(function()
                Glyph:Tween({ ImageColor3 = Library.Theme.Text })
            end, function()
                Glyph:Tween({ ImageColor3 = Library.Theme.DimText })
            end)

            return Glyph, Hit
        end

        local function SidePlace(Anchor)
            return function(Off)
                local PScale = Library:GetScreenScale()
                local Right = Anchor.AbsolutePosition.X + Anchor.AbsoluteSize.X
                local PX = Right / PScale + 8 + (Off or 0)
                local PY = (Anchor.AbsolutePosition.Y + GuiInset) / PScale - 4

                return UDim2.fromOffset(PX, PY)
            end
        end

        function Toggle:Colorpicker(CParams)
            CParams = CParams or { }

            local Picker = {
                Color = CParams.Default or Library.Theme.Accent,
                Transparency = CParams.Transparency or 0
            }

            local X = TakeSlot(22)
            local Swatch = MakeSwatch(Row.Instance, X, Picker.Color, 6)

            local Inner = MakeColorPopup(function()
                return Swatch.Halo.Instance
            end, CParams.Name or Toggle.Name, Picker.Color, Picker.Transparency, function(Color, Alpha)
                Picker.Color = Color
                Picker.Transparency = Alpha
                Swatch:SetColor(Color, Alpha)

                if CParams.Flag then
                    Library.Flags[CParams.Flag] = {
                        __color = Color:ToHex(),
                        __alpha = Alpha
                    }
                end

                Library:SafeCall(CParams.Callback, Color, Alpha)
            end)

            Swatch.Hit:Connect("MouseButton1Down", function()
                Inner:SetOpen(not Inner.IsOpen)
            end)

            if CParams.Flag then
                Library.SetFlags[CParams.Flag] = function(Color, Alpha)
                    Inner:Set(Color, Alpha)
                end
            end

            function Picker:Set(Color, Alpha)
                Inner:Set(Color, Alpha)
            end

            Picker.Picker = Inner
            return Picker
        end

        function Toggle:Keybind(KParams)
            KParams = KParams or { }

            local Keybind = {
                Key = KParams.Default,
                Mode = KParams.Mode or "Toggle",
                Flag = KParams.Flag,
                Picking = false,
                IsOpen = false,
                Debounce = false
            }

            local X = TakeSlot(20)
            local BindIcon, BindHit = SlotIcon(X, "command")

            local PanelW = 160

            local Panel = MakeFrame({
                Parent = Library.UnusedHolder.Instance,
                Size = UDim2.fromOffset(PanelW, 128),
                Color = "Section",
                Round = 8,
                Z = 40
            })

            Panel.Instance.Visible = false

            MakeText({
                Parent = Panel.Instance,
                Text = "Keybind",
                TextSize = 12,
                Pos = UDim2.fromOffset(11, 7),
                Size = UDim2.fromOffset(PanelW - 22, 14),
                Color = "DimText",
                Z = 41
            })

            local KeyBox = MakeFrame({
                Parent = Panel.Instance,
                Pos = UDim2.fromOffset(8, 26),
                Size = UDim2.fromOffset(PanelW - 16, 26),
                Color = "Light",
                Round = 5,
                Z = 41
            })

            local PanelKey = MakeText({
                Parent = KeyBox.Instance,
                Text = "None",
                TextSize = 13,
                Size = UDim2.new(1, 0, 1, 0),
                Color = "Text",
                Align = Enum.TextXAlignment.Center,
                Truncate = true,
                Z = 42
            })

            local KeyHit = MakeButton({
                Parent = KeyBox.Instance,
                Z = 43
            })

            local ModeRows = { }

            local function ModeRow(Y, ModeName)
                local Built = MakeAccentRow({
                    Parent = Panel.Instance,
                    Pos = UDim2.fromOffset(8, Y),
                    Size = UDim2.fromOffset(PanelW - 16, 28),
                    Color = "Element",
                    Text = ModeName,
                    TextSize = 13,
                    LabelSize = UDim2.new(1, -18, 1, 0),
                    LineX = 6,
                    LineH = 14,
                    TextX = 10,
                    TextActiveX = 17,
                    SnapShadow = true,
                    Z = 41
                })

                Built.Hit:Connect("MouseButton1Down", function()
                    Keybind:SetMode(ModeName)
                end)

                table.insert(ModeRows, {
                    Name = ModeName,
                    SetActive = Built.SetActive
                })
            end

            ModeRow(60, "Toggle")
            ModeRow(92, "Hold")

            local function SaveFlag()
                if not Keybind.Flag then return end

                Library.Flags[Keybind.Flag] = {
                    Key = Keybind.Key and tostring(Keybind.Key) or "None",
                    Mode = Keybind.Mode
                }
            end

            function Keybind:SetMode(Mode, Instant)
                Keybind.Mode = Mode

                for _, Data in ModeRows do
                    Data.SetActive(Data.Name == Mode, Instant)
                end

                SaveFlag()
            end

            function Keybind:Set(Key)
                Keybind.Key = Key
                PanelKey.Instance.Text = KeyName(Key)
                Keybind.Picking = false

                SaveFlag()
            end

            AttachPopup({
                Popup = Keybind,
                Frame = Panel,
                Level = 40,
                GetAnchor = function()
                    return BindHit.Instance
                end,
                Place = SidePlace(BindIcon.Instance),
                From = -6,
                To = 2,
                Retreat = RetreatLeft
            })

            BindHit:Connect("MouseButton1Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)

            KeyHit:Connect("MouseButton1Click", function()
                CaptureKey(Keybind, PanelKey.Instance, function(Key)
                    Keybind:Set(Key)
                end)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input, Processed)
                if Processed or Keybind.Picking or not Keybind.Key then return end
                if not KeyMatches(Input, Keybind.Key) then return end

                if Keybind.Mode == "Hold" then
                    Toggle:Set(true)
                else
                    Toggle:Set(not Toggle.Value)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Keybind.Mode ~= "Hold" or not Keybind.Key then return end
                if not KeyMatches(Input, Keybind.Key) then return end

                Toggle:Set(false)
            end)

            if Keybind.Flag then
                Library.SetFlags[Keybind.Flag] = function(Value)
                    if type(Value) == "table" then
                        if Value.Mode then Keybind:SetMode(Value.Mode, true) end
                        Value = Value.Key
                    end

                    Keybind:Set(ParseKey(Value))
                end
            end

            Keybind:SetMode(Keybind.Mode, true)
            Keybind:Set(Keybind.Key)

            return Keybind
        end

        function Toggle:Extra(EParams)
            EParams = EParams or { }

            if Toggle.ExtraPanel then
                return Toggle.ExtraPanel
            end

            local Extra = {
                IsOpen = false,
                Debounce = false,
                NextY = 30,
                Width = EParams.Width or 220
            }

            local X = TakeSlot(20)
            local ExtraIcon, ExtraHit = SlotIcon(X, "settings-2")

            local Frame = MakeFrame({
                Parent = Library.UnusedHolder.Instance,
                Size = UDim2.fromOffset(Extra.Width, 38),
                Color = "Section",
                Round = 8,
                Z = 2
            })

            Frame.Instance.Visible = false

            MakeText({
                Parent = Frame.Instance,
                Text = Toggle.Name,
                TextSize = 12,
                Pos = UDim2.fromOffset(12, 8),
                Size = UDim2.fromOffset(Extra.Width - 24, 14),
                Color = "DimText",
                Truncate = true,
                Z = 3
            })

            local ChildDim = MakeFrame({
                Parent = Frame.Instance,
                Size = UDim2.new(1, 0, 1, 0),
                Raw = Color3.new(0, 0, 0),
                Alpha = 1,
                Round = 8,
                Z = 30
            })

            ChildDim.Instance.Visible = false
            Library:StampResting(ChildDim.Instance, "BackgroundTransparency", 1)

            local DimShown = false

            function Extra.SetChildDim(Bool)
                if DimShown == Bool then return end
                DimShown = Bool

                local Info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local Target = Bool and 0.5 or 1

                Library:StampResting(ChildDim.Instance, "BackgroundTransparency", Target)

                if Bool then
                    ChildDim.Instance.Visible = true
                end

                Library:Tween({ BackgroundTransparency = Target }, Info, ChildDim.Instance)

                if Bool then return end

                task.delay(0.24, function()
                    if not DimShown then ChildDim.Instance.Visible = false end
                end)
            end

            function Extra:AddRow(Height, SearchName)
                local RowFrame = MakeFrame({
                    Parent = Frame.Instance,
                    Pos = UDim2.fromOffset(0, Extra.NextY),
                    Size = UDim2.fromOffset(Extra.Width, Height),
                    Z = 3
                })

                local Data = {
                    Frame = RowFrame,
                    Height = Height,
                    Y = Extra.NextY,
                    Visible = true,
                    Name = SearchName or Toggle.Name
                }

                Extra.NextY += Height
                Frame.Instance.Size = UDim2.fromOffset(Extra.Width, Extra.NextY + 8)

                return RowFrame, Data
            end

            local function HasOpenChild()
                for _, Value in Library.OpenFrames do
                    if Value.Host == Extra then return true end
                end

                return false
            end

            AttachPopup({
                Popup = Extra,
                Frame = Frame,
                Level = 2,
                GetAnchor = function()
                    return ExtraHit.Instance
                end,
                Place = SidePlace(ExtraIcon.Instance),
                From = -6,
                To = 2,
                Retreat = RetreatLeft,
                KeepOpen = function(Value)
                    return Value == Extra or Value.Host == Extra
                end,
                HoldOpen = HasOpenChild,
                OnClose = function()
                    for _, Value in Library.OpenFrames do
                        if Value.Host == Extra then Value:SetOpen(false) end
                    end
                end
            })

            ExtraHit:Connect("MouseButton1Down", function()
                Extra:SetOpen(not Extra.IsOpen)
            end)

            setmetatable(Extra, {
                __index = function(_, Key)
                    local Builder = Library[Key]
                    if type(Builder) ~= "function" then return nil end

                    return function(SelfArg, BuildParams)
                        local Element = Builder(SelfArg, BuildParams)

                        if type(Element) == "table" then
                            if rawget(Element, "Popup") then Element.Popup.Host = Extra end
                            if rawget(Element, "Picker") then Element.Picker.Host = Extra end
                        end

                        return Element
                    end
                end
            })

            Toggle.ExtraPanel = Extra
            return Extra
        end

        Toggle.Value = Toggle.Default

        if Toggle.Flag then
            Library.Flags[Toggle.Flag] = Toggle.Value

            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end
        end

        Toggle.SetVisual(Toggle.Value, true)
        Library:SafeCall(Toggle.Callback, Toggle.Value)

        return setmetatable(Toggle, Library)
    end

    local SlideInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local KnobColor = Color3.fromRGB(197, 197, 197)

    local function MakeKnob(Parent)
        local Knob = MakeFrame({
            Parent = Parent,
            Anchor = Vector2.new(0.5, 0.5),
            Pos = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(13, 13),
            Raw = KnobColor,
            Round = 20,
            Z = 7
        })

        MakeShadow(Knob.Instance, KnobColor, UDim2.fromOffset(0, 0), UDim.new(0, 5), 0.5)
        return Knob
    end

    local function BuildSliderRow(Section, Name, SearchName)
        local Row = Section:AddRow(44, SearchName or Name)
        local Items = { Row = Row }

        Items.Label = MakeText({
            Parent = Row.Instance,
            Text = Name,
            TextSize = 15,
            Pos = UDim2.fromOffset(15, 3),
            Size = UDim2.new(1, -120, 0, 20),
            Color = "Text",
            Truncate = true,
            Z = 5
        })

        Items.Value = MakeText({
            Parent = Row.Instance,
            Text = "",
            TextSize = 15,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, -15, 0, 3),
            Size = UDim2.fromOffset(100, 20),
            Color = "DimText",
            Align = Enum.TextXAlignment.Right,
            Truncate = true,
            Z = 5
        })

        Items.Track = MakeFrame({
            Parent = Row.Instance,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 15, 0, 32),
            Size = UDim2.new(1, -30, 0, 10),
            Color = "Element",
            Round = 20,
            Z = 5
        })

        Items.Fill = MakeFrame({
            Parent = Items.Track.Instance,
            Size = UDim2.fromOffset(0, 10),
            Raw = Color3.new(1, 1, 1),
            Round = 20,
            Z = 6
        })

        Library:RegisterGradient(Library:Create("UIGradient", {
            Parent = Items.Fill.Instance
        }).Instance)

        Items.Hit = MakeButton({
            Parent = Row.Instance,
            Pos = UDim2.fromOffset(9, 22),
            Size = UDim2.new(1, -18, 0, 22),
            Z = 8
        })

        return Items
    end

    Library.Slider = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Slider = {
            Name = Params.Name or "Slider",
            Min = Params.Min or 0,
            Max = Params.Max or 100,
            Default = Params.Default or 0,
            Decimals = Params.Decimals or 1,
            Suffix = Params.Suffix or "",
            Flag = Params.Flag,
            Callback = Params.Callback or function() end,
            Value = 0,
            Sliding = false
        }

        local Items = BuildSliderRow(Section, Slider.Name)

        Slider.Items = Items
        Items.Knob = MakeKnob(Items.Track.Instance)

        function Slider:Set(Value, Instant)
            local Clamped = math.clamp(Value, Slider.Min, Slider.Max)
            Slider.Value = Library:Round(Clamped, Slider.Decimals)

            if Slider.Flag then
                Library.Flags[Slider.Flag] = Slider.Value
            end

            local Span = Slider.Max - Slider.Min
            local Fraction = Span == 0 and 0 or (Slider.Value - Slider.Min) / Span
            local Info = Instant and TweenInfo.new(0) or SlideInfo

            Library:Tween({ Size = UDim2.new(Fraction, 0, 0, 10) }, Info, Items.Fill.Instance)
            Library:Tween({ Position = UDim2.new(Fraction, 0, 0.5, 0) }, Info, Items.Knob.Instance)

            Items.Value.Instance.Text = tostring(Slider.Value) .. Slider.Suffix
            Library:SafeCall(Slider.Callback, Slider.Value)
        end

        function Slider:Get()
            return Slider.Value
        end

        local function Calculate(Input)
            local Fraction = AxisFraction(Input, Items.Track.Instance, "X")
            return Slider.Min + (Slider.Max - Slider.Min) * Fraction
        end

        local function Apply(Input)
            Slider:Set(Calculate(Input))
        end

        AttachDrag(Items.Hit, {
            OnGrab = function(Input)
                Slider.Sliding = true
                Apply(Input)
            end,
            OnMove = Apply,
            OnRelease = function()
                Slider.Sliding = false
            end
        })

        Slider:Set(Slider.Default, true)

        if Slider.Flag then
            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end
        end

        return setmetatable(Slider, Library)
    end

    Library.RangeSlider = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Slider = {
            Name = Params.Name or "Range",
            Min = Params.Min or 0,
            Max = Params.Max or 100,
            Default = Params.Default,
            Decimals = Params.Decimals or 1,
            Suffix = Params.Suffix or "",
            Flag = Params.Flag,
            Callback = Params.Callback or function() end,
            Value = { 0, 0 },
            Grabbing = nil
        }

        Slider.MinGap = Params.MinGap or Slider.Decimals
        Slider.Default = Slider.Default or { Slider.Min, Slider.Max }

        local Items = BuildSliderRow(Section, Slider.Name)

        Slider.Items = Items
        Items.MinKnob = MakeKnob(Items.Track.Instance)
        Items.MaxKnob = MakeKnob(Items.Track.Instance)

        local function Normalize(Value)
            local Span = Slider.Max - Slider.Min
            return Span == 0 and 0 or (Value - Slider.Min) / Span
        end

        function Slider:Set(MinValue, MaxValue, Instant)
            if type(MinValue) == "table" then
                MinValue, MaxValue = MinValue[1], MinValue[2]
            end

            MinValue = math.clamp(MinValue or Slider.Min, Slider.Min, Slider.Max)
            MaxValue = math.clamp(MaxValue or Slider.Max, Slider.Min, Slider.Max)

            MinValue = Library:Round(MinValue, Slider.Decimals)
            MaxValue = Library:Round(MaxValue, Slider.Decimals)

            if MinValue > MaxValue then
                MinValue, MaxValue = MaxValue, MinValue
            end

            Slider.Value = { MinValue, MaxValue }

            if Slider.Flag then
                Library.Flags[Slider.Flag] = Slider.Value
            end

            local MinF = Normalize(MinValue)
            local MaxF = Normalize(MaxValue)
            local Info = Instant and TweenInfo.new(0) or SlideInfo

            Library:Tween({
                Position = UDim2.new(MinF, 0, 0, 0),
                Size = UDim2.new(MaxF - MinF, 0, 0, 10)
            }, Info, Items.Fill.Instance)

            Library:Tween({ Position = UDim2.new(MinF, 0, 0.5, 0) }, Info, Items.MinKnob.Instance)
            Library:Tween({ Position = UDim2.new(MaxF, 0, 0.5, 0) }, Info, Items.MaxKnob.Instance)

            local Text = tostring(MinValue) .. Slider.Suffix
            Text = Text .. " - " .. tostring(MaxValue) .. Slider.Suffix

            Items.Value.Instance.Text = Text
            Library:SafeCall(Slider.Callback, Slider.Value)
        end

        function Slider:Get()
            return Slider.Value
        end

        local function Apply(Input)
            local Point = AxisFraction(Input, Items.Track.Instance, "X")
            local Value = Slider.Min + (Slider.Max - Slider.Min) * Point

            if Slider.Grabbing == "Min" then
                Slider:Set(math.min(Value, Slider.Value[2] - Slider.MinGap), Slider.Value[2])
            else
                Slider:Set(Slider.Value[1], math.max(Value, Slider.Value[1] + Slider.MinGap))
            end
        end

        AttachDrag(Items.Hit, {
            OnGrab = function(Input)
                local Point = AxisFraction(Input, Items.Track.Instance, "X")
                local MinF = Normalize(Slider.Value[1])
                local MaxF = Normalize(Slider.Value[2])

                Slider.Grabbing = math.abs(Point - MinF) <= math.abs(Point - MaxF) and "Min" or "Max"
                Apply(Input)
            end,
            OnMove = Apply,
            OnRelease = function()
                Slider.Grabbing = nil
            end
        })

        Slider:Set(Slider.Default[1], Slider.Default[2], true)

        if Slider.Flag then
            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end
        end

        return setmetatable(Slider, Library)
    end

    local function MakeFieldRow(Section, Name, SearchName)
        local Row = Section:AddRow(54, SearchName or Name)
        local Items = { Row = Row }

        Items.Label = MakeText({
            Parent = Row.Instance,
            Text = Name,
            TextSize = 15,
            Pos = UDim2.fromOffset(15, 4),
            Size = UDim2.new(1, -30, 0, 18),
            Color = "DimText",
            Truncate = true,
            Z = 5
        })

        Items.Box = MakeFrame({
            Parent = Row.Instance,
            Pos = UDim2.fromOffset(15, 24),
            Size = UDim2.new(1, -30, 0, 30),
            Color = "Element",
            Round = 6,
            Clip = true,
            Z = 5
        })

        return Items
    end

    local function MakeSweep(Parent, Z)
        local Sweep = MakeFrame({
            Parent = Parent,
            Anchor = Vector2.new(0.5, 0.5),
            Pos = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 0, 1, 0),
            Color = "Accent",
            Round = 6,
            Z = Z
        })

        Sweep.Instance.BackgroundTransparency = 1
        Library:StampResting(Sweep.Instance, "BackgroundTransparency", 1)

        return Sweep
    end

    local function PlaySweep(Sweep)
        local In = TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local Out = TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        Sweep.Size = UDim2.new(0, 0, 1, 0)
        Sweep.BackgroundTransparency = 1

        Library:Tween({
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 0.15
        }, In, Sweep)

        task.delay(0.17, function()
            Library:Tween({
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundTransparency = 1
            }, Out, Sweep)
        end)
    end

    local function HoverSwap(Frame)
        Frame:OnHover(function()
            Frame:Tween({ BackgroundColor3 = Library.Theme.Hover })
        end, function()
            Frame:Tween({ BackgroundColor3 = Library.Theme.Element })
        end)
    end

    Library.Dropdown = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Dropdown = {
            Name = Params.Name or "Dropdown",
            Options = Params.Items or Params.Options or { },
            Default = Params.Default,
            Multi = Params.Multi or false,
            Flag = Params.Flag,
            Callback = Params.Callback or function() end,
            Value = nil,
            Items = { }
        }

        if Dropdown.Multi then
            Dropdown.Value = { }
        end

        local Items = MakeFieldRow(Section, Dropdown.Name)

        Items.Selected = MakeText({
            Parent = Items.Box.Instance,
            Text = "None",
            TextSize = 15,
            Pos = UDim2.fromOffset(11, 0),
            Size = UDim2.new(1, -34, 1, 0),
            Color = "Text",
            Truncate = true,
            Z = 6
        })

        Items.Arrow = MakeImage({
            Parent = Items.Box.Instance,
            Icon = "chevron-down",
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -10, 0.5, 0),
            Size = UDim2.fromOffset(14, 14),
            Color = "DimText",
            Z = 6
        })

        Items.Hit = MakeButton({
            Parent = Items.Box.Instance,
            Z = 7
        })

        Dropdown.Items = Items

        local Popup = MakeOptionPopup(function()
            return Items.Box.Instance
        end)

        Popup.OnState = function(Open)
            Items.Arrow:Tween({ Rotation = Open and 180 or 0 })
        end

        Dropdown.Popup = Popup

        local function Report()
            if Dropdown.Flag then
                Library.Flags[Dropdown.Flag] = Dropdown.Value
            end

            if Dropdown.Multi then
                Items.Selected.Instance.Text = #Dropdown.Value > 0
                and table.concat(Dropdown.Value, ", ")
                or "None"
            else
                Items.Selected.Instance.Text = Dropdown.Value ~= nil
                and tostring(Dropdown.Value)
                or "None"
            end

            Library:SafeCall(Dropdown.Callback, Dropdown.Value)
        end

        Popup.OnPick = function(Data)
            if Dropdown.Multi then
                local Index = table.find(Dropdown.Value, Data.Name)

                if Index then
                    table.remove(Dropdown.Value, Index)
                    Data:Set(false)
                else
                    table.insert(Dropdown.Value, Data.Name)
                    Data:Set(true)
                end
            else
                Dropdown.Value = Data.Name

                for _, Other in Popup.Order do
                    Other:Set(Other == Data)
                end
            end

            Report()
        end

        function Dropdown:Refresh(List)
            Popup:Clear()
            Dropdown.Options = List

            for _, Option in List do
                Popup:AddRow(tostring(Option))
            end
        end

        function Dropdown:Set(Value)
            if Dropdown.Multi then
                if type(Value) ~= "table" then return end

                Dropdown.Value = Value

                for _, Data in Popup.Order do
                    Data:Set(table.find(Value, Data.Name) ~= nil, true)
                end
            else
                local Found = false

                for _, Data in Popup.Order do
                    if Data.Name == Value then Found = true end
                end

                if not Found then return end

                Dropdown.Value = Value

                for _, Data in Popup.Order do
                    Data:Set(Data.Name == Value, true)
                end
            end

            Report()
        end

        function Dropdown:Get()
            return Dropdown.Value
        end

        Items.Hit:Connect("MouseButton1Down", function()
            Popup:SetOpen(not Popup.IsOpen)
        end)

        HoverSwap(Items.Box)

        for _, Option in Dropdown.Options do
            Popup:AddRow(tostring(Option))
        end

        if Dropdown.Default ~= nil then
            Dropdown:Set(Dropdown.Default)
        end

        if Dropdown.Flag then
            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end
        end

        return setmetatable(Dropdown, Library)
    end

    Library.Button = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Button = {
            Name = Params.Name or "Button",
            Callback = Params.Callback or function() end,
            Items = { }
        }

        local Row = Section:AddRow(36, Button.Name)
        local Items = { Row = Row }

        Items.Frame = MakeFrame({
            Parent = Row.Instance,
            Pos = UDim2.fromOffset(15, 3),
            Size = UDim2.new(1, -30, 0, 30),
            Color = "Element",
            Round = 6,
            Clip = true,
            Z = 5
        })

        Items.Sweep = MakeSweep(Items.Frame.Instance, 6)

        Items.Label = MakeText({
            Parent = Items.Frame.Instance,
            Text = Button.Name,
            TextSize = 15,
            Size = UDim2.new(1, 0, 1, 0),
            Color = "Text",
            Align = Enum.TextXAlignment.Center,
            Truncate = true,
            Z = 7
        })

        Items.Hit = MakeButton({
            Parent = Items.Frame.Instance,
            Z = 8
        })

        Button.Items = Items
        HoverSwap(Items.Frame)

        function Button:Press()
            PlaySweep(Items.Sweep.Instance)
            Library:SafeCall(Button.Callback)
        end

        function Button:SetText(Text)
            Items.Label.Instance.Text = tostring(Text)
        end

        Items.Hit:Connect("MouseButton1Down", function()
            Button:Press()
        end)

        return setmetatable(Button, Library)
    end

    Library.Textbox = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Textbox = {
            Name = Params.Name or "Textbox",
            Default = Params.Default or "",
            Placeholder = Params.Placeholder or "...",
            Finished = Params.Finished or false,
            Flag = Params.Flag,
            Callback = Params.Callback or function() end,
            Value = "",
            Items = { }
        }

        local Items = MakeFieldRow(Section, Textbox.Name)

        Items.Input = MakeInput({
            Parent = Items.Box.Instance,
            Placeholder = Textbox.Placeholder,
            Pos = UDim2.fromOffset(11, 0),
            Size = UDim2.new(1, -22, 1, 0),
            TextSize = 15,
            Z = 6
        })

        Textbox.Items = Items

        function Textbox:Set(Value)
            Textbox.Value = tostring(Value)
            Items.Input.Instance.Text = Textbox.Value

            if Textbox.Flag then
                Library.Flags[Textbox.Flag] = Textbox.Value
            end

            Library:SafeCall(Textbox.Callback, Textbox.Value)
        end

        function Textbox:Get()
            return Textbox.Value
        end

        if Textbox.Finished then
            Items.Input:Connect("FocusLost", function(Enter)
                if Enter then
                    Textbox:Set(Items.Input.Instance.Text)
                end
            end)
        else
            Library:Connect(Items.Input.Instance:GetPropertyChangedSignal("Text"), function()
                Textbox:Set(Items.Input.Instance.Text)
            end)
        end

        if Textbox.Default ~= "" then
            Textbox:Set(Textbox.Default)
        end

        if Textbox.Flag then
            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end
        end

        return setmetatable(Textbox, Library)
    end

    Library.Keybind = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Keybind = {
            Name = Params.Name or "Keybind",
            Key = Params.Default,
            Flag = Params.Flag,
            Callback = Params.Callback or function() end,
            Picking = false,
            IsOpen = false,
            Debounce = false,
            Items = { }
        }

        local Row = Section:AddRow(32, Keybind.Name)
        local Items = { Row = Row }

        Items.Label = MakeText({
            Parent = Row.Instance,
            Text = Keybind.Name,
            TextSize = 15,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 14, 0.5, 0),
            Size = UDim2.new(1, -60, 0, 20),
            Color = "Text",
            Truncate = true,
            Z = 5
        })

        Items.Icon = MakeImage({
            Parent = Row.Instance,
            Icon = "command",
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -16, 0.5, 0),
            Size = UDim2.fromOffset(16, 16),
            Color = "DimText",
            Z = 6
        })

        Items.Hit = MakeButton({
            Parent = Row.Instance,
            Anchor = Vector2.new(1, 0.5),
            Pos = UDim2.new(1, -8, 0.5, 0),
            Size = UDim2.fromOffset(30, 26),
            Z = 8
        })

        Items.Hit:OnHover(function()
            Items.Icon:Tween({ ImageColor3 = Library.Theme.Text })
        end, function()
            Items.Icon:Tween({ ImageColor3 = Library.Theme.DimText })
        end)

        Keybind.Items = Items

        local PanelW = 170

        local Panel = MakeFrame({
            Parent = Library.UnusedHolder.Instance,
            Size = UDim2.fromOffset(PanelW, 72),
            Color = "Section",
            Round = 8,
            Z = 40
        })

        Panel.Instance.Visible = false

        MakeText({
            Parent = Panel.Instance,
            Text = Keybind.Name,
            TextSize = 12,
            Pos = UDim2.fromOffset(11, 8),
            Size = UDim2.fromOffset(PanelW - 22, 14),
            Color = "DimText",
            Truncate = true,
            Z = 41
        })

        local KeyBox = MakeFrame({
            Parent = Panel.Instance,
            Pos = UDim2.fromOffset(9, 32),
            Size = UDim2.fromOffset(PanelW - 18, 30),
            Color = "Light",
            Round = 5,
            Clip = true,
            Z = 41
        })

        local PanelKey = MakeText({
            Parent = KeyBox.Instance,
            Text = "None",
            TextSize = 13,
            Size = UDim2.new(1, 0, 1, 0),
            Color = "Text",
            Align = Enum.TextXAlignment.Center,
            Truncate = true,
            Z = 42
        })

        local KeyHit = MakeButton({
            Parent = KeyBox.Instance,
            Z = 43
        })

        function Keybind:Set(Key)
            Keybind.Key = Key
            PanelKey.Instance.Text = KeyName(Key)
            Keybind.Picking = false

            if Keybind.Flag then
                Library.Flags[Keybind.Flag] = Key and tostring(Key) or "None"
            end
        end

        function Keybind:Get()
            return Keybind.Key
        end

        AttachPopup({
            Popup = Keybind,
            Frame = Panel,
            Level = 40,
            GetAnchor = function()
                return Items.Hit.Instance
            end,
            Place = function(Off)
                local Anchor = Items.Icon.Instance
                local PScale = Library:GetScreenScale()
                local Right = Anchor.AbsolutePosition.X + Anchor.AbsoluteSize.X
                local PX = Right / PScale + 8 + (Off or 0)
                local PY = (Anchor.AbsolutePosition.Y + GuiInset) / PScale - 4

                return UDim2.fromOffset(PX, PY)
            end,
            From = -6,
            To = 2,
            Retreat = RetreatLeft
        })

        Items.Hit:Connect("MouseButton1Down", function()
            Keybind:SetOpen(not Keybind.IsOpen)
        end)

        KeyHit:Connect("MouseButton1Click", function()
            CaptureKey(Keybind, PanelKey.Instance, function(Key)
                Keybind:Set(Key)
            end)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input, Processed)
            if Processed or Keybind.Picking or not Keybind.Key then return end
            if not KeyMatches(Input, Keybind.Key) then return end

            Library:SafeCall(Keybind.Callback, Keybind.Key)
        end)

        Keybind:Set(Keybind.Key)

        if Keybind.Flag then
            Library.SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(ParseKey(Value))
            end
        end

        return setmetatable(Keybind, Library)
    end

    Library.Colorpicker = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Colorpicker = {
            Name = Params.Name or "Color",
            Default = Params.Default or Library.Theme.Accent,
            Transparency = Params.Transparency or 0,
            Flag = Params.Flag,
            Callback = Params.Callback or function() end,
            Color = Params.Default or Library.Theme.Accent,
            Items = { }
        }

        local Row = Section:AddRow(32, Colorpicker.Name)
        local Items = { Row = Row }

        Items.Label = MakeText({
            Parent = Row.Instance,
            Text = Colorpicker.Name,
            TextSize = 15,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 14, 0.5, 0),
            Size = UDim2.new(1, -60, 0, 20),
            Color = "Text",
            Truncate = true,
            Z = 5
        })

        Items.Swatch = MakeSwatch(Row.Instance, -13, Colorpicker.Default, 5)
        Colorpicker.Items = Items

        local Picker = MakeColorPopup(function()
            return Items.Swatch.Halo.Instance
        end, Colorpicker.Name, Colorpicker.Default, Colorpicker.Transparency, function(Color, Alpha)
            Colorpicker.Color = Color
            Colorpicker.Transparency = Alpha
            Items.Swatch:SetColor(Color, Alpha)

            if Colorpicker.Flag then
                Library.Flags[Colorpicker.Flag] = {
                    __color = Color:ToHex(),
                    __alpha = Alpha
                }
            end

            Library:SafeCall(Colorpicker.Callback, Color, Alpha)
        end)

        Colorpicker.Picker = Picker

        function Colorpicker:Set(Color, Alpha)
            Picker:Set(Color, Alpha)
        end

        function Colorpicker:Get()
            return Colorpicker.Color, Colorpicker.Transparency
        end

        Items.Swatch.Hit:Connect("MouseButton1Down", function()
            Picker:SetOpen(not Picker.IsOpen)
        end)

        if Colorpicker.Flag then
            Library.SetFlags[Colorpicker.Flag] = function(Color, Alpha)
                Picker:Set(Color, Alpha)
            end
        end

        return setmetatable(Colorpicker, Library)
    end

    Library.Label = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Label = {
            Name = Params.Name or "Label",
            Items = { }
        }

        local Row = Section:AddRow(24, Label.Name)

        Label.Items.Text = MakeText({
            Parent = Row.Instance,
            Text = Label.Name,
            TextSize = 15,
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 14, 0.5, 0),
            Size = UDim2.new(1, -28, 0, 20),
            Color = "DimText",
            Truncate = true,
            Z = 5
        })

        function Label:Set(Text)
            Label.Items.Text.Instance.Text = tostring(Text)
        end

        return setmetatable(Label, Library)
    end

    Library.Paragraph = function(Self, Params)
        Params = Params or { }

        local Section = Self

        local Paragraph = {
            Title = Params.Title or Params.Name or "Paragraph",
            Content = Params.Content or "",
            Items = { }
        }

        local Width = Section.Width - 28
        local TitleBounds = MeasureText(Paragraph.Title, 15, Width, UiFont)
        local BodyBounds = MeasureText(Paragraph.Content, 14, Width, UiFont)
        local Total = TitleBounds.Y + BodyBounds.Y + 16

        local Row, Data = Section:AddRow(Total, Paragraph.Title .. " " .. Paragraph.Content)

        local function Block(Text, TextSize, Y, Height, Color)
            local Item = MakeText({
                Parent = Row.Instance,
                Text = Text,
                TextSize = TextSize,
                Pos = UDim2.fromOffset(14, Y),
                Size = UDim2.new(1, -28, 0, Height),
                Color = Color,
                Wrap = true,
                Z = 5
            })

            Item.Instance.TextYAlignment = Enum.TextYAlignment.Top
            return Item
        end

        Paragraph.Items.Title = Block(Paragraph.Title, 15, 6, TitleBounds.Y, "Text")
        Paragraph.Items.Body = Block(Paragraph.Content, 14, TitleBounds.Y + 8, BodyBounds.Y, "DimText")

        local function Remeasure(NewWidth)
            local Wrap = (NewWidth or Section.Width) - 28
            local Title = MeasureText(Paragraph.Title, 15, Wrap, UiFont)
            local Body = MeasureText(Paragraph.Content, 14, Wrap, UiFont)
            local Height = Title.Y + Body.Y + 16

            Paragraph.Items.Title.Instance.Position = UDim2.fromOffset(14, 6)
            Paragraph.Items.Title.Instance.Size = UDim2.new(1, -28, 0, Title.Y)
            Paragraph.Items.Body.Instance.Position = UDim2.fromOffset(14, Title.Y + 8)
            Paragraph.Items.Body.Instance.Size = UDim2.new(1, -28, 0, Body.Y)

            Data.Height = Height
            Row.Instance.Size = UDim2.new(1, 0, 0, Height)

            if Section.Reflow then Section:Reflow() end
        end

        Data.OnWidth = Remeasure

        function Paragraph:SetTitle(Text)
            Paragraph.Title = tostring(Text)
            Paragraph.Items.Title.Instance.Text = Paragraph.Title
            Remeasure(Section.Width)
        end

        function Paragraph:SetContent(Text)
            Paragraph.Content = tostring(Text)
            Paragraph.Items.Body.Instance.Text = Paragraph.Content
            Remeasure(Section.Width)
        end

        return setmetatable(Paragraph, Library)
    end

    do
        local PreviewCache = getgenv().PulseEspPreviewCache

        if type(PreviewCache) ~= "table" then
            PreviewCache = { Models = { }, Failures = { } }
            getgenv().PulseEspPreviewCache = PreviewCache
        end

        local Previews = { }
        local Driver = nil
        local MaxStud = 40

        local EspDefaults = {
            Box = true,
            Corners = true,
            Fill = false,
            FillAlpha = 0.22,
            Outline = false,
            OutlineFill = 0.72,
            Health = true,
            Name = true,
            Role = true,
            Distance = true,
            Tracer = false,
            TracerFrom = "bottom",
            TextSize = 13,
            NameText = "mauszyx",
            RoleText = "Civilian",
            DistanceText = 42,
            Color = Color3.fromRGB(120, 230, 140),
            Demo = true
        }

        local function IsUsable(Model)
            if typeof(Model) ~= "Instance" then return false end

            local Ok, Result = pcall(function()
                return Model.Parent == nil and #Model:GetChildren() > 0
            end)

            return Ok and Result == true
        end

        local function FetchRig(BundleId)
            local Key = tostring(BundleId)

            if IsUsable(PreviewCache.Models[Key]) then
                return PreviewCache.Models[Key]
            end

            local Failed = PreviewCache.Failures[Key]
            if Failed then return nil, Failed end

            local function Fail(Reason)
                PreviewCache.Failures[Key] = Reason
                return nil, Reason
            end

            local Bundle
            local Ok = pcall(function()
                Bundle = AssetService:GetBundleDetailsAsync(BundleId)
            end)

            if not Ok or type(Bundle) ~= "table" or type(Bundle.Items) ~= "table" then
                return Fail("bundle")
            end

            local OutfitId

            for _, Item in Bundle.Items do
                if Item.Type == "UserOutfit" then
                    OutfitId = Item.Id
                    break
                end
            end

            if not OutfitId then return Fail("outfit") end

            local Description
            Ok = pcall(function()
                Description = Players:GetHumanoidDescriptionFromOutfitId(OutfitId)
            end)

            if not Ok or typeof(Description) ~= "Instance" then return Fail("outfit") end

            local Model
            Ok = pcall(function()
                Model = Players:CreateHumanoidModelFromDescription(Description, Enum.HumanoidRigType.R15)
            end)

            if not Ok or typeof(Model) ~= "Instance" then return Fail("rig") end

            for _, Child in Model:GetDescendants() do
                if Child:IsA("LuaSourceContainer") or Child:IsA("Humanoid") then
                    Child:Destroy()
                end
            end

            Model.Parent = nil
            PreviewCache.Models[Key] = Model

            return Model
        end

        local function FlattenShell(Model, Colour)
            for _, Child in Model:GetDescendants() do
                if Child:IsA("BasePart") then
                    if Child.Transparency >= 1 or Child.Name == "HumanoidRootPart" then
                        Child.Transparency = 1
                    else
                        Child.Color = Colour
                        Child.Material = Enum.Material.Neon
                        Child.Transparency = 0
                        Child.Reflectance = 0
                        pcall(function() Child.TextureID = "" end)
                    end

                    Child.Anchored = true
                    Child.CastShadow = false
                    Child.CanCollide = false
                    Child.CanQuery = false
                    Child.CanTouch = false
                elseif Child:IsA("Decal") or Child:IsA("Texture") or Child:IsA("SurfaceAppearance")
                    or Child:IsA("ParticleEmitter") or Child:IsA("Beam") or Child:IsA("Trail")
                    or Child:IsA("Light") or Child:IsA("LayerCollector") or Child:IsA("Fire")
                    or Child:IsA("Smoke") or Child:IsA("Sparkles") then
                    pcall(function() Child:Destroy() end)
                end
            end
        end

        local function GrowShell(Model, Thickness)
            local Bulk = Vector3.new(Thickness, Thickness, Thickness)

            for _, Child in Model:GetDescendants() do
                if not Child:IsA("BasePart") then continue end

                local Mesh = Child:FindFirstChildWhichIsA("SpecialMesh")

                if Mesh then
                    local Span = math.max(Child.Size.X, Child.Size.Y, Child.Size.Z, 0.05)
                    Mesh.Scale *= 1 + Thickness / Span
                else
                    Child.Size += Bulk
                end
            end
        end

        local function MeasureRig(Model)
            local Low, High

            for _, Child in Model:GetDescendants() do
                if not Child:IsA("BasePart") then continue end
                if Child.Name == "HumanoidRootPart" then continue end
                if Child.Transparency >= 1 then continue end

                local Pose, Span = Child.CFrame, Child.Size

                local Reach = Vector3.new(
                    math.abs(Pose.RightVector.X) * Span.X + math.abs(Pose.UpVector.X) * Span.Y + math.abs(Pose.LookVector.X) * Span.Z,
                    math.abs(Pose.RightVector.Y) * Span.X + math.abs(Pose.UpVector.Y) * Span.Y + math.abs(Pose.LookVector.Y) * Span.Z,
                    math.abs(Pose.RightVector.Z) * Span.X + math.abs(Pose.UpVector.Z) * Span.Y + math.abs(Pose.LookVector.Z) * Span.Z
                ) * 0.5

                local A, B = Pose.Position - Reach, Pose.Position + Reach

                Low = Low and Low:Min(A) or A
                High = High and High:Max(B) or B
            end

            if not Low then return nil end

            return (Low + High) * 0.5, High - Low
        end

        local function Frame3D(Preview)
            local Span = Preview.Viewport.AbsoluteSize
            if Span.X < 1 or Span.Y < 1 then return end

            local Scale = Library:GetScreenScale()
            if Scale <= 0 then Scale = 1 end

            Preview.Width = Span.X / Scale
            Preview.Height = Span.Y / Scale
            Preview.Aspect = Span.X / Span.Y

            if not Preview.Model then return end

            local TanV = math.tan(math.rad(Preview.Camera.FieldOfView) * 0.5)
            local TanH = TanV * Preview.Aspect

            local DistV = Preview.Half / TanV + Preview.Radius
            local DistH = Preview.Radius / math.sin(math.atan(TanH))

            Preview.Dist = math.max(DistV, DistH) * Preview.Margin
            Preview.TanV = TanV
        end

        local function Apply(Preview)
            if not Preview.Model or not Preview.Dist then return end

            local Spin = CFrame.Angles(0, Preview.Yaw, 0)
            local Eye = Preview.Center + Spin * Vector3.new(0, 0, Preview.Dist)

            local Pose = CFrame.lookAt(Eye, Preview.Center)

            Preview.Camera.CFrame = Pose
            Preview.Viewport.LightDirection = Spin * Preview.Light
            Preview.Inverse = Pose:Inverse()

            if Preview.RimCamera then
                Preview.RimCamera.CFrame = Pose
                Preview.ChamsCamera.CFrame = Pose
                Preview.Rim.LightDirection = Spin * Preview.Light
                Preview.Chams.LightDirection = Spin * Preview.Light
            end
        end

        local function Project(Preview, Point)
            if not Preview.Inverse or not Preview.TanV then return nil end

            local Rel = Preview.Inverse * Point
            local Depth = -Rel.Z

            if Depth <= 0.05 then return nil end

            local SpanY = Depth * Preview.TanV

            return Vector2.new(
                ((Rel.X / (SpanY * Preview.Aspect)) * 0.5 + 0.5) * Preview.Width,
                (0.5 - (Rel.Y / SpanY) * 0.5) * Preview.Height
            )
        end

        local function Wanted(Preview)
            if not Preview.Model then return false end
            if not Preview.Row.Instance.Parent then return false end
            if Preview.Data.Window and Preview.Data.Window.IsOpen == false then return false end
            if Preview.Data.Borrowed then return true end
            if Preview.Data.Visible == false then return false end

            return Preview.SubTab.Active == true
        end

        local function SetAwake(Preview, State)
            if Preview.Awake == State then return end

            Preview.Awake = State
            Preview.SleepToken += 1

            if State then
                Preview.Viewport.Visible = true
                Preview.Overlay.Visible = true

                if Preview.Rim then
                    Preview.Rim.Visible = Preview.RimOn == true
                    Preview.Chams.Visible = Preview.RimOn == true
                end

                return
            end

            local Token = Preview.SleepToken

            task.delay(Library.Animation.Time + 0.15, function()
                if Preview.Awake or Preview.SleepToken ~= Token then return end

                Preview.Viewport.Visible = false
                Preview.Overlay.Visible = false

                if Preview.Rim then
                    Preview.Rim.Visible = false
                    Preview.Chams.Visible = false
                end
            end)
        end

        local function Step(Delta)
            for Index = #Previews, 1, -1 do
                local Preview = Previews[Index]

                if Preview.Dead or not Preview.Row.Instance.Parent then
                    table.remove(Previews, Index)
                    continue
                end

                local Want = Wanted(Preview)

                if Want ~= Preview.Awake then
                    SetAwake(Preview, Want)
                end

                if not Want then continue end

                local Span = Preview.Viewport.AbsoluteSize

                if Span.X ~= Preview.LastX or Span.Y ~= Preview.LastY then
                    Preview.LastX = Span.X
                    Preview.LastY = Span.Y

                    Frame3D(Preview)
                    Preview.Dirty = true
                end

                if not Preview.Dragging and Preview.Speed ~= 0 then
                    Preview.Yaw += Delta * Preview.Speed
                    Preview.Dirty = true
                end

                if Preview.Dirty then
                    Preview.Dirty = false

                    Apply(Preview)
                    Preview:Solve()
                    Preview:Layout()
                end

                if Preview.Options.Outline and not Preview.Shell and Preview.Dist then
                    pcall(function() Preview:ApplyOutline() end)
                end

                Preview:StepHealth(Delta)
            end
        end

        Library.EspPreview = function(Self, Params)
            Params = Params or { }

            local Section = Self
            local SubTab = Section.SubTab

            local Preview = {
                Name = Params.Name or "ESP preview",
                Bundle = Params.Bundle or 228468095335331,
                Box = math.clamp(Params.Height or 200, 120, 360),
                Section = Section,
                SubTab = SubTab,
                Yaw = math.rad(Params.Yaw or 0),
                Speed = Params.Speed == nil and 0.45 or (tonumber(Params.Speed) or 0),
                Margin = Params.Margin or 1.28,
                Light = Vector3.new(-0.4, -0.7, -0.6),
                OutlineWidth = math.clamp(tonumber(Params.OutlineWidth) or 2.5, 0.5, 12),
                RimOn = false,
                Width = 1,
                Height = 1,
                Aspect = 1,
                Awake = false,
                Dirty = true,
                Dragging = false,
                Dead = false,
                SleepToken = 0,
                Clock = 0,
                Accum = 0,
                Frac = 1,
                Rect = { On = false, X = 0, Y = 0, W = 0, H = 0 },
                Options = { },
                Segments = { },
                Items = { }
            }

            for Key, Value in EspDefaults do
                Preview.Options[Key] = Value
            end

            if type(Params.Options) == "table" then
                for Key, Value in Params.Options do
                    if EspDefaults[Key] ~= nil then
                        Preview.Options[Key] = Value
                    end
                end
            end

            local Options = Preview.Options

            local Row, Data = Section:AddRow(Preview.Box + 32, Params.SearchName or Preview.Name)
            local Items = Preview.Items

            Preview.Row = Row
            Preview.Data = Data

            Items.Label = MakeText({
                Parent = Row.Instance,
                Text = Preview.Name,
                TextSize = 15,
                Pos = UDim2.fromOffset(15, 4),
                Size = UDim2.new(1, -30, 0, 18),
                Color = "DimText",
                Truncate = true,
                Z = 5
            })

            Items.Stage = MakeFrame({
                Parent = Row.Instance,
                Pos = UDim2.fromOffset(15, 24),
                Size = UDim2.new(1, -30, 0, Preview.Box),
                Color = "Element",
                Round = 6,
                Clip = true,
                Z = 5
            })

            Items.Viewport = Library:Create("ViewportFrame", {
                Parent = Items.Stage.Instance,
                Name = "\0",
                Position = UDim2.fromOffset(0, 0),
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ImageTransparency = 0,
                Ambient = Color3.fromRGB(132, 132, 142),
                LightColor = Color3.fromRGB(255, 252, 245),
                LightDirection = Preview.Light,
                BorderSizePixel = 0,
                ZIndex = 7
            })

            Items.Viewport.Instance.Visible = false
            Preview.Viewport = Items.Viewport.Instance

            Preview.World = Library:Create("WorldModel", {
                Parent = Preview.Viewport,
                Name = "\0"
            }).Instance

            Preview.Camera = Library:Create("Camera", {
                Parent = Preview.Viewport,
                Name = "\0",
                FieldOfView = math.clamp(Params.FieldOfView or 26, 5, 90)
            }).Instance

            Preview.Viewport.CurrentCamera = Preview.Camera

            Items.Rim = Library:Create("ViewportFrame", {
                Parent = Items.Stage.Instance,
                Name = "\0",
                Position = UDim2.fromOffset(0, 0),
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ImageTransparency = 0,
                Ambient = Color3.new(1, 1, 1),
                LightColor = Color3.new(1, 1, 1),
                LightDirection = Preview.Light,
                BorderSizePixel = 0,
                ZIndex = 6
            })

            Items.Rim.Instance.Visible = false
            Preview.Rim = Items.Rim.Instance

            Preview.RimWorld = Library:Create("WorldModel", {
                Parent = Preview.Rim,
                Name = "\0"
            }).Instance

            Preview.RimCamera = Library:Create("Camera", {
                Parent = Preview.Rim,
                Name = "\0",
                FieldOfView = math.clamp(Params.FieldOfView or 26, 5, 90)
            }).Instance

            Preview.Rim.CurrentCamera = Preview.RimCamera

            Items.Chams = Library:Create("ViewportFrame", {
                Parent = Items.Stage.Instance,
                Name = "\0",
                Position = UDim2.fromOffset(0, 0),
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ImageTransparency = 0.72,
                Ambient = Color3.new(1, 1, 1),
                LightColor = Color3.new(1, 1, 1),
                LightDirection = Preview.Light,
                BorderSizePixel = 0,
                ZIndex = 8
            })

            Items.Chams.Instance.Visible = false
            Preview.Chams = Items.Chams.Instance

            Preview.ChamsWorld = Library:Create("WorldModel", {
                Parent = Preview.Chams,
                Name = "\0"
            }).Instance

            Preview.ChamsCamera = Library:Create("Camera", {
                Parent = Preview.Chams,
                Name = "\0",
                FieldOfView = math.clamp(Params.FieldOfView or 26, 5, 90)
            }).Instance

            Preview.Chams.CurrentCamera = Preview.ChamsCamera

            Items.Overlay = MakeFrame({
                Parent = Items.Stage.Instance,
                Pos = UDim2.fromOffset(0, 0),
                Size = UDim2.new(1, 0, 1, 0),
                Clip = true,
                Z = 9
            })

            Items.Overlay.Instance.Visible = false
            Preview.Overlay = Items.Overlay.Instance

            Items.Status = MakeText({
                Parent = Items.Stage.Instance,
                Text = "Loading preview",
                TextSize = 14,
                Anchor = Vector2.new(0.5, 0.5),
                Pos = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, -20, 0, 20),
                Align = Enum.TextXAlignment.Center,
                Color = "DimText",
                Z = 15
            })

            Items.Hit = MakeButton({
                Parent = Items.Stage.Instance,
                Z = 16
            })

            local function RawFrame(Z, Alpha, Color)
                return Library:Create("Frame", {
                    Parent = Preview.Overlay,
                    Name = "\0",
                    BackgroundColor3 = Color or Options.Color,
                    BackgroundTransparency = Alpha or 0,
                    BorderSizePixel = 0,
                    Position = UDim2.fromOffset(0, 0),
                    Size = UDim2.fromOffset(0, 0),
                    Visible = false,
                    ZIndex = Z
                })
            end

            local function RawText(Z, TextSize, Color)
                local Item = Library:Create("TextLabel", {
                    Parent = Preview.Overlay,
                    Name = "\0",
                    FontFace = UiFont,
                    Text = "",
                    TextSize = TextSize,
                    TextColor3 = Color or Options.Color,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Position = UDim2.fromOffset(0, 0),
                    Size = UDim2.fromOffset(0, 0),
                    Visible = false,
                    BorderSizePixel = 0,
                    ZIndex = Z
                })

                Library:Create("UIStroke", {
                    Parent = Item.Instance,
                    Name = "\0",
                    Color = Color3.new(0, 0, 0),
                    Thickness = 1,
                    Transparency = 0.35
                })

                return Item
            end

            Items.Fill = RawFrame(10, Options.FillAlpha)
            Items.Tracer = RawFrame(11, 0)
            Items.Tracer.Instance.AnchorPoint = Vector2.new(0.5, 0.5)

            for Index = 1, 8 do
                Preview.Segments[Index] = RawFrame(12, 0)
            end

            Items.HealthBg = RawFrame(12, 0.3, Color3.fromRGB(14, 15, 18))
            Items.HealthBar = RawFrame(13, 0)

            Items.NameTag = RawText(14, Options.TextSize)
            Items.RoleTag = RawText(14, Options.TextSize - 1)

            table.insert(Previews, Preview)

            if not Driver then
                Driver = Library:Connect(RunService.RenderStepped, Step)
            end

            local function Place(Item, X, Y, W, H)
                Item.Instance.Position = UDim2.fromOffset(math.round(X), math.round(Y))
                Item.Instance.Size = UDim2.fromOffset(math.max(1, math.round(W)), math.max(1, math.round(H)))
            end

            local function Clamped(Point)
                return Vector2.new(
                    math.clamp(Point.X, 1, Preview.Width - 1),
                    math.clamp(Point.Y, 1, Preview.Height - 1)
                )
            end

            local function TracerOrigin()
                local Mode = Options.TracerFrom

                if Mode == "top" then
                    return Vector2.new(Preview.Width * 0.5, 0)
                elseif Mode == "centre" or Mode == "center" then
                    return Vector2.new(Preview.Width * 0.5, Preview.Height * 0.5)
                elseif Mode == "mouse" then
                    local Scale = Library:GetScreenScale()
                    if Scale <= 0 then Scale = 1 end

                    local Point = UserInputService:GetMouseLocation()
                    local Corner = Preview.Viewport.AbsolutePosition

                    return Vector2.new(
                        (Point.X - Corner.X) / Scale,
                        (Point.Y - GuiInset - Corner.Y) / Scale
                    )
                end

                return Vector2.new(Preview.Width * 0.5, Preview.Height)
            end

            function Preview:Solve()
                local Rect = Preview.Rect
                Rect.On = false

                if not Preview.Model then return end

                local Top = Project(Preview, Preview.Center + Vector3.new(0, Preview.Half + 0.4, 0))
                local Bottom = Project(Preview, Preview.Center - Vector3.new(0, Preview.Half, 0))

                if not Top or not Bottom then return end

                local H = math.abs(Bottom.Y - Top.Y)
                if H < 1 or H > Preview.Height * 12 then return end

                local W = H * 0.52

                Rect.X = (Top.X + Bottom.X) * 0.5 - W * 0.5
                Rect.Y = math.min(Top.Y, Bottom.Y)
                Rect.W = W
                Rect.H = H
                Rect.On = true
            end

            function Preview:Layout()
                local Rect = Preview.Rect

                if not Rect.On then
                    for _, Segment in Preview.Segments do
                        Segment.Instance.Visible = false
                    end

                    for _, Key in { "Fill", "Tracer", "HealthBg", "HealthBar", "NameTag", "RoleTag" } do
                        Items[Key].Instance.Visible = false
                    end

                    return
                end

                local X, Y, W, H = Rect.X, Rect.Y, Rect.W, Rect.H

                Items.Fill.Instance.Visible = Options.Fill

                if Options.Fill then
                    Place(Items.Fill, X, Y, W, H)
                end

                if Options.Box and Options.Corners then
                    local Len = math.clamp(math.min(W, H) * 0.28, 3, 18)

                    local Plan = {
                        { X, Y, Len, 1 },
                        { X, Y, 1, Len },
                        { X + W - Len, Y, Len, 1 },
                        { X + W - 1, Y, 1, Len },
                        { X, Y + H - 1, Len, 1 },
                        { X, Y + H - Len, 1, Len },
                        { X + W - Len, Y + H - 1, Len, 1 },
                        { X + W - 1, Y + H - Len, 1, Len }
                    }

                    for Index, Segment in Preview.Segments do
                        local Spec = Plan[Index]

                        Place(Segment, Spec[1], Spec[2], Spec[3], Spec[4])
                        Segment.Instance.Visible = true
                    end
                elseif Options.Box then
                    local Plan = {
                        { X, Y, W, 1 },
                        { X, Y + H - 1, W, 1 },
                        { X, Y, 1, H },
                        { X + W - 1, Y, 1, H }
                    }

                    for Index, Segment in Preview.Segments do
                        local Spec = Plan[Index]

                        if Spec then
                            Place(Segment, Spec[1], Spec[2], Spec[3], Spec[4])
                            Segment.Instance.Visible = true
                        else
                            Segment.Instance.Visible = false
                        end
                    end
                else
                    for _, Segment in Preview.Segments do
                        Segment.Instance.Visible = false
                    end
                end

                Items.HealthBg.Instance.Visible = Options.Health
                Items.HealthBar.Instance.Visible = Options.Health

                if Options.Health then
                    local BarW = math.clamp(W * 0.07, 2, 5)
                    local BarX = X - BarW - math.max(2, BarW)
                    local Frac = Preview.Frac

                    Place(Items.HealthBg, BarX, Y, BarW, H)
                    Place(Items.HealthBar, BarX, Y + H * (1 - Frac), BarW, H * Frac)

                    Items.HealthBar.Instance.BackgroundColor3 =
                        Color3.fromRGB(255 - 200 * Frac, 40 + 200 * Frac, 60)
                end

                local Pad = 45

                Items.NameTag.Instance.Visible = Options.Name

                if Options.Name then
                    if Items.NameTag.Instance.Text ~= Options.NameText then
                        Items.NameTag.Instance.Text = Options.NameText
                    end

                    local NameY = math.clamp(Y - Options.TextSize - 3, 1, Preview.Height - Options.TextSize - 2)

                    Place(Items.NameTag, X - Pad, NameY, W + Pad * 2, Options.TextSize + 2)
                end

                Items.RoleTag.Instance.Visible = Options.Role

                if Options.Role then
                    local Line = Options.RoleText

                    if Options.Distance then
                        Line = string.format("%s  %dm", Line, Options.DistanceText)
                    end

                    if Preview.LastRole ~= Line then
                        Preview.LastRole = Line
                        Items.RoleTag.Instance.Text = Line
                    end

                    local RoleY = math.clamp(Y + H + 3, 1, Preview.Height - Options.TextSize - 1)

                    Place(Items.RoleTag, X - Pad, RoleY, W + Pad * 2, Options.TextSize + 1)
                end

                Items.Tracer.Instance.Visible = Options.Tracer

                if Options.Tracer then
                    local From = Clamped(TracerOrigin())
                    local To = Clamped(Vector2.new(X + W * 0.5, Y + H))
                    local Delta = To - From
                    local Mid = (From + To) * 0.5

                    Items.Tracer.Instance.Position = UDim2.fromOffset(math.round(Mid.X), math.round(Mid.Y))
                    Items.Tracer.Instance.Size = UDim2.fromOffset(math.max(1, math.round(Delta.Magnitude)), 1)
                    Items.Tracer.Instance.Rotation = math.deg(math.atan2(Delta.Y, Delta.X))
                end
            end

            function Preview:StepHealth(Delta)
                if not Options.Health or not Options.Demo then return end

                Preview.Clock += Delta
                Preview.Accum += Delta

                if Preview.Accum < 0.05 then return end
                Preview.Accum = 0

                local T = Preview.Clock
                local Frac = math.clamp(0.55 + 0.35 * math.sin(T * 0.9) * math.cos(T * 0.37), 0.05, 1)
                local Rect = Preview.Rect

                if not Rect.On then return end
                if math.abs(Frac - Preview.Frac) * Rect.H < 0.5 then return end

                Preview.Frac = Frac

                local BarW = math.clamp(Rect.W * 0.07, 2, 5)
                local BarX = Rect.X - BarW - math.max(2, BarW)

                Place(Items.HealthBar, BarX, Rect.Y + Rect.H * (1 - Frac), BarW, Rect.H * Frac)

                Items.HealthBar.Instance.BackgroundColor3 =
                    Color3.fromRGB(255 - 200 * Frac, 40 + 200 * Frac, 60)
            end

            function Preview:Recolor()
                for _, Segment in Preview.Segments do
                    Segment.Instance.BackgroundColor3 = Options.Color
                end

                Items.Fill.Instance.BackgroundColor3 = Options.Color
                Items.Tracer.Instance.BackgroundColor3 = Options.Color
                Items.NameTag.Instance.TextColor3 = Options.Color
                Items.RoleTag.Instance.TextColor3 = Options.Color

                Items.NameTag.Instance.TextSize = Options.TextSize
                Items.RoleTag.Instance.TextSize = math.max(1, Options.TextSize - 1)

                Library:StampResting(Items.Fill.Instance, "BackgroundTransparency", Options.FillAlpha)

                if Preview.Awake then
                    Items.Fill.Instance.BackgroundTransparency = Options.FillAlpha
                end
            end

            function Preview:ApplyOutline()
                if Options.Outline and Preview.Model and not Preview.Shell
                    and not Preview.Dead and Preview.Dist and Preview.Height > 1 then
                    local Ok, Shell = pcall(function()
                        return Preview.Model:Clone()
                    end)

                    local Fine, Body = pcall(function()
                        return Preview.Model:Clone()
                    end)

                    if Ok and Fine and typeof(Shell) == "Instance" and typeof(Body) == "Instance" then
                        local PerPixel = (2 * Preview.Dist * Preview.TanV) / Preview.Height

                        FlattenShell(Shell, Options.Color)
                        FlattenShell(Body, Options.Color)
                        GrowShell(Shell, math.clamp(2 * Preview.OutlineWidth * PerPixel, 0.01, 2))

                        Shell.Parent = Preview.RimWorld
                        Body.Parent = Preview.ChamsWorld

                        Preview.Shell = Shell
                        Preview.Body = Body
                        Preview.ShellParts = { }

                        for _, Child in Shell:GetDescendants() do
                            if Child:IsA("BasePart") and Child.Transparency < 1 then
                                table.insert(Preview.ShellParts, Child)
                            end
                        end

                        for _, Child in Body:GetDescendants() do
                            if Child:IsA("BasePart") and Child.Transparency < 1 then
                                table.insert(Preview.ShellParts, Child)
                            end
                        end
                    else
                        if typeof(Shell) == "Instance" then pcall(function() Shell:Destroy() end) end
                        if typeof(Body) == "Instance" then pcall(function() Body:Destroy() end) end
                    end
                end

                Preview.RimOn = Options.Outline == true and Preview.Shell ~= nil
                Preview.Rim.Visible = Preview.RimOn and Preview.Awake
                Preview.Chams.Visible = Preview.RimOn and Preview.Awake
                Preview.Chams.ImageTransparency = math.clamp(Options.OutlineFill, 0, 1)

                if not Preview.ShellParts then return end

                for _, Part in Preview.ShellParts do
                    Part.Color = Options.Color
                end
            end

            function Preview:SetOptions(New)
                if type(New) ~= "table" then return Options end

                for Key, Value in New do
                    if EspDefaults[Key] == nil then continue end

                    local Kind = type(Value)

                    if Kind == "boolean" or Kind == "number" or Kind == "string" or typeof(Value) == "Color3" then
                        Options[Key] = Value
                    end
                end

                Preview:Recolor()
                pcall(function() Preview:ApplyOutline() end)
                Preview.Dirty = true

                if Preview.Model then
                    Preview:Solve()
                    Preview:Layout()
                end

                return Options
            end

            function Preview:GetOptions()
                return Options
            end

            function Preview:SetSpeed(Value)
                Preview.Speed = tonumber(Value) or 0
                Preview.Dirty = true
            end

            function Preview:SetYaw(Degrees)
                Preview.Yaw = math.rad(tonumber(Degrees) or 0)
                Preview.Dirty = true
            end

            function Preview:Project(Point)
                return Project(Preview, Point)
            end

            function Preview:GetStage()
                return Items.Stage.Instance, Preview.Overlay
            end

            function Preview:Destroy()
                Preview.Dead = true

                if Preview.Shell then
                    pcall(function() Preview.Shell:Destroy() end)
                    Preview.Shell = nil
                end

                if Preview.Body then
                    pcall(function() Preview.Body:Destroy() end)
                    Preview.Body = nil
                end

                Preview.ShellParts = nil

                for Index = #Previews, 1, -1 do
                    if Previews[Index] == Preview then
                        table.remove(Previews, Index)
                    end
                end

                for Index = #Library.Searchables, 1, -1 do
                    if Library.Searchables[Index] == Data then
                        table.remove(Library.Searchables, Index)
                    end
                end

                for Index = #Section.Rows, 1, -1 do
                    if Section.Rows[Index] == Data then
                        table.remove(Section.Rows, Index)
                    end
                end

                Data.Visible = false
                Data.OnWidth = nil
                Data.Borrowed = nil
                Data.Section = nil

                pcall(function()
                    Row.Instance:Destroy()
                end)

                Data.Frame = nil

                if Section.Reflow then Section:Reflow() end
            end

            Data.OnWidth = function()
                Frame3D(Preview)
                Preview.Dirty = true
            end

            AttachDrag(Items.Hit, {
                OnGrab = function(Input)
                    Preview.Dragging = true
                    Preview.DragX = Input.Position.X
                end,

                OnMove = function(Input)
                    if not Preview.Dragging then return end

                    local Scale = Library:GetScreenScale()
                    if Scale <= 0 then Scale = 1 end

                    Preview.Yaw -= ((Input.Position.X - Preview.DragX) / Scale) * 0.012
                    Preview.DragX = Input.Position.X
                    Preview.Dirty = true
                end,

                OnRelease = function()
                    Preview.Dragging = false
                end
            })

            Preview:Recolor()

            Library:Thread(function()
                local Source, Reason = FetchRig(Preview.Bundle)

                if Preview.Dead or not Row.Instance.Parent then return end

                if not Source then
                    Items.Status.Instance.Text = "Preview unavailable (" .. tostring(Reason) .. ")"
                    return
                end

                local Model = Source:Clone()
                Model.Parent = Preview.World

                local Center, Span = MeasureRig(Model)

                if not Center or Span.X > MaxStud or Span.Y > MaxStud or Span.Z > MaxStud then
                    RunService.RenderStepped:Wait()

                    if Preview.Dead or not Row.Instance.Parent then
                        Model:Destroy()
                        return
                    end

                    Center, Span = MeasureRig(Model)
                end

                if not Center or Span.X > MaxStud or Span.Y > MaxStud or Span.Z > MaxStud then
                    Model:Destroy()
                    Items.Status.Instance.Text = "Preview unavailable (rig)"
                    return
                end

                for _, Child in Model:GetDescendants() do
                    if Child:IsA("BasePart") then
                        Child.Anchored = true
                        Child.CanCollide = false
                        Child.CanQuery = false
                        Child.CanTouch = false
                        Child.CastShadow = false
                    end
                end

                Preview.Model = Model
                Preview.Center = Center
                Preview.Half = Span.Y * 0.5
                Preview.Radius = math.sqrt(Span.X * Span.X + Span.Z * Span.Z) * 0.5

                Items.Status.Instance.Visible = false

                Frame3D(Preview)
                Apply(Preview)
                pcall(function() Preview:ApplyOutline() end)

                Preview.Dirty = true
            end)

            return setmetatable(Preview, Library)
        end
    end

    Library.ThemeConfig = function(Self, Params)
        Params = Params or { }

        local SubTab = Self
        local Window = SubTab.Window
        local Page = SubTab.Items.Page
        local ContentH = Window.ContentH
        local ColW = Window.ColW
        local Col2X = Window.Col2X

        SubTab.Columns[1].Scroll.Instance.Visible = false
        SubTab.Columns[2].Scroll.Instance.Visible = false

        local Config = {
            Rows = { },
            Selected = nil,
            IntroToken = 0,
            Items = { }
        }

        local Items = Config.Items

        local function ConfigPath(Name)
            return Library.ConfigFolder .. "/" .. Name .. ".json"
        end

        Items.CreateBox = MakeFrame({
            Parent = Page.Instance,
            Pos = UDim2.fromOffset(0, 0),
            Size = UDim2.new(0.5, -8, 0, 40),
            Z = 3
        })

        Items.NameBox = MakeFrame({
            Parent = Items.CreateBox.Instance,
            Size = UDim2.new(1, -94, 0, 40),
            Color = "Element",
            Round = 6,
            Clip = true,
            Z = 4
        })

        MakeImage({
            Parent = Items.NameBox.Instance,
            Icon = "pencil",
            Anchor = Vector2.new(0, 0.5),
            Pos = UDim2.new(0, 12, 0.5, 0),
            Size = UDim2.fromOffset(14, 14),
            Color = "DimText",
            Z = 5
        })

        Items.NameInput = MakeInput({
            Parent = Items.NameBox.Instance,
            Placeholder = "config name",
            Pos = UDim2.fromOffset(34, 0),
            Size = UDim2.new(1, -44, 1, 0),
            TextSize = 15,
            Z = 5
        })

        Items.Create = MakeFrame({
            Parent = Items.CreateBox.Instance,
            Anchor = Vector2.new(1, 0),
            Pos = UDim2.new(1, 0, 0, 0),
            Size = UDim2.fromOffset(84, 40),
            Color = "Element",
            Round = 6,
            Clip = true,
            Z = 4
        })

        HoverSwap(Items.Create)
        Items.CreateSweep = MakeSweep(Items.Create.Instance, 5)

        MakeText({
            Parent = Items.Create.Instance,
            Text = "Create",
            TextSize = 15,
            Size = UDim2.new(1, 0, 1, 0),
            Color = "Text",
            Align = Enum.TextXAlignment.Center,
            Z = 6
        })

        Items.CreateHit = MakeButton({
            Parent = Items.Create.Instance,
            Z = 7
        })

        Items.ListHolder = MakeFrame({
            Parent = Page.Instance,
            Pos = UDim2.fromOffset(0, 52),
            Size = UDim2.new(0.5, -8, 1, -52),
            Z = 3
        })

        Items.List = Library:Create("ScrollingFrame", {
            Parent = Items.ListHolder.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            ScrollBarImageTransparency = 1,
            Selectable = false,
            Active = true,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.fromOffset(0, 0),
            ZIndex = 3,
            BorderSizePixel = 0
        })

        Library:Create("UIListLayout", {
            Parent = Items.List.Instance,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })

        Items.InfoPanel = MakeFrame({
            Parent = Page.Instance,
            Pos = UDim2.new(0.5, 8, 0, 0),
            Size = UDim2.new(0.5, -8, 0, 204),
            Color = "Section",
            Round = 10,
            Z = 3
        })

        MakeText({
            Parent = Items.InfoPanel.Instance,
            Text = "Config info",
            TextSize = 15,
            Pos = UDim2.fromOffset(14, 12),
            Size = UDim2.new(1, -28, 0, 20),
            Color = "Text",
            Z = 4
        })

        local InfoRows = { }

        local function InfoRow(Index, Icon, Label)
            local Y = 44 + (Index - 1) * 32

            MakeImage({
                Parent = Items.InfoPanel.Instance,
                Icon = Icon,
                Pos = UDim2.fromOffset(14, Y + 3),
                Size = UDim2.fromOffset(14, 14),
                Color = "DimIcon",
                Z = 4
            })

            MakeText({
                Parent = Items.InfoPanel.Instance,
                Text = Label,
                TextSize = 15,
                Pos = UDim2.fromOffset(36, Y),
                Size = UDim2.new(1, -170, 0, 20),
                Color = "DimText",
                Z = 4
            })

            local Value = MakeText({
                Parent = Items.InfoPanel.Instance,
                Text = "-",
                TextSize = 15,
                Anchor = Vector2.new(1, 0),
                Pos = UDim2.new(1, -14, 0, Y),
                Size = UDim2.fromOffset(150, 20),
                Color = "Text",
                Align = Enum.TextXAlignment.Right,
                Truncate = true,
                Z = 4
            })

            if Index < 5 then
                MakeFrame({
                    Parent = Items.InfoPanel.Instance,
                    Pos = UDim2.fromOffset(14, Y + 27),
                    Size = UDim2.new(1, -28, 0, 1),
                    Color = "Element",
                    Z = 4
                })
            end

            return Value
        end

        InfoRows.Version = InfoRow(1, "layers", "Config version")
        InfoRows.Compatible = InfoRow(2, "link", "Compatibility")
        InfoRows.Created = InfoRow(3, "clock", "Created")
        InfoRows.Creator = InfoRow(4, "user", "Creator")
        InfoRows.Elements = InfoRow(5, "box", "Saved flags")

        local function ShowInfo(Name)
            if not Name then
                for _, Value in InfoRows do
                    Value.Instance.Text = "-"
                end

                return
            end

            local Data = { }

            pcall(function()
                Data = HttpService:JSONDecode(readfile(ConfigPath(Name)))
            end)

            local Count = 0

            for Key in Data do
                if string.sub(Key, 1, 2) ~= "__" then
                    Count += 1
                end
            end

            local Same = Data.__version == Library.Version

            InfoRows.Version.Instance.Text = Data.__version or "Unknown"
            InfoRows.Compatible.Instance.Text = Same and "Compatible" or "Outdated"
            InfoRows.Created.Instance.Text = Data.__created or "Unknown"
            InfoRows.Creator.Instance.Text = Data.__creator or "Unknown"
            InfoRows.Elements.Instance.Text = tostring(Count) .. " flags"
        end

        Items.ThemePanel = MakeFrame({
            Parent = Page.Instance,
            Pos = UDim2.new(0.5, 8, 0, 216),
            Size = UDim2.new(0.5, -8, 0, 194),
            Color = "Section",
            Round = 10,
            Z = 3
        })

        MakeText({
            Parent = Items.ThemePanel.Instance,
            Text = "Theme",
            TextSize = 15,
            Pos = UDim2.fromOffset(14, 8),
            Size = UDim2.new(1, -28, 0, 20),
            Color = "Text",
            Z = 4
        })

        local RefreshThemeUI
        local PresetDots = { }

        local function SelectPreset(Target)
            for _, Dot in PresetDots do
                Library:Tween({ Thickness = Dot == Target and 2 or 0 }, nil, Dot.Ring.Instance)
            end
        end

        MakeText({
            Parent = Items.ThemePanel.Instance,
            Text = "Presets",
            TextSize = 15,
            Pos = UDim2.fromOffset(14, 34),
            Size = UDim2.fromOffset(100, 20),
            Color = "DimText",
            Z = 4
        })

        for Index, Preset in Library.ThemePresets do
            local Dot = MakeFrame({
                Parent = Items.ThemePanel.Instance,
                Anchor = Vector2.new(1, 0),
                Pos = UDim2.new(1, -14 - (#Library.ThemePresets - Index) * 28, 0, 35),
                Size = UDim2.fromOffset(18, 18),
                Raw = Preset.Swatch or Preset.Accent,
                Round = 20,
                Z = 4
            })

            Dot.Ring = Library:Create("UIStroke", {
                Parent = Dot.Instance,
                Color = Color3.new(1, 1, 1),
                Thickness = 0
            })

            local Hit = MakeButton({
                Parent = Dot.Instance,
                Z = 5
            })

            Hit:Connect("MouseButton1Down", function()
                Library:SetTheme(Preset)
                SelectPreset(Dot)

                if RefreshThemeUI then
                    RefreshThemeUI()
                end
            end)

            table.insert(PresetDots, Dot)
        end

        PresetDots[1].Ring.Instance.Thickness = 2

        local ThemeCells = {
            { "Background", "Background" },
            { "Section", "Sections" },
            { "Element", "Elements" },
            { "Light", "Boxes" },
            { "Text", "Text" },
            { "DimText", "Dim text" }
        }

        local ThemeCellList = { }
        local CellW = math.floor((ColW - 42) / 2)

        for Index, Entry in ThemeCells do
            local Key = Entry[1]
            local CellX = 14 + ((Index - 1) % 2) * (CellW + 14)
            local CellY = 66 + math.floor((Index - 1) / 2) * 30

            local Label = MakeText({
                Parent = Items.ThemePanel.Instance,
                Text = Entry[2],
                TextSize = 15,
                Pos = UDim2.fromOffset(CellX, CellY),
                Size = UDim2.fromOffset(CellW - 28, 20),
                Color = "DimText",
                Truncate = true,
                Z = 4
            })

            local Swatch = MakeSwatch(Items.ThemePanel.Instance, 0, Library.Theme[Key], 4)

            Swatch.Halo.Instance.AnchorPoint = Vector2.new(0, 0)
            Swatch.Halo.Instance.Position = UDim2.fromOffset(CellX + CellW - 22, CellY - 1)

            local CellPicker = MakeColorPopup(function()
                return Swatch.Halo.Instance
            end, Entry[2], Library.Theme[Key], 0, function(Color)
                Swatch:SetColor(Color)
                Library:SetThemeColor(Key, Color)
            end)

            Swatch.Hit:Connect("MouseButton1Down", function()
                CellPicker:SetOpen(not CellPicker.IsOpen)
            end)

            table.insert(ThemeCellList, {
                Key = Key,
                Label = Label,
                Swatch = Swatch,
                Picker = CellPicker
            })
        end

        local function LayoutCells(NewColW)
            CellW = math.floor((NewColW - 42) / 2)

            for Index, Cell in ThemeCellList do
                local CellX = 14 + ((Index - 1) % 2) * (CellW + 14)
                local CellY = 66 + math.floor((Index - 1) / 2) * 30

                Cell.Label.Instance.Position = UDim2.fromOffset(CellX, CellY)
                Cell.Label.Instance.Size = UDim2.fromOffset(CellW - 28, 20)
                Cell.Swatch.Halo.Instance.Position = UDim2.fromOffset(CellX + CellW - 22, CellY - 1)
            end
        end

        SubTab.OnResize = function()
            LayoutCells(Window.ColW)
        end

        MakeText({
            Parent = Items.ThemePanel.Instance,
            Text = "Accent",
            TextSize = 15,
            Pos = UDim2.fromOffset(14, 160),
            Size = UDim2.new(1, -60, 0, 20),
            Color = "DimText",
            Truncate = true,
            Z = 4
        })

        Items.Swatch = MakeSwatch(Items.ThemePanel.Instance, -14, Library.Theme.Accent, 4)
        Items.Swatch.Halo.Instance.AnchorPoint = Vector2.new(1, 0.5)
        Items.Swatch.Halo.Instance.Position = UDim2.new(1, -14, 0, 170)

        local Picker = MakeColorPopup(function()
            return Items.Swatch.Halo.Instance
        end, "Accent", Library.Theme.Accent, 0, function(Color)
            Items.Swatch:SetColor(Color)
            Library:SetAccent(Color)
        end)

        Items.Swatch.Hit:Connect("MouseButton1Down", function()
            Picker:SetOpen(not Picker.IsOpen)
        end)

        RefreshThemeUI = function()
            Items.Swatch:SetColor(Library.Theme.Accent)
            Picker:Set(Library.Theme.Accent, 0, true)

            for _, Cell in ThemeCellList do
                Cell.Swatch:SetColor(Library.Theme[Cell.Key])
                Cell.Picker:Set(Library.Theme[Cell.Key], 0, true)
            end
        end

        local RefreshList

        local function AddRow(Index, Name)
            local Slot = MakeFrame({
                Parent = Items.List.Instance,
                Size = UDim2.new(1, 0, 0, 44),
                Clip = true,
                Z = 4
            })

            Slot.Instance.LayoutOrder = Index

            local Row = MakeFrame({
                Parent = Slot.Instance,
                Size = UDim2.new(1, 0, 0, 44),
                Color = "Section",
                Round = 8,
                Z = 4
            })

            local Bar = MakeFrame({
                Parent = Row.Instance,
                Anchor = Vector2.new(0, 0.5),
                Pos = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.fromOffset(3, 0),
                Color = "Accent",
                Round = 4,
                Z = 6
            })

            local BarShadow = MakeAccentShadow(
                Bar.Instance,
                UDim2.fromOffset(3, 15),
                UDim.new(0, 10),
                0
            )

            if BarShadow then
                SetRest(BarShadow, "Transparency", 1)
            end

            local Label = MakeText({
                Parent = Row.Instance,
                Text = Name,
                TextSize = 15,
                Anchor = Vector2.new(0, 0.5),
                Pos = UDim2.new(0, 15, 0.5, 0),
                Size = UDim2.new(1, -130, 0, 20),
                Color = "DimText",
                Truncate = true,
                Z = 5
            })

            local Data = {
                Name = Name,
                Slot = Slot,
                Row = Row
            }

            local function IconButton(Offset, Icon, Callback)
                local Image = MakeImage({
                    Parent = Row.Instance,
                    Icon = Icon,
                    Anchor = Vector2.new(1, 0.5),
                    Pos = UDim2.new(1, Offset, 0.5, 0),
                    Size = UDim2.fromOffset(15, 15),
                    Color = "DimText",
                    Z = 5
                })

                local Hit = MakeButton({
                    Parent = Row.Instance,
                    Anchor = Vector2.new(1, 0.5),
                    Pos = UDim2.new(1, Offset + 7, 0.5, 0),
                    Size = UDim2.fromOffset(28, 28),
                    Z = 6
                })

                Hit:OnHover(function()
                    Image:Tween({ ImageColor3 = Library.Theme.Text })
                end, function()
                    Image:Tween({ ImageColor3 = Library.Theme.DimText })
                end)

                Hit:Connect("MouseButton1Down", Callback)
            end

            IconButton(-66, "download", function()
                local Created

                pcall(function()
                    Created = HttpService:JSONDecode(readfile(ConfigPath(Name))).__created
                end)

                writefile(ConfigPath(Name), Library:GetConfig(Created))
                ShowInfo(Name)

                Library:Notification({
                    Name = "Config saved",
                    Description = "Current values were written into \"" .. Name .. "\".",
                    Icon = "download"
                })
            end)

            IconButton(-40, "share-2", function()
                if setclipboard then
                    pcall(function()
                        setclipboard(readfile(ConfigPath(Name)))
                    end)
                end

                Library:Notification({
                    Name = "Config copied",
                    Description = "\"" .. Name .. "\" was copied to your clipboard.",
                    Icon = "share-2"
                })
            end)

            IconButton(-14, "trash-2", function()
                if Data.Removing then return end
                Data.Removing = true

                if delfile and isfile and isfile(ConfigPath(Name)) then
                    delfile(ConfigPath(Name))
                end

                if Config.Selected == Name then
                    Config.Selected = nil
                    ShowInfo(nil)
                end

                local Index = table.find(Config.Rows, Data)
                if Index then table.remove(Config.Rows, Index) end

                local Sink = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

                Library:Tween({ Size = UDim2.new(1, 0, 0, 0) }, Sink, Slot.Instance)
                Row:FadeDescendants(false)

                Library:Notification({
                    Name = "Config deleted",
                    Description = "\"" .. Name .. "\" was removed.",
                    Icon = "trash-2"
                })

                task.delay(0.3, function()
                    Slot.Instance:Destroy()

                    local NewHeight = #Config.Rows * 52
                    Items.List.Instance.CanvasSize = UDim2.fromOffset(0, math.max(NewHeight - 8, 0))
                end)
            end)

            function Data:SetSelected(Active)
                local Key = Active and "Text" or "DimText"

                Label:ChangeItemTheme({ TextColor3 = Key })
                Label:Tween({ TextColor3 = Library.Theme[Key] })
                Library:Tween({ Size = UDim2.fromOffset(3, Active and 16 or 0) }, nil, Bar.Instance)

                if BarShadow then
                    Library:StampResting(BarShadow, "Transparency", Active and 0 or 1)
                    BarShadow.Transparency = Active and 0 or 1
                end
            end

            local Hit = MakeButton({
                Parent = Row.Instance,
                Size = UDim2.new(1, -96, 1, 0),
                Z = 5
            })

            Hit:Connect("MouseButton1Down", function()
                Config.Selected = Name

                for _, Other in Config.Rows do
                    Other:SetSelected(Other == Data)
                end

                ShowInfo(Name)
                Library:LoadConfigFile(Name)

                if RefreshThemeUI then
                    RefreshThemeUI()
                end

                Library:Notification({
                    Name = "Config loaded",
                    Description = "All values were restored from \"" .. Name .. "\".",
                    Icon = "check"
                })
            end)

            table.insert(Config.Rows, Data)
            return Data
        end

        RefreshList = function()
            for _, Data in Config.Rows do
                Data.Slot.Instance:Destroy()
            end

            Config.Rows = { }

            for Index, Name in Library:ListConfigs() do
                local Data = AddRow(Index, Name)
                Data:SetSelected(Name == Config.Selected)
            end

            local Height = #Config.Rows * 52
            Items.List.Instance.CanvasSize = UDim2.fromOffset(0, math.max(Height - 8, 0))
        end

        Items.CreateHit:Connect("MouseButton1Down", function()
            PlaySweep(Items.CreateSweep.Instance)

            local Name = string.gsub(Items.NameInput.Instance.Text, "[^%w _%-]", "")

            if Name == "" then
                Library:Notification({
                    Name = "Config name required",
                    Description = "Type a name into the box before creating.",
                    Icon = "triangle-alert"
                })

                return
            end

            if isfile and isfile(ConfigPath(Name)) then
                Library:Notification({
                    Name = "Name already used",
                    Description = "A config called \"" .. Name .. "\" already exists.",
                    Icon = "triangle-alert"
                })

                return
            end

            writefile(ConfigPath(Name), Library:GetConfig())
            Items.NameInput.Instance.Text = ""
            Config.Selected = Name
            RefreshList()
            ShowInfo(Name)

            Library:Notification({
                Name = "Config created",
                Description = "\"" .. Name .. "\" now holds your current values.",
                Icon = "plus"
            })
        end)

        local Blocks = {
            { Frame = Items.CreateBox, Home = UDim2.fromOffset(0, 0) },
            { Frame = Items.ListHolder, Home = UDim2.fromOffset(0, 52) },
            { Frame = Items.InfoPanel, Home = UDim2.new(0.5, 8, 0, 0) },
            { Frame = Items.ThemePanel, Home = UDim2.new(0.5, 8, 0, 216) }
        }

        local BlockSlide = 30
        local BlockStep = 0.06

        SubTab.PageIntro = function()
            Config.IntroToken += 1

            local Token = Config.IntroToken
            local Slide = TweenInfo.new(0.36, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

            for _, Block in Blocks do
                Block.Frame:CancelFade()
                Block.Frame.Instance.Visible = false
                Block.Frame.Instance.Position = Block.Home + UDim2.fromOffset(BlockSlide, 0)
            end

            for Index, Block in Blocks do
                task.delay((Index - 1) * BlockStep, function()
                    Block.Frame.Instance.Visible = true

                    if Config.IntroToken ~= Token then
                        Block.Frame.Instance.Position = Block.Home
                        return
                    end

                    Block.Frame:FadeDescendants(true)
                    Library:Tween({ Position = Block.Home }, Slide, Block.Frame.Instance)
                end)
            end
        end

        SubTab.PageOutro = function()
            Config.IntroToken += 1

            local Token = Config.IntroToken
            local Slide = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

            for Index, Block in Blocks do
                local Away = Block.Home + UDim2.fromOffset(-BlockSlide, 0)

                task.delay((Index - 1) * BlockStep, function()
                    if Config.IntroToken ~= Token then return end

                    Block.Frame:FadeDescendants(false)
                    Library:Tween({ Position = Away }, Slide, Block.Frame.Instance)
                end)
            end
        end

        function Config:Refresh()
            RefreshList()
        end

        RefreshList()
        ShowInfo(nil)

        return Config
    end

    Library.Watermark = function(Self, Params)
        Params = Params or { }

        if Library.WatermarkBar then
            return Library.WatermarkBar
        end

        local Icon = Params.Icon or (Self and Self.Icon) or Library.Logo or "layers"
        local Title = Params.Name or Params.Title or LocalPlayer.DisplayName
        local Items = { }
        local Order = 0

        Items.Bar = MakeFrame({
            Parent = Library.Holder.Instance,
            Anchor = Vector2.new(0.5, 0),
            Pos = UDim2.new(0.5, 0, 0, 14),
            Size = UDim2.fromOffset(0, 32),
            Color = "Section",
            Round = 8,
            Z = 60
        })

        Items.Bar.Instance.AutomaticSize = Enum.AutomaticSize.X

        Library:Create("UIPadding", {
            Parent = Items.Bar.Instance,
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12)
        })

        Library:Create("UIListLayout", {
            Parent = Items.Bar.Instance,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })

        local function NextOrder()
            Order += 1
            return Order
        end

        Items.Icon = MakeImage({
            Parent = Items.Bar.Instance,
            Icon = Icon,
            Size = UDim2.fromOffset(20, 20),
            Raw = Color3.new(1, 1, 1),
            Fit = true,
            Z = 61
        })

        Items.Icon.Instance.LayoutOrder = NextOrder()

        local function Separator()
            local Sep = MakeFrame({
                Parent = Items.Bar.Instance,
                Size = UDim2.fromOffset(1, 14),
                Color = "Light",
                Z = 61
            })

            Sep.Instance.LayoutOrder = NextOrder()
        end

        local function Stat(Text, ColorKey)
            local Label = MakeText({
                Parent = Items.Bar.Instance,
                Text = Text,
                TextSize = 14,
                Size = UDim2.fromOffset(0, 16),
                Color = ColorKey or "DimText",
                Z = 61
            })

            Label.Instance.AutomaticSize = Enum.AutomaticSize.X
            Label.Instance.LayoutOrder = NextOrder()

            return Label
        end

        local Good = Color3.fromRGB(96, 216, 148)
        local Fair = Color3.fromRGB(232, 190, 92)
        local Poor = Color3.fromRGB(232, 100, 100)

        local function Grade(Value, GoodAt, FairAt, Lower)
            if Lower then
                return (Value <= GoodAt and Good) or (Value <= FairAt and Fair) or Poor
            end

            return (Value >= GoodAt and Good) or (Value >= FairAt and Fair) or Poor
        end

        local function Reading(Value, Unit, Color)
            return ("<font color=\"#%s\">%d</font> %s"):format(Color:ToHex(), Value, Unit)
        end

        local function StatGroup(Glyph)
            local Holder = MakeFrame({
                Parent = Items.Bar.Instance,
                Size = UDim2.fromOffset(0, 18),
                Z = 61
            })

            Holder.Instance.AutomaticSize = Enum.AutomaticSize.X
            Holder.Instance.LayoutOrder = NextOrder()

            Library:Create("UIListLayout", {
                Parent = Holder.Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5)
            })

            local Image = MakeImage({
                Parent = Holder.Instance,
                Icon = Glyph,
                Size = UDim2.fromOffset(14, 14),
                Raw = Library.Theme.DimIcon,
                Fit = true,
                Z = 61
            })

            Image.Instance.LayoutOrder = 1

            local Label = MakeText({
                Parent = Holder.Instance,
                Text = "",
                TextSize = 14,
                Size = UDim2.fromOffset(0, 16),
                Color = "DimText",
                Z = 61
            })

            Label.Instance.AutomaticSize = Enum.AutomaticSize.X
            Label.Instance.RichText = true
            Label.Instance.LayoutOrder = 2

            return Label, Image
        end

        Separator()
        local NameStat = Stat(Title, "Text")
        Separator()
        local FpsStat, FpsGlyph = StatGroup("gravity:speedometer")
        Separator()
        local PingStat, PingGlyph = StatGroup("gravity:signal")

        FpsStat.Instance.Text = Reading(0, "fps", Good)
        PingStat.Instance.Text = Reading(0, "ms", Good)

        local Frames = 0
        local Since = os.clock()

        Library:Connect(RunService.RenderStepped, function()
            Frames += 1
        end)

        Library:Thread(function()
            while task.wait(0.5) do
                if not Items.Bar.Instance.Parent then break end

                local Now = os.clock()
                local Span = Now - Since
                local Fps = (Span > 0 and math.floor(Frames / Span + 0.5)) or 0

                Frames, Since = 0, Now

                local FpsColor = Grade(Fps, 50, 30)

                FpsStat.Instance.Text = Reading(Fps, "fps", FpsColor)
                FpsGlyph.Instance.ImageColor3 = FpsColor

                local Ping = 0

                pcall(function()
                    Ping = math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5)
                end)

                if Ping <= 0 then
                    pcall(function()
                        local Stat = StatsService.Network.ServerStatsItem["Data Ping"]
                        Ping = math.floor(Stat:GetValue())
                    end)
                end

                local PingColor = Grade(Ping, 110, 220, true)

                PingStat.Instance.Text = Reading(Ping, "ms", PingColor)
                PingGlyph.Instance.ImageColor3 = PingColor
            end
        end)

        Items.Bar:MakeDraggable()
        Library.WatermarkBar = Items.Bar

        local Watermark = { Instance = Items.Bar.Instance }

        if Self and Self.SetOpen then
            Library.WatermarkTarget = Self
        end

        do
            local PressAt, PressAt2, PressClock = nil, nil, 0

            local function IsPointer(Input)
                return Input.UserInputType == Enum.UserInputType.MouseButton1
                    or Input.UserInputType == Enum.UserInputType.Touch
            end

            Library:Connect(Items.Bar.Instance.InputBegan, function(Input)
                if not IsPointer(Input) then return end

                PressAt = Input.Position
                PressAt2 = Vector2.new(PressAt.X, PressAt.Y)
                PressClock = os.clock()
            end)

            Library:Connect(Items.Bar.Instance.InputEnded, function(Input)
                if not IsPointer(Input) or not PressAt2 then return end

                local Here = Vector2.new(Input.Position.X, Input.Position.Y)
                local Moved = (Here - PressAt2).Magnitude

                PressAt, PressAt2 = nil, nil

                if Moved > 6 or os.clock() - PressClock > 0.6 then return end

                local Target = Library.WatermarkTarget or Library.Windows[1]

                if Target and Target.SetOpen then
                    Target:SetOpen(not Target.IsOpen)
                end
            end)
        end

        function Watermark:SetIcon(NewIcon)
            ApplyIcon(Items.Icon.Instance, NewIcon)
        end

        function Watermark:SetName(Text)
            NameStat.Instance.Text = tostring(Text or "")
        end

        function Watermark:SetTarget(Window)
            Library.WatermarkTarget = Window
        end

        function Watermark:SetVisible(Bool)
            Items.Bar:FadeDescendants(Bool)
        end

        return Watermark
    end

    Library.GetConfig = function(Self, Created)
        local Config = { }

        for Index, Value in Library.Flags do
            if typeof(Value) == "Color3" then
                Config[Index] = { __color = Value:ToHex() }
            else
                Config[Index] = Value
            end
        end

        local ThemeColors = { }

        for _, Key in Library.ThemeKeys do
            ThemeColors[Key] = Library.Theme[Key]:ToHex()
        end

        Config.__accent = Library.Theme.Accent:ToHex()
        Config.__theme = ThemeColors
        Config.__created = Created or os.date("%d.%m.%Y %H:%M")
        Config.__version = Library.Version
        Config.__creator = LocalPlayer.DisplayName

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(Self, Config)
        local Ok, Decoded = pcall(function()
            return HttpService:JSONDecode(Config)
        end)

        if not Ok or type(Decoded) ~= "table" then return false end

        Library.Silent = true

        for Index, Value in Decoded do
            local SetFunction = Library.SetFlags[Index]
            if not SetFunction then continue end

            if type(Value) == "table" and Value.__color then
                SetFunction(Color3.fromHex(Value.__color), Value.__alpha)
            else
                SetFunction(Value)
            end
        end

        if type(Decoded.__theme) == "table" then
            for Key, Hex in Decoded.__theme do
                local OkColor, Color = pcall(Color3.fromHex, Hex)
                if OkColor then Library.Theme[Key] = Color end
            end

            DeriveTheme()
            Library.ThemeDirty = true
        end

        if type(Decoded.__accent) == "string" then
            local OkColor, Color = pcall(Color3.fromHex, Decoded.__accent)
            if OkColor then Library:SetAccent(Color) end
        end

        Library.Silent = false
        return true
    end

    Library.SaveConfigFile = function(Self, Name)
        if not writefile then return false end

        writefile(Library.ConfigFolder .. "/" .. Name .. ".json", Library:GetConfig())
        return true
    end

    Library.LoadConfigFile = function(Self, Name)
        if not isfile then return false end

        local Path = Library.ConfigFolder .. "/" .. Name .. ".json"
        if not isfile(Path) then return false end

        return Library:LoadConfig(readfile(Path))
    end

    Library.ListConfigs = function(Self)
        local Result = { }

        if not listfiles then return Result end

        for _, File in listfiles(Library.ConfigFolder) do
            if string.sub(File, -5) ~= ".json" then continue end

            local Name = string.match(File, "([^/\\]+)%.json$")
            if Name then table.insert(Result, Name) end
        end

        return Result
    end

    Library:Connect(RunService.Heartbeat, function(Delta)
        if Library.ThemeDirty then
            Library.ThemeDirty = false
            Library:ApplyThemeInstant()
        end

        if not Library.PreloadDirty then return end

        Library.PreloadClock += Delta or 0

        if Library.PreloadClock >= 0.35 then
            Library.PreloadDirty = false
            Library.PreloadClock = 0
            Library:PreloadAll()
        end
    end)

    getgenv().PulseLib = Library
end

return Library
