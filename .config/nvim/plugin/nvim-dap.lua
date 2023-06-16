local vim = vim
local status, dap = pcall(require, 'dap')
if (not status) then return end

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {vim.env.HOME .. '/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js'},
}

dap.configurations.javascript = {
  {
    type = 'node2',
    request = 'launch',
    program = vim.fn.expand('%:p'),
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
}

dap.configurations.typescript = {
  {
    type = 'node2',
    request = 'launch',
    program = vim.fn.expand('%:p'),
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
}
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
    pathMappings = {
      ["/var/www/html"] = "${workspaceFolder}"
    },
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
