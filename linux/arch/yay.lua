---@type utils.PackConfig
local M = {
  packs = {
    "git",
    "base-devel",
    "go",
  }
}

-- Helper to interpret os.execute result across Lua versions
local function is_success(ok)
  return ok == true or ok == 0
end

-- Check if a command exists in PATH
local function command_exists(cmd)
  local handle = io.popen("command -v " .. cmd .. " >/dev/null 2>&1 && echo yes || echo no")
  local result = handle:read("*l")
  handle:close()
  return result == "yes"
end

-- Install yay AUR helper if missing
local function install_yay()
  print("==> Installing yay if not already installed...")

  if command_exists("yay") then
    print("yay is already installed.")
    return
  end

  print("Cloning yay repository...")
  local ok = os.execute("git clone https://aur.archlinux.org/yay.git")
  if not is_success(ok) then
    print("Failed to clone yay repository.")
    return
  end

  print("Building and installing yay...")
  ok = os.execute("cd yay && makepkg -si --noconfirm")
  if not is_success(ok) then
    print("Failed to build/install yay.")
    return
  end

  print("Cleaning up...")
  os.execute("rm -rf yay")

  print("yay installation complete.")
end

function M.setup()
  install_yay()
end

return M
