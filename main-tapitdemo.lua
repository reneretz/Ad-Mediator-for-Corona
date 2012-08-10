------------------------------------------------------------
------------------------------------------------------------
-- Ad Mediator for Corona
--
-- Ad network mediation module for Ansca Corona
-- by Deniz Aydinoglu
--
-- he2apps.com
--
-- GitHub repository and documentation:
-- https://github.com/deniza/Ad-Mediator-for-Corona
------------------------------------------------------------
------------------------------------------------------------

local widget = require("widget")
require("admediator")

local tapitNetwork
local testModeInput
local zoneIdInput
local requestAdButton
local requestTapitAlert
local alertLabel
local adMediatorStarted = false
local testMode = false
local zoneId = 7527

local function createNewLineText(displayGroup, message,x,y)

    local line = display.newRetinaText( message, 0, 0, native.systemFontBold, 18*2 )
    line:setReferencePoint(display.CenterRightReferencePoint)
    line.x = x
    line.y = y
    line:scale(0.5,0.5)
    displayGroup:insert(line)
    
    return line

end

local function createCaption(displayGroup, message, x, y)

    local cap = display.newRetinaText( message, 0, 0, native.systemFontBold, 24*2 )
    cap.x = x
    cap.y = y
    cap:setTextColor(120,220,120)
    cap:scale(0.5,0.5)
    displayGroup:insert(cap)

end

local function startAdMediator()

    AdMediator.init(0,0,60)    
    AdMediator.enableAutomaticScalingOnIPAD(false)

    zoneId = zoneIdInput.text
    testMode = false
    if testModeInput.text == "1" then
        testMode = true
    end

    tapitNetwork = AdMediator.addNetwork(
        {
            name="admediator_tapit",
            weight=100,
            backfillpriority=5,
            enabled=true,
            networkParams = {
                --zoneId="7527",
                --zoneId="5716",
                --zoneId = "3644",
                zoneId = zoneId,
                test=testMode,
                swapButtons = false,
            },
        }
    )

    -- you can configure houseads plugin by using an array of (banner_image, target_url) data 
    AdMediator.addNetwork(
        {
            name="admediator_houseads",
            weight=0,
            backfillpriority=7,
            networkParams = {
                {image="http://he2apps.com/okey/noads.png",target="http://google.com"},
            },            
        }
    )

    AdMediator.start()
    adMediatorStarted = true

end

local function initGui()

    local background = display.newRect(0, 0, 320, 480)
    background:setFillColor(140, 23, 23)

    requestAdButton = widget.newButton{
        label = "Start Ad Mediator",
        left = (320-200)/2,
        top = 220,
        width = 200, height = 40,
        onRelease = function()            
            
            native.setKeyboardFocus(nil)

            if requestAdButton.disabled then
                
                alertLabel.text = "restart application to modify parameters"

                return
            end

            startAdMediator()

            requestAdButton.label.text = "running..."
            requestAdButton.disabled = true
            requestAdButton.alpha = 0.5

        end
    }

    requestTapitAlert = widget.newButton{
        label = "Request Alert Ads",
        left = (320-200)/2,
        top = 270,
        width = 200, height = 40,
        onRelease = function()
            if adMediatorStarted then
                alertLabel.text = ""
                tapitNetwork:requestAlertAds()
            else
                alertLabel.text = "please start ad mediator first"
            end
        end
    }

    local displayGroup = display.newGroup()
    createCaption(displayGroup, "Tapit Demo", 160, 100)

    createNewLineText(displayGroup, "ZoneId:", 160, 150)
    createNewLineText(displayGroup, "Test (0 or 1):", 160, 180)

    alertLabel = display.newRetinaText( "", 0, 0, native.systemFont, 14*2 )
    alertLabel.x = 160
    alertLabel.y = 210
    alertLabel:scale(0.5,0.5)
    displayGroup:insert(alertLabel)

    zoneIdInput = native.newTextField( 170, 138, 100, 22 )    

    zoneIdInput.font = native.newFont( native.systemFont, 16 )
    zoneIdInput.text = zoneId
    zoneIdInput.inputType = "default"

    testModeInput = native.newTextField( 170, 168, 50, 22 )

    testModeInput.font = native.newFont( native.systemFont, 16 )
    testModeInput.inputType = "default"

    if testMode then
        testModeInput.text = "1"
    else
        testModeInput.text = "0"
    end
 
end

    
display.setStatusBar( display.HiddenStatusBar )

initGui()

