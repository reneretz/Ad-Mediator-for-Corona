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

io.output():setvbuf("no")

local widget = require("widget")
tpAdMediatorLibpath = "admediator."
require(tpAdMediatorLibpath.."admediator")

local function initGui()

    local background = display.newRect(0, 0, 320, 480)
    background:setFillColor(140, 23, 23)

    local showButton = widget.newButton{
        label = "show",
        left = 50,
        top = 200,
        width = 100, height = 40,
        onRelease = function() AdMediator.show() end
    }
    local hideButton = widget.newButton{
        label = "hide",
        left = 170,
        top = 200,
        width = 100, height = 40,
        onRelease = function() AdMediator.hide() end
    }
 
end

local function remote_configuration()

    -- If you choose to use full remote configuration, you have to call;
    -- AdMediator.initFromUrl(configURL, callbackFunction)
    -- AdMediator will call your callbackFunction with true if initialization succeeded, and with false
    -- if something failed (thats probably about missing or broken configuration file)
    -- Please see included ad configuation file (admediator-init.config) for further configuration parameters
    -- Remember: dont forget to call AdMediator.start() in your callbackFunction() or after receiving a positive callback.

    local function initCallback(initialized)
        if initialized then
            AdMediator.start()
        else
            print("ERROR: AdMediator could not initialized properly!")
        end
    end

    AdMediator.initFromUrl("http://br.com.tapps.ads.s3.amazonaws.com/json/tappyescape-admediator-ads-ios.json", initCallback)    
    
end

local function local_configuration()

    -- init function takes three arguments; adposition_x, adposition_y and ad_request_delay_in_seconds
    -- I recommend using a delay value 60 seconds or more.
    AdMediator.init(0,0,60)
    
    -- 320x50 banners will scale on iPad by default. You can disable this feature by calling this function
    -- This function should be called before addNetwork(...)
    AdMediator.enableAutomaticScalingOnIPAD(true)
    
    -- after initializing the module, we should add some ad networks and configure them.
    -- AdMediator comes with inmobi, inneractive, herewead and houseads. You can add
    -- new networks if you wish.
    
    -- There are 4 parameters common for all networks; name, weight, enabled and backfillpriority
    -- name should be the file name of the ad network plugin script file without lua extension
    -- weight denotes network selection priority as fill percentage. It can be betwwen 0 and 100.
    -- The rule is; all network weight values shoud sum up to 100. A network with weight equals to zero
    -- will never be selected for ad serving. If you have 2 networks, and you give first network a weight
    -- of 40 and second one a weight of 60, that means first network have a 40% chance to serve an ad, while
    -- second network has a chance of 60%
    -- backfillpriority is used to select next available network if there are no ads served from currently selected
    -- ad provider. AdMediator always selects the next network with lowest backfillpriority
    -- enabled is an optional parameter with a default value true. You can easily disable ad network by setting it to false.
    -- networkParams is an ad plugin specific configuration block. If you plan to implement your own network
    -- plugins, you should use this block to get extended parameters.
    
    -- Below we configure inmobi, inneractive, admob, tapit and herewead networks with respective weight values.
    -- A final houseads network is configured with a weight of 0 and highest priority value.
    -- That means; this network will never be selected for ad serving, but if there are no ads from
    -- each of 4 providers, AdMediator will use this last plugin to fetch our house ads.  

    -- clientKey is you application specific token from inmobi
    -- if you want to server demo (test) ads, set test parameter to true     
    AdMediator.addNetwork(
        {
            name="admediator_inmobi",
            weight=20,
            backfillpriority=1,
            enabled=true,
            networkParams = {
                clientKey="YOUR_INMOBI_APP_KEY",
                test=true,
            },
        }
    )
    
    -- to receive LIVE inneractive ads, set clientKey to your inneractive app key
    AdMediator.addNetwork(
        {
            name="admediator_inneractive",    
            weight=20,
            backfillpriority=2,
            enabled=true,
            networkParams = {
                clientKey="YOUR_INNERACTIVE_APP_KEY",
            },            
        }
    )
   
    -- to receive live ads, put your app's publisherId and disable test mode
    AdMediator.addNetwork(
        {
            name="admediator_admob",
            weight=20,
            backfillpriority=3,
            enabled=true,
            networkParams = {
                publisherId="YOUR_ADMOB_PUBLISHER_ID",
                appIdentifier="com.yourcompany.AdMediatorSampleApp",
                test=true,
            },
        }
    )
    

    -- to receive LIVE ads, set zoneId to your tapit zoneId and disable test mode
    -- set enableAlertAds to receive alert ads (by calling tapit:requestAlertAds())
    -- set swapButtons=true to swap alert ads confirmation buttons.
    -- tapit plugin also supports interstitial ads. please check main-tapitdemo.lua for further instructions.
    local tapit = AdMediator.addNetwork(
        {
            name="admediator_tapit",
            weight=20,
            backfillpriority=5,
            enabled=true,
            networkParams = {
                zoneId="7527",
                test=true,
                enableAlertAds=false,
                swapButtons=false,
            },
        }
    )

    AdMediator.addNetwork(
        {
            name="admediator_madvertise",
            weight=20,
            backfillpriority=6,
            enabled=true,
            networkParams = {
                clientToken="your_client_token_from_madvertise",
                test=true,
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
                {image="http://he2apps.com/okey/adsv2/chatkapi.png",target="http://bit.ly/housead_target1"},
                {image="http://he2apps.com/okey/adsv2/komikreplikler.jpg",target="http://bit.ly/housead_target2"},
                {image="http://he2apps.com/okey/adsv2/2resim5fark.jpg",target="http://bit.ly/housead_target3"},
            },            
        }
    )

    -- you can use this simple plugin to send custom parameters to your own server side scripts and
    -- show returning html content. This plugin can be used for many useful things. You can implement
    -- new ad networks (by usign server-side apis) or use javascript driven interactive houseads, etc.
    --[[
    AdMediator.addNetwork(
        {
            name="admediator_customHtml",
            weight=100,
            backfillpriority=1,
            enabled=true,
            networkParams = {
                requestType="GET",
                requestUrl = "http://he2apps.com/test/customHtmlTest.php",
                rawResponse=false,
                requestParams={
                    someNumber=123850,
                    someText="a simple text message",
                    someOtherTextParameter="whatever you send"
                }
            },
        }
    )
    ]]--
    
    -- finally, start serving ads
    AdMediator.start()       
    
end

display.setStatusBar( display.HiddenStatusBar )

initGui()

-- You can configure AdMediator either manually or by using a remote configuration URI
--
--
-- For this sample application we use manual configuration
-- local_configuration()
remote_configuration()
