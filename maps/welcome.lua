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
  nextobjectid = 87,
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
          id = 86,
          name = "",
          type = "Obj_Box",
          shape = "rectangle",
          x = 640,
          y = 1792,
          width = 128,
          height = 128,
          rotation = 0,
          gid = 161,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
