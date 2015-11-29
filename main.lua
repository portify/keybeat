local game = require("game")
local inst

function love.load()
end

function love.resize()
  if inst then inst:resize() end
end

function love.keypressed(key)
  if inst then
    inst:keypressed(key)
  elseif key == "space" then
    inst = game({
      filename = "assets/music/Stonebank - Chokehold.mp3",
      bpm = 110,
      keys = {
        {16, "g"},
        {17, "g"},
        {18, "g"},
        {19, "g"},
        {20, "g"},
        {21, "g"},
        {22, "g"},
        {23, "g"},
        {24, "f"},
        {25, "f"},
        {26, "f"},
        {27, "f"},
        {28, "f"},
        {29, "f"},
        {30, "f"},
        {31, "v"},
        {32, "b"},
        {33, "b"},
        {34, "b"},
        {35, "b"},
        {36, "b"},
        {37, "b"},
        {38, "b"},
        {39.5, "h"},
        {40.5, "n"},

        -- {48, "d"}, {48, "g"},
        -- {49, "g"},
        -- {49.25, "d"},
        -- {49.75, "g"},
        -- {50.25, "d"},
        -- {50.5, "g"},
        -- {51, "g"},
        -- {51.25, "d"},
        -- {51.5, "g"},
        -- {51.75, "g"}

        {48.125, "a"},
        {48.125, "d"},
        {49, "s"},
        {49, "f"},
        {49.75, "f"},
        {50.5, "g"},
        {51, "h"},
        {51.5, "j"},
        {51.75, "j"},
        {52.25, "k"},
        {53.125, "l"},
        {53.75, "k"},
        {54.25, "j"},
        {54.625, "j"},
        {54.75, "j"},
        {55.125, "h"},
        {55.5, "h"},
        {55.75, "g"},

        {56.25, "z"},
        {57, "x"},
        {57.75, "c"},
        {58.25, "v"},
        {60.375, "z"},
        {61, "x"},
        {61.75, "c"},
        {62.25, "v"},
        -- {63.375, "h"},

        {64.125, "g"},
        {65.125, "h"},
        {65.75, "j"},
        {66.25, "k"},
        {68.25, "b"},
        {69, "n"},
        {69.875, "m"},
        {70.375, "k"},
        {72.25, "d"},
        {73.125, "r"},
        {73.75, "t"},
        {74.25, "y"},

        {76.375, "g"},
        {77.25, "g"},
        {77.875, "f"},
        {78.125, "f"},
        {78.5, "f"},
        {79.125, "d"},
        {79.375, "d"},
        {79.75, "d"},
        {80.25, "s"},
        {82.25, "n"},
        {82.25, "v"},
        {84.375, "v"},
        {84.375, "n"},
        {86.25, "v"},
        {86.25, "n"},
        {87.25, "m"},
        {87.25, "b"},
        {88.375, "h"},
        {88.375, "k"},
        {90.25, "k"},
        {90.25, "h"},
        {92.25, "k"},
        {92.25, "h"},
        {94.375, "o"},
        {94.375, "u"},
        {95.375, "l"},
        {95.375, "j"},
        {96.375, "t"},
        {96.75, "t"},
        {97.375, "r"},
      }
    })
  end
end

function love.update(dt)
  if inst then inst:update(dt) end
end

function love.draw()
  if inst then inst:draw() end
end

