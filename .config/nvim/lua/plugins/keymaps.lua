-- fzf-lua
vim.keymap.set("n", "<leader>ff", ":FzfLua files<cr>")
vim.keymap.set("n", "<leader>fc", ":FzfLua files cwd=~/.config<cr>")
vim.keymap.set("n", "<leader>fb", ":FzfLua files cwd=~/Dokument/båten<cr>")

-- tree
vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<cr>")

-- markdown preview
vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<cr>")

--Zen-mode
vim.keymap.set("n", "<leader>z", ":ZenMode<cr>")

-- Obsidian keybindings
vim.keymap.set("n", "<leader>os", ":ObsidianSearch<cr>")
vim.keymap.set("n", "<leader>on", ":ObsidianNew<cr>")
vim.keymap.set("n", "<leader>ol", ":ObsidianFollowLink<cr>")

