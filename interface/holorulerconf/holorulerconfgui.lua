StaticEl = {}
function StaticEl:new(id, pos, size, imgd)
  local newEl = {}
  setmetatable(newEl, extend(self))
  newEl.id = id
  newEl.pos = pos
  newEl.size = size
  newEl.imgDefault = imgd
  newEl._type = "static"
  return newEl
end

function StaticEl:draw()
  canvas:drawImage(self.imgDefault, self.pos, 1)
end

TextEl = {}
function TextEl:new(id, pos, size, imgd, text, textOffset, colour)
  local newEl = {}
  setmetatable(newEl, extend(self))
  newEl.id = id
  newEl.pos = pos
  newEl.size = size
  newEl.imgDefault = imgd
  newEl.text = text
  newEl.textOffset = textOffset
  newEl.colour = colour
  newEl._type = "text"
  return newEl
end

function TextEl:draw()
  if self.imgDefault then
    canvas:drawImage(self.imgDefault, self.pos, 1)
  end
  --canvas:drawText(tostring(self.text), {position=vec2.add(self.pos, self.textOffset)}, 8, self.colour)
end

ButtonEl = {}
function ButtonEl:new(id, pos, size, imgd, imgh, imgp, text, textoffset, colour)
  local newEl = {}
  setmetatable(newEl, extend(self))
  newEl.id = id
  newEl.pos = pos
  newEl.size = size
  newEl.imgDefault = imgd
  newEl.imgHover = imgh
  newEl.imgPressed = imgp
  newEl.text = text
  newEl.textOffset = textoffset
  newEl.colour = colour
  newEl.status = 0
  newEl._type = "button"
  return newEl
end

function ButtonEl:draw()
  canvas = widget.bindCanvas('scriptCanvas')
  if self.imgDefault then
    if self.status == 0 then
      canvas:drawImage(self.imgDefault, self.pos, 1)
    elseif self.status == 1 then
      canvas:drawImage(self.imgHover or self.imgDefault, self.pos, 1)
    elseif self.status == 2 then
      canvas:drawImage(self.imgPressed or self.imgDefault, self.pos, 1)
    end
  end
  if self.text then
    canvas:drawText(self.text, {position=vec2.add(self.pos, self.textOffset), horizontalAnchor="mid"}, 7, self.colour)
  end
end

function ButtonEl:onClick()
  return true
end

ColourDisplayEl = {}
function ColourDisplayEl:new(id, pos, size, imgd, clroffset, clrsize, colour)
  local newEl = {}
  setmetatable(newEl, extend(self))
  newEl.id = id
  newEl.pos = pos
  newEl.size = size
  newEl.imgDefault = imgd
  newEl.clrOffset = clroffset
  newEl.clrSize = clrsize
  newEl.colour = colour
  newEl._type = "clrdisp"
  return newEl
end

function ColourDisplayEl:draw()
  local cRect = {
    self.pos[1]+self.clrOffset[1],
    self.pos[2]+self.clrOffset[2],
    self.pos[1]+self.clrOffset[1]+self.clrSize[1],
    self.pos[2]+self.clrOffset[2]+self.clrSize[2]
  }
  canvas:drawImage(self.imgDefault, self.pos, 1)
  canvas:drawRect(cRect, self.colour)
end

--===============================================--

