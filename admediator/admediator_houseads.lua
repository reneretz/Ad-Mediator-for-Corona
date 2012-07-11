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

local function getRandomHouseAdIdx()
	--> Support to weighted houseAds
	local totalWeight = 0
	local random = math.floor(math.random (0, 100))
	for i, p in ipairs(houseAds) do
		totalWeight = totalWeight + p.weight
		if totalWeight >= random then
		    return i
		end
	end
	
	return 1
end

function instance:init(networkParams)

    print("houseads init")

    for _,p in ipairs(networkParams) do
        houseAds[#houseAds+1] = p
        print(p.image,p.target)
    end

	currentHouseAdIdx = getRandomHouseAdIdx()
end

function instance:requestAd()
    
    Runtime:dispatchEvent({name="adMediator_adResponse",available=true,imageUrl=houseAds[currentHouseAdIdx].image,adUrl=houseAds[currentHouseAdIdx].target,,htmlContent=houseAds[currentHouseAdIdx].htmlContent}})

    currentHouseAdIdx = currentHouseAdIdx + 1
    if currentHouseAdIdx > #houseAds then
        currentHouseAdIdx = 1
    end
    
end

return instance