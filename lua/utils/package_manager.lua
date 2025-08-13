local M = {}

require("core.os")

local function run(cmd)
  if _G.dry_run then
    print("==> Would run ", cmd)
    return
  end

  print("==> Running:", cmd)
  local ok, _, code = os.execute(cmd)
  return ok == true or code == 0
end

local pkgman = {
  arch = {
    install = "sudo pacman -S --noconfirm",
    update = "sudo pacman -Sy",
    upgrade = "sudo pacman -Syu --noconfirm",
    remove = "sudo pacman -Rns --noconfirm",
  },
  debian = {
    install = "sudo apt install -y",
    update = "sudo apt update",
    upgrade = "sudo apt full-upgrade -y",
    remove = "sudo apt remove -y",
  },
  ubuntu = {
    install = "sudo apt-get install -y",
    update = "sudo apt-get update",
    upgrade = "sudo apt-get full-upgrade -y",
    remove = "sudo apt-get remove -y",
  },
  fedora = {
    install = "sudo dnf install -y",
    update = "sudo dnf check-update",
    upgrade = "sudo dnf upgrade -y",
    remove = "sudo dnf remove -y",
  },
  opensuse = {
    install = "sudo zypper install -y",
    update = "sudo zypper refresh",
    upgrade = "sudo zypper update -y",
    remove = "sudo zypper remove -y",
  },
}

local function get_pkgman()
  if not _G.os_config or not _G.os_config.os_id then
    error("os_config.os_id is not set!")
  end
  local pm = pkgman[_G.os_config.os_id]
  if not pm then
    error("No package manager config for OS: " .. _G.os_config.os_id)
  end
  return pm
end

function M.install(pkgs)
  assert(type(pkgs) == "table", "pkgs must be a string array")
  local pm = get_pkgman()
  return run(pm.install .. " " .. table.concat(pkgs, " "))
end

function M.update()
  local pm = get_pkgman()
  return run(pm.update)
end

function M.upgrade()
  local pm = get_pkgman()
  return run(pm.upgrade)
end

function M.remove(pkgs)
  assert(type(pkgs) == "table", "pkgs must be a string array")
  local pm = get_pkgman()
  return run(pm.remove .. " " .. table.concat(pkgs, " "))
end

return M
