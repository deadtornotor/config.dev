---@type utils.PackConfig
return {
  setup = function()
    print("==> Enabling Audio Deamons...")

    os.execute("systemctl --user enable --now pipewire")
    os.execute("systemctl --user enable --now pipewire-pulse")
  end,
  packs = {
    "pipewire",
    "lib32-pipewire",
    "wireplumber",
    "pipewire-audio",
    "pipewire-alsa",
    "pipewire-pulse",
    "pipewire-jack",
    "lib32-pipewire-jack",
    "pavucontrol",
    "qpwgraph",
  }
}
