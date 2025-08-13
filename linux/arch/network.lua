---@type utils.PackConfig
return {
  setup = function()
    print("==> Enabling Network Deamons...")

    local cmd = "systemctl enable --now NetworkManager portmaster"
    os.execute(cmd)
  end,
  packs = {
    "networkmanager",
    "network-manager-applet",
    "portmaster-bin",
  }
}
