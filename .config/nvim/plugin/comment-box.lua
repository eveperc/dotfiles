local status,comment_box = pcall(require,'comment-box')
if (not status) then return end

comment_box.setup {}

local keymap = vim.api.nvim_set_keymap

--  ┌──────────────────────────────────────────────────────────┐
--  │                                                          │
--  └──────────────────────────────────────────────────────────┘
keymap("n", "<Leader>bbc", "<Cmd>lua require('comment-box').lbox(2)<CR>", {})
keymap("v", "<Leader>bbc", "<Cmd>lua require('comment-box').lbox(2)<CR>", {})
--  ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--  ╏                                                          ╏
--  ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
keymap("n", "<Leader>bbd", "<Cmd>lua require('comment-box').lbox(5)<CR>", {})
keymap("v", "<Leader>bbd", "<Cmd>lua require('comment-box').lbox(5)<CR>", {})
--  ╔══════════════════════════════════════════════════════════╗
--  ║                                                          ║
--  ╚══════════════════════════════════════════════════════════╝
keymap("n", "<Leader>bb2", "<Cmd>lua require('comment-box').lbox(7)<CR>", {})
keymap("v", "<Leader>bb2", "<Cmd>lua require('comment-box').lbox(7)<CR>", {})
--  ▲                                                          ▲
--  █                                                          █
--  ▼                                                          ▼
keymap("n", "<Leader>bsa", "<Cmd>lua require('comment-box').lbox(10)<CR>", {})
keymap("v", "<Leader>bsa", "<Cmd>lua require('comment-box').lbox(10)<CR>", {})
--  ▲
--  █
--  ▼
keymap("n", "<Leader>bla", "<Cmd>lua require('comment-box').lbox(11)<CR>", {})
keymap("v", "<Leader>bla", "<Cmd>lua require('comment-box').lbox(11)<CR>", {})
--  ┌
--  │
--  └
keymap("n", "<Leader>blb", "<Cmd>lua require('comment-box').lbox(12)<CR>", {})
keymap("v", "<Leader>blb", "<Cmd>lua require('comment-box').lbox(12)<CR>", {})
--  ╓
--  ║
--  ╙
keymap("n", "<Leader>blc", "<Cmd>lua require('comment-box').lbox(13)<CR>", {})
keymap("v", "<Leader>blc", "<Cmd>lua require('comment-box').lbox(13)<CR>", {})
--  ▲                                                          ▲
--  █                                                          █
--  ▼                                                          ▼
keymap("n", "<Leader>bsa", "<Cmd>lua require('comment-box').lbox(17)<CR>", {})
keymap("v", "<Leader>bsa", "<Cmd>lua require('comment-box').lbox(17)<CR>", {})
--  ┌                                                          ┐
--  │                                                          │
--  └                                                          ┘
keymap("n", "<Leader>bsb", "<Cmd>lua require('comment-box').lbox(18)<CR>", {})
keymap("v", "<Leader>bsb", "<Cmd>lua require('comment-box').lbox(18)<CR>", {})
--  ╓                                                          ╖
--  ║                                                          ║
--  ╙                                                          ╜
keymap("n", "<Leader>bsc", "<Cmd>lua require('comment-box').lbox(19)<CR>", {})
keymap("v", "<Leader>bsc", "<Cmd>lua require('comment-box').lbox(19)<CR>", {})
--  ┌──────────────────────────────────────────────────────────┐
--
--  └──────────────────────────────────────────────────────────┘
keymap("n", "<Leader>bta", "<Cmd>lua require('comment-box').lbox(20)<CR>", {})
keymap("v", "<Leader>bta", "<Cmd>lua require('comment-box').lbox(20)<CR>", {})
--  ╒══════════════════════════════════════════════════════════╕
--
--  ╘══════════════════════════════════════════════════════════╛
keymap("n", "<Leader>btb", "<Cmd>lua require('comment-box').lbox(21)<CR>", {})
keymap("v", "<Leader>btb", "<Cmd>lua require('comment-box').lbox(21)<CR>", {})
--  ╒══════════════════════════════════════════════════════════╕
--
--  └──────────────────────────────────────────────────────────┘
keymap("n", "<Leader>btc", "<Cmd>lua require('comment-box').lbox(22)<CR>", {})
keymap("v", "<Leader>btc", "<Cmd>lua require('comment-box').lbox(22)<CR>", {})

--      ────────────────────────────────────────────────────────────
keymap("n", "<Leader>cl1", "<Cmd>lua require('comment-box').cline()<CR>", {})
--      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
keymap("n", "<Leader>cl2", "<Cmd>lua require('comment-box').cline(2)<CR>", {})
--      ├──────────────────────────────────────────────────────────┤
keymap("n", "<Leader>cl3", "<Cmd>lua require('comment-box').cline(3)<CR>", {})
--      ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
keymap("n", "<Leader>cl4", "<Cmd>lua require('comment-box').cline(4)<CR>", {})
--      ╾──────────────────────────────────────────────────────────╼
keymap("n", "<Leader>cl5", "<Cmd>lua require('comment-box').cline(5)<CR>", {})
--      ╞══════════════════════════════════════════════════════════╡
keymap("n", "<Leader>cl6", "<Cmd>lua require('comment-box').cline(6)<CR>", {})
--      ------------------------------------------------------------
keymap("n", "<Leader>cl7", "<Cmd>lua require('comment-box').cline(7)<CR>", {})
--      ------------------------------------------------------------
keymap("n", "<Leader>cl8", "<Cmd>lua require('comment-box').cline(8)<CR>", {})
--      ____________________________________________________________
keymap("n", "<Leader>cl9", "<Cmd>lua require('comment-box').cline(9)<CR>", {})
--      +----------------------------------------------------------+
keymap("n", "<Leader>cl0", "<Cmd>lua require('comment-box').cline(10)<CR>", {})

keymap("i", "<M-l>", "<Cmd>lua require('comment-box').cline()<CR>", {})
