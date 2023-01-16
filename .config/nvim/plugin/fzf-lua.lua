local status,fzf = pcall(require,'fzf')
if (not status) then return end

fzf.setup {}

