---@type utils.PackConfig
return {
  setup = require("linux.flatpaks").install,
  packs = {
    "flatpak",
  },
}
