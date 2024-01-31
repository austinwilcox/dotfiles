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
	if op == Worktree.Operations.Switch then
    --TODO: Check if this is a node project, because that will determine whether or not I have a .env file at the root of the project
    --I am okay for right now because I am only using this for a node project while I work with trees
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
	end
end)
