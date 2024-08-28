-- Name: Pickaxe

local json = require("json")
local ao = require("ao")

Constants = Constants or {}

Constants.Name = "Pickaxe"

Constants.TARGET_WORLD_PID = "_9QcH-Ma0LRvYInsa36d8zEkMRB9tfoAyEaLHmlUw3U"

Constants.GameplayProcess = "ElHCsTvRsN7_5Bpy1d3dC4kaVtAXMWiCMVz46H6sP3k"


Handlers.add(
    'DefaultInteraction',
    Handlers.utils.hasMatchingTag('Action', 'DefaultInteraction'),
    function(msg)
        print('DefaultInteraction - use pickaxe')

        local chance = math.random(100)
        print('chance: ' .. tostring(chance))
        ao.send({
            Target = Constants.TARGET_WORLD_PID,
            Tags = {
                Action = "ChatMessage",
                ['Author-Name'] = Constants.Name,
                Recipient = msg.From
            },
            Data = 'Chink, chink, chink...'
        })
        ao.send({
            Target = Constants.GameplayProcess,
            Tags = {
                Action = "Mine",
                Sender = msg.From,
                Chance = tostring(chance),
            }
        })
        print("sent messages")
    end
)
Handlers.add(
    "Mined",
    Handlers.utils.hasMatchingTag("Action", "Mined"),
    function(msg)
        print("Mined")
        local userId = msg.Tags.Sender
        local mined = tonumber(msg.Tags.Mined)
        assert(msg.From == Constants.GameplayProcess, "You have no authority to call this handler")
        local message = '...and you find nothing in the rock chips ' .. msg.Tags.Name .. '...'

        if mined == 2 then
            message = '...and ' .. msg.Tags.Name .. ' you you found a piece of Limestone!'
        elseif mined == 3 then
            message = '...and ' .. msg.Tags.Name .. ' whoa you found a piece of Strange Ore!'
        end

        ao.send({
            Target = Constants.TARGET_WORLD_PID,
            Tags = {
                Action = "ChatMessage",
                ['Author-Name'] = Constants.Name,
                Recipient = userId,
            },
            Data = message
        })
    end
)
