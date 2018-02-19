local Object = require '/libraries/classic/classic'
local Input  = require '/libraries/boipushy/Input'
local Timer  = require '/libraries/enhanced_timer/EnhancedTimer'
local _      = require '/libraries/Moses/moses_min'

function love.load()
  local object_files = {}
  recursiveEnumerate('objects', object_files)
  requireFiles(object_files)

  -- Input library removes the need to thread keypressed callbacks through
  -- connected models (e.g player in a level in a game) using the usual
  -- love.keypressed, etc.
  input = Input()
  -- Don't forget to update this in love.update
  timer = Timer()
  rect_1 = {x = 400, y = 300, w = 50, h = 200}
  rect_2 = {x = 400, y = 300, w = 200, h = 50}

  timer:tween(1, rect_1, {w = 0}, 'in-out-cubic', function()
    timer:tween(2, rect_2, {h = 0}, 'in-out-cubic', function()
      timer:tween(2, rect_1, {w = 50}, 'in-out-cubic')
      timer:tween(2, rect_2, {h = 50}, 'in-out-cubic')
    end)
  end)
end

function love.update(dt)
  timer:update(dt)
end

function love.draw()
  love.graphics.rectangle('fill', rect_1.x - rect_1.w/2, rect_1.y - rect_1.h/2, rect_1.w, rect_1.h)
  love.graphics.rectangle('fill', rect_2.x - rect_2.w/2, rect_2.y - rect_2.h/2, rect_2.w, rect_2.h)
end

function love.keypressed(key)
end

function love.keyreleased(key)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function recursiveEnumerate(folder, file_list)
  local items = love.filesystem.getDirectoryItems(folder)
  for _, item in ipairs(items) do
    local file = folder .. '/' .. item
    if love.filesystem.isFile(file) then
      table.insert(file_list, file)
    elseif love.filesystem.isDirectory(file) then
      recursiveEnumerate(file, file_list)
    end
  end
end

function requireFiles(files)
  for _, item in ipairs(files) do
    local file = item:sub(1, -5) -- remove ".lua" from the require statement
    require(file)
  end
end
