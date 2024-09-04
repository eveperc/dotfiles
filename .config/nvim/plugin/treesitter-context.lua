-- Attempt to require the 'treesitter-context' module
local status, treesitter_context = pcall(require, 'treesitter-context')
if not status then
  print("Failed to load treesitter-context module")
  return
end

-- Ensure 'treesitter_context' is a table
if type(treesitter_context) ~= "table" then
  print("Unexpected type for treesitter_context: " .. type(treesitter_context))
  return
end

-- Setup for treesitter-context
treesitter_context.setup {
  enable = true,         -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0,         -- How many lines the window should span. Values <= 0 mean no limit.
  trim_scope = 'outer',  -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  patterns = {           -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
    default = {
      'class',
      'function',
      'method',
      'for',
      'while',
      'if',
      'switch',
      'case',
      'interface',
      'struct',
      'enum',
    },
    tex = {
      'chapter',
      'section',
      'subsection',
      'subsubsection',
    },
    haskell = {
      'adt',
    },
    rust = {
      'impl_item',
    },
    terraform = {
      'block',
      'object_elem',
      'attribute',
    },
    scala = {
      'object_definition',
    },
    vhdl = {
      'process_statement',
      'architecture_body',
      'entity_declaration',
    },
    markdown = {
      'section',
    },
    elixir = {
      'anonymous_function',
      'arguments',
      'block',
      'do_block',
      'list',
      'map',
      'tuple',
      'quoted_content',
    },
    json = {
      'pair',
    },
    typescript = {
      'export_statement',
    },
    yaml = {
      'block_mapping_pair',
    },
  },
  exact_patterns = {
    -- Example for a specific filetype with Lua patterns
    -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
    -- exactly match "impl_item" only)
    -- rust = true,
  },

  -- The options below are exposed but shouldn't require your attention,
  -- you can safely ignore them.

  zindex = 20,     -- The Z-index of the context window
  mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
  separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
}
