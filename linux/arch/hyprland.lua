---@type utils.PackConfig
return {
  setup = function()
    local lfs = require("lfs")
    local home = os.getenv("HOME")

    -- Screenshot directory
    local screenshot_dir = home .. "/Screenshots"
    if lfs.attributes(screenshot_dir, "mode") ~= "directory" then
      assert(lfs.mkdir(screenshot_dir))
      print("Created directory: " .. screenshot_dir)
    end

    print("==> Installing hyprland plugins...")

    local ok, reason, code = os.execute("hyprpm update")

    if ok ~= true and ok ~= 0 then
      print(string.format("Hyprpm update failed: reason=%s code=%s", reason, code))
      return false
    end

    -- Hyprgrass
    if os.execute("hyprpm list | grep -q 'hyprgrass'") == 0 then
      print("Hyprgrass is already installed.")
    else
      print("Installing Hyprgrass...")
      os.execute("hyprpm add https://github.com/horriblename/hyprgrass")
      print("Hyprgrass installation complete.")
    end
    os.execute("hyprpm enable hyprgrass")

    -- hyprland-plugins
    if os.execute("hyprpm list | grep -q 'hyprland-plugins'") == 0 then
      print("hyprland-plugins is already installed.")
    else
      print("Installing hyprland-plugins...")
      os.execute("hyprpm add https://github.com/hyprwm/hyprland-plugins.git")
      print("hyprland-plugins installation complete.")
    end
    os.execute("hyprpm enable hyprexpo")

    -- Config files
    local hw_dir = home .. "/.config/hypr/hw"
    if lfs.attributes(hw_dir, "mode") ~= "directory" then
      assert(lfs.mkdir(hw_dir))
    end

    local hypr_conf = hw_dir .. "/hypr.conf"
    if not lfs.attributes(hypr_conf) then
      io.open(hypr_conf, "w"):close()
      print("Created " .. hypr_conf)
    end

    local lock_conf = hw_dir .. "/lock.conf"
    if not lfs.attributes(lock_conf) then
      io.open(lock_conf, "w"):close()
      print("Created " .. lock_conf)
    end
  end,
  dots = {
    ".config/hypr",
    ".config/waybar",
    ".config/xdg-desktop-portal",
    ".config/mimeapps.list",
  },
  packs = {
    "hyprland",
    -- Utility
    "hyprpaper",
    "hyprlock",
    "waybar",
    "hyprcursor",
    "hyprpicker",
    -- Xdg portals
    "xdg-desktop-portal-hyprland",
    "xdg-desktop-portal-gtk",
    -- Screen Keyboard
    "wvkbd",
    -- screenshots
    "grim",
    "slurp",
  }
}
