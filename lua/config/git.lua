return {
  -- Git remote with the config
  nvim_remote = "https://github.com/deadtornotor/config.nvim.git",
  --- Specifies the branches advailable
  nvim_branches = {
    "main",
    "minimal",
    "nightly",
  },
  --- Specifies the version to use with the branch
  nvim_versions = {
    main = "stable",
    minimal = "stable",
    nightly = "nightly",
  }
}
