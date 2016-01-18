return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.15.0",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 40,
  height = 20,
  tilewidth = 128,
  tileheight = 128,
  nextobjectid = 101,
  backgroundcolor = { 160, 206, 249 },
  properties = {},
  tilesets = {
    {
      name = "Ground",
      firstgid = 1,
      tilewidth = 128,
      tileheight = 128,
      spacing = 0,
      margin = 0,
      image = "../gfx/spritesheet_ground.png",
      imagewidth = 1024,
      imageheight = 2048,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 128,
      tiles = {
        {
          id = 0,
          properties = {
            ["collision_type"] = "top"
          }
        },
        {
          id = 8,
          properties = {
            ["collision_type"] = "all"
          }
        },
        {
          id = 16,
          properties = {
            ["collision_type"] = "top"
          }
        },
        {
          id = 24,
          properties = {
            ["collision_type"] = "slope_up"
          }
        },
        {
          id = 32,
          properties = {
            ["collision_type"] = "slope_dn"
          }
        },
        {
          id = 40,
          properties = {
            ["collision_type"] = "top"
          }
        },
        {
          id = 48,
          properties = {
            ["collision_type"] = "top"
          }
        },
        {
          id = 56,
          properties = {
            ["collision_type"] = "top"
          }
        },
        {
          id = 64,
          properties = {
            ["collision_type"] = "top"
          }
        },
        {
          id = 88,
          properties = {
            ["collision_type"] = "all"
          }
        },
        {
          id = 96,
          properties = {
            ["collision_type"] = "all"
          }
        }
      }
    },
    {
      name = "Stuff",
      firstgid = 129,
      tilewidth = 128,
      tileheight = 128,
      spacing = 0,
      margin = 0,
      image = "../gfx/spritesheet_tiles.png",
      imagewidth = 1024,
      imageheight = 2048,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 128,
      tiles = {}
    },
    {
      name = "NPCs",
      firstgid = 257,
      tilewidth = 130,
      tileheight = 268,
      spacing = 0,
      margin = 0,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 24,
      tiles = {
        {
          id = 0,
          image = "../gfx/enemies/frame1.png",
          width = 88,
          height = 63
        },
        {
          id = 1,
          image = "../gfx/enemies/frame5.png",
          width = 114,
          height = 114
        },
        {
          id = 2,
          image = "../gfx/enemies/frame9.png",
          width = 96,
          height = 268
        },
        {
          id = 3,
          image = "../gfx/enemies/frame14.png",
          width = 88,
          height = 63
        },
        {
          id = 4,
          image = "../gfx/enemies/frame18.png",
          width = 92,
          height = 93
        },
        {
          id = 5,
          image = "../gfx/enemies/frame23.png",
          width = 88,
          height = 63
        },
        {
          id = 6,
          image = "../gfx/enemies/frame27.png",
          width = 104,
          height = 83
        },
        {
          id = 7,
          image = "../gfx/enemies/frame31.png",
          width = 115,
          height = 42
        },
        {
          id = 8,
          image = "../gfx/enemies/frame35.png",
          width = 109,
          height = 82
        },
        {
          id = 9,
          image = "../gfx/enemies/frame39.png",
          width = 115,
          height = 42
        },
        {
          id = 10,
          image = "../gfx/enemies/frame43.png",
          width = 96,
          height = 268
        },
        {
          id = 11,
          image = "../gfx/enemies/frame47.png",
          width = 109,
          height = 82
        },
        {
          id = 12,
          image = "../gfx/enemies/frame51.png",
          width = 102,
          height = 88
        },
        {
          id = 13,
          image = "../gfx/enemies/frame55.png",
          width = 82,
          height = 109
        },
        {
          id = 14,
          image = "../gfx/enemies/frame59.png",
          width = 107,
          height = 64
        },
        {
          id = 15,
          image = "../gfx/enemies/frame63.png",
          width = 114,
          height = 57
        },
        {
          id = 16,
          image = "../gfx/enemies/frame67.png",
          width = 68,
          height = 89
        },
        {
          id = 17,
          image = "../gfx/enemies/frame72.png",
          width = 100,
          height = 73
        },
        {
          id = 18,
          image = "../gfx/enemies/frame76.png",
          width = 130,
          height = 82
        },
        {
          id = 19,
          image = "../gfx/enemies/frame81.png",
          width = 92,
          height = 105
        },
        {
          id = 20,
          image = "../gfx/enemies/frame86.png",
          width = 92,
          height = 133
        },
        {
          id = 21,
          image = "../gfx/enemies/frame89.png",
          width = 129,
          height = 129
        },
        {
          id = 22,
          image = "../gfx/enemies/frame93.png",
          width = 104,
          height = 71
        },
        {
          id = 23,
          image = "../gfx/enemies/frame97.png",
          width = 106,
          height = 63
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "bg",
      x = 0,
      y = 0,
      width = 40,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {
        ["collidable"] = "true"
      },
      encoding = "base64",
      compression = "zlib",
      data = "eJxjYBgFo2AUjIJRMFRAIhBzQnEkBWpGwSiQZECkE2yYELAEYkMg1qSR2zyBmAkPJtdcZD8q0shtTAz4wxYXRjc3kApmjOJRPBgxAOEvBtc="
    },
    {
      type = "tilelayer",
      name = "decoration",
      x = 0,
      y = 0,
      width = 40,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eJzrZBi8oHOgHTAKRsEoGHFgN5HqDtPUFaNgFAxd8IaOdn3BIraGgDwlYDWVzRsFo2CkAgCOYQa8"
    },
    {
      type = "objectgroup",
      name = "objects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      objects = {
        {
          id = 45,
          name = "welcome sign",
          type = "Obj_Sign",
          shape = "rectangle",
          x = 1408,
          y = 1920,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 163,
          visible = true,
          properties = {
            ["message"] = "Hi! Howdy! Welcome!"
          }
        },
        {
          id = 46,
          name = "",
          type = "Obj_Bridge",
          shape = "rectangle",
          x = 1152,
          y = 1280,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 133,
          visible = true,
          properties = {
            ["collision_type"] = "top"
          }
        },
        {
          id = 47,
          name = "",
          type = "Obj_Bridge",
          shape = "rectangle",
          x = 1280,
          y = 1280,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 133,
          visible = true,
          properties = {
            ["collision_type"] = "top"
          }
        },
        {
          id = 48,
          name = "",
          type = "Obj_Bridge",
          shape = "rectangle",
          x = 1408,
          y = 1280,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 133,
          visible = true,
          properties = {
            ["collision_type"] = "top"
          }
        },
        {
          id = 49,
          name = "",
          type = "Obj_Bridge",
          shape = "rectangle",
          x = 1536,
          y = 1280,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 133,
          visible = true,
          properties = {
            ["collision_type"] = "top"
          }
        },
        {
          id = 50,
          name = "",
          type = "Obj_Bridge",
          shape = "rectangle",
          x = 1664,
          y = 1280,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 133,
          visible = true,
          properties = {
            ["collision_type"] = "top"
          }
        },
        {
          id = 51,
          name = "",
          type = "Obj_Box",
          shape = "rectangle",
          x = 2432,
          y = 1920,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 161,
          visible = true,
          properties = {}
        },
        {
          id = 52,
          name = "",
          type = "Obj_Box",
          shape = "rectangle",
          x = 2560,
          y = 1920,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 161,
          visible = true,
          properties = {}
        },
        {
          id = 53,
          name = "",
          type = "Obj_Box",
          shape = "rectangle",
          x = 2688,
          y = 1920,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 161,
          visible = true,
          properties = {}
        },
        {
          id = 54,
          name = "",
          type = "Obj_Box",
          shape = "rectangle",
          x = 2816,
          y = 1920,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 161,
          visible = true,
          properties = {}
        },
        {
          id = 55,
          name = "",
          type = "Obj_Box",
          shape = "rectangle",
          x = 2944,
          y = 1920,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 161,
          visible = true,
          properties = {}
        },
        {
          id = 56,
          name = "",
          type = "Obj_Box",
          shape = "rectangle",
          x = 2560,
          y = 1792,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 161,
          visible = true,
          properties = {}
        },
        {
          id = 57,
          name = "",
          type = "Obj_Box",
          shape = "rectangle",
          x = 2688,
          y = 1792,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 161,
          visible = true,
          properties = {}
        },
        {
          id = 58,
          name = "",
          type = "Obj_Box",
          shape = "rectangle",
          x = 2816,
          y = 1792,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 161,
          visible = true,
          properties = {}
        },
        {
          id = 63,
          name = "",
          type = "Obj_Spring",
          shape = "rectangle",
          x = 384,
          y = 1920,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 242,
          visible = true,
          properties = {}
        },
        {
          id = 64,
          name = "start",
          type = "Obj_Player",
          shape = "rectangle",
          x = 896,
          y = 1664,
          width = 128,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 84,
          name = "",
          type = "Obj_Spring",
          shape = "rectangle",
          x = 4352,
          y = 1536,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 242,
          visible = true,
          properties = {}
        },
        {
          id = 96,
          name = "",
          type = "Obj_Wiggler",
          shape = "rectangle",
          x = 2048,
          y = 1792,
          width = 96,
          height = 268,
          rotation = 0,
          gid = 259,
          visible = true,
          properties = {}
        },
        {
          id = 98,
          name = "",
          type = "Obj_Frog",
          shape = "rectangle",
          x = 2304,
          y = 1792,
          width = 104,
          height = 71,
          rotation = 0,
          gid = 279,
          visible = true,
          properties = {}
        },
        {
          id = 99,
          name = "",
          type = "Obj_Platform",
          shape = "rectangle",
          x = 384,
          y = 1408,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 252,
          visible = true,
          properties = {
            ["direction"] = "ud",
            ["distance"] = "2"
          }
        }
      }
    }
  }
}
