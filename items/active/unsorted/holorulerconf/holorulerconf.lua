require "/scripts/vec2.lua"

function init()
  message.setHandler("updateHRState", function(msgName, isLocal, state)
    if msgName ~= "updateHRState" then return end
    activeItem.callOtherHandScript("applyPackedConfig", state)
  end)
  activeItem.setOutsideOfHand(false)
end

function uninit()

end

function update(dt, fireMode, shiftHeld)

end

function activate(fireMode, shiftHeld)
  if fireMode == "primary" then
    local HRState = activeItem.callOtherHandScript("getPackedConfig") --{color, textColor, showGrid, textMode}
    if HRState == nil then -- guess there's no HoloRuler in the other hand
      return
    end
    local configData = root.assetJson("/interface/holorulerconf/holorulerconfgui.config")
    configData.HRState = HRState
    
    activeItem.interact("ScriptPane", configData, activeItem.ownerEntityId()) -- fire up the ol' GUI!
  end
end