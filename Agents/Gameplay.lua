local ao = require('ao')
local json = require('json')

-- Constant variables
Constants = Constants or {}

Constants.TARGET_WORLD_PID = "_9QcH-Ma0LRvYInsa36d8zEkMRB9tfoAyEaLHmlUw3U"

Constants.Name = Constants.Name or "Forge World Gameplay Process"

Constants.Registry = "SNy4m-DrqxWl01YqGM4sxI8qCni-58re8uuJLvZPypY"

Constants.FunderId = "N90q65iT59dCo01-gtZRUlLMX0w6_ylFHv2uHaSUFNk"

Constants.InformationAgent = ""

Constants.PayoutTable = {
    { threshold = 40, mined = 2 },
}

Constants.Messages = Constants.Messages or {
    ReturnTokens = "Return Tokens",
    TransferTokens = "Transfer Tokens",
    Description =
    "Forge World Demo for Weavers Raid IV Hackathon."
}


Constants.Tokens = {
    Payment = Constants.LlamaToken,
    Knife = "Rs1BVOkXSFCyhzeRRMAvCdysZBVjlZVFVdSHUNSI_4k",
    Limestone = "Ft6jNe3CBg_u2Rl4Z8t7AoF30J5iNd9u5FC7Y2N_Dp4",
    StrangeOre = "eLAgDHhcthcmjeaywlqkKTo8oPLZOc3YTQdU5ENJjKY",
}

Constants.NumToTokenMap = {
    [1] = Constants.Tokens.Payment,
    [2] = Constants.Tokens.Limestone,
    [3] = Constants.Tokens.StrangeOre,
    [4] = Constants.Tokens.Knife,
}

-- State data storage
State = State or {}

State.Agents = {
    "g307wX7lCRpqwLP1NEaZV_R5yg0sasWmqAX2bdQ7h-E", -- Pickaxe
    "73Dx0a4DuC3GyG-ovRL7S9G2Ddd4zBmVZ8SsJ4hVRS8", -- InformationAgent
    "hlm1bCyGVpl8wuKZDcbHaU4GkqcELyqWWdwpX60aTas", -- OreSeller
    "EJFmQ6VbhYsrxKkMV3sRtgR0qJacw_-DyD_5AFcI6eg", -- Knife Forger
}


State.Balance = State.Balance or {
    Payment = 0,
    Knife = 0,
    Limestone = 0,
    StrangeOre = 0
}

-- State Service functions
StateServices = StateServices or {}

-- Function to check if valid process sending the message to act on
function StateServices.isValidProcess(processId)
    print("checking valid process")
    -- Check if the value exists in the table
    for _, value in ipairs(State.Agents) do
        if value == processId then
            return true -- Value found, return true
        end
    end
    -- Value not found, return false
    return false
end

-- Function to return proper mined per cast
function StateServices.getRockMined(chance)
    local table = Constants.PayoutTable

    for _, range in ipairs(table) do
        if chance > range.threshold then
            return range.mined
        end
    end

    return 1
end

-- User data storage
Users = {}
ProfileIds = {}
UserServices = UserServices or {}

-- Function to check if a user exists, and if not, add them with default values
function UserServices.ensureUserExists(userId)
    if not Users[userId] then
        Users[userId] = {
            Name = "",
            Id = "",
            Received = {
                Limestone = 0,
                StrangeOre = 0
            }
        }
        print("Added user:", userId, "with default values.")
    else
        print("User already exists:", userId)
    end
end

-- Function to check if a user has mined Limestone (i.e., has more than 0 Limestone)
function UserServices.ensureMined(userId)
    UserServices.ensureUserExists(userId) -- Ensure the user exists before checking
    local user = Users[userId]

    if user.Received.Limestone > 0 then
        print("User", userId, "has mined Limestone:", user.Received.Limestone)
        return true
    else
        print("User", userId, "has not mined any Limestone.")
        -- You can handle this case as needed, e.g., assign Limestone, log a message, etc.
        return false
    end
end

-- Token Service functions
TokenService = TokenService or {}

-- Function to assign correct token based on token number
function TokenService.numToToken(num)
    return Constants.NumToTokenMap[num]
end

-- Send tokens from process
function TokenService.transfer(userId, quantity, message, token)
    local tokenProcess = TokenService.numToToken(token)
    print('sending: ' .. tokenProcess .. ' to user')
    ao.send({
        Target = tokenProcess,
        Action = "Transfer",
        Recipient = userId,
        Quantity = tostring(quantity),
        ["X-Note"] = message
    })
    ao.send({
        Target = userId,
        Action = Constants.Messages.TransferTokens,
        Data = message
    })
end

-- Ensure token is one of valid accepted types
function TokenService.checkTokenValidity(tokenProcess)
    if tokenProcess == Constants.Tokens.StrangeOre then
        print("valid token")
        return true
    end
    return false
end

-- Handlers
Handlers = Handlers or {}

--[[
  Info
]]
--
Handlers.add('Info', Handlers.utils.hasMatchingTag('Action', 'Info'), function(msg)
    ao.send({
        Target = msg.From,
        Tags = {
            Name = Constants.Name,
            World = Constants.TARGET_WORLD_PID,
            Description = Constants.Messages.Description
        }
    })
end)

--[[
  Balances
]]
--
Handlers.add('Balances', Handlers.utils.hasMatchingTag('Action', 'Balances'), function(msg)
    ao.send({
        Target = msg.From,
        Tags = {
            BankBalance = tostring(State.Balance.Payment)
        }
    })
end)

