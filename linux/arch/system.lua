---@type utils.PackConfig
return {
  dots = {
    ".config/fastfetch"
  },
  setup = function()
    print("==> Enabling System Deamons...")

    os.execute("systemctl enable --now tuned tuned-ppd")
  end,
  packs = {
    "brightnessctl",
    "htop",
    "btop",
    "tuned",
    "tuned-ppd",
    "fastfetch",
  },
}
