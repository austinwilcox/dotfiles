local Worktree = require("git-worktree")

-- op = Operations.Switch, Operations.Create, Operations.Delete
-- metadata = table of useful values (structure dependent on op)
--      Switch
--          path = path you switched to
--          prev_path = previous worktree path
--      Create
--          path = path where worktree created
--          branch = branch name
--          upstream = upstream remote name
--      Delete
--          path = path where worktree deleted

Worktree.on_tree_change(function(op, metadata)
  if op == Worktree.Operations.Create then
    if vim.loop.fs_stat(metadata.path .. "/package.json") then
      if
          vim.loop.fs_stat(
            metadata.path .. "/pnpm-lock.yaml" or not vim.loop.fs_stat(metadata.path .. "/node_modules")
          )
      then
        vim.fn.system({
          "pnpm",
          "install",
          metadata.path,
        })
        print("Installed pnpm packages for " .. metadata.path)
      end
    end

    return
  end

  if op == Worktree.Operations.Switch then
    if not vim.loop.fs_stat(metadata.path .. "/package.json") then
      --NOTE: I do not currently handle anything but node projects
      return
    end
    
    local stat = vim.loop.fs_stat(metadata.prev_path .. "/.env")
    local targetStat = vim.loop.fs_stat(metadata.path .. "/.env")
    if stat and not targetStat then
      local success, err = vim.loop.fs_copyfile(metadata.prev_path .. "/.env", metadata.path .. "/.env", 0)
      if success then
        print("Moved .env file from " .. metadata.prev_path .. " to " .. metadata.path)
      else
        print("Error moving .env file: " .. err)
      end
    end
    return
  end
end)
