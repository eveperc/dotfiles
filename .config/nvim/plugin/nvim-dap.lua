local status, dap = pcall(require, 'dap')
if (not status) then return end

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    -- CHANGE THIS to your path!
    command = vim.env.HOME .. '/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb',
    args = { "--port", "${port}" },
    -- On windows you may have to uncomment this:
    -- detached = false,
  }
}
local dap = require('dap')
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { vim.env.HOME .. '/.local/share/nvim/mason/packages/php-debug-adapter/extension/out/phpDebug.js' }
}
dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = 9003,
    log = true,
    hostname = "0.0.0.0",
    -- pathMappings = {
    --   ["/var/www/html"] = "${workspaceFolder}"
    -- },
    serverSourceRoot = '/work/backend',
    localSourceRoot = { vim.env.HOME .. './src/cocorela/backend' },
  }
}
dap.adapters.go = {
  type = 'executable';
  command = 'node';
  args = { vim.env.HOME .. '/.local/share/nvim/mason/packages/go-debug-adapter/extension/dist/debugAdapter.js' };
}
dap.configurations.go = {
  {
    type = 'go';
    name = 'Debug';
    request = 'launch';
    showLog = false;
    program = "${file}";
    dlvToolPath = vim.fn.exepath('dlv') -- Adjust to where delve is installed
  },
}
