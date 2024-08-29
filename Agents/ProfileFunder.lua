-- Name: Profile Funder

local json = require("json")
local ao = require("ao")

Constants = Constants or {}

Constants.Name = "Profile Funder"

Constants.GameplayProcess = "ElHCsTvRsN7_5Bpy1d3dC4kaVtAXMWiCMVz46H6sP3k"

Constants.TARGET_WORLD_PID = "_9QcH-Ma0LRvYInsa36d8zEkMRB9tfoAyEaLHmlUw3U"

Constants.ARToken = "xU9zFkq3X2ZQ6olwNVvr1vUWIjc3kXTWr7xKQD6dh10"

Constants.BazarUCM = "U3TjJAZWJjlWBB4KAXSHKzuky81jtyh0zqH8rUL4Wd0"

Constants.OrePrice = 100000000000


-- Schema
function BuyOreSchemaTags(profileId)
  return [[
{
  "type": "object",
  "required": [
    "Action",
    "Recipient",
    "Quantity"
  ],
  "properties": {
    "Action": {
      "type": "string",
      "const": "Transfer"
    },
    "Recipient": {
      "type": "string",
      "const": "]] .. profileId .. [["
    },
    "Quantity": {
      "type": "number",
      "const": ]] .. (Constants.OrePrice) .. [[,
    }
  }
}
]]
end

function SchemaExternalHasProfile(profileId)
  return {
    Fund = {
      Target = Constants.ARToken, -- Can be nil? In that case it must be supplied externally
      Title = "Fund Your Bazar Profile with .1 AR",
      Description =
      "By clicking submit you are calling the AR token to transfer 0.1 to your Bazar process, this will allow you to purchase a Strange Ore.",
      Schema = {
        Tags = json.decode(BuyOreSchemaTags(profileId)),
        -- Data
        -- Result?
      },
    },
  }
end

Handlers.add(
  'Profile-Response',
  Handlers.utils.hasMatchingTag("Action", "Profile-Response"),
  function(msg)
    print("profile response")
    local profileId = msg.Tags.Profile
    local userId = msg.Tags.UserId
    print("profile: " .. profileId .. "user: " .. userId)

    ao.send({
      Target = userId,
      Tags = { Type = 'SchemaExternal' },
      Data = json.encode(SchemaExternalHasProfile(profileId))
    })
  end
)

Handlers.add(
  'SchemaExternal',
  Handlers.utils.hasMatchingTag('Action', 'SchemaExternal'),
  function(msg)
    print('SchemaExternal')
    ao.send({
      Target = Constants.GameplayProcess,
      Tags = {
        Action = 'Profile',
        UserId = msg.From,
      },
    })
  end
)
