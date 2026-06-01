-- Editing helpers
vim.keymap.set("n", "<leader><BS>", "I<CR><esc>")
vim.keymap.set("n", "<leader><CR>", "A<CR><esc>")

-- Horizontal scrolling
vim.keymap.set({ "n", "v", "x" }, "<C-L>", "20zl")
vim.keymap.set({ "n", "v", "x" }, "<C-H>", "20zh")

-- Search
vim.keymap.set("n", "*", "*N", { desc = "Search word inplace" })

-- Buffers
vim.keymap.set("n", "<Leader>,", ":ls<CR>:b ")

-- Search and replace
vim.keymap.set("n", "<Leader>s", 'viw"zy:%s/\\<<C-r>"\\>//g<Left><Left>', { silent = true })
vim.keymap.set("v", "<Leader>s", '"hy:%s/<C-r>"//g<Left><Left>', { silent = true })

-- Directory finder
vim.keymap.set("n", "<Leader>fd", "<cmd>Dir<cr>", { desc = "Find Directory" })

-- Paste without losing yanked content
vim.keymap.set("v", "<Leader>p", '"_dP', { desc = "Preserve yanked content on paste" })

-- Oil file explorer
vim.keymap.set("n", "-", "<CMD>Oil<CR>")

-- FzfLua
vim.keymap.set("n", "<leader><leader>", function() require("fzf-lua").files() end)
vim.keymap.set("n", "<leader>/", function() require("fzf-lua").grep_project() end)

-- Build
vim.keymap.set("n", "<leader>m", ":silent make | redraw!")

-- Run script
vim.keymap.set("n", "<F5>", function()
  vim.cmd("split | terminal bash _run.sh")
end, { noremap = true, silent = true })

-- Terminal escape
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
