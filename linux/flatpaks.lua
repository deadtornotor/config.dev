--- @class linux.Flatpak
--- @field install fun(): boolean Function to install packages
--- @field packs string[] Packages to install
local M = {}

M.packs = {
  "com.github.tchx84.Flatseal",
  "one.ablaze.floorp",
  "com.spotify.Client",
  "com.github.PintaProject.Pinta",
  "org.kde.krita",
  "com.tomjwatson.Emote",
  "com.github.flxzt.rnote",
  "org.onlyoffice.desktopeditors",
}

function M.install()
  local cmd = "flatpak install -y " .. table.concat(M.packs, " ")

  -- Run command and capture exit code
  local ok, reason, code = os.execute(cmd)

  -- Lua 5.2+ returns: true/nil, "exit"/"signal", status_code
  if ok == true or ok == 0 then
    return true
  else
    print(string.format("Flatpak install failed: reason=%s code=%s", reason, code))
    return false
  end
end

return M
