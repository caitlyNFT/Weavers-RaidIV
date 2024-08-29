--#region Model

RealityInfo = {
    Dimensions = 2,
    Name = 'KnifeDemo',
    ['Render-With'] = '2D-Tile-0',
}

RealityParameters = {
    ['2D-Tile-0'] = {
        Version = 0,
        PlayerSpriteTxId = 'njU06ZNozJgm0D_nGSmt7xC6LGA0IG4XjmRfAiGO2mw',
        Spawn = { 10, 13 },
        -- This is a tileset themed to Llama Land main island
        Tileset = {
            Type = 'Fixed',
            Format = 'PNG',
            TxId = 'oImQMRnsWjjJWMSA1_h94qwc3D7EMQVS7b4gmoaSTUI', -- TxId of the tileset in PNG format
        },
        -- This is a tilemap of sample small island
        Tilemap = {
            Type = 'Fixed',
            Format = 'TMJ',
            TxId = 'ydnrrhizdCNVYGx7XZNi0F3oAc4WODrpH_jpJU8YCQQ', -- TxId of the tilemap in TMJ format
            -- Since we are already setting the spawn in the middle, we don't need this
            -- Offset = { -20, -20 },
        },
    },
    ['Audio-0'] = {
        Bgm = {
            Type = 'Fixed',
            Format = 'WAV',
            TxId = "srhHoZK4IcpRLDAmjMNFnh6_5MlI2jX4AoXZznRLuh4",
        }
    }
}

RealityEntitiesStatic = {
    -- Pickaxe
    ['g307wX7lCRpqwLP1NEaZV_R5yg0sasWmqAX2bdQ7h-E'] = {
        Position = { 32, 34.5 },
        Type = 'Avatar',
        Metadata = {
            DisplayName = 'Mine Me',
            -- Demo PickAxe
            SpriteTxId = 'EuQg32PBsZiSapDLCW5RLrTN7EcC2EY2Sx_09uVEAZA',
            Interaction = {
                Type = 'Default',
            },
        },
    },
    -- Information Agent
    ['73Dx0a4DuC3GyG-ovRL7S9G2Ddd4zBmVZ8SsJ4hVRS8'] = {
        Position = { 28, 20 },
        Type = 'Avatar',
        Metadata = {
            DisplayName = 'Click Me!',
            -- Demo PickAxe
            SpriteTxId = '0hXLb5i3C2EOeszSs4EBGu9BaMumZFsd98DkXAXV2g0',
            Interaction = {
                Type = 'SchemaForm',
                Id = 'Guide'
            },
        },
    },

    -- OreSeller
    ['hlm1bCyGVpl8wuKZDcbHaU4GkqcELyqWWdwpX60aTas'] = {
        Position = { 29, 25 },
        Type = 'Avatar',
        Metadata = {
            DisplayName = 'Ore Seller',
            -- Demo PickAxe
            SpriteTxId = '0hXLb5i3C2EOeszSs4EBGu9BaMumZFsd98DkXAXV2g0',
            Interaction = {
                Type = 'SchemaExternalForm',
                Id = 'BuyOre'
            },
        },
    },

    -- Knife Maker
    ['EJFmQ6VbhYsrxKkMV3sRtgR0qJacw_-DyD_5AFcI6eg'] = {
        Position = { 21, 27 },
        Type = 'Avatar',
        Metadata = {
            DisplayName = 'Knife Forger',
            -- Demo PickAxe
            SpriteTxId = '0hXLb5i3C2EOeszSs4EBGu9BaMumZFsd98DkXAXV2g0',
            Interaction = {
                Type = 'SchemaExternalForm',
                Id = 'Forge'
            },
        },
    },

    -- Funder
    ['wEGRe4FCf-BrhvkLxrLgoNO9c_5HnvkpehuHwEAaYss'] = {
        Position = { 27, 25 },
        Type = 'Avatar',
        Metadata = {
            DisplayName = 'Funder',
            -- Demo PickAxe
            SpriteTxId = '0hXLb5i3C2EOeszSs4EBGu9BaMumZFsd98DkXAXV2g0',
            Interaction = {
                Type = 'SchemaExternalForm',
                Id = 'Fund'
            },
        },
    },
}


--#endregion

return print("Knife Demo World Reality Template Loaded....")
