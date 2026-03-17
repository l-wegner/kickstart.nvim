local function copilot_quick_chat()
  local input = vim.fn.input 'Quick Chat: '
  if input ~= '' then
    require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
  end
end
local function get_claude_context(chat)
  local current_resources = chat.config and rawget(chat.config, 'resources') or nil
  if not current_resources then
    return nil, nil
  end
  if type(current_resources) == 'string' then
    if current_resources:match '^file:.*CLAUDE%.md$' then
      return current_resources, 1
    end
    return nil, nil
  end
  for i, res in ipairs(current_resources) do
    if type(res) == 'string' and res:match '^file:.*CLAUDE%.md$' then
      return res, i
    end
  end
  return nil, nil
end

local function set_claude_context(chat, claude_path)
  local current_resources = chat.config and rawget(chat.config, 'resources') or {}
  if type(current_resources) == 'string' then
    current_resources = { current_resources }
  end
  local new_resources = vim.tbl_filter(function(res)
    return not (type(res) == 'string' and res:match '^file:.*CLAUDE%.md$')
  end, current_resources)
  table.insert(new_resources, 'file:' .. claude_path)
  chat.config.resources = new_resources
end

local function unset_claude_context(chat)
  local current_resources = chat.config and rawget(chat.config, 'resources') or {}
  if type(current_resources) == 'string' then
    current_resources = { current_resources }
  end
  local new_resources = vim.tbl_filter(function(res)
    return not (type(res) == 'string' and res:match '^file:.*CLAUDE%.md$')
  end, current_resources)
  chat.config.resources = #new_resources == 1 and new_resources[1] or (#new_resources > 1 and new_resources or nil)
end

local function toggle_claude_md()
  local chat = require 'CopilotChat'
  local cwd = vim.fn.getcwd()
  local claude_path = vim.fn.fnamemodify(cwd .. '/CLAUDE.md', ':p')
  local cwd_has_claude = vim.fn.filereadable(claude_path) == 1

  -- Find currently set CLAUDE.md context
  local existing_claude = get_claude_context(chat)
  local existing_path = existing_claude and existing_claude:match '^file:(.+)' or nil

  if existing_claude ~= nil then
    vim.notify('CLAUDE.md at context: ' .. existing_path, vim.log.levels.INFO)
  end
  if cwd_has_claude then
    if existing_claude == nil then
      -- No CLAUDE.md in context, add cwd one
      set_claude_context(chat, claude_path)
      vim.notify('CLAUDE.md added: ' .. claude_path, vim.log.levels.INFO)
    elseif existing_path == claude_path then
      -- Same CLAUDE.md, unset it
      unset_claude_context(chat)
      vim.notify('CLAUDE.md context removed', vim.log.levels.INFO)
    else
      -- Different CLAUDE.md, replace it
      set_claude_context(chat, claude_path)
      vim.notify('CLAUDE.md replaced: ' .. existing_path .. ' → ' .. claude_path, vim.log.levels.INFO)
    end
  else
    if existing_claude then
      -- No cwd CLAUDE.md but one is set, ask to unset
      local ans = vim.fn.input('No CLAUDE.md in cwd. Unset ' .. existing_path .. '? [y/n]: ')
      if ans:lower() == 'y' then
        unset_claude_context(chat)
        vim.notify('CLAUDE.md context removed', vim.log.levels.INFO)
      else
        vim.notify('CLAUDE.md context unchanged', vim.log.levels.INFO)
      end
    else
      vim.notify('No CLAUDE.md in cwd and no CLAUDE.md context set', vim.log.levels.WARN)
    end
  end
end

return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
      model = 'claude-sonnet-4.6',
    },
    keys = {
      -- Toggle chat
      { '<leader>cc', ':CopilotChatToggle<CR>', desc = 'CopilotChat - Toggle' },

      -- Quick prompts (visual or buffer selection)
      { '<leader>cce', ':CopilotChatExplain<CR>', mode = { 'n', 'v' }, desc = 'CopilotChat - Explain' },
      { '<leader>ccr', ':CopilotChatReview<CR>', mode = { 'n', 'v' }, desc = 'CopilotChat - Review' },
      { '<leader>ccf', ':CopilotChatFix<CR>', mode = { 'n', 'v' }, desc = 'CopilotChat - Fix' },
      { '<leader>cct', ':CopilotChatTests<CR>', mode = { 'n', 'v' }, desc = 'CopilotChat - Tests' },

      -- Models/Agents/Prompts
      { '<leader>ccm', ':CopilotChatModels<CR>', desc = 'CopilotChat - Models' },
      { '<leader>cca', ':CopilotChatAgents<CR>', desc = 'CopilotChat - Agents' },
      { '<leader>ccp', ':CopilotChatPrompts<CR>', desc = 'CopilotChat - Prompts' },

      -- Quick buffer chat
      { '<leader>ccq', copilot_quick_chat, desc = 'CopilotChat - Quick buffer chat' },

      -- Toggle CLAUDE.md context globally (on/off, handles cwd changes)
      { '<leader>ccC', toggle_claude_md, desc = 'CopilotChat - Toggle CLAUDE.md context (cwd)' },
    },
  },
}