function init()
  canvas = widget.bindCanvas('scriptCanvas')
  -- activate(1, 2, 3): 3 -> config{}
  local COLOUR_WHITE = {255,255,255,255}
  self.HRState = config.getParameter("HRState") --{color, textColor, showGrid, textMode}
  self.formState = { activeColour = self.HRState.color }
  self.controls = {
    markerBtn = ButtonEl:new("markerBtn", {138,98}, {38,12}, "/interface/holorulerconf/button.png", nil, "/interface/holorulerconf/buttonactive.png", "MARKERS", {19,9}, COLOUR_WHITE),
    textBtn = ButtonEl:new("textBtn", {180,98}, {38,12}, "/interface/holorulerconf/button.png", nil, "/interface/holorulerconf/buttonactive.png", "TEXT", {19,9}, COLOUR_WHITE),
    clrTxtR = TextEl:new("clrTxtR", {162,86}, {32,11}, "/interface/holorulerconf/amount.png", "", {16,9}, {255,0,0,255}), -- red colour component, text readout
    clrBtnRD = ButtonEl:new("clrBtnRD", {152,87}, {8,9}, "/interface/holorulerconf/pick.png:left", nil, "/interface/holorulerconf/pick.png:leftHover", nil, nil, nil), -- red colour component, down button
    clrBtnRDD = ButtonEl:new("clrBtnRDD", {138,87}, {12,9}, "/interface/holorulerconf/picklong.png:left", nil, "/interface/holorulerconf/picklong.png:leftHover", nil, nil, nil), -- red colour component, down(x10) button
    clrBtnRU = ButtonEl:new("clrBtnRU", {196,87}, {8,9}, "/interface/holorulerconf/pick.png:right", nil, "/interface/holorulerconf/pick.png:rightHover", nil, nil, nil), -- red colour component, up button
    clrBtnRUU = ButtonEl:new("clrBtnRUU", {206,87}, {12,9}, "/interface/holorulerconf/picklong.png:right", nil, "/interface/holorulerconf/picklong.png:rightHover", nil, nil, nil), -- red colour component, up(x10) button
    clrTxtG = TextEl:new("clrTxtG", {162,74}, {32,11}, "/interface/holorulerconf/amount.png", "", {16,9}, {0,255,0,255}),
    clrBtnGD = ButtonEl:new("clrBtnGD", {152,75}, {8,9}, "/interface/holorulerconf/pick.png:left", nil, "/interface/holorulerconf/pick.png:leftHover", nil, nil, nil),
    clrBtnGDD = ButtonEl:new("clrBtnGDD", {138,75}, {12,9}, "/interface/holorulerconf/picklong.png:left", nil, "/interface/holorulerconf/picklong.png:leftHover", nil, nil, nil),
    clrBtnGU = ButtonEl:new("clrBtnGU", {196,75}, {8,9}, "/interface/holorulerconf/pick.png:right", nil, "/interface/holorulerconf/pick.png:rightHover", nil, nil, nil),
    clrBtnGUU = ButtonEl:new("clrBtnGUU", {206,75}, {12,9}, "/interface/holorulerconf/picklong.png:right", nil, "/interface/holorulerconf/picklong.png:rightHover", nil, nil, nil),
    clrTxtB = TextEl:new("clrTxtB", {162,62}, {32,11}, "/interface/holorulerconf/amount.png", "", {16,9}, {60,170,255,255}),
    clrBtnBD = ButtonEl:new("clrBtnBD", {152,63}, {8,9}, "/interface/holorulerconf/pick.png:left", nil, "/interface/holorulerconf/pick.png:leftHover", nil, nil, nil),
    clrBtnBDD = ButtonEl:new("clrBtnBDD", {138,63}, {12,9}, "/interface/holorulerconf/picklong.png:left", nil, "/interface/holorulerconf/picklong.png:leftHover", nil, nil, nil),
    clrBtnBU = ButtonEl:new("clrBtnBU", {196,63}, {8,9}, "/interface/holorulerconf/pick.png:right", nil, "/interface/holorulerconf/pick.png:rightHover", nil, nil, nil),
    clrBtnBUU = ButtonEl:new("clrBtnBUU", {206,63}, {12,9}, "/interface/holorulerconf/picklong.png:right", nil, "/interface/holorulerconf/picklong.png:rightHover", nil, nil, nil),
    clrTxtA = TextEl:new("clrTxtA", {162,50}, {32,11}, "/interface/holorulerconf/amount.png", "", {16,9}, {255,255,255,255}),
    clrBtnAD = ButtonEl:new("clrBtnAD", {152,51}, {8,9}, "/interface/holorulerconf/pick.png:left", nil, "/interface/holorulerconf/pick.png:leftHover", nil, nil, nil),
    clrBtnADD = ButtonEl:new("clrBtnADD", {138,51}, {12,9}, "/interface/holorulerconf/picklong.png:left", nil, "/interface/holorulerconf/picklong.png:leftHover", nil, nil, nil),
    clrBtnAU = ButtonEl:new("clrBtnAU", {196,51}, {8,9}, "/interface/holorulerconf/pick.png:right", nil, "/interface/holorulerconf/pick.png:rightHover", nil, nil, nil),
    clrBtnAUU = ButtonEl:new("clrBtnAUU", {206,51}, {12,9}, "/interface/holorulerconf/picklong.png:right", nil, "/interface/holorulerconf/picklong.png:rightHover", nil, nil, nil),
    clrDisp = ColourDisplayEl:new("clrDisp", {154,38}, {48,11}, "/interface/holorulerconf/colourdisp.png", {3,3}, {42,5}, self.formState.activeColour),
    textModeCptn = ButtonEl:new("textModeCptn", {240,98}, {48,22}, nil, nil, nil, "TEXT MODE", {24,9}, COLOUR_WHITE),
    textModeDefBtn = ButtonEl:new("textModeDefBtn", {240,74}, {48,24}, "/interface/holorulerconf/button_lg.png", nil, "/interface/holorulerconf/buttonactive_lg.png", "OVERHEAD\nDEFAULT", {24,20}, COLOUR_WHITE),
    textModeStatBtn = ButtonEl:new("textModeStatBtn", {240,50}, {48,24}, "/interface/holorulerconf/button_lg.png", nil, "/interface/holorulerconf/buttonactive_lg.png", "OVERHEAD\nSTATIC", {24,20}, COLOUR_WHITE),
    textModeLineBtn = ButtonEl:new("textModeLineBtn", {240,26}, {48,24}, "/interface/holorulerconf/button_lg.png", nil, "/interface/holorulerconf/buttonactive_lg.png", "LINE\nCENTER", {24,20}, COLOUR_WHITE),
    applyBtn = ButtonEl:new("applyBtn", {138,22}, {38,12}, "/interface/holorulerconf/button.png", nil, "/interface/holorulerconf/buttonactive.png", "APPLY", {19,9}, COLOUR_WHITE),
    cancelBtn = ButtonEl:new("cancelBtn", {180,22}, {38,12}, "/interface/holorulerconf/button.png", nil, "/interface/holorulerconf/buttonactive.png", "CANCEL", {19,9}, COLOUR_WHITE),
  }
  self.controls.textGroup = {self.controls.textModeDefBtn, self.controls.textModeStatBtn, self.controls.textModeLineBtn}
  
  -- colour group init
  self.controls.clrBtnRD.onClick = function() return modColourComponent(1, -1) end
  self.controls.clrBtnRDD.onClick = function() return modColourComponent(1, -10) end
  self.controls.clrBtnRU.onClick = function() return modColourComponent(1, 1) end
  self.controls.clrBtnRUU.onClick = function() return modColourComponent(1, 10) end
  self.controls.clrBtnGD.onClick = function() return modColourComponent(2, -1) end
  self.controls.clrBtnGDD.onClick = function() return modColourComponent(2, -10) end
  self.controls.clrBtnGU.onClick = function() return modColourComponent(2, 1) end
  self.controls.clrBtnGUU.onClick = function() return modColourComponent(2, 10) end
  self.controls.clrBtnBD.onClick = function() return modColourComponent(3, -1) end
  self.controls.clrBtnBDD.onClick = function() return modColourComponent(3, -10) end
  self.controls.clrBtnBU.onClick = function() return modColourComponent(3, 1) end
  self.controls.clrBtnBUU.onClick = function() return modColourComponent(3, 10) end
  self.controls.clrBtnAD.onClick = function() return modColourComponent(4, -1) end
  self.controls.clrBtnADD.onClick = function() return modColourComponent(4, -10) end
  self.controls.clrBtnAU.onClick = function() return modColourComponent(4, 1) end
  self.controls.clrBtnAUU.onClick = function() return modColourComponent(4, 10) end
  
  self.controls.markerBtn.onClick = function()
    self.formState.activeColour = self.HRState.color
    self.controls.clrDisp.colour = self.HRState.color --stuff doesn't seem to work without this
    self.controls.textBtn.status = 0
    self.controls.markerBtn.status = 2
  end
  self.controls.markerBtn.status = 2
  self.controls.textBtn.onClick = function()
    self.formState.activeColour = self.HRState.textColor
    self.controls.clrDisp.colour = self.HRState.textColor
    self.controls.markerBtn.status = 0
    self.controls.textBtn.status = 2
  end
  
  -- text switch group init
  self.controls.textModeDefBtn.onClick = function()
    self.HRState.textMode = 0
    for i,ctl in pairs(self.controls.textGroup) do
      ctl.status = 0
    end
    self.controls.textModeDefBtn.status = 2
  end
  self.controls.textModeStatBtn.onClick = function()
    self.HRState.textMode = 1
    for i,ctl in pairs(self.controls.textGroup) do
      ctl.status = 0
    end
    self.controls.textModeStatBtn.status = 2
  end
  self.controls.textModeLineBtn.onClick = function()
    self.HRState.textMode = 2
    for i,ctl in pairs(self.controls.textGroup) do
      ctl.status = 0
    end
    self.controls.textModeLineBtn.status = 2
  end
  if self.HRState.textMode == 0 then
    self.controls.textModeDefBtn.onClick()
  elseif self.HRState.textMode == 1 then
    self.controls.textModeStatBtn.onClick()
  elseif self.HRState.textMode == 2 then
    self.controls.textModeLineBtn.onClick()
  end
  
  -- misc controls init
  self.controls.applyBtn.onClick = function()
    world.sendEntityMessage(pane.sourceEntity(), "updateHRState", self.HRState)
    pane.dismiss()
  end
  self.controls.cancelBtn.onClick = function()
    pane.dismiss()
  end
