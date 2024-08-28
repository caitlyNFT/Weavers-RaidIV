-- Name: InformationAgent

local json = require("json")
local ao = require("ao")

Constants = Constants or {}

Constants.Name = "Guide"

Constants.TARGET_WORLD_PID = "_9QcH-Ma0LRvYInsa36d8zEkMRB9tfoAyEaLHmlUw3U"

Constants.GameplayProcess = "ElHCsTvRsN7_5Bpy1d3dC4kaVtAXMWiCMVz46H6sP3k"


Handlers.add(
    'DefaultInteraction',
    Handlers.utils.hasMatchingTag('Action', 'DefaultInteraction'),
    function(msg)
        print('DefaultInteraction - call set up user')

        ao.send({
            Target = Constants.TARGET_WORLD_PID,
            Tags = {
                Action = "ChatMessage",
                ['Author-Name'] = Constants.Name,
                Recipient = msg.From,
            },
            Data = 'Enrolling'
        })
        ao.send({
            Target = Constants.GameplayProcess,
            Tags = {
                Action = "Read",
                Sender = msg.From,
            }
        })
        print("sent messages")
    end
)

Handlers.add(
    'Schema',
    Handlers.utils.hasMatchingTag('Action', 'Schema'),
    function(msg)
        print('Schema - call set up user')

        ao.send({
            Target = Constants.TARGET_WORLD_PID,
            Tags = {
                Action = "ChatMessage",
                ['Author-Name'] = Constants.Name,
                Recipient = msg.From,
            },
            Data = 'pssst! Go mine some stone!'
        })
        ao.send({
            Target = Constants.GameplayProcess,
            Tags = {
                Action = "Read",
                Sender = msg.From,
            }
        })

        ao.send({
            Target = msg.From,
            Tags = { Type = 'Schema' },
            Data = json.encode({
                Guide = {
                    Title = "Welcome to the Bazar Knife Experiance!",
                    Description =
                    "By clicking on me your Bazar Profile ID has been registered to our Gameplay Process. This allows you to mine Limestone and purchase Strange Ore to combine into a super cool knife! Please go mine some stone with the provided Pickaxe, talk to our Ore Seller to purchase some Strange Ore listed on Bazar and then head over to Knfie Forger to put it all together!",
                    Schema = nil,
                },
            })
        })
        print("sent messages")
    end
)
