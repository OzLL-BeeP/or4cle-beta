-- OR4CLE v5 Design Tokens
-- Semua nilai UI di sini. Ubah sekali, kepakai di semua komponen.

return {
    -- ============ COLOR PALETTE ============
    -- Setiap warna punya 2-3 shade buat depth, bukan flat.

    -- Aksen utama
    AccentA      = {139, 92, 246},     -- ungu
    AccentB      = {59, 130, 246},     -- biru
    AccentSoft   = {168, 85, 247},     -- ungu light (glow)
    AccentDim    = {88, 62, 156},      -- ungu gelap (border subtle)
    AccentBright = {186, 137, 255},    -- ungu terang (hover)

    -- Background (hue ungu halus, bukan abu netral)
    BgRoot       = {8, 8, 14},
    BgWindow     = {14, 14, 24},
    BgPanel      = {20, 20, 31},
    BgCard       = {26, 26, 40},
    BgElem       = {35, 35, 54},
    BgHover      = {44, 44, 66},
    BgActive     = {58, 58, 84},

    -- Border (3 tingkat: subtle, normal, strong)
    BorderSubtle = {36, 36, 52},
    BorderNormal = {48, 48, 70},
    BorderStrong = {68, 68, 96},
    BorderAccent = {139, 92, 246},

    -- Text (4 tingkat)
    TextPrimary   = {245, 245, 252},
    TextSecondary = {172, 172, 198},
    TextMuted     = {110, 110, 140},
    TextDisabled  = {68, 68, 88},

    -- Status
    Success      = {74, 222, 128},
    Warning      = {251, 191, 36},
    Error        = {248, 113, 113},
    Info         = {96, 165, 250},

    -- Tier (egg rarity) — sama kayak sebelumnya
    TierEthereal = {255, 100, 255},
    TierDivine   = {255, 215, 0},
    TierMythic   = {255, 80, 80},
    TierLegend   = {255, 150, 50},
    TierEpic     = {180, 100, 255},
    TierRare     = {80, 160, 255},
    TierCommon   = {180, 180, 180},

    -- ============ SPACING SCALE ============
    -- Pakai angka konsisten: 4, 8, 12, 16, 20, 24, 32
    SpacingXXS = 4,
    SpacingXS  = 8,
    SpacingS   = 12,
    SpacingM   = 16,   -- default padding
    SpacingL   = 20,
    SpacingXL  = 24,
    SpacingXXL = 32,

    -- Khusus untuk layout
    Pad        = 16,   -- padding window
    GapSection = 20,   -- gap antar section
    GapItem    = 4,    -- gap antar item
    PadCard    = 14,   -- padding dalam card item

    -- ============ CORNER RADIUS ============
    RadiusWindow = 14,
    RadiusPanel  = 10,
    RadiusCard   = 8,
    RadiusButton = 8,
    RadiusTag    = 4,
    RadiusPill   = 999,

    -- ============ FONT HIERARCHY ============
    -- Konsisten, gak asal gede-kecil
    FontTitle    = 15,   -- judul window
    FontHeading  = 13,   -- judul panel/card
    FontLabel    = 13,   -- label item utama
    FontValue    = 12,   -- nilai (angka)
    FontHelper   = 11,   -- subtitle / helper text
    FontSmall    = 10,   -- section header uppercase
    FontTiny     = 9,    -- tag / badge

    -- ============ ANIMATION ============
    -- Durasi konsisten, beda per konteks
    AnimFast    = 0.12,  -- hover, klik feedback
    AnimNormal  = 0.20,  -- toggle, button
    AnimSlow    = 0.30,  -- buka/tutup window
    AnimSpring  = 0.25,  -- bounce effect

    -- ============ DIMENSIONS ============
    -- Window
    WinW = 520,
    WinH = 400,
    WinMinW = 420,
    WinMinH = 320,

    -- Sidebar
    SidebarW = 130,

    -- Top bar
    TopBarH = 52,

    -- Item
    ItemH      = 36,   -- tinggi toggle/button
    ItemCardH  = 40,   -- tinggi card lebih lega
    SectionH   = 30,   -- tinggi section header

    -- Bubble
    BubbleSize = 50,
    BubbleX    = 80,
    BubbleY    = 200,

    -- ============ ASSET ============
    LogoId = "rbxassetid://114651091062453",

    -- ============ METADATA ============
    ProductName = "OR4CLE",
    ProductSub  = "R I D E  A  P E T",
    Version     = "v5.0-beta",
    BuildDate   = "2026-10",
}