end

function update(dt)
  canvas = widget.bindCanvas('scriptCanvas')
  for k,ctl in pairs(self.controls) do
    if ctl._type then
      ctl:draw()
    end
  end
  local textElMap = {"clrTxtR", "clrTxtG", "clrTxtB", "clrTxtA"}
  for i,id in pairs(textElMap) do
    canvas:drawText(tostring(self.formState.activeColour[i]), {position=vec2.add(self.controls[id].pos, self.controls[id].textOffset), horizontalAnchor="mid"}, 8, self.controls[id].colour)
  end
end

function canvasClickEvent(position, button, isButtonDown)
  if button == 0 and isButtonDown == false then
    for k,ctl in pairs(self.controls) do
      if ctl._type == "button" and pointInRect(position, ctl.pos, ctl.size) then
        ctl:onClick()
      end
    end
  end
end

function pointInRect(point, rectOrigin, rectSize)
  return point[1] >= rectOrigin[1] and point[1] < rectOrigin[1]+rectSize[1] and point[2] >= rectOrigin[2] and point[2] < rectOrigin[2]+rectSize[2]
end

function modColourComponent(compIndex, delta)
  local clrStruct = self.formState.activeColour
  clrStruct[compIndex] = clrStruct[compIndex] + delta
  if clrStruct[compIndex] > 255 then
    clrStruct[compIndex] = 255
  elseif clrStruct[compIndex] < 0 then
    clrStruct[compIndex] = 0
  end
end