-- Function to convert a table to a string for debug output
function TableToString(tbl, indent)
    indent = indent or 0
    local tostr = string.rep(" ", indent) .. "{\n"

    for k, v in pairs(tbl) do
        if type(k) == "number" then
            k = "[" .. k .. "]"
        else
            k = "\"" .. k .. "\""
        end

        if type(v) == "table" then
            v = TableToString(v, indent + 2)
        else
            v = "\"" .. tostring(v) .. "\""
        end

        tostr = tostr .. string.rep(" ", indent + 2) .. k .. " = " .. v .. ",\n"
    end

    return tostr .. string.rep(" ", indent) .. "}"
end

--[[
  Entry point for pickaxe to mine stone
]]
--
Handlers.add(
    "Mine",
    Handlers.utils.hasMatchingTag("Action", "Mine"),
    function(msg)
        print("Mine rock")
        local pickaxeId = msg.From
        local userId = msg.Tags.Sender
        print(userId)
        local chance = tonumber(msg.Tags.Chance)
        assert(StateServices.isValidProcess(pickaxeId), "Only valid pickaxes can mine.")
        -- Base case of no mined
        local mined = StateServices.getRockMined(tonumber(chance))
        -- If mined > 0 then transfer tokens and update state
        if mined > 1 then
            TokenService.transfer(Users[userId].Id, 1, Constants.Messages.TransferTokens, mined)
        end
        Users[userId].Received.Limestone = Users[userId].Received.Limestone + 1
        print("sending mined information back")
        -- Send mined information back to pickaxeId
        ao.send({
            Target = pickaxeId,
            Tags = {
                Action = "Mined",
                Mined = tostring(mined),
                Name = Users[userId].Name or "User",
                Sender = userId
            }
        })
    end
)

Handlers.add(
    "Mined Limestone",
    Handlers.utils.hasMatchingTag("Action", "Mined-Limestone"),
    function(msg)
        print("mined Limestone")
        assert(StateServices.isValidProcess(msg.From), "Only knife forger can call.")

        local userId = msg.Tags.UserId
        local minedStone = UserServices.ensureMined(userId)
        if minedStone then
            ao.send({
                Target = msg.From,
                Tags = {
                    Action = "Mined-Response",
                    UserId = userId,
                    ProfileId = Users[userId].Id
                }
            })
        else
            ao.send({
                Target = msg.From,
                Tags = {
                    Action = "Mined-Response-Fail",
                    UserId = userId,
                    ProfileId = Users[userId].Id
                }
            })
        end
    end
)

Handlers.add(
    "Profile",
    Handlers.utils.hasMatchingTag("Action", "Profile"),
    function(msg)
        assert(StateServices.isValidProcess(msg.From), "Only ore seller.")

        local userId = msg.Tags.UserId
        local profileId = Users[userId] and Users[userId].Id -- Ensure Users[userId] exists before accessing Id

        if profileId then
            print("Profile: " .. profileId)
            ao.send({
                Target = msg.From,
                Tags = {
                    Action = "Profile-Response",
                    Profile = profileId,
                    UserId = userId
                }
            })
        else
            -- Handle the case where profileId does not exist
            print("Error: Profile ID not found for user " .. tostring(userId))
            ao.send({
                Target = msg.From,
                Tags = {
                    Action = "Profile-Response-Failure",
                }
            })
        end
    end)

-- Entry point for profile metadata bounce back from Bazar registry
Handlers.add(
    "Get-Metadata-Success",
    Handlers.utils.hasMatchingTag("Action", "Get-Metadata-Success"),
    function(msg)
        print("Metadata Success")
        local msgData = json.decode(msg.Data)
        local userName = msgData[1].DisplayName
        local profileId = msgData[1].ProfileId

        local userId = ProfileIds[profileId]
        Users[userId].Name = userName
    end)

-- Entry point for ProfileId bounce back from Bazar registry
Handlers.add(
    "Profile-Success",
    Handlers.utils.hasMatchingTag("Action", "Profile-Success"),
    function(msg)
        print("Profile Success")
        local msgData = json.decode(msg.Data)
        local id = { msgData[1].ProfileId }
        local data = '{\"ProfileIds\":' .. json.encode(id) .. '}'
        local userId = msgData[1].CallerAddress
        Users[userId].Id = id[1]
        ProfileIds[id[1]] = msgData[1].CallerAddress
        ao.send({
            Target = Constants.Registry,
            Action = "Get-Metadata-By-ProfileIds",
            Data = data
        })
    end)

-- Entry point for profile bounce back from Bazar registry
Handlers.add(
    "Read Profile",
    Handlers.utils.hasMatchingTag("Action", "Read"),
    function(msg)
        print("Read Profile")
        local user = msg.Tags.Sender
        local data =
            '{\"Address\":\"' .. user .. '"}'
        UserServices.ensureUserExists(user)
        ao.send({
            Target = Constants.Registry,
            Action = "Get-Profiles-By-Delegate",
            Data = data
        })
    end)

-- Entry point for creating knives from ore
Handlers.add(
    "CreditNoticeHandler",
    Handlers.utils.hasMatchingTag("Action", "Credit-Notice"),
    function(msg)
        print("credit-notice")
        local userId = ProfileIds[msg.Tags.Sender]
        local quantity = tonumber(msg.Tags.Quantity)

        local tokenValid = TokenService.checkTokenValidity(msg.From)
        local mined = UserServices.ensureMined(userId)
        print(mined)
        if tokenValid and mined then
            print("made into sending")
            TokenService.transfer(Users[userId].Id, 1, Constants.Messages.TransferTokens, 4)
            ao.send({
                Target = Constants.TARGET_WORLD_PID,
                Tags = {
                    Action = "ChatMessage",
                    ['Author-Name'] = 'Knife Forger',
                },
                Data = 'Congratulations! ' ..
                    Users[userId].Name .. ' on your newly forged Knife!'
            })
        end
    end)
