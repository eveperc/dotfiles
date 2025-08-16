-- dpp.vim configuration
local M = {}

-- dpp.vimのベースパス
local dpp_base = vim.fn.expand('~/.cache/dpp')
local dpp_src = vim.fn.expand('~/.cache/dpp/repos/github.com/Shougo')

-- runtimepathに追加
local function add_rtp(path)
  vim.opt.runtimepath:prepend(path)
end

-- dpp.vimと拡張機能をruntimepathに追加
M.setup = function()
  -- dpp.vim core
  add_rtp(dpp_src .. '/dpp.vim')
  add_rtp(dpp_src .. '/dpp-ext-installer')
  add_rtp(dpp_src .. '/dpp-ext-lazy')
  add_rtp(dpp_src .. '/dpp-ext-toml')
  add_rtp(dpp_src .. '/dpp-protocol-git')
  add_rtp(dpp_src .. '/denops.vim')  -- denops.vimも追加
  
  -- dpp.vimの初期化（簡易版）
  if vim.fn.exists('*dpp#min#load_state') == 1 then
    vim.fn['dpp#min#load_state'](dpp_base)
  elseif vim.fn.exists('*dpp#load_state') == 1 then
    -- 通常のload_stateを試す
    vim.fn['dpp#load_state'](dpp_base)
  end
  
  -- dpp.vimが正しくロードされているか確認
  if vim.fn.exists('*dpp#begin') == 0 then
    vim.notify('dpp.vim is not loaded properly. Setting up minimal configuration...', vim.log.levels.WARN)
    -- 最小限の初期化
    M.initialize_dpp()
  end
end

-- dpp.vimの手動初期化
M.initialize_dpp = function()
  -- TOMLファイルから直接読み込む簡易実装
  local toml_files = {
    vim.fn.expand('~/.config/nvim/dpp/dpp.toml'),
    vim.fn.expand('~/.config/nvim/dpp/dpp_lazy.toml')
  }
  
  -- dpp#begin相当の処理
  if vim.fn.exists('*dpp#begin') == 1 then
    vim.fn['dpp#begin'](dpp_base, {
      ftplugin = false,
      lazy = 0,
    })
    
    -- TOMLファイルを読み込む
    for _, toml in ipairs(toml_files) do
      if vim.fn.filereadable(toml) == 1 then
        if vim.fn.exists('*dpp#load_toml') == 1 then
          vim.fn['dpp#load_toml'](toml, {lazy = vim.fn.match(toml, '_lazy') >= 0 and 1 or 0})
        end
      end
    end
    
    -- dpp#end相当の処理
    if vim.fn.exists('*dpp#end') == 1 then
      vim.fn['dpp#end']()
    end
  end
end

-- dpp.vimの設定を作成
M.make_state = function()
  local ok, err = pcall(function()
    vim.fn['dpp#make_state'](vim.fn.expand('~/.cache/dpp'), vim.fn.expand('~/.config/nvim/dpp/dpp.ts'))
  end)
  if not ok then
    vim.notify('Error in dpp#make_state: ' .. tostring(err), vim.log.levels.ERROR)
  end
end

-- プラグインのインストール
M.install = function()
  local ok, err = pcall(function()
    vim.fn['dpp#install']()
  end)
  if not ok then
    vim.notify('Error in dpp#install: ' .. tostring(err), vim.log.levels.ERROR)
  end
end

-- プラグインの更新  
M.update = function()
  local ok, err = pcall(function()
    vim.fn['dpp#update']()
  end)
  if not ok then
    vim.notify('Error in dpp#update: ' .. tostring(err), vim.log.levels.ERROR)
  end
end

-- dpp.vimの設定をTypeScriptで書く（高度な設定用）
M.create_typescript_config = function()
  local ts_config = [[
import {
  BaseConfig,
  ContextBuilder,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.0.5/types.ts";
import { Denops, fn } from "https://deno.land/x/dpp_vim@v0.0.5/deps.ts";

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
    dpp: Dpp;
  }): Promise<{
    plugins: Plugin[];
    stateLines: string[];
  }> {
    args.contextBuilder.setGlobal({
      protocols: ["git"],
    });

    const [context, options] = await args.contextBuilder.get(args.denops);
    
    // Load toml files
    const tomls: string[] = [
      "~/.config/nvim/dpp/dpp.toml",
      "~/.config/nvim/dpp/dpp_lazy.toml",
    ];

    const recordPlugins: Record<string, Plugin> = {};
    
    for (const toml of tomls) {
      const tomlPath = await fn.expand(args.denops, toml) as string;
      const loadedToml = await args.dpp.extAction(
        args.denops,
        context,
        options,
        "toml",
        "load",
        {
          path: tomlPath,
          options: {
            lazy: toml.endsWith("_lazy.toml"),
          },
        },
      ) as Record<string, Plugin> | undefined;
      
      if (loadedToml) {
        for (const [key, value] of Object.entries(loadedToml)) {
          recordPlugins[key] = value;
        }
      }
    }

    const plugins = Object.values(recordPlugins);

    return {
      plugins,
      stateLines: [],
    };
  }
}
]]
  
  local config_path = vim.fn.expand('~/.config/nvim/dpp/dpp.ts')
  local file = io.open(config_path, 'w')
  if file then
    file:write(ts_config)
    file:close()
    print("TypeScript config created at: " .. config_path)
  end
end

return M