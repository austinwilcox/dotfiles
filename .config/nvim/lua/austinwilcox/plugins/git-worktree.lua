return {
  "ThePrimeagen/git-worktree.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    local Worktree = require("git-worktree")

    require("telescope").load_extension("git_worktree")
    Worktree.setup({
      update_on_change = true,
      clearjumps_on_change = true,
      autopush = false,
      autopull = true,
    })

    local function copy_dotenv(prev_path, path)
      local success, err = vim.loop.fs_copyfile(prev_path .. "/.env", path .. "/.env", 0)
      if success then
        print("Moved .env file from " .. prev_path .. " to " .. path)
      else
        print("Error moving .env file: " .. err)
      end
    end

    Worktree.on_tree_change(function(op, metadata)
      if op == Worktree.Operations.Create then
        if vim.loop.fs_stat(metadata.path .. "/package.json") then
          if vim.loop.fs_stat(metadata.path .. "/pnpm-lock.yaml") or not vim.loop.fs_stat(metadata.path .. "/node_modules") then
            vim.fn.system({ "pnpm", "install", metadata.path })
            print("Installed pnpm packages for " .. metadata.path)
          end
          if vim.loop.fs_stat(metadata.path .. "/master/.env") then
            copy_dotenv(metadata.path .. "/master", metadata.path .. "/" .. metadata.branch)
          end
        end
      elseif op == Worktree.Operations.Switch then
        if not vim.loop.fs_stat(metadata.path .. "/package.json") then return end
        local stat = vim.loop.fs_stat(metadata.prev_path .. "/.env")
        local target_stat = vim.loop.fs_stat(metadata.path .. "/.env")
        if stat and not target_stat then
          copy_dotenv(metadata.prev_path, metadata.path)
        end
      end
    end)

    vim.keymap.set("n", "<leader>gw", function()
      require("telescope").extensions.git_worktree.git_worktrees()
    end, { noremap = true })
    vim.keymap.set("n", "<leader>gc", function()
      require("telescope").extensions.git_worktree.create_git_worktree()
    end, { noremap = true })
  end,
}
