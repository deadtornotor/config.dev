---@type utils.PackConfig
return {
  dots = {
    ".bashrc",
    ".profile",
    ".local/scripts/projects",
  },
  setup = function()
    local lfs = require("lfs")

    lfs.mkdir("~/notes")
    lfs.mkdir("~/dev")
  end,
  packs = {
    -- base
    "base-devel",
    "pkg-config",
    "fzf",
    "neovim",
    "cpio",
    -- c/cpp
    "gcc",
    "cmake",
    "clang",
    "ninja",
    "glm",
    -- python
    "python",
    -- java
    "jdk-openjdk",
    "gradle",
    "meson",
  },
}
