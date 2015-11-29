local KEYBOARD_KEYS = {
  {off =   0, keys = {"1", "2", "3", "4", "5", "6", "7", "8", "9"}},
  {off = 0.5, keys = {"q", "w", "e", "r", "t", "y", "u", "i", "o", "p"}},
  {off =   1, keys = {"a", "s", "d", "f", "g", "h", "j", "k", "l"}},
  {off = 1.5, keys = {"z", "x", "c", "v", "b", "n", "m"}},
}

local KEY_SPACING_Y = 138
local KEY_SPACING_X = 110

local kb_by_key = {}

for i, row in ipairs(KEYBOARD_KEYS) do
  for j, key in ipairs(row.keys) do
    kb_by_key[key] = {row = i, col = j + row.off}
  end
end

local mt = {__index = {}}

mt.__index.window_size = 0.5

function mt.__index:__init(song)
  self.song = song

  self.source = love.audio.newSource(song.filename)
  self.source:play()
  --self.source:seek(30)
  --self.source:setPitch(0.5)

  self.key_index = 1
  self.spent = {}
  self.timeline_y = {}
  self.effects = {}

  self.font = love.graphics.newFont("assets/fonts/Montserrat-Regular.otf", 18)
  self.font_timeline =
    love.graphics.newFont("assets/fonts/Montserrat-Regular.otf", 20)
  self.font_hairline =
    love.graphics.newFont("assets/fonts/Montserrat-Hairline.otf", 96)
  self.font_regular =
    love.graphics.newFont("assets/fonts/Montserrat-Regular.otf", 96)

  self:calculate_keyboard_pos()
  -- self:seek(50)
end

function mt.__index:seek(beat)
  self.source:seek(beat * (1 / (self.song.bpm / 60)))

  for i, entry in ipairs(self.song.keys) do
    if entry[1] < beat then
      self.key_index = i
    else
      break
    end
  end
end

function mt.__index:calculate_keyboard_pos()
  local gw, gh = love.graphics.getDimensions()
  local kw, kh = 0, #KEYBOARD_KEYS * KEY_SPACING_Y

  -- Figure out how much space the keyboard takes up
  for _, row in ipairs(KEYBOARD_KEYS) do
    kw = math.max(kw, (#row.keys + row.off) * KEY_SPACING_X)
  end

  self.kb_x = gw / 2 - kw / 2
  self.kb_y = gh / 2 - kh / 2
end

mt.__index.resize = mt.__index.calculate_keyboard_pos

function mt.__index:keypressed(key)
  key = key:lower()

  if not kb_by_key[key] then
    return
  end

  local beat = self:get_beat()
  local quan = 1/8
  print("{" .. math.floor(beat / quan + 0.5) * quan .. ", \"" .. key .. "\"},")

  for i = self.key_index, #self.song.keys do
    local entry = self.song.keys[i]

    if entry[2] == key then
      local offset = entry[1] - beat

      if offset <= self.window_size and not self.spent[entry] then
        self.spent[entry] = true
        table.insert(self.effects, {
          key = key, t = 0, dur = 0.5, bad = false, scale = 0.5
        })
        return
      end
    end
  end

  table.insert(self.effects, {key = key, t = 0, dur = 0.25, bad = true, scale = 1})
end

function mt.__index:get_beat()
  return self.source:tell() / (1 / (self.song.bpm / 60))
end

function mt.__index:update(dt)
  -- Fade out effects over time
  do
    local i = 1

    while i <= #self.effects do
      local effect = self.effects[i]
      effect.t = effect.t + dt

      if effect.t >= effect.dur then
        table.remove(self.effects, i)
      else
        i = i + 1
      end
    end
  end

  -- Check for missed notes
  local beat = self:get_beat()

  for i = self.key_index, #self.song.keys do
    local entry = self.song.keys[i]
    local offset = entry[1] - beat

    if offset < -self.window_size and not self.spent[entry] then
      self.key_index = i + 1
      table.insert(self.effects, {key = entry[2], t = 0, dur = 0.25, bad = true, scale = 0.25})
      break
    end

  end
end

function mt.__index:find_key_position(key)
  local pos = kb_by_key[key]

  local y = (pos.row - 1) * KEY_SPACING_Y
  local x = (pos.col - 1) * KEY_SPACING_X

  return self.kb_x + x, self.kb_y + y
end

function mt.__index:draw()
  local beat = self:get_beat()
  love.graphics.setFont(self.font)
  love.graphics.setColor(255, 255, 255)
  -- love.graphics.printf(tostring(beat) .. "\n" .. tostring(self.key_index), 8, 8, 5000)

  local spacing_x_over_2 = KEY_SPACING_X / 2
  local font_y_over_2 = self.font_hairline:getHeight() / 2

  for _, effect in ipairs(self.effects) do
    local key = effect.key
    local t = effect.t / effect.dur

    love.graphics.push()
    love.graphics.translate(self:find_key_position(key))
    love.graphics.translate(spacing_x_over_2, font_y_over_2)

    love.graphics.setFont(self.font_regular)

    if effect.bad then
      love.graphics.setColor(255, 50, 40, 255 * (1 - t))
    else
      love.graphics.setColor(200, 230, 255, 255 * (1 - t))
    end

    love.graphics.scale(0.5 + effect.scale * t)
    love.graphics.printf(key:upper(), -spacing_x_over_2, -font_y_over_2,
      KEY_SPACING_X, "center")

    love.graphics.pop()
  end

  local drew_back = {}
  local approach_size = 3

  for i = self.key_index, #self.song.keys do
    local entry = self.song.keys[i]
    local offset = entry[1] - beat

    if offset <= approach_size and offset >= -self.window_size and not self.spent[entry] then
      local key = entry[2]
      local approach = math.max(0, offset) / approach_size

      love.graphics.push()
      love.graphics.translate(self:find_key_position(key))
      love.graphics.translate(spacing_x_over_2, font_y_over_2)

      if not drew_back[key] then
        love.graphics.push()
        love.graphics.setFont(self.font_regular)
        love.graphics.setColor(255, 255, 255, 100)
        love.graphics.scale(0.5)
        love.graphics.printf(key:upper(), -spacing_x_over_2, -font_y_over_2,
          KEY_SPACING_X, "center")
        love.graphics.pop()
        drew_back[key] = true
      end

      love.graphics.setFont(self.font_hairline)
      love.graphics.setColor(255, 255, 255, (1 - approach) * 255)
      love.graphics.scale(0.5 + approach * 1.5)
      love.graphics.printf(key:upper(), -spacing_x_over_2, -font_y_over_2,
        KEY_SPACING_X, "center")

      love.graphics.pop()

      -- love.graphics.push()
      -- love.graphics.translate(300, 8)

    --   do
    --     local tx = offset * 20
    --     local n = 1
    --
    --     while n <= #inc_until do
    --       if tx > inc_until[n] then
    --         table.remove(inc_until, n)
    --       else
    --         n = n + 1
    --       end
    --     end
    --
    --     if self.timeline_y[entry] == nil then
    --       self.timeline_y[entry] = self.font_timeline:getHeight() * #inc_until
    --     end
    --
    --     love.graphics.setFont(self.font_timeline)
    --     love.graphics.setColor(255, 255, 255)
    --     love.graphics.print(key:upper(), tx, self.timeline_y[entry])
    --     table.insert(inc_until, tx + self.font_timeline:getWidth(key:upper()))
    --   end
    --
    --   love.graphics.pop()
    end
  end
end

setmetatable(mt, {
  __call = function(self, ...)
    local inst = setmetatable({}, self)
    inst:__init(...)
    return inst
  end
})

return mt
