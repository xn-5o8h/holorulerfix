require "/scripts/vec2.lua"

function init()
  self.pointCache = {}
  self.holoRulerConfig = {}
  self.distanceCache = nil
end

function uninit()
  localAnimator.clearDrawables()
end

function update()

  local redraw = false
  local holoRulerConfig = animationConfig.animationParameter("holoRulerConfig")
  if holoRulerConfig == nil then return end
  local point1 = animationConfig.animationParameter("point1")
  local point2 = animationConfig.animationParameter("point2")
  local userPos = animationConfig.animationParameter("userPos")

  if self.pointCache[1] == nil or vec2.eq(point1, self.pointCache[1]) == false then
    redraw = true
    self.pointCache[1] = point1
  end
  if self.pointCache[2] == nil or vec2.eq(point2, self.pointCache[2]) == false then
    redraw = true
    self.pointCache[2] = point2
  end
  if compareConfigs(self.holoRulerConfig, holoRulerConfig) == false then
    redraw = true
    self.holoRulerConfig = holoRulerConfig
  end
  self.pointCache[1] = point1
  self.pointCache[2] = point2
  self.holoRulerConfig = holoRulerConfig

  
  if redraw == true or self.holoRulerConfig.textMode == 1 then
    localAnimator.clearDrawables()
    self.distanceCache = nil
    if point1 then
      localAnimator.addDrawable({
        image = self.holoRulerConfig.image:gsub("<variant>", 1),
        fullbright = true,
        position = point1,
        centered = false,
        color = self.holoRulerConfig.color
      }, "overlay")
    end
    if point2 then
      localAnimator.addDrawable({
        image = self.holoRulerConfig.image:gsub("<variant>", 2),
        fullbright = true,
        position = point2,
        centered = false,
        color = self.holoRulerConfig.color
      }, "overlay")
    end
    -- TODO: alternative approach with the grid fill
    if point1 and point2 then
      self.distanceCache = world.distance(point2, point1)
      localAnimator.addDrawable({
        line = {{0,0}, self.distanceCache},
        fullbright = true,
        width = 1,
        color = self.holoRulerConfig.color,
        position = {point1[1]+0.5, point1[2]+0.5}
      }, "overlay")
      
    end
    self.nonce = 0
    if self.holoRulerConfig.textMode == 2 and point1 and point2 then
      -- REM: calculate with point1 as origin
      -- boy oh boy, would this be a pain to reverse engineer ^-^
      local drawables = compileText(self.distanceCache)
      local angle = vec2.angle(vec2.sub(point2, point1))
      local lineVec = vec2.sub(point2, point1)
      local mid1 = { vec2.mag(lineVec)/2, 0}
      local sgn = point2[1]-point1[1]>=0 and 1 or -1
      local relPos1 = vec2.add(mid1, {drawables[2]/2*-math.cos(angle), sgn} )
      local relPos = vec2.rotate(relPos1, angle)
      local absPos = vec2.add(point1, relPos)

      -- this is for angled text; needs work
      --[[if math.abs(math.tan(angle))>1 then
        angle = 0
      elseif math.cos(angle)<0 then
        angle = angle + math.pi
      end]]--
      angle = 0
      for i=1,#drawables[1] do
        drawables[1][i].position = vec2.add(vec2.rotate(drawables[1][i].position, angle), absPos)
        drawables[1][i].rotation = angle
        localAnimator.addDrawable(drawables[1][i], "overlay")
      end
    end
  end
  
  if self.holoRulerConfig.textMode == 1 and self.distanceCache then
    local drawables = compileText(self.distanceCache)
    for i=1,#drawables[1] do
      drawables[1][i].position = vec2.add({ userPos[1] - drawables[2]/2, userPos[2] + 2 }, drawables[1][i].position)
      localAnimator.addDrawable(drawables[1][i], "overlay")
    end
  end

end

function compareColors(color1, color2)
  return color1 ~= nil and color2 ~= nil and color1[1] == color2[1] and color1[2] == color2[2] and color1[3] == color2[3] and color1[4] == color2[4]
end

function compareConfigs(config1, config2)
  return config1 ~= nil and config2 ~= nil and compareColors(config1.color, config2.color) and compareColors(config1.textColor, config2.textColor) and config1.showGrid == config2.showGrid and config1.textMode == config2.textMode
end

function compileText(distance)
  local dx = math.abs(math.floor(distance[1]))+1
  local dy = math.abs(math.floor(distance[2]))+1
  --dx = math.min(dx, 999)
  --dy = math.min(dy, 999)
  local str = tostring(dx).."x"..tostring(dy)
  local drawables = {}
  local offsetXAcc = 0
  for i=1,#str do
    local tempch = str:sub(i,i)
    local chpos=nil
    local img=nil

    if tempch:match("[0,2-9]") then
      --chpos = vec2.add({playerPos[1]-(#str*0.75/2), playerPos[2]}, offsetXAcc)
      chpos = { offsetXAcc, 0 }
      img = self.holoRulerConfig.text12:gsub("<variant>", tempch)
      offsetXAcc = offsetXAcc + 7/8
    elseif tempch:match("[1x ]") then
      --chpos = vec2.add({playerPos[1]-(#str*0.75/2), playerPos[2]}, offsetXAcc)
      chpos = { offsetXAcc, 0 }
      img = self.holoRulerConfig.text10:gsub("<variant>", tempch)
      offsetXAcc = offsetXAcc + 6/8
    end
    if chpos ~= nil and img ~= nil then
      table.insert(drawables,{
        image = img,
        fullbright = true,
        position = chpos,
        centered = false,
        color = self.holoRulerConfig.textColor
      })
    end
  end
  return {drawables, offsetXAcc}
end