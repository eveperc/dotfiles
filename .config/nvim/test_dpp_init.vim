" Test dpp initialization
echo "=== Testing dpp.vim initialization ==="
echo ""

" Check function existence
echo "dpp#begin exists: " . exists('*dpp#begin')
echo "dpp#load_state exists: " . exists('*dpp#load_state') 
echo "dpp#min#load_state exists: " . exists('*dpp#min#load_state')
echo ""

" Check runtimepath
echo "dpp.vim in runtimepath: " . (match(&runtimepath, 'dpp\.vim') >= 0)
echo "denops.vim in runtimepath: " . (match(&runtimepath, 'denops\.vim') >= 0)
echo ""

" Check cache directory
let cache_dir = expand('~/.cache/dpp')
echo "Cache directory exists: " . isdirectory(cache_dir)
echo ""

" List dpp repos
let repos_dir = cache_dir . '/repos/github.com/Shougo'
if isdirectory(repos_dir)
  echo "Installed dpp components:"
  for dir in glob(repos_dir . '/*', 0, 1)
    echo "  - " . fnamemodify(dir, ':t')
  endfor
else
  echo "No dpp repos found in: " . repos_dir
endif

qa!