return {
  'lewis6991/gitsigns.nvim',
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Jump to next git [c]hange' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Jump to previous git [c]hange' })

      -- Actions
      map('n', '<Leader>hs', gitsigns.stage_hunk, { desc = 'Git [s]tage hunk' })
      map('v', '<Leader>hs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Stage git hunk' })
      map('n', '<Leader>hr', gitsigns.reset_hunk, { desc = 'Git [r]eset hunk' })
      map('v', '<Leader>hr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Reset git hunk' })
      map('n', '<Leader>hS', gitsigns.stage_buffer, { desc = 'Git [S]tage buffer' })
      map('n', '<Leader>hu', gitsigns.undo_stage_hunk, { desc = 'Git [u]ndo stage hunk' })
      map('n', '<Leader>hR', gitsigns.reset_buffer, { desc = 'Git [R]eset buffer' })
      map('n', '<Leader>hp', gitsigns.preview_hunk, { desc = 'Git [p]review hunk' })
      map('n', '<Leader>hb', gitsigns.blame_line, { desc = 'Git [b]lame line' })
      map('n', '<Leader>hd', gitsigns.diffthis, { desc = 'Git [d]iff against index' })
      map('n', '<Leader>hD', function()
        gitsigns.diffthis '@'
      end, { desc = 'Git [D]iff against last commit' })
      map('n', '<Leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
      map('n', '<Leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
    end
  }
}
