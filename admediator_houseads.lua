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

local instance = {}

local houseAds = {}
local currentHouseAdIdx = 1
local weightTable = {}

local function adRequestListener(event)

    local available = true
    if event.isError then
        available = false
    end
    
    Runtime:dispatchEvent({name="adMediator_adResponse",available=available,imageUrl=houseAds[currentHouseAdIdx].image,adUrl=houseAds[currentHouseAdIdx].target})
	
	--> Support to weighted houseAds
	local totalWeight = 0
	local random = math.floor(math.random (0, 100))
	-- print("Random number = "..random)
	for i, p in ipairs(houseAds) do
		totalWeight = totalWeight + p.weight
		if totalWeight >= random then
			-- print("Index chosen = "..i)
		    currentHouseAdIdx = i
			break
		end
	end
end

function instance:init(networkParams)

    print("houseads init")

    for _,p in ipairs(networkParams) do
        houseAds[#houseAds+1] = p
        print(p.image,p.target)
    end
end

function instance:requestAd()
    
    network.request(houseAds[currentHouseAdIdx].image,"GET",adRequestListener)
    
end

return instance