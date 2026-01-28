local M = {}

--- Detect the current os
function M.detect_os()
  local os_config = {
    os_id = "unknown",
    is_wsl = false,
    os_name = "Unknown OS",
  }

  local sep = package.config:sub(1, 1)
  local is_windows = sep == "\\"

  if is_windows then
    os_config.os_id = "windows"
    os_config.os_name = "Windows"
    os_config.is_wsl = false
  else
    -- Try reading /etc/os-release for Linux distros
    local os_release = {}
    local f = io.open("/etc/os-release", "r")
    if f then
      for line in f:lines() do
        local k, v = line:match("^(%w+)=(.+)$")
        if k and v then
          -- remove possible quotes around value
          v = v:gsub('^"(.*)"$', "%1")
          os_release[k] = v
        end
      end
      f:close()
    end

    if os_release.ID then
      os_config.os_id = os_release.ID:lower()
      os_config.os_name = os_release.PRETTY_NAME or os_release.NAME or os_config.os_id
    else
      -- fallback for unknown linux
      os_config.os_id = "linux"
      os_config.os_name = "Linux"
    end

    -- Detect WSL by checking /proc/version content for "Microsoft"
    local proc_version = io.open("/proc/version", "r")
    if proc_version then
      local content = proc_version:read("*a")
      proc_version:close()
      if content:match("Microsoft") then
        os_config.is_wsl = true
      end
    end
  end

  _G.os_config = os_config
end

M.detect_os()

return M