-- local KEYBOARD_KEYS = {
--   {off =   0, keys = {"1", "2", "3", "4", "5", "6", "7", "8", "9"}},
--   {off = 0.5, keys = {"q", "w", "e", "r", "t", "y", "u", "i", "o", "p"}},
--   {off =   1, keys = {"a", "s", "d", "f", "g", "h", "j", "k", "l"}},
--   {off = 1.5, keys = {"z", "x", "c", "v", "b", "n", "m"}},
-- }
--
-- local KEY_SPACING_Y = 138
-- local KEY_SPACING_X = 110
--
-- local font, font_hairline, font_regular
-- local kb_by_key, kb_x, kb_y
-- local source, song_bpm, song_keys, keys_spent
-- local window_size
--
-- local function calculate_keyboard_pos()
--   local gw, gh = love.graphics.getDimensions()
--   local kw, kh = 0, #KEYBOARD_KEYS * KEY_SPACING_Y
--
--   -- Figure out how much space the keyboard takes up
--   for _, row in ipairs(KEYBOARD_KEYS) do
--     kw = math.max(kw, (#row.keys + row.off) * KEY_SPACING_X)
--   end
--
--   kb_x = gw / 2 - kw / 2
--   kb_y = gh / 2 - kh / 2
-- end
--
-- function love.load()
--   source = love.audio.newSource("assets/music/Stonebank - Chokehold.mp3")
--   source:play()
--   source:seek(5)
--   song_bpm = 110
--   song_keys = {
--     {16, "g"},
--   }
--   keys_spent = {}
--   window_size = 0.5
--
--   font = love.graphics.newFont("assets/fonts/Montserrat-Regular.otf", 18)
--   font_hairline = love.graphics.newFont("assets/fonts/Montserrat-Hairline.otf", 96)
--   font_regular = love.graphics.newFont("assets/fonts/Montserrat-Regular.otf", 96)
--
--   kb_by_key = {}
--
--   for i, row in ipairs(KEYBOARD_KEYS) do
--     for j, key in ipairs(row.keys) do
--       kb_by_key[key] = {row = i, col = j + row.off}
--     end
--   end
--
--   calculate_keyboard_pos()
-- end
--
-- love.resize = calculate_keyboard_pos
--
-- function love.keypressed(key)
--   local time = source:tell()
--   local beat = time / (1 / (song_bpm / 60))
--
--   for _, entry in ipairs(song_keys) do
--     repeat
--       if entry[2] ~= key:lower() then
--         break
--       end
--
--       local offset = entry[1] - beat
--
--       if offset > window_size or offset < -window_size or keys_spent[entry] then
--         break
--       end
--
--       keys_spent[entry] = true
--       return
--     until false
--   end
-- end
--
-- local function find_key_position(key)
--   local pos = kb_by_key[key]
--
--   local y = (pos.row - 1) * KEY_SPACING_Y
--   local x = (pos.col - 1) * KEY_SPACING_X
--
--   return kb_x + x, kb_y + y
-- end
--
-- function love.draw()
--   local time = source:tell()
--   local beat = time / (1 / (song_bpm / 60))
--   -- local beat_frac = beat - math.floor(beat)
--   love.graphics.setFont(font)
--   love.graphics.setColor(255, 255, 255)
--   love.graphics.printf(tostring(beat), 8, 8, 5000)
--
--   local spacing_x_over_2 = KEY_SPACING_X / 2
--   local font_y_over_2 = font_hairline:getHeight() / 2
--
--   -- for key in pairs(kb_by_key) do
--   --   love.graphics.push()
--   --   love.graphics.translate(find_key_position(key))
--   --   love.graphics.translate(spacing_x_over_2, font_y_over_2)
--   --
--   --   love.graphics.push()
--   --   love.graphics.setFont(font_hairline)
--   --   love.graphics.setColor(255, 255, 255)
--   --   love.graphics.scale(0.5)
--   --   love.graphics.printf(key:upper(), -spacing_x_over_2, -font_y_over_2,
--   --     KEY_SPACING_X, "center")
--   --   love.graphics.pop()
--   --
--   --   love.graphics.setFont(font_hairline)
--   --   love.graphics.setColor(255, 255, 255, beat_frac * 255)
--   --   love.graphics.scale(0.5 + (1 - beat_frac))
--   --   love.graphics.printf(key:upper(), -spacing_x_over_2, -font_y_over_2,
--   --     KEY_SPACING_X, "center")
--   --
--   --   love.graphics.pop()
--   -- end
--
--   local approach_size = 4
--
--   for _, entry in ipairs(song_keys) do
--     local offset = entry[1] - beat
--
--     if offset <= approach_size and offset >= -window_size and not keys_spent[entry] then
--       local key = entry[2]
--       local approach = math.max(0, offset) / approach_size
--
--       love.graphics.push()
--       love.graphics.translate(find_key_position(key))
--       love.graphics.translate(spacing_x_over_2, font_y_over_2)
--
--       love.graphics.push()
--       love.graphics.setFont(font_regular)
--       love.graphics.setColor(255, 255, 255, 100)
--       love.graphics.scale(0.5)
--       love.graphics.printf(key:upper(), -spacing_x_over_2, -font_y_over_2,
--         KEY_SPACING_X, "center")
--       love.graphics.pop()
--
--       love.graphics.setFont(font_hairline)
--       love.graphics.setColor(255, 255, 255, (1 - approach) * 255)
--       love.graphics.scale(0.5 + approach)
--       love.graphics.printf(key:upper(), -spacing_x_over_2, -font_y_over_2,
--         KEY_SPACING_X, "center")
--
--       love.graphics.pop()
--     end
--   end
--
--   -- for i, row in ipairs(KEYBOARD_KEYS) do
--   --   love.graphics.push()
--   --   love.graphics.translate(0, (i - 1) * KEY_SPACING_Y)
--   --
--   --   for j, key in ipairs(row.keys) do
--   --     love.graphics.push()
--   --     love.graphics.translate((j - 1 + row.off) * KEY_SPACING_X, 0)
--   --     love.graphics.printf(key:upper(), 0, 0, KEY_SPACING_X, "center")
--   --     love.graphics.pop()
--   --   end
--   --
--   --   love.graphics.pop()
--   -- end
--   --
--   -- love.graphics.pop()
-- end
