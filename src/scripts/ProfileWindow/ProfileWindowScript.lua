PW = PW or {
    containers = {},
    lineTrigger = nil,
    eventHandlers = {}
  }
  
  
  local profileName = getProfileName()
  
  function PW.addProfileWindow(name)
    PW.containers[name] = PW.containers[name] or {}
    
    if not PW.containers[name].container then
    
      PW.containers[name].container = Adjustable.Container:new({
        name = name,
        x = "40%", y = "5%",
        width = 600,
        height = "50%",
        lockStyle = "border",
        adjLabelstyle = "background-color:darkred; border: 0; padding: 1px;",
      })
        
      PW.containers[name].console = Geyser.MiniConsole:new({
          name = name .. " Console",
          x = 0, y = 0,
          autoWrap = false,
          color = "black",
          scrollBar = true,
          fontSize = 9,
          width="100%", height="100%",
        },
        PW.containers[name].container
      )
      
      PW.containers[name].console:setFont(getFont())
      PW.containers[name].console:enableCommandLine()
      
      -- hook the console commandline so we can send commands to that profile
      PW.containers[name].console:setCmdAction(PW.cmdLineAction, profileName, name)
      
      -- Tell other instances that the profile *name* has been registered and should start sending their data
      raiseGlobalEvent("PWRegisterEvent", name)
      
    else
      PW.containers[name].container:show()
      PW.containers[name].console:enableCommandLine()
    end
  end
  
  
  function PW.cmdLineAction(profileName, name, text)
    raiseGlobalEvent("PWCmdEvent", profileName, name, text)
  end
  
  
  
  function PW.eventHandler(event, ...)
    if event == "PWLineEvent" then
      local pwName = arg[1]
      local pwLine = arg[2]
      
      if PW.containers[pwName] then
        local pwConsole = PW.containers[pwName].console
        pwConsole:decho(pwLine)
        pwConsole:echo("\n")
      end
      
    elseif event == "PWCmdEvent" then
      local pwProfileFrom = arg[1]
      local pwProfileTarget = arg[2]
      local pwLine = arg[3]
      
      if getProfileName() == pwProfileTarget then
        cecho(string.format("<orange>%s<white>> %s<reset>\n", pwProfileFrom, pwLine))
        send(pwLine)
      end
      
    elseif event == "PWRegisterEvent" then
      
      if getProfileName() == arg[1] then
        PW.myProfileRegistered = true
        
        if not PW.lineTrigger then
          PW.lineTrigger = tempRegexTrigger("(.*)", function()
            -- check if our current profile has been added by another profile's pwadd command
            -- so we're not uneccessarily sending a bunch of global events
            selectCurrentLine()
            local dString = copy2decho()
            raiseGlobalEvent("PWLineEvent", getProfileName(), dString)
          end)
        end
        
        cecho(string.format("<orange>ProfileWindow: <yellow>This profile <spring_green>%s <yellow>now broadcasting\n",
          getProfileName()))
      end
    end
  end
  
  
  for _, v in pairs(PW.eventHandlers) do
    killAnonymousEventHandler(v)
  end
  
  PW.eventHandlers = {
    registerAnonymousEventHandler("PWLineEvent", [[PW.eventHandler]]),
    registerAnonymousEventHandler("PWCmdEvent", [[PW.eventHandler]]),
    registerAnonymousEventHandler("PWRegisterEvent", [[PW.eventHandler]])
  }
  
  
  if PW.lineTrigger then
    killTrigger(PW.lineTrigger)
  end
  
  