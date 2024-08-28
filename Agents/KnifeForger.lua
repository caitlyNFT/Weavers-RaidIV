-- Name: Knife Forger

local json = require("json")
local ao = require("ao")

Constants = Constants or {}

Constants.Name = "Knife Forger"

Constants.GameplayProcess = "ElHCsTvRsN7_5Bpy1d3dC4kaVtAXMWiCMVz46H6sP3k"

Constants.TARGET_WORLD_PID = "_9QcH-Ma0LRvYInsa36d8zEkMRB9tfoAyEaLHmlUw3U"

Constants.StrangeOre = "eLAgDHhcthcmjeaywlqkKTo8oPLZOc3YTQdU5ENJjKY"

Constants.Number = 1

-- Schema
function SendOreSchemaTags()
    return [[
{
  "type": "object",
  "required": [
    "Action",
    "Target",
    "Recipient",
    "Quantity"
  ],
  "properties": {
    "Action": {
      "type": "string",
      "const": "Transfer"
    },
    "Target": {
        "type": "string",
        "const": "]] .. Constants.StrangeOre .. [["
    },
    "Recipient": {
      "type": "string",
      "const": "]] .. Constants.GameplayProcess .. [["
    },
    "Quantity": {
      "type": "number",
      "const": ]] .. (Constants.Number) .. [[,
    }
  }
}
]]
end

function SchemaExternalHasLimestone(profileId)
    return {
        Forge = {
            Target = profileId, -- Can be nil? In that case it must be supplied externally
            Title = "Knife Forger",
            Description =
            "Send your Strange Ore off to be forged into a knife!",
            Schema = {
                Tags = json.decode(SendOreSchemaTags()),
                -- Data
                -- Result?
            },
        },
    }
end

Handlers.add(
    'Mined-Response',
    Handlers.utils.hasMatchingTag("Action", "Mined-Response"),
    function(msg)
        print("mined response")
        local profileId = msg.Tags.ProfileId
        local userId = msg.Tags.UserId

        ao.send({
            Target = userId,
            Tags = { Type = 'SchemaExternal' },
            Data = json.encode(SchemaExternalHasLimestone(profileId))
        })
    end
)

Handlers.add(
    'Mined-Response-Fail',
    Handlers.utils.hasMatchingTag("Action", "Mined-Response-Fail"),
    function(msg)
        print("mined response fail")
        local profileId = msg.Tags.ProfileId
        local userId = msg.Tags.UserId

        ao.send({
            Target = userId,
            Tags = { Type = 'SchemaExternal' },
            Data = json.encode({
                Forge = {
                    Target = userId,
                    Title = "Knife Forger",
                    Description =
                    "You don't have any mined limestone, please go use our provided pickaxe!",
                    Schema = nil,
                },
            })
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
                Action = 'Mined-Limestone',
                UserId = msg.From,
            },
        })
    end
)
