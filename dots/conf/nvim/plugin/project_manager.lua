local M = {}

local ok, req = pcall(require, "telescope")

if not ok then
  print("Could not load project_manager")
  return {}
end

local json_path = vim.fn.expand(vim.fn.stdpath('config') .. "/project_manager.json")
local plenary_path = require("plenary.path")
local telescope = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local function load_projects()
  local file = plenary_path:new(json_path)
  if not file:exists() then return {} end

  local content = file:read()
  local ok, projects = pcall(vim.json.decode, content)
  if not ok then return {} end

  return projects
end

function M.pick_project()
  local projects = load_projects()
  local entries = vim.tbl_map(function(p)
    return { name = p.name, path = p.path }
  end, projects)

  telescope.new({
    prompt_title = "Select Project",
    finder = finders.new_table({
      results = entries,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name .. " (" .. entry.path .. ")",
          ordinal = entry.name,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local project_path = selection.value.path

        -- Change directory
        vim.cmd("cd " .. project_path)

        -- Optional: Open file tree (example with NvimTree)
        local ok, tree_api = pcall(require, "nvim-tree.api")

        if ok then
          tree_api.tree.change_root(project_path)

          tree_api.tree.focus()
        end


        local ok, oil = pcall(require, "oil")

        if ok then
          oil.open(project_path)
        end

        -- Message
        print("Switched to project: " .. selection.value.name)
      end)

      vim.keymap.set("i", "<C-d>", function()
        M.remove_project(action_state.get_selected_entry(), projects)
        vim.schedule(function()
          actions.close(prompt_bufnr)
          M.pick_project()
        end)
      end, { desc = "Delete project from list", buffer = prompt_bufnr })

      vim.keymap.set("n", "d", function()
        M.remove_project(action_state.get_selected_entry(), projects)
        vim.schedule(function()
          actions.close(prompt_bufnr)
          M.pick_project()
        end)
      end, { desc = "Delete project from list", buffer = prompt_bufnr })

      return true
    end,
  }):find()
end

function M.add_project()
  vim.ui.input({ prompt = "Project name: " }, function(input)
    if not input or input == "" then return end

    local cwd = vim.fn.getcwd()
    local projects = load_projects()

    table.insert(projects, { name = input, path = cwd })

    local file = plenary_path:new(json_path)
    file:write(vim.fn.json_encode(projects), "w")
    print("Added project: " .. input .. " (" .. cwd .. ")")
  end)
end

function M.remove_project(selection, projects)
  local new_projects = vim.tbl_filter(function(p)
    return p.name ~= selection.value.name or p.path ~= selection.value.path
  end, projects)

  local file = plenary_path:new(json_path)
  file:write(vim.fn.json_encode(new_projects), "w")

  print("Deleted project: " .. selection.value.name)
end

vim.keymap.set("n", "<leader>ww", M.pick_project, { desc = "Browse workspaces" })

vim.keymap.set("n", "<leader>wa", M.add_project, { desc = "Add current project" })

return M
