---@type utils.PackConfig
local M = {
  packs = {
    "bob",
    "nodejs",
    "rustup",
    "npm",
    "python",
    "python-pip",
    "python-debugpy",
    "jdk-openjdk",
    "make",
    "cmake",
    "clang",
    "llvm",
    "ripgrep",
    "fd",
    "fzf",
    "unzip",
    "git",
    "lazygit",
    "lua-language-server",
  },
}

-- Prompt user to select branch
local function prompt_branches(branches)
  print("Select a config branch to install:")
  for i, branch in ipairs(branches) do
    print(string.format("%d) %s", i, branch))
  end
  io.write("Enter number: ")
  local choice = io.read("*line")
  local idx = tonumber(choice)
  if idx and idx >= 1 and idx <= #branches then
    return branches[idx]
  else
    print("Invalid choice")
    return nil
  end
end

-- Required for bob
local function create_bash_login()
  local fs = require("utils.fs")

  -- Get the user's home directory from environment
  local home = os.getenv("HOME")
  if not home then
    error("Could not determine HOME directory")
  end

  local bash_login_path = home .. "/.bash_login"

  if fs.file_exists(bash_login_path) then
    print(".bash_login already exists at " .. bash_login_path)
  else
    local file, err = io.open(bash_login_path, "w")
    if not file then
      error("Failed to create .bash_login: " .. err)
    end
    file:write("# .bash_login created by Lua script\n")
    file:close()
    print(".bash_login created at " .. bash_login_path)
  end
end

-- Main install function for Neovim config
local function install_nvim_config()
  local home = os.getenv("HOME")
  local nvim_config_dir = home .. "/.config/nvim"

  local conf = require("config.git")
  local git_repo_url = conf.nvim_remote

  local lfs = require("lfs")

  local branches = conf.nvim_branches
  local branch = prompt_branches(branches)
  if not branch then return end

  if lfs.attributes(nvim_config_dir, "mode") == "directory" then
    print("Removing existing config directory: " .. nvim_config_dir)
    local rm_cmd = string.format("rm -rf %q", nvim_config_dir)
    os.execute(rm_cmd)
  end

  local clone_cmd = string.format("git clone --branch %q %q %q", branch, git_repo_url, nvim_config_dir)
  print("Cloning branch " .. branch .. "...")
  local ok = os.execute(clone_cmd)
  if ok ~= 0 and ok ~= true then
    print("Failed to clone repository.")
    return
  end

  create_bash_login()

  print("Running bob install for branch " .. branch .. "...")
  local bob_version = conf.nvim_versions[branch] or "stable"
  local bob_cmd = string.format("bob install %s; bob use %s", bob_version, bob_version)
  local bob_ok = os.execute(bob_cmd)
  if bob_ok ~= 0 and bob_ok ~= true then
    print("bob install failed.")
    return
  end

  local rustup_cmd = "rustup install nightly"
  os.execute(rustup_cmd)
  print("Neovim config installed successfully with branch: " .. branch)
end

function M.setup()
  -- Call the install function, or you can call this manually later
  install_nvim_config()
end

return M
