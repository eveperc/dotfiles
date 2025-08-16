local status, fzf = pcall(require, 'fzf-lua')
if (not status) then return end

fzf.setup {
  live_grep = {
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512 --no-ignore --hidden --glob '!.git' --glob '!node_modules'"
  }
}